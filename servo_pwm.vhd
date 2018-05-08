library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity servo_pwm is
    PORT (
        clk   				: IN STD_LOGIC;
        position			: IN std_logic_vector(3 downto 0);
        Kservo, Tservo 	: OUT STD_LOGIC
    );
end servo_pwm;

architecture Behavioral of servo_pwm is
	type state_klauw is (input, hoog, laag);
	type state_selector is (choose, pause);
	type state_twist is (input, hoog, laag);
		signal klauw 	: state_klauw;
		signal twist 	: state_twist;
		signal selector: state_selector;
		-- de klok is 64khz. de servo kan 128 posities aannemen.
		signal Kteller 	: unsigned(10 downto 0);
		signal Tteller 	: unsigned(10 downto 0);
		signal Ktijd		: unsigned(10 downto 0);
		signal Ttijd		: unsigned(10 downto 0);
		signal seconde	: unsigned(17 downto 0);
		signal openDicht : std_LOGIC;

begin
    pwm: process (clk, position) begin
        if rising_edge(clk) then
				case klauw is
					when input =>
						Kteller <= Ktijd;
						klauw <= hoog;
					when hoog =>
						Kservo <= '1';
						Kteller <= Kteller - 1;
						if Kteller = 0 then	
							Kteller <= Kteller + 400;
							klauw <= laag;
							end if;
					when laag =>
						Kservo <= '0';
						Kteller <= Kteller - 1;
						if Kteller = 0 then
							klauw <= input;
							end if;
					when others =>
						klauw <= input;
						end case;
						
				case twist is
					when input =>
						Tteller <= Ttijd;
						twist <= hoog;
					when hoog =>
						Tservo <= '1';
						Tteller <= Tteller - 1;
						if Tteller = 0 then	
							Tteller <= Tteller + 400;
							twist <= laag;
							end if;
					when laag =>
						Tservo <= '0';
						Tteller <= Tteller - 1;
						if Tteller = 0 then
							twist <= input;
							end if;
					when others =>
						twist <= input;
						
						end case;
						
						
				case selector is
					when choose =>
						if position(0) = '1' then
							-- dicht
								Ktijd <= to_unsigned(50,11);
								seconde <= to_unsigned(8000,18);
								selector <= pause;
							end if;
						if position(0) = '0' then
							-- open
								Ktijd <= to_unsigned(40,11);
								seconde <= to_unsigned(8000,18);
								selector <= pause;
							end if;
						if position(1) = '1' then
							--links
							Ttijd <= to_unsigned(64,11);
							seconde <= to_unsigned(8000,18);
							selector <= pause;
							end if;
						if position(2) = '1' then
							--mid
							Ttijd <= to_unsigned(36,11);
							seconde <= to_unsigned(8000,18);
							selector <= pause;
							end if;
						if position(3) = '1' then
							--rechts
							Ttijd <= to_unsigned(13,11);
							seconde <= to_unsigned(8000,18);
							selector <= pause;
							end if;
					when pause =>
							seconde <= seconde - 1;
							if seconde = 0 then	
								selector <= choose;
								end if;
					when others =>
						Ttijd <= to_unsigned(34,11);
						Ktijd <= to_unsigned(50,11);
						selector <= choose;
					end case;
						
						--grijper open is 45 tellen
						--grijper dicht is 55 tellen
						--grijper min/rechts is 14 tellen
						--grijper mid is 34 tellen
						--grijper max/links is 62 tellen
						
				end if;
			end process;
end Behavioral;