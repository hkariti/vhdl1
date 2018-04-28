library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all; 
use ieee.std_logic_arith.all;

entity Traffic_Light is 
	port ( 
		resetN: in std_logic; 
		clock: in std_logic; 
		SwitchN: in std_logic;	
		Turbo : in std_logic;
		Red : out std_logic;
		Yellow: out std_logic; 
		Green: out std_logic
	); 
end entity;

architecture behavior of Traffic_Light is

signal clk_one_sec : std_logic;

component one_sec_turbo
	port (
		resetN: in std_logic;
      clk: in std_logic;
   	Turbo: in std_logic;
		OneSec: out std_logic
 	);
end component;
	
	type state is(R, RY, Y, G);
		
		constant timeMAX : integer := 54;
		constant timeR : integer := 54;
		constant timeR_RY : integer := 20;
		constant timeG : integer := 41;
		
		signal pr_state, next_state : state;
		signal time: integer range 0 to timeMAX;
	
	begin 
	
Slow_Clock : one_sec_turbo port map(resetN, clock, Turbo, clk_one_sec);
	
	process(clk_one_sec, resetN)

	variable count :integer range 0 to timeMAX;

	begin
		if (resetN = '0') then
			pr_state <= R;
		elsif(rising_edge(clk_one_sec)) then
			count := count +1;
			if(count = time) then
				pr_state <= next_state;
				count := 0;
			end if;
		end if;
	end process;
	
	process(pr_state)
	
	begin 
		case pr_state is
			when R => 
				if(switchN = '0') then
					next_state <= RY;
				else
					Red <= '1';
					Yellow <= '0';
					Green <= '0';
					time <= timeR;
					next_state <= RY;
				end if;
			when RY =>
				Red <= '1';
				Yellow <='1';
				Green <='0';
				time <= timeR_RY;
				next_state <= G;
			when G =>
				Red <='0';
				Yellow <='0';
				Green <='1';
				time <= timeG;
				next_state <= Y;
			when Y =>
				Red <='0';
				Yellow <='1';
				Green <='0';
				time <= timeR_RY;
				next_state <= R;
		end case;
	end process;
end architecture;