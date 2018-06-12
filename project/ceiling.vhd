library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity ceiling is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
			slow_clk : in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end ceiling;

architecture behav of ceiling is 

constant init_height : integer:= 40;
constant object_X_size : integer := 200;
signal current_X_size : integer;

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_X_size - 1) of integer;
signal object : object_form;

signal ObjectStartX : integer := 0;
signal ObjectEndX : integer := object_X_size - 1;

signal bCoord_X : integer := 0;-- offset from start position 

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';

begin

-- Calculate object end boundaries


-- Signals drawing_X[Y] are active when obects coordinates are being crossed

-- calculate offset from start corner 
process ( RESETn, CLK)
	variable add : integer := 1;

   begin
	if RESETn = '0' then
	   mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
		current_X_size <= 0;
		objectStartX <= 0;
		objectEndX <= object_X_size - 1;

	elsif rising_edge(CLK) then
		if (current_X_size < object_X_size) then
			object(current_X_size) <= init_height;
			current_X_size <= current_X_size + 1;
			if (oCoord_Y <= init_height) then
				drawing_request <= '1';
			else
				drawing_request <= '0';
			end if;
		else
			if(slow_clk = '1') then
				if object(ObjectStartX) = 2*init_height then
					object
				object(objectStartX) <= object(objectEndX) + 1;
				if object(objectStartX) = 2*init_height then
					object(objectStartX) <= init_height;
				end if;
				objectStartX <= objectStartX + 1;
				objectEndX <= objectEndX + 1;
				if (objectStartX = object_X_size) then
					objectStartX <= 0;
				end if;
				if (objectEndX = object_X_size) then
					objectEndX <= 0;
				end if;
			end if;
			--if (oCoord_X >= objectStartX) then
			--	bCoord_X 	<= (oCoord_X - objectStartX);
			--else
			--	bCoord_X <= object_X_size + (oCoord_X-objectStartX); 
			--end if;
			bCoord_X <= (objectStartX + oCoord_X) mod object_X_size;
			if (object(bCoord_X) <= oCoord_Y) then
				drawing_request <= '0';
			else
				drawing_request <= '1';
			end if;
		end if;
		mVGA_RGB	<= x"FF";
	end if;
  end process;
end behav;		
		