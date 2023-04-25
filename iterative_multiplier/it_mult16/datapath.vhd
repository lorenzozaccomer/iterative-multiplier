
-- datapath.vhd

-- for iterative multiplier 16

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package it_mult16_datapath_package is
	component it_mult16_datapath is
		generic(
			N	: integer := 16;
			M	: integer := 8;
			P	: integer := 4
			);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- data inputs
			A_M:			in std_logic_vector(N-1 downto 0);
			B_M:			in std_logic_vector(N-1 downto 0);
				-- data outputs
			OUT_MULT16:		out std_logic_vector(2*N-1 downto 0);
				-- control signal to datapath
			test:			in std_logic
				-- status signals from datapath
		);
	end component;
end it_mult16_datapath_package;
----------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.it_mult16_components_package.all;

	-- interface
entity it_mult16_datapath is
	generic(
		N	: integer := 16;
		M	: integer := 8;
		P	: integer := 4
		);
	port(
		CLK:			in std_logic;
		RST:			in std_logic;
			-- data inputs
		A_M:			in std_logic_vector(N-1 downto 0);
		B_M:			in std_logic_vector(N-1 downto 0);
			-- data outputs
		OUT_MULT16:		out std_logic_vector(2*N-1 downto 0);
			-- control signal to datapath
		test:			in std_logic
			-- status signals from datapath
	);
end entity;



architecture struct of it_mult16_datapath is

	-- signals	
	
				
	begin
		-- REGISTERS
	
		-- MUXS
	
		-- ADDERS
	
	
		-- SHIFTERS

		-- status signals

		-- data outputs
end struct;