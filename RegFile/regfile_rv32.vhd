library IEEE;
use IEEE.std_logic_1164.all;

entity regfile_rv32 is
  port(
    i_CLK : in std_logic;
    i_RST : in std_logic;

    i_WE    : in std_logic; -- regWrite
    i_rs1   : in std_logic_vector(4 downto 0);
    i_rs2   : in std_logic_vector(4 downto 0);
    i_rd    : in std_logic_vector(4 downto 0);
    i_wdata : in std_logic_vector(31 downto 0);

    o_rs1_data : out std_logic_vector(31 downto 0);
    o_rs2_data : out std_logic_vector(31 downto 0)
  );
end regfile_rv32;

architecture structural of regfile_rv32 is
  component reg_N
    generic(N : integer := 32);
    port(
      i_CLK : in std_logic;
      i_RST : in std_logic;
      i_WE  : in std_logic;
      i_D   : in std_logic_vector(N-1 downto 0);
      o_Q   : out std_logic_vector(N-1 downto 0)
    );
  end component;

  component decoder_5to32
    port(
      i_EN : in std_logic;
      i_A  : in std_logic_vector(4 downto 0);
      o_Y  : out std_logic_vector(31 downto 0)
    );
  end component;

  component mux32to1_32bit
    port(
      i_D : in std_logic_vector(1023 downto 0);
      i_S : in std_logic_vector(4 downto 0);
      o_Y : out std_logic_vector(31 downto 0)
    );
  end component;

  type reg_array_t is array(0 to 31) of std_logic_vector(31 downto 0);

  signal regs   : reg_array_t;
  signal we_dec : std_logic_vector(31 downto 0);
  signal we_use : std_logic_vector(31 downto 0);

  signal flat_regs : std_logic_vector(1023 downto 0);

begin
  -- decoder: which reg gets written
  dec0: decoder_5to32
    port map(
      i_EN => i_WE,
      i_A  => i_rd,
      o_Y  => we_dec
    );

  -- ignore writes to x0
  process(we_dec)
  begin
    we_use <= we_dec;
    we_use(0) <= '0';
  end process;

  -- x0 is hardwired to 0
  regs(0) <= (others => '0');

  -- regs 1..31 are real storage
  gen_regs: for i in 1 to 31 generate
    r: reg_N
      generic map(N => 32)
      port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE  => we_use(i),
        i_D   => i_wdata,
        o_Q   => regs(i)
      );
  end generate;

  -- pack regs into a flat bus so mux can index it
  gen_pack: for i in 0 to 31 generate
    flat_regs((i*32 + 31) downto (i*32)) <= regs(i);
  end generate;

  -- two read muxes
  mux_rs1: mux32to1_32bit
    port map(
      i_D => flat_regs,
      i_S => i_rs1,
      o_Y => o_rs1_data
    );

  mux_rs2: mux32to1_32bit
    port map(
      i_D => flat_regs,
      i_S => i_rs2,
      o_Y => o_rs2_data
    );

end structural;
