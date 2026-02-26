-------------------------------------------------------------------------
-- adder_sub_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: N-bit adder/subtractor with control (structural VHDL).
-- Uses only:
--   - OnesComp_N  (N-bit inverter)
--   - mux2t1_N    (N-bit 2:1 mux)
--   - adderN_rca  (N-bit ripple-carry adder)
--
-- Control:
--   nAdd_Sub = 0 => Add:       oS = iA + iB
--   nAdd_Sub = 1 => Subtract:  oS = iA + (~iB) + 1 = iA - iB
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity adder_sub_N is
  generic(N : integer := 32);
  port(
    iA       : in  std_logic_vector(N-1 downto 0);
    iB       : in  std_logic_vector(N-1 downto 0);
    nAdd_Sub : in  std_logic;
    oS       : out std_logic_vector(N-1 downto 0);
    oCout    : out std_logic
  );
end adder_sub_N;

architecture structural of adder_sub_N is

  component OnesComp_N is
    generic(N : integer := 32);
    port(
      i_A : in  std_logic_vector(N-1 downto 0);
      o_O : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component mux2t1_N is
    generic(N : integer := 16);
    port(
      i_S  : in  std_logic;
      i_D0 : in  std_logic_vector(N-1 downto 0);
      i_D1 : in  std_logic_vector(N-1 downto 0);
      o_O  : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component adderN_rca is
    generic(N : integer := 32);
    port(
      iA    : in  std_logic_vector(N-1 downto 0);
      iB    : in  std_logic_vector(N-1 downto 0);
      iCin  : in  std_logic;
      oS    : out std_logic_vector(N-1 downto 0);
      oCout : out std_logic
    );
  end component;

  signal s_Binv : std_logic_vector(N-1 downto 0);
  signal s_Bsel : std_logic_vector(N-1 downto 0);

begin

  -- Invert B (one's complement)
  U_INV: OnesComp_N
    generic map (N => N)
    port map(
      i_A => iB,
      o_O => s_Binv
    );

  -- Select B or ~B depending on nAdd_Sub
  -- nAdd_Sub=0 -> choose iB
  -- nAdd_Sub=1 -> choose ~iB
  U_MUX: mux2t1_N
    generic map (N => N)
    port map(
      i_S  => nAdd_Sub,
      i_D0 => iB,
      i_D1 => s_Binv,
      o_O  => s_Bsel
    );

  -- Add A + selected-B + carry-in (carry-in is nAdd_Sub)
  U_ADD: adderN_rca
    generic map (N => N)
    port map(
      iA    => iA,
      iB    => s_Bsel,
      iCin  => nAdd_Sub,
      oS    => oS,
      oCout => oCout
    );

end structural;
