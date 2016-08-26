----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.09.2015 09:10:19
-- Design Name: 
-- Module Name: operation_controller - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity operation_controller is
    Port ( RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           SWITCHES : in STD_LOGIC_VECTOR (4 downto 0);
           EXECUTE : in STD_LOGIC;
           FROM_STACK : in STD_LOGIC_VECTOR (15 downto 0);
           USER_INPUT : in STD_LOGIC_VECTOR (15 downto 0);
           A : out STD_LOGIC_VECTOR (16 downto 0);
           B : out STD_LOGIC_VECTOR (16 downto 0);
           OPCODE : out STD_LOGIC_VECTOR (2 downto 0);
           SWAP_COUNT : out STD_LOGIC;
           START : out STD_LOGIC;
           DONE : in STD_LOGIC;
           POP : out STD_LOGIC;
           ENTER : out STD_LOGIC;
           PUSH : out STD_LOGIC);
end operation_controller;

architecture Behavioral of operation_controller is

    TYPE State_type IS (S0,S1,S2,S3,S4,S5,S6);
    SIGNAL S : State_type;
    
begin

    PROCESS( CLK, RST )
    BEGIN 
        IF RST = '1' THEN
            S <= S0;
            A <= "00000000000000000";
            B <= "00000000000000000";
            
        ELSIF (CLK'event AND CLK = '1') THEN
            CASE S IS
                WHEN S0 =>
                    POP <= '0';
                    PUSH <= '0';
                    ENTER <= '0';
                    START <= '0';
                    OPCODE <= "000";
                    IF(EXECUTE = '1') THEN
                        S <= S1;
                    END IF;
                    
                WHEN S1 =>
                    -- Enter operation
                    IF(SWITCHES(4 downto 0) = "00001") THEN
                        -- reject entering OFLO
                        IF(FROM_STACK /= "1111111111111111") THEN
                            ENTER <= '1';
                            S <= S0;
                        END IF;
                    
                    -- No operation (do nothing)
                    ELSIF(SWITCHES(4 DOWNTO 0) = "00000") THEN
                        S <= S0;
                    ELSE
                        S <= S2;
                    END IF;
                    
                WHEN S2 =>
                    -- CLR operation
                    IF(SWITCHES(4 downto 0) = "00010") THEN
                        POP <= '1';
                        S <= S0;
                    -- Only allow clear if OFLO is top of stack
                    ELSIF(FROM_STACK /= "1111111111111111") THEN
                        S <= S3;
                        POP <= '1';
                    ELSE
                        S <= S0;
                    END IF;
                
                WHEN S3 =>
                    POP <= '0';
                    START <= '1';
                    
                    -- Set Sign bits
                    IF(FROM_STACK(15 downto 12) = "1111") THEN
                        A(16) <= '1';
                    ELSE 
                        A(16) <= '0';
                    END IF;
                    A(15 downto 0) <= FROM_STACK;
                    IF(USER_INPUT(15 downto 12) = "1111") THEN
                        B(16) <= '1';
                    ELSE 
                        B(16) <= '0';
                    END IF;
                    B(15 downto 0) <= USER_INPUT;
                    
                    --SWAP operation
                    IF(SWITCHES(4 downto 0) = "00011") THEN
                        S <= S6;
                        OPCODE <= "011";

                    --Add operation
                    ELSIF(SWITCHES(4 downto 0) = "00100") THEN
                        OPCODE <= "000";
                        S <= S4;
                    
                    -- Sub operation
                    ELSIF(SWITCHES(4 downto 0) = "01000") THEN
                        OPCODE <= "010";
                        S <= S4;
                        
                    -- Mul operation
                    ELSIF(SWITCHES(4 downto 0) = "10000") THEN
                        OPCODE <= "001";
                        S <= S4;
                                           
                    -- DIV operation
                    ELSIF(SWITCHES(4 downto 0) = "11000") THEN
                        OPCODE <= "101";
                        S <= S4;
                    ELSE
                        S <= S0;
                    END IF;
                    
                WHEN S4 =>
                    START <= '0';
                    IF( DONE = '1') THEN
                        S <= S5;
                    ELSE
                        S <= S4;
                    END IF;
                    
                WHEN S5 =>
                     PUSH <= '1';
                     SWAP_COUNT <= '0';
                     S <= S0;
                     
                WHEN S6 =>
                    SWAP_COUNT <= '1';
                    PUSH <= '1';
                    S <= S5;
                    
            END CASE;
        END IF;
    END PROCESS;
end Behavioral;
