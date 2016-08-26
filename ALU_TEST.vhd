----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.10.2015 10:12:45
-- Design Name: 
-- Module Name: ALU_TEST - Behavioral
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

entity ALU_TEST is
--  Port ( );
end ALU_TEST;

architecture Behavioral of ALU_TEST is

    component ALU port (  
       A : in STD_LOGIC_VECTOR (16 downto 0);
               B : in STD_LOGIC_VECTOR (16 downto 0);
               OPCODE : in STD_LOGIC_VECTOR (2 downto 0);
               RST : in STD_LOGIC;
               SWAP_COUNT : in STD_LOGIC;
               clockScalers : in STD_LOGIC_VECTOR(11 downto 0);
               START : in STD_LOGIC;
               DONE : out STD_LOGIC;
               RESULT : out STD_LOGIC_VECTOR (16 downto 0));
    end component;
    
    SIGNAL A: STD_LOGIC_VECTOR (16 downto 0);
    SIGNAL B:  STD_LOGIC_VECTOR (16 downto 0);
    SIGNAL RESULT:  STD_LOGIC_VECTOR (16 downto 0);
    SIGNAL OPCODE:  STD_LOGIC_VECTOR (2 downto 0);
    SIGNAL START: STD_LOGIC;
    SIGNAL DONE: STD_LOGIC;
    SIGNAL RST : STD_LOGIC;
    SIGNAL clockScalers : STD_LOGIC_VECTOR(11 downto 0);
    SIGNAL SWAP_COUNT: STD_LOGIC :='0';

    
    SIGNAL PUSH : STD_LOGIC;

begin

    a1:
    ALU port map (
        A => A,
        B => B,
        RST => RST,
        clockScalers => clockScalers,
        OPCODE => OPCODE,
        START => START,
        DONE => DONE,
        RESULT => RESULT,
        SWAP_COUNT => SWAP_COUNT
    );
    
    PROCESS
    BEGIN
        IF(RST = '1') THEN
            clockScalers <= "000000000000";
            wait for 1ns;
        ELSE
            clockScalers <= clockScalers +1;
            wait for 5ns;
        END IF;
    END PROCESS;
    
    PROCESS
    BEGIN
        RST <= '1';
        wait for 10ns;
        RST <= '0';
        wait for 200ns;
        OPCODE <= "101";
        A <= '0' & X"5000";
        B <= '0' & X"0200";
        START <= '1';
        wait for 20480ns;
        START <= '0';
        while (DONE <= '0') LOOP
            wait for 20480ns;
        END LOOP;
        PUSH <= '1';
        
        

        WAIT;
    END PROCESS;
    
end Behavioral;
