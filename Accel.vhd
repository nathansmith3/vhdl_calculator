----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.10.2015 18:08:49
-- Design Name: 
-- Module Name: Accel - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Accel is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           INV : out STD_LOGIC;
           MISO : in STD_LOGIC;
           MOSI : out STD_LOGIC;
           SCK : out STD_LOGIC;
           SS : out STD_LOGIC);
end Accel;

architecture Behavioral of Accel is

    component Controller port ( 
               CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               MOSI : out STD_LOGIC;
               COUNT : out INTEGER RANGE 0 to 320
               );
    end component;
    
    component FSM2 port ( 
               DATA_IN : in STD_LOGIC;
               CLK : in STD_LOGIC;
               RST : in STD_LOGIC;
               COUNT : in INTEGER RANGE 0 to 320;
               SCK : out STD_LOGIC;
               CSN : out STD_LOGIC;
               MOSI : out STD_LOGIC;
               MISO : in STD_LOGIC;
               DATA_OUT : out STD_LOGIC_VECTOR( 7 downto 0 )
               );
    end component;
    
    SIGNAL DATA: STD_LOGIC;
    SIGNAL INVERT: STD_LOGIC;
    SIGNAL COUNT: INTEGER RANGE 0 to 320;
    SIGNAL DIGIT_BYTE: STD_LOGIC_VECTOR(7 downto 0);

begin


    F2:
    FSM2 port map (
        CLK => CLK,
        DATA_IN => DATA,
        RST => RST,
        COUNT => COUNT,
        SCK => SCK,
        CSN => SS,
        MOSI => MOSI,
        MISO => MISO,
        DATA_OUT => DIGIT_BYTE
    );
    
    C1:
    Controller port map (
        RST => RST,
        CLK => CLK,
        MOSI => DATA,
        COUNT => COUNT
        );
        
    PROCESS(RST, CLK)
    BEGIN
        IF(RST = '1') THEN
            INVERT <= '0';
        ELSIF(CLK'EVENT AND CLK = '1') THEN
            IF(DIGIT_BYTE(7 downto 4) = X"2") THEN
                INVERT <= '0';
            ELSIF(DIGIT_BYTE(7 downto 4) = X"C") THEN
                INVERT <= '1';               
            ELSE
                INVERT <= INVERT;
            END IF;
       END IF;
    END PROCESS;
    
    INV <= INVERT;
end Behavioral;
