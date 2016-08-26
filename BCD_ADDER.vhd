----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.10.2015 09:09:41
-- Design Name: 
-- Module Name: BCD_ADDER - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BCD_ADDER is
    Port ( A : in STD_LOGIC_VECTOR (16 downto 0);
           B : in STD_LOGIC_VECTOR (16 downto 0);
           RESULT : out STD_LOGIC_VECTOR (16 downto 0));
end BCD_ADDER;

architecture Behavioral of BCD_ADDER is

    component bcd_1_adder port (
        A: in STD_LOGIC_VECTOR (4 downto 0);
        B: in STD_LOGIC_VECTOR (4 downto 0);
        GREATER_A: in STD_LOGIC;
        C_IN: in STD_LOGIC;
        SUM: out STD_LOGIC_VECTOR (4 downto 0);
        C_OUT: out STD_LOGIC
    );
 end component;
    
    SIGNAL C_OUT_0 : STD_LOGIC := '0';
    SIGNAL C_OUT_1 : STD_LOGIC ;
    SIGNAL C_OUT_2 : STD_LOGIC;
    SIGNAL C_OUT_3 : STD_LOGIC;
    SIGNAL C_OUT_4 : STD_LOGIC;
    
    SIGNAL GREATER_A : STD_LOGIC:= '0';
    
    SIGNAL A15to12 : STD_LOGIC_VECTOR(3 downto 0):= "0000";
    SIGNAL B15to12 : STD_LOGIC_VECTOR(3 downto 0):= "0000";

    SIGNAL GROUND :STD_LOGIC_VECTOR(3 DOWNTO 0);
    
    SIGNAL RES_ADD : STD_LOGIC_VECTOR(16 downto 0);
    
begin

    b4:
    bcd_1_adder port map (
        A => A(16) & A15to12,
        B => B(16) & B15to12,
        C_IN => C_OUT_3,
        GREATER_A => GREATER_A,
        SUM(3 DOWNTO 0) => RES_ADD(15 downto 12),
        SUM(4) => GROUND(3),
        C_OUT => RES_ADD(16)
        );
        
    b3:
    bcd_1_adder port map (
        A => A(16) & A(11 downto 8),
        B => B(16) & B(11 downto 8),
        C_IN => C_OUT_2,
        GREATER_A => GREATER_A,
        SUM(3 DOWNTO 0) => RES_ADD(11 downto 8),
        SUM(4) => GROUND(2),
        C_OUT => C_OUT_3
        );
                
    b2:
    bcd_1_adder port map (
        A => A(16) & A(7 downto 4),
        B => B(16) & B(7 downto 4),
        C_IN => C_OUT_1,
        GREATER_A => GREATER_A,
        SUM(3 DOWNTO 0) => RES_ADD(7 downto 4),
        SUM(4) => GROUND(1),
        C_OUT => C_OUT_2
        );
        
    b1:
    bcd_1_adder port map (
        A => A(16) & A(3 downto 0),
        B => B(16) & B(3 downto 0),
        C_IN => C_OUT_0,
        GREATER_A => GREATER_A,
        SUM(3 DOWNTO 0) => RES_ADD(3 downto 0),
        SUM(4) => GROUND(0),
        C_OUT => C_OUT_1
        );
        
    -- Check if Negative result is expected and if the result is out of range    
    PROCESS(A, B, RES_ADD, GREATER_A)
    BEGIN
        IF((A(16) = '1' AND B(16) = '1') OR 
                (A(16) = '1' AND B(16) = '0' AND GREATER_A = '1') OR
                (A(16) = '0' AND B(16) = '1' AND GREATER_A = '0')
        ) THEN
            RESULT(16) <= RES_ADD(15) OR RES_ADD(14) OR RES_ADD(13) OR RES_ADD(12);
            RESULT(15 downto 12) <= "1111";
            RESULT(11 downto 0) <= RES_ADD(11 downto 0);
        ELSE
            RESULT(16 downto 0) <= RES_ADD(16 downto 0);
        END IF;
            
    END PROCESS;
        
    -- Format Negative Numbers suitable for ALU and calculaate if A is greater than B    
    PROCESS(A, B)
    BEGIN
        IF(A(15 downto 12) = "1111") THEN
            A15to12 <= "0000";
        ELSE
            A15to12 <= A(15 downto 12);
        END IF;
        IF(B(15 downto 12) = "1111") THEN
            B15to12 <= "0000";        
        ELSE
            B15to12 <= B(15 downto 12);
        END IF;
        
        --Neither are negative and 10s digit non equal
        IF((A(15 downto 12) /= "1111") AND (B(15 downto 12) /= "1111") 
                    AND (A(15 downto 12) /= B(15 downto 12))) THEN
            IF(A(15 downto 12) > B(15 downto 12)) THEN
                GREATER_A <= '1';
            ELSIF(A(15 downto 12) < B(15 downto 12)) THEN
                GREATER_A <= '0';
            END IF;
                
        -- A is negative and 10s digit of B is greater than 0   
        ELSIF((A(15 downto 12) = "1111") AND (B(15 downto 12) /= "0000")) THEN
                GREATER_A <= '0';  
        
        -- B is negative and 10s digit of A is greater than 0
        ELSIF((B(15 downto 12) = "1111") AND (A(15 downto 12) /= "0000")) THEN
                GREATER_A <= '1';  

        -- if lower digits need comparason
        ELSE
            IF(A(11 downto 8) > B(11 downto 8)) THEN
                GREATER_A <= '1';
            ELSIF(A(11 downto 8) < B(11 downto 8)) THEN
                GREATER_A <= '0';
            ELSE 
                IF(A(7 downto 4) > B(7 downto 4)) THEN
                    GREATER_A <= '1';
                ELSIF(A(7 downto 4) < B(7 downto 4)) THEN
                    GREATER_A <= '0';
                ELSE
                    IF(A(3 downto 0) >= B(3 downto 0)) THEN
                        GREATER_A <= '1';
                    ELSE
                        GREATER_A <= '0';
                    END IF;
                END IF;
            END IF;
        END IF;
    END PROCESS;
end Behavioral;
