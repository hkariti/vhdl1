library ieee ;
use ieee.std_logic_1164.all ;
entity HEXSS is port (
		din : in std_logic_vector(3 downto 0) ; 
		ss : out std_logic_vector(6 downto 0) ;
		blinkN : in std_logic ;
		LAMP_TEST : in std_logic 
		);
end HEXSS ;
architecture behavior of HEXSS is
begin
	process(din, blinkN, LAMP_TEST)
    begin
		if( LAMP_TEST = '1') then
			ss <= "0000000";
        elsif (blinkN = '1') then
			ss <= "1111111";
        else
            case din is
                when "0000" => ss <= "1000000"; --0
                when "0001" => ss <= "1111001"; --1
                when "0010" => ss <= "0100100"; --2
                when "0011" => ss <= "0110000"; --3
                when "0100" => ss <= "0011001"; --4
                when "0101" => ss <= "0010010"; --5
                when "0110" => ss <= "0000010"; --6
                when "0111" => ss <= "1111000"; --7
                when "1000" => ss <= "0000000"; --8
                when "1001" => ss <= "0010000"; --9
                when "1010" => ss <= "0001000"; --10
                when "1011" => ss <= "0000011"; --11
                when "1100" => ss <= "1000110"; --12
                when "1101" => ss <= "0100001"; --13
                when "1110" => ss <= "0000110"; --14
                when "1111" => ss <= "0001110"; --15
                when others => null;
            end case;
		end if;
	end process;
end ;
