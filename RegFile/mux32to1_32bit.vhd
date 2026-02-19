library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mux32to1_32bit is
  port(
    i_D : in std_logic_vector(1023 downto 0);
    i_S : in std_logic_vector(4 downto 0);
    o_Y : out std_logic_vector(31 downto 0)
  );
end mux32to1_32bit;

architecture rtl of mux32to1_32bit is
begin
  process(i_D, i_S)
    variable idx : integer;
  begin
    idx := to_integer(unsigned(i_S));

    if idx >= 0 and idx <= 31 then
      o_Y <= i_D((idx*32 + 31) downto (idx*32));
    else
      o_Y <= (others => '0');
    end if;
  end process;
end rtl;
