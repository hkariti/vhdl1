library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity game_logic is
port 	(
		CLOCK_50: in std_logic;
		sec: in std_logic;
		resetN: in std_logic;
		collision: in std_logic;
		smileyStartX: in integer;
		smileyStartY: in integer;
		food_eaten: in std_logic;
		sound_on: out std_logic;
		score: out integer;
		life: out unsigned(2 downto 0);
		restart_game: out std_logic;
		speed : out integer;
		game_over: out std_logic

	);
end game_logic;

architecture behav of game_logic is
	type state is (Idle, collisionStart);
	signal sm : state;
	signal smileyTarget : integer;
	signal life_t: unsigned(2 downto 0) := "111";
	signal score_t: integer := 0;
	signal speed_t : integer;
	signal speed_counter : integer := 0;
    constant init_speed : integer := 1;
    constant food_score_value : integer := 10;
begin
process (CLOCK_50, resetN)
begin
	if (resetN = '0') then
		sm <= Idle;
		sound_on <= '0';
		restart_game <= '1';
		score_t <= 0;
		life_t <= "111";
		game_over <= '0';
		speed_t <= init_speed;
	elsif (rising_edge(CLOCK_50)) then
		if food_eaten = '1' then
			score_t <= score_t + food_score_value;
		end if;
		if sec = '1' then
			score_t <= score_t + speed_t;
			speed_counter <= speed_counter + 1;
			if speed_counter = 10 then
				speed_t <= speed_t + 1;
				speed_counter <= 0;
			end if;
		end if;
		case sm is
			when Idle =>
				sound_on <= '0';
				restart_game <= '1';
				if (collision = '1') then
					sm <= collisionStart;
				end if;
			when collisionStart =>
				sound_on <= '1';
				speed_t <= init_speed;
				speed_counter <= 0;
				restart_game <= '0';
				life_t <= shift_right(life_t, 1);
				if (life_t = "000") then
					score_t <= 0;
					game_over <= '1';
				end if;
				sm <= idle;
		end case;
	end if;
end process;
speed <= speed_t;
score <= score_t;
life <= life_t;

end behav;
