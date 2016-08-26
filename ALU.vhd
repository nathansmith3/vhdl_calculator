----------------------------------------------------------------------------------
-- Company: UQ
-- Engineer: NATHAN SMITH
-- 
-- Create Date: 25.09.2015 08:52:06
-- Design Name: 
-- Module Name: ALU - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 

-- Description: TAKES TWO SIGNED FIXED POINT INTEGERS AND AN OPCODE AND OUTPUTS
-- THE RESULT OF THE SELECTED OPERATION
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

entity ALU is
    Port ( A : in STD_LOGIC_VECTOR (16 downto 0);
           B : in STD_LOGIC_VECTOR (16 downto 0);
           OPCODE : in STD_LOGIC_VECTOR (2 downto 0);
           RST : in STD_LOGIC;
           SWAP_COUNT : in STD_LOGIC;
           clockScalers : in STD_LOGIC_VECTOR(11 downto 0);
           START : in STD_LOGIC;
           DONE : out STD_LOGIC;
           RESULT : out STD_LOGIC_VECTOR (16 downto 0));
end ALU;

architecture Behavioral of ALU is

    component BCD_ADDER port (
        A : in STD_LOGIC_VECTOR (16 downto 0);
        B : in STD_LOGIC_VECTOR (16 downto 0);
        RESULT :  out STD_LOGIC_VECTOR (16 downto 0)
    ); end component;
    
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
    
    component BCD_DIVIDER is
        Port ( CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               A : in STD_LOGIC_VECTOR (16 downto 0);
               B : in STD_LOGIC_VECTOR (16 downto 0);
               START : in STD_LOGIC;
               DONE : out STD_LOGIC;
               NEG : out STD_LOGIC;
               RESULT : out STD_LOGIC_VECTOR (16 downto 0));
    end component;
    
    signal RES_ADD : STD_LOGIC_VECTOR(16 downto 0);
    signal B_INV : STD_LOGIC;
    signal NEG_MUL : STD_LOGIC;
    signal NEG_DIV : STD_LOGIC;

    
    signal DONE_MUL : STD_LOGIC;
    signal DONE_CONV : STD_LOGIC;
    signal RES_CONV : STD_LOGIC_VECTOR(16 downto 0);
    signal RES_MUL_BIN : STD_LOGIC_VECTOR(16 downto 0);

    signal DONE_DIV : STD_LOGIC;
    signal DONE_DIV_CONV : STD_LOGIC;
    signal RES_DIV_CONV : STD_LOGIC_VECTOR(16 downto 0);
    signal RES_DIV_BIN : STD_LOGIC_VECTOR(16 downto 0);
    
begin

    a1:
    BCD_ADDER port map (
        A => A,
        B => B_INV & B(15 downto 0),
        RESULT => RES_ADD
    );
    
    c1: CONVERTER port map (
        RST => RST,
        CLK => clockScalers(0),
        START => DONE_MUL,
        RESULT => RES_MUL_BIN,
        DONE => DONE_CONV,
        NEG => NEG_MUL,
        BCD_RESULT => RES_CONV
        
        );
        
    c2: CONVERTER port map (
        RST => RST,
        CLK => clockScalers(0),
        START => DONE_DIV,
        RESULT => RES_DIV_BIN,
        NEG => NEG_DIV,
        DONE => DONE_DIV_CONV,
        BCD_RESULT => RES_DIV_CONV       
        );
        
    m1 : BCD_MULTIPLIER port map(
        RST => RST,
        CLK => clockScalers(11),
        START => START,
        NEG => NEG_MUL,
        RESULT => RES_MUL_BIN,
        A => A,
        B => B,
        DONE => DONE_MUL
        );
        
    d1 : BCD_DIVIDER port map (
        RST => RST,
        CLK => clockScalers(11),
        START => START,
        NEG => NEG_DIV,
        RESULT => RES_DIV_BIN,
        A => A,
        B => B,
        DONE => DONE_DIV
        );

    -- If Subtration invert B's sign bit
    PROCESS(RST, DONE_DIV_CONV, B, OPCODE, DONE_CONV, SWAP_COUNT, RES_DIV_BIN)
    BEGIN
        -- If Subtration invert B's sign bit
        IF(RST = '1') THEN
            RESULT <= '0' & X"0000";
            DONE <= '0';
        ELSE

            B_INV <= B(16) XOR OPCODE(1);
            IF(OPCODE(0) = '0') THEN
                DONE <= '1';
                RESULT <= RES_ADD;
            ELSIF(OPCODE = "001") THEN
                DONE <= DONE_CONV;
                RESULT <= RES_CONV;
            ELSIF(OPCODE = "011") THEN
                IF(SWAP_COUNT = '0') THEN
                    RESULT <= A;
                    DONE <= '1';
                ELSE
                    RESULT <= B;
                    DONE <= '0';
                END IF;
            ELSIF(OPCODE = "101") THEN
                DONE <= DONE_DIV_CONV;
                RESULT <= RES_DIV_CONV;
            END IF;
        END IF;
    END PROCESS;
               
end Behavioral;
