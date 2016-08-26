----------------------------------------------------------------------------------
-- Company: UQ
-- Engineer: NATHAN SMITH
-- 
-- Create Date: 25.09.2015 08:59:57
-- Design Name: 
-- Module Name: stack_controller - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 

-- Description: TAKES USER INPUTS OF NUMBERS AND CONVERTS TO 2's COMP AND
-- THEN PLACES THEM ON THE STACK
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

entity stack_controller is
    Port ( RST : in STD_LOGIC;
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
           );
       end stack_controller;

architecture Behavioral of stack_controller is

    signal top : STD_LOGIC_VECTOR(4 downto 0) := "00001";
    signal top_1 : STD_LOGIC_VECTOR(4 downto 0) := "00000";
    signal EMPTY : STD_LOGIC;
    signal FULL : STD_LOGIC;
    signal POINTER : STD_LOGIC_VECTOR(4 downto 0);
    
begin

    PROCESS(POINTER)
    BEGIN
        if(POINTER = "00000") then
            EMPTY <= '1';
        else
            EMPTY <= '0';
        end if;
        
        if(POINTER = "10011") then
            FULL <= '1';
        else
            FULL <= '0';
        end if;
    END PROCESS;
    
    process(CLK, RST, POINTER)
    begin
        IF(RST = '1') THEN
            ENABLE <= '0';
            WE <= '0';
            POINTER <= "00000";
            top <= "00001";
            top_1 <= "00000";
            
        ELSIF(CLK'EVENT AND CLK = '1') THEN
            IF( ENTER = '1') THEN
                -- Reject if invalid BCD number entered on Switches
                IF((USER_INPUT(11 downto 8) /= "1111") AND
                        (USER_INPUT(7 downto 0) /= "11111111")) THEN
                    IF (FULL = '0') THEN
                        ENABLE <= '1';
                        WE <= '1';
                        POINTER <= top;
                        top <= top + 1;
                        top_1 <= top_1 + 1;
                        TO_STACK <= USER_INPUT;
                    END IF;
                END IF;
                
            -- Pop operation     
            ELSIF (POP = '1') THEN
                IF( EMPTY = '0') THEN
                    ENABLE <= '1';
                    WE <= '0';
                    POINTER <= top_1;
                    top <= top - 1;
                    top_1 <= top_1 - 1;
                END IF;
                
            -- Push operation    
            ELSIF (PUSH = '1') THEN
                IF ( FULL = '0' ) THEN
                    ENABLE <= '1';
                    WE <= '1';
                    POINTER <= top;
                    top <= top + 1;
                    top_1 <= top_1 + 1;
                    --check for overflow
                    IF(ALU_RESULT(16) = '0') THEN
                        TO_STACK <= ALU_RESULT(15 downto 0);
                    ELSE
                        TO_STACK <= "1111111111111111";
                    END IF;
                    
                END IF;    
                  
            ELSE
                ENABLE <= '0';
                WE <= '0';
            END IF;
        END IF;
        ADDR <= POINTER;
    end process;
end Behavioral;
