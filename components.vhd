
-- components.vhd

library ieee;
use ieee.std_logic_1164.all;


package component_package is
	-- ADDER
	component adder is
		generic(N	: integer := 4 );
		port(
		  A_sum, B_sum	: in std_logic_vector(N-1 downto 0); 	-- operands
		  C_in			: in std_logic;							-- carry in
		  Sum			: out std_logic_vector(N-1 downto 0); 	-- final result
		  C_out			: out std_logic							-- carry out
		  );
	end component;
	
	-- BASIC_MULTIPLIER
	component basic_multiplier is
		generic(N 	: integer := 2);
		port(
		  A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
		  P		: out std_logic_vector(2*N-1 downto 0) 	-- final result
		  );
	end component;
	
	-- REGISTER
	component reg is
		generic(N 	: integer := 4 );
		port(
			CLK, RST_N, LOAD : in std_logic;
			D : in std_logic_vector(N-1 downto 0);
			Q : out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	-- SHIFTER
	component shifter is
		generic(N 	: integer := 4);
		port( 
			CLK, RST_N, SH_ENABLE: in std_logic;
			D: in std_logic_vector(N-1 downto 0);
			Q: out std_logic_vector(N-1 downto 0)
		);
	end component;
end component_package;
-----------------------------------------------------------------

-----------------------------------------------------------------
package constants_components_package is
end constants_components_package;
-----------------------------------------------------------------


-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_pkg.all;

entity adder is
	generic(
	  N 	: integer := 4 );
	port(
      A_sum, B_sum	: in std_logic_vector(N-1 downto 0); 	-- operands
	  C_in			: in std_logic;							-- carry in
      Sum			: out std_logic_vector(N-1 downto 0); 	-- final result
	  C_out			: out std_logic							-- carry out
	  );
end entity;


architecture behavior of adder is

	signal Sum_int : std_logic_vector(N+1 downto 0);

	begin
	Sum_int <= std_logic_vector(unsigned('0' & A_sum & '1') + 
				unsigned('0' & B_sum & C_in));
	Sum <= Sum_int(N downto 1);
	C_out <= Sum_int(N+1);
end behavior;
-----------------------------------------------------------------



-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity reg is
	generic(
	  N 	: integer := 4);
	port(
		CLK, RST_N, LOAD : in std_logic;
		D : in std_logic_vector(N-1 downto 0);
		Q : out std_logic_vector(N-1 downto 0)
	);
end reg;

architecture behavior of reg is
	begin
	process(CLK, RST_N)
	begin
		if(RST_N = '0') then
			Q <= (others => '0');
		elsif rising_edge(CLK) and LOAD='1' then
			Q <= D;
		end if;
	end process;
end behavior;
-----------------------------------------------------------------



-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity basic_multiplier is
	generic(
	  N 	: integer := 2);
	port(
      A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
      P		: out std_logic_vector(2*N-1 downto 0) 	-- final result
	  );
end entity;


architecture behavior of basic_multiplier is
  begin
    P <= std_logic_vector(unsigned(A) * unsigned(B));
end behavior;
-----------------------------------------------------------------