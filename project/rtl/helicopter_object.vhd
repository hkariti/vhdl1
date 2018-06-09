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
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ed",x"f4",x"cc",x"6e",x"70",x"70",x"6d",x"9f",x"f8",x"f4",x"e6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e4",x"b2",x"d8",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e2",x"f7",x"f4",x"93",x"6d",x"70",x"6e",x"7c",x"ea",x"f3",x"f9",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f4",x"c4",x"a8",x"a9",x"a5",x"9b",x"9b",x"9b",x"9b",x"9d",x"b2",x"a9",x"94",x"d3",x"bd",x"f6",x"fc",x"ff",x"ff",x"ff",x"d8",x"88",x"c6",x"ff",x"ff",x"ff",x"f2",x"f4",x"b4",x"d9",x"8a",x"b0",x"ab",x"9d",x"9b",x"9c",x"9b",x"9c",x"aa",x"a8",x"c1",x"c6",x"f3",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f1",x"af",x"a1",x"a6",x"a3",x"a4",x"a4",x"a4",x"a4",x"a5",x"a5",x"a2",x"a2",x"a5",x"a0",x"a5",x"a8",x"c1",x"b2",x"f6",x"e9",x"c6",x"91",x"b6",x"e7",x"f1",x"ca",x"ac",x"a6",x"a1",x"a3",x"a7",x"a1",x"a1",x"9f",x"9f",x"9f",x"9f",x"9f",x"9e",x"9e",x"9e",x"a1",x"a3",x"f7",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d1",x"9f",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a3",x"9e",x"9b",x"9a",x"97",x"97",x"98",x"9a",x"9a",x"9b",x"93",x"ab",x"72",x"76",x"a7",x"7a",x"70",x"b6",x"a0",x"a6",x"a3",x"a2",x"9c",x"9a",x"97",x"97",x"97",x"99",x"9b",x"9b",x"9b",x"9b",x"9b",x"9b",x"9a",x"97",x"d8",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"bf",x"9f",x"a4",x"a4",x"a4",x"a3",x"a0",x"99",x"99",x"ad",x"c3",x"c3",x"c3",x"c4",x"b9",x"a0",x"9c",x"90",x"9c",x"97",x"9e",x"9e",x"a1",x"a7",x"aa",x"a4",x"a4",x"98",x"a1",x"a2",x"bd",x"c4",x"c3",x"c3",x"c2",x"aa",x"97",x"97",x"9b",x"9a",x"9b",x"9b",x"9a",x"a0",x"d9",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f3",x"ab",x"a3",x"a4",x"a0",x"a3",x"b8",x"bf",x"cb",x"fa",x"ff",x"ff",x"ff",x"ff",x"fe",x"f5",x"da",x"90",x"e8",x"c9",x"9f",x"9a",x"a1",x"a3",x"ad",x"ee",x"e4",x"9c",x"ef",x"f5",x"ff",x"ff",x"ff",x"ff",x"ff",x"f8",x"c2",x"c6",x"9f",x"9f",x"99",x"9a",x"99",x"c8",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e3",x"a2",x"a1",x"c1",x"e4",x"fa",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fc",x"a3",x"98",x"a2",x"a5",x"96",x"f5",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ef",x"de",x"b6",x"9a",x"b0",x"f6",x"ff",x"ff"),
     (x"ff",x"fc",x"f4",x"ff",x"ff",x"ff",x"ff",x"ff",x"d1",x"cf",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f3",x"d6",x"c5",x"9a",x"d0",x"e8",x"fd",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f9",x"c9",x"da",x"ff",x"ff",x"ff"),
     (x"ff",x"bd",x"8d",x"eb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d9",x"8c",x"c7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"fb",x"8e",x"75",x"bd",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d7",x"8d",x"c6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"f4",x"86",x"7b",x"93",x"fa",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"dd",x"8c",x"cb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"f8",x"8d",x"7c",x"7f",x"e3",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f5",x"82",x"89",x"9d",x"7f",x"9c",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"98",x"7c",x"7b",x"bd",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f8",x"96",x"90",x"9d",x"92",x"88",x"f5",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"a3",x"7b",x"7c",x"94",x"fa",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f9",x"a6",x"9a",x"9b",x"9c",x"92",x"f5",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ac",x"7a",x"7e",x"7e",x"dd",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fa",x"a5",x"99",x"9b",x"9b",x"91",x"f5",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"bd",x"7a",x"7f",x"7a",x"b9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f7",x"a8",x"9d",x"9f",x"9e",x"9f",x"f6",x"fd",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"cb",x"7a",x"7f",x"7c",x"91",x"fa",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fb",x"ea",x"d5",x"ce",x"b9",x"a4",x"91",x"86",x"86",x"86",x"85",x"8a",x"94",x"8f",x"bf",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"db",x"7c",x"7f",x"7f",x"7c",x"da",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f1",x"dd",x"c9",x"a6",x"94",x"88",x"7a",x"7a",x"7b",x"7b",x"7c",x"7e",x"7e",x"7e",x"7e",x"7e",x"7c",x"7a",x"8a",x"f4",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"e5",x"80",x"7e",x"7f",x"7a",x"b5",x"ff",x"ff",x"ff",x"fd",x"eb",x"db",x"be",x"9e",x"8e",x"7c",x"7a",x"7b",x"7c",x"7d",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7e",x"e1",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ee",x"84",x"7e",x"7f",x"7d",x"90",x"e3",x"d1",x"b3",x"9c",x"87",x"7b",x"7b",x"7b",x"7d",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7b",x"d4",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"f7",x"8c",x"7d",x"7f",x"7f",x"7e",x"7e",x"7d",x"7b",x"7b",x"7e",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7a",x"c8",x"df",x"de",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"fd",x"96",x"7c",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7a",x"c3",x"f4",x"e1",x"db",x"fd",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"a0",x"7b",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7a",x"c3",x"f6",x"f4",x"e2",x"d7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"af",x"7a",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7d",x"7a",x"7a",x"7a",x"7b",x"7f",x"7a",x"c3",x"f6",x"f1",x"f4",x"d7",x"e5",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"bd",x"7a",x"7f",x"7f",x"7d",x"7c",x"7c",x"7c",x"7c",x"7c",x"7c",x"7c",x"7c",x"7c",x"7c",x"7c",x"7c",x"7c",x"7c",x"7c",x"7f",x"7f",x"7f",x"7f",x"7d",x"8e",x"ab",x"a8",x"a9",x"a6",x"81",x"7a",x"c3",x"f6",x"f1",x"f1",x"f2",x"cb",x"fa",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"c9",x"7a",x"7b",x"78",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"7b",x"7f",x"7f",x"7f",x"7b",x"c0",x"fb",x"f7",x"f7",x"f8",x"aa",x"76",x"c3",x"f6",x"f1",x"f1",x"f3",x"e2",x"d8",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"d7",x"75",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"78",x"7f",x"7f",x"7e",x"84",x"e2",x"f3",x"f1",x"f1",x"f6",x"cb",x"77",x"c3",x"f6",x"f1",x"f1",x"f1",x"f3",x"ce",x"f2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"dc",x"75",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"78",x"7f",x"7f",x"7d",x"8f",x"ee",x"f2",x"f1",x"f1",x"f4",x"da",x"7b",x"c2",x"f6",x"f1",x"f1",x"f1",x"f3",x"e2",x"e4",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"eb",x"7b",x"76",x"77",x"77",x"77",x"75",x"76",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"7e",x"7f",x"7c",x"98",x"f2",x"f1",x"f1",x"f1",x"f4",x"dd",x"7b",x"c2",x"f6",x"f1",x"f1",x"f1",x"f1",x"ef",x"d5",x"f7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"f5",x"83",x"75",x"77",x"77",x"78",x"82",x"79",x"70",x"73",x"75",x"76",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"7e",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f3",x"e3",x"80",x"c2",x"f6",x"f1",x"f1",x"f1",x"ef",x"ea",x"d3",x"dd",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"fd",x"8e",x"74",x"77",x"75",x"7f",x"e4",x"d9",x"c2",x"a1",x"84",x"7c",x"72",x"72",x"75",x"76",x"77",x"77",x"77",x"77",x"77",x"7e",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f3",x"e3",x"80",x"c2",x"f6",x"f1",x"f1",x"f0",x"ea",x"e8",x"e5",x"c7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"99",x"73",x"77",x"74",x"86",x"f8",x"ff",x"ff",x"ff",x"f8",x"e1",x"c3",x"a9",x"88",x"7b",x"74",x"73",x"77",x"77",x"78",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f3",x"e3",x"80",x"c2",x"f6",x"f1",x"f1",x"ec",x"e8",x"e8",x"eb",x"c9",x"ef",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"a2",x"72",x"77",x"74",x"91",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f9",x"e5",x"c4",x"94",x"74",x"77",x"78",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f3",x"e3",x"80",x"c2",x"f6",x"f1",x"ef",x"e8",x"e8",x"e8",x"ea",x"db",x"d7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"b4",x"72",x"77",x"73",x"a1",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"eb",x"7d",x"76",x"7a",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f3",x"e3",x"80",x"c2",x"f6",x"f0",x"e9",x"e8",x"e8",x"e8",x"e8",x"e7",x"f1",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"c3",x"71",x"77",x"72",x"af",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"9b",x"73",x"7a",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f3",x"e3",x"80",x"c2",x"f6",x"eb",x"e8",x"e8",x"e8",x"e8",x"e8",x"e9",x"e2",x"f7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"d4",x"73",x"77",x"71",x"c1",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b0",x"71",x"7c",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f3",x"e3",x"80",x"c2",x"f2",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"ea",x"d8",x"e9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"e0",x"77",x"76",x"73",x"d1",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"bc",x"72",x"7e",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f3",x"e3",x"81",x"c1",x"ed",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"eb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"e9",x"7a",x"76",x"76",x"df",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"73",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f3",x"e3",x"81",x"bb",x"ec",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e7",x"e4",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"f3",x"80",x"73",x"7c",x"ef",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"a2",x"76",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f3",x"e3",x"7c",x"b9",x"ed",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e9",x"dd",x"f6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"fd",x"a0",x"76",x"9c",x"fd",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fd",x"91",x"7a",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f3",x"e1",x"79",x"b9",x"ed",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e6",x"f5",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"f5",x"e0",x"f2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f1",x"83",x"7d",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f2",x"dc",x"79",x"b9",x"ed",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e4",x"e2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e1",x"7e",x"7f",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"ee",x"db",x"79",x"b9",x"ed",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e7",x"dd",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"dd",x"7c",x"7f",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"ef",x"ea",x"db",x"79",x"b9",x"ed",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e9",x"da",x"fc",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"dd",x"7c",x"7f",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f0",x"e9",x"ea",x"db",x"79",x"b9",x"ed",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e9",x"dd",x"f8",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"dd",x"7c",x"7f",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f2",x"eb",x"e8",x"ea",x"db",x"79",x"b9",x"ed",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e3",x"f5",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"df",x"7d",x"7f",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"ed",x"e8",x"e8",x"ea",x"db",x"79",x"b9",x"ed",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e9",x"df",x"e8",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f4",x"8a",x"7d",x"7f",x"7f",x"7f",x"7d",x"94",x"ee",x"e9",x"e8",x"e8",x"eb",x"d6",x"75",x"bb",x"ed",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e9",x"df",x"db",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"9f",x"7b",x"7f",x"7f",x"7f",x"7d",x"8b",x"e4",x"e9",x"e8",x"e8",x"ec",x"cb",x"71",x"b0",x"ed",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e7",x"ef",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"c1",x"7a",x"7f",x"7f",x"7f",x"7f",x"7b",x"d1",x"ed",x"ea",x"ea",x"ef",x"b7",x"6e",x"9c",x"ee",x"ea",x"ea",x"ea",x"ea",x"ea",x"ea",x"ea",x"ea",x"ea",x"e7",x"c6",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e1",x"7f",x"7e",x"7f",x"7f",x"7d",x"73",x"a2",x"df",x"db",x"dc",x"d7",x"8b",x"74",x"7d",x"c9",x"de",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"db",x"d9",x"de",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fa",x"93",x"7c",x"7f",x"7e",x"79",x"77",x"77",x"7a",x"7a",x"7a",x"79",x"76",x"77",x"76",x"78",x"7a",x"7a",x"7a",x"7a",x"7a",x"7a",x"7a",x"7a",x"7a",x"75",x"c8",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b2",x"7a",x"7f",x"7b",x"77",x"77",x"77",x"76",x"76",x"76",x"76",x"77",x"77",x"77",x"77",x"76",x"76",x"76",x"76",x"76",x"76",x"76",x"76",x"76",x"71",x"c5",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d5",x"7c",x"7c",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"72",x"d0",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f7",x"8d",x"75",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"76",x"e0",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b0",x"71",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"76",x"7b",x"ea",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e1",x"77",x"77",x"77",x"77",x"77",x"76",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"76",x"76",x"77",x"77",x"77",x"77",x"77",x"74",x"89",x"f8",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"a4",x"72",x"77",x"77",x"79",x"7d",x"76",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"79",x"78",x"77",x"77",x"77",x"77",x"77",x"72",x"a9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e0",x"78",x"76",x"75",x"86",x"97",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"75",x"89",x"97",x"78",x"77",x"77",x"77",x"77",x"74",x"d6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b3",x"72",x"76",x"92",x"97",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"76",x"91",x"9d",x"7f",x"76",x"77",x"77",x"74",x"89",x"f8",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f8",x"93",x"79",x"9c",x"97",x"78",x"77",x"77",x"77",x"77",x"77",x"77",x"76",x"8b",x"9e",x"85",x"76",x"77",x"77",x"72",x"c3",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e7",x"91",x"9c",x"8f",x"76",x"77",x"77",x"77",x"77",x"77",x"77",x"76",x"7d",x"9c",x"90",x"76",x"77",x"72",x"92",x"f7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"bd",x"9a",x"83",x"70",x"72",x"72",x"72",x"72",x"72",x"72",x"71",x"71",x"92",x"97",x"72",x"71",x"8d",x"eb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"c6",x"98",x"cb",x"ae",x"aa",x"aa",x"aa",x"aa",x"aa",x"aa",x"ab",x"a6",x"8f",x"9b",x"a5",x"ba",x"f4",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fb",x"9a",x"a6",x"fa",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ad",x"9e",x"f9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"b5",x"a6",x"fb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d0",x"96",x"e7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b8",x"8a",x"ee",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d6",x"8b",x"cb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"af",x"a8",x"fb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e2",x"8c",x"cc",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ae",x"b3",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e1",x"8c",x"cc",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ae",x"b2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e1",x"8c",x"cc",x"ff",x"ff",x"ff",x"f7",x"ca",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ae",x"b2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e2",x"8c",x"cd",x"ff",x"ff",x"ff",x"c4",x"a0",x"f6",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fa",x"ec",x"ec",x"ec",x"ee",x"ad",x"b1",x"ed",x"ec",x"ec",x"ec",x"ec",x"ec",x"ec",x"ec",x"ec",x"ec",x"d8",x"8f",x"c0",x"f0",x"f4",x"bd",x"aa",x"aa",x"f7",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"c9",x"5c",x"60",x"5f",x"6a",x"a4",x"a3",x"67",x"5f",x"60",x"60",x"60",x"60",x"60",x"60",x"60",x"5d",x"8a",x"aa",x"74",x"74",x"c6",x"a0",x"a1",x"b9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"bd",x"a5",x"a8",x"a8",x"a7",x"a4",x"a4",x"a8",x"a8",x"a8",x"a8",x"a8",x"a8",x"a8",x"a8",x"a8",x"a8",x"a5",x"a4",x"a7",x"a7",x"a1",x"a4",x"a3",x"d8",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e4",x"a2",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a4",x"a2",x"a7",x"f4",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f6",x"a8",x"a1",x"a2",x"a2",x"a2",x"a2",x"a2",x"a2",x"a2",x"a2",x"a2",x"a2",x"a2",x"a2",x"a2",x"a2",x"a2",x"a2",x"a2",x"a2",x"a4",x"aa",x"cf",x"fc",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fc",x"bd",x"62",x"66",x"66",x"66",x"66",x"66",x"66",x"66",x"66",x"66",x"66",x"66",x"66",x"66",x"66",x"66",x"66",x"66",x"62",x"9a",x"f2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"));


-- one bit mask  0 - off 1 dispaly 
type object_form is array (0 to object_Y_size - 1 , 0 to object_X_size - 1) of std_logic;
constant object : object_form := (
     ("0000000000000000000000000000000000000000000000000000"),
     ("0000000000000000000000000000000000000000000000000000"),
     ("0000000000000000000000000000000000000000000000000000"),
     ("0000000000000000000000000000000000000000000000000000"),
     ("0000000000000000000000000000000000000000000000000000"),
     ("0000000000000000000000000000000000000000000000000000"),
     ("0000000001111111111100000001110000000111111111110000"),
     ("0000000111111111111111110001110001111111111111111100"),
     ("0000001111111111111111111111111111111111111111111110"),
     ("0000001111111111111111111111111111111111111111111110"),
     ("0000001111111111111111111111111111111111111111111110"),
     ("0000001111111111000011111111111111110000011111111100"),
     ("0000000111111000000000000111111100000000000011111100"),
     ("0110000011000000000000000111111100000000000000111000"),
     ("0111000000000000000000000001110000000000000000000000"),
     ("1111000000000000000000000001110000000000000000000000"),
     ("1111100000000000000000000001110000000000000000000000"),
     ("1111100000000000000000000111111100000000000000000000"),
     ("0111100000000000000000000111111100000000000000000000"),
     ("0111110000000000000000000111111100000000000000000000"),
     ("0111110000000000000000000111111100000000000000000000"),
     ("0111110000000000000000000111111110000000000000000000"),
     ("0111111000000000000111111111111111000000000000000000"),
     ("0111111000000001111111111111111111100000000000000000"),
     ("0111111000111111111111111111111111100000000000000000"),
     ("0111111111111111111111111111111111100000000000000000"),
     ("0111111111111111111111111111111111111100000000000000"),
     ("0111111111111111111111111111111111111110000000000000"),
     ("0011111111111111111111111111111111111110000000000000"),
     ("0011111111111111111111111111111111111111000000000000"),
     ("0011111111111111111111111111111111111111100000000000"),
     ("0011111111111111111111111111111111111111100000000000"),
     ("0011111111111111111111111111111111111111110000000000"),
     ("0011111111111111111111111111111111111111110000000000"),
     ("0011111111111111111111111111111111111111111000000000"),
     ("0011111111111111111111111111111111111111111000000000"),
     ("0011111111111111111111111111111111111111111000000000"),
     ("0001111110001111111111111111111111111111111100000000"),
     ("0001111110000000111111111111111111111111111100000000"),
     ("0001111100000000000111111111111111111111111100000000"),
     ("0001111100000000000011111111111111111111111110000000"),
     ("0001111100000000000011111111111111111111111110000000"),
     ("0001111100000000000011111111111111111111111110000000"),
     ("0001111100000000000011111111111111111111111110000000"),
     ("0001111100000000000011111111111111111111111111000000"),
     ("0001111100000000000111111111111111111111111111000000"),
     ("0000111000000000000111111111111111111111111111000000"),
     ("0000000000000000000111111111111111111111111111000000"),
     ("0000000000000000000111111111111111111111111111100000"),
     ("0000000000000000000111111111111111111111111111100000"),
     ("0000000000000000000111111111111111111111111111100000"),
     ("0000000000000000000111111111111111111111111111100000"),
     ("0000000000000000000111111111111111111111111111100000"),
     ("0000000000000000000011111111111111111111111111100000"),
     ("0000000000000000000011111111111111111111111111100000"),
     ("0000000000000000000011111111111111111111111111100000"),
     ("0000000000000000000011111111111111111111111111100000"),
     ("0000000000000000000001111111111111111111111111100000"),
     ("0000000000000000000001111111111111111111111111100000"),
     ("0000000000000000000001111111111111111111111111100000"),
     ("0000000000000000000000111111111111111111111111100000"),
     ("0000000000000000000000111111111111111111111111100000"),
     ("0000000000000000000000011111111111111111111111000000"),
     ("0000000000000000000000011111111111111111111111000000"),
     ("0000000000000000000000001111111111111111111111000000"),
     ("0000000000000000000000001111111111111111111110000000"),
     ("0000000000000000000000000111111111111111111110000000"),
     ("0000000000000000000000000011111111111111111100000000"),
     ("0000000000000000000000000011111111111111111000000000"),
     ("0000000000000000000000000111100000000011100000000000"),
     ("0000000000000000000000000111100000000011100000000000"),
     ("0000000000000000000000000011100000000011100000000000"),
     ("0000000000000000000000000011100000000011100000000000"),
     ("0000000000000000000000000011000000000011100000000000"),
     ("0000000000000000000000000011000000000011100011000000"),
     ("0000000000000000000000000011000000000011100011100000"),
     ("0000000000000000000001111111111111111111111111100000"),
     ("0000000000000000000001111111111111111111111111000000"),
     ("0000000000000000000001111111111111111111111111000000"),
     ("0000000000000000000001111111111111111111111111000000"),
     ("0000000000000000000001111111111111111111111111000000"),
     ("0000000000000000000001111111111111111111111100000000"),
     ("0000000000000000000000000000000000000000000000000000"),
     ("0000000000000000000000000000000000000000000000000000"),
     ("0000000000000000000000000000000000000000000000000000"),
     ("0000000000000000000000000000000000000000000000000000"));

signal bCoord_X : integer := 0;-- offset from start position 
signal bCoord_Y : integer := 0;

signal drawing_X : std_logic := '0';
signal drawing_Y : std_logic := '0';

--		
signal objectEndX : integer;
signal objectEndY : integer;

begin

-- Calculate object end boundaries
objectEndX	<= 2*object_X_size+ObjectStartX;
objectEndY	<= 2*object_Y_size+ObjectStartY;

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
			mVGA_RGB	<=  object_colors(to_integer(shift_right(to_unsigned(bCoord_Y, 32), 1)),
												to_integer(shift_right(to_unsigned(bCoord_X, 32), 1)));	--get from colors table 
			drawing_request	<= object(to_integer(shift_right(to_unsigned(bCoord_Y, 32), 1)),
												 to_integer(shift_right(to_unsigned(bCoord_X, 32), 1))) and drawing_X and drawing_Y ; -- get from mask table if inside rectangle  
	end if;

  end process;

		
end behav;		
		
