library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

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
	component regfile_rv32
		port(
			i_CLK : in std_logic;
			i_RST : in std_logic;

			i_WE    : in std_logic;
			i_rs1   : in std_logic_vector(4 downto 0);
			i_rs2   : in std_logic_vector(4 downto 0);
			i_rd    : in std_logic_vector(4 downto 0);
			i_wdata : in std_logic_vector(31 downto 0);

			o_rs1_data : out std_logic_vector(31 downto 0);
			o_rs2_data : out std_logic_vector(31 downto 0)
		);
	end component;

	component ext12to32
		port(
			i_A    : in  std_logic_vector(11 downto 0);
			i_SEXT : in  std_logic;
			o_Y    : out std_logic_vector(31 downto 0)
		);
	end component;

	component mem
		generic(
			DATA_WIDTH : natural := 32;
			ADDR_WIDTH : natural := 10
		);
		port(
			clk  : in std_logic;
			addr : in std_logic_vector((ADDR_WIDTH-1) downto 0);
			data : in std_logic_vector((DATA_WIDTH-1) downto 0);
			we   : in std_logic := '1';
			q    : out std_logic_vector((DATA_WIDTH-1) downto 0)
		);
	end component;

	signal rs1_data : std_logic_vector(31 downto 0);
	signal rs2_data : std_logic_vector(31 downto 0);

	signal imm32    : std_logic_vector(31 downto 0);
	signal alu_b    : std_logic_vector(31 downto 0);
	signal alu_out  : std_logic_vector(31 downto 0);

	signal mem_addr : std_logic_vector(AW-1 downto 0);
	signal mem_q    : std_logic_vector(31 downto 0);

	signal wb_data  : std_logic_vector(31 downto 0);

begin
	rf: regfile_rv32
		port map(
			i_CLK => i_CLK,
			i_RST => i_RST,
			i_WE => i_RegWrite,
			i_rs1 => i_rs1,
			i_rs2 => i_rs2,
			i_rd  => i_rd,
			i_wdata => wb_data,
			o_rs1_data => rs1_data,
			o_rs2_data => rs2_data
		);

	ext: ext12to32
		port map(
			i_A => i_imm12,
			i_SEXT => '1',	-- always sign extend for this lab
			o_Y => imm32
		);

	-- ALUSrc mux
	alu_b <= rs2_data when i_ALUSrc = '0' else imm32;

	-- ALU add/sub
process(rs1_data, alu_b, i_nAddSub)
	variable a_s : signed(31 downto 0);
	variable b_s : signed(31 downto 0);
	variable c_s : signed(31 downto 0);
begin
	a_s := signed(rs1_data);
	b_s := signed(alu_b);

	if i_nAddSub = '1' then
		c_s := a_s - b_s;
	else
		c_s := a_s + b_s;
	end if;

	alu_out <= std_logic_vector(c_s);
end process;

-- byte addr -> word addr (mem.vhd is word-addressed)
mem_addr <= std_logic_vector(resize(unsigned(alu_out) srl 2, AW));

dmem: mem
	generic map(
		DATA_WIDTH => DW,
		ADDR_WIDTH => AW
	)
	port map(
		clk => i_CLK,
		addr => mem_addr,
		data => rs2_data,
		we => i_MemWrite,
		q => mem_q
	);

	-- writeback mux
	wb_data <= alu_out when i_MemToReg = '0' else mem_q;

	-- debug outs
	o_rs1_data <= rs1_data;
	o_rs2_data <= rs2_data;
	o_alu_out  <= alu_out;
	o_mem_addr <= mem_addr;
	o_mem_we   <= i_MemWrite;
	o_mem_q    <= mem_q;

end structural;
