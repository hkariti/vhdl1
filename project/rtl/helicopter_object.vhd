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
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fc",x"f9",x"ff",x"fd",x"d9",x"d0",x"d1",x"d1",x"d1",x"d1",x"d1",x"d1",x"f5",x"ff",x"ff",x"fc",x"f7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"ef",x"ec",x"e7",x"fc",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"f7",x"fc",x"ff",x"ff",x"f4",x"d1",x"d1",x"d1",x"d1",x"d1",x"d1",x"cf",x"e7",x"ff",x"ff",x"fa",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f4",x"f2",x"c2",x"dd",x"b5",x"9e",x"cb",x"b3",x"91",x"88",x"89",x"89",x"89",x"89",x"89",x"89",x"aa",x"ba",x"ce",x"b4",x"8a",x"ce",x"e7",x"ae",x"de",x"f9",x"df",x"fe",x"fa",x"f8",x"ff",x"ff",x"ff",x"fc",x"ab",x"9a",x"7c",x"ee",x"ff",x"ff",x"ff",x"f8",x"fe",x"f7",x"d3",x"f8",x"da",x"ae",x"e8",x"cd",x"8a",x"b5",x"cb",x"b5",x"aa",x"88",x"88",x"88",x"88",x"88",x"88",x"86",x"9d",x"b6",x"ca",x"a4",x"c8",x"da",x"c7",x"e6",x"f1",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e8",x"ac",x"a6",x"9f",x"a1",x"a2",x"a3",x"a0",x"a2",x"a6",x"a7",x"a5",x"a7",x"a5",x"a3",x"a1",x"a0",x"9c",x"9a",x"97",x"99",x"9c",x"98",x"99",x"93",x"9b",x"a3",x"94",x"b3",x"a2",x"98",x"cb",x"cd",x"97",x"98",x"9d",x"9f",x"95",x"96",x"96",x"be",x"d8",x"a1",x"ba",x"b3",x"8f",x"a9",x"9d",x"98",x"9c",x"9b",x"9d",x"99",x"97",x"98",x"98",x"9b",x"9b",x"9b",x"9e",x"9f",x"9d",x"9f",x"9c",x"9a",x"98",x"9b",x"99",x"99",x"9c",x"97",x"a2",x"e9",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d7",x"a5",x"a0",x"a3",x"a5",x"a3",x"a2",x"a0",x"a0",x"a0",x"a2",x"b5",x"93",x"a3",x"bd",x"c8",x"d5",x"d6",x"d6",x"d6",x"d6",x"d6",x"d5",x"d1",x"bd",x"bb",x"ba",x"94",x"7e",x"b1",x"b4",x"a1",x"9d",x"93",x"93",x"9a",x"a1",x"a5",x"9d",x"9b",x"ae",x"bc",x"bc",x"b6",x"84",x"ab",x"bc",x"bd",x"bf",x"d2",x"d6",x"d6",x"d6",x"d6",x"d6",x"d5",x"d4",x"c7",x"bc",x"a2",x"92",x"b1",x"95",x"99",x"98",x"97",x"99",x"99",x"9b",x"99",x"9b",x"c2",x"e3",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f6",x"d1",x"ad",x"9c",x"a7",x"b4",x"ca",x"d1",x"e6",x"eb",x"fe",x"ee",x"f5",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ef",x"e6",x"fd",x"fe",x"fc",x"c9",x"9e",x"a2",x"9b",x"a0",x"a9",x"ac",x"a2",x"b2",x"ff",x"ff",x"fd",x"e6",x"f7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f5",x"ee",x"ff",x"d9",x"e3",x"ce",x"c7",x"ab",x"a7",x"93",x"b8",x"e2",x"fd",x"ff",x"ff",x"ff"),
     (x"ff",x"fe",x"d8",x"b7",x"c2",x"f3",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fa",x"d8",x"f0",x"fb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ea",x"f3",x"f2",x"a8",x"9b",x"91",x"ed",x"f8",x"f8",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f9",x"f2",x"d8",x"fa",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"d9",x"7c",x"79",x"77",x"9c",x"f5",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fc",x"ab",x"9b",x"7d",x"ee",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"d5",x"7b",x"7f",x"7f",x"79",x"a1",x"fa",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d3",x"a0",x"a5",x"9f",x"9c",x"8e",x"9f",x"a2",x"e0",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"f3",x"8a",x"7d",x"7f",x"7f",x"7b",x"ab",x"fa",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"cc",x"8b",x"8f",x"9a",x"9b",x"9d",x"91",x"84",x"a0",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"a1",x"7b",x"7f",x"7f",x"7f",x"7a",x"ae",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d4",x"9a",x"9e",x"9d",x"9d",x"9d",x"9e",x"94",x"a5",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"c9",x"7a",x"7f",x"7f",x"7f",x"7f",x"7b",x"b9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"fe",x"f7",x"f6",x"ed",x"e9",x"dc",x"d6",x"d8",x"cd",x"c6",x"c4",x"b2",x"b0",x"9e",x"8a",x"8d",x"8d",x"8d",x"8d",x"8d",x"8b",x"9b",x"b1",x"af",x"ae",x"b9",x"f4",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ec",x"84",x"7e",x"7f",x"7f",x"7f",x"7e",x"7a",x"bf",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fd",x"fa",x"f3",x"f3",x"e8",x"df",x"d2",x"cb",x"c1",x"af",x"aa",x"a2",x"9b",x"8c",x"8a",x"85",x"83",x"7d",x"7b",x"7b",x"7b",x"7b",x"7b",x"7a",x"7a",x"7c",x"7e",x"7e",x"7e",x"7e",x"7e",x"7e",x"7e",x"7d",x"7a",x"7a",x"7a",x"78",x"a4",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"fd",x"97",x"7c",x"7f",x"7f",x"7f",x"7f",x"7e",x"80",x"bc",x"d0",x"c3",x"bc",x"ad",x"a4",x"9c",x"95",x"87",x"87",x"82",x"7f",x"7a",x"7a",x"7a",x"7a",x"7a",x"7b",x"7c",x"7d",x"7d",x"7e",x"7e",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7e",x"80",x"e6",x"ff",x"ee",x"f8",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"bb",x"7a",x"7f",x"7f",x"7f",x"7f",x"7f",x"7e",x"7a",x"7a",x"7a",x"7a",x"7b",x"7b",x"7c",x"7c",x"7e",x"7e",x"7e",x"7e",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7c",x"d4",x"f8",x"d8",x"e4",x"df",x"e9",x"f6",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"dd",x"7f",x"7e",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7e",x"7b",x"7a",x"7a",x"7a",x"7a",x"7a",x"7a",x"7c",x"7f",x"7f",x"7d",x"d5",x"f4",x"f4",x"f2",x"f0",x"e9",x"d6",x"da",x"f5",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"f8",x"8f",x"7d",x"7f",x"7e",x"7d",x"7d",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7b",x"7d",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7e",x"81",x"af",x"b7",x"b5",x"b5",x"b5",x"b5",x"b8",x"9a",x"7e",x"7f",x"7d",x"d5",x"f4",x"f1",x"f1",x"f1",x"f2",x"f3",x"e9",x"cc",x"dc",x"fd",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ab",x"76",x"78",x"78",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"7d",x"7f",x"7f",x"7f",x"7f",x"7f",x"7e",x"c0",x"f7",x"f6",x"f6",x"f6",x"f6",x"f6",x"f7",x"f2",x"a2",x"7b",x"7d",x"d5",x"f4",x"f1",x"f1",x"f1",x"f1",x"f1",x"f2",x"f4",x"d9",x"ca",x"f2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"c8",x"72",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"73",x"74",x"74",x"75",x"76",x"76",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"7a",x"7f",x"7f",x"7f",x"7f",x"7d",x"8f",x"ee",x"f2",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f6",x"cc",x"7b",x"7d",x"d5",x"f4",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f4",x"e2",x"d6",x"eb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ed",x"7e",x"76",x"77",x"77",x"77",x"77",x"77",x"76",x"94",x"95",x"8c",x"7f",x"7e",x"7a",x"74",x"72",x"72",x"72",x"72",x"72",x"73",x"74",x"75",x"76",x"76",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"79",x"7f",x"7f",x"7f",x"7f",x"7c",x"9b",x"f4",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f4",x"d9",x"80",x"7c",x"d5",x"f4",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"ee",x"ea",x"e9",x"e9",x"ba",x"de",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"99",x"73",x"77",x"77",x"77",x"77",x"76",x"7f",x"ee",x"ff",x"f9",x"f3",x"f0",x"e4",x"d5",x"d0",x"c5",x"bb",x"a8",x"a2",x"97",x"8d",x"82",x"7f",x"7b",x"74",x"72",x"74",x"77",x"77",x"77",x"77",x"7a",x"7f",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f4",x"db",x"81",x"7c",x"d5",x"f4",x"f1",x"f1",x"f1",x"f1",x"f0",x"eb",x"e8",x"e8",x"e8",x"e9",x"e9",x"ba",x"de",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"bb",x"71",x"77",x"77",x"77",x"77",x"72",x"9e",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fe",x"fb",x"f6",x"ee",x"e7",x"d9",x"cd",x"93",x"74",x"77",x"77",x"77",x"7d",x"7f",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f4",x"db",x"81",x"7c",x"d5",x"f4",x"f1",x"f1",x"f0",x"ec",x"e9",x"e8",x"e8",x"e8",x"e8",x"e8",x"e9",x"e9",x"c4",x"f9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"e4",x"79",x"76",x"77",x"77",x"77",x"72",x"ca",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f3",x"8d",x"74",x"77",x"78",x"7e",x"7f",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f4",x"db",x"81",x"7c",x"d5",x"f5",x"f0",x"ec",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"ec",x"da",x"f3",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"fc",x"8f",x"74",x"77",x"77",x"76",x"7f",x"ee",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b7",x"72",x"77",x"7c",x"7f",x"7f",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f4",x"db",x"81",x"7c",x"d4",x"f0",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e9",x"dd",x"e0",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ac",x"6e",x"74",x"74",x"6f",x"9f",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"a7",x"72",x"7a",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f4",x"db",x"80",x"78",x"cd",x"eb",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"ea",x"dd",x"ec",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e7",x"96",x"8b",x"8b",x"93",x"e3",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ed",x"80",x"79",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"f3",x"d8",x"7a",x"74",x"cc",x"eb",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"db",x"f7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fd",x"f9",x"f9",x"fc",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b7",x"77",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f1",x"f1",x"f1",x"ee",x"ec",x"d3",x"7a",x"74",x"cc",x"eb",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e9",x"df",x"d7",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"a1",x"7b",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7c",x"9a",x"f3",x"f1",x"f1",x"f1",x"f1",x"ee",x"ea",x"e8",x"eb",x"d3",x"7a",x"74",x"cc",x"eb",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"ea",x"cf",x"f5",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"a0",x"7b",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7c",x"9b",x"f4",x"f1",x"f1",x"ee",x"ea",x"e8",x"e8",x"e8",x"ea",x"d4",x"7a",x"74",x"cc",x"eb",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e9",x"e1",x"e5",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"c2",x"7b",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7c",x"95",x"f1",x"f0",x"eb",x"e8",x"e8",x"e8",x"e8",x"e8",x"eb",x"cf",x"77",x"74",x"cd",x"eb",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"e8",x"c1",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fb",x"9e",x"7a",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7f",x"7e",x"80",x"d5",x"ee",x"eb",x"eb",x"eb",x"eb",x"eb",x"eb",x"ef",x"ab",x"73",x"73",x"b4",x"f0",x"eb",x"eb",x"eb",x"eb",x"eb",x"eb",x"eb",x"eb",x"eb",x"eb",x"eb",x"eb",x"eb",x"eb",x"eb",x"eb",x"ee",x"d1",x"ef",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ea",x"8a",x"7d",x"7f",x"7f",x"7f",x"7f",x"7f",x"7e",x"7a",x"75",x"89",x"c9",x"d2",x"d1",x"d1",x"d1",x"d1",x"d2",x"b3",x"7c",x"76",x"76",x"7e",x"b7",x"d2",x"d1",x"d1",x"d1",x"d1",x"d1",x"d1",x"d1",x"d1",x"d1",x"d1",x"d1",x"d1",x"d1",x"d1",x"d1",x"d3",x"bc",x"ec",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"dc",x"80",x"7d",x"7f",x"7f",x"7e",x"7b",x"78",x"77",x"77",x"75",x"75",x"76",x"76",x"76",x"76",x"76",x"76",x"73",x"76",x"77",x"77",x"76",x"73",x"76",x"76",x"76",x"76",x"76",x"76",x"76",x"76",x"76",x"76",x"76",x"76",x"76",x"76",x"76",x"76",x"73",x"8f",x"fc",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"c6",x"7d",x"7d",x"7b",x"78",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"72",x"9f",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"c4",x"76",x"74",x"77",x"77",x"77",x"77",x"77",x"77",x"76",x"76",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"71",x"ca",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ce",x"81",x"72",x"77",x"77",x"77",x"77",x"76",x"79",x"7b",x"76",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"78",x"78",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"72",x"97",x"fa",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e7",x"9a",x"74",x"73",x"77",x"76",x"7b",x"96",x"9a",x"7d",x"76",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"91",x"9a",x"8d",x"76",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"70",x"91",x"ee",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fd",x"d5",x"97",x"75",x"79",x"96",x"9c",x"9d",x"7f",x"76",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"77",x"78",x"94",x"9d",x"9d",x"84",x"76",x"77",x"77",x"77",x"76",x"72",x"74",x"a3",x"ef",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fd",x"d8",x"95",x"9b",x"9d",x"8b",x"72",x"71",x"71",x"71",x"71",x"71",x"71",x"71",x"71",x"71",x"71",x"71",x"71",x"70",x"72",x"91",x"9d",x"99",x"77",x"70",x"71",x"74",x"7c",x"9f",x"d1",x"fd",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f3",x"a7",x"99",x"a6",x"d9",x"c5",x"bb",x"bc",x"bc",x"bc",x"bc",x"bc",x"bc",x"bc",x"bc",x"bc",x"bc",x"bc",x"bc",x"bd",x"91",x"98",x"9a",x"aa",x"be",x"bd",x"d6",x"ec",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e7",x"97",x"98",x"bb",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e9",x"9d",x"98",x"bc",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f0",x"a0",x"97",x"a2",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fd",x"ae",x"99",x"81",x"f9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ea",x"9b",x"97",x"db",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b5",x"98",x"82",x"f9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fa",x"f3",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"eb",x"9c",x"97",x"d9",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"b5",x"98",x"80",x"f9",x"ff",x"ff",x"ff",x"ff",x"f9",x"e3",x"b4",x"9e",x"f0",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"d0",x"aa",x"ad",x"ad",x"ad",x"ad",x"ac",x"be",x"a2",x"9e",x"bc",x"ae",x"ad",x"ad",x"ad",x"ad",x"ad",x"ad",x"ad",x"ad",x"ad",x"ad",x"ad",x"ad",x"ad",x"ad",x"ac",x"b5",x"b1",x"9e",x"8f",x"aa",x"ab",x"d6",x"f0",x"ae",x"b6",x"a7",x"a0",x"a9",x"f5",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"f2",x"a8",x"93",x"96",x"96",x"96",x"96",x"95",x"9e",x"a6",x"a6",x"a1",x"96",x"96",x"96",x"96",x"96",x"96",x"96",x"96",x"96",x"96",x"96",x"96",x"96",x"96",x"96",x"96",x"98",x"a5",x"a5",x"a6",x"96",x"95",x"a0",x"a6",x"a1",x"a1",x"a0",x"ac",x"e0",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"e9",x"a7",x"9a",x"98",x"98",x"98",x"98",x"97",x"97",x"97",x"97",x"98",x"98",x"98",x"98",x"98",x"98",x"98",x"98",x"98",x"98",x"98",x"98",x"98",x"98",x"98",x"98",x"98",x"97",x"97",x"97",x"98",x"98",x"96",x"9b",x"af",x"a8",x"bb",x"e0",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
     (x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"fd",x"ec",x"b1",x"a8",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a9",x"a6",x"c0",x"fc",x"f2",x"fe",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff",x"ff"),
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
		
