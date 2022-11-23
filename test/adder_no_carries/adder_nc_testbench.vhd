
-- testbench.vhdl for multiplier

-- libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- interface
entity testbench is
	generic(N 	: integer := 4);
end testbench;


-- architecture
architecture tb_adder of testbench is

	constant CLK_SEMIPERIOD0 : time := 25 ns;
	constant CLK_SEMIPERIOD1 : time := 25 ns;
	constant CLK_PERIOD : time := CLK_SEMIPERIOD0+CLK_SEMIPERIOD1;
	signal RST : std_logic;
	
	signal A_SIG: std_logic_vector(N-1 downto 0);
	signal B_SIG: std_logic_vector(N-1 downto 0);
	signal R_SIG: std_logic_vector(N downto 0);

	component adder is
	port( 
	  A_sum  : in std_logic_vector(N-1 downto 0);
	  B_sum  : in std_logic_vector(N-1 downto 0);
      Sum	 : out std_logic_vector(N downto 0) 		-- final result
	  );
	end component adder;
      
begin
  
	DUT : adder
	port map(
		A_sum	=> A_SIG,
		B_sum	=> B_SIG,
		Sum		=> R_SIG
		);
	
	process is
	begin
		A_SIG <= "0000";
		B_SIG <= "0000";
		wait for 10 ns;
		A_SIG <= "0001";
		B_SIG <= "0001";
		wait for 10 ns;
		A_SIG <= "1011";
		B_SIG <= "0010";
		wait for 10 ns;
		A_SIG <= "1111";
		B_SIG <= "1111";
		wait for 10 ns;
	end process;
	
end tb_adder;