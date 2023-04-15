
-- res.vhdl


----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package res_package is
	component res is
		generic(
			N	: integer := 16;
			M	: integer := 8;
			P	: integer := 4
			);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- data inputs
			OUT_BM:			in std_logic_vector(M-1 downto 0);
				-- data outputs
			RES:			out std_logic_vector(2*N-1 downto 0);
				-- control signal to/from extern
			DATAIN:			in std_logic;	-- new data to manipulate
			NW_PRD:			in std_logic;
			ADV_AM:			out std_logic_vector (1 downto 0);	-- new 4bits of A
			DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
			READY:			out std_logic	-- m_sel can accept new data input
		);
	end component;
end res_package;
----------------------------------------------------------------------

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.res_datapath_package.all;
use work.res_ctrlunit_package.all;

entity res is
	generic(
		N	: integer := 16;
		M	: integer := 8;
		P	: integer := 4
		);
	port(
		CLK:			in std_logic;
		RST:			in std_logic;
			-- data inputs
		OUT_BM:			in std_logic_vector(M-1 downto 0);
			-- data outputs
		RES:			out std_logic_vector(2*N-1 downto 0);
			-- control signal to/from extern
		DATAIN:			in std_logic;	-- new data to manipulate
		NW_PRD:			in std_logic;
		ADV_AM:			out std_logic_vector (1 downto 0);	-- new 4bits of A
		DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
		READY:			out std_logic	-- m_sel can accept new data input
	);
end entity;

architecture struct of res is

		-- control signal to datapath
	signal loadNSHIFT:		 std_logic;
	signal selNSHIFT:		 std_logic;
	signal loadPSHIFT:		 std_logic;
	signal selPSHIFT:		 std_logic;
	signal loadOUTBM:		 std_logic;
	signal selOUTBM:		 std_logic;
	signal loadBM:			 std_logic;
	signal selBM:			 std_logic;
	signal loadS1:			 std_logic;
	signal selS1:			 std_logic;
	signal loadRS:			 std_logic;
	signal selRS:			 std_logic_vector(1 downto 0);
	signal loadS2:			 std_logic;
	signal selS2:			 std_logic;
	signal loadACCR:		 std_logic;
	signal selACCR:			 std_logic;
	signal loadRES:			 std_logic;
	signal selRES:			 std_logic;
				-- status signals from datapath
	signal P_SHIFT:		std_logic_vector(1 downto 0);
	signal N_SHIFT:		std_logic_vector(P downto 0);
	
	begin
	CTRL: res_ctrlunit 
		port map(CLK, RST, DATAIN, NW_PRD, ADV_AM, DATAOUT, READY,
			loadNSHIFT,
			selNSHIFT,
			loadPSHIFT,
			selPSHIFT,
			loadOUTBM,
			selOUTBM,
			loadBM,
			selBM,
			loadS1,
			selS1,
			loadRS,
			selRS,
			loadS2,
			selS2,
			loadACCR,
			selACCR,
			loadRES,
			selRES,
			P_SHIFT,
			N_SHIFT
		);
		
	DP: res_datapath 
		port map(CLK, RST, OUT_BM, RES,
			loadNSHIFT,
			selNSHIFT,
			loadPSHIFT,
			selPSHIFT,
			loadOUTBM,
			selOUTBM,
			loadBM,
			selBM,
			loadS1,
			selS1,
			loadRS,
			selRS,
			loadS2,
			selS2,
			loadACCR,
			selACCR,
			loadRES,
			selRES,
			P_SHIFT,
			N_SHIFT
		);
end struct;