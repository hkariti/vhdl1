library ieee;
use ieee.std_logic_1164.all;

entity one_sec_turbo is
    port (
             resetN: in std_logic;
             clk: in std_logic;
				 Turbo: in std_logic;
             OneSec: out std_logic;
				 duty50: out std_logic
);
end entity;

architecture behavior of one_sec_turbo is
    signal one_sec_flag : std_logic ; 
begin
    process(clk,resetN,Turbo)
        variable one_sec: integer ;
		  variable sec: integer ;
		  variable half_sec: integer;
        constant tmp: integer := 50000000 ; -- for Real operation
 --     constant tmp: integer := 5 ; -- for simulation
	begin
		if Turbo = '0' then
			sec := tmp ;
		else
			sec := tmp/10 ;
		end if;
		half_sec := sec/2;
        if resetN = '0' then
            one_sec := 0 ;
            one_sec_flag <= '0' ;
				duty50 <= '0';
        elsif rising_edge(clk) then
            one_sec := one_sec + 1 ;
            if (one_sec >= sec) then
                one_sec_flag <= '1' ;
					 duty50 <= '1';
                one_sec := 0 ;
            else
                one_sec_flag <= '0' ;
					 duty50 <= '1' ;
					 if (one_sec >= half_sec) then
					      duty50 <= '0';
					 end if;
            end if;
        end if;
    end process;
    OneSec <= one_sec_flag;
end;