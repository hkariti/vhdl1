library ieee;
use ieee.std_logic_1164.all;

entity One_sec_tb is
	port ( z : out std_logic);
end entity;

architecture behavior of One_sec_tb is
	signal clk : std_logic := '0';
	signal resetn : std_logic := '0';
component One_sec is
    port (
             resetN: in std_logic;
             clk: in std_logic;
             OneSec: out std_logic
);
end component;
	
begin
	clk <= not clk after 10 ns;
	one_s: one_sec port map (resetN => resetn, clk => clk, OneSec =>z );
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
