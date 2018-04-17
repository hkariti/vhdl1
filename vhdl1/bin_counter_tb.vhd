library ieee;
use ieee.std_logic_1164.all;

entity bin_counter_tb is
	port ( z : out std_logic_vector(3 downto 0));
end entity;

architecture behavior of bin_counter_tb is
	signal clk : std_logic := '0';
	signal resetn : std_logic := '0';
component bin_counter is
    port (
             resetN: in std_logic;
             clk: in std_logic;
             count: out std_logic_vector(3 downto 0)
);
end component;
	
begin
	clk <= not clk after 10 ns;
	cnt: bin_counter port map (resetN => resetn, clk => clk, count=>z );
	process begin
		wait for 20 ns;
		resetn <= '1';
		wait for 200 ns;
		resetn <= '0';
		wait for 20 ns;
		resetn <= '1';
		wait;
	end process;
end;