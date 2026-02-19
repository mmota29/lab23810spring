library IEEE;
use IEEE.std_logic_1164.all;

entity reg_N is
  generic (N : integer := 32);
  port(
    i_CLK : in std_logic;
    i_RST : in std_logic;
    i_WE  : in std_logic;
    i_D   : in std_logic_vector(N-1 downto 0);
    o_Q   : out std_logic_vector(N-1 downto 0)
  );
end reg_N;

architecture structural of reg_N is
  component dffg
    port(
      i_CLK : in std_logic;
      i_RST : in std_logic;
      i_WE  : in std_logic;
      i_D   : in std_logic;
      o_Q   : out std_logic
    );
  end component;

  signal s_q : std_logic_vector(N-1 downto 0);

begin
  o_Q <= s_q;

  gen_bits: for i in 0 to N-1 generate
    dff_i: dffg
      port map(
        i_CLK => i_CLK,
        i_RST => i_RST,
        i_WE  => i_WE,
        i_D   => i_D(i),
        o_Q   => s_q(i)
      );
  end generate gen_bits;

end structural;
