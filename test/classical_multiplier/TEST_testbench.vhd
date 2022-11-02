
-- TEST_testbench.vhdl for TEST_Multiplier

-- libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- interface
entity testbench is
	generic(N 	: integer := 4);
end testbench;


-- architecture
architecture tb_TEST_multiplier of testbench is

	constant CLK_SEMIPERIOD0 : time := 25ns;
	constant CLK_SEMIPERIOD1 : time := 25ns;
	constant CLK_PERIOD : time := CLK_SEMIPERIOD0+CLK_SEMIPERIOD1;
	signal RST : std_logic;
	
	signal A_CM: std_logic_vector(3 downto 0);
	signal B_CM: std_logic_vector(3 downto 0);
	signal P_CM: std_logic_vector(7 downto 0);
	
	component TEST_Multiplier is
	port( 
		A_CM : in  STD_LOGIC_VECTOR (3 downto 0);
        B_CM : in  STD_LOGIC_VECTOR (3 downto 0);
        P_CM : out  STD_LOGIC_VECTOR (7 downto 0)
		);
	end component TEST_Multiplier;
      
begin

	TEST_Multiplier_INST : TEST_Multiplier
	port map(
		A_CM	=> A_CM,
		B_CM	=> B_CM,
		P_CM	=> P_CM	
		);
	
	process is
	begin
		A_CM <= "1011";
		B_CM <= "0011";
		wait for 10 ns;
		A_CM <= "1011";
		B_CM <= "0010";
		wait for 10 ns;
		-- A_CM <= "0011";
		-- B_CM <= "0111";
		-- wait for 10 ns;
		-- A_SIG <= "11";
		-- B_SIG <= "10";
		-- wait for 10 ns;
		-- A_SIG <= "10";
		-- B_SIG <= "01";
		-- wait for 10 ns;
		-- A_SIG <= "11";
		-- B_SIG <= "11";
		-- wait for 10 ns;
		-- A_SIG <= "10101010";
		-- B_SIG <= "11010101";
		-- wait for 10 ns;
	end process;
	
end tb_TEST_multiplier;
