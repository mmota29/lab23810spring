library IEEE;
use IEEE.std_logic_1164.all;

entity ext12to32 is
  port(
    i_A    : in  std_logic_vector(11 downto 0);
    i_SEXT : in  std_logic; -- 1=sign extend, 0=zero extend
    o_Y    : out std_logic_vector(31 downto 0)
  );
end ext12to32;

architecture rtl of ext12to32 is
begin
  process(i_A, i_SEXT)
    variable top : std_logic_vector(19 downto 0);
  begin
    if i_SEXT = '1' then
      top := (others => i_A(11)); -- replicate sign bit
    else
      top := (others => '0');
    end if;

    o_Y <= top & i_A;
  end process;
end rtl;
