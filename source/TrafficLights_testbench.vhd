LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY TrafficLights_testbench IS
END TrafficLights_testbench;
 
ARCHITECTURE behavior OF TrafficLights_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT TrafficLights
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         START : IN  std_logic;
         CWAIT : IN  std_logic;
         R : OUT  std_logic;
         Y : OUT  std_logic;
         G : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal START : std_logic := '0';
   signal CWAIT : std_logic := '0';

 	--Outputs
   signal R : std_logic;
   signal Y : std_logic;
   signal G : std_logic;

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: TrafficLights PORT MAP (
          CLK => CLK,
          RST => RST,
          START => START,
          CWAIT => CWAIT,
          R => R,
          Y => Y,
          G => G
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      RST <= '1';
      wait for 100 ns;	
		RST <= '0';
		
      wait for CLK_period*10;

		CWAIT <= '0';
      START <= '1';

      wait;
   end process;

END;
