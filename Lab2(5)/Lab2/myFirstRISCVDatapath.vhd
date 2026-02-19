library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity myFirstRISCVDatapath is
  port(
    i_CLK : in std_logic;
    i_RST : in std_logic;

    -- control
    i_regWrite : in std_logic;
    i_ALUSrc   : in std_logic;
    i_nAddSub  : in std_logic;

    -- "instruction fields"
    i_rs1  : in std_logic_vector(4 downto 0);
    i_rs2  : in std_logic_vector(4 downto 0);
    i_rd   : in std_logic_vector(4 downto 0);
    i_imm  : in std_logic_vector(31 downto 0); -- already sign-extended for now

    -- debug outputs (makes waveforms way easier)
    o_rs1_data : out std_logic_vector(31 downto 0);
    o_rs2_data : out std_logic_vector(31 downto 0);
    o_alu_out  : out std_logic_vector(31 downto 0)
  );
end myFirstRISCVDatapath;

architecture structural of myFirstRISCVDatapath is
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

  signal rs1_data : std_logic_vector(31 downto 0);
  signal rs2_data : std_logic_vector(31 downto 0);

  signal alu_b    : std_logic_vector(31 downto 0);
  signal alu_out  : std_logic_vector(31 downto 0);

begin
  -- register file
  rf0: regfile_rv32
    port map(
      i_CLK => i_CLK,
      i_RST => i_RST,

      i_WE => i_regWrite,
      i_rs1 => i_rs1,
      i_rs2 => i_rs2,
      i_rd  => i_rd,
      i_wdata => alu_out,

      o_rs1_data => rs1_data,
      o_rs2_data => rs2_data
    );

  -- ALUSrc mux on B input (this is the whole part-a thing)
  alu_b <= rs2_data when i_ALUSrc = '0' else i_imm;

  -- add/sub core (using signed so negatives work)
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

  -- debug outs
  o_rs1_data <= rs1_data;
  o_rs2_data <= rs2_data;
  o_alu_out  <= alu_out;

end structural;
