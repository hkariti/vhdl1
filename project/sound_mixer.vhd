-- This module is dividing the 50MHz CLOCK OSC, and sends clock
-- enable it to the appropriate outputs in order to achieve
-- operation at slower rate of individual modules (this is done
-- to keep the whole system globally synchronous).
-- All DACs output are set to 100 KHz. 

 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


entity sound_mixer is
	port
		(
			CLK_IN					:	in 	std_logic;	
			resetN					:  in 	std_logic;
			stream1					:	in 	integer range -128 to 127;
			stream2					:	in		integer range -128 to 127;
			stream3					:	in		integer range -128 to 127;
			stream4					:	in		integer range -128 to 127;
			mixed						:	out	integer range -32768 to 32767
		);
		
end sound_mixer;


architecture behave of sound_mixer is

constant volume_scale_factor : integer := 1;
signal mixed_t : integer range 0 to 65535;

begin	
process (CLK_IN, resetN)
begin
	if (resetN = '0') then
		mixed_t <= 0;
	elsif (rising_edge(clk_in)) then
		mixed_t <= 	conv_integer(stream1)/volume_scale_factor +
						conv_integer(stream2)/volume_scale_factor +
						conv_integer(stream3)/volume_scale_factor +
						conv_integer(stream4)/volume_scale_factor;
	end if;
end process;

mixed <= mixed_t;
end behave;