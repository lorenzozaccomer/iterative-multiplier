
-- basic_mult.vhdl


----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package basic_mult_package is
	component basic_mult is
		generic(
			M 	: integer := 4);
		port(
			CLK:				in std_logic;
			RST:				in std_logic;
				-- data inputs
			A_BM:				in std_logic_vector(M-1 downto 0);
			B_BM:				in std_logic_vector(M-1 downto 0);
				-- data outputs
			OUT_BM:			out std_logic_vector(2*M-1 downto 0);
				-- control inputs
			DATAIN:				in std_logic;
				-- control outputs
			DATAOUT:			out std_logic;	-- new data for bm_sel are ready to used it
			READY:				out std_logic
		);
	end component;
end basic_mult_package;
----------------------------------------------------------------------

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.basic_mult_datapath_package.all;
use work.basic_mult_ctrlunit_package.all;

entity basic_mult is
	generic(
		Q 	: integer := 2;
		M 	: integer := 4);
	port(
		CLK:				in std_logic;
		RST:				in std_logic;
			-- data inputs
		A_BM:				in std_logic_vector(M-1 downto 0);
		B_BM:				in std_logic_vector(M-1 downto 0);
			-- data outputs
		OUT_BM:				out std_logic_vector(2*M-1 downto 0);
			-- control inputs
		DATAIN:				in std_logic;
		-- START:				in std_logic;
			-- control outputs
		DATAOUT:			out std_logic;	-- new data for bm_sel are ready to used it
		READY:				out std_logic
	);
end entity;


architecture struct of basic_mult is
	
		-- control signals to datapath
	signal selOPA:				std_logic;
	signal selOPB:				std_logic;
	signal selRA_BM:			std_logic_vector(Q-1 downto 0);
	signal selRB_BM:			std_logic_vector(Q-1 downto 0);
	signal selOPR:				std_logic_vector(Q-1 downto 0);
	signal selACC_BM:			std_logic_vector(Q-1 downto 0);
	signal selSUM:				std_logic;
	signal selCNT_BM:			std_logic;
	-- signal selADV_BM:			std_logic;
	signal selRPM:				std_logic;
	signal selOUT:				std_logic;
		
	signal loadOPA:				std_logic;
	signal loadOPB:				std_logic;
	signal loadRA_BM:			std_logic;
	signal loadRB_BM:			std_logic;
	signal loadOPR:				std_logic;
	signal loadACC_BM:			std_logic;
	signal loadSUM:				std_logic;
	signal loadCNT_BM:			std_logic;
	-- signal loadADV_BM:			std_logic;
	signal loadOUT:				std_logic;
	signal loadRPM:				std_logic;
		-- status signals from datapath
	signal CNT_BM:				std_logic_vector(Q downto 0);
	signal ADV_BM:				std_logic;	
	
	begin
	CTRL: basic_mult_ctrlunit 
		port map(CLK, RST, DATAIN, DATAOUT, READY,
			selOPA,
			selOPB,
			selRA_BM,
			selRB_BM,
			selOPR,
			selACC_BM,
			selSUM,
			selCNT_BM,
			-- selADV_BM,
			selRPM,
			selOUT,
			loadOPA,
			loadOPB,
			loadRA_BM,
			loadRB_BM,
			loadOPR,
			loadACC_BM,
			loadSUM,
			loadCNT_BM,
			-- loadADV_BM,
			loadOUT,
			loadRPM,
			-- ADV_BM,
			CNT_BM
		);
		
	DP:	basic_mult_datapath 
		port map(CLK, RST, A_BM, B_BM, OUT_BM,
			selOPA,
			selOPB,
			selRA_BM,
			selRB_BM,
			selOPR,
			selACC_BM,
			selSUM,
			selCNT_BM,
			-- selADV_BM,
			selRPM,
			selOUT,
			loadOPA,
			loadOPB,
			loadRA_BM,
			loadRB_BM,
			loadOPR,
			loadACC_BM,
			loadSUM,
			loadCNT_BM,
			-- loadADV_BM,
			loadOUT,
			loadRPM,
			-- ADV_BM,
			CNT_BM
		);
end struct;