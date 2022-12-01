
-- components.vhd for bm_sel

library ieee;
use ieee.std_logic_1164.all;

package msel_components_package is

	component regN is
		generic(N 	: integer := 4);
		port(
			CLK, RST, LOAD : in std_logic;
			D : in std_logic_vector(N-1 downto 0);
			Q : out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	component leftshiftN is
		generic(
			N: 	integer := 4;
			SH:	integer := 1);
		port(
			X: in std_logic_vector(N-1 downto 0);
			Y: out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	component rightshiftN is
		generic(
			N: 	integer := 4;
			SH:	integer := 1);
		port(
			X: in std_logic_vector(N-1 downto 0);
			Y: out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	-- component adderN is
		-- generic(N 	: integer := 4);
		-- port(
		  -- A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
		  -- S			: out std_logic_vector(N downto 0) 	-- final result
		  -- );
	-- end component;
	
	
	component adderNotCOut is
		generic(N 	: integer := 4);
		port(
		  A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
		  S		: out std_logic_vector(N-1 downto 0) 	-- final result
		  );
	end component;
	
	-- component multiplierN is
		-- generic(N 	: integer := 2);
		-- port(
		  -- A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
		  -- P		: out std_logic_vector(2*N-1 downto 0) 	-- final result
		  -- );
	-- end component;
	
	
	-- component notport is
		-- port (
				-- A               : in  std_logic;
				-- Y               : out std_logic
			 -- );
	-- end component;
		

	component mux is
		port (
		sel: 	in std_logic;
		I0: 	in std_logic;
		I1: 	in std_logic;
		Y:		out std_logic
		);
	end component;

	component mux2N is
		generic(N 	: integer := 8);
		port (
		sel: 	in std_logic;
		I0: 	in std_logic_vector(N-1 downto 0);
		I1: 	in std_logic_vector(N-1 downto 0);
		Y:		out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	
	component mux4N is
		generic(N 	: integer := 8);
		port (
		sel: 	in std_logic_vector(1 downto 0);
		I0: 	in std_logic_vector(N-1 downto 0);
		I1: 	in std_logic_vector(N-1 downto 0);
		I2: 	in std_logic_vector(N-1 downto 0);
		I3: 	in std_logic_vector(N-1 downto 0);
		Y:		out std_logic_vector(N-1 downto 0)
		);
	end component;
	
	
	component reg is
		port(
		CLK:	in std_logic;
		RST:	in std_logic;
		LOAD:	in std_logic;
		D : 	in std_logic;
		Q : 	out std_logic
		);
	end component;
	
end msel_components_package;
----------------------------------------------------------------------



----------------------------------------------------------------------
package constants_components_package is
    constant Tadd           : time := 4 ns;
    constant Tcomp          : time := 5 ns;
    constant Tmux           : time := 2 ns;
    constant TRco           : time := 1 ns;
    constant TRsu           : time := 1 ns;
    constant Tshift         : time := 0 ns;
    constant Tlogic         : time := 0.4 ns;
end constants_components_package;
----------------------------------------------------------------------



----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_package.all;

-- adder with carry out and without carry in

-- entity adderN is
	-- generic(N 	: integer := 4);
	-- port(
      -- A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
      -- S			: out std_logic_vector(N downto 0) 	-- final result
	  -- );
-- end entity;


-- architecture behavior of adderN is

	-- signal Sum_int : std_logic_vector(N downto 0);

	-- begin
	-- Sum_int <= std_logic_vector(unsigned('0' & A) + unsigned('0' & B));
	-- S <= Sum_int;
-- end behavior;
----------------------------------------------------------------------



----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_package.all;

-- adder without carries

entity adderNotCOut is
	generic(N 	: integer := 4);
	port(
      A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
      S		: out std_logic_vector(N-1 downto 0) 	-- final result
	  );
end entity;

architecture behavior of adderNotCOut is
	begin
		S <= std_logic_vector(unsigned(A) + unsigned(B));
end behavior;
----------------------------------------------------------------------



----------------------------------------------------------------------
-- library ieee;
-- use ieee.std_logic_1164.all;
-- use work.constants_components_package.all;


-- entity notport is
    -- port (
            -- A               : in  std_logic;
            -- Y               : out std_logic
         -- );
-- end notport;

-- architecture behavior of notport is
-- begin
    -- Y <= not A;
-- end behavior;
----------------------------------------------------------------------


----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_package.all;


entity mux is
	port (
	sel: 	in std_logic;
	I0: 	in std_logic;
	I1: 	in std_logic;
	Y:		out std_logic
	);
end mux;

architecture behavior of mux is
begin
	with sel select
		Y <= 	I0 when '0', 
				I1 when others;
end behavior;
----------------------------------------------------------------------

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_package.all;


entity mux2N is
	generic(N 	: integer := 8);
	port (
	sel: 	in std_logic;
	I0: 	in std_logic_vector(N-1 downto 0);
	I1: 	in std_logic_vector(N-1 downto 0);
	Y:		out std_logic_vector(N-1 downto 0)
	);
end mux2N;

architecture behavior of mux2N is
begin
	with sel select
		Y <= 	I0 when '0', 
				I1 when others;
end behavior;
----------------------------------------------------------------------


----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_package.all;


entity mux4N is
	generic(N 	: integer := 8);
	port (
	sel: 	in std_logic_vector(1 downto 0);
	I0: 	in std_logic_vector(N-1 downto 0);
	I1: 	in std_logic_vector(N-1 downto 0);
	I2: 	in std_logic_vector(N-1 downto 0);
	I3: 	in std_logic_vector(N-1 downto 0);
	Y:		out std_logic_vector(N-1 downto 0)
	);
end mux4N;

architecture behavior of mux4N is
begin
	with sel select
        Y <= I0 when "00",
             I1 when "01",
             I2 when "10",
             I3 when others;
end behavior;
----------------------------------------------------------------------




----------------------------------------------------------------------
-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
-- use work.constants_components_package.all;


-- entity multiplierN is
	-- generic(
	  -- N 	: integer := 2);
	-- port(
      -- A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
      -- P		: out std_logic_vector(2*N-1 downto 0) 	-- final result
	  -- );
-- end entity;


-- architecture behavior of multiplierN is
  -- begin
    -- P <= std_logic_vector(unsigned(A) * unsigned(B));
-- end behavior;
----------------------------------------------------------------------



----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_package.all;


entity leftshiftN is
	generic(
		N: 	integer := 4;
		SH:	integer := 1);
	port( 
		X: in std_logic_vector(N-1 downto 0);
		Y: out std_logic_vector(N-1 downto 0)
	);
end entity;

architecture behavior of leftshiftN is
	begin
		Y <= std_logic_vector(shift_left(unsigned(X), SH));
end behavior;
----------------------------------------------------------------------


----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_package.all;


entity rightshiftN is
	generic(
		N: 	integer := 4;
		SH:	integer := 1);
	port( 
		X: in std_logic_vector(N-1 downto 0);
		Y: out std_logic_vector(N-1 downto 0)
	);
end entity;

architecture behavior of rightshiftN is
	begin
		Y <= std_logic_vector(shift_right(unsigned(X), SH));
end behavior;
----------------------------------------------------------------------



----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_package.all;


entity regN is
	generic(N 	: integer := 4);
	port(
		CLK, RST, LOAD : in std_logic;
		D : in std_logic_vector(N-1 downto 0);
		Q : out std_logic_vector(N-1 downto 0)
	);
end regN;

architecture behavior of regN is
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


----------------------------------------------------------------------


----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_package.all;


entity reg is
	port(
		CLK:	in std_logic;
		RST:	in std_logic;
		LOAD:	in std_logic;
		D : 	in std_logic;
		Q : 	out std_logic
	);
end reg;

architecture behavior of reg is
	begin
	process(CLK, RST)
	begin
		if(RST = '1') then
			Q <= '0';
		elsif rising_edge(CLK) and LOAD='1' then
			Q <= D;
		end if;
	end process;
end behavior;


----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
-- use work.constants_components_package.all;


-- ----------------------------------------------------------------------