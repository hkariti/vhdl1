library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun July 24 2017 
-- Dudy Nov 13 2017


entity rect_draw is
port 	(
		
	   CLK      : in std_logic;
		RESETn	: in std_logic;
		oCoord_X : in integer;
		oCoord_Y : in integer;
		mVGA_RGB	: out std_logic_vector(7 downto 0); --	,//	VGA composite RGB
		drawing_request: out std_logic
	);
end rect_draw;

architecture behav of rect_draw is 


signal mVGA_R	: std_logic_vector(2 downto 0); --	,	 			//	VGA Red[2:0]
signal mVGA_G	: std_logic_vector(2 downto 0); --	,	 			//	VGA Green[2:0]
signal mVGA_B	: std_logic_vector(1 downto 0); --	,  			//	VGA Blue[1:0]
	
begin

mVGA_RGB <=  mVGA_R & mVGA_G &  mVGA_B ;
-- defining three rectangles 

process ( oCoord_X,oCoord_y )
begin 
   mVGA_R <= "000";
	mVGA_G <= "000";
	mVGA_B <= "00";
	drawing_request <= '0';

	if (oCoord_X < 200 and oCoord_X >= 100 and oCoord_Y < 200 and oCoord_Y >= 100) then
	    mVGA_R <= "000";
		 mVGA_G <= "000";
		 mVGA_B <= "11";
		 drawing_request <= '1';
   end if;

end process ; 

		
end behav;