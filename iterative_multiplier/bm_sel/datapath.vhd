


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	-- interface
package bmsel_datapath_package is
    component bmsel_datapath is
		generic(
			Q 	: integer := 2;
			M 	: integer := 4);
		port(
			CLK, RST:			in std_logic;
				-- data inputs
			A_BM, B_BM:			in std_logic_vector(M-1 downto 0);
				-- data outputs
			ROUT_BM:			out std_logic_vector(2*M-1 downto 0);
				-- control singals to datapath
			selOPA:				in std_logic;
			selOPB:				in std_logic;
			selA_BM:			in std_logic_vector(Q-1 downto 0);
			selB_BM:			in std_logic_vector(Q-1 downto 0);
			selTEMP_BM:			in std_logic;	-- NOT USED
			selOPR:				in std_logic_vector(Q-1 downto 0);
			selACC_BM:			in std_logic_vector(Q-1 downto 0);
			selSUM:				in std_logic;
			selINC_BM:			in std_logic;
			selADV_BM:			in std_logic;
			selRPM:				in std_logic;
			
			selSUBPRD:			in std_logic;	-- NOT USED
			selSH_TMP:			in std_logic;	-- NOT USED
		
			loadOPA:			in std_logic;
			loadOPB:			in std_logic;
			loadA_BM:			in std_logic;
			loadB_BM:			in std_logic;
			loadTEMP_BM:		in std_logic;
			loadOPR:			in std_logic;
			loadACC_BM:			in std_logic;
			loadSUM:			in std_logic;
			loadINC_BM:			in std_logic;
			loadADV_BM:			in std_logic;
			loadOUT:			in std_logic;
			loadRPM:			in std_logic;
				-- status signals from datapath
			CNT_BM:				out std_logic_vector(Q downto 0);
			ADV_BM:				out std_logic
			);
	end component;
end bmsel_datapath_package;
----------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.components_package.all;

	-- interface
entity bmsel_datapath is
	generic(
		Q 	: integer := 2;
		M 	: integer := 4);
	port(
		CLK, RST:			in std_logic;
			-- data inputs
		A_BM, B_BM:			in std_logic_vector(M-1 downto 0);
			-- data outputs
		ROUT_BM:			out std_logic_vector(2*M-1 downto 0);
			-- control signals to datapath
		selOPA:				in std_logic;
		selOPB:				in std_logic;
		selA_BM:			in std_logic_vector(Q-1 downto 0);
		selB_BM:			in std_logic_vector(Q-1 downto 0);
		selTEMP_BM:			in std_logic;	-- NOT USED
		selOPR:				in std_logic_vector(Q-1 downto 0);
		selACC_BM:			in std_logic_vector(Q-1 downto 0);
		selSUM:				in std_logic;
		selINC_BM:			in std_logic;
		selADV_BM:			in std_logic;
		selRPM:				in std_logic;
		
		selSUBPRD:			in std_logic;	-- NOT USED
		selSH_TMP:			in std_logic;	-- NOT USED
		
		loadOPA:			in std_logic;
		loadOPB:			in std_logic;
		loadA_BM:			in std_logic;
		loadB_BM:			in std_logic;
		loadTEMP_BM:		in std_logic;
		loadOPR:			in std_logic;
		loadACC_BM:			in std_logic;
		loadSUM:			in std_logic;
		loadINC_BM:			in std_logic;
		loadADV_BM:			in std_logic;
		loadOUT:			in std_logic;
		loadRPM:			in std_logic;
			-- status signals from datapath
		CNT_BM:				out std_logic_vector(Q downto 0);
		ADV_BM:				out std_logic							
		);
end entity;

