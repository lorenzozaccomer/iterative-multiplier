
-- testbench.vhdl for basic_multiplier

-- libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- interface
entity tb is
	generic(N 	: integer := 4);
end tb;


-- architecture
architecture tb_standard_multiplier of tb is

	-- constant CLK_SEMIPERIOD0 : time := 25 ns;
	-- constant CLK_SEMIPERIOD1 : time := 25 ns;
	-- constant CLK_PERIOD : time := CLK_SEMIPERIOD0+CLK_SEMIPERIOD1;
	-- signal RST : std_logic;
	
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
			-- A_SIG <= "1010101010101010"; -- 16 bit
			-- B_SIG <= "1101010111010101"; -- 16 bit
		-- wait for 10 ns;
			-- A_SIG <= "1010101010101010"; -- 16 bit
			-- B_SIG <= "0000000000000101"; -- 16 bit
		-- wait for 10 ns;
			-- A_SIG <= "1010101010101010"; -- 16 bit
			-- B_SIG <= "0000000000001101"; -- 16 bit
		-- wait for 10 ns;
			-- A_SIG <= "1010101010101010"; -- 16 bit
			-- B_SIG <= "0000000000000101"; -- 16 bit
		-- wait for 10 ns;
			-- A_SIG <= "1010101010101010"; -- 16 bit
			-- B_SIG <= "1101000000000000"; -- 16 bit
		-- wait for 10 ns;
			-- A_SIG <= "10101010"; -- 8 bit
			-- B_SIG <= "11010101"; -- 8 bit
		-- wait for 10 ns;
		A_SIG <= "1111";	-- 4 bit
		B_SIG <= "1111";	-- 4 bit	
		wait for 10 ns;
		A_SIG <= "1011";	-- 4 bit
		B_SIG <= "0010";	-- 4 bit	
		wait for 10 ns;
		A_SIG <= "1101";	-- 4 bit
		B_SIG <= "1010";	-- 4 bit	
		wait for 10 ns;
		A_SIG <= "1010";	-- 4 bit
		B_SIG <= "0101";	-- 4 bit	
		wait for 10 ns;
		A_SIG <= "1011";	-- 4 bit
		B_SIG <= "1010";	-- 4 bit	
		wait for 10 ns;
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
	
end tb_standard_multiplier;
