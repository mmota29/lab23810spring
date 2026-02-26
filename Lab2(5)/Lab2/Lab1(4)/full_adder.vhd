-- full_adder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 1-bit Full Adder implemented using structural VHDL.
--              Uses provided gate designs:
--              - xorg2 (XOR)
--              - andg2 (AND)
--              - invg  (NOT)
--
-- Sum:
--   oS = iA xor iB xor iCin
--
-- Carry:
--   oCout = (iA and iB) or (iCin and (iA xor iB))
--   OR implemented via De Morgan:
--     A or B = not( not A and not B )
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder is
  port(
    iA    : in  std_logic;
    iB    : in  std_logic;
    iCin  : in  std_logic;
    oS    : out std_logic;
    oCout : out std_logic
  );
end full_adder;

architecture structural of full_adder is

  component xorg2 is
    port(
      i_A : in  std_logic;
      i_B : in  std_logic;
      o_F : out std_logic
    );
  end component;

  component andg2 is
    port(
      i_A : in  std_logic;
      i_B : in  std_logic;
      o_F : out std_logic
    );
  end component;

  component invg is
    port(
      i_A : in  std_logic;
      o_F : out std_logic
    );
  end component;

  -- Internal signals
  signal s_xorAB    : std_logic;
  signal s_andAB   : std_logic;
  signal s_andCin  : std_logic;
  signal s_nAndAB  : std_logic;
  signal s_nAndCin : std_logic;
  signal s_andN    : std_logic;

begin

  -----------------------------------------------------------------------
  -- Sum logic: oS = iA xor iB xor iCin
  -----------------------------------------------------------------------
  XOR1: xorg2
    port map(
      i_A => iA,
      i_B => iB,
      o_F => s_xorAB
    );

  XOR2: xorg2
    port map(
      i_A => s_xorAB,
      i_B => iCin,
      o_F => oS
    );

  -----------------------------------------------------------------------
  -- Carry logic
  -- oCout = (iA and iB) or (iCin and (iA xor iB))
  -- OR implemented using De Morgan
  -----------------------------------------------------------------------
  AND1: andg2
    port map(
      i_A => iA,
      i_B => iB,
      o_F => s_andAB
    );

  AND2: andg2
    port map(
      i_A => iCin,
      i_B => s_xorAB,
      o_F => s_andCin
    );

  -- De Morgan OR
  INV1: invg
    port map(
      i_A => s_andAB,
      o_F => s_nAndAB
    );

  INV2: invg
    port map(
      i_A => s_andCin,
      o_F => s_nAndCin
    );

  AND3: andg2
    port map(
      i_A => s_nAndAB,
      i_B => s_nAndCin,
      o_F => s_andN
    );

  INV3: invg
    port map(
      i_A => s_andN,
      o_F => oCout
    );

end structural;
