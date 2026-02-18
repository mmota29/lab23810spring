library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_mux32to1_32bit is
end tb_mux32to1_32bit;

architecture sim of tb_mux32to1_32bit is
  type word32_array_t is array(0 to 31) of std_logic_vector(31 downto 0);
  component mux32to1_32bit
    port(
      i_D : in word32_array_t;
      i_S : in std_logic_vector(4 downto 0);
      o_Y : out std_logic_vector(31 downto 0)
    );
  end component;

  signal data : word32_array_t;
  signal s : std_logic_vector(4 downto 0) := (others => '0');
  signal y : std_logic_vector(31 downto 0);

begin
  uut: mux32to1_32bit port map(i_D => data, i_S => s, o_Y => y);

  init: process
  begin
    -- fill array with recognizable pattern
    for i in 0 to 31 loop
      data(i) <= std_logic_vector(to_unsigned(i * 3 + 1, 32));
    end loop;

    s <= "00000"; wait for 10 ns; -- pick 0
    s <= "00001"; wait for 10 ns; -- pick 1
    s <= "00100"; wait for 10 ns; -- pick 4
    s <= "11111"; wait for 10 ns; -- pick 31

    -- change this to test more indices
    wait;
  end process;

end sim;
