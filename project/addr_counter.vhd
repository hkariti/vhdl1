library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity addr_counter is
   port( en: in std_logic;
	en1: in std_logic;
 	 clk_in: in std_logic;
 	 resetN: in std_logic;
 	 addr: out std_logic_vector(14 downto 0));
end ;
 
architecture Behavioral of addr_counter is
   signal temp: std_logic_vector(14 downto 0);
begin 
  
process(clk_in,resetN)

   begin
      if ResetN='0' then
         temp <= "000000000000000";
      elsif(rising_edge(clk_in)) then
         if en1='1' and en='1' then
            if temp = "111111111111111" then
               temp <= (others => '0');
            else
               temp <= temp + 1;
            end if;
         end if;
      end if;
   end process;
   addr <= temp;
end Behavioral;