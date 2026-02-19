library IEEE;
use IEEE.std_logic_1164.all;

entity tb_myFirstRISCVDatapath is
end tb_myFirstRISCVDatapath;

architecture sim of tb_myFirstRISCVDatapath is
  component myFirstRISCVDatapath
    port(
      i_CLK : in std_logic;
      i_RST : in std_logic;

      i_regWrite : in std_logic;
      i_ALUSrc   : in std_logic;
      i_nAddSub  : in std_logic;

      i_rs1  : in std_logic_vector(4 downto 0);
      i_rs2  : in std_logic_vector(4 downto 0);
      i_rd   : in std_logic_vector(4 downto 0);
      i_imm  : in std_logic_vector(31 downto 0);

      o_rs1_data : out std_logic_vector(31 downto 0);
      o_rs2_data : out std_logic_vector(31 downto 0);
      o_alu_out  : out std_logic_vector(31 downto 0)
    );
  end component;

  signal clk : std_logic := '0';
  signal rst : std_logic := '0';

  signal regWrite : std_logic := '0';
  signal ALUSrc   : std_logic := '0';
  signal nAddSub  : std_logic := '0';

  signal rs1  : std_logic_vector(4 downto 0) := (others => '0');
  signal rs2  : std_logic_vector(4 downto 0) := (others => '0');
  signal rd   : std_logic_vector(4 downto 0) := (others => '0');
  signal imm  : std_logic_vector(31 downto 0) := (others => '0');

  signal rs1_data : std_logic_vector(31 downto 0);
  signal rs2_data : std_logic_vector(31 downto 0);
  signal alu_out  : std_logic_vector(31 downto 0);

  -- Questa wants signal params if a procedure drives signals (vhdl-93 stuff)
  procedure step_inst(
    signal clk_s : in std_logic;

    signal rs1_s : out std_logic_vector(4 downto 0);
    signal rs2_s : out std_logic_vector(4 downto 0);
    signal rd_s  : out std_logic_vector(4 downto 0);
    signal imm_s : out std_logic_vector(31 downto 0);

    signal we_s  : out std_logic;
    signal alus_s: out std_logic;
    signal sub_s : out std_logic;

    rs1v : std_logic_vector(4 downto 0);
    rs2v : std_logic_vector(4 downto 0);
    rdv  : std_logic_vector(4 downto 0);
    immv : std_logic_vector(31 downto 0);
    wev  : std_logic;
    alusv: std_logic;
    subv : std_logic
  ) is
  begin
    -- change inputs on non-active edge so waveform is clean
    wait until clk_s = '0';

    rs1_s <= rs1v;
    rs2_s <= rs2v;
    rd_s  <= rdv;
    imm_s <= immv;

    we_s   <= wev;
    alus_s <= alusv;
    sub_s  <= subv;

    wait until clk_s = '1'; -- "instruction executes" here
    wait for 1 ns;
  end procedure;

begin
  uut: myFirstRISCVDatapath
    port map(
      i_CLK => clk,
      i_RST => rst,
      i_regWrite => regWrite,
      i_ALUSrc => ALUSrc,
      i_nAddSub => nAddSub,
      i_rs1 => rs1,
      i_rs2 => rs2,
      i_rd => rd,
      i_imm => imm,
      o_rs1_data => rs1_data,
      o_rs2_data => rs2_data,
      o_alu_out => alu_out
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
    -- reset (flip polarity if your dffg is active-low)
    rst <= '1';
    regWrite <= '0';
    ALUSrc <= '0';
    nAddSub <= '0';
    rs1 <= "00000";
    rs2 <= "00000";
    rd  <= "00000";
    imm <= (others => '0');
    wait for 12 ns;
    rst <= '0';
    wait for 8 ns;

    -- addi x1, zero, 1
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "00000","00001","00001",x"00000001",'1','1','0');

    -- addi x2..x10, zero, 2..10
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "00000","00001","00010",x"00000002",'1','1','0');
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "00000","00001","00011",x"00000003",'1','1','0');
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "00000","00001","00100",x"00000004",'1','1','0');
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "00000","00001","00101",x"00000005",'1','1','0');
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "00000","00001","00110",x"00000006",'1','1','0');
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "00000","00001","00111",x"00000007",'1','1','0');
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "00000","00001","01000",x"00000008",'1','1','0');
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "00000","00001","01001",x"00000009",'1','1','0');
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "00000","00001","01010",x"0000000A",'1','1','0');

    -- add x11, x1, x2
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "00001","00010","01011",x"00000000",'1','0','0');

    -- sub x12, x11, x3
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "01011","00011","01100",x"00000000",'1','0','1');

    -- add x13, x12, x4
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "01100","00100","01101",x"00000000",'1','0','0');

    -- sub x14, x13, x5
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "01101","00101","01110",x"00000000",'1','0','1');

    -- add x15, x14, x6
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "01110","00110","01111",x"00000000",'1','0','0');

    -- sub x16, x15, x7
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "01111","00111","10000",x"00000000",'1','0','1');

    -- add x17, x16, x8
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "10000","01000","10001",x"00000000",'1','0','0');

    -- sub x18, x17, x9
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "10001","01001","10010",x"00000000",'1','0','1');

    -- add x19, x18, x10
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "10010","01010","10011",x"00000000",'1','0','0');

    -- addi x20, zero, -35  (two's complement: FFFFFFDD)
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "00000","00001","10100",x"FFFFFFDD",'1','1','0');

    -- add x21, x19, x20
    step_inst(clk, rs1, rs2, rd, imm, regWrite, ALUSrc, nAddSub,
      "10011","10100","10101",x"00000000",'1','0','0');

    regWrite <= '0';
    wait;
  end process;

end sim;