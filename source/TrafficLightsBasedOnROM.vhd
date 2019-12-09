library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity TrafficLightsBasedOnROM is
	port (
		CLK: in std_logic;
		RST: in std_logic;
		START: in std_logic;
		CWAIT: in std_logic;
		R, Y, G: out std_logic
	);
end TrafficLightsBasedOnROM;

architecture Behavioral of TrafficLightsBasedOnROM is
	type TROM is array (0 to 9) of std_logic_vector(10 downto 0);
	constant ROM: TROM := (
		"000" & "0001" & "0000",
		"010" & "0010" & "0000",
		"100" & "0011" & "0000",
		"100" & "0100" & "0000",
		"100" & "0101" & "0000",
		"110" & "0110" & "0000",
		"001" & "0111" & "0000",
		"001" & "1000" & "0000",
		"001" & "1001" & "0000",
		"000" & "0000" & "1001"
	);
	signal s_current_address: std_logic_vector(3 downto 0) := "0000";
	signal s_next_address: std_logic_vector(3 downto 0);
	signal s_lights: std_logic_vector(2 downto 0);
	signal s_jmp_command: std_logic_vector(3 downto 0);
begin
	ChangeAddress: process(CLK, RST)
	begin
		if RST = '1' then
			s_current_address <= "0000";
		elsif rising_edge(CLK) then
			s_current_address <= s_next_address;
		end if;
	end process;
	
	SelectNextAddress: process(START, CWAIT, s_current_address, s_jmp_command)
	begin
		if (s_current_address = "0000") and (START = '0') then
			s_next_address <= s_jmp_command;
		elsif (s_current_address = "0001") and (CWAIT = '1') then
			s_next_address <= s_jmp_command;
		elsif (s_current_address = "1001") and (CWAIT = '1') then
			s_next_address <= s_jmp_command;
		else
			s_next_address <= ROM(conv_integer(s_current_address))(7 downto 4);
		end if;
	end process;
	
	s_jmp_command <= ROM(conv_integer(s_current_address))(3 downto 0);
	s_lights <= ROM(conv_integer(s_current_address))(10 downto 8);
	
	R <= s_lights(2);
	Y <= s_lights(1);
	G <= s_lights(0);
end Behavioral;
