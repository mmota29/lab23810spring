library IEEE;
use IEEE.std_logic_1164.all;

entity tb_ext12to32 is
end tb_ext12to32;

architecture sim of tb_ext12to32 is
  component ext12to32
    port(
      i_A    : in  std_logic_vector(11 downto 0);
      i_SEXT : in  std_logic;
      o_Y    : out std_logic_vector(31 downto 0)
    );
  end component;

  signal a    : std_logic_vector(11 downto 0) := (others => '0');
  signal sext : std_logic := '0';
  signal y    : std_logic_vector(31 downto 0);

begin
  uut: ext12to32
    port map(
      i_A => a,
      i_SEXT => sext,
      o_Y => y
    );

  stim: process
  begin
    -- zero extend tests
    sext <= '0';

    a <= x"001"; wait for 10 ns; -- expect 00000001
    a <= x"7FF"; wait for 10 ns; -- expect 000007FF
    a <= x"800"; wait for 10 ns; -- expect 00000800
    a <= x"FFF"; wait for 10 ns; -- expect 00000FFF

    -- sign extend tests
    sext <= '1';

    a <= x"001"; wait for 10 ns; -- expect 00000001
    a <= x"7FF"; wait for 10 ns; -- expect 000007FF
    a <= x"800"; wait for 10 ns; -- expect FFFFF800
    a <= x"FFF"; wait for 10 ns; -- expect FFFFFFFF

    -- change this if you want a custom test
    a <= x"129"; wait for 10 ns;

    wait;
  end process;

end sim;
