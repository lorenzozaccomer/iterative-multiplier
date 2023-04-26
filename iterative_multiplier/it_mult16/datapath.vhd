
-- datapath.vhd

-- for iterative multiplier 16

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package it_mult16_datapath_package is
	component it_mult16_datapath is
		generic(
			N	: integer := 16;
			M	: integer := 8;
			P	: integer := 4
			);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- data inputs
			A:				in std_logic_vector(N-1 downto 0);
			B:				in std_logic_vector(N-1 downto 0);
				-- data outputs
			OUT_MULT16:		out std_logic_vector(2*N-1 downto 0);
				-- control signal to datapath
			loadA:			in std_logic;
			selA:			in std_logic;
			loadB:			in std_logic;
			selB:			in std_logic;
			selEN1:			in std_logic;
			loadEN1:		in std_logic;
			selOPA:			in std_logic;
			loadOPA:		in std_logic;
			selOPB:			in std_logic;
			loadOPB:		in std_logic;
			selEN2:			in std_logic;
			loadEN2:		in std_logic;
			selOUTBM:		in std_logic;
			loadOUTBM:		in std_logic;
			selEN3:			in std_logic;
			loadEN3:		in std_logic;
			selOUT16:		in std_logic;
			loadOUT16:		in std_logic;
				-- status signals from datapath
			ADV_BM:			out std_logic_vector(1 downto 0);
			DATAOUT_SEL:	out std_logic;
			DATAOUT_BM:		out std_logic;
			DATAOUT_RES:	out std_logic
		);
	end component;
end it_mult16_datapath_package;
----------------------------------------------------------------------



library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.it_mult16_components_package.all;

use work.selector_package.all;
use work.basic_mult_package.all;
use work.resolver_package.all;

	-- interface
entity it_mult16_datapath is
	generic(
		N	: integer := 16;
		M	: integer := 8;
		P	: integer := 4
		);
	port(
		CLK:			in std_logic;
		RST:			in std_logic;
			-- data inputs
		A:				in std_logic_vector(N-1 downto 0);
		B:				in std_logic_vector(N-1 downto 0);
			-- data outputs
		OUT_MULT16:		out std_logic_vector(2*N-1 downto 0);
			-- control signal to datapath
		loadA:			in std_logic;
		selA:			in std_logic;
		loadB:			in std_logic;
		selB:			in std_logic;
		selEN1:			in std_logic;
		loadEN1:		in std_logic;
		selOPA:			in std_logic;
		loadOPA:		in std_logic;
		selOPB:			in std_logic;
		loadOPB:		in std_logic;
		selEN2:			in std_logic;
		loadEN2:		in std_logic;
		selOUTBM:		in std_logic;
		loadOUTBM:		in std_logic;
		selEN3:			in std_logic;
		loadEN3:		in std_logic;
		selOUT16:		in std_logic;
		loadOUT16:		in std_logic;
			-- status signals from datapath
		ADV_BM:			out std_logic_vector(1 downto 0);
		DATAOUT_SEL:	out std_logic;
		DATAOUT_BM:		out std_logic;
		DATAOUT_RES:	out std_logic
	);
end entity;



architecture struct of it_mult16_datapath is

	-- signals	
	signal new_product:						std_logic;
	signal datain1, datain2, datain3:		std_logic;
	signal dataout1, dataout2, dataout3:	std_logic;
	signal ready_sel, data_bm, ready_res:	std_logic;
	signal advance_bm:						std_logic_vector(1 downto 0);
	
	signal am_in, am_out:					std_logic_vector(P-1 downto 0) := (others=>'0');
	signal bm_in, bm_out:					std_logic_vector(P-1 downto 0) := (others=>'0');
	
	signal a_in, a_out:						std_logic_vector(N-1 downto 0) := (others=>'0');
	signal b_in, b_out:						std_logic_vector(N-1 downto 0) := (others=>'0');
	signal out16_in, out_16_out:			std_logic_vector(2*N-1 downto 0) := (others=>'0');
	signal result_out:						std_logic_vector(2*N-1 downto 0) := (others=>'0');
	
				
	begin
		-- REGISTERS
	REG_A:		regN generic map(N) port map(CLK, RST, loadA, a_in, a_out);
	REG_B:		regN generic map(N) port map(CLK, RST, loadB, b_in, b_out);
	REG_RESULT:	regN generic map(N) port map(CLK, RST, loadOUT16, out16_in, out_16_out);
	
		-- MUXS
	MUX_A:		mux2N generic map(M) port map(selA, A, a_out, a_in);
	MUX_B:		mux2N generic map(M) port map(selB, B, b_out, b_in);
	MUX_A_M:	mux2N generic map(M) port map(selA, A, a_out, a_in);
	MUX_B_M:	mux2N generic map(M) port map(selB, B, b_out, b_in);
	
		-- ADDERS
		
		-- SHIFTERS
		
	--COSTUM MODULES
	
		-- SELECTOR
	SEL1: selector port map(CLK, RST, a_out, b_out, am_out, bm_out, datain1, advance_bm, new_product, dataout1, ready_sel);
		
		-- BASIC_MULT
	-- BM1: basic_mult port map(CLK, RST, a_out, b_out, am_out, bm_out, datain, nw_prd, adv_am, dataout_sel, ready_sel);		
	
		-- RESOLVER
	-- RES1: resolver port map(CLK, RST, a_out, b_out, am_out, bm_out, datain, nw_prd, adv_am, dataout_sel, ready_sel);

		-- status signals

		-- data outputs
	ADV_BM		<= advance_bm;
	DATAOUT_SEL <= dataout1;
	DATAOUT_BM 	<= dataout2;
	DATAOUT_RES <= dataout3;
	
	OUT_MULT16 	<= result_out;
	
end struct;