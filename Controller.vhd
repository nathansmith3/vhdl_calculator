----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.09.2015 15:28:29
-- Design Name: 
-- Module Name: Controller - Behavioral
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Controller is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           MOSI : out STD_LOGIC;
           COUNT : out INTEGER RANGE 0 to 320);
end Controller;

architecture Behavioral of Controller is

    SIGNAL CLK_COUNT : INTEGER RANGE 0 to 320;
    SIGNAL X_SEQUENCE : STD_LOGIC_VECTOR( 51 downto 0 ); 
    SIGNAL Y_SEQUENCE : STD_LOGIC_VECTOR( 51 downto 0 ); 
    SIGNAL Z_SEQUENCE : STD_LOGIC_VECTOR( 51 downto 0 );
    

begin

    X_SEQUENCE <= "0000000000000000000000000001100000000111100110000000";
    Y_SEQUENCE <= "0000000000000000000001100001100000000111100110000000";
    Z_SEQUENCE <= "0000000000000000000000011001100000000111100110000000";
    
    COUNT <= CLK_COUNT;

    PROCESS(RST, CLK)
    BEGIN
        IF RST = '1' THEN
            CLK_COUNT <= 0;
            MOSI <= '0';
            
        ELSIF (CLK'event AND CLK = '1') THEN
                   
                --SPI COMMAND TO READ X--
                IF (CLK_COUNT > 299) THEN
                    CLK_COUNT <= 0;    
                ELSIF ((CLK_COUNT > 50) AND ((CLK_COUNT < 300))) THEN
                    MOSI <= '0';
                    CLK_COUNT <= CLK_COUNT + 1;
                    
                ELSE
                    MOSI <= X_SEQUENCE(CLK_COUNT);
                    CLK_COUNT <= CLK_COUNT + 1;

                END IF;
                    

--                WHEN "10" =>
               
--                    --SPI COMMAND TO READ Y--
--                    IF (CLK_COUNT = 300) THEN
--                        CLK_COUNT <= 0;    
--                    ELSIF CLK_COUNT > 50 THEN
--                        MOSI <= '0';
--                        CLK_COUNT <= CLK_COUNT + 1;
--                    ELSE
--                        MOSI <= Y_SEQUENCE(CLK_COUNT);
--                        CLK_COUNT <= CLK_COUNT + 1;   
--                    END IF;
                    
                    
                                       
                
--                WHEN "11" =>
                
--                    --SPI COMMAND TO READ Z--
--                    IF (CLK_COUNT = 300) THEN
--                        CLK_COUNT <= 0;    
--                    ELSIF CLK_COUNT > 50 THEN
--                        MOSI <= '0';
--                        CLK_COUNT <= CLK_COUNT + 1;
--                    ELSE
--                        MOSI <= Z_SEQUENCE(CLK_COUNT);  
--                        CLK_COUNT <= CLK_COUNT + 1; 
--                    END IF;
                    
    
--                WHEN OTHERS =>
--                    CLK_COUNT <= 0;
         END IF;
     END PROCESS;

end Behavioral;
