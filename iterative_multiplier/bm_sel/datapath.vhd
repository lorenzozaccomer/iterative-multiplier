


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	-- interface
entity datapath is
	generic(
		Q 	: integer := 2;
		M 	: integer := 4);
	port(
		CLK, RST:			in std_logic;
			-- control inputs
		CALC:				in std_logic;
		DATAIN:				in std_logic;
			-- control outputs
		loadOPA:			out std_logic;
		loadOPB:			out std_logic;
		selRA_BM:			out std_logic;
		loadRB_BM:			out std_logic;
		selRB_BM:			out std_logic;
		loadTEMP_BM:		out std_logic;
		selTEMP_BM:			out std_logic;
		loadOPR:			out std_logic;
		selOPR:				out std_logic;
		loadACC:			out std_logic;
		selACC:				out std_logic;
		loadSUM:			out std_logic;
		selSUM:				out std_logic;
		selINC:				out std_logic;
		loadINC:			out std_logic;
		selSH:				out std_logic;
		loadSH:				out std_logic;
		OK:					out std_logic;
			-- status signals
		INT_CNT:			in std_logic_vector(Q downto 0);
		BM_SHIFT:			in std_logic				
		);
end datapath;

architecture struct of datapath is
	component reg4 is
	