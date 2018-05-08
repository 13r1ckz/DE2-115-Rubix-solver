library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- pinassignment
-- grijper1 -> kvervo1 gpio5
--					tservo1 gpio6
--	grijper2	->	kservo2 gpio7
-- 				tservo2 gpio8
-- 5v "gpio10"
-- ground "gpio11"
-- switch 0 en 4 klauw
-- switch 1-3 en 5-7 rotatie




entity servoMotor is
    PORT(
        clk  			:	IN STD_LOGIC;
        positie 		:	IN std_logic_vector(17 downto 0);
        Kservo1, Kservo2, Tservo1, Tservo2	:	OUT STD_LOGIC

    );
end entity servoMotor;

architecture Behavioral of servoMotor is
		component clock2000hz is
			Port (	clk    : in  STD_LOGIC;
						clk_out: out STD_LOGIC
					);
		end component clock2000hz;
    
		component servo_pwm is
			PORT (	clk   	: IN STD_LOGIC;
						position	: IN std_logic_vector(3 downto 0);
						Kservo,Tservo 	: OUT STD_LOGIC
					);
		end component servo_pwm;
		
    signal clk_out : STD_LOGIC := '0';
begin
    clock200hz_map		: clock2000hz PORT MAP(clk, clk_out);
	 servo_pwm_grijper1	: servo_pwm PORT MAP(clk_out, positie(3 downto 0), Kservo1, Tservo1);
	 servo_pwm_grijper2	: servo_pwm PORT MAP(clk_out, positie(7 downto 4), Kservo2, Tservo2);
	 
end Behavioral;

-- qsys component

--register namaken van de elo