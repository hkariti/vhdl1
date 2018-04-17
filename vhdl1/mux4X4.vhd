library ieee;
use ieee.std_logic_1164.all;

entity mux4X4 is
port (
	ind : in  std_logic_vector(15 downto 0) ;-- input vector
	sel : in  std_logic_vector(3 downto 0);-- Select vector
	outd : out std_logic -- mux output
);
end entity;

architecture behavior of mux4X4 is
	component mux_IF is
		port (ind_1, ind_2, ind_3, ind_4, sel_0, sel_1 : in std_logic;
			  outd : out std_logic);
	end component;
	
signal out0, out1, out2, out3: std_logic;

begin
	U0: mux_IF 
		port map(ind(0), ind(1), ind(2), ind(3), sel(0), sel(1), out0);
	U1: mux_IF
		port map(ind(4), ind(5), ind(6), ind(7), sel(0), sel(1), out1);
	U2: mux_IF 
		port map(ind(8), ind(9), ind(10), ind(11), sel(0), sel(1), out2);
	U3: mux_IF
		port map(ind(12), ind(13), ind(14), ind(15), sel(0), sel(1), out3);
	U4: mux_IF
		port map(out0, out1, out2, out3, sel(2), sel(3), outd);
end architecture;

