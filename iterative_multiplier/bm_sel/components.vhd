
-- components.vhd for bm_sel

library ieee;
use ieee.std_logic_1164.all;

package components_package is

	component regN is
		generic(N 	: integer := 4);
		port(
			CLK, RST, LOAD : in std_logic;
			D : in std_logic_vector(N-1 downto 0);
			Q : out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	component leftshiftN is
		generic(N 	: integer := 4);
		port( 
			CLK, RST, SH_ENABLE: in std_logic;
			D: in std_logic_vector(N-1 downto 0);
			Q: out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	component rightshiftN is
		generic(N 	: integer := 4);
		port( 
			CLK, RST, SH_ENABLE: in std_logic;
			D: in std_logic_vector(N-1 downto 0);
			Q: out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	component adderN is
		generic(N 	: integer := 4);
		port(
		  A_sum, B_sum	: in std_logic_vector(N-1 downto 0); 	-- operands
		  Sum			: out std_logic_vector(N downto 0) 	-- final result
		  );
	end component;
	
end components_package;
----------------------------------------------------------------------



----------------------------------------------------------------------
package constants_components_pkg is
    constant Tadd           : time := 4 ns;
    constant Tcomp          : time := 5 ns;
    constant Tmux           : time := 2 ns;
    constant TRco           : time := 1 ns;
    constant TRsu           : time := 1 ns;
    constant Tshift         : time := 0 ns;
    constant Tlogic         : time := 0.4 ns;
end constants_components_pkg;
----------------------------------------------------------------------



----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_pkg.all;


entity adderN is
	generic(N 	: integer := 4);
	port(
      A_sum, B_sum	: in std_logic_vector(N-1 downto 0); 	-- operands
      Sum			: out std_logic_vector(N downto 0) 	-- final result
	  );
end entity;


architecture behavior of adderN is

	signal Sum_int : std_logic_vector(N downto 0);

	begin
	Sum_int <= std_logic_vector( 
				unsigned('0' & A_sum) + 
				unsigned('0' & B_sum)	);
				
	Sum <= Sum_int;
end behavior;
----------------------------------------------------------------------



----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_pkg.all;


----------------------------------------------------------------------



----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_pkg.all;


----------------------------------------------------------------------