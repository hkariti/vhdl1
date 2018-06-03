library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity pwm is
    port (  resetN      : in std_logic;
            clk         : in std_logic;
            datain      : in std_logic_vector(7 downto 0);
            pwmOut      : out std_logic;
            clkOut      : out std_logic
        );
end pwm ;

architecture arc of pwm is
    constant period: integer := 255;
begin
process ( resetN , clk )
    variable counter: integer := 0;
    variable datain_sample: integer := 0;
begin
    if (resetN = '0') then
        counter := 0;
        pwmOut <= '0';
        clkOut <= '0';
    elsif (rising_edge(clk)) then
        pwmOut <= '1';
        counter := counter + 1;
        clkOut <= '0';
        if (counter > datain_sample ) then
            pwmOut <= '0';
        end if;
        if (counter >= period) then
            counter := 0;
            clkOut <= '1';
            datain_sample := conv_integer(unsigned(datain));
        end if;
    end if;
end process;
end architecture;
