----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.09.2015 10:34:38
-- Design Name: 
-- Module Name: FSM2 - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FSM2 is
    Port ( DATA_IN : in STD_LOGIC;
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           COUNT : in INTEGER RANGE 0 to 320;
           CSN : out STD_LOGIC;
           SCK : out STD_LOGIC;
           MOSI : out STD_LOGIC;
           MISO : in STD_LOGIC;
           DATA_OUT : out STD_LOGIC_VECTOR( 7 downto 0 )
           );
end FSM2;

architecture Behavioral of FSM2 is
    TYPE State_type IS (A,B,C,D);
    SIGNAL y : State_type;
    SIGNAL DATA : STD_LOGIC;
    SIGNAL READ : STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL WRITE_SEQUENCE : STD_LOGIC_VECTOR(47 downto 0);
    SIGNAL CLOCK_SEQUENCE : STD_LOGIC_VECTOR(47 downto 0);

begin

    WRITE_SEQUENCE <= "001100110000000011001111001100000011001100000000";
    CLOCK_SEQUENCE <= "101010101010101010101010101010101010101010101010";
    PROCESS(RST, CLK)
    BEGIN
        IF RST = '1' THEN
            y <= C;
            SCK <= '1';
            CSN <= '1';
        ELSIF (CLK'event AND CLK = '1') THEN
        
            IF (y = C) THEN
                --SET POWER REG--
                CSN <= '0';
                IF COUNT > 47 THEN
                    y <= A;
                ELSE 
                    DATA <= WRITE_SEQUENCE(COUNT);
                    SCK <= CLOCK_SEQUENCE(COUNT);
                
                END IF;
                    
            ELSIF(COUNT = 0) THEN
                SCK <= '0';
                CSN <= '0';
                y <= B;
            ELSIF (COUNT > 50) THEN
                CSN <= '1';
                SCK <= '1';
            ELSE
                CASE y IS
                    WHEN A =>
                        DATA <= DATA_IN;
                        SCK <= '0';
                        y <= B;
                                    
                    WHEN B =>
                        SCK <= '1';
                        y <= A;
    
                        --Read MISO--
                        IF ((COUNT = 33) OR (COUNT = 34)) THEN
                            READ(7) <= MISO;
                        ELSIF ((COUNT = 35) OR (COUNT = 36)) THEN
                            READ(6) <= MISO;
                        ELSIF ((COUNT = 37) OR (COUNT = 38)) THEN
                            READ(5) <= MISO;
                        ELSIF ((COUNT = 34) OR (COUNT = 40)) THEN
                            READ(4) <= MISO;
                        ELSIF ((COUNT = 42) OR (COUNT = 41)) THEN
                            READ(3) <= MISO;
                        ELSIF ((COUNT = 44) OR (COUNT = 43)) THEN
                            READ(2) <= MISO;
                        ELSIF ((COUNT = 46) OR (COUNT = 45)) THEN
                            READ(1) <= MISO;
                        ELSIF ((COUNT = 47) OR (COUNT = 48)) THEN
                            READ(0) <= MISO;
                        ELSE
                            DATA_OUT <= READ;
                        END IF;
                    WHEN OTHERS =>
                        SCK <= '1';
                        CSN <= '1';
                    
                            
                END CASE;
            END IF;
        END IF;
    END PROCESS;
    --SET OUTPUT--
    MOSI <= DATA;
    
end Behavioral;
