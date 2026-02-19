library IEEE;
use IEEE.std_logic_1164.all;

entity tb_decoder_5to32 is
end tb_decoder_5to32;

architecture sim of tb_decoder_5to32 is
  component decoder_5to32
    port(
      i_EN : in std_logic;
      i_A  : in std_logic_vector(4 downto 0);
      o_Y  : out std_logic_vector(31 downto 0)
    );
  end component;

  signal en : std_logic := '0';
  signal a  : std_logic_vector(4 downto 0) := (others => '0');
  signal y  : std_logic_vector(31 downto 0);
begin
  uut: decoder_5to32
    port map(
      i_EN => en,
      i_A  => a,
      o_Y  => y
    );

  stim: process
  begin
    -- enable off => all zeros
    en <= '0';
    a <= "00000"; wait for 10 ns;
    a <= "11111"; wait for 10 ns;

    -- enable on => one-hot
    en <= '1';
    a <= "00000"; wait for 10 ns; -- expect y(0)=1
    a <= "00001"; wait for 10 ns; -- expect y(1)=1
    a <= "01001"; wait for 10 ns; -- change this to pick a different bit
    a <= "11111"; wait for 10 ns; -- expect y(31)=1

    en <= '0'; wait for 10 ns;
    wait;
  end process;
end sim;