architecture struct of bmsel_datapath is
	
		-- signals
	signal adv_in:						std_logic;
	signal adv_out: 					std_logic;
	signal notport_out:					std_logic;
		
	signal opa_in, opa_out:				std_logic_vector(Q-1 downto 0);
	signal opb_in, opb_out:				std_logic_vector(Q-1 downto 0);
	
	signal inc_bm_in, inc_bm_out:		std_logic_vector(Q downto 0); 
	signal add_inc_bm_out:				std_logic_vector(Q downto 0);
	
	signal temp_bm_in, temp_bm_out: 	std_logic_vector(M-1 downto 0);
	signal ra_bm_in, ra_bm_out:			std_logic_vector(M-1 downto 0);
	signal rb_bm_in, rb_bm_out:			std_logic_vector(M-1 downto 0);
	signal shift_rb_bm:					std_logic_vector(M-1 downto 0);
	signal shift_ra_bm:					std_logic_vector(M-1 downto 0);
	
	signal accbm_in, accbm_out:			std_logic_vector(2*M-1 downto 0);
	signal rout_in, rout_out:			std_logic_vector(2*M-1 downto 0);
	signal opr_in, opr_out:				std_logic_vector(2*M-1 downto 0);
	
	signal add_sum_out:					std_logic_vector(2*M-1 downto 0);
	signal add_subproduct_out:			std_logic_vector(2*M-1 downto 0);
	signal product_out:					std_logic_vector(2*M-1 downto 0) := (others=>'0');
	signal shift_opr:					std_logic_vector(2*M-1 downto 0);
	signal r_out_bm:					std_logic_vector(2*M-1 downto 0);
	signal shift_acc_bm:				std_logic_vector(2*M-1 downto 0);
	signal sum_bm_in, sum_bm_out:		std_logic_vector(2*M-1 downto 0);
	signal rpm_in, rpm_out:				std_logic_vector(2*M-1 downto 0);
	
		-- internal signals
	signal zeros2:						std_logic_vector(Q-1 downto 0)	:= (others=>'0');
	signal zeros3:						std_logic_vector(Q downto 0)	:= (others=>'0');
	signal zeros4:						std_logic_vector(M-1 downto 0)	:= (others=>'0');
	signal zeros8:						std_logic_vector(2*M-1 downto 0):= (others=>'0');
	signal one_inc_vector:				std_logic_vector(Q downto 0)	:= "001";
	
	
	begin
		
		-- REGISTERS
	REG_ADV:		reg port map(CLK, RST, loadADV_BM, adv_in, adv_out);
	
	REG_OPA:		regN generic map(Q) port map(CLK, RST, loadOPA, opa_in, opa_out);
	REG_OPB:		regN generic map(Q) port map(CLK, RST, loadOPB, opb_in, opb_out);	
	
	REG_INC_BM:		regN generic map(Q+1) port map(CLK, RST, loadINC_BM, inc_bm_in, inc_bm_out);
	
	REG_A_BM:		regN generic map(M) port map(CLK, RST, loadA_BM, ra_bm_in, ra_bm_out);
	REG_B_BM:		regN generic map(M) port map(CLK, RST, loadB_BM, rb_bm_in, rb_bm_out);
	
	REG_SUM:		regN generic map(2*M) port map(CLK, RST, loadSUM, sum_bm_in, sum_bm_out);
	REG_ACC_BM:		regN generic map(2*M) port map(CLK, RST, loadACC_BM, accbm_in, accbm_out);
	REG_OPR:		regN generic map(2*M) port map(CLK, RST, loadOPR, opr_in, opr_out);
	REG_PM:			regN generic map(2*M) port map(CLK, RST, loadRPM, rpm_in, rpm_out);
	REG_OUT_BM:		regN generic map(2*M) port map(CLK, RST, loadOUT, rout_in, r_out_bm);
	
		-- -- MUXS
	MUX_SHIFT_BM:	mux port map(selADV_BM, '0', notport_out, adv_in);		
	
	MUX_OPA:		mux2N generic map(Q) port map(selOPA, ra_bm_out(Q-1 downto 0), opa_out, opa_in);				
	MUX_OPB:		mux2N generic map(Q) port map(selOPB, rb_bm_out(Q-1 downto 0), opb_out, opb_in);				
	MUX_INC_BM:		mux2N generic map(Q+1) port map(selINC_BM, zeros3, add_inc_bm_out, inc_bm_in); 	
	MUX_A_BM:		mux4N generic map(M) port map(selA_BM, A_BM, ra_bm_out, shift_ra_bm, zeros4, ra_bm_in);		
	MUX_B_BM:		mux4N generic map(M) port map(selB_BM, B_BM, rb_bm_out, shift_rb_bm, zeros4, rb_bm_in);	
	
	MUX_RPM:		mux2N generic map(2*M) port map(selRPM, zeros8, rpm_out, rpm_in);		
	MUX_SUM:		mux2N generic map(2*M) port map(selSUM, add_sum_out, sum_bm_out, sum_bm_in); 
	MUX_OPR:		mux4N generic map(2*M) port map(selOPR, zeros8, shift_opr, opr_out, product_out, opr_in);
	MUX_ACC_BM: 	mux4N generic map(2*M) port map(selACC_BM, zeros8, shift_acc_bm, accbm_out, add_sum_out, accbm_in);
	
	-- MUX_TEMPtoA:	mux2N generic map(Q) port map(selSUBPRD, zeros2, temp_bm_out(Q-1 downto 0), opa_in);
	-- MUX_SH_TMP:		mux2N generic map(M) port map(selSH_TMP, zeros4, shift_ra_bm, ra_bm_out);
	-- MUX_ADD_INC:	mux2N generic map(Q+1) port map(
	-- MUX_ADD_OPR:	mux2N generic map(2*M) port map(
	-- MUX_ADD_SUBPRD:	mux2N generic map(2*M) port map(
	
		-- ADDERS
	-- needed to increment CNT_BM
	ADD_INC_BM:		adderNotCOut generic map(Q+1) port map(inc_bm_out, one_inc_vector, add_inc_bm_out);		
	-- SUM_BUM = ACC_BM + OPR	
	ADD_SUM:		adderNotCOut generic map(2*M) port map(opr_out, accbm_out, add_sum_out);		
	-- ROUT = RPM + ACC
	ADD_SUBPRD:		adderNotCOut generic map(2*M) port map(rpm_out, accbm_out, add_subproduct_out);	
	
		-- LOGIC PORTS
	NOTPORT1:		notport port map(adv_out, notport_out);
	
		-- SHIFTERS
	SH_B_BM:		rightshiftN	generic map(M,Q) port map(rb_bm_out, shift_rb_bm);
	SH_OPR:			leftshiftN  generic map(2*M,Q) port map(opr_out, shift_opr);
	SH_A_BM:		rightshiftN generic map(M,Q) port map(ra_bm_out, shift_ra_bm);
	SH_ACC_BM:		rightshiftN	generic map(2*M,Q) port map(accbm_out, shift_acc_bm);
	
		-- PRODUCT
	PRODUCT:		multiplierN port map(opa_out, opb_out, product_out(M-1 downto 0));
	
		-- status signals
	ADV_BM 	<= adv_out;
	CNT_BM <= inc_bm_out;
	
		-- data output
	ROUT_BM <= r_out_bm;
	
end struct;