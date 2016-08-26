----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2015 12:32:07
-- Design Name: 
-- Module Name: BCD_MULTIPLIER - Behavioral
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity BCD_MULTIPLIER is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           A : in STD_LOGIC_VECTOR (16 downto 0);
           B : in STD_LOGIC_VECTOR (16 downto 0);
           START : in STD_LOGIC;
           DONE : out STD_LOGIC;
           NEG : out STD_LOGIC;
           RESULT : out STD_LOGIC_VECTOR (16 downto 0));
end BCD_MULTIPLIER;

architecture Behavioral of BCD_MULTIPLIER is

    TYPE State_type IS(one, two, three, four);
    SIGNAL y : State_type;

    SIGNAL MA : STD_LOGIC_VECTOR(19 downto 0);
    SIGNAL MB : STD_LOGIC_VECTOR(19 downto 0);
    SIGNAL PRODUCT : STD_LOGIC_VECTOR(39 downto 0);
    SIGNAL RES : UNSIGNED(39 downto 0);

begin
    PROCESS(CLK, RST)
    BEGIN
        IF( RST = '1' ) THEN
            y <= one;
            NEG <= '0';
        
        ELSIF (CLK'event AND CLK = '1') THEN
            case y IS
                WHEN one =>
                    DONE <= '0';
                    IF (A(16) = '1') THEN
                        MA <= ((A(11 downto 8) * X"0064") + (A(7 downto 4) * X"000A") + A(3 downto 0));
                    ELSE
                        MA <= ((A(15 downto 12)* X"03E8") + (A(11 downto 8) * X"0064") + (A(7 downto 4) * X"000A") + A(3 downto 0));
                    END IF;
                    
                    IF (B(16) = '1') THEN
                        MB <= ((B(11 downto 8) * X"0064") + (B(7 downto 4) * X"000A") + B(3 downto 0));
                    ELSE
                        MB <= ((B(15 downto 12)* X"03E8") + (B(11 downto 8) * X"0064") + (B(7 downto 4) * X"000A") + B(3 downto 0));
                    END IF;
                    
                    NEG <= A(16) XOR B(16);
                    
                    IF(START = '1') THEN
                        y <= two;
                    ELSE 
                        y <= one;
                    END IF;
                    
                WHEN two =>
                    PRODUCT <= MA * MB;         
                    y <= three;
                    
                WHEN three =>
                    RES <= (unsigned(PRODUCT) / 100) ;
                    y <= four;
                    
                WHEN four =>
                    DONE <= '1';
                    IF((A(16) XOR B(16)) = '1') THEN
                        IF(RES > 999) THEN
                            RESULT <= "10000000000000000";
                        ELSE
                            RESULT <= STD_LOGIC_VECTOR(RES(16 downto 0));
                        END IF;
                    ELSE
                        IF(RES > 9999) THEN
                           RESULT <= "10000000000000000";
                        ELSE
                           RESULT <= STD_LOGIC_VECTOR(RES(16 downto 0));
                        END IF;
                    END IF;
                    y <= one;
            end case;
        end if;
    end process;


end Behavioral;
