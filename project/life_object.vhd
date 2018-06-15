library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity life_object is
port 	(
		--////////////////////	Clock Input	 	////////////////////	
	   	CLK  		: in std_logic;
		RESETn		: in std_logic;
		oCoord_X	: in integer;
		oCoord_Y	: in integer;
		ObjectStartX	: in integer;
		life_on : in std_logic;
		drawing_request	: out std_logic ;
		mVGA_RGB 	: out std_logic_vector(7 downto 0) 
	);
end life_object;

architecture behav of life_object is 

constant ObjectStartY  : integer := 15;
constant object_X_size : integer := 76;
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
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"db",x"da",x"b6",x"b6",x"da",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"b6",x"95",x"95",x"95",x"b9",x"b9",x"b9",x"b9",x"b9",x"b5",x"95",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"95",x"b5",x"b9",x"b9",x"dd",x"b9",x"b9",x"dd",x"bd",x"b9",x"dd",x"dd",x"b9",x"b9",x"95",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"95",x"b9",x"dd",x"dd",x"b9",x"bd",x"bd",x"b9",x"bd",x"dd",x"b9",x"b9",x"dd",x"b9",x"b9",x"b9",x"95",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"95",x"b9",x"b9",x"b9",x"dd",x"b9",x"b9",x"dd",x"b9",x"b9",x"dd",x"dd",x"b9",x"dd",x"dd",x"b9",x"bd",x"b9",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ba",x"b9",x"bd",x"dd",x"b9",x"bd",x"dd",x"bd",x"b9",x"b9",x"b9",x"b9",x"b9",x"b9",x"b9",x"b9",x"b9",x"b9",x"dd",x"b9",x"96",x"ba",x"ba",x"da",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"95",x"bd",x"b9",x"dd",x"bd",x"b9",x"95",x"90",x"90",x"b0",x"8c",x"ce",x"ce",x"ce",x"ce",x"ce",x"ad",x"ad",x"b1",x"95",x"95",x"b9",x"b9",x"b9",x"95",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"b9",x"dd",x"b9",x"b9",x"95",x"8d",x"ac",x"f4",x"f4",x"f4",x"ad",x"f2",x"f2",x"f2",x"ce",x"ce",x"f2",x"f2",x"f2",x"ee",x"ce",x"8d",x"90",x"b9",x"dd",x"95",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"95",x"95",x"b9",x"b9",x"dd",x"b9",x"8d",x"ee",x"f2",x"ad",x"f4",x"f4",x"d0",x"ce",x"f2",x"f2",x"ce",x"d0",x"d0",x"ce",x"f2",x"f2",x"f2",x"f2",x"ad",x"d0",x"b0",x"91",x"b9",x"da",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"95",x"bd",x"b9",x"dd",x"bd",x"99",x"ad",x"f2",x"f2",x"f2",x"ee",x"cd",x"cd",x"ce",x"f2",x"f2",x"f2",x"ee",x"ad",x"ac",x"ee",x"f2",x"ad",x"cd",x"f2",x"ad",x"f4",x"f4",x"d0",x"68",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"b9",x"b9",x"bd",x"b9",x"ad",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"f2",x"f2",x"f2",x"f2",x"ee",x"f2",x"ad",x"f4",x"d0",x"ce",x"ce",x"d0",x"f4",x"b0",x"ce",x"ce",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"95",x"b9",x"ba",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"95",x"b9",x"b9",x"8d",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"cd",x"b0",x"ad",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"f4",x"d0",x"ce",x"f2",x"ce",x"ad",x"ee",x"f2",x"f2",x"ce",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"b6",x"b9",x"b9",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"8d",x"ee",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"cd",x"b0",x"ad",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"cd",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"95",x"dd",x"b9",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ee",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"d7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"da",x"b9",x"dd",x"dd",x"95",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ae",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"b1",x"b1",x"6d",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"b6",x"b9",x"bd",x"dd",x"b9",x"96",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"ee",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ee",x"91",x"95",x"70",x"70",x"95",x"91",x"ff",x"b6",x"6d",x"92",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"95",x"dd",x"bd",x"bd",x"dd",x"b9",x"96",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ae",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"f2",x"f2",x"f2",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"91",x"95",x"6c",x"b9",x"b9",x"b9",x"95",x"92",x"b6",x"ff",x"ff",x"b6",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"95",x"dd",x"bd",x"bd",x"bd",x"dd",x"b9",x"b9",x"95",x"95",x"b5",x"b6",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"ee",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"ce",x"f2",x"f2",x"f2",x"ad",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"b9",x"6c",x"b9",x"dd",x"dd",x"dd",x"bd",x"6d",x"ff",x"db",x"b6",x"b6",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"b5",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"dd",x"dd",x"bd",x"b9",x"95",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ae",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"f2",x"f2",x"f2",x"ae",x"ee",x"f2",x"f2",x"ad",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"91",x"dd",x"95",x"bd",x"bd",x"95",x"b6",x"b5",x"95",x"6d",x"db",x"ff",x"ff",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"b5",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"dd",x"b9",x"95",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"ee",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"ce",x"f2",x"f2",x"f2",x"ad",x"f2",x"f2",x"ce",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"b9",x"dd",x"dd",x"dd",x"95",x"db",x"ff",x"ff",x"95",x"4c",x"ff",x"ff",x"ff",x"db",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"db",x"b5",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"95",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"ae",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"f2",x"f2",x"f2",x"ce",x"ce",x"f2",x"f2",x"ad",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"b1",x"bd",x"bd",x"bd",x"b9",x"b6",x"ff",x"ff",x"ff",x"db",x"70",x"92",x"db",x"ff",x"ff",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"db",x"b5",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"ee",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"f2",x"f2",x"f2",x"ce",x"ee",x"f2",x"ee",x"ce",x"f2",x"ae",x"f2",x"f2",x"f2",x"f2",x"f2",x"ee",x"91",x"dd",x"bd",x"dd",x"b9",x"ba",x"ff",x"db",x"ff",x"ff",x"b5",x"48",x"00",x"6d",x"db",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"db",x"b5",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"95",x"db",x"ff",x"ff",x"ff",x"ff",x"df",x"ae",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"f2",x"f2",x"f2",x"ad",x"f2",x"f2",x"ce",x"ce",x"f2",x"ad",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"b5",x"dd",x"bd",x"dd",x"b9",x"b6",x"6d",x"00",x"49",x"ff",x"b5",x"95",x"00",x"24",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"b5",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"b6",x"ff",x"ff",x"ff",x"ff",x"b6",x"ee",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"f2",x"f2",x"f2",x"ce",x"f2",x"f2",x"ce",x"f2",x"ce",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"b9",x"dd",x"bd",x"bd",x"dd",x"95",x"20",x"00",x"24",x"b6",x"b9",x"dd",x"48",x"6d",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"95",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"95",x"ff",x"ff",x"ff",x"ff",x"ae",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ae",x"f2",x"f2",x"f2",x"ce",x"f2",x"f2",x"ce",x"f2",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"b9",x"dd",x"bd",x"bd",x"dd",x"b9",x"48",x"00",x"4d",x"b5",x"dd",x"dd",x"95",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"b6",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"db",x"ff",x"ff",x"b6",x"ee",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"f2",x"f2",x"f2",x"ae",x"f2",x"f2",x"ce",x"f2",x"ad",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"b9",x"dd",x"bd",x"bd",x"bd",x"dd",x"dd",x"b9",x"b9",x"dd",x"bd",x"bd",x"bd",x"71",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"db",x"95",x"dd",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"b6",x"ff",x"df",x"ae",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"f2",x"f2",x"f2",x"ad",x"f2",x"f2",x"ce",x"ee",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"dd",x"dd",x"dd",x"bd",x"bd",x"bd",x"dd",x"95",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"da",x"95",x"b9",x"bd",x"dd",x"dd",x"dd",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"b9",x"b6",x"ff",x"b2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"ce",x"f2",x"f2",x"ce",x"ce",x"f2",x"ce",x"ce",x"ce",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"b9",x"dd",x"bd",x"bd",x"bd",x"dd",x"b9",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"dd",x"91",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"b6",x"b5",x"95",x"b9",x"b9",x"b9",x"b9",x"dd",x"dd",x"dd",x"dd",x"dd",x"bd",x"bd",x"bd",x"91",x"ae",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"f2",x"f2",x"f2",x"ce",x"f2",x"f2",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"b9",x"dd",x"bd",x"bd",x"bd",x"dd",x"b9",x"95",x"dd",x"bd",x"bd",x"bd",x"bd",x"dd",x"dd",x"95",x"91",x"db",x"ff",x"ff",x"b6",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"b6",x"91",x"6d",x"6c",x"71",x"95",x"95",x"95",x"b9",x"dd",x"dd",x"b9",x"ad",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"b9",x"dd",x"bd",x"bd",x"dd",x"b9",x"71",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"95",x"91",x"91",x"95",x"91",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"db",x"b6",x"95",x"b9",x"b9",x"b9",x"b9",x"b9",x"b9",x"b9",x"b9",x"b9",x"bd",x"bd",x"bd",x"b1",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"b9",x"dd",x"bd",x"bd",x"dd",x"b9",x"95",x"95",x"dd",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"dd",x"dd",x"dd",x"dd",x"91",x"ff"),
     (x"ff",x"ff",x"ff",x"95",x"b9",x"b9",x"dd",x"dd",x"dd",x"dd",x"bd",x"bd",x"bd",x"dd",x"dd",x"bd",x"bd",x"dd",x"b9",x"8d",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"b5",x"dd",x"bd",x"bd",x"bd",x"dd",x"dd",x"4c",x"28",x"b9",x"dd",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"dd",x"b9",x"6d",x"ff"),
     (x"ff",x"ff",x"95",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"b6",x"db",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ee",x"95",x"dd",x"bd",x"bd",x"bd",x"bd",x"dd",x"6c",x"00",x"00",x"4c",x"b9",x"dd",x"dd",x"dd",x"dd",x"dd",x"dd",x"b9",x"95",x"95",x"91",x"ff"),
     (x"ff",x"b6",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"95",x"ff",x"ff",x"ae",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"91",x"dd",x"bd",x"bd",x"bd",x"bd",x"dd",x"91",x"00",x"00",x"00",x"00",x"28",x"6c",x"91",x"95",x"71",x"95",x"95",x"b9",x"b5",x"b6",x"ff"),
     (x"ff",x"95",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"b5",x"ff",x"ff",x"b6",x"ee",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"91",x"91",x"ce",x"f2",x"b1",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"28",x"bd",x"dd",x"bd",x"91",x"ff",x"ff"),
     (x"ff",x"95",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"b6",x"ff",x"ff",x"ff",x"ae",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"d2",x"95",x"dd",x"b9",x"ad",x"f2",x"ad",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"dd",x"4c",x"00",x"00",x"00",x"00",x"00",x"00",x"00",x"95",x"dd",x"dd",x"95",x"db",x"ff",x"ff"),
     (x"ff",x"95",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"da",x"ff",x"ff",x"ff",x"b6",x"ee",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"b1",x"b9",x"dd",x"bd",x"ad",x"f2",x"ce",x"b5",x"dd",x"bd",x"bd",x"bd",x"bd",x"dd",x"dd",x"6c",x"00",x"00",x"00",x"00",x"00",x"95",x"dd",x"dd",x"95",x"b6",x"ff",x"ff",x"ff"),
     (x"ff",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b5",x"db",x"ff",x"ff",x"ff",x"ff",x"ae",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"d2",x"95",x"dd",x"bd",x"b9",x"ad",x"f2",x"f2",x"91",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"dd",x"b9",x"71",x"6c",x"70",x"b9",x"dd",x"dd",x"b5",x"96",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"b5",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"95",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"b1",x"95",x"bd",x"bd",x"dd",x"b9",x"ad",x"f2",x"f2",x"ad",x"bd",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"dd",x"dd",x"dd",x"dd",x"dd",x"b9",x"91",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"95",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"95",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"ee",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"d2",x"91",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"91",x"f2",x"f2",x"ce",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"bd",x"71",x"fb",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"95",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"ee",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"d2",x"95",x"bd",x"dd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"ad",x"f2",x"f2",x"91",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"91",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"b6",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"95",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"91",x"bd",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"95",x"ee",x"f2",x"ad",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"96",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"db",x"95",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"b2",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"ad",x"f2",x"f2",x"91",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"91",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"b6",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"bd",x"95",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"ae",x"ee",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"b1",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"ad",x"f2",x"f2",x"ce",x"95",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"dd",x"91",x"fb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"95",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"95",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"91",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"ad",x"f2",x"f2",x"f2",x"ad",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"dd",x"91",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"b5",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"95",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"95",x"bd",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"b9",x"ad",x"f2",x"f2",x"f2",x"f2",x"8d",x"b9",x"dd",x"dd",x"dd",x"dd",x"91",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"95",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"dd",x"95",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"df",x"b2",x"ce",x"ee",x"f2",x"f2",x"f2",x"f2",x"f2",x"91",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"95",x"ce",x"f2",x"f2",x"f2",x"f2",x"f2",x"ad",x"95",x"b9",x"b9",x"95",x"ba",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"db",x"b5",x"dd",x"bd",x"bd",x"dd",x"dd",x"b9",x"95",x"ba",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"b2",x"ae",x"ce",x"ee",x"f2",x"91",x"b9",x"b9",x"dd",x"bd",x"bd",x"bd",x"bd",x"bd",x"dd",x"bd",x"91",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"f2",x"ce",x"6d",x"92",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"95",x"dd",x"dd",x"dd",x"dd",x"b9",x"95",x"b6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"d6",x"b2",x"8d",x"95",x"b9",x"bd",x"dd",x"bd",x"bd",x"bd",x"dd",x"bd",x"99",x"ad",x"f2",x"f2",x"ee",x"ee",x"ce",x"ce",x"b2",x"d6",x"fb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"db",x"95",x"b9",x"b9",x"95",x"95",x"b6",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"da",x"95",x"b9",x"b9",x"dd",x"dd",x"dd",x"bd",x"99",x"71",x"b2",x"b2",x"b6",x"d6",x"db",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"db",x"db",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b6",x"95",x"95",x"95",x"95",x"95",x"96",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"db",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff")
);

-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
     ("0000000000000000000000000000000000000011111110000000000000000000000000000000"),
     ("0000000000000000000000000000000000111111111111100000000000000000000000000000"),
     ("0000000000000000000000000000000001111111111111110000000000000000000000000000"),
     ("0000000000000000000000000000000011111111111111111000000000000000000000000000"),
     ("0000000000000000000000000000000111111111111111111100000000000000000000000000"),
     ("0000000000000000000000000000001111111111111111111111110000000000000000000000"),
     ("0000000000000000000000000000001111111111111111111111111100000000000000000000"),
     ("0000000000000000000000000000011111111111111111111111111100000000000000000000"),
     ("0000000000000000000000000011111111111111111111111111111110000000000000000000"),
     ("0000000000000000000000000011111111111111111111111111111110000000000000000000"),
     ("0000100000000000000000000011111111111111111111111111111111000000000000000000"),
     ("0001110000000000000000000001111111111111111111111111111111100000000000000000"),
     ("0011110000000000000000000000111111111111111111111111111111110000000000000000"),
     ("0011110000000000000000000000111111111111111111111111111111111000000000000000"),
     ("0111111000000000000000000000111111111111111111111111111111111100000000000000"),
     ("0111111000000000000000000001111111111111111111111111111111111101111000000000"),
     ("0111111110000000000000000001111111111111111111111111111111111111111100000000"),
     ("0111111111111100000000000011111111111111111111111111111111111111111100000000"),
     ("0111111111111110000000000011111111111111111111111111111111111111111100000000"),
     ("0111111111111111000000000111111111111111111111111111111111111111111110000000"),
     ("1111111111111111100000001111111111111111111111111111111111111111111110000000"),
     ("1111111111111111110000001111111111111111111111111111111111111111111110000000"),
     ("1111111111111111111000011111111111111111111111111111111111111111111100000000"),
     ("0111111111111111111000011111111111111111111111111111111111111111111100000000"),
     ("0111111111111111111000011111111111111111111111111111111111111111111000000000"),
     ("0111111111111111111100111111111111111111111111111111111111111111111000000000"),
     ("0111111111111111111101111111111111111111111111111111111111111111111100000000"),
     ("0011111111111111111101111111111111111111111111111111111111111111111110000000"),
     ("0000111111111111111111111111111111111111111111111111111111111111111111100100"),
     ("0000001111111111111111111111111111111111111111111111111111111111111111111110"),
     ("0000111111111111111111111111111111111111111111111111111111111111111111111110"),
     ("0001111111111111111111111111111111111111111111111111111111111111111111111110"),
     ("0011111111111111111111111111111111111111111111111111111111111111111111111110"),
     ("0111111111111111110011111111111111111111111111111111111111111111111111111110"),
     ("0111111111111111110011111111111111111111111111111111111111111111111111111100"),
     ("0111111111111111110001111111111111111111111111111111111111111111111111111100"),
     ("0111111111111111110001111111111111111111111111111111111111111111111111111000"),
     ("0111111111111111110000111111111111111111111111111111111111111111111111110000"),
     ("0111111111111111100000111111111111111111111111111111111111111111111111100000"),
     ("0111111111111111100000011111111111111111111111111111111111111111111111100000"),
     ("0111111111111111100000001111111111111111111111111111111111111111111111000000"),
     ("0111111111111111000000000111111111111111111111111111111111111111111110000000"),
     ("0111111111111111000000000011111111111111111111111111111111111111111100000000"),
     ("0011111111111110000000000001111111111111111111111111111111111111111100000000"),
     ("0001111111111110000000000000011111111111111111111111111111111111111000000000"),
     ("0001111111111100000000000000000111111111111111111111111111111111110000000000"),
     ("0001111111111000000000000000000011111111111111111111111111111111100000000000"),
     ("0011111111110000000000000000000000011111111111111111111111111110000000000000"),
     ("0011111111000000000000000000000000000011111111111111111111111100000000000000"),
     ("0111111110000000000000000000000000000000001111111111111111000000000000000000"),
     ("0001110000000000000000000000000000000000000011111110000000000000000000000000"),
     ("0000000000000000000000000000000000000000000000011000000000000000000000000000")
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
objectEndX	<= object_X_size/2+ObjectStartX;
objectEndY	<= object_Y_size/2+ObjectStartY;

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
			if life_on = '1' then
				mVGA_RGB	<=  object_colors(bCoord_Y*2, bCoord_X*2);	--get from colors table 
				drawing_request	<= object(bCoord_Y*2, bCoord_X*2) and drawing_X and drawing_Y ; -- get from mask table if inside rectangle  
		end if;
	end if;

  end process;

		
end behav;		
		
