library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity game_logic is
port 	(
		CLOCK_50: in std_logic;
		resetN: in std_logic;
		collision: in std_logic;
		smileyStartX: in integer;
		smileyStartY: in integer;
		sound_on: out std_logic;
		reset_smiley_move: out std_logic
		
	);
end game_logic;

architecture behav of game_logic is
	type state is (Idle, collisionStart, saveInitialX, waitForSmileyPosition);
	signal sm : state;
	signal smileyTarget : integer;
begin 

process (CLOCK_50, resetN)
begin
	if (resetN = '0') then
		sm <= Idle;
		sound_on <= '0';
		reset_smiley_move <= '1';
	elsif (rising_edge(CLOCK_50)) then
		case sm is
			when Idle =>
				sound_on <= '0';
				reset_smiley_move <= '1';
				if (collision = '1') then
					sm <= collisionStart;
				end if;
			when collisionStart =>
				sound_on <= '1';
				reset_smiley_move <= '0';
				sm <= saveInitialX;
			when saveInitialX =>
				sound_on <= '1';
				reset_smiley_move <= '1';
				smileyTarget <= smileyStartY + 20;
				sm <= waitForsmileyPosition;
			when waitForsmileyPosition =>
				sound_on <= '1';
				reset_smiley_move <= '1';
				if (smileyStartY <= smileyTarget) then
					sm <= Idle;
				end if;
		end case;
	end if;
end process;
		
end behav;		