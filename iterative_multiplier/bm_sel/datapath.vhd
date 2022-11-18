


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
			-- data inputs
		RA_BM, RB_BM:		in std_logic_vector(M-1 downto 0);
			-- data outputs
		ROUT_BM:			out std_logic_vector(2*M-1 downto 0);
			-- control inputs
		CALC:				in std_logic;
		DATAIN:				in std_logic;
			-- control outputs
		selOPA:				out std_logic;
		selOPB:				out std_logic;
		selRA_BM:			out std_logic_vector(Q-1 downto 0);
		selRB_BM:			out std_logic_vector(Q-1 downto 0);
		selTEMP_BM:			out std_logic_vector(Q-1 downto 0);
		selOPR:				out std_logic_vector(Q-1 downto 0);
		selACC_BM:			out std_logic_vector(Q-1 downto 0);
		selSUM:				out std_logic;
		selINC_CNT:			out std_logic_vector(Q-1 downto 0);
		selSH_BM:			out std_logic_vector(Q-1 downto 0);
		selR_PM:			out std_logic;
		
		loadOPA:			out std_logic;
		loadOPB:			out std_logic;
		loadRB_BM:			out std_logic;
		loadTEMP_BM:		out std_logic;
		loadOPR:			out std_logic;
		loadACC_BM:			out std_logic;
		loadSUM:			out std_logic;
		loadINC_CNT:		out std_logic;
		loadSH_BM:			out std_logic;
		loadOUT:			out std_logic;
		loadR_PM:			out std_logic;
		OK:					out std_logic;
			-- status signals
		INT_CNT:			in std_logic_vector(Q+1 downto 0);
		BM_SHIFT:			in std_logic							
		);
end datapath;

