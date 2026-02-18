library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- yeah questa can be picky about types inside entity depending on vhdl version
-- so i'm just putting it here in the same file
package mux_pkg is
	type word32_array_t is array(0 to 31) of std_logic_vector(31 downto 0);
end package;

package body mux_pkg is
end package body;

use work.mux_pkg.all;

entity mux32to1_32bit is
	port(
		i_D : in word32_array_t;
		i_S : in std_logic_vector(4 downto 0);
		o_Y : out std_logic_vector(31 downto 0)
	);
end mux32to1_32bit;

architecture rtl of mux32to1_32bit is
begin
	process(i_D, i_S)
		variable idx : integer;
	begin
		-- if select is clean 0/1 this is fine
		idx := to_integer(unsigned(i_S));
		o_Y <= i_D(idx);
	end process;
end rtl;
