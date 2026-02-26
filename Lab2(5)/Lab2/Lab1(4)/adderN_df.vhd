-------------------------------------------------------------------------
-- adderN_df.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: N-bit adder reference (dataflow/behavioral) using numeric_std.
--              oS,oCout = iA + iB + iCin
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity adderN_df is
  generic(N : integer := 32);
  port(
    iA    : in  std_logic_vector(N-1 downto 0);
    iB    : in  std_logic_vector(N-1 downto 0);
    iCin  : in  std_logic;
    oS    : out std_logic_vector(N-1 downto 0);
    oCout : out std_logic
  );
end adderN_df;

architecture dataflow of adderN_df is
  signal s_sum   : unsigned(N downto 0);
  signal s_cinex : unsigned(N downto 0);
begin

  -- Carry-in extended to N+1 bits (only bit 0 is iCin)
  s_cinex <= (0 => iCin, others => '0');

  -- Full (N+1)-bit sum to capture carry-out
  s_sum <= ('0' & unsigned(iA)) + ('0' & unsigned(iB)) + s_cinex;

  oS    <= std_logic_vector(s_sum(N-1 downto 0));
  oCout <= s_sum(N);

end dataflow;

