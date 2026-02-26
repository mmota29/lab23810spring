-------------------------------------------------------------------------
-- tb_mux2t1_df.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for mux2t1_df. Exhaustively tests all 8 cases.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mux2t1_df is
end tb_mux2t1_df;

architecture tb of tb_mux2t1_df is

  component mux2t1_df is
    port(
      i_S  : in  std_logic;
      i_D0 : in  std_logic;
      i_D1 : in  std_logic;
      o_O  : out std_logic
    );
  end component;

  signal s_iS  : std_logic := '0';
  signal s_iD0 : std_logic := '0';
  signal s_iD1 : std_logic := '0';
  signal s_oO  : std_logic;

begin

  DUT0: mux2t1_df
    port map(
      i_S  => s_iS,
      i_D0 => s_iD0,
      i_D1 => s_iD1,
      o_O  => s_oO
    );

  P_TEST: process
  begin
    -- iS iD0 iD1 -> expected oO
    s_iS <= '0'; s_iD0 <= '0'; s_iD1 <= '0'; wait for 10 ns; -- 0
    s_iS <= '0'; s_iD0 <= '0'; s_iD1 <= '1'; wait for 10 ns; -- 0
    s_iS <= '0'; s_iD0 <= '1'; s_iD1 <= '0'; wait for 10 ns; -- 1
    s_iS <= '0'; s_iD0 <= '1'; s_iD1 <= '1'; wait for 10 ns; -- 1
    s_iS <= '1'; s_iD0 <= '0'; s_iD1 <= '0'; wait for 10 ns; -- 0
    s_iS <= '1'; s_iD0 <= '0'; s_iD1 <= '1'; wait for 10 ns; -- 1
    s_iS <= '1'; s_iD0 <= '1'; s_iD1 <= '0'; wait for 10 ns; -- 0
    s_iS <= '1'; s_iD0 <= '1'; s_iD1 <= '1'; wait for 10 ns; -- 1

    wait;
  end process;

end tb;
