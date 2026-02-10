library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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
  uut: decoder_5to32 port map(i_EN => en, i_A => a, o_Y => y);

  stim: process
  begin
    en <= '0'; a <= "00000"; wait for 10 ns;
    en <= '1'; a <= "00000"; wait for 10 ns; -- address 0
    a <= "00001"; wait for 10 ns; -- address 1
    a <= "00010"; wait for 10 ns; -- address 2
    a <= "11111"; wait for 10 ns; -- address 31

    -- change this to check other addresses
    wait;
  end process;

end sim;
