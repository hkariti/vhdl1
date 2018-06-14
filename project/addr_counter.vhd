library IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity addr_counter is
    port(
            clk_in: in std_logic;
            resetN: in std_logic;
            en: in std_logic;
            start: in std_logic;
            stop: in std_logic;
            length: in integer;
            addr: out std_logic_vector(14 downto 0)
        );
end;
 
architecture Behavioral of addr_counter is
    type state is (idle, playing);
    signal sm : state;
    signal counter: std_logic_vector(14 downto 0);
begin 
  
process(clk_in,resetN)
begin
    if ResetN='0' then
        counter <= "000000000000000";
        sm <= idle;
    elsif(rising_edge(clk_in)) then
        case sm is
            when idle =>
                counter <= (others => '0');
                if (start = '1') then
                    sm <= playing;
                end if;
            when playing =>
                if en='1' then
                    if (stop = '1' or counter = conv_std_logic_vector(length)) then
                        sm <= idle;
                    else
                        counter <= counter + 1;
                    end if;
                end if;
        end case;
    end if;
   end process;
   addr <= counter;
end Behavioral;
