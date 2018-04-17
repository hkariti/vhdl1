library ieee;
use ieee.std_logic_1164.all;

entity mux_CASE is
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

architecture behavior of mux_CASE is

begin

process (ind_1, ind_2, ind_3, ind_4, sel_0, sel_1)
begin
	case sel_1 is
		when '0' => 
			case sel_0 is
				when '0' =>
					outd<=ind_1;
				when others =>
					outd<=ind_2;
			end case;
		when others =>
			case sel_0 is
				when '0' =>
					outd<=ind_3;
				when others =>
					outd<=ind_4;
			end case;
	end case;
end process;

end architecture;

