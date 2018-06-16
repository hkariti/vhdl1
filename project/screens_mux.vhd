-- This module is dividing the 50MHz CLOCK OSC, and sends clock
-- enable it to the appropriate outputs in order to achieve
-- operation at slower rate of individual modules (this is done
-- to keep the whole system globally synchronous).
-- All DACs output are set to 100 KHz. 

 
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;


entity screens_mux is
	port
		(
			CLK_IN					:	in 	std_logic;	
			resetN					:  in 	std_logic;
			screen_1_rgb			:	in 	std_logic_vector(23 downto 0);
			screen_2_rgb			:	in		std_logic_vector(23 downto 0);
			screen_3_rgb			:	in		std_logic_vector(23 downto 0);
			screen_choice			:	in		std_logic_vector(1 downto 0);
			screen_out_rgb			:	out	std_logic_vector(23 downto 0)
		);
		
end screens_mux;


architecture behave of screens_mux is
signal screen_out_rgb_t: std_logic_vector(23 downto 0);
begin	
process (CLK_IN, resetN)
begin
	if (resetN = '0') then
		screen_out_rgb_t <= (others => '0');
	elsif (rising_edge(clk_in)) then
		if (screen_choice = "00") then
			screen_out_rgb_t <= screen_1_rgb;
		elsif (screen_choice = "01") then
			screen_out_rgb_t <= screen_2_rgb;
		else
			screen_out_rgb_t <= screen_3_rgb;
		end if;
	end if;
end process;

screen_out_rgb <= screen_out_rgb_t;
end behave;