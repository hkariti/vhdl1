library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun March 24 2017 
-- Dudy Nov 13 2017


entity object_1_move is
port 	(
		CLK				: in std_logic; --						//	27 MHz
		RESETn			: in std_logic; --			//	50 MHz
		timer_done		: in std_logic;
		StartY         : in std_logic_vector(31 downto 0);
		speed          : in std_logic_vector(31 downto 0);
		ObjectStartX	: out std_logic_vector(31 downto 0) ;
		ObjectStartY	: out std_logic_vector(31 downto 0)
		
	);
end;

architecture behav of object_1_move is 

constant StartX : integer := 640;   -- starting point
  

signal ObjectStartX_t : integer range 0 to 640;  --vga screen size 
signal ObjectStartY_t : integer range 80 to 400;
begin
		process ( RESETn,CLK)
		begin
		  if RESETn = '0' then
				ObjectStartX_t	<= StartX + to_integer(unsigned(startY));
				ObjectStartY_t	<= to_integer(unsigned(StartY)) ;
		elsif rising_edge(CLK) then
			if timer_done = '1' then
				if ObjectStartX_t <=  0 then
					ObjectStartX_t <= StartX + to_integer(unsigned(startY));
					ObjectStartY_t <= to_integer(unsigned(StartY));
				else		
				   ObjectStartX_t <= ObjectStartX_t - to_integer(unsigned(speed));
				end if;
			end if;
			
		end if;
		end process ;
ObjectStartX	<= std_logic_vector(to_unsigned(ObjectStartX_t, 32));		-- copy to outputs 	
ObjectStartY	<= std_logic_vector(to_unsigned(ObjectStartY_t, 32));	


end behav;