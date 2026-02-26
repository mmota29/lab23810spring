library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu32_addsub is
	port(
		i_A       : in  std_logic_vector(31 downto 0);
		i_B       : in  std_logic_vector(31 downto 0);
		i_nAddSub : in  std_logic;
		o_S       : out std_logic_vector(31 downto 0)
	);
end alu32_addsub;

architecture behavioral of alu32_addsub is
begin
	process(i_A, i_B, i_nAddSub)
	begin
		if i_nAddSub = '1' then
			o_S <= std_logic_vector(signed(i_A) - signed(i_B));
		else
			o_S <= std_logic_vector(signed(i_A) + signed(i_B));
		end if;
	end process;
end behavioral;