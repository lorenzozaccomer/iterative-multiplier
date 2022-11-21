


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
		selSHIFT_BM:			out std_logic_vector(Q-1 downto 0);
		selR_PM:			out std_logic;
		
		loadOPA:			out std_logic;
		loadOPB:			out std_logic;
		loadRB_BM:			out std_logic;
		loadTEMP_BM:		out std_logic;
		loadOPR:			out std_logic;
		loadACC_BM:			out std_logic;
		loadSUM:			out std_logic;
		loadINC_CNT:		out std_logic;
		loadSHIFT_BM:			out std_logic;
		loadOUT:			out std_logic;
		loadR_PM:			out std_logic;
		OK:					out std_logic;
			-- status signals
		INT_CNT:			in std_logic_vector(Q downto 0);
		BM_SHIFT:			in std_logic							
		);
end datapath;

architecture struct of datapath is
	
		-- signals
	signal bm_shift_in, bm_shift_out: std_logic;
		
	signal opa_in, opa_out:		std_logic_vector(Q-1 downto 0);
	signal opb_in, opb_out:		std_logic_vector(Q-1 downto 0);
	
	signal inc_cnt_in, inc_cnt_out: 	std_logic_vector(Q downto 0);
	
	signal temp_bm_in, temp_bm_out: 	std_logic_vector(M-1 downto 0);
	signal rb_bm_in, rb_bm_out:			std_logic_vector(M-1 downto 0);
	signal shift_rb_bm:					std_logic_vector(M-1 downto 0);
	
	signal add_cnt_out:			std_logic_vector(M downto 0);
	
	signal accbm_in, accbm_out:	std_logic_vector(2*M-1 downto 0);
	signal rout_in, rout_out:	std_logic_vector(2*M-1 downto 0);
	signal opr_in, opr_out:		std_logic_vector(2*M-1 downto 0);
	
	signal adder1_out:				std_logic_vector(2*M downto 0);
	signal shift_opr:		std_logic_vector(2*M downto 0);
	
	begin
		-- REGISTERS
	BM_SHIFT:	regN generic map(Q) port map(CLK, RST, loadSHIFT_BM, bm_shift_in, bm_shift_out);
	
	OPA:		regN generic map(Q) port map(CLK, RST, loadOPA, opa_in, opa_out);
	OPB:		regN generic map(Q) port map(CLK, RST, loadOPB, opb_in, opb_out);	
	OPR:		regN generic map(2*M) port map(CLK, RST, loadOPR, opr_in, opr_out);
	RA_BM:		regN generic map(M) port map(CLK, RST, loadRA_BM, ra_bm_in, ra_bm_out);
	RB_BM:		regN generic map(M) port map(CLK, RST, loadRB_BM, rb_bm_in, rb_bm_out);
	TEMP_BM:	regN generic map(M) port map(CLK, RST, loadTEMP_BM, temp_bm_in, temp_bm_out);
	SUM:		regN generic map(2*M) port map(CLK, RST, loadSUM, sum_bm_in, sum_bm_out);
	ACC_BM:		regN generic map(2*M) port map(CLK, RST, loadACC_BM, accbm_in, accbm_out);
	INC_CNT:	regN generic map(M) port map(CLK, RST, loadINC_CNT, inc_cnt_in, inc_cnt_out);
	R_PM:		regN generic map(2*M) port map(CLK, RST, load_RPM, rpm_in, rpm_out);
	R_OUT_BM:	regN generic map(2*M) port map(CLK, RST, loadOUT, subproduct_out, r_out_bm);
	
		-- MUXS
	MUX1:	mux2N generic map(Q) port map(selOPA, (others=>'0'), opa_out, opa_in);					-- OPA
	MUX2:	mux2N generic map(Q) port map(selOPB, (others=>'0'), opb_out, opb_in);					-- OPB
	MUX3:	mux2N generic map(Q) port map(selINC_CNT, (others=>'0'), adder2_out, inc_cnt_in); 		-- INC_CNT
	MUX4:	mux2N generic map(M) port map(selRA_BM, (others=>'0'), ra_bm_out, ra_bm_in);			-- RA_BM
	MUX5:	mux2N generic map(M) port map(selRB_BM, shift_rb_bm, rb_bm_out(Q-1,0), rb_bm_in);		-- RB_BM
	MUX6:	mux2N generic map(M) port map(selTEMP_BM, shift_temp_bm, temp_bm_out(Q-1,0), opa_in);	-- TEMP_BM
	MUX7:	mux2N generic map(Q) port map(selSHIFT_BM, '0', notport_out, bm_shift_in);				-- SHIFT_BM
	
	MUX10:	mux2N generic map(2*M) port map(selR_PM, (others=>'0'), rpm_out, rpm_in);				-- RPM
	MUX11:	mux2N generic map(2*M) port map(selSUM, (others=>'0'), sum_bm_out, sum_bm_in); 			-- SELSUM
	MUX12:	mux4N generic map(2*M) port map(selOPR, shift_opr, opr_out, (others=>'0'), (others=>'0'), opr_in);				-- OPR
	MUX13: 	mux4N generic map(2*M) port map(selACC_BM, shift_acc_bm, accbm_out, (others=>'0'), (others=>'0'), accbm_in);	-- ACC_BM
	
		-- ADDERS
	ADDER1:		adderNotCOut port map(inc_cnt_out, "001", adder2_out);						-- INC_CNT
	ADDER2:		adderNotCOut generic map(2*M) port map(opr_out, accbm_out, adder1_out);		-- SUM_BUM = ACC_BM + OPR
	ADDER3;		adderNotCOut generic map(2*M) port map(rpm_out, accbm_out, subproduct_out);	-- ROUT = RPM + ACC
	
		-- LOGIC PORTS
	NOTPORT1:	notport port map(inc_cnt_out, notport_out);
	
		-- SHIFTERS
	SHIFT1:	leftshiftN generic map(M,Q) port map(rb_bm_in, shift_rb_bm);
	SHIFT2:	leftshiftN generic map(2*M,Q) port map(opr_out, shift_opr);
	SHIFT3:	leftshiftN generic map(M,Q) port map(temp_bm_out, shift_temp_bm);
	SHIFT4:	leftshiftN generic map(2*M,Q) port map(accbm_out, shift_acc_bm);
	
		-- PRODUCT
	PRODUCT:	BasicMultiplier port map(opa_out, opb_out, opr_in(M-1,0));
	
		-- status signals
	BM_SHIFT <= bm_shift_out;
	INT_CNT <= inc_cnt_out;
	
		-- data output
	ROUT_BM <= subproduct_out;

end struct;