
-- components.vhd

library ieee;
use ieee.std_logic_1164.all;


package component_package is
	-- ADDER
	component adder is
		generic(N	: integer := 4);
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
			CLK, RST, LOAD : in std_logic;
			D : in std_logic_vector(N-1 downto 0);
			Q : out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	-- SHIFTER
	component shifter is
		generic(N 	: integer := 4);
		port( 
			CLK, RST, SH_ENABLE: in std_logic;
			D: in std_logic_vector(N-1 downto 0);
			Q: out std_logic_vector(N-1 downto 0)
		);
	end component;
end component_package;
-----------------------------------------------------------------

-----------------------------------------------------------------
package constants_components_package is
    constant Tadd           : time := 4 ns;
    constant Tcomp          : time := 5 ns;
    constant Tmux           : time := 2 ns;
    constant TRco           : time := 1 ns;
    constant TRsu           : time := 1 ns;
    constant Tshift         : time := 0 ns;
    constant Tlogic         : time := 0.4 ns;
end constants_components_package;
-----------------------------------------------------------------


-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_package.all;

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
use ieee.numeric_std.all;
use work.constants_components_package.all;

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



-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.constants_components_package.all;

entity reg is
	generic(
	  N 	: integer := 4);
	port(
		CLK, RST, LOAD : in std_logic;
		D : in std_logic_vector(N-1 downto 0);
		Q : out std_logic_vector(N-1 downto 0)
	);
end reg;

architecture behavior of reg is
	begin
	process(CLK, RST)
	begin
		if(RST = '1') then
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
use ieee.numeric_std.all;	-- needed to shift op
use work.constants_components_package.all;

entity shift is
	generic(N 	: integer := 4);
	port( 
		CLK, RST, SH_ENABLE: in std_logic;
		D: in std_logic_vector(N-1 downto 0);
		Q: out std_logic_vector(N-1 downto 0)
	);
end entity;

architecture behavior of shift is
	begin
		process(CLK, RST)
		begin
			if rising_edge(CLK) then
				if RST = '1' then			-- clear
					Q <= (others => '0');
				elsif SH_ENABLE = '1' then	-- shift
					Q <= std_logic_vector(shift_left(unsigned(D), 1));
				end if;
			end if;
		end process;
end behavior;
-----------------------------------------------------------------