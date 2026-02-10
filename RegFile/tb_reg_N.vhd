library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_reg_N is
end tb_reg_N;

architecture sim of tb_reg_N is
  component reg_N
    generic (N : integer := 32);
    port(
      i_CLK : in std_logic;
      i_RST : in std_logic;
      i_WE  : in std_logic;
      i_D   : in std_logic_vector(N-1 downto 0);
      o_Q   : out std_logic_vector(N-1 downto 0)
    );
  end component;

  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal we  : std_logic := '0';
  signal d   : std_logic_vector(31 downto 0) := (others => '0');
  signal q   : std_logic_vector(31 downto 0);

begin
  uut: reg_N
    port map(
      i_CLK => clk,
      i_RST => rst,
      i_WE  => we,
      i_D   => d,
      o_Q   => q
    );

  -- clock gen
  clk_proc: process
  begin
    wait for 5 ns; clk <= not clk;
  end process;

  stim: process
  begin
    -- reset
    rst <= '1';
    wait for 12 ns;
    rst <= '0';
    wait for 8 ns;

    -- write some value to reg when we=1
    -- change this to change which value we write
    we <= '1';
    d <= x"DEADBEEF";
    wait for 10 ns; -- sample on rising edge

    -- hold behavior when we=0
    we <= '0';
    d <= x"01234567"; -- should not update
    wait for 20 ns;

    -- test write again
    we <= '1';
    d <= x"AAAAAAAA";
    wait for 10 ns;

    wait for 50 ns;
    wait;
  end process;

end sim;
