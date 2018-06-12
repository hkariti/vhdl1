library ieee ;
use ieee.std_logic_1164.all ;


entity NUM_LOCK is
port( resetN : in std_logic;
		clk : in std_logic;
		din : in std_logic_vector(8 downto 0);
		key_code : in std_logic_vector(8 downto 0);
		make : in std_logic;
		break : in std_logic;
		dout : out std_logic);
end NUM_LOCK;

architecture behavior of NUM_LOCK is

	signal out_led : std_logic;
	type state is (st_pressed, st_break);

begin
	dout <= out_led;
	process(resetN, clk)
	variable pr_state : state; 
		begin
			if resetN = '0' then
				out_led <= '0';
				pr_state := st_break;
			elsif rising_edge(clk) then
				out_led <= '0';
				case pr_state is
					when st_break =>
						if(din = key_code) and (make = '1') then
							out_led <= '1';
							pr_state := st_pressed;
						end if;
					when st_pressed =>
						if(din = key_code) and (break = '1') then
							pr_state := st_break;
						end if;
						out_led <= '1';
				end case;
			end if;
	end process;
end architecture;