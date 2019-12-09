library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity TrafficLights is
	port (
		CLK: in std_logic;
		RST: in std_logic;
		START: in std_logic;
		CWAIT: in std_logic;
		R, Y, G: out std_logic
	);
end TrafficLights;

architecture Behavioral of TrafficLights is
	type TState is (S0, S1, S2, S3, S4, S5);
	
	signal s_current_state, s_next_state: TState;
	signal s_pclk: std_logic_vector(1 downto 0);
	signal s_lights: std_logic_vector(2 downto 0);
begin
	ChangeState: process(CLK, RST)
	begin
		if RST = '1' then
			s_current_state <= S0;
		elsif rising_edge(CLK) then
			if (s_next_state = S1) or (s_next_state = S3) then
				s_pclk <= (others => '0');
			else
				s_pclk <= s_pclk + 1;
			end if;
			s_current_state <= s_next_state;
		end if;
	end process;
	
	SelectNextState: process(START, CWAIT, s_current_state, s_pclk)
	begin
		case s_current_state is
			when S0 => 
				if START = '1' then
					s_next_state <= S1;
				else
					s_next_state <= S0;
				end if;
			when S1 =>
				if CWAIT = '1' then
					s_next_state <= S0;
				else
					s_next_state <= S2;
				end if;
			when S2 =>
				if s_pclk = "11" then
					s_next_state <= S3;
				else
					s_next_state <= S2;
				end if;
			when S3 =>
				s_next_state <= S4;
			when S4 =>
				if s_pclk = "11" then
					s_next_state <= S5;
				else
					s_next_state <= S4;
				end if;
			when S5 =>
				if CWAIT = '0' then
					s_next_state <= S0;
				else
					s_next_state <= S5;
				end if;
		end case;
	end process;
	
	ApplyNewOutputSignals: process(s_current_state)
	begin
		case s_current_state is
			when S0 => s_lights <= "000";
			when S1 => s_lights <= "010";
			when S2 => s_lights <= "100";
			when S3 => s_lights <= "110";
			when S4 => s_lights <= "001";
			when S5 => s_lights <= "000";
		end case;
	end process;
	
	R <= s_lights(2);
	Y <= s_lights(1);
	G <= s_lights(0);
end Behavioral;
