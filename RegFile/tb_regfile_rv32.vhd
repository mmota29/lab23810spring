library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_regfile_rv32 is
end tb_regfile_rv32;

architecture sim of tb_regfile_rv32 is
  component regfile_rv32
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
  end component;

  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal we  : std_logic := '0';
  signal rs1, rs2, rd : std_logic_vector(4 downto 0) := (others => '0');
  signal wdata : std_logic_vector(31 downto 0) := (others => '0');
  signal r1, r2 : std_logic_vector(31 downto 0);

begin
  uut: regfile_rv32 port map(
    i_CLK => clk,
    i_RST => rst,
    i_we  => we,
    i_rs1 => rs1,
    i_rs2 => rs2,
    i_rd  => rd,
    i_wdata => wdata,
    o_rs1_data => r1,
    o_rs2_data => r2
  );

  clk_proc: process
  begin
    wait for 5 ns; clk <= not clk;
  end process;

  stim: process
  begin
    -- reset
    rst <= '1'; wait for 12 ns; rst <= '0'; wait for 8 ns;

    -- write to x1
    rd <= "00001"; wdata <= x"00000001"; we <= '1';
    wait for 10 ns; we <= '0'; -- sample
    -- read back x1
    rs1 <= "00001"; rs2 <= "00010"; -- rs2 still 0
    wait for 10 ns;

    -- write to x2
    rd <= "00010"; wdata <= x"00000002"; we <= '1'; wait for 10 ns; we <= '0';
    wait for 10 ns;

    -- attempt write to x0 (should stay 0)
    rd <= "00000"; wdata <= x"FFFFFFFF"; we <= '1'; wait for 10 ns; we <= '0';
    wait for 10 ns;

    -- write to x31
    rd <= "11111"; wdata <= x"DEAD0001"; we <= '1'; wait for 10 ns; we <= '0';
    wait for 10 ns;

    -- change read addresses and observe
    rs1 <= "11111"; rs2 <= "00001"; wait for 10 ns;
    rs1 <= "00010"; rs2 <= "00000"; wait for 10 ns;

    wait;
  end process;

end sim;
