library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity helicopter_object is
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
end helicopter_object;

architecture behav of helicopter_object is 

constant object_X_size : integer := 85;
constant object_Y_size : integer := 52;
--constant R_high		: integer := 7;
--constant R_low		: integer := 5;
--constant G_high		: integer := 4;
--constant G_low		: integer := 2;
--constant B_high		: integer := 1;
--constant B_low		: integer := 0;

type ram_array is array(0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic_vector(7 downto 0);  

-- 8 bit - color definition : "RRRGGGBB"  
constant object_colors: ram_array := (
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"df",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"db",x"b7",x"b6",x"96",x"96",x"92",x"92",x"92",x"92",x"92",x"92",x"92",x"92",x"92",x"96",x"96",x"b6",x"b6",x"bb",x"db",x"db",x"df",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"72",x"4d",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"db",x"db",x"bb",x"b6",x"96",x"96",x"96",x"92",x"92",x"92",x"72",x"72",x"72",x"72",x"72",x"92",x"92",x"96",x"96",x"b7",x"db",x"db",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"92",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"6e",x"6e",x"4e",x"4e",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4e",x"6e",x"72",x"72",x"96",x"96",x"b7",x"bb",x"bb",x"6e",x"4d",x"92",x"db",x"db",x"db",x"b7",x"b6",x"96",x"92",x"72",x"72",x"72",x"6e",x"6e",x"4e",x"4e",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"6e",x"72",x"db",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"96",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"92",x"92",x"96",x"96",x"96",x"b6",x"b6",x"b6",x"b6",x"96",x"96",x"96",x"92",x"92",x"72",x"72",x"72",x"6e",x"6e",x"4d",x"4d",x"4d",x"4d",x"72",x"72",x"72",x"72",x"72",x"72",x"92",x"92",x"92",x"92",x"92",x"92",x"96",x"96",x"96",x"b6",x"b6",x"b6",x"b6",x"b6",x"96",x"96",x"92",x"92",x"72",x"72",x"4e",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"92",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"df",x"b6",x"72",x"92",x"96",x"b6",x"db",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b7",x"4d",x"4d",x"4d",x"72",x"72",x"72",x"72",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"bb",x"b6",x"92",x"6e",x"4e",x"92",x"df",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"fe",x"fe",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"df",x"db",x"72",x"4d",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"f8",x"f8",x"f8",x"f9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"72",x"4d",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"fe",x"f8",x"f8",x"f8",x"f8",x"fd",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"db",x"72",x"4d",x"72",x"db",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"f9",x"f8",x"f8",x"f8",x"f8",x"fd",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"bb",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"fd",x"f8",x"f8",x"f8",x"f8",x"f8",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"bb",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"4d",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"fe",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"fe",x"fe",x"fe",x"fe",x"fe",x"f9",x"b5",x"d5",x"d5",x"d5",x"d5",x"d5",x"d5",x"f9",x"fd",x"fd",x"fd",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"fe",x"fe",x"fe",x"fd",x"fd",x"f9",x"f9",x"f9",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"fd",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"f9",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"fe",x"fe",x"fe",x"fe",x"fd",x"fd",x"f9",x"f9",x"f9",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"fe",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"57",x"37",x"57",x"7b",x"9b",x"df",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"57",x"37",x"37",x"37",x"37",x"37",x"7b",x"df",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"f9",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"b9",x"9a",x"9a",x"9a",x"9a",x"9a",x"9a",x"d9",x"f8",x"f8",x"f8",x"57",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"7b",x"df",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"f9",x"f8",x"f8",x"f8",x"f8",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"9a",x"37",x"17",x"17",x"37",x"37",x"37",x"17",x"37",x"d9",x"f8",x"f8",x"57",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"bf",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"fe",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f9",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"17",x"76",x"f8",x"f8",x"57",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"17",x"7b",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"f8",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f9",x"f9",x"f9",x"f8",x"f8",x"f8",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"d9",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"77",x"f8",x"f8",x"57",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"17",x"13",x"13",x"57",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"f9",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f8",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"fe",x"fa",x"f9",x"f9",x"f9",x"f9",x"f9",x"f8",x"f8",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"d9",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"76",x"f8",x"f8",x"57",x"37",x"37",x"37",x"37",x"37",x"37",x"17",x"13",x"13",x"13",x"13",x"13",x"57",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"f9",x"f4",x"f4",x"f4",x"f4",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"d9",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"76",x"f8",x"f8",x"57",x"37",x"37",x"37",x"37",x"17",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"57",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f9",x"f4",x"f4",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"d9",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"76",x"f8",x"f8",x"57",x"37",x"37",x"17",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"7b",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f9",x"f4",x"f4",x"f4",x"f4",x"f8",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fa",x"f4",x"f4",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"d9",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"76",x"f8",x"f8",x"57",x"17",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"bb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fa",x"f4",x"f4",x"f4",x"f4",x"f9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f9",x"f4",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"d9",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"77",x"f8",x"f8",x"36",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"37",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f9",x"f9",x"f9",x"f9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"d9",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"56",x"f8",x"f4",x"36",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"77",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"d9",x"37",x"37",x"37",x"37",x"37",x"37",x"37",x"17",x"13",x"36",x"f4",x"f4",x"36",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"df",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fd",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"d9",x"37",x"37",x"37",x"37",x"37",x"37",x"17",x"13",x"13",x"36",x"f4",x"f4",x"36",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"57",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fd",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"d9",x"37",x"37",x"37",x"37",x"17",x"13",x"13",x"13",x"13",x"36",x"f4",x"f4",x"36",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"df",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"d9",x"37",x"37",x"17",x"13",x"13",x"13",x"13",x"13",x"13",x"56",x"f4",x"f4",x"36",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"9b",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f9",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"56",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"96",x"f4",x"f4",x"76",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"13",x"57",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f9",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"d5",x"56",x"33",x"33",x"33",x"33",x"33",x"33",x"76",x"f4",x"f4",x"f4",x"f4",x"76",x"33",x"33",x"33",x"33",x"33",x"33",x"33",x"33",x"33",x"33",x"33",x"33",x"33",x"33",x"33",x"33",x"33",x"57",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f8",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"f8",x"f8",x"f8",x"f8",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"f8",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f8",x"f8",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f8",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"f8",x"f4",x"f4",x"f4",x"f4",x"f4",x"f8",x"f4",x"d4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"d4",x"f4",x"f8",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f9",x"f4",x"f4",x"f4",x"f8",x"d5",x"6d",x"4d",x"b5",x"f8",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"6d",x"4d",x"91",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"f9",x"f4",x"f4",x"6d",x"4d",x"4d",x"b5",x"f8",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"6d",x"4d",x"4d",x"b1",x"f8",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b5",x"4d",x"4d",x"b1",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"f4",x"d4",x"6d",x"4d",x"6d",x"f4",x"f4",x"f4",x"f4",x"f8",x"f9",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"72",x"4d",x"72",x"ff",x"fe",x"fa",x"fa",x"fa",x"fa",x"fa",x"fa",x"fa",x"fa",x"fa",x"fa",x"fa",x"fa",x"fa",x"fa",x"d6",x"4d",x"4d",x"b5",x"fa",x"fe",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6e",x"4d",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"4e",x"4d",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"4d",x"4d",x"b7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"6e",x"4d",x"96",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"4d",x"4d",x"bb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"72",x"4d",x"96",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"4d",x"4d",x"bb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"72",x"4d",x"96",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"db",x"db",x"db",x"db",x"df",x"db",x"6e",x"4e",x"b6",x"df",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"72",x"4d",x"92",x"df",x"db",x"db",x"db",x"bb",x"96",x"72",x"72",x"96",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"92",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"72",x"92",x"b7",x"df",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"df",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"));

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
     ("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
     ("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
     ("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
     ("0000000000000001101111111111001100000000000011111000000000001110011111111100110000000"),
     ("0000000000011111111111111111111111111111100011111000111111111111111111111111111111000"),
     ("0000000000111111111111111111111111111111111111111111111111111111111111111111111111100"),
     ("0000000000111111111111111111111111111111111111111111111111111111111111111111111111100"),
     ("0000000000011111111111110000000000000111111111111110011100000000000001101111111111000"),
     ("0111110000000111100000000000000000000000001111111110000000000000000000000000111100000"),
     ("0111111000000000000000000000000000000000000011111000000000000000000000000000000000000"),
     ("0111111100000000000000000000000000000000001111111110000000000000000000000000000000000"),
     ("0111111110000000000000000000000000000000001111111110000000000000000000000000000000000"),
     ("0011111111000000000000000000000000000000001111111110000000000000000000000000000000000"),
     ("0011111111000000000000000000111111111111111111111111111100000000000000000000000000000"),
     ("0011111111100000011111111111111111111111111111111111111110000000000000000000000000000"),
     ("0011111111111111111111111111111111111111111111111111111110110000000000000000000000000"),
     ("0001111111111111111111111111111111111111111111111111111111111110000000000000000000000"),
     ("0001111111111111111111111111111111111111111111111111111111111111100000000000000000000"),
     ("0001111111111111111111111111111111111111111111111111111111111111111000000000000000000"),
     ("0000111111111111111111111111111111111111111111111111111111111111111100000000000000000"),
     ("0000111111111111111111111111111111111111111111111111111111111111111110000000000000000"),
     ("0000111111111111111111111111111111111111111111111111111111111111111111000000000000000"),
     ("0000011111111101111111111111111111111111111111111111111111111111111111100000000000000"),
     ("0000011111111000000000000111111111111111111111111111111111111111111111110000000000000"),
     ("0000011111111000000000000000000011111111111111111111111111111111111111111000000000000"),
     ("0000011111111000000000000000000001111111111111111111111111111111111111111000000000000"),
     ("0000001111110000000000000000000001111111111111111111111111111111111111111100000000000"),
     ("0000001111110000000000000000000011111111111111111111111111111111111111111110000000000"),
     ("0000000111100000000000000000000011111111111111111111111111111111111111111110000000000"),
     ("0000000000000000000000000000000011111111111111111111111111111111111111111111000000000"),
     ("0000000000000000000000000000000011111111111111111111111111111111111111111111000000000"),
     ("0000000000000000000000000000000011111111111111111111111111111111111111111111100000000"),
     ("0000000000000000000000000000000011111111111111111111111111111111111111111111100000000"),
     ("0000000000000000000000000000000001111111111111111111111111111111111111111111100000000"),
     ("0000000000000000000000000000000000111111111111111111111111111111111111111111100000000"),
     ("0000000000000000000000000000000000011111111111111111111111111111111111111111000000000"),
     ("0000000000000000000000000000000000001111111111111111111111111111111111111111000000000"),
     ("0000000000000000000000000000000000000111111111111111111111111111111111111111000000000"),
     ("0000000000000000000000000000000000000011111111111111111111111111111111111110000000000"),
     ("0000000000000000000000000000000000000001111111111111111111111111111111111100000000000"),
     ("0000000000000000000000000000000000000000011111111111111111111111111111111000000000000"),
     ("0000000000000000000000000000000000000000001111111111111111111111111111100000000000000"),
     ("0000000000000000000000000000000000000000001111000000000000000011110000000000000000000"),
     ("0000000000000000000000000000000000000000001111000000000000000011111000000000000000000"),
     ("0000000000000000000000000000000000000000001111000000000000000001111000000110000000000"),
     ("0000000000000000000000000000000000000000001111000000000000000001111000011111000000000"),
     ("0000000000000000000000000000000000011111111111111111111111111111111111111111000000000"),
     ("0000000000000000000000000000000000111111111111111111111111111111111111111110000000000"),
     ("0000000000000000000000000000000000011111111111111111111111111111111111111100000000000"),
     ("0000000000000000000000000000000000011111111111111111111111111111111111111000000000000"),
     ("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000"),
     ("0000000000000000000000000000000000000000000000000000000000000000000000000000000000000"));

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
		