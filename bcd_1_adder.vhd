library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity bcd_1_adder is
    port (
        A: in STD_LOGIC_VECTOR (4 downto 0);
        B: in STD_LOGIC_VECTOR (4 downto 0);
        C_IN: in STD_LOGIC;
        GREATER_A : in STD_LOGIC;
        SUM: out STD_LOGIC_VECTOR (4 downto 0);
        C_OUT: out STD_LOGIC
    );
end bcd_1_adder;


architecture bcd_1_adder_arch of bcd_1_adder is

begin

	--BCD adder logic
	process (A,B,C_IN,GREATER_A)
	begin
	   -- If both positive or both negative no change in sign and just add (deal with negating in BCD_ADDER)
	   IF((A(4) = '0' AND B(4) = '0') OR((A(4) = '1' AND B(4) = '1'))) THEN
           IF (A + B + C_IN) <= 9 THEN
               SUM <= ((A + B + C_IN) AND "01111");
               C_OUT <= '0';
           ELSE
               SUM <= ((A + B + C_IN + 6) AND "01111");
               C_OUT <= '1';
           END IF;
        
        -- IF A is greater than B then (A-B-Cin-Correction) (deal with negating in BCD_ADDER)
        ELSIF ((A(4) = '0' AND B(4) = '1' AND (GREATER_A = '1')) OR 
        (A(4) = '1' AND B(4) = '0' AND (GREATER_A = '1'))) THEN
           
            IF ((A AND "01111") - (B AND "01111") - C_IN) < 16 THEN
               SUM <= ((A - B - C_IN) AND "01111");
               C_OUT <= '0';
            ELSE
               SUM <= ((A - B - C_IN - 6) AND "01111");
               C_OUT <= '1';
            END IF;
         -- IF B is greater than A then (B-A-Cin-Correction) (deal with negating in BCD_ADDER)
        ELSE
            IF ((B AND "01111") - (A AND "01111") - C_IN) < 16 THEN
               SUM <= ((B - A - C_IN) AND "01111");
               C_OUT <= '0';
            ELSE
               SUM <= ((B - A - C_IN - 6) AND "01111");
               C_OUT <= '1';
            END IF; 
            
        END IF;    
	end process;
	
end bcd_1_adder_arch;