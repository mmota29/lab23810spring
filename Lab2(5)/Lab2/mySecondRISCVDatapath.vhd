library IEEE;
use IEEE.std_logic_1164.all;

entity mySecondRISCVDatapath is
	generic(
		AW : natural := 10;
		DW : natural := 32
	);
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
end mySecondRISCVDatapath;

architecture structural of mySecondRISCVDatapath is
	signal rs1_data : std_logic_vector(31 downto 0);
	signal rs2_data : std_logic_vector(31 downto 0);

	signal imm32    : std_logic_vector(31 downto 0);
	signal alu_b    : std_logic_vector(31 downto 0);
	signal alu_out  : std_logic_vector(31 downto 0);

	signal mem_addr : std_logic_vector(AW-1 downto 0);
	signal mem_q    : std_logic_vector(31 downto 0);

	signal wb_data  : std_logic_vector(31 downto 0);

begin
	-- register file
	rf: entity work.regfile_rv32
		port map(
			i_CLK      => i_CLK,
			i_RST      => i_RST,
			i_WE       => i_RegWrite,
			i_rs1      => i_rs1,
			i_rs2      => i_rs2,
			i_rd       => i_rd,
			i_wdata    => wb_data,
			o_rs1_data => rs1_data,
			o_rs2_data => rs2_data
		);

	-- 12-bit sign extender
	ext: entity work.ext12to32
		port map(
			i_A    => i_imm12,
			i_SEXT => '1',
			o_Y    => imm32
		);

	-- ALUSrc mux: rs2 vs immediate
	alu_src_mux: entity work.mux2t1_32bit
		port map(
			i_S  => i_ALUSrc,
			i_D0 => rs2_data,
			i_D1 => imm32,
			o_O  => alu_b
		);

	-- ALU add/sub
	alu0: entity work.alu32_addsub
		port map(
			i_A       => rs1_data,
			i_B       => alu_b,
			i_nAddSub => i_nAddSub,
			o_S       => alu_out
		);

	-- memory is word-addressed, ALU output is byte address
	mem_addr <= alu_out(AW+1 downto 2);

	-- data memory
	dmem: entity work.mem
		generic map(
			DATA_WIDTH => DW,
			ADDR_WIDTH => AW
		)
		port map(
			clk  => i_CLK,
			addr => mem_addr,
			data => rs2_data,
			we   => i_MemWrite,
			q    => mem_q
		);

	-- writeback mux: ALU result vs memory data
	wb_mux: entity work.mux2t1_32bit
		port map(
			i_S  => i_MemToReg,
			i_D0 => alu_out,
			i_D1 => mem_q,
			o_O  => wb_data
		);

	-- debug outputs
	o_rs1_data <= rs1_data;
	o_rs2_data <= rs2_data;
	o_alu_out  <= alu_out;
	o_mem_addr <= mem_addr;
	o_mem_we   <= i_MemWrite;
	o_mem_q    <= mem_q;

end structural;
