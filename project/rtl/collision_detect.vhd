library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity collision_detect is
port 	(
		resetN: in std_logic;
		drawing_request1: in std_logic;
		drawing_request2: in std_logic;
		collision: out std_logic
	);
end collision_detect;

architecture behav of collision_detect is 
begin

collision <= resetN and drawing_request1 and drawing_request2;

		
end behav;		