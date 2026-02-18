library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_mux32to1_32bit is
end tb_mux32to1_32bit;

architecture sim of tb_mux32to1_32bit is
  component mux32to1_32bit
    type word32_array_t is array(0 to 31) of std_logic_vector(31 downto 0);
    port(
      i_D : in word32_array_t;
      i_S : in std_logic_vector(4 downto 0);
      o_Y : out std_logic_vector(31 downto 0)
    );
  end component;

  -- annoying but easiest: redeclare the same type here too
  type word32_array_t is array(0 to 31) of std_logic_vector(31 downto 0);

  signal d : word32_array_t;
  signal s : std_logic_vector(4 downto 0) := (others => '0');
  signal y : std_logic_vector(31 downto 0);

begin
  uut: mux32to1_32bit
    port map(
      i_D => d,
      i_S => s,
      o_Y => y
    );

  stim: process
  begin
    -- init the inputs with something obvious in hex
    -- change this pattern if you want it to look different in waveform
    for i in 0 to 31 loop
      d(i) <= std_logic_vector(to_unsigned(i, 32)); -- 0..31
    end loop;

    -- pick a few selects
    s <= "00000"; -- expect y=0
    wait for 10 ns;

    s <= "00001"; -- expect y=1
    wait for 10 ns;

    s <= "01001"; -- expect y=9
    wait for 10 ns;

    s <= "11111"; -- expect y=31
    wait for 10 ns;

    -- another test: make inputs more ?taggy?
    -- change this to change the vibe (ASCII hex works too)
    d(5) <= x"4D494348"; -- "MICH"
    d(6) <= x"41454C00"; -- "AEL\0"
    s <= "00101"; -- select 5
    wait for 10 ns;
    s <= "00110"; -- select 6
    wait for 10 ns;

    wait;
  end process;

end sim;
