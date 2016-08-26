----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2015 13:57:35
-- Design Name: 
-- Module Name: test_TOP - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_TOP is
--  Port ( );
end test_TOP;

architecture Behavioral of test_TOP is

    component ProjectTop is Port ( ssegAnode : out  STD_LOGIC_VECTOR (7 downto 0);
           ssegCathode : out  STD_LOGIC_VECTOR (7 downto 0);
           slideSwitches : in  STD_LOGIC_VECTOR (12 downto 0);
           pushButtons : in  STD_LOGIC_VECTOR (3 downto 0);
	       clk100mhz : in STD_LOGIC
    );
    end component;
    
    SIGNAL clk100mhz : STD_LOGIC;
    SIGNAL slideSwitches : STD_LOGIC_VECTOR(12 downto 0);
    SIGNAL pushButtons : STD_LOGIC_VECTOR(3 downto 0);

begin

    board1:
    ProjectTop port map (
        clk100mhz => clk100mhz,
        pushButtons => pushButtons,
        slideSwitches => slideSwitches
    );
    
    CLK: PROCESS
    BEGIN 
        clk100mhz <= '0';   
        wait for 5ns;
        clk100mhz <= '1';      
        wait for 5ns;      
    END PROCESS;
    
    
    INPUT: PROCESS
    BEGIN
    
        slideSwitches <= "0000000000000";
        pushButtons <= "0000";
        wait for 30ns;
        
        pushButtons <= "0001"; -- reset button
        wait for 20ns;
        
        pushButtons <= "0000";
        slideSwitches <= "0000100000001"; -- 01.00
        wait for 100ns;
        
        pushButtons <= "0100"; -- enter button
        wait for 100ns;
        
        pushButtons <= "0000";
  --      slideSwitches <= "0000100000010"; -- 02.00
        wait for 20ns;
        
    --    pushButtons <= "0100"; -- execute button (enter)
        wait for 100ns;
        
     --   pushButtons <= "0000";
          slideSwitches <= "0000100000000"; -- 00.00
       --   pushButtons <= "0010"; -- load button
      --    wait for 100ns;
        
--        pushButtons <= "0000";
--        slideSwitches <= "0000100010000"; -- 10.00
--        wait for 20ns;
        
--        pushButtons <= "0010"; -- load button
--        wait for 82000ns;
        
        pushButtons <= "0000";
        wait for 40ns;
        slideSwitches <= "1000000000100"; -- 00.45
        wait for 20ns;
        
        pushButtons <= "0100"; -- execute button (add)
        wait for 100ns;

        pushButtons <= "0000";
        wait for 500ns;
        
        slideSwitches <= "0001001000101"; 
        pushButtons <= "0100"; -- execute button (pop)
        wait for 100ns;
        
--        pushButtons <= "0000"; 
--        wait for 500 ns;
        
--        slideSwitches <= "0010001000101"; -- 45.00
--        pushButtons <= "0100"; -- execute button (add)
--        wait for 100ns;
        pushButtons <= "0000";
        
        wait for 200ns;
        
        slideSwitches <= "0001001000101"; 
        pushButtons <= "0100"; -- execute button (pop)
        wait for 100ns;
        
        wait;


    end PROCESS;
end Behavioral;
