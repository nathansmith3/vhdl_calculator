----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.10.2015 12:56:33
-- Design Name: 
-- Module Name: Count_Converter - Behavioral
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
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;


entity bcd_counter is
    port (
        reset: in STD_LOGIC;
        clk: in STD_LOGIC;
        count_enable: in STD_LOGIC;
        carry_out: out STD_LOGIC;
        digit_out: out STD_LOGIC_VECTOR (3 downto 0)
    );
end bcd_counter;

architecture bcd_counter_arch of bcd_counter is

	signal counter_value: STD_LOGIC_VECTOR (3 downto 0);
begin

	process(clk, reset, counter_value, count_enable)
	begin
		if reset = '0' then
			counter_value <= "0000";
			carry_out <= '0';
			
		elsif clk'EVENT and clk = '1' then
            if count_enable = '1' then 
                if counter_value < 9 then
                counter_value <= counter_value + 1;
                carry_out <= '0'; 
                        
                else 
                counter_value <= "0000";		
                carry_out <= '1';
                end if;
            else 
                carry_out <= '0';
            end if ; 
            
        end if;
	end process;
	
	digit_out <= counter_value;

 end bcd_counter_arch;
