library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity shark1_object is
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
end shark1_object;

architecture behav of shark1_object is 

constant object_X_size : integer := 53;
constant object_Y_size : integer := 70;
--constant R_high		: integer := 7;
--constant R_low		: integer := 5;
--constant G_high		: integer := 4;
--constant G_low		: integer := 2;
--constant B_high		: integer := 1;
--constant B_low		: integer := 0;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := (
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"6d",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"b6",x"6d",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"6d",x"b6",x"6d",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"92",x"b6",x"b6",x"b6",x"6d",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"92",x"db",x"b6",x"b6",x"b6",x"6d",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"6d",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"6d",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"6d",x"b6",x"92",x"b6",x"db",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"6d",x"b6",x"db",x"ff",x"ff",x"ff",x"92",x"92",x"b6",x"24",x"b6",x"db",x"db",x"6d",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"b6",x"92",x"6d",x"6d",x"92",x"6d",x"6d",x"92",x"6d",x"92",x"b6",x"b6",x"b6",x"92",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"db",x"b6",x"b6",x"b6",x"92",x"6d",x"24",x"6d",x"6d",x"92",x"6d",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"b6",x"49",x"db",x"ff",x"b6",x"92",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"6d",x"ff",x"ff",x"6d",x"92",x"49",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"6d",x"6d",x"92",x"b6",x"b6",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"6d",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"49",x"6d",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"6d",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"b6",x"49",x"24",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"24",x"24",x"24",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6d",x"b6",x"db",x"db",x"b6",x"b6",x"6d",x"24",x"49",x"ff",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"92",x"92",x"6d",x"49",x"6d",x"ff",x"49",x"92",x"ff",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"92",x"6d",x"db",x"6d",x"b6",x"ff",x"6d",x"92",x"db",x"24",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"ff",x"49",x"b6",x"b6",x"db",x"92",x"6d",x"49",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"49",x"6d",x"db",x"6d",x"92",x"ff",x"92",x"6d",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"92",x"6d",x"ff",x"6d",x"b6",x"ff",x"b6",x"b6",x"6d",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"db",x"b6",x"ff",x"92",x"db",x"ff",x"92",x"b6",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"49",x"92",x"92",x"ff",x"92",x"db",x"ff",x"92",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"b6",x"49",x"24",x"92",x"49",x"49",x"49",x"24",x"6d",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"b6",x"b6",x"49",x"24",x"6d",x"6d",x"6d",x"49",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"b6",x"b6",x"b6",x"db",x"6d",x"24",x"6d",x"49",x"49",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"6d",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"92",x"db",x"b6",x"b6",x"b6",x"db",x"92",x"49",x"49",x"b6",x"b6",x"b6",x"b6",x"db",x"db",x"db",x"b6",x"db",x"db",x"b6",x"b6",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"db",x"b6",x"6d",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"b6",x"b6",x"b6",x"db",x"92",x"6d",x"6d",x"92",x"92",x"92",x"92",x"92",x"b6",x"92",x"49",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"49",x"6d",x"92",x"92",x"92",x"92",x"92",x"6d",x"6d",x"92",x"92",x"92",x"49",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"92",x"92",x"92",x"92",x"db",x"6d",x"49",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"92",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"db",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"6d",x"6d",x"92",x"b6",x"b6",x"b6",x"92",x"b6",x"b6",x"6d",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"6d",x"b6",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"6d",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"b6",x"b6",x"db",x"b6",x"92",x"92",x"6d",x"92",x"92",x"db",x"6d",x"b6",x"b6",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"db",x"6d",x"92",x"b6",x"db",x"b6",x"b6",x"b6",x"b6",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"49",x"92",x"6d",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"6d",x"db",x"db",x"6d",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"92",x"6d",x"6d",x"b6",x"b6",x"db",x"b6",x"6d",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"49",x"b6",x"92",x"6d",x"6d",x"6d",x"6d",x"92",x"b6",x"6d",x"b6",x"b6",x"db",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"92",x"92",x"92",x"49",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"6d",x"6d",x"db",x"db",x"b6",x"b6",x"db",x"db",x"6d",x"92",x"db",x"b6",x"db",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"49",x"92",x"db",x"b6",x"b6",x"db",x"92",x"6d",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"49",x"b6",x"db",x"b6",x"b6",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"49",x"b6",x"db",x"6d",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"b6",x"49",x"6d",x"49",x"92",x"92",x"b6",x"db",x"b6",x"db",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"b6",x"24",x"92",x"b6",x"92",x"6d",x"6d",x"b6",x"db",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"b6",x"b6",x"b6",x"b6",x"db",x"b6",x"6d",x"db",x"ff",x"ff",x"b6",x"6d",x"db",x"92",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"6d",x"b6",x"b6",x"db",x"db",x"db",x"db",x"db",x"b6",x"6d",x"92",x"ff",x"ff",x"92",x"b6",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"db",x"b6",x"db"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"6d",x"49",x"6d",x"6d",x"6d",x"92",x"92",x"92",x"92",x"49",x"6d",x"ff",x"db",x"6d",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"92",x"6d",x"92",x"92",x"49",x"92"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"b6",x"b6",x"b6",x"92",x"6d",x"db",x"db",x"db",x"b6",x"b6",x"db",x"ff",x"ff",x"b6",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"92",x"92",x"b6",x"b6",x"6d",x"6d",x"db",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"b6",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"92",x"92",x"b6",x"db",x"b6",x"6d",x"b6",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"6d",x"b6",x"b6",x"db",x"db",x"92",x"92",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"92",x"b6",x"b6",x"b6",x"b6",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"6d",x"b6",x"db",x"b6",x"b6",x"b6",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"6d",x"b6",x"db",x"b6",x"b6",x"db",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"6d",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"92",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"6d",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"6d",x"db",x"ff",x"ff",x"b6",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"6d",x"db",x"ff",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"6d",x"b6",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"6d",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"6d",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"6d",x"92",x"b6",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"92",x"6d",x"92",x"b6",x"b6",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"92",x"6d",x"92",x"b6",x"b6",x"db",x"db",x"db",x"b6",x"db",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"92",x"6d",x"6d",x"92",x"92",x"92",x"92",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"db",x"b6",x"b6",x"92",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"db",x"92",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"92",x"db",x"b6",x"b6",x"b6",x"b6",x"92",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"6d",x"b6",x"b6",x"b6",x"b6",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"6d",x"b6",x"db",x"b6",x"db",x"92",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"6d",x"b6",x"db",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"92",x"6d",x"92",x"6d",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
     ("00000000001110000000000000000000000000000000000000000"),
     ("00000000001111000000000000000000000000000000000000000"),
     ("00000000001111100000000000000000000000000000000000000"),
     ("00000000011111110000000000000010000000000000000000000"),
     ("00000000011111111000000000000111000000000000000000000"),
     ("00000000001111111100000001111111000000000000000000000"),
     ("00000000001111111111100011111111100000000000000000000"),
     ("00000000001111111111111111111111100000000000000000000"),
     ("00000000001111111111111111111111000000000000000000000"),
     ("00000000001111111111111111111111000000000000000000000"),
     ("00000000000111111111111111111111100000000000000000000"),
     ("00000000000111111111111111111111110000000000000000000"),
     ("00000000000011111111111111111111111000000000000000000"),
     ("00000000000011111111111111111111111000000000000000000"),
     ("00000000000001111111111111111111111100000000000000000"),
     ("00000000000001111111111111111111111100000000000000000"),
     ("00000000000000111111111111111111111110000000000000000"),
     ("00000000000000011111111111111111111110000000000000000"),
     ("00000000000000011111111111111111111110000000000000000"),
     ("00000000000000011111111111111111111110000000000000000"),
     ("00000000000000000111111111111111111110000000000000000"),
     ("00000000000000000111111111111111111110000000000000000"),
     ("00000000000000001111111111111111111110000000000000000"),
     ("00000000000000001111111111111111111110000000000000000"),
     ("00000000000000011111111111111111111110000000000000000"),
     ("00000000000000011111111111111111111110000000000000000"),
     ("00000000000000011111111111111111111110000000000000000"),
     ("00000000000000111111111111111111111110000000000000000"),
     ("00000000000001111111111111111111111100000000000000000"),
     ("00000000011111111111111111111111111100000000000000000"),
     ("11111111111111111111111111111111111110000000000000000"),
     ("11111111111111111111111111111111111110000000000000000"),
     ("01111111111111111111111111111111111110000000000000000"),
     ("01111111111111111111111111111111111111000000000000000"),
     ("00011111111111111111111111111111111111000000000000000"),
     ("00000111111111111111111111111111111111000000000000000"),
     ("00000000011111111111111111111111111111000000000000000"),
     ("00000000011111111111111111111111111111000000000000000"),
     ("00000000111111111111111111111111111111000000000000000"),
     ("00000000111111111111111111111111111111000000000000000"),
     ("00000000111111111111111111111111111111000000000000000"),
     ("00000000111111111111111111111110011111000000000000000"),
     ("00000000111111111111111111111111001110000000000001111"),
     ("00000000111111111111111111111111101110000000001111111"),
     ("00000000111111111111111111111111100110000000111111110"),
     ("00000000111111111111111111100000000000000011111111000"),
     ("00000000111111111111111111100000000000001111111100000"),
     ("00000000011111111111111111100000000000011111111000000"),
     ("00000000011111111111111111100000000001111111110000000"),
     ("00000000011111111111111111100000000011111111100000000"),
     ("00000000011111111111111111100000000111111111000000000"),
     ("00000000001111111111111111110000001111111110000000000"),
     ("00000000001111111111111111110000011111111110000000000"),
     ("00000000000111111111111111111000011111111100000000000"),
     ("00000000000111111111111111111100111111111000000000000"),
     ("00000000000011111111111111111110111111111000000000000"),
     ("00000000000001111111111111111111111111111000000000000"),
     ("00000000000000111111111111111111111111110000000000000"),
     ("00000000000000001111111111111111111111110000000000000"),
     ("00000000000000000111111111111111111111110000000000000"),
     ("00000000000000000000111111111111111111110000000000000"),
     ("00000000000000000000000111111111111111110000000000000"),
     ("00000000000000000000000000111111111111110000000000000"),
     ("00000000000000000000000000000001111111110000000000000"),
     ("00000000000000000000000000000000111111110000000000000"),
     ("00000000000000000000000000000000111111110000000000000"),
     ("00000000000000000000000000000000011111111000000000000"),
     ("00000000000000000000000000000000000111111000000000000"),
     ("00000000000000000000000000000000000011111000000000000"),
     ("00000000000000000000000000000000000000011000000000000")
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
		
