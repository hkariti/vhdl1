library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bin_counter is
    port (
             resetN: in std_logic;
             clk: in std_logic;
             count: out std_logic_vector(3 downto 0)
);
end entity;

architecture behavior of bin_counter is
begin
    process(CLK,RESETN)
        variable counter: integer := 0;
	constant counter_max: integer := 13;
    begin
        if RESETN = '0' then
            counter := 0 ;
        elsif rising_edge(CLK) then
            counter := counter + 1 ;
            if (counter = counter_max) then
                counter := 0;
            end if;
        end if;
    count <= std_logic_vector(to_unsigned(counter, count'length));
    end process;
    
end;