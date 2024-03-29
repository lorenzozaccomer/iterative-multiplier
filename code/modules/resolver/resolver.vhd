
-- resolver.vhdl



----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package resolver_package is
	component resolver is
		generic(
			N			: integer := 16;
			DIM_CNT		: integer := 3;
			M			: integer := 8;
			REPETITION	: integer := 4
			);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- data inputs
			OUT_BM:			in std_logic_vector(M-1 downto 0);
				-- data outputs
			RESULT:			out std_logic_vector(2*N-1 downto 0);
				-- control signal to/from extern
			DATAIN:			in std_logic;	-- new data to manipulate
			NW_PRD:			in std_logic;
			ADV_AM:			out std_logic_vector (1 downto 0);	-- new 4bits of A
			DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
			READY:			out std_logic	-- m_sel can accept new data input
		);
	end component;
end resolver_package;
----------------------------------------------------------------------

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.resolver_datapath_package.all;
use work.resolver_ctrlunit_package.all;

entity resolver is
	generic(
		N			: integer := 16;
		DIM_CNT		: integer := 3;
		M			: integer := 8;
		REPETITION	: integer := 4
		);
	port(
		CLK:			in std_logic;
		RST:			in std_logic;
			-- data inputs
		OUT_BM:			in std_logic_vector(M-1 downto 0);
			-- data outputs
		RESULT:			out std_logic_vector(2*N-1 downto 0);
			-- control signal to/from extern
		DATAIN:			in std_logic;	-- new data to manipulate
		NW_PRD:			in std_logic;
		ADV_AM:			out std_logic_vector (1 downto 0);	-- new 4bits of A
		DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
		READY:			out std_logic	-- m_sel can accept new data input
	);
end entity;

architecture struct of resolver is

		-- control signal to datapath
	signal loadNSHIFT:		 std_logic;
	signal selNSHIFT:		 std_logic;
	signal loadPSHIFT:		 std_logic;
	signal selPSHIFT:		 std_logic;
	signal loadOUTBM:		 std_logic;
	signal selOUTBM:		 std_logic;
	signal loadINT:			 std_logic;
	signal selINT:			 std_logic;
	signal loadINT2:		 std_logic;
	signal selINT2:			 std_logic;
	signal loadS1:			 std_logic;
	signal selS1:			 std_logic;
	signal loadRS:			 std_logic;
	signal selRS:			 std_logic_vector(1 downto 0);
	signal selS2:			 std_logic;
	signal loadS2:			 std_logic;
	signal selOPT1:			 std_logic;
	signal selOPT2:			 std_logic;
	signal loadACCR:		 std_logic;
	signal selACCR:			 std_logic_vector(1 downto 0);
	signal loadRESULT:		 std_logic;
	signal selRESULT:		 std_logic;
				-- status signals from datapath
	signal P_SHIFT:		std_logic_vector(DIM_CNT-1 downto 0);
	signal N_SHIFT:		std_logic_vector(DIM_CNT-1 downto 0);
	
	begin
	CTRL: resolver_ctrlunit 
		generic map(
			N => N,
			DIM_CNT => DIM_CNT,
			REPETITION => REPETITION
		)
		port map(CLK, RST, DATAIN, NW_PRD, ADV_AM, DATAOUT, READY,
			loadNSHIFT,
			selNSHIFT,
			loadPSHIFT,
			selPSHIFT,
			loadOUTBM,
			selOUTBM,
			loadINT,
			selINT,
			loadINT2,
			selINT2,
			loadS1,
			selS1,
			loadRS,
			selRS,
			loadS2,
			selS2,
			selOPT1,
			selOPT2,
			loadACCR,
			selACCR,
			loadRESULT,
			selRESULT,
			P_SHIFT,
			N_SHIFT
		);
		
	DP: resolver_datapath
		generic map(
			N => N,
			DIM_CNT => DIM_CNT
		)
		port map(CLK, RST, OUT_BM, RESULT,
			loadNSHIFT,
			selNSHIFT,
			loadPSHIFT,
			selPSHIFT,
			loadOUTBM,
			selOUTBM,
			loadINT,
			selINT,
			loadINT2,
			selINT2,
			loadS1,
			selS1,
			loadRS,
			selRS,
			loadS2,
			selS2,
			selOPT1,
			selOPT2,
			loadACCR,
			selACCR,
			loadRESULT,
			selRESULT,
			P_SHIFT,
			N_SHIFT
		);
end struct;