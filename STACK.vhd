----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.10.2015 11:18:47
-- Design Name: 
-- Module Name: STACK - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity STACK is
    Port ( RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           EN : in STD_LOGIC;
           ADDR : in STD_LOGIC_VECTOR (4 downto 0);
           DATA_IN : in STD_LOGIC_VECTOR (15 downto 0);
           DATA_OUT : out STD_LOGIC_VECTOR (15 downto 0);
           CLK : in STD_LOGIC);
end STACK;

architecture Behavioral of STACK is

    type ram_type is array(19 downto 0) of STD_LOGIC_VECTOR(15 downto 0);    
    signal ram : ram_type;
   -- attribute ram_style: string;
    --attribute ram_style of ram : signal is "block";

begin   

    process(CLK, RST)
    begin
        if (RST = '1') then
            DATA_OUT <= "0000000000000000";
        elsif(CLK'EVENT AND CLK = '1') then
            if (EN = '1') then
                if (WE = '1') then
                    ram(to_integer(unsigned(ADDR))) <= DATA_IN;
                end if;
                if(ADDR = "00000") then
                    DATA_OUT <= "0000000000000000";
                else
                    DATA_OUT <= ram(to_integer(unsigned(ADDR)));
                end if;
            end if;
        end if;
    end process;
end Behavioral;
