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
		StartX         : in std_logic_vector(31 downto 0);
		ObjectStartX	: out std_logic_vector(31 downto 0) ;
		ObjectStartY	: out std_logic_vector(31 downto 0)
		
	);
end;

architecture behav of food_move is 

constant StartY : integer := 480;   -- starting point
constant marginY: integer := 128;
constant marginX: integer := 600;
constant baseStartX: integer := 400;
constant speed: integer := 1; 

signal ObjectStartX_t : integer; -- range 0 to 640;  --vga screen size 
signal ObjectStartY_t : integer; -- range 80 to 400;
begin
		process ( RESETn,CLK)
		begin
		  if RESETn = '0' then
				ObjectStartY_t	<= StartY + (to_integer(unsigned(startX)) mod marginY);
				ObjectStartX_t	<= (to_integer(unsigned(StartX)) mod marginX) + baseStartX ;
			elsif rising_edge(CLK) then
				if timer_done = '1' then
					if ObjectStartY_t <=  0 then
						ObjectStartY_t <= StartY + (to_integer(unsigned(startX)) mod marginY);
						ObjectStartX_t <= (to_integer(unsigned(StartX)) mod marginX) + baseStartX ;
					else		
						ObjectStartY_t <= ObjectStartY_t - speed;
						ObjectStartX_t <= ObjectStartX_t - 2*speed;
					end if;
				end if;	
			end if;
		end process ;
ObjectStartX	<= std_logic_vector(to_unsigned(ObjectStartX_t, 32));		-- copy to outputs 	
ObjectStartY	<= std_logic_vector(to_unsigned(ObjectStartY_t, 32));	


end behav;