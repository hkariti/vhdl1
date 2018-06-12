library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity food_object is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		ObjectStartX	: in integer;
		ObjectStartY 	: in integer;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end food_object;

architecture behav of food_object is 

constant object_X_size : integer := 27;
constant object_Y_size : integer := 40;
--constant R_high		: integer := 7;
--constant R_low		: integer := 5;
--constant G_high		: integer := 4;
--constant G_low		: integer := 2;
--constant B_high		: integer := 1;
--constant B_low		: integer := 0;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := (
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"d7",x"d2",x"b2",x"d2",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"b2",x"ce",x"cf",x"ef",x"ef",x"ef",x"ef",x"ce",x"d7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ce",x"ef",x"93",x"3b",x"57",x"af",x"ef",x"ef",x"ef",x"ef",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"d2",x"ef",x"cf",x"3b",x"5f",x"3f",x"57",x"ef",x"ef",x"cf",x"cf",x"ef",x"b2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"db",x"8e",x"93",x"af",x"3b",x"5f",x"3f",x"57",x"ef",x"ef",x"5b",x"57",x"ef",x"ef",x"d6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"d7",x"72",x"57",x"ef",x"73",x"3b",x"57",x"af",x"ef",x"ef",x"57",x"57",x"ef",x"ef",x"cf",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"d2",x"ef",x"ef",x"ef",x"ef",x"cf",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ce",x"d2",x"d7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ce",x"ef",x"92",x"ef",x"b3",x"93",x"ef",x"ef",x"ef",x"73",x"af",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ce",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ce",x"ef",x"8e",x"ae",x"3b",x"3f",x"93",x"ef",x"ef",x"53",x"b3",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"d2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"d2",x"ef",x"ef",x"cf",x"3b",x"3b",x"b3",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"d2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"d2",x"ef",x"ef",x"ef",x"cf",x"cf",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"d2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"d7",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ae",x"56",x"97",x"97",x"db",x"ff",x"ff",x"ff",x"ff"),
     (x"db",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"53",x"3f",x"3f",x"3b",x"76",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"cf",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"72",x"3f",x"5b",x"76",x"97",x"df",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"d2",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"8e",x"3b",x"5f",x"3b",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ce",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"8e",x"3b",x"5f",x"3b",x"3b",x"76",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"db",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"72",x"3b",x"5f",x"57",x"db",x"bb",x"df",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"d7",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ae",x"57",x"3f",x"3f",x"3f",x"5b",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"d7",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"ef",x"cf",x"8e",x"57",x"3b",x"3f",x"5b",x"97",x"57",x"52",x"fb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"b2",x"cf",x"ef",x"ef",x"cf",x"cf",x"8e",x"72",x"57",x"3b",x"3f",x"3b",x"3f",x"96",x"ff",x"ff",x"d2",x"ce",x"d7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"db",x"52",x"57",x"5b",x"3b",x"3f",x"3f",x"3b",x"3f",x"5b",x"76",x"3b",x"6e",x"d7",x"ff",x"ff",x"d7",x"ce",x"ce",x"fb",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"df",x"3b",x"5f",x"3f",x"5f",x"5f",x"3f",x"96",x"77",x"36",x"db",x"df",x"d7",x"b2",x"ff",x"ff",x"ff",x"ff",x"d3",x"d2",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"db",x"3b",x"3b",x"76",x"57",x"3b",x"37",x"db",x"ff",x"b2",x"d7",x"ff",x"ff",x"ae",x"ff",x"ff",x"ff",x"ff",x"ff",x"ae",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"56",x"9b",x"ff",x"ff",x"9b",x"92",x"d7",x"ff",x"d7",x"d3",x"ff",x"ff",x"ae",x"fb",x"ff",x"ff",x"ff",x"ff",x"b2",x"fb",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"d2",x"ff",x"d7",x"d2",x"ff",x"ff",x"d3",x"ce",x"ff",x"ff",x"ff",x"ff",x"d2",x"d7",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d7",x"d2",x"ff",x"d7",x"d2",x"ff",x"ff",x"ff",x"d2",x"ae",x"d7",x"ff",x"ff",x"d7",x"d2",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d7",x"d7",x"ff",x"db",x"ce",x"ff",x"ff",x"ff",x"ff",x"db",x"ae",x"d7",x"ff",x"ff",x"ce",x"d7",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"fb",x"ff",x"ff",x"ce",x"d7",x"ff",x"ff",x"ff",x"ff",x"db",x"ae",x"ff",x"ff",x"fb",x"d2",x"ae",x"d7",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"fb",x"ff",x"ff",x"db",x"ce",x"d7",x"ff",x"ff",x"ff",x"ff",x"ae",x"ff",x"ff",x"ff",x"ff",x"fb",x"ae",x"db"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d2",x"d7",x"ff",x"ff",x"ff",x"db",x"ce",x"d2",x"ff",x"ff",x"ff",x"b2",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fb",x"ae",x"ff",x"ff",x"ff",x"ff",x"ff",x"d3",x"ae",x"fb",x"ff",x"d7",x"ae",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"d7",x"ff",x"ff",x"ff",x"ff",x"ff",x"d7",x"b2",x"ff",x"ff",x"d7",x"ae",x"db",x"ff",x"ff",x"ff",x"db"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ae",x"d7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ae",x"ff",x"ff",x"ff",x"ff",x"ae",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ae",x"fb",x"ff",x"ff",x"ff",x"fb",x"b2",x"ff",x"ff",x"ff",x"ff",x"b2",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d7",x"d7",x"ff",x"ff",x"ff",x"d7",x"d2",x"ff",x"ff",x"ff",x"ff",x"db",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d2",x"d7",x"ff",x"ff",x"ff",x"db",x"b2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
     ("000001111100000000000000000"),
     ("000111111111000000000000000"),
     ("001111111111100000000000000"),
     ("011111111111110000000000000"),
     ("111111111111111000000000000"),
     ("111111111111111100000000000"),
     ("111111111111111111000000000"),
     ("111111111111111111110000000"),
     ("111111111111111111110000000"),
     ("111111111111111111110000000"),
     ("111111111111111111110000000"),
     ("111111111111111111111110000"),
     ("111111111111111111111110000"),
     ("011111111111111111111110000"),
     ("011111111111111111111000000"),
     ("011111111111111111111000000"),
     ("111111111111111111111000000"),
     ("111111111111111111000000000"),
     ("111111111111111111100000000"),
     ("011111111111111001110000000"),
     ("001111111111111100111100000"),
     ("001111111111111100001100000"),
     ("001111111101100100000100000"),
     ("000110011101100110000110000"),
     ("000000001101100110000110000"),
     ("000000001101100011100110000"),
     ("000000001101100001110011000"),
     ("000000001100110000110011110"),
     ("000000001100111000010000111"),
     ("000000001100011100011000001"),
     ("000000001100000111011000001"),
     ("000000000110000011001110001"),
     ("000000000011000001000010000"),
     ("000000000001100011000010000"),
     ("000000000001100011000010000"),
     ("000000000001100011000000000"),
     ("000000000001000001000000000"),
     ("000000000001000001100000000"),
     ("000000000001000000110000000"),
     ("000000000000100000000000000")
);

signal bCoord_X : integer := 0;-- offset from start position 
signal bCoord_Y : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';

--		
signal objectEndX : integer;
signal objectEndY : integer;

begin

-- Calculate object end boundaries
objectEndX	<= object_X_size+ObjectStartX;
objectEndY	<= object_Y_size+ObjectStartY;

-- Signals drawing_X[Y] are active when obects coordinates are being crossed

-- test if ooCoord is in the rectangle defined by Start and End 
	drawing_X	<= '1' when  (oCoord_X  >= ObjectStartX) and  (oCoord_X < objectEndX) else '0';
    drawing_Y	<= '1' when  (oCoord_Y  >= ObjectStartY) and  (oCoord_Y < objectEndY) else '0';

-- calculate offset from start corner 
	bCoord_X 	<= (oCoord_X - ObjectStartX) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 
	bCoord_Y 	<= (oCoord_Y - ObjectStartY) when ( drawing_X = '1' and  drawing_Y = '1'  ) else 0 ; 


process ( RESETn, CLK)

  		
   begin
	if RESETn = '0' then
	    mVGA_RGB	<=  (others => '0') ; 	
		drawing_request	<=  '0' ;

		elsif rising_edge(CLK) then
			mVGA_RGB	<=  object_colors(bCoord_Y, bCoord_X);	--get from colors table 
			drawing_request	<= object(bCoord_Y, bCoord_X) and drawing_X and drawing_Y ; -- get from mask table if inside rectangle  
	end if;

  end process;

		
end behav;		
		
