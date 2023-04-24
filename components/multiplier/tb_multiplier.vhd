
-- tb.vhdl for multiplierN

-- libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- interface
entity tb is
	generic(N 	: integer := 2);
end tb;


-- architecture
architecture behavior of tb is

	constant CLK_SEMIPERIOD0 : time := 25 ns;
	constant CLK_SEMIPERIOD1 : time := 25 ns;
	constant CLK_PERIOD : time := CLK_SEMIPERIOD0+CLK_SEMIPERIOD1;
	
	signal A_SIG: std_logic_vector(N-1 downto 0);
	signal B_SIG: std_logic_vector(N-1 downto 0);
	signal R_SIG: std_logic_vector(2*N-1 downto 0);

	component multiplierN is
	port( 
		A   : in std_logic_vector(N-1 downto 0);
		B   : in std_logic_vector(N-1 downto 0);
		P   : out std_logic_vector(2*N-1 downto 0)
		);
	end component multiplierN;
      
begin
  
	basic_multiplier_INST : multiplierN
	port map(
		A	=> A_SIG,
		B	=> B_SIG,
		P	=> R_SIG
		);
	
	process is
	begin
		A_SIG <= "00";
		B_SIG <= "00";
		wait for 10 ns;
		A_SIG <= "01";
		B_SIG <= "01";
		wait for 10 ns;
		A_SIG <= "11";
		B_SIG <= "10";
		wait for 10 ns;
		A_SIG <= "10";
		B_SIG <= "01";
		wait for 10 ns;
		A_SIG <= "11";
		B_SIG <= "11";
		wait for 10 ns;
		-- A_SIG <= "10101010";
		-- B_SIG <= "11010101";
		-- wait for 10 ns;
	end process;
	
end behavior;
