library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity floor is
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
end floor;

architecture behav of floor is 

constant object_X_size : integer := 58;
constant object_Y_size : integer := 25;
constant ObjectStartY : integer := 479 - object_Y_size;
constant ObjectEndY : integer := 480;

--constant R_high		: integer := 7;
--constant R_low		: integer := 5;
--constant G_high		: integer := 4;
--constant G_low		: integer := 2;
--constant B_high		: integer := 1;
--constant B_low		: integer := 0;

type ram_array is array(0 to object_X_size - 1, 0 to object_Y_size - 1) of std_logic_vector(7 downto 0);  

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_X_size - 1, 0 to object_Y_size - 1) of std_logic;
constant object : object_form := (
("0000000000000001111111111"),
("0000000000000001111111111"),
("0000000000000001111111111"),
("0000000000000001111111111"),
("0000000000000011111111111"),
("0000000000000011111111111"),
("0000000000000011111111111"),
("0000000000001111111111111"),
("0000000000001111111111111"),
("0000000000111111111111111"),
("0000000000111111111111111"),
("0000000011111111111111111"),
("0000000011111111111111111"),
("0000000011111111111111111"),
("0000001111111111111111111"),
("0000001111111111111111111"),
("0000111111111111111111111"),
("0000111111111111111111111"),
("0000111111111111111111111"),
("0001111111111111111111111"),
("0001111111111111111111111"),
("0001111111111111111111111"),
("0001111111111111111111111"),
("0001111111111111111111111"),
("0011111111111111111111111"),
("0011111111111111111111111"),
("0011111111111111111111111"),
("0011111111111111111111111"),
("0011111111111111111111111"),
("0011111111111111111111111"),
("0011111111111111111111111"),
("0011111111111111111111111"),
("0011111111111111111111111"),
("0011111111111111111111111"),
("0001111111111111111111111"),
("0001111111111111111111111"),
("0001111111111111111111111"),
("0001111111111111111111111"),
("0000111111111111111111111"),
("0000111111111111111111111"),
("0000111111111111111111111"),
("0000111111111111111111111"),
("0000001111111111111111111"),
("0000001111111111111111111"),
("0000001111111111111111111"),
("0000000011111111111111111"),
("0000000011111111111111111"),
("0000000011111111111111111"),
("0000000000111111111111111"),
("0000000000111111111111111"),
("0000000000001111111111111"),
("0000000000000011111111111"),
("0000000000000011111111111"),
("0000000000000011111111111"),
("0000000000000001111111111"),
("0000000000000001111111111"),
("0000000000000001111111111"),
("0000000000000001111111111")
);
signal ObjectStartX : integer := 0;

signal bCoord_X : integer := 0;-- offset from start position 
signal bCoord_Y : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';

--		

begin

-- Calculate object end boundaries


-- Signals drawing_X[Y] are active when obects coordinates are being crossed

-- test if ooCoord is in the rectangle defined by Start and End 
    drawing_Y	<= '1' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectEndY) else '0';

-- calculate offset from start corner 
	bCoord_Y 	<= (oCoord_Y - ObjectStartY) when ( drawing_Y = '1'  ) else 0 ; 


process ( RESETn, CLK)
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;
		elsif rising_edge(CLK) then
			if(slow_clk = '1') then
				objectStartX <= objectStartX + 1;
				if (objectStartX = object_X_size) then
					objectStartX <= 0;
				end if;
			end if;
			mVGA_RGB <= x"F0";
			bCoord_X <= (objectStartX + oCoord_X) mod object_X_size;
			drawing_request <= object(bCoord_X, bCoord_Y);
	end if;

  end process;

		
end behav;		
		
