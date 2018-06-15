library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity collision_detect is
port 	(
		resetN: in std_logic;
		clk: in std_logic;
		drawing_request_main: in std_logic;
		drawing_request_sec1: in std_logic;
		drawing_request_sec2: in std_logic;
		drawing_request_sec3: in std_logic;
		drawing_request_sec4: in std_logic;
		drawing_request_sec5: in std_logic;
		drawing_request_sec6: in std_logic;
		drawing_request_sec7: in std_logic;
		drawing_request_sec8: in std_logic;
		drawing_request_sec9: in std_logic;
		collision: out std_logic;
		food_eaten5: out std_logic;
		food_eaten6: out std_logic;
		food_eaten7: out std_logic

	);
end collision_detect;

architecture behav of collision_detect is 
signal collision_t : std_logic;
signal food_eaten5_t : std_logic;
signal food_eaten6_t : std_logic;
signal food_eaten7_t : std_logic;
begin
process(clk, resetN)
begin

if (resetN = '0') then
	collision_t <= '0';
	food_eaten5_t <= '0';
	food_eaten6_t <= '0';
	food_eaten7_t <= '0';
elsif (rising_edge(clk)) then
	collision_t <= ((drawing_request_main and drawing_request_sec1) or
								(drawing_request_main and drawing_request_sec2) or
								(drawing_request_main and drawing_request_sec3) or
								(drawing_request_main and drawing_request_sec4) or
								(drawing_request_main and drawing_request_sec5) or
								(drawing_request_main and drawing_request_sec6)
								);
	food_eaten5_t <=	drawing_request_main and drawing_request_sec7;
	food_eaten6_t <=	drawing_request_main and drawing_request_sec8;
	food_eaten7_t <=	drawing_request_main and drawing_request_sec9;
end if;
end process;

collision <= collision_t;
food_eaten5 <= food_eaten5_t;
food_eaten6 <= food_eaten6_t;
food_eaten7 <= food_eaten7_t;
end behav;		