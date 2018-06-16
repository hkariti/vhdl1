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
		food_eaten: in std_logic;
      space_pressed: in std_logic;
		score: out integer;
		life: out unsigned(2 downto 0);
		restart_game: out std_logic;
		speed : out integer;
		game_over_snd_start: out std_logic;
		background_snd_start: out std_logic;
		background_snd_stop: out std_logic;
      slurp_snd_start: out std_logic;
      scream_snd_start: out std_logic;
      screen_choice: out std_logic_vector(1 downto 0)
	);
end game_logic;

architecture behav of game_logic is
	type state is (init, new_game, playing, collision_detected, game_over, game_over_wait);
	signal sm : state;
	signal score_t: integer := 0;
	signal life_t: unsigned(2 downto 0) := "111";
   signal restart_game_t: std_logic;
	signal speed_t : integer;
   signal game_over_snd_start_t: std_logic;
	signal background_snd_start_t: std_logic;
	signal background_snd_stop_t: std_logic;
   signal slurp_snd_start_t: std_logic;
   signal scream_snd_start_t: std_logic;
   signal screen_choice_t : std_logic_vector(1 downto 0);
	signal speed_counter : integer;
   constant init_speed : integer := 1;
   constant init_life : unsigned(2 downto 0) := "111";
   constant init_score : integer := 0;
   constant food_score_value : integer := 5;
   constant screen_welcome : std_logic_vector(1 downto 0) := "00";
   constant screen_playing : std_logic_vector(1 downto 0) := "01";
   constant screen_game_over : std_logic_vector(1 downto 0) := "11";
   constant speed_increase_threshold : integer := 10;
begin
process (CLOCK_50, resetN)
begin
	if (resetN = '0') then
		sm <= init;
      screen_choice_t <= screen_welcome;
		restart_game_t <= '1';
		score_t <= init_score;
		life_t <= init_life;
		speed_t <= init_speed;
      speed_counter <= 0;
      game_over_snd_start_t <= '0';
	   background_snd_start_t <= '0';
	   background_snd_stop_t <= '0';
      slurp_snd_start_t <= '0';
      scream_snd_start_t <= '0';
	elsif (rising_edge(CLOCK_50)) then
      background_snd_start_t <= '1';
      background_snd_stop_t <= '0';
      game_over_snd_start_t <= '0';
      slurp_snd_start_t <= '0';
      scream_snd_start_t <= '0';
      restart_game_t <= '1';
		screen_choice_t <= screen_playing;
      case sm is
          when init =>
              screen_choice_t <= screen_welcome;
              if (space_pressed = '1') then
                  sm <= new_game;
              end if;
          when new_game =>
                  sm <= playing;
                  restart_game_t <= '0';
                  score_t <= init_score;
                  life_t <= init_life;
                  speed_t <= init_speed;
          when playing =>
              if food_eaten = '1' then
                  score_t <= score_t + food_score_value;
                  slurp_snd_start_t <= '1';
              end if;
              if sec = '1' then
                  score_t <= score_t + speed_t;
                  speed_counter <= speed_counter + 1;
                  if speed_counter = speed_increase_threshold then
                      speed_t <= speed_t + 1;
                      speed_counter <= 0;
                  end if;
              end if;
              if (collision = '1') then
                  sm <= collision_detected;
              end if;
          when collision_detected =>
			     -- Wait for collision to end
				  if (collision = '0') then
				      life_t <= shift_right(life_t, 1);
				      if (life_t = "000") then
						    sm <= game_over;
					    else
						    scream_snd_start_t <= '1';
						    speed_t <= init_speed;
						    speed_counter <= 0;
						    restart_game_t <= '0';
						    sm <= playing;
					    end if;
			     end if;
          when game_over =>
              background_snd_stop_t <= '1';
              background_snd_start_t <= '0';
              game_over_snd_start_t <= '1';
              screen_choice_t <= screen_game_over;
				  -- wait for space to be released
				  if (space_pressed = '0') then
				      sm <= game_over_wait;
				  end if;
          when game_over_wait =>
              background_snd_start_t <= '0';
              screen_choice_t <= screen_game_over;
              if (space_pressed = '1') then
                  sm <= new_game;
              end if;
		end case;
	end if;
end process;
speed <= speed_t;
score <= score_t;
life <= life_t;
restart_game <= restart_game_t;
game_over_snd_start <= game_over_snd_start_t;
background_snd_start <= background_snd_start_t;
background_snd_stop <= background_snd_stop_t;
slurp_snd_start <= slurp_snd_start_t;
scream_snd_start <= scream_snd_start_t;
screen_choice <= screen_choice_t;

end behav;
