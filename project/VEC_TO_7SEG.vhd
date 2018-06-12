library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
use ieee.std_logic_arith.all;


entity VEC_TO_7SEG is
port 	(


		RESETn		: in std_logic;
		score	: in integer ;
		H_num	: out std_logic_vector(3 downto 0)  ;
		M_num	: out std_logic_vector(3 downto 0)  ;
		L_num	: out std_logic_vector(3 downto 0)  
	);
end VEC_TO_7SEG;

architecture behav of VEC_TO_7SEG is 

begin

process(score)

begin 

	H_num <= conv_std_logic_vector(score/100 mod 10 , 4);
	M_num <= conv_std_logic_vector(score/10 mod 10 , 4);
	L_num <= conv_std_logic_vector(score mod 10 , 4);

end process;

end behav;
	
	