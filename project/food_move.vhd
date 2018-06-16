library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 
-- Dudy Nov 13 2017


entity food_move is
port 	(
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		timer_done		: in std_logic;
		random          : in integer;
		collision		: in std_logic;
		ObjectStartX	: out integer ;
		ObjectStartY	: out integer
	);
end;

architecture behav of food_move is 

constant StartY : integer := 480;   -- starting point
constant baseStartX: integer := 400;
constant marginY: integer := 128;   -- allowed deviation from starting point
constant marginX: integer := 600;
constant speed: integer := 1;       -- speed of the object

signal ObjectStartX_t : integer;
signal ObjectStartY_t : integer;

begin
		process ( RESETn,CLK)
        variable recalc_Y : integer := StartY + (random mod marginY);
        variable recalc_X : integer := (random mod marginX) + baseStartX;
		begin
		  if RESETn = '0' then
				ObjectStartY_t	<= recalc_Y;
				ObjectStartX_t	<= recalc_X;
			elsif rising_edge(CLK) then
				if collision = '1' then
						ObjectStartY_t <= recalc_Y;
						ObjectStartX_t <= recalc_X;
				end if;
				if timer_done = '1' then
					if ObjectStartY_t <=  0 then
						ObjectStartY_t <= recalc_Y;
						ObjectStartX_t <= recalc_X;
					else		
						ObjectStartY_t <= ObjectStartY_t - speed;
						ObjectStartX_t <= ObjectStartX_t - 2*speed;
					end if;
				end if;	
			end if;
		end process;
ObjectStartX	<= ObjectStartX_t;		-- copy to outputs 	
ObjectStartY	<= ObjectStartY_t;	

end behav;
