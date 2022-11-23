


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
			RA_BM, RB_BM:		in std_logic_vector(M-1 downto 0);
				-- data outputs
			ROUT_BM:			out std_logic_vector(2*M-1 downto 0);
				-- control singals to datapath
			selOPA:				in std_logic;
			selOPB:				in std_logic;
			selRA_BM:			in std_logic;
			selRB_BM:			in std_logic;
			selTEMP_BM:			in std_logic;
			selOPR:				in std_logic_vector(Q-1 downto 0);
			selACC_BM:			in std_logic_vector(Q-1 downto 0);
			selSUM:				in std_logic;
			selINC_CNT:			in std_logic;
			selADV_BM:			in std_logic;
			selRPM:				in std_logic;
			
			loadOPA:			in std_logic;
			loadOPB:			in std_logic;
			loadRB_BM:			in std_logic;
			loadTEMP_BM:		in std_logic;
			loadOPR:			in std_logic;
			loadACC_BM:			in std_logic;
			loadSUM:			in std_logic;
			loadINC_CNT:		in std_logic;
			loadADV_BM:			in std_logic;
			loadOUT:			in std_logic;
			loadRPM:			in std_logic;
				-- status signals from datapath
			INT_CNT:			out std_logic_vector(Q downto 0);
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
		RA_BM, RB_BM:		in std_logic_vector(M-1 downto 0);
			-- data outputs
		ROUT_BM:			out std_logic_vector(2*M-1 downto 0);
			-- control signals to datapath
		selOPA:				in std_logic;
		selOPB:				in std_logic;
		selRA_BM:			in std_logic;
		selRB_BM:			in std_logic;
		selTEMP_BM:			in std_logic;
		selOPR:				in std_logic_vector(Q-1 downto 0);
		selACC_BM:			in std_logic_vector(Q-1 downto 0);
		selSUM:				in std_logic;
		selINC_CNT:			in std_logic;
		selADV_BM:			in std_logic;
		selRPM:				in std_logic;
		
		loadOPA:			in std_logic;
		loadOPB:			in std_logic;
		loadRA_BM:			in std_logic;
		loadRB_BM:			in std_logic;
		loadTEMP_BM:		in std_logic;
		loadOPR:			in std_logic;
		loadACC_BM:			in std_logic;
		loadSUM:			in std_logic;
		loadINC_CNT:		in std_logic;
		loadADV_BM:			in std_logic;
		loadOUT:			in std_logic;
		loadRPM:			in std_logic;
			-- status signals from datapath
		INT_CNT:			out std_logic_vector(Q downto 0);
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
	
	signal inc_cnt_in, inc_cnt_out: 	std_logic_vector(Q downto 0);
	
	signal temp_bm_in, temp_bm_out: 	std_logic_vector(M-1 downto 0);
	signal ra_bm_in, ra_bm_out:			std_logic_vector(M-1 downto 0);
	signal rb_bm_in, rb_bm_out:			std_logic_vector(M-1 downto 0);
	signal shift_rb_bm:					std_logic_vector(M-1 downto 0);
	signal shift_temp_bm_out:			std_logic_vector(M-1 downto 0);
	
	signal accbm_in, accbm_out:			std_logic_vector(2*M-1 downto 0);
	signal rout_in, rout_out:			std_logic_vector(2*M-1 downto 0);
	signal opr_in, opr_out:				std_logic_vector(2*M-1 downto 0);
	
	signal add_opr_out:					std_logic_vector(2*M downto 0);
	signal add_subproduct_out:			std_logic_vector(2*M downto 0);
	signal shift_opr:					std_logic_vector(2*M downto 0);
	signal r_out_bm:					std_logic_vector(2*M downto 0);
	signal shift_acc_bm_out:			std_logic_vector(2*M downto 0);
	signal sum_bm_in, sum_bm_out:		std_logic_vector(2*M downto 0);
	signal rpm_in, rpm_out:				std_logic_vector(2*M downto 0);
	
		-- internal signals
	signal shift_rb_bm_Int:				std_logic_vector(Q-1 downto 0);
	signal rb_bm_out_Int:				std_logic_vector(Q-1 downto 0);
	signal shift_temp_bm_out_Int:		std_logic_vector(Q-1 downto 0);
	signal temp_bm_out_Int:				std_logic_vector(Q-1 downto 0);
	signal one_inc_vector:				std_logic_vector(Q downto 0);
	
	begin
		-- REGISTERS
	REG_ADV:		reg port map(CLK, RST, loadADV_BM, adv_in, adv_out);
	
	REG_OPA:		regN generic map(Q) port map(CLK, RST, loadOPA, opa_in, opa_out);
	REG_OPB:		regN generic map(Q) port map(CLK, RST, loadOPB, opb_in, opb_out);	
	
	REG_INC_CNT:	regN generic map(Q+1) port map(CLK, RST, loadINC_CNT, inc_cnt_in, inc_cnt_out);
	
	REG_RA_BM:		regN generic map(M) port map(CLK, RST, loadRA_BM, ra_bm_in, ra_bm_out);
	REG_RB_BM:		regN generic map(M) port map(CLK, RST, loadRB_BM, rb_bm_in, rb_bm_out);
	REG_TEMP_BM:	regN generic map(M) port map(CLK, RST, loadTEMP_BM, temp_bm_in, temp_bm_out);
	
	REG_SUM:		regN generic map(2*M) port map(CLK, RST, loadSUM, sum_bm_in, sum_bm_out);
	REG_ACC_BM:		regN generic map(2*M) port map(CLK, RST, loadACC_BM, accbm_in, accbm_out);
	REG_OPR:		regN generic map(2*M) port map(CLK, RST, loadOPR, opr_in, opr_out);
	REG_PM:			regN generic map(2*M) port map(CLK, RST, loadRPM, rpm_in, rpm_out);
	REG_OUT_BM:		regN generic map(2*M) port map(CLK, RST, loadOUT, add_subproduct_out, r_out_bm);
	
		-- MUXS
	MUX_SHIFT_BM:	mux port map(selADV_BM, '0', notport_out, adv_in);		
	
	MUX_OPA:		mux2N generic map(Q) port map(selOPA, (others=>'0'), opa_out, opa_in);				
	MUX_OPB:		mux2N generic map(Q) port map(selOPB, (others=>'0'), opb_out, opb_in);				
	MUX_INC_CNT:	mux2N generic map(Q) port map(selINC_CNT, (others=>'0'), inc_cnt_out, inc_cnt_in); 	
	MUX_RA_BM:		mux2N generic map(M) port map(selRA_BM, (others=>'0'), ra_bm_out, temp_bm_in);		
	MUX_RB_BM:		mux2N generic map(Q) port map(selRB_BM, shift_rb_bm_Int, rb_bm_out_Int, opb_in);	
	MUX_TEMP_BM:	mux2N generic map(Q) port map(selTEMP_BM, shift_temp_bm_out_Int, temp_bm_out_Int, opa_in);
	
	MUX_RPM:		mux2N generic map(2*M) port map(selRPM, (others=>'0'), rpm_out, rpm_in);		
	MUX_SUM:		mux2N generic map(2*M) port map(selSUM, (others=>'0'), sum_bm_out, sum_bm_in); 
	MUX_OPR:		mux4N generic map(2*M) port map(selOPR, (others=>'0'), shift_opr, opr_out, (others=>'0'), opr_in);
	MUX_ACC_BM: 	mux4N generic map(2*M) port map(selACC_BM, (others=>'0'), shift_acc_bm_out, accbm_out, (others=>'0'), accbm_in);
	
		-- ADDERS
	-- needed to increment INC_CNT
	ADD_INC_CNT:	adderNotCOut port map(inc_cnt_in, one_inc_vector, inc_cnt_out);		
	-- SUM_BUM = ACC_BM + OPR	
	ADD_OPR:		adderNotCOut generic map(2*M) port map(opr_out, accbm_out, add_opr_out);		
	-- ROUT = RPM + ACC
	ADD_SUBPRD:		adderNotCOut generic map(2*M) port map(rpm_out, accbm_out, add_subproduct_out);	
	
		-- LOGIC PORTS
	NOTPORT1:		notport port map(adv_in, notport_out);
	
		-- SHIFTERS
	SHIFT1_RB_BM:	leftshiftN generic map(M,Q) port map(rb_bm_in, shift_rb_bm);
	SHIFT2_OPR:		leftshiftN generic map(2*M,Q) port map(opr_out, shift_opr);
	SHIFT3_TEMP_BM:	leftshiftN generic map(M,Q) port map(temp_bm_out, shift_temp_bm_out);
	SHIFT_ACC_BM:	leftshiftN generic map(2*M,Q) port map(accbm_out, shift_acc_bm_out);
	
		-- PRODUCT
	PRODUCT:	BasicMultiplier port map(opa_out, opb_out, opr_out(M-1 downto 0));
	
		-- status signals
	ADV_BM 	<= adv_out;
	INT_CNT <= inc_cnt_out;
	
		-- data output
	ROUT_BM <= add_subproduct_out;
	
		-- internal signals management
	shift_rb_bm_Int <= shift_rb_bm(Q-1 downto 0);
	rb_bm_out_Int <= rb_bm_out(Q-1 downto 0);
	shift_temp_bm_out_Int <= shift_temp_bm_out(Q-1 downto 0);
	temp_bm_out_Int <= temp_bm_out(Q-1 downto 0);
	one_inc_vector <= "001";

end struct;