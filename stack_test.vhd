----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.10.2015 20:45:17
-- Design Name: 
-- Module Name: stack_test - Behavioral
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity stack_test is
--  Port ( );
end stack_test;

architecture Behavioral of stack_test is

   component STACK is Port ( 
        WE : in STD_LOGIC;
        EN : in STD_LOGIC;
        ADDR : in STD_LOGIC_VECTOR (4 downto 0);
        DATA_IN : in STD_LOGIC_VECTOR (15 downto 0);
        DATA_OUT : out STD_LOGIC_VECTOR (15 downto 0);
        CLK : in STD_LOGIC
    ); end component;
    
    component stack_controller port (
        RST : in STD_LOGIC;
        CLK : in STD_LOGIC;
        ENTER : in STD_LOGIC;
        POP : in STD_LOGIC;
        PUSH : in STD_LOGIC;
        USER_INPUT : in STD_LOGIC_VECTOR(15 downto 0);
        ALU_RESULT : in STD_LOGIC_VECTOR(16 downto 0);
        TO_STACK : out STD_LOGIC_VECTOR(15 downto 0);
        ADDR : out STD_LOGIC_VECTOR(4 downto 0);           
        WE : out STD_LOGIC;
        ENABLE : out STD_LOGIC
     ); end component;
     
     signal masterReset : std_logic;
     
     signal ENTER : STD_LOGIC;
     signal POP : STD_LOGIC;
     signal PUSH : STD_LOGIC;
     signal RESULT_ALU : STD_LOGIC_VECTOR(16 downto 0);
     
     signal NUM_input : std_logic_vector(15 downto 0);
     
     signal ADDR : std_logic_vector(4 downto 0);
     signal WE : std_logic;
     signal ENABLE : std_logic;
     signal TO_STACK : std_logic_vector(15 downto 0);
     signal TOS_DISPLAY : std_logic_vector(15 downto 0);
     
     signal clockScalers : std_logic_vector (1 downto 0);
begin

   u3:
	stack_controller port map (
	   RST => masterReset,
	   CLK => clockScalers(1),
	   ENTER => ENTER,
	   POP => POP,
	   PUSH => PUSH,
	   USER_INPUT => NUM_input,
	   ALU_RESULT => RESULT_ALU,
	   TO_STACK => TO_STACK,
	   ADDR => ADDR,
	   WE => WE,
	   ENABLE => ENABLE	
    );
	
	u4:
	STACK port map (
	   CLK => clockScalers(0),
	   WE => WE,
	   EN => ENABLE,
	   ADDR => ADDR,
	   DATA_IN => TO_STACK,
	   DATA_OUT => TOS_DISPLAY
	);
	
	CLK_CYCLE : PROCESS
	BEGIN
	   clockScalers <= "00";
	   wait for 5 ns;
	   clockScalers <= "01";
       wait for 5 ns;
       clockScalers <= "10";
       wait for 5 ns;
       clockScalers <= "11";
       wait for 5 ns;
	end process;
	
	Input : PROCESS
	BEGIN
        masterReset <= '1';
        POP <= '0';
        PUSH <= '0';
        ENTER <= '0';
        NUM_input <= "0000000000000000";
        RESULT_ALU <= "00000000000000000";
	    wait for 20ns;
	    
        masterReset <= '0';
        NUM_input <= "0000000000000001";
        ENTER <= '1';
        wait for 20ns;
        
        NUM_input <= "0000000000000010";
        ENTER <= '0';
        wait for 20ns;
        
        ENTER <= '1';
        wait for 20ns;   
        
        ENTER <= '0';
        wait for 40ns;
        POP <= '1';
        wait for 20ns;
        
        POP <= '0';
        wait for 40ns;
        
        POP <= '1';
        wait for 20ns;
        
        POP <= '0';
        wait for 40ns;
        
        POP <= '1';
        wait for 20ns;
        
        POP <= '0';
        wait for 40ns;
        
        POP <= '1';
        wait for 20ns;
        
        POP <= '0';
        wait for 40ns;
        
        RESULT_ALU <= "00000000000000001";
        PUSH <= '1';
        
                

        wait; 
        
           
	   
	END PROCESS;

end Behavioral;
