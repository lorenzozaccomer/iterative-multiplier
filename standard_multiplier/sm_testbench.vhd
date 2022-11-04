
-- testbench.vhdl for basic_multiplier

-- libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- interface
entity testbench is
	generic(N 	: integer := 16);
end testbench;


-- architecture
architecture tb_basic_multiplier of testbench is

	constant CLK_SEMIPERIOD0 : time := 25ns;
	constant CLK_SEMIPERIOD1 : time := 25ns;
	constant CLK_PERIOD : time := CLK_SEMIPERIOD0+CLK_SEMIPERIOD1;
	signal RST : std_logic;
	
	signal A_SIG: std_logic_vector(N-1 downto 0);
	signal B_SIG: std_logic_vector(N-1 downto 0);
	signal R_SIG: std_logic_vector(2*N-1 downto 0);
	signal DONE_SIG: std_logic;

	component basic_multiplier is
	port( 
	  A   : in std_logic_vector(N-1 downto 0);
	  B   : in std_logic_vector(N-1 downto 0);
	  P   : out std_logic_vector(2*N-1 downto 0);
	  Done_BM : out std_logic);
	end component basic_multiplier;
      
begin
  
	basic_multiplier_INST : basic_multiplier
	port map(
		A	=> A_SIG,
		B	=> B_SIG,
		P	=> R_SIG,
		Done_BM => DONE_SIG
		);
	
	process is
	begin
		A_SIG <= "1010101010101010"; -- 16 bit
		B_SIG <= "1101010111010101"; -- 16 bit
		wait for 10 ns;
		-- A_SIG <= "10101010"; -- 8 bit
		-- B_SIG <= "00000101"; -- 8 bit
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
	
end tb_basic_multiplier;
