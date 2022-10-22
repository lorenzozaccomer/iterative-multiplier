
-- testbench.vhdl for multiplier

-- libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- interface
entity testbench is
	generic(
	  N 	: integer := 8);
end testbench;


-- architecture
architecture tb_multiplier of testbench is

	constant CLK_SEMIPERIOD0 : time := 25ns;
	constant CLK_SEMIPERIOD1 : time := 25ns;
	constant CLK_PERIOD : time := CLK_SEMIPERIOD0+CLK_SEMIPERIOD1;
	signal RST : std_logic;
	
	signal A_SIG: std_logic_vector(N-1 downto 0);
	signal B_SIG: std_logic_vector(N-1 downto 0);
	signal R_SIG: std_logic_vector(2*N-1 downto 0);

	component multiplier is
	port( 
	  A   : in std_logic_vector(N-1 downto 0);
	  B   : in std_logic_vector(N-1 downto 0);
	  P   : out std_logic_vector(2*N-1 downto 0)  );
	end component multiplier;
      
begin
  
	multiplier_INST : multiplier
	port map(
		A	=> A_SIG,
		B	=> B_SIG,
		P	=> R_SIG	
		);
	
	process is
	begin
		-- A_SIG <= "0000000";
		-- B_SIG <= "0000000";
		wait for 10 ns;
		A_SIG <= "10101010";
		B_SIG <= "11010101";
		wait for 10 ns;
		-- A_SIG <= "1011";
		-- B_SIG <= "0010";
		-- wait for 10 ns;
		-- A_SIG <= "1010";
		-- B_SIG <= "0101";
		-- wait for 10 ns;
		-- A_SIG <= "1011";
		-- B_SIG <= "1010";
		-- wait for 10 ns;
	end process;
	
end tb_multiplier;