architecture struct of datapath is
	
		-- signals
	signal opa_in, opa_out:		std_logic_vector(Q-1 downto 0);
	signal opb_in, opb_out:		std_logic_vector(Q-1 downto 0);
	
	signal temp_bm_in, temp_bm_out: 	std_logic_vector(M-1 downto 0);
	signal inc_cnt_in, inc_cnt_out: 	std_logic_vector(M-1 downto 0);
	signal rb_bm_in, rb_bm_out:			std_logic_vector(M-1 downto 0);
	signal shift_rb:					std_logic_vector(M-1 downto 0);
	
	signal add_cnt_out:			std_logic_vector(M downto 0);
	
	signal accbm_in, accbm_out:	std_logic_vector(2*M-1 downto 0);
	signal rout_in, rout_out:	std_logic_vector(2*M-1 downto 0);
	signal opr_in, opr_out:		std_logic_vector(2*M-1 downto 0);
	
	signal sum_out:				std_logic_vector(2*M downto 0);
	signal shift_opr_out:		std_logic_vector(2*M downto 0);
	
	begin
		-- REGISTERS
	OP_A:		regN generic map(Q) port map(CLK, RST, loadOPA, opa_in, opa_out);
	OP_B:		regN generic map(Q) port map(CLK, RST, loadOPB, opb_in, opb_out);	
	OP_R:		regN generic map(2*M) port map(CLK, RST, loadOPR, opr_in, opr_out);
	RA_BM:		regN generic map(M) port map(CLK, RST, loadRA_BM, ra_bm_in, ra_bm_out);
	RB_BM:		regN generic map(M) port map(CLK, RST, loadRB_BM, rb_bm_in, rb_bm_out);
	TEMP_BM:	regN generic map(M) port map(CLK, RST, loadTEMP_BM, temp_bm_in, temp_bm_out);
	SUM:		regN generic map(2*M) port map(CLK, RST, loadSUM, sum_in, sum_out);
	ACC_BM:		regN generic map(2*M) port map(CLK, RST, loadACC_BM, accbm_in, accbm_out);
	INC_CNT:	regN generic map(M) port map(CLK, RST, loadINC_CNT, inc_cnt_in, inc_cnt_out);
	-- BM_SHIFT:	regN generic map
	R_PM:		regN generic map(2*M) port map(CLK, RST, load_RPM, rpm_in, rpm_out);
	R_OUT:		regN generic map(2*M) port map(CLK, RST, loadOUT, subproduct_out, out_out);
	
		-- MUXS
	MUX_OPA:	mux2N generic map(Q) port map(selOPA, (others=>'0'), opa_out, opa_in);
	MUX_OPB:	mux2N generic map(Q) port map(selOPB, (others=>'0'), opb_out, opb_in);
	MUX_OPR:	mux2N generic map(2*M) port map(selOPR, shift_opr_out, opr_out, opr_in);
	MUX_SUM_BM:	mux2N generic map(2*M) port map(selSUM, (others=>'0'), sum_out, accbm_in);
	MUX_ACC_BM: mux2N generic map(2*M) port map(selACC_BM, shift_acc_out, accbm_out, accbm_in);
	MUX_INC_CNT:mux2N generic map(Q) port map(selINC_CNT, (others=>'0'), adder1_out, inc_cnt_in);
	MUX_RPM:	mux2N generic map(2*M) port map(selR_PM, (others=>'0'), rpm_out, rpm_in);
	MUX_RA_BM:	mux2N generic map(M) port map(selRA_BM, (others=>'0'), ra_bm_out, ra_bm_in);
	MUX_RB_BM:	mux2N generic map(M) port map(selRB_BM, rb_bm_out, rb_bm_out(Q-1,0), rb_bm_in);
	MUX_TEMP_BM:mux2N generic map(M) port map(selTEMP_BM, temp_bm_out, temp_bm_out(Q-1,0), opa_in);
	
		-- ADDERS
	SUM_BM:		adderN generic map(2*M) port map(opr_out, accbm_out, sum_in);
	ADDER1:		adderN_NC port map(inc_cnt_out, "0001", adder1_out);
	ADDER2:		notport port map(inc_cnt_out, '1', adder2_out);
	SUBPRODUCT;	adderN generic map(2*M) port map(rpm_out, accbm_out, subproduct_out);
	
		-- SHIFTERS
	SHIFT_RB:		leftshiftN generic map(M,Q) port map(rb_bm_in, shift_rb);
	SHIFT_OPR:		leftshiftN generic map(2*M,Q) port map(opr_out, shift_opr_out);
	SHIFT_ACC_BM:	leftshiftN generic map(2*M,Q) port map(accbm_out, shift_acc_out);
	
		-- PRODUCT
	PRODUCT:	BasicMultiplier port map(opa_out, opb_out, opr_in(M-1,0));
	
		-- status signals
	BM_SHIFT <= adder2_out;
	INT_CNT <= adder1_out;
	
		-- REGISTERS
	-- TEMP_BM:	regN generic map(M) port map(CLK, RST, loadTEMP_BM, RB_BM, TEMP_BM);
	-- OPA:		regN generic map(Q) port map(CLK, RST, loadOPA, opa_in, opa_out);
	-- OPB:		regN generic map(Q) port map(CLK, RST, loadOPB, opb_in, opb_out);
	-- OPR:		regN generic map(M) port map(CLK, RST, loadOPR, opr_in, opr_out);
	-- ACC_BM:		regN generic map(2*M) port map(CLK, RST, loadACC_BM, accbm_in, accbm_out);
	-- ROUT_BM:	regN generic map(2*M) port map(CLK, RST, loadOUT, rout_in, rout_out);
	-- SUM:		regN generic map(2*M) port map(CLK, RST, loadSUM, sum_in, sum_out);
	-- INT_CNT:	regN generic map(M) port map(CLK, RST, loadINC, inc_cnt_in, inc_cnt_out);
	-- BM_SHIFT:	regN generic map(
	
		-- -- MUXS
	-- MUX_OPR:	mux2N generic map(2*M) port map(selOPR, "00000000", shift_opr_out, opr_in);
	-- MUX_ACC_BM:  mux2N generic map(2*M) port map(selACC, "00000000", shift_acc_out, accbm_in);
	-- MUX_TEMP_BM: mux2N generic map(2*Q) port map(selTEMP_BM, "0000", 
	
		-- -- SHIFTERS
	-- SHIFT_OPR:	leftshiftN generic map(2*M,Q) port map(opr_out, shift_opr_out);
	-- SHIFT_OPB:	righshiftN generic map(M,Q)   port map(
	
		-- -- ADDERS
	-- SUM_BM:		adderN generic map(2*M) port map(opr_out, accbm_out, sum_out);
	-- SUMPRODUCT: adderN generic map(2*M) port map(...);
	
	-- INC_INT_CNT:	adderN generic map(M)	port map(int_out, "0001", add_cnt_out);
	-- INC_BM_SHIFT:	adder2 generic map(M)	port map(int_out, "0001", add_cnt_out);
	
		-- -- MULTIPLIERS
	-- PRODUCT:	BasicMultiplier	port map(opa_out, opb_out, opr_in(M-1,0));
end struct;