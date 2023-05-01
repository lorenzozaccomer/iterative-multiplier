
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
	signal enable1, enable2, enable3:		std_logic;
	signal datain1, datain2, datain3:		std_logic;
	signal dataout1, dataout2, dataout3:	std_logic;
	signal ready_sel, ready_bm, ready_res:	std_logic;
	signal advance_bm:						std_logic_vector(1 downto 0);
	
	signal a_sel, b_sel:					std_logic_vector(P-1 downto 0) := (others=>'0');
	signal opa_in, opa_out:					std_logic_vector(P-1 downto 0) := (others=>'0');
	signal opb_in, opb_out:					std_logic_vector(P-1 downto 0) := (others=>'0');
	
	signal bm_in, bm_out:					std_logic_vector(M-1 downto 0) := (others=>'0');
	signal outbm:							std_logic_vector(M-1 downto 0) := (others=>'0');
	
	signal a16_in, a16_out:					std_logic_vector(N-1 downto 0) := (others=>'0');
	signal b16_in, b16_out:					std_logic_vector(N-1 downto 0) := (others=>'0');
	signal out16_in, out_16_out:			std_logic_vector(2*N-1 downto 0) := (others=>'0');
	signal result_out:						std_logic_vector(2*N-1 downto 0) := (others=>'0');
	
	constant zero:							std_logic := '0';
	constant one:							std_logic := '1';
	
	constant zeros4:						std_logic_vector(P-1 downto 0) := (others=>'0');
				
	begin
		-- REGISTERS
	REG_EN1:	reg port map(CLK, RST, loadEN1, enable1, datain1);
	REG_EN2:	reg port map(CLK, RST, loadEN2, enable2, datain2);
	REG_EN3:	reg port map(CLK, RST, loadEN3, enable3, datain3);
	
	REG_OPA:	regN generic map(P) port map(CLK, RST, loadA, opa_in, opa_out);
	REG_OPB:	regN generic map(P) port map(CLK, RST, loadB, opb_in, opb_out);
	
	REG_OUTBM:	regN generic map(M) port map(CLK, RST, loadOUTBM, bm_in, bm_out);
	
	REG_A16:	regN generic map(N) port map(CLK, RST, loadA, a16_in, a16_out);
	REG_B16:	regN generic map(N) port map(CLK, RST, loadB, b16_in, b16_out);
	REG_OUT16:	regN generic map(2*N) port map(CLK, RST, loadOUT16, out16_in, out_16_out);
	
		-- MUXS
	MUX_EN1:	mux2 port map(selEN1, zero, one, enable1);
	MUX_EN2:	mux2 port map(selEN2, zero, one, enable2);
	MUX_EN3:	mux2 port map(selEN3, zero, one, enable3);
		
	MUX_OPA:	mux2N generic map(P) port map(selOPA, opa_out, a_sel, opa_in);
	MUX_OPB:	mux2N generic map(P) port map(selOPB, opb_out, b_sel, opb_in);
	
	MUX_OUTBM:	mux2N generic map(M) port map(selOUTBM, bm_out, outbm, bm_in);
	
	MUX_A16:	mux2N generic map(N) port map(selA, a16_out, A, a16_in);
	MUX_B16:	mux2N generic map(N) port map(selB, b16_out, B, b16_in);
	
	MUX_OUT16:	mux2N generic map(2*N) port map(selOUT16, out_16_out, result_out, out16_in);
	
		-- SELECTOR
	SEL1: selector port map(CLK, RST, a16_out, b16_out, a_sel, b_sel, datain1, advance_bm, new_product, dataout1, ready_sel);
		
		-- BASIC_MULT
	BM1: basic_mult port map(CLK, RST, opa_out, opb_out, outbm, datain2, dataout2, ready_bm);		
	
		-- RESOLVER
	RES1: resolver port map(CLK, RST, bm_out, result_out, datain3, new_product, advance_bm, dataout_sel, ready_sel);

		-- status signals

		-- data outputs
	ADV_BM		<= advance_bm;
	DATAOUT_SEL <= dataout1;
	DATAOUT_BM 	<= dataout2;
	DATAOUT_RES <= dataout3;
	
	OUT_MULT16 	<= out_16_out;
	
end struct;