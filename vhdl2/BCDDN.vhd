library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;

entity bcddn is 
	port ( 
		resetN: in std_logic; 
		clock: in std_logic; 
		ena_cnt: in std_logic;	
		load : in std_logic;
		data : in std_logic_vector(7 downto 0);
		TC : out std_logic;
		countH: out std_logic_vector(3 downto 0); 
		countL: out std_logic_vector(3 downto 0)
	); 
end entity;

architecture behavior of bcddn is

	signal Htmp : integer := 0;
	signal Ltmp : integer := 0;
	
	begin	

	process(clock, resetN) 
	
	begin
		if (resetN = '0') then
			Htmp <= 9;
			Ltmp <= 9;
		elsif (rising_edge(clock)) then
			if (load = '0') then
				Htmp <= conv_integer(data(7 downto 4)) ;
				Ltmp <= conv_integer(data(3 downto 0)) ;
			elsif (ena_cnt = '1') then
				if ((Htmp = 0) and (Ltmp = 0)) then
					Htmp <= 9;
					Ltmp <= 9;
				elsif (Ltmp = 0) then
					Htmp <= Htmp - 1;
					Ltmp <= 9;
				else
					Htmp <= Htmp;
					Ltmp <= Ltmp - 1;
				end if;
			end if;
		end if;

		countH <= conv_std_logic_vector(Htmp, countH'length);
		countL <= conv_std_logic_vector(Ltmp, countL'length);
		
	end process;
	
	process(Htmp, Ltmp)
	
	begin
		if(ena_cnt = '1') then
			if((Htmp = 0) and (Ltmp = 0)) then
				TC <= '1';
			else
				TC <= '0';
			end if;
		end if;
	end process;
	
end architecture;