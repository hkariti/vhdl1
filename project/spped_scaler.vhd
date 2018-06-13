library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;
-- Alex Grinshpun April 2017
-- Dudy Nov 13 2017


entity speed_scaler is
port 	(
	speed:	in integer;
	scaled_speed: out integer
	);
end speed_scaler;

architecture behav of speed_scaler is 

constant scale : integer := 2;

begin
	scaled_speed <= speed + speed/scale + 1;
end behav;