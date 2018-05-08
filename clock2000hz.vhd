library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity clock2000hz is
    Port (
        clk    : in  STD_LOGIC;
        clk_out: out STD_LOGIC
    );
end clock2000hz;
 
architecture Behavioral of clock2000hz is
    signal temporal: STD_LOGIC;
	 -- het word toch 64khz
    signal counter : integer range 0 to 780 := 0;
begin
    mhz50naarhz2000 : process (clk) begin
        if  rising_edge(clk) then
            if (counter = 780) then
                temporal <= NOT(temporal);
                counter  <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
 
    clk_out <= temporal;
end Behavioral;