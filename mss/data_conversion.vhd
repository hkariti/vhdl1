library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;

entity data_conversion is 
	port ( 
		resetN: in std_logic; 
		clock: in std_logic;  
		mux: in std_logic_vector(3 downto 0);
		data_in: in std_logic_vector(15 downto 0);
		data_out: out std_logic_vector(15 downto 0)
	); 
end entity;

architecture behavior of data_conversion is

signal data_out_next : integer := 0;

begin

	process(clock, resetN)

	variable data_in_int : integer;
	variable data_out_curr : integer;
	variable tmp_mux : std_logic_vector(3 downto 0);
	
	begin
	

	
	if(resetN = '0') then
		data_out <= "0000000000000000";
	elsif(rising_edge(clock)) then
		tmp_mux := mux;
		data_in_int := conv_integer(signed(data_in));
	   data_out_curr := data_out_next;
		case tmp_mux is
			when "0001" =>
				data_in_int := (-1)*data_in_int;	
			when "0010" =>
				if(data_in_int < 0) then
					data_in_int := 0;
				else
					data_in_int := data_in_int;
				end if;
			when "0011" =>
				if(data_in_int < 0) then
					data_in_int := (-1)* data_in_int;
				else
					data_in_int := data_in_int;
				end if;
			when "0100" =>
				data_in_int := conv_integer(data_in and "1111111111111100");
			when "0101" =>
				data_in_int := conv_integer(data_in and "1111100000000000");
			when "0110" =>
				data_in_int := data_in_int/2;
			when "0111" =>
				data_in_int := (data_in_int*3)/(2);
				if (data_in_int > 32767) then
					data_in_int := 32767;
				elsif(data_in_int < -32768) then
					data_in_int := -32768;
				end if;
			when others =>
				data_in_int := data_in_int;
		end case;
		data_out_next <= data_in_int;
		data_out <= conv_std_logic_vector(data_out_curr, data_out'length);
	end if;
	end process;
end architecture;