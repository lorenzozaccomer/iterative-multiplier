
-- msel.vhdl


----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package msel_package is
	component msel is
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
				-- data outputs
			A_BM:			out std_logic_vector(M-1 downto 0);
			B_BM:			out std_logic_vector(M-1 downto 0);
				-- control inputs
			DATAIN:			in std_logic;	-- new data to manipulate
			ADV_AM:			in std_logic;
			NW_PRD:			in std_logic;
				-- control outputs
			DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
			READY:			out std_logic	-- m_sel can accept new data input
		);
	end component;
end msel_package;
----------------------------------------------------------------------

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.msel_datapath_package.all;
use work.msel_ctrlunit_package.all;

entity msel is
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
			-- data outputs
		A_BM:			out std_logic_vector(M-1 downto 0);
		B_BM:			out std_logic_vector(M-1 downto 0);
			-- control inputs
		DATAIN:			in std_logic;	-- new data to manipulate
		ADV_AM:			in std_logic;
		NW_PRD:			in std_logic;
			-- control outputs
		DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
		READY:			out std_logic	-- m_sel can accept new data input
	);
end entity;

architecture struct of msel is

			-- control signal to datapath
	signal selAM:			std_logic;
	signal selBM:			std_logic;
	signal selINC_M:		std_logic;
	signal selA_BM:			std_logic;
	signal selB_BM:			std_logic;
				
	signal loadAM:			std_logic;
	signal loadBM:			std_logic;
	signal loadINC_M:		std_logic;
	signal loadA_BM:		std_logic;
	signal loadB_BM:		std_logic;
				-- status signals from datapath
	signal INC_M:			std_logic_vector(M downto 0);
	
	begin
	CTRL: msel_ctrlunit 
		port map(CLK, RST, DATAIN, ADV_AM, NW_PRD, DATAOUT, READY,
			selAM,
			selBM,
			selINC_M,
			selA_BM,
			selB_BM,
			loadAM,
			loadBM,
			loadINC_M,
			loadA_BM,
			loadB_BM,
			INC_M
		);
		
	DP: msel_datapath 
		port map(CLK, RST, A_M, B_M, A_BM, B_BM,
			selAM,
			selBM,
			selINC_M,
			selA_BM,
			selB_BM,
			loadAM,
			loadBM,
			loadINC_M,
			loadA_BM,
			loadB_BM,
			INC_M
		);
end struct;