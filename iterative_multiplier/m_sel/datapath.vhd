
-- datapath.vhd

-- for multilplier select

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package msel_datapath_package is
	component msel_datapath is
		generic(
			N	: integer := 16;
			M	: integer := 4
			);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- data inputs
			A_M:			in std_logic_vector(N-1 downto 0);
			B_M:			in std_logic_vector(N-1 downto 0);
			A_BM:			out std_logic_vector(N-1 downto 0);
			B_BM:			out std_logic_vector(N-1 downto 0);
				-- control signal to/from extern
			DATAIN:			in std_logic;	-- new data to manipulate
			ADV_AM:			in std_logic;
			NW_PRD:			in std_logic;
			DATAIN_BM:		in std_logic;	-- new data for bm_sel are ready to used it
			READY:			out std_logic;	-- m_sel can accept new data input
				-- control signal to datapath
			selAM			in std_logic;
			selBM			in std_logic;
			selINC_M		in std_logic;
			selA_AM			in std_logic;
			selB_BM			in std_logic;
						
			loadAM			in std_logic;
			loadBM			in std_logic;
			loadINC_M		in std_logic;
			loadA_BM		in std_logic;
			loadB_BM		in std_logic;
				-- status signals from datapath
			INC_M:			in std_logic_vector(M downto 0);
		);
	end component;
end msel_ctrlunit_package;
----------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components_package.all;

	-- interface
entity msel_datapath is
	generic(
		N	: integer := 16;
		M	: integer := 4
		);
	port(
		CLK:			in std_logic;
		RST:			in std_logic;
			-- data inputs
		A_M:			in std_logic_vector(N-1 downto 0);
		B_M:			in std_logic_vector(N-1 downto 0);
		A_BM:			out std_logic_vector(N-1 downto 0);
		B_BM:			out std_logic_vector(N-1 downto 0);
			-- control signal to datapath
		selAM			in std_logic;
		selBM			in std_logic;
		selINC_M		in std_logic;
		selA_AM			in std_logic;
		selB_BM			in std_logic;
					
		loadAM			in std_logic;
		loadBM			in std_logic;
		loadINC_M		in std_logic;
		loadA_BM		in std_logic;
		loadB_BM		in std_logic;
			-- status signals from datapath
		INC_M:			out std_logic_vector(M downto 0);
	);
end entity;

architecture struct of msel_datapath is

	-- signals
	-- internal signals
	
	begin
		-- REGISTERS
		-- MUXS
		-- ADDERS
		-- LOGIC PORTS
		-- SHIFTERS
		-- status signals
		-- data outputs
end struct;
