library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_32bit is
	port(
		i_S  : in  std_logic;
		i_D0 : in  std_logic_vector(31 downto 0);
		i_D1 : in  std_logic_vector(31 downto 0);
		o_O  : out std_logic_vector(31 downto 0)
	);
end mux2t1_32bit;

architecture dataflow of mux2t1_32bit is
begin
	o_O <= i_D0 when i_S = '0' else i_D1;
end dataflow;