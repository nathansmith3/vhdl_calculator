----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.10.2015 14:10:49
-- Design Name: 
-- Module Name: ProjectTop - Behavioral
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

entity ProjectTop is
    Port ( ssegAnode : out  STD_LOGIC_VECTOR (7 downto 0);
           ssegCathode : out  STD_LOGIC_VECTOR (7 downto 0);
           slideSwitches : in  STD_LOGIC_VECTOR (12 downto 0);
           pushButtons : in  STD_LOGIC_VECTOR (3 downto 0);
	       clk100mhz : in STD_LOGIC;
	       LEDs : out STD_LOGIC_VECTOR(4 downto 0);
	       aclMISO : in STD_LOGIC;
           aclMOSI : out STD_LOGIC;
           aclSCK : out STD_LOGIC;
           aclSS : out STD_LOGIC
    );
end ProjectTop;

architecture Behavioral of ProjectTop is

	component ssegDriver port (
		clk : in std_logic;
		rst : in std_logic;
	    invert : in std_logic;
		cathode_p : out std_logic_vector(7 downto 0);
		digit1_p : in std_logic_vector(3 downto 0);
		anode_p : out std_logic_vector(7 downto 0);
		digit2_p : in std_logic_vector(3 downto 0);
		digit3_p : in std_logic_vector(3 downto 0);
		digit4_p : in std_logic_vector(3 downto 0);
		digit5_p : in std_logic_vector(3 downto 0);
		digit6_p : in std_logic_vector(3 downto 0);
		digit7_p : in std_logic_vector(3 downto 0);
		digit8_p : in std_logic_vector(3 downto 0)
	); end component;
	
	component input_FSM port (
       RST : in STD_LOGIC;
       CLK : in STD_LOGIC;
       SWITCHES : in STD_LOGIC_VECTOR (7 downto 0);
       LOAD : in STD_LOGIC; -- MUST BE DEBOUNCED
       TEMP : out STD_LOGIC_VECTOR (15 downto 0)
    ); end component;
    
     component STACK is Port ( 
        RST : in STD_LOGIC;
        WE : in STD_LOGIC;
        EN : in STD_LOGIC;
        ADDR : in STD_LOGIC_VECTOR (4 downto 0);
        DATA_IN : in STD_LOGIC_VECTOR (15 downto 0);
        DATA_OUT : out STD_LOGIC_VECTOR (15 downto 0);
        CLK : in STD_LOGIC
    ); end component;
    
    component stack_controller port (
        RST : in STD_LOGIC;
        CLK : in STD_LOGIC;
        ENTER : in STD_LOGIC;
        POP : in STD_LOGIC;
        PUSH : in STD_LOGIC;
        USER_INPUT : in STD_LOGIC_VECTOR(15 downto 0);
        ALU_RESULT : in STD_LOGIC_VECTOR(16 downto 0);
        TO_STACK : out STD_LOGIC_VECTOR(15 downto 0);
        ADDR : out STD_LOGIC_VECTOR(4 downto 0);           
        WE : out STD_LOGIC;
        ENABLE : out STD_LOGIC
     ); end component;
     
     component operation_controller port ( 
        RST : in STD_LOGIC;
        CLK : in STD_LOGIC;
        SWITCHES : in STD_LOGIC_VECTOR (4 downto 0);
        EXECUTE : in STD_LOGIC;
        FROM_STACK : in STD_LOGIC_VECTOR (15 downto 0);
        USER_INPUT : in STD_LOGIC_VECTOR (15 downto 0);
        A : out STD_LOGIC_VECTOR (16 downto 0);
        B : out STD_LOGIC_VECTOR (16 downto 0);
        OPCODE : out STD_LOGIC_VECTOR (2 downto 0);
        START : out STD_LOGIC;
        DONE : in STD_LOGIC;
        POP : out STD_LOGIC;
        PUSH : out STD_LOGIC;
        SWAP_COUNT : out STD_LOGIC;
        ENTER : out STD_LOGIC
     ); end component;
     
    component ALU port (  
       A : in STD_LOGIC_VECTOR (16 downto 0);
       B : in STD_LOGIC_VECTOR (16 downto 0);
       OPCODE : in STD_LOGIC_VECTOR (2 downto 0);
       RST : in STD_LOGIC;
       SWAP_COUNT : in STD_LOGIC;
       clockScalers : in STD_LOGIC_VECTOR(11 downto 0);
       START : in STD_LOGIC;
       DONE : out STD_LOGIC;
       RESULT : out STD_LOGIC_VECTOR (16 downto 0)
    );end component;
    
    component Accel port (
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        INV : out STD_LOGIC;
        MISO : in STD_LOGIC;
        MOSI : out STD_LOGIC;
        SCK : out STD_LOGIC;
        SS : out STD_LOGIC);
    end component;
    
    signal masterReset : std_logic;
    
    signal LOAD : std_logic;
    signal LOAD_COUNT : integer range 0 to 4096;
            
    signal EXEC : std_logic;
    signal EXEC_COUNT : integer range 0 to 4096;
    
    signal NUM_input : std_logic_vector(15 downto 0);
    signal invert : std_logic;
    
    signal ADDR : std_logic_vector(4 downto 0);
    signal WE : std_logic;
    signal ENABLE : std_logic;
    signal TO_STACK : std_logic_vector(15 downto 0);
    signal TOS_DISPLAY : std_logic_vector(15 downto 0);
    
    signal clockScalers : std_logic_vector (11 downto 0);
    
    signal digit1 : std_logic_vector(3 downto 0);
    signal digit2 : std_logic_vector(3 downto 0);
    signal digit3 : std_logic_vector(3 downto 0);
    signal digit4 : std_logic_vector(3 downto 0);
    signal digit5 : std_logic_vector(3 downto 0);
    signal digit6 : std_logic_vector(3 downto 0);
    signal digit7 : std_logic_vector(3 downto 0);
    signal digit8 : std_logic_vector(3 downto 0);
        
    signal A : STD_LOGIC_VECTOR(16 downto 0);
    signal B : STD_LOGIC_VECTOR(16 downto 0);
    signal OPCODE : STD_LOGIC_VECTOR(2 downto 0);
    signal DONE : STD_LOGIC;
    signal START : STD_LOGIC;
    signal ENTER : STD_LOGIC;
    signal POP : STD_LOGIC;
    signal PUSH : STD_LOGIC;
    signal RESULT_ALU : STD_LOGIC_VECTOR(16 downto 0);
    signal SWAP_COUNT : STD_LOGIC;
    

begin

    u1:
	ssegDriver port map (
		clk => clockScalers(11),
		rst => masterReset,
	    invert => invert,
		cathode_p => ssegCathode,
		digit1_p => digit1,
		anode_p => ssegAnode,
		digit2_p => digit2,
		digit3_p => digit3,
		digit4_p => digit4,
		digit5_p => digit5,
		digit6_p => digit6,
		digit7_p => digit7,
		digit8_p => digit8
	);	
	
	u2:
	input_FSM port map(
	   RST => masterReset,
	   CLK => clockScalers(11),
	   SWITCHES => slideSwitches(7 downto 0),
	   LOAD => LOAD,
	   TEMP => NUM_input
	);
	
	u3:
	stack_controller port map (
	   RST => masterReset,
	   CLK => clockScalers(11),
	   ENTER => ENTER,
	   POP => POP,
	   PUSH => PUSH,
	   USER_INPUT => NUM_input,
	   ALU_RESULT => RESULT_ALU,
	   TO_STACK => TO_STACK,
	   ADDR => ADDR,
	   WE => WE,
	   ENABLE => ENABLE	
    );
	
	u4:
	STACK port map (
	   RST => masterReset,
	   CLK => clockScalers(10),
	   WE => WE,
	   EN => ENABLE,
	   ADDR => ADDR,
	   DATA_IN => TO_STACK,
	   DATA_OUT => TOS_DISPLAY
	);
	
	u5:
	operation_controller port map (
	   RST => masterReset,
	   CLK => clockScalers(11),
	   SWITCHES => slideSwitches(12 downto 8),
	   EXECUTE => EXEC,
	   FROM_STACK => TOS_DISPLAY,
	   USER_INPUT => NUM_input,
	   A => A,
	   B => B,
	   SWAP_COUNT => SWAP_COUNT,
	   OPCODE => OPCODE,
	   START => START,
	   DONE => DONE,
	   ENTER => ENTER,
	   PUSH => PUSH,
	   POP => POP
	);
	
	u6:
	ALU port map (
	   A => A,
	   B => B,
	   OPCODE => OPCODE,
	   START => START,
	   DONE => DONE,
	   SWAP_COUNT => SWAP_COUNT,
	   RESULT => RESULT_ALU,
	   RST => masterReset,
	   clockScalers => clockScalers	
	);
	
	u7:
	Accel port map (
	   RST => masterReset,
	   CLK => clockScalers(11),
	   INV => invert,
	   MOSI => aclMOSI,
	   MISO => aclMISO,
	   SCK => aclSCK,
	   SS => aclSS
    );
    
	masterReset <= pushButtons(0);		
	
	-- Assign digit display values
    digit1 <= NUM_input(3 downto 0);
    digit2 <= NUM_input(7 downto 4);
    digit3 <= NUM_input(11 downto 8);
    digit4 <= NUM_input(15 downto 12);
    digit5 <= TOS_DISPLAY(3 downto 0);
    digit6 <= TOS_DISPLAY(7 downto 4);
    digit7 <= TOS_DISPLAY(11 downto 8);
    digit8 <= TOS_DISPLAY(15 downto 12);
	
    -- Slowing down clock	
	process (clk100mhz, masterReset)
    begin
        if (masterReset = '1') then
            clockScalers <= "000000000000";
        elsif (clk100mhz'event and clk100mhz = '1')then
            clockScalers <= clockScalers + '1';
        end if;
    end process;

    -- Button Debouncing
    process (clockscalers(11), masterReset)
    begin
        if (masterReset = '1') then
            LOAD_COUNT <= 0;
            EXEC_COUNT <= 0;
        elsif(clockScalers(11)'event AND clockScalers(11) = '1') then
            
            --LOAD BUTTON        
            if (pushButtons(1) = '1') then
                LOAD_COUNT <= LOAD_COUNT + 1;
            else
                LOAD_COUNT <= 0;
            end if;  
                      
            if(LOAD_COUNT = 3000) then
                LOAD <= '1';
                LOAD_COUNT <= 0;
            else 
                LOAD <= '0';
            end if;
            
           --EXECUTE BUTTON
            if (pushButtons(2) = '1') then
                EXEC_COUNT <= EXEC_COUNT + 1;
            else
                EXEC_COUNT <= 0;
            end if;
            
            if(EXEC_COUNT = 3000) then
                EXEC <= '1';
                EXEC_COUNT <= 0;
            else 
                EXEC <= '0';
            end if;
        end if;
    end process;
    
    -- Display Value of Stack Adrres in Binary
    LEDs(4 downto 0) <= ADDR(4 downto 0);

end Behavioral;
