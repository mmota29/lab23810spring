-------------------------------------------------------------------------
-- mux2t1_df.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Dataflow 2:1 mux using conditional signal assignment only.
--              No AND/OR/NOT operators used.
--              If i_S = '0' -> o_O = i_D0
--              If i_S = '1' -> o_O = i_D1
-------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity mux2t1_df is
  port(
    i_S  : in  std_logic;
    i_D0 : in  std_logic;
    i_D1 : in  std_logic;
    o_O  : out std_logic
  );
end mux2t1_df;

architecture dataflow of mux2t1_df is
begin
  o_O <= i_D0 when i_S = '0' else i_D1;
end dataflow;
