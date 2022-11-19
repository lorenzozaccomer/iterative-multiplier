
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
	
	component adderN is
		generic(N 	: integer := 4);
		port(
		  A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
		  S			: out std_logic_vector(N downto 0) 	-- final result
		  );
	end component;
	
	
	component adderN_NC is
		generic(N 	: integer := 4);
		port(
		  A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
		  S		: out std_logic_vector(N-1 downto 0) 	-- final result
		  );
	end component;
	
	component BasicMultiplier is
		generic(N 	: integer := 2);
		port(
		  A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
		  P		: out std_logic_vector(2*N-1 downto 0); 	-- final result
		  );
	end component;
	
	
	component notport is
		port (
				A               : in  std_logic;
				Y               : out std_logic
			 );
	end component;
	
	
	component mux4N is
		generic(N 	: integer := 8);
		port (
		sel: 	in std_logic_vector(1 downto 0);
		IN0: 	in std_logic_vector(N-1 downto 0);
		IN1: 	in std_logic_vector(N-1 downto 0);
		IN2: 	in std_logic_vector(N-1 downto 0);
		IN3: 	in std_logic_vector(N-1 downto 0);
		Y:		out std_logic_vector(N-1 downto 0)
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

-- adder with carry out and without carry in

entity adderN is
	generic(N 	: integer := 4);
	port(
      A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
      S			: out std_logic_vector(N downto 0) 	-- final result
	  );
end entity;


architecture behavior of adderN is

	signal Sum_int : std_logic_vector(N downto 0);

	begin
	Sum_int <= std_logic_vector(unsigned('0'&A) + unsigned('0'&B));
	S <= Sum_int;
end behavior;
----------------------------------------------------------------------



----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_pkg.all;

-- adder without carries

entity adderN_NC is
	generic(N 	: integer := 4);
	port(
      A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
      S		: out std_logic_vector(N-1 downto 0) 	-- final result
	  );
end entity;


architecture behavior of adderN_NC is
	begin
	S <= std_logic_vector(unsigned(A) + unsigned(B));
end behavior;
----------------------------------------------------------------------



----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use work.constants_components_pkg.all;

entity notport is
    port (
            A               : in  std_logic;
            Y               : out std_logic
         );
end notport;

architecture s of notport is
begin
    Y <= not A;
end s;
----------------------------------------------------------------------


-- ----------------------------------------------------------------------
-- library ieee;
-- use ieee.std_logic_1164.all;
-- use ieee.numeric_std.all;
-- use work.constants_components_pkg.all;


-- entity adder2 is
	-- port(
      -- A, B	: in std_logic; 	-- operands
      -- S			: out std_logic_vector(1 downto 0) 	-- final result
	  -- );
-- end entity;


-- architecture behavior of adder2 is

	-- signal Sum_int : std_logic_vector(1 downto 0);

	-- begin
	-- Sum_int <= std_logic_vector(unsigned(A) + unsigned(B));
	-- S <= Sum_int;
-- end behavior;
-- ----------------------------------------------------------------------



----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_pkg.all;

library ieee;
use ieee.std_logic_1164.all;
entity mux2N is
	generic(N 	: integer := 8);
	port (
	sel: 	in std_logic;
	IN0: 	in std_logic_vector(N-1 downto 0);
	IN1: 	in std_logic_vector(N-1 downto 0);
	Y:		out std_logic_vector(N-1 downto 0)
	);
end mux2x8;
architecture behavior of mux2N is
begin
	with sel select
	Y <= 	IN0 when '0', 
			IN1 when others;
end behavior;
----------------------------------------------------------------------


----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_pkg.all;

entity mux4N is
	generic(N 	: integer := 8);
	port (
	sel: 	in std_logic_vector(1 downto 0);
	IN0: 	in std_logic_vector(N-1 downto 0);
	IN1: 	in std_logic_vector(N-1 downto 0);
	IN2: 	in std_logic_vector(N-1 downto 0);
	IN3: 	in std_logic_vector(N-1 downto 0);
	Y:		out std_logic_vector(N-1 downto 0)
	);
end mux4N;

architecture behavior of mux4N is
begin
	with sel select
        Y <= I0 after Tmux when "00",
             I1 after Tmux when "01",
             I2 after Tmux when "10",
             I3 after Tmux when others;
end behavior;
----------------------------------------------------------------------




----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_pkg.all;

entity BasicMultiplier is
	generic(
	  N 	: integer := 2);
	port(
      A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
      P		: out std_logic_vector(2*N-1 downto 0) 	-- final result
	  );
end entity;


architecture behavior of BasicMultiplier is
  begin
    P <= std_logic_vector(unsigned(A) * unsigned(B));
end behavior;
----------------------------------------------------------------------



----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants_components_pkg.all;


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
use work.constants_components_pkg.all;


entity rightshiftN is
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
		Y <= std_logic_vector(shift_right(unsigned(X), SH));
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