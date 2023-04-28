
-- testbench.vhdl for basic_multiplier

-- libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- interface
entity tb is
	generic(N 	: integer := 16);
end tb;


-- architecture
architecture tb_standard_multiplier of tb is
	
	signal A_SIG: std_logic_vector(N-1 downto 0);
	signal B_SIG: std_logic_vector(N-1 downto 0);
	signal R_SIG: std_logic_vector(2*N-1 downto 0);

	component basic_multiplier is
	port( 
	  A   : in std_logic_vector(N-1 downto 0);
	  B   : in std_logic_vector(N-1 downto 0);
	  P   : out std_logic_vector(2*N-1 downto 0)
	  );
	end component basic_multiplier;
      
begin
  
	basic_multiplier_INST : basic_multiplier
	port map(
		A	=> A_SIG,
		B	=> B_SIG,
		P	=> R_SIG
		);
	
	process is
	begin
			A_SIG <= "1010101010101010"; -- 16 bit
			B_SIG <= "1101010111010101"; -- 16 bit
		wait for 100 ns;
			A_SIG <= "0010100001100001"; -- 16 bit
			B_SIG <= "1000011100101001"; -- 16 bit
		wait for 100 ns;
			A_SIG <= "1010101010101010"; -- 16 bit
			B_SIG <= "0000000000001101"; -- 16 bit
		wait for 100 ns;
			A_SIG <= "1010101010101010"; -- 16 bit
			B_SIG <= "0000000000000101"; -- 16 bit
		wait for 100 ns;
			A_SIG <= "1010101010101010"; -- 16 bit
			B_SIG <= "1101000000000000"; -- 16 bit
		wait for 100 ns;
	end process;
	
end tb_standard_multiplier;
