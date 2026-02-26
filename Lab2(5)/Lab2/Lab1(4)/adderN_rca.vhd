-------------------------------------------------------------------------
-- adderN_rca.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: N-bit ripple-carry adder built from 1-bit full adders.
--              Structural VHDL with generate statement.
--              Adds iA + iB + iCin -> oS (N bits) and oCout (1 bit)
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity adderN_rca is
  generic(N : integer := 32);
  port(
    iA    : in  std_logic_vector(N-1 downto 0);
    iB    : in  std_logic_vector(N-1 downto 0);
    iCin  : in  std_logic;
    oS    : out std_logic_vector(N-1 downto 0);
    oCout : out std_logic
  );
end adderN_rca;

architecture structural of adderN_rca is

  component full_adder is
    port(
      iA    : in  std_logic;
      iB    : in  std_logic;
      iCin  : in  std_logic;
      oS    : out std_logic;
      oCout : out std_logic
    );
  end component;

  signal s_C : std_logic_vector(N downto 0);

begin

  -- Carry chain
  s_C(0) <= iCin;
  oCout  <= s_C(N);

  -- N full adders
  G_FA: for i in 0 to N-1 generate
    FA_i: full_adder
      port map(
        iA    => iA(i),
        iB    => iB(i),
        iCin  => s_C(i),
        oS    => oS(i),
        oCout => s_C(i+1)
      );
  end generate G_FA;

end structural;

