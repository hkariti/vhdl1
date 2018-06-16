-- This module is dividing the 50MHz CLOCK OSC, and sends clock
-- enable it to the appropriate outputs in order to achieve
-- operation at slower rate of individual modules (this is done
-- to keep the whole system globally synchronous).
-- All DACs output are set to 100 KHz. 

 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


entity pixel_filter is
	port
		(
			rgb_in				:	in	integer range 0 to 255;
			transparent_color	:	in integer range 0 to 255;
			color					:	out std_logic
		);
		
end pixel_filter;


architecture behave of pixel_filter is
begin
color <= '0' when (rgb_in = transparent_color) else '1';
end behave;