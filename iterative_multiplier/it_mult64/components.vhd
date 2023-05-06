
-- components.vhd

-- for iterative multiplier 16

----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


package it_mult64_components_package is

	component reg is
		port(
		CLK:	in std_logic;
		RST:	in std_logic;
		LOAD:	in std_logic;
		D : 	in std_logic;
		Q : 	out std_logic
		);
	end component;
	
	component regN is
		generic(N 	: integer := 4);
		port(
			CLK, RST, LOAD : in std_logic;
			D : in std_logic_vector(N-1 downto 0);
			Q : out std_logic_vector(N-1 downto 0)
		);
	end component;
		
	
	component mux2 is
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
	
end it_mult64_components_package;
----------------------------------------------------------------------


----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity mux2 is
	port (
	sel: 	in std_logic;
	I0: 	in std_logic;
	I1: 	in std_logic;
	Y:		out std_logic
	);
end mux2;

architecture behavior of mux2 is
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
-- 


-- ----------------------------------------------------------------------