-------------------------------------------------------------------------
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_OnesComp_N.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for OnesComp_N.
--              Tests N=32 configuration in QuestaSim.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_OnesComp_N is
end tb_OnesComp_N;

architecture tb of tb_OnesComp_N is

  constant cN : integer := 32;

  component OnesComp_N is
    generic(N : integer := 32);
    port(
      i_A : in  std_logic_vector(N-1 downto 0);
      o_O : out std_logic_vector(N-1 downto 0)
    );
  end component;

  signal s_A : std_logic_vector(cN-1 downto 0) := (others => '0');
  signal s_O : std_logic_vector(cN-1 downto 0);

begin

  DUT0: OnesComp_N
    generic map (N => cN)
    port map(
      i_A => s_A,
      o_O => s_O
    );

  P_TEST: process
  begin
    -- Test 1: all zeros -> all ones
    s_A <= x"00000000";
    wait for 10 ns;
    assert (s_O = x"FFFFFFFF")
      report "FAIL: 00000000 -> expected FFFFFFFF" severity error;

    -- Test 2: all ones -> all zeros
    s_A <= x"FFFFFFFF";
    wait for 10 ns;
    assert (s_O = x"00000000")
      report "FAIL: FFFFFFFF -> expected 00000000" severity error;

    -- Test 3: alternating pattern
    s_A <= x"AAAAAAAA";
    wait for 10 ns;
    assert (s_O = x"55555555")
      report "FAIL: AAAAAAAA -> expected 55555555" severity error;

    -- Test 4: other alternating pattern
    s_A <= x"55555555";
    wait for 10 ns;
    assert (s_O = x"AAAAAAAA")
      report "FAIL: 55555555 -> expected AAAAAAAA" severity error;

    -- Test 5: random-ish value
    s_A <= x"1234ABCD";
    wait for 10 ns;
    assert (s_O = x"EDCB5432")
      report "FAIL: 1234ABCD -> expected EDCB5432" severity error;

    -- Test 6: single-bit check (MSB set)
    s_A <= x"80000000";
    wait for 10 ns;
    assert (s_O = x"7FFFFFFF")
      report "FAIL: 80000000 -> expected 7FFFFFFF" severity error;

    wait;
  end process;

end tb;
