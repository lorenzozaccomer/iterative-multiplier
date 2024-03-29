
-- selector.vhdl


----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package selector_package is
	component selector is
		generic(
			N			:	integer := 16;
			DIM_CNT		:	integer := 7;
			ITERATIONS	: 	integer := 16;
			M			:	integer := 4
			);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- data inputs
			A_M:			in std_logic_vector(N-1 downto 0);
			B_M:			in std_logic_vector(N-1 downto 0);
				-- data outputs
			A_BM:			out std_logic_vector(M-1 downto 0);
			B_BM:			out std_logic_vector(M-1 downto 0);
				-- control inputs
			DATAIN:			in std_logic;	-- new data to manipulate
			ADV_AM:			in std_logic_vector(1 downto 0);
				-- control outputs
			NW_PRD:			out std_logic;
			DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
			READY:			out std_logic	-- m_sel can accept new data input
		);
	end component;
end selector_package;
----------------------------------------------------------------------

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.selector_datapath_package.all;
use work.selector_ctrlunit_package.all;

entity selector is
	generic(
		N			:	integer := 32;
		DIM_CNT		:	integer := 7;
		ITERATIONS	: 	integer := 64;
		M			:	integer := 4
	);
	port(
		CLK:			in std_logic;
		RST:			in std_logic;
			-- data inputs
		A_M:			in std_logic_vector(N-1 downto 0);
		B_M:			in std_logic_vector(N-1 downto 0);
			-- data outputs
		A_BM:			out std_logic_vector(M-1 downto 0);
		B_BM:			out std_logic_vector(M-1 downto 0);
			-- control inputs
		DATAIN:			in std_logic;	-- new data to manipulate
		ADV_AM:			in std_logic_vector(1 downto 0);
			-- control outputs
		NW_PRD:			out std_logic;
		DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
		READY:			out std_logic	-- m_sel can accept new data input
	);
end entity;

architecture struct of selector is

			-- control signal to datapath
	signal selAM:			std_logic_vector (1 downto 0);
	signal selBM:			std_logic_vector (1 downto 0);
	signal selINC_M:		std_logic;
	signal selA_BM:			std_logic;
	signal selB_BM:			std_logic;
	signal selINT_A:		std_logic;
	signal selINT_B:		std_logic;
				
	signal loadAM:			std_logic;
	signal loadBM:			std_logic;
	signal loadINC_M:		std_logic;
	signal loadA_BM:		std_logic;
	signal loadB_BM:		std_logic;
	signal loadINT_A:		std_logic;
	signal loadINT_B:		std_logic;
				-- status signals from datapath
	signal INC_M:			std_logic_vector(DIM_CNT-1 downto 0);
	
	begin
	CTRL: selector_ctrlunit
		generic map(
			N,
			DIM_CNT,
			ITERATIONS
		)
		port map(CLK, RST, DATAIN, ADV_AM, NW_PRD, DATAOUT, READY,
			selAM,
			selBM,
			selINC_M,
			selA_BM,
			selB_BM,
			selINT_A,
			selINT_B,
			loadAM,
			loadBM,
			loadINC_M,
			loadA_BM,
			loadB_BM,
			loadINT_A,
			loadINT_B,
			INC_M
		);
		
	DP: selector_datapath
		generic map(
			N,
			DIM_CNT
		)
		port map(CLK, RST, A_M, B_M, A_BM, B_BM,
			selAM,
			selBM,
			selINC_M,
			selA_BM,
			selB_BM,
			selINT_A,
			selINT_B,
			loadAM,
			loadBM,
			loadINC_M,
			loadA_BM,
			loadB_BM,
			loadINT_A,
			loadINT_B,
			INC_M
		);
end struct;