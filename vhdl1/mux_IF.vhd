library ieee;
use ieee.std_logic_1164.all;

entity mux_IF is
port (
	ind_1 : in  std_logic;-- Mux first input
	ind_2 : in  std_logic;-- Mux Second input
	ind_3 : in  std_logic;-- Mux Third input
	ind_4 : in  std_logic;-- Mux Forth input
	sel_0: in  std_logic;-- Select input
	sel_1: in  std_logic;-- Select input
	outd : out std_logic -- Mux output
);
end entity;

architecture behavior of mux_IF is

begin

process (ind_1, ind_2, ind_3, ind_4, sel_0, sel_1)
begin
	if(sel_1='0') then
		if(sel_0='0') then
			outd<=ind_1;
		else
			outd<=ind_2;
		end if;
	else
		if(sel_0='0') then
			outd<=ind_3;
		else
			outd<=ind_4;
		end if;
	end if;
end process;

end architecture;

