library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity random is
port 	(
		CLOCK_50: in std_logic;
		resetN: in std_logic;
		init: in integer;
		random: out unsigned(31 downto 0)
	);
end random;

architecture behav of random is
	constant M: integer := 511;
	constant A: integer := 13;
	constant C: integer := 5;
	signal random_t: integer := 0;
begin 
process (CLOCK_50, resetN)
begin
	if (resetN = '0') then
		random_t <= init;
	elsif (rising_edge(CLOCK_50)) then
		random_t <= A*random_t + C;
		--random_t <= bignum(15 downto 0);
	--	random_t <= std_logic_vector(random_t) and M;
	end if;
	random(8 downto 0) <= to_unsigned(random_t, 9);
	random(31 downto 9) <= (others => '0');
end process;
end;
		
		
		