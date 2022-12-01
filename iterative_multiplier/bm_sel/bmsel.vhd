
-- bmsel.vhdl


----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package bmsel_package is
	component bmsel is
		generic(
			M 	: integer := 4);
		port(
			CLK:				in std_logic;
			RST:				in std_logic;
				-- data inputs
			RA_BM:				in std_logic_vector(M-1 downto 0);
			RB_BM:				in std_logic_vector(M-1 downto 0);
				-- data outputs
			ROUT_BM:			out std_logic_vector(2*M-1 downto 0);
				-- control inputs
			DATAIN:				in std_logic;
				-- control outputs
			READY:				out std_logic
		);
	end component;
end bmsel_package;
----------------------------------------------------------------------

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.bmsel_datapath_package.all;
use work.bmsel_ctrlunit_package.all;

entity bmsel is
	generic(
		Q 	: integer := 2;
		M 	: integer := 4);
	port(
		CLK:				in std_logic;
		RST:				in std_logic;
			-- data inputs
		RA_BM:				in std_logic_vector(M-1 downto 0);
		RB_BM:				in std_logic_vector(M-1 downto 0);
			-- data outputs
		ROUT_BM:			out std_logic_vector(2*M-1 downto 0);
			-- control inputs
		DATAIN:				in std_logic;
		-- START:				in std_logic;
			-- control outputs
		READY:				out std_logic
	);
end entity;


architecture struct of bmsel is
	
		-- control signals to datapath
	signal selOPA:				std_logic;
	signal selOPB:				std_logic;
	signal selRA_BM:			std_logic_vector(Q-1 downto 0);
	signal selRB_BM:			std_logic_vector(Q-1 downto 0);
	signal selOPR:				std_logic_vector(Q-1 downto 0);
	signal selACC_BM:			std_logic_vector(Q-1 downto 0);
	signal selSUM:				std_logic;
	signal selINC_CNT:			std_logic;
	signal selADV_BM:			std_logic;
	signal selRPM:				std_logic;
	signal selOUT:				std_logic;
		
	signal loadOPA:				std_logic;
	signal loadOPB:				std_logic;
	signal loadRA_BM:			std_logic;
	signal loadRB_BM:			std_logic;
	signal loadOPR:				std_logic;
	signal loadACC_BM:			std_logic;
	signal loadSUM:				std_logic;
	signal loadINC_CNT:			std_logic;
	signal loadADV_BM:			std_logic;
	signal loadOUT:				std_logic;
	signal loadRPM:				std_logic;
		-- status signals from datapath
	signal CNT_BM:				std_logic_vector(Q downto 0);
	signal ADV_BM:				std_logic;	
	
	begin
	CTRL: bmsel_ctrlunit 
		port map(CLK, RST, DATAIN, READY,
			selOPA,
			selOPB,
			selRA_BM,
			selRB_BM,
			selOPR,
			selACC_BM,
			selSUM,
			selINC_CNT,
			selADV_BM,
			selRPM,
			selOUT,
			loadOPA,
			loadOPB,
			loadRA_BM,
			loadRB_BM,
			loadOPR,
			loadACC_BM,
			loadSUM,
			loadINC_CNT,
			loadADV_BM,
			loadOUT,
			loadRPM,
			CNT_BM,
			ADV_BM
		);
		
	DP:	bmsel_datapath 
		port map(CLK, RST, RA_BM, RB_BM, ROUT_BM,
			selOPA,
			selOPB,
			selRA_BM,
			selRB_BM,
			selOPR,
			selACC_BM,
			selSUM,
			selINC_CNT,
			selADV_BM,
			selRPM,
			selOUT,
			loadOPA,
			loadOPB,
			loadRA_BM,
			loadRB_BM,
			loadOPR,
			loadACC_BM,
			loadSUM,
			loadINC_CNT,
			loadADV_BM,
			loadOUT,
			loadRPM,
			CNT_BM,
			ADV_BM
		);
end struct;