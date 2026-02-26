-- DESCRIPTION: Testbench for mux2t1_N (generic N-bit 2:1 mux).
-- Tests that:
--   - when i_S='0' -> o_O = i_D0
--   - when i_S='1' -> o_O = i_D1
-- Also confirms generic width by instantiating with a chosen N.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mux2t1_N is
end tb_mux2t1_N;

architecture tb of tb_mux2t1_N is

  -- Change this to test different widths (8, 16, 32, etc.)
  constant cN : integer := 8;

  component mux2t1_N is
    generic(N : integer := 16);
    port(
      i_S  : in  std_logic;
      i_D0 : in  std_logic_vector(N-1 downto 0);
      i_D1 : in  std_logic_vector(N-1 downto 0);
      o_O  : out std_logic_vector(N-1 downto 0)
    );
  end component;

  signal s_S  : std_logic := '0';
  signal s_D0 : std_logic_vector(cN-1 downto 0) := (others => '0');
  signal s_D1 : std_logic_vector(cN-1 downto 0) := (others => '0');
  signal s_O  : std_logic_vector(cN-1 downto 0);

begin

  DUT0: mux2t1_N
    generic map (N => cN)
    port map(
      i_S  => s_S,
      i_D0 => s_D0,
      i_D1 => s_D1,
      o_O  => s_O
    );

  P_TEST: process
  begin
    -----------------------------------------------------------------------
    -- Test 1: i_S = 0 -> output should follow D0
    -----------------------------------------------------------------------
    s_S  <= '0';
    s_D0 <= "10101010";   -- for cN=8
    s_D1 <= "01010101";
    wait for 10 ns;
    assert (s_O = s_D0)
      report "FAIL: i_S=0 but o_O != i_D0" severity error;

    -----------------------------------------------------------------------
    -- Test 2: i_S = 1 -> output should follow D1
    -----------------------------------------------------------------------
    s_S <= '1';
    wait for 10 ns;
    assert (s_O = s_D1)
      report "FAIL: i_S=1 but o_O != i_D1" severity error;

    -----------------------------------------------------------------------
    -- Test 3: change inputs while i_S=1 (output should track D1)
    -----------------------------------------------------------------------
    s_D0 <= "11110000";
    s_D1 <= "00001111";
    wait for 10 ns;
    assert (s_O = s_D1)
      report "FAIL: i_S=1 but o_O did not track i_D1 after input change" severity error;

    -----------------------------------------------------------------------
    -- Test 4: switch back to i_S=0 (output should track D0)
    -----------------------------------------------------------------------
    s_S <= '0';
    wait for 10 ns;
    assert (s_O = s_D0)
      report "FAIL: i_S=0 but o_O did not track i_D0 after switching select" severity error;

    wait;
  end process;

end tb;
