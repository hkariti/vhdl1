library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 
-- Dudy Nov 13 2017


entity smileyfacemove is
port 	(
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		timer_done		: in std_logic;
		up     			: in std_logic;
		speed          : in integer;
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
		
	);
end smileyfacemove;

architecture behav of smileyfacemove is 

constant StartX : integer := 50;   -- starting point
constant StartY : integer := 200;   


signal ObjectStartX_t : integer range 0 to 640;  --vga screen size 
signal ObjectStartY_t : integer range 0 to 480;
begin


		process ( RESETn,CLK)
		begin
		  if RESETn = '0' then
				ObjectStartX_t	<= StartX;
				ObjectStartY_t	<= StartY ;
		elsif rising_edge(CLK) then		
			if timer_done = '1' then
				if (up = '1') then 
				  ObjectStartY_t  <= ObjectStartY_t - speed; -- move to the up
				else
					ObjectStartY_t <= ObjectStartY_t + speed;
				end if;
			end if;
		end if;
		end process ;
ObjectStartX	<= ObjectStartX_t;		-- copy to outputs 	
ObjectStartY	<= ObjectStartY_t;	


end behav;