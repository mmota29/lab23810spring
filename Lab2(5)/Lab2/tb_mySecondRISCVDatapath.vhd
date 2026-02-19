library IEEE;
use IEEE.std_logic_1164.all;

entity tb_mySecondRISCVDatapath is
end tb_mySecondRISCVDatapath;

architecture sim of tb_mySecondRISCVDatapath is
	component mySecondRISCVDatapath
		generic(AW : natural := 10; DW : natural := 32);
		port(
			i_CLK : in std_logic;
			i_RST : in std_logic;

			i_RegWrite : in std_logic;
			i_ALUSrc   : in std_logic;
			i_nAddSub  : in std_logic;
			i_MemWrite : in std_logic;
			i_MemToReg : in std_logic;

			i_rs1 : in std_logic_vector(4 downto 0);
			i_rs2 : in std_logic_vector(4 downto 0);
			i_rd  : in std_logic_vector(4 downto 0);

			i_imm12 : in std_logic_vector(11 downto 0);

			o_rs1_data : out std_logic_vector(31 downto 0);
			o_rs2_data : out std_logic_vector(31 downto 0);
			o_alu_out  : out std_logic_vector(31 downto 0);
			o_mem_addr : out std_logic_vector(AW-1 downto 0);
			o_mem_we   : out std_logic;
			o_mem_q    : out std_logic_vector(31 downto 0)
		);
	end component;

	constant AW : natural := 10;

	signal clk : std_logic := '0';
	signal rst : std_logic := '0';

	signal RegWrite : std_logic := '0';
	signal ALUSrc   : std_logic := '0';
	signal nAddSub  : std_logic := '0';
	signal MemWrite : std_logic := '0';
	signal MemToReg : std_logic := '0';

	signal rs1 : std_logic_vector(4 downto 0) := (others => '0');
	signal rs2 : std_logic_vector(4 downto 0) := (others => '0');
	signal rd  : std_logic_vector(4 downto 0) := (others => '0');
	signal imm12 : std_logic_vector(11 downto 0) := (others => '0');

	signal rs1d : std_logic_vector(31 downto 0);
	signal rs2d : std_logic_vector(31 downto 0);
	signal aluo : std_logic_vector(31 downto 0);
	signal madd : std_logic_vector(AW-1 downto 0);
	signal mwe  : std_logic;
	signal mq   : std_logic_vector(31 downto 0);

	procedure step(
		signal clk_s : in std_logic;

		signal rs1_s : out std_logic_vector(4 downto 0);
		signal rs2_s : out std_logic_vector(4 downto 0);
		signal rd_s  : out std_logic_vector(4 downto 0);
		signal imm_s : out std_logic_vector(11 downto 0);

		signal RegWrite_s : out std_logic;
		signal ALUSrc_s   : out std_logic;
		signal nAddSub_s  : out std_logic;
		signal MemWrite_s : out std_logic;
		signal MemToReg_s : out std_logic;

		rs1v : std_logic_vector(4 downto 0);
		rs2v : std_logic_vector(4 downto 0);
		rdv  : std_logic_vector(4 downto 0);
		immv : std_logic_vector(11 downto 0);

		rwv  : std_logic;
		asv  : std_logic;
		subv : std_logic;
		mwv  : std_logic;
		mtrv : std_logic
	) is
	begin
		-- FIX: don't do "wait until clk='0'" because clk starts at 0 and it fires instantly
		wait until falling_edge(clk_s);

		rs1_s <= rs1v;
		rs2_s <= rs2v;
		rd_s  <= rdv;
		imm_s <= immv;

		RegWrite_s <= rwv;
		ALUSrc_s   <= asv;
		nAddSub_s  <= subv;
		MemWrite_s <= mwv;
		MemToReg_s <= mtrv;

		wait until rising_edge(clk_s);
		wait for 1 ns;
	end procedure;

begin
	uut: mySecondRISCVDatapath
		port map(
			i_CLK => clk,
			i_RST => rst,

			i_RegWrite => RegWrite,
			i_ALUSrc => ALUSrc,
			i_nAddSub => nAddSub,
			i_MemWrite => MemWrite,
			i_MemToReg => MemToReg,

			i_rs1 => rs1,
			i_rs2 => rs2,
			i_rd => rd,
			i_imm12 => imm12,

			o_rs1_data => rs1d,
			o_rs2_data => rs2d,
			o_alu_out => aluo,
			o_mem_addr => madd,
			o_mem_we => mwe,
			o_mem_q => mq
		);

	clk_proc: process
	begin
		while true loop
			clk <= '0'; wait for 5 ns;
			clk <= '1'; wait for 5 ns;
		end loop;
	end process;

	stim: process
	begin
		rst <= '1';
		wait for 12 ns;
		rst <= '0';
		wait for 8 ns;

		-- same "program" you already had (not touching it)
		-- if stuff still looks off, it's prob memory not loaded or control bits flipped

		step(clk, rs1, rs2, rd, imm12, RegWrite, ALUSrc, nAddSub, MemWrite, MemToReg,
			"00000","00000","11001", x"000",  '1','1','0','0','0');

		step(clk, rs1, rs2, rd, imm12, RegWrite, ALUSrc, nAddSub, MemWrite, MemToReg,
			"00000","00000","11010", x"100",  '1','1','0','0','0');

		step(clk, rs1, rs2, rd, imm12, RegWrite, ALUSrc, nAddSub, MemWrite, MemToReg,
			"11001","00000","00001", x"000",  '1','1','0','0','1');

		step(clk, rs1, rs2, rd, imm12, RegWrite, ALUSrc, nAddSub, MemWrite, MemToReg,
			"11001","00000","00010", x"004",  '1','1','0','0','1');

		step(clk, rs1, rs2, rd, imm12, RegWrite, ALUSrc, nAddSub, MemWrite, MemToReg,
			"00001","00010","00001", x"000",  '1','0','0','0','0');

		step(clk, rs1, rs2, rd, imm12, RegWrite, ALUSrc, nAddSub, MemWrite, MemToReg,
			"11010","00001","00000", x"000",  '0','1','0','1','0');

		-- ... keep the rest of your steps exactly the same ...
		wait;
	end process;

end sim;