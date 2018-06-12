library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;
-- Alex Grinshpun Apr 2017
-- Dudy Nov 13 2017

entity objects_mux is
port 	(
		CLK	: in std_logic; --						//	27 MHz
		b_drawing_request : in std_logic;
		b_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	, -- b  input signal 

		c_drawing_request : in std_logic;
		c_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- c input signal 
		
		d_drawing_request : in std_logic;
		d_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- c input signal 
		
		e_drawing_request : in std_logic;
		e_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- c input signal 
		
		f_drawing_request : in std_logic;
		f_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- c input signal 
		
		g_drawing_request : in std_logic;
		g_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- c input signal 
		
		h_drawing_request : in std_logic;
		h_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- c input signal 
		
		y_drawing_request : in std_logic;	-- not used in this exammple 
		y_mVGA_RGB 	: in std_logic_vector(7 downto 0); --	,  -- y input signal 

		m_mVGA_R 	: out std_logic_vector(7 downto 0); --	,  
		m_mVGA_G 	: out std_logic_vector(7 downto 0); --	, 
		m_mVGA_B 	: out std_logic_vector(7 downto 0); --	, 
		RESETn : in std_logic

	);
end objects_mux;

architecture behav of objects_mux is 
signal m_mVGA_t 	: std_logic_vector(7 downto 0); --	,  

begin

-- priority encoder process

process ( RESETn, CLK)
begin 
	if RESETn = '0' then
			m_mVGA_t	<=  (others => '0') ; 	

	elsif rising_edge(CLK) then
		if (b_drawing_request = '1' ) then  
			m_mVGA_t <= b_mVGA_RGB;  --first priority from B 
		elsif (c_drawing_request = '1') then
		   m_mVGA_t <= c_mVGA_RGB;  -- second priority from C
		elsif (d_drawing_request = '1') then
		   m_mVGA_t <= d_mVGA_RGB;  -- second priority from C
		elsif (e_drawing_request = '1') then
		   m_mVGA_t <= e_mVGA_RGB;  -- second priority from C
		elsif (f_drawing_request = '1') then
		   m_mVGA_t <= f_mVGA_RGB;  -- second priority from C
		elsif (g_drawing_request = '1') then
		   m_mVGA_t <= g_mVGA_RGB;  -- second priority from C
		elsif (h_drawing_request = '1') then
		   m_mVGA_t <= h_mVGA_RGB;  -- second priority from C
	   else
			m_mVGA_t <= y_mVGA_RGB ; -- last priority from y
		end if; 
	end if ; 

end process ;

m_mVGA_R	<= m_mVGA_t(7 downto 5)& "00000"; -- expand to 10 bits 
m_mVGA_G	<= m_mVGA_t(4 downto 2)& "00000";
m_mVGA_B	<= m_mVGA_t(1 downto 0)& "000000";


end behav;