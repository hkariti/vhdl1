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
				start_X: in integer;
				start_Y: in integer;
            size_X: in integer;
            size_Y: in integer;
            scale: in integer;
            addr: out integer;
				drawing_request: out std_logic
        );
end ;
 
architecture Behavioral of image_addr_conv is
   signal addr_t: integer := 0;
	signal end_X: integer := start_X + size_X;
	signal end_Y: integer := start_Y + size_Y;
	signal drawing_request_X : std_logic;
	signal drawing_request_Y : std_logic;
	signal drawing_request_t : std_logic;
begin
process(clk_in,resetN)
   begin
      if ResetN='0' then
         addr_t <= 0;
      elsif(rising_edge(clk_in)) then
			 drawing_request_t <= drawing_request_X and drawing_request_Y;
			 addr_t <= 0;
          if (drawing_request_t = '1') then
              addr_t <= oCoord_Y/scale*(size_X/scale) + oCoord_X/scale;
          end if;
      end if;
   end process;
   addr <= addr_t;
   drawing_request_X <= '1' when (oCoord_X >= start_X) and (oCoord_X < end_X) else '0';
   drawing_request_Y <= '1' when (oCoord_Y >= start_Y) and (oCoord_Y < end_Y) else '0';
	drawing_request <= drawing_request_t;
end Behavioral;
