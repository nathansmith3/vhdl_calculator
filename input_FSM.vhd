----------------------------------------------------------------------------------
-- Company: UQ
-- Engineer: NATHAN SMITH
-- 
-- Create Date: 25.09.2015 08:59:57
-- Design Name: 
-- Module Name: input_FSM - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 

-- Description: TAKES USER INPUTS OF NUMBERS
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

entity input_FSM is
    Port ( RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           SWITCHES : in STD_LOGIC_VECTOR (7 downto 0);
           LOAD : in STD_LOGIC; -- MUST BE DEBOUNCED
           TEMP : out STD_LOGIC_VECTOR (15 downto 0));
end input_FSM;

architecture Behavioral of input_FSM is
    
    TYPE State_type IS (A,B,C);
    SIGNAL y : State_type;

begin
    
    --LOADING NUMBERS TO TEMP AND PUSHING TEMP TO STACK
    PROCESS(CLK, RST)
    BEGIN
        IF RST = '1' THEN
            y <= A;
        ELSIF (CLK'event AND CLK = '1') THEN
            CASE y IS
                WHEN A =>
                    y <= B;
                    TEMP <= "0000000000000000";
                    
                WHEN B =>
                    IF((SWITCHES(3 downto 0) > "1001") OR ((SWITCHES(7 downto 4) > "1001") AND
                             (SWITCHES(7 downto 4) /= "1111")))  THEN
                        TEMP(15 downto 8) <= "11111111";
                    ELSE
                        TEMP(15 downto 8) <= SWITCHES(7 downto 0);
                        IF LOAD = '1' THEN
                            y <= C;
                        END IF;
                    END IF;
                    
                WHEN C =>
                    IF( (SWITCHES(7 downto 4) > "1001") OR (SWITCHES(3 downto 0) > "1001")) THEN
                        TEMP(7 downto 0) <= "11111111";
                    ELSE
                        TEMP(7 downto 0) <= SWITCHES(7 downto 0);
                        IF LOAD = '1' THEN
                            y <= A;
                        END IF;
                    END IF;
            END CASE;
        END IF;
    END PROCESS;   
end Behavioral;
