----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2015 13:26:54
-- Design Name: 
-- Module Name: CONVERTER - Behavioral
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

entity CONVERTER is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           NEG : in STD_LOGIC;
           START : in STD_LOGIC;
           RESULT : in STD_LOGIC_VECTOR (16 downto 0);
           BCD_RESULT : out STD_LOGIC_VECTOR (16 downto 0);
           DONE : out STD_LOGIC);
end CONVERTER;

architecture Behavioral of CONVERTER is
    TYPE State_type IS(S0, S1, S2, S3, S4);
    SIGNAL y : State_type;
    SIGNAL COUNT : STD_LOGIC_VECTOR(16 downto 0);
    SIGNAL NEW_NUMBER : STD_LOGIC;
    SIGNAL EN1 : STD_LOGIC;
    SIGNAL EN2 : STD_LOGIC;
    SIGNAL EN3 : STD_LOGIC;
    SIGNAL EN4 : STD_LOGIC;   

    
    component bcd_counter is
        port (
            reset: in STD_LOGIC;
            clk: in STD_LOGIC;
            count_enable: in STD_LOGIC;
            carry_out: out STD_LOGIC;
            digit_out: out STD_LOGIC_VECTOR (3 downto 0)
        );
    end component;
    SIGNAL CLOCK_COUNT : STD_LOGIC_VECTOR(11 downto 0); 
    SIGNAL CONV_RESULT : STD_LOGIC_VECTOR(16 downto 0);   
    SIGNAL FOUR_COUNT : STD_LOGIC_VECTOR(1 downto 0); 
begin

    d1: bcd_counter port map (
        reset => NEW_NUMBER,
        clk => CLK,
        count_enable => EN1,
        carry_out => EN2,
        digit_out => CONV_RESULT(3 downto 0)
    );
    
    d2: bcd_counter port map (
        reset => NEW_NUMBER,
        clk => CLK,
        count_enable => EN2,
        carry_out => EN3,
        digit_out => CONV_RESULT(7 downto 4)
    );
    
    d3: bcd_counter port map (
        reset => NEW_NUMBER,
        clk => CLK,
        count_enable => EN3,
        carry_out => EN4,
        digit_out => CONV_RESULT(11 downto 8)
    );
    
    d4: bcd_counter port map (
        reset => NEW_NUMBER,
        clk => CLK,
        count_enable => EN4,
        carry_out => CONV_RESULT(16),
        digit_out => CONV_RESULT(15 downto 12)
    );

    PROCESS( RST, CLK )
    BEGIN
        IF( RST = '1' ) THEN
            y <= S0;
            NEW_NUMBER <= '1';
            COUNT <= "00000000000000000";
            DONE <= '0';
            FOUR_COUNT <= "00";
        ELSIF (CLK'event AND CLK = '1') THEN
            case y IS
                WHEN S0 =>
                    IF (START = '1') THEN
                        y <= S1;
                        COUNT <= RESULT;
                        NEW_NUMBER <= '1';
                        DONE <= '0';
                        CLOCK_COUNT <= "000000000000";
                    ELSE
                        CLOCK_COUNT <= CLOCK_COUNT + '1';
                        IF (CLOCK_COUNT(11) = '1') THEN
                            DONE <= '0';
                        END IF;
                        y <= S0;
                    END IF;
                WHEN S1 =>
                    IF(RESULT(16) = '1') THEN
                        BCD_RESULT <= "10000000000000000";
                        y <= S0;
                        DONE <= '1';
                    ELSE
                        COUNT <= COUNT - '1';
                        NEW_NUMBER <= '0';
                        IF (COUNT > "00000000000000000") THEN
                            EN1 <= '1';
                            y <= S1;
                        ELSE
                            y <= S4;
                            EN1 <= '0'; 
                        END IF;  
                    END IF;              
                WHEN S2 =>
                    IF( NEG = '1') THEN
                        BCD_RESULT <= "01111" & CONV_RESULT(11 downto 0);
                    ELSE
                        BCD_RESULT <= CONV_RESULT;
                    END IF;
                    y <= S3;
                    
                WHEN S3 =>
                    DONE <= '1';
                    y <= S0;
                    
                WHEN S4 =>
                    --wait for carries
                    FOUR_COUNT <= FOUR_COUNT +1;
                    IF(FOUR_COUNT = "11") THEN
                        y <= S2;
                    ELSE
                        y <= S4;
                    END IF;
            end case;
        end if;
    end process;
end Behavioral;
