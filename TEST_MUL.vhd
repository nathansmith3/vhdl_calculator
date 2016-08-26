----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2015 20:56:45
-- Design Name: 
-- Module Name: TEST_MUL - Behavioral
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

entity TEST_MUL is
--  Port ( );
end TEST_MUL;

architecture Behavioral of TEST_MUL is

    component CONVERTER is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           NEG : in STD_LOGIC;
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
               NEG : out STD_LOGIC;
               START : in STD_LOGIC;
               DONE : out STD_LOGIC;
               RESULT : out STD_LOGIC_VECTOR (16 downto 0));
    end component;

    SIGNAL clk100mhz : STD_LOGIC;
    SIGNAL RST: STD_LOGIC;
    SIGNAL START : STD_LOGIC;
    SIGNAL NEG : STD_LOGIC;
    SIGNAL RES_MUL_BIN : STD_LOGIC_VECTOR (16 downto 0);
    SIGNAL A : STD_LOGIC_VECTOR (16 downto 0);
    SIGNAL B : STD_LOGIC_VECTOR (16 downto 0);
    SIGNAL DONE_MUL : STD_LOGIC;
    signal clockScalers : std_logic_vector (11 downto 0);    
    signal RES_CONV: STD_LOGIC_VECTOR (16 downto 0);
    signal DONE_CONV: STD_LOGIC;

begin

     c1: CONVERTER port map (
        RST => RST,
        CLK => clockScalers(0),
        START => DONE_MUL,
        RESULT => RES_MUL_BIN,
        DONE => DONE_CONV,
        NEG => NEG,
        BCD_RESULT => RES_CONV      
        );
        
    m1 : BCD_MULTIPLIER port map(
            RST => RST,
            CLK => clockScalers(11),
            START => START,
            NEG => NEG,
            RESULT => RES_MUL_BIN,
            A => A,
            B => B,
            DONE => DONE_MUL
        );
        

    PROCESS
    BEGIN 
        clk100mhz <= '0';   
        wait for 5ns;
        clk100mhz <= '1';      
        wait for 5ns;      
    END PROCESS;
    
    -- Slowing down clock	
    process (clk100mhz, RST)
    begin
        if (RST = '1') then
            clockScalers <= "000000000000";
        elsif (clk100mhz'event and clk100mhz = '1')then
            clockScalers <= clockScalers + '1';
        end if;
    end process;
    
    
    INPUT: PROCESS
    BEGIN
        RST <= '1';
        WAIT FOR 100ns;
        RST <= '0';
        WAIT FOR 100ns;
        A<= '0' & X"4700";
        B <= '0' & X"0200";
        WAIT FOR 50us;
        START <= '1';
        WAIT FOR 42us;
        START <= '0';
 
        WAIT;      
    END PROCESS;
        

end Behavioral;
