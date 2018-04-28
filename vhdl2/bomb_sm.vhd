library ieee ;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;

entity BombStateMachine is
	port ( 	clk:	in 	std_logic;
		resetN:		in 	std_logic;
	    startN:		in 	std_logic;
		WaitN:  	in	std_logic; --wait might be a reserved word 
		SlowClk: 	in	std_logic;
		TC: 		in	std_logic;
		
		CounterEnable:  out	std_logic;  --enable('1')/disable('0')  
		CounterLoadN:  out	std_logic;  --/load ('0')  
		LampOn: 	out	std_logic;
        LampOff:  out std_logic); -- on('1') off('0')
end BombStateMachine;

architecture arc_BombStateMachine of BombStateMachine is 
  type state_type is (idle, arm, run, pause, lamp_on, lamp_off); --enumerated type for state machine
  signal state : state_type;
begin
    process (clk, resetN)
    begin
        if resetN = '0' then
            state <= idle;
			CounterEnable <= '0';
			LampOn<= '0';
			LampOff<= '0';
			CounterLoadN <= '1' ; 
       elsif (rising_edge(clk)) then
	   -- preset all outputs ,override in the state machine if needed  
	   		CounterLoadN <= '1' ; 
			CounterEnable <= '0';
			LampOn<= '0';
			LampOff<= '0';
	
	   
            -- Determine the next state synchronously, based on
            -- the current state and the input
			case state is
                when idle=>
                    if startN = '0' then
                        state <= arm;
						CounterLoadN <= '0' ; 
                    end if;
                when arm =>
                    if startN = '1' then
                        state <= run;
                        CounterEnable <= '1';
                    else
                        CounterLoadN <= '0';
                    end if;
                when run=>
                    if waitN = '0' then
                        state <= pause;
                    elsif TC = '1' then
                        state <= lamp_on;
                        LampOn <= '1';
                    else
                        CounterEnable <= '1';
                    end if;
                when pause =>
                    if waitN = '1' then
                        state <= run;
                        CounterEnable <= '1';
                    end if;
                when lamp_on =>
                    if SlowClk = '1' then
                        state <= lamp_off;
                        LampOff <= '1';
                    else
                        LampOn <= '1';
                    end if;
                when lamp_off =>
                    if SlowClk = '0' then
                        state <= lamp_on;
                        LampOn <= '1';
                    else
                        LampOff <= '1';
                    end if;
            end case;
        end if;
    end process;
end arc_BombStateMachine ; 
