library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_dmem is
end tb_dmem;

architecture sim of tb_dmem is
	constant DW : natural := 32;
	constant AW : natural := 10; -- 2^10 = 1024 words

	signal clk	: std_logic := '0';
	signal addr	: std_logic_vector(AW-1 downto 0) := (others => '0');
	signal data	: std_logic_vector(DW-1 downto 0) := (others => '0');
	signal we	: std_logic := '0'; -- IMPORTANT: default in mem.vhd is '1' (wtf) so we drive this
	signal q	: std_logic_vector(DW-1 downto 0);

	type word10_t is array(0 to 9) of std_logic_vector(31 downto 0);
begin
	-- memory instance MUST be labeled dmem so the tcl path works:
	-- mem load -infile dmem.hex -format hex /tb_dmem/dmem/ram
	dmem: entity work.mem
		generic map(
			DATA_WIDTH => DW,
			ADDR_WIDTH => AW
		)
		port map(
			clk => clk,
			addr => addr,
			data => data,
			we => we,
			q => q
		);

	clk_proc: process
	begin
		while true loop
			clk <= '0'; wait for 5 ns;
			clk <= '1'; wait for 5 ns;
		end loop;
	end process;

	stim: process
		variable vals : word10_t;
		variable base : integer := 16#100#; -- word address 0x100 (NOT byte address)
	begin
		-- tiny pause so you can do mem load before run, or just so waveforms aren't ugly
		we <= '0';
		wait for 1 ns;

		-- (b) read first 10 words from 0x0..0x9
		for i in 0 to 9 loop
			wait until clk = '0';
			we <= '0';
			addr <= std_logic_vector(to_unsigned(i, AW));
			wait for 1 ns; -- q is async, this is just spacing
			vals(i) := q;
		end loop;

		-- (c) write those 10 words to 0x100..0x109
		for i in 0 to 9 loop
			wait until clk = '0';
			addr <= std_logic_vector(to_unsigned(base + i, AW));
			data <= vals(i);
			we <= '1';
			wait until clk = '1'; -- write happens here
			wait for 1 ns;
			we <= '0';
		end loop;

		-- (d) read back and sanity check
		for i in 0 to 9 loop
			wait until clk = '0';
			we <= '0';
			addr <= std_logic_vector(to_unsigned(base + i, AW));
			wait for 1 ns;

			assert q = vals(i)
			report "memory mismatch at addr 0x" & integer'image(base + i)
			severity error;
		end loop;

		wait;
	end process;

end sim;