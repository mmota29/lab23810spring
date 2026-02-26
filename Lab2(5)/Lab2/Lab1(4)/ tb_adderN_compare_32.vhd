-------------------------------------------------------------------------
-- tb_adderN_compare_32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Testbench for N-bit adder.
--              Compares structural ripple-carry adder (adderN_rca)
--              against reference dataflow adder (adderN_df) for N=32.
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity tb_adderN_compare_32 is
end tb_adderN_compare_32;

architecture tb of tb_adderN_compare_32 is

  constant N : integer := 32;

  component adderN_rca is
    generic(N : integer := 32);
    port(
      iA    : in  std_logic_vector(N-1 downto 0);
      iB    : in  std_logic_vector(N-1 downto 0);
      iCin  : in  std_logic;
      oS    : out std_logic_vector(N-1 downto 0);
      oCout : out std_logic
    );
  end component;

  component adderN_df is
    generic(N : integer := 32);
    port(
      iA    : in  std_logic_vector(N-1 downto 0);
      iB    : in  std_logic_vector(N-1 downto 0);
      iCin  : in  std_logic;
      oS    : out std_logic_vector(N-1 downto 0);
      oCout : out std_logic
    );
  end component;

  signal s_A    : std_logic_vector(N-1 downto 0) := (others => '0');
  signal s_B    : std_logic_vector(N-1 downto 0) := (others => '0');
  signal s_Cin  : std_logic := '0';

  signal s_S_rca   : std_logic_vector(N-1 downto 0);
  signal s_Cout_rca: std_logic;

  signal s_S_df    : std_logic_vector(N-1 downto 0);
  signal s_Cout_df : std_logic;

begin

  DUT_RCA: adderN_rca
    generic map (N => N)
    port map(
      iA    => s_A,
      iB    => s_B,
      iCin  => s_Cin,
      oS    => s_S_rca,
      oCout => s_Cout_rca
    );

  DUT_DF: adderN_df
    generic map (N => N)
    port map(
      iA    => s_A,
      iB    => s_B,
      iCin  => s_Cin,
      oS    => s_S_df,
      oCout => s_Cout_df
    );

  P_TEST: process
  begin
    ---------------------------------------------------------------------
    -- Case 1: 5 + 3 + 0 = 8, Cout=0
    ---------------------------------------------------------------------
    s_A   <= x"00000005";
    s_B   <= x"00000003";
    s_Cin <= '0';
    wait for 10 ns;

    assert (s_S_rca = x"00000008" and s_Cout_rca = '0')
      report "FAIL RCA Case 1: expected S=00000008 Cout=0" severity error;

    assert (s_S_df = x"00000008" and s_Cout_df = '0')
      report "FAIL DF Case 1: expected S=00000008 Cout=0" severity error;

    assert (s_S_rca = s_S_df and s_Cout_rca = s_Cout_df)
      report "MISMATCH Case 1: RCA != DF" severity error;

    ---------------------------------------------------------------------
    -- Case 2: 0x0F + 0x01 + 0 = 0x10, Cout=0 (carry ripples through low bits)
    ---------------------------------------------------------------------
    s_A   <= x"0000000F";
    s_B   <= x"00000001";
    s_Cin <= '0';
    wait for 10 ns;

    assert (s_S_rca = x"00000010" and s_Cout_rca = '0')
      report "FAIL RCA Case 2: expected S=00000010 Cout=0" severity error;

    assert (s_S_df = x"00000010" and s_Cout_df = '0')
      report "FAIL DF Case 2: expected S=00000010 Cout=0" severity error;

    assert (s_S_rca = s_S_df and s_Cout_rca = s_Cout_df)
      report "MISMATCH Case 2: RCA != DF" severity error;

    ---------------------------------------------------------------------
    -- Case 3: 0xFFFFFFFF + 1 + 0 = 0x00000000, Cout=1 (full carry ripple)
    ---------------------------------------------------------------------
    s_A   <= x"FFFFFFFF";
    s_B   <= x"00000001";
    s_Cin <= '0';
    wait for 10 ns;

    assert (s_S_rca = x"00000000" and s_Cout_rca = '1')
      report "FAIL RCA Case 3: expected S=00000000 Cout=1" severity error;

    assert (s_S_df = x"00000000" and s_Cout_df = '1')
      report "FAIL DF Case 3: expected S=00000000 Cout=1" severity error;

    assert (s_S_rca = s_S_df and s_Cout_rca = s_Cout_df)
      report "MISMATCH Case 3: RCA != DF" severity error;

    ---------------------------------------------------------------------
    -- Optional Case 4: Cin used (0 + 0 + 1 = 1)
    ---------------------------------------------------------------------
    s_A   <= x"00000000";
    s_B   <= x"00000000";
    s_Cin <= '1';
    wait for 10 ns;

    assert (s_S_rca = x"00000001" and s_Cout_rca = '0')
      report "FAIL RCA Case 4: expected S=00000001 Cout=0" severity error;

    assert (s_S_df = x"00000001" and s_Cout_df = '0')
      report "FAIL DF Case 4: expected S=00000001 Cout=0" severity error;

    assert (s_S_rca = s_S_df and s_Cout_rca = s_Cout_df)
      report "MISMATCH Case 4: RCA != DF" severity error;

    wait;
  end process;

end tb;
