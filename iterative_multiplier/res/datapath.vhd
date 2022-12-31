
-- datapath.vhd

-- for multilplier select

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package res_datapath_package is
	component res_datapath is
		generic(
			N	: integer := 16;
			P	: integer := 4
			);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- data inputs
			OUT_BM:			in std_logic_vector(2*P-1 downto 0);
			RES:			out std_logic_vector(2*N-1 downto 0);
				-- control signal to datapath
			loadNSHIFT:		in std_logic;
			selNSHIFT:		in std_logic;
			loadPSHIFT:		in std_logic;
			selPSHIFT:		in std_logic;
			loadOUTBM:		in std_logic;
			selOUTBM:		in std_logic;
			loadBM:			in std_logic;
			selBM:			in std_logic;
			loadS1:			in std_logic;
			selS1:			in std_logic;
			loadRS:			in std_logic;
			selRS:			in std_logic;
			loadS2:			in std_logic;
			selS2:			in std_logic;
			loadACCR:		in std_logic;
			selACCR:		in std_logic;
			loadRES:		in std_logic;
			selRES:			in std_logic;
				-- status signals from datapath
			P_SHIFT:		out std_logic_vector(P-1 downto 0);
			N_SHIFT:		out std_logic_vector(P downto 0);
			CNT_R:			out std_logic_vector(P downto 0)
		);
	end component;
end res_datapath_package;
----------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.res_components_package.all;

	-- interface
entity res_datapath is
	generic(
		N	: integer := 16;
		P	: integer := 4
		);
	port(
		CLK:			in std_logic;
		RST:			in std_logic;
			-- data inputs
		OUT_BM:			in std_logic_vector(2*P-1 downto 0);
		RES:			out std_logic_vector(2*N-1 downto 0);
			-- control signal to datapath
		loadNSHIFT:		in std_logic;
		selNSHIFT:		in std_logic;
		loadPSHIFT:		in std_logic;
		selPSHIFT:		in std_logic;
		loadOUTBM:		in std_logic;
		selOUTBM:		in std_logic;
		loadBM:			in std_logic;
		selBM:			in std_logic;
		loadS1:			in std_logic;
		selS1:			in std_logic;
		loadRS:			in std_logic;
		selRS:			in std_logic;
		loadS2:			in std_logic;
		selS2:			in std_logic;
		loadACCR:		in std_logic;
		selACCR:		in std_logic;
		loadRES:		in std_logic;
		selRES:			in std_logic;
			-- status signals from datapath
		P_SHIFT:		out std_logic_vector(P-1 downto 0);
		N_SHIFT:		out std_logic_vector(P downto 0);
		CNT_R:			out std_logic_vector(P downto 0)
	);
end entity;