-------------------------------------------------------------------------
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- OnesComp_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: N-bit One's Complementor (bitwise NOT).
--              Structural VHDL using invg.vhd as the basic building block.
--
-- NOTES:
--   One's complement: o_O(i) = not i_A(i) for each bit i.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity OnesComp_N is
  generic(N : integer := 32);
  port(
    i_A : in  std_logic_vector(N-1 downto 0);
    o_O : out std_logic_vector(N-1 downto 0)
  );
end OnesComp_N;

architecture structural of OnesComp_N is

  component invg is
    port(
      i_A : in  std_logic;
      o_F : out std_logic
    );
  end component;

begin

  -- Instantiate N NOT gates.
  G_INV: for i in 0 to N-1 generate
    INV_I: invg
      port map(
        i_A => i_A(i),
        o_F => o_O(i)
      );
  end generate G_INV;

end structural;
