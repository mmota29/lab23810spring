library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regfile_rv32 is
  port(
    i_CLK : in std_logic;
    i_RST : in std_logic;
    i_we  : in std_logic;
    i_rs1 : in std_logic_vector(4 downto 0);
    i_rs2 : in std_logic_vector(4 downto 0);
    i_rd  : in std_logic_vector(4 downto 0);
    i_wdata : in std_logic_vector(31 downto 0);
    o_rs1_data : out std_logic_vector(31 downto 0);
    o_rs2_data : out std_logic_vector(31 downto 0)
  );
end regfile_rv32;

architecture structural of regfile_rv32 is
  -- reuse the array type from mux file (redeclared here)
  type word32_array_t is array(0 to 31) of std_logic_vector(31 downto 0);

  signal write_one_hot : std_logic_vector(31 downto 0);
  signal regs_out : word32_array_t;

begin
  -- x0 is hardwired to zero
  regs_out(0) <= (others => '0');

  dec: entity work.decoder_5to32
    port map(
      i_EN => i_we,
      i_A  => i_rd,
      o_Y  => write_one_hot
    );

  -- instantiate regs 1..31
  gen_regs: for i in 1 to 31 generate
    r: entity work.reg_N
      generic map(N => 32)
      port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE  => write_one_hot(i),
        i_D   => i_wdata,
        o_Q   => regs_out(i)
      );
  end generate gen_regs;

  -- muxes for read ports
  m1: entity work.mux32to1_32bit
    port map(
      i_D => regs_out,
      i_S => i_rs1,
      o_Y => o_rs1_data
    );

  m2: entity work.mux32to1_32bit
    port map(
      i_D => regs_out,
      i_S => i_rs2,
      o_Y => o_rs2_data
    );

end structural;
