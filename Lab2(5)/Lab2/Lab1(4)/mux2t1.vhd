-------------------------------------------------------------------------
-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Structural 2:1 mux using provided gates invg, andg2 only.
--   oO = (not iS and iD0) or (iS and iD1)
-- OR is implemented using De Morgan:
--   A or B = not( (not A) and (not B) )
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1 is
  port(
    i_S  : in  std_logic;
    i_D0 : in  std_logic;
    i_D1 : in  std_logic;
    o_O  : out std_logic
  );
end mux2t1;

architecture structural of mux2t1 is

  component invg is
    port(
      i_A : in  std_logic;
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

  signal s_nS    : std_logic;
  signal s_and0  : std_logic;
  signal s_and1  : std_logic;

  -- For De Morgan OR
  signal s_nAnd0 : std_logic;
  signal s_nAnd1 : std_logic;
  signal s_andN  : std_logic;

begin

  -- s_nS = not i_S
  U_INV_S: invg
    port map(
      i_A => i_S,
      o_F => s_nS
    );

  -- s_and0 = (not i_S) and i_D0
  U_AND0: andg2
    port map(
      i_A => s_nS,
      i_B => i_D0,
      o_F => s_and0
    );

  -- s_and1 = i_S and i_D1
  U_AND1: andg2
    port map(
      i_A => i_S,
      i_B => i_D1,
      o_F => s_and1
    );

  -- OR via De Morgan:
  -- o_O = s_and0 OR s_and1 = not( (not s_and0) and (not s_and1) )

  U_INV_A: invg
    port map(
      i_A => s_and0,
      o_F => s_nAnd0
    );

  U_INV_B: invg
    port map(
      i_A => s_and1,
      o_F => s_nAnd1
    );

  U_AND_N: andg2
    port map(
      i_A => s_nAnd0,
      i_B => s_nAnd1,
      o_F => s_andN
    );

  U_INV_OUT: invg
    port map(
      i_A => s_andN,
      o_F => o_O
    );

end structural;

