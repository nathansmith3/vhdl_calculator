----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2015 13:57:53
-- Design Name: 
-- Module Name: TEST_CONVERTER - Behavioral
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

entity TEST_CONVERTER is
--  Port ( );
end TEST_CONVERTER;

architecture Behavioral of TEST_CONVERTER is

    component CONVERTER is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           START : in STD_LOGIC;
           RESULT : in STD_LOGIC_VECTOR (16 downto 0);
           BCD_RESULT : out STD_LOGIC_VECTOR (16 downto 0);
           DONE : out STD_LOGIC);
    end component;
    
   component BCD_MULTIPLIER is
        Port ( CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               A : in STD_LOGIC_VECTOR (16 downto 0);
               B : in STD_LOGIC_VECTOR (16 downto 0);
               START : in STD_LOGIC;
               DONE : out STD_LOGIC;
               RESULT : out STD_LOGIC_VECTOR (16 downto 0));
    end component;

    SIGNAL CLK : STD_LOGIC;
    SIGNAL RST: STD_LOGIC;
    SIGNAL START : STD_LOGIC;
    SIGNAL RESULT : STD_LOGIC_VECTOR (16 downto 0);
    SIGNAL A : STD_LOGIC_VECTOR (16 downto 0);
    SIGNAL B : STD_LOGIC_VECTOR (16 downto 0);
    SIGNAL DONE : STD_LOGIC;
    

begin

    c1: CONVERTER port map (
        RST => RST,
        CLK => CLK,
        START => START,
        RESULT => RESULT
        );
        
    m1 : BCD_MULTIPLIER port map(
        RST => RST,
        CLK => CLK,
        START => START,
        RESULT => RESULT,
        A => A,
        B => B,
        DONE => DONE
        );
        

    PROCESS
    BEGIN 
        CLK <= '0';   
        wait for 5ns;
        CLK <= '1';      
        wait for 5ns;      
    END PROCESS;
    
    
    INPUT: PROCESS
    BEGIN
        RST <= '1';
        FOR I IN 1 TO 4 LOOP
            RESULT <= '0' & X"270F";
            wait for 40ns;
            RST <= '0';
            wait for 40ns;
            START <= '1';
            wait for 100000ns;
            START <= '0';
            wait for 100ns;
        END LOOP;
    END PROCESS;
        

end Behavioral;
