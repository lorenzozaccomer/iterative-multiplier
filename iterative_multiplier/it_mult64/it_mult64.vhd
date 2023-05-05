
-- it_mult64.vhdl



----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package it_mult64_package is
	component it_mult64 is
		generic(
			N			: integer := 32;
			DIM_CNT		: integer := 7;		-- both units
			ITERATIONS	: integer := 64;	-- for selector unit
			REPETITION	: integer := 8;		-- for resolver unit
			M			: integer := 8;		-- fixed
			P			: integer := 4		-- fixed
			);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- data inputs
			A_M:			in std_logic_vector(N-1 downto 0);
			B_M:			in std_logic_vector(N-1 downto 0);
				-- data outputs
			OUT_MULT:		out std_logic_vector(2*N-1 downto 0);
				-- control signal to/from extern
			DATAIN:			in std_logic;	-- new data to manipulate
			DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
			READY:			out std_logic	-- m_sel can accept new data input
		);
	end component;
end it_mult64_package;
----------------------------------------------------------------------

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.it_mult64_datapath_package.all;
use work.it_mult64_ctrlunit_package.all;


entity it_mult64 is
	generic(
		N			: integer := 32;
		DIM_CNT		: integer := 7;		-- both units
		ITERATIONS	: integer := 64;	-- for selector unit
		REPETITION	: integer := 8;		-- for resolver unit
		M			: integer := 8;		-- fixed
		P			: integer := 4		-- fixed
		);
	port(
		CLK:			in std_logic;
		RST:			in std_logic;
			-- data inputs
		A:				in std_logic_vector(N-1 downto 0);
		B:				in std_logic_vector(N-1 downto 0);
			-- data outputs
		OUT_MULT:		out std_logic_vector(2*N-1 downto 0);
			-- control signal to/from extern
		DATAIN:			in std_logic;	-- new data to manipulate
		DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
		READY:			out std_logic	-- m_sel can accept new data input
	);
end entity;

architecture struct of it_mult64 is

		-- control signal to datapath
	signal loadA:		std_logic;
	signal selA:		std_logic;
	signal loadB:		std_logic;
	signal selB:		std_logic;
	signal selEN1:		std_logic;
	signal loadEN1:		std_logic;
	signal selOPA:		std_logic;
	signal loadOPA:		std_logic;
	signal selOPB:		std_logic;
	signal loadOPB:		std_logic;
	signal selEN2:		std_logic;
	signal loadEN2:		std_logic;
	signal selOUTBM:	std_logic;
	signal loadOUTBM:	std_logic;
	signal selEN3:		std_logic;
	signal loadEN3:		std_logic;
	signal selOUT16:	std_logic;
	signal loadOUT16:	std_logic;
				-- status signals from datapath
	signal ADV_BM:		std_logic_vector(1 downto 0);
	signal DATAOUT_SEL:	std_logic;
	signal DATAOUT_BM:	std_logic;
	signal DATAOUT_RES:	std_logic;
	
	begin
	CTRL: it_mult64_ctrlunit
		port map(CLK, RST, DATAIN, DATAOUT, READY,
			loadA,
			selA,
			loadB,
			selB,
			selEN1,
			loadEN1,
			selOPA,
			loadOPA,
			selOPB,
			loadOPB,
			selEN2,
			loadEN2,
			selOUTBM,
			loadOUTBM,
			selEN3,
			loadEN3,
			selOUT16,
			loadOUT16,
			ADV_BM,
			DATAOUT_SEL,
			DATAOUT_BM,
			DATAOUT_RES
		);

	
	DP: it_mult64_datapath
		generic map(
			N => N,
			DIM_CNT => DIM_CNT,
			REPETITION => REPETITION,
			ITERATIONS => ITERATIONS
		)
		port map(CLK, RST, A, B, OUT_MULT,
			loadA,
			selA,
			loadB,
			selB,
			selEN1,
			loadEN1,
			selOPA,
			loadOPA,
			selOPB,
			loadOPB,
			selEN2,
			loadEN2,
			selOUTBM,
			loadOUTBM,
			selEN3,
			loadEN3,
			selOUT16,
			loadOUT16,
			ADV_BM,
			DATAOUT_SEL,
			DATAOUT_BM,
			DATAOUT_RES
		);
end struct;