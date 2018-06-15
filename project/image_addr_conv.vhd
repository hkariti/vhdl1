library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity image_addr_conv is
    port(
            clk_in: in std_logic;
            resetN: in std_logic;
            oCoord_X: in integer;
            oCoord_Y: in integer;
            size_X: in integer;
            size_Y: in integer;
            scale: in integer;
            addr: out integer
        );
end ;
 
architecture Behavioral of image_addr_conv is
   signal addr_t: integer := 0;
begin 
  
process(clk_in,resetN)
   begin
      if ResetN='0' then
         addr_t <= 0;
      elsif(rising_edge(clk_in)) then
          if (oCoord_X < size_X and oCoord_Y < size_Y) then
              addr_t <= oCoord_Y/scale*(size_X/scale) + oCoord_X/scale;
          end if;
      end if;
   end process;
   addr <= addr_t;
end Behavioral;
