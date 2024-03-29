
-- datapath.vhd

-- for multilplier resolver module

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package resolver_datapath_package is
	component resolver_datapath is
		generic(
			N		: integer := 16;
			DIM_CNT	: integer := 3;
			M		: integer := 8;
			P		: integer := 4
			);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- data inputs
			OUT_BM:			in std_logic_vector(M-1 downto 0);
				-- data outputs
			RESULT:			out std_logic_vector(2*N-1 downto 0);
				-- control signal to datapath
			loadNSHIFT:		in std_logic;
			selNSHIFT:		in std_logic;
			loadPSHIFT:		in std_logic;
			selPSHIFT:		in std_logic;
			loadOUTBM:		in std_logic;
			selOUTBM:		in std_logic;
			loadINT:		in std_logic;
			selINT:			in std_logic;
			loadINT2:		in std_logic;
			selINT2:		in std_logic;
			loadS1:			in std_logic;
			selS1:			in std_logic;
			loadRS:			in std_logic;
			selRS:			in std_logic_vector(1 downto 0);
			loadS2:			in std_logic;
			selS2:			in std_logic;
			selOPT1:		in std_logic;
			selOPT2:		in std_logic;
			loadACCR:		in std_logic;
			selACCR:		in std_logic_vector(1 downto 0);
			loadRESULT:		in std_logic;
			selRESULT:		in std_logic;
				-- status signals from datapath
			P_SHIFT:		out std_logic_vector(DIM_CNT-1 downto 0);
			N_SHIFT:		out std_logic_vector(DIM_CNT-1 downto 0)
		);
	end component;
end resolver_datapath_package;
----------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.resolver_components_package.all;

	-- interface
entity resolver_datapath is
	generic(
		N		: integer := 16;
		DIM_CNT	: integer := 3;
		M		: integer := 8;
		P		: integer := 4
		);
	port(
		CLK:			in std_logic;
		RST:			in std_logic;
			-- data inputs
		OUT_BM:			in std_logic_vector(M-1 downto 0);
		RESULT:			out std_logic_vector(2*N-1 downto 0);
			-- control signal to datapath
		loadNSHIFT:		in std_logic;
		selNSHIFT:		in std_logic;
		loadPSHIFT:		in std_logic;
		selPSHIFT:		in std_logic;
		loadOUTBM:		in std_logic;
		selOUTBM:		in std_logic;
		loadINT:		in std_logic;
		selINT:			in std_logic;
		loadINT2:		in std_logic;
		selINT2:		in std_logic;
		loadS1:			in std_logic;
		selS1:			in std_logic;
		loadRS:			in std_logic;
		selRS:			in std_logic_vector(1 downto 0);
		selS2:			in std_logic;
		loadS2:			in std_logic;
		selOPT1:		in std_logic;
		selOPT2:		in std_logic;
		loadACCR:		in std_logic;
		selACCR:		in std_logic_vector(1 downto 0);
		loadRESULT:		in std_logic;
		selRESULT:		in std_logic;
			-- status signals from datapath
		P_SHIFT:		out std_logic_vector(DIM_CNT-1 downto 0);
		N_SHIFT:		out std_logic_vector(DIM_CNT-1 downto 0)
	);
end entity;


architecture struct of resolver_datapath is

	-- signals
	
	signal pshift_in, pshift_out, p_out:	std_logic_vector(DIM_CNT-1 downto 0);
	signal nshift_in, nshift_out, n_out:	std_logic_vector(DIM_CNT-1 downto 0);
	
	signal bm_in, bm_out:					std_logic_vector(M-1 downto 0);
		
	signal rs_in, rs_out:					std_logic_vector(2*N-1 downto 0);
	signal s1_in, s1_out:					std_logic_vector(2*N-1 downto 0) := (others=>'0');
	signal s2_in, s2_out:					std_logic_vector(2*N-1 downto 0) := (others=>'0');
	signal accr_in, accr_out:				std_logic_vector(2*N-1 downto 0) := (others=>'0');
	signal result_in, result_out:			std_logic_vector(2*N-1 downto 0);
	signal int_in, int_out:					std_logic_vector(2*N-1 downto 0);
	signal int2_in, int2_out:				std_logic_vector(2*N-1 downto 0);
	
	signal adder1_out:						std_logic_vector(M-1 downto 0)  := (others=>'0');
	signal adder2_out:						std_logic_vector(N+P-1 downto 0):= (others=>'0');
	signal shift_rs:						std_logic_vector(2*N-1 downto 0);
	signal shift_accr:						std_logic_vector(2*N-1 downto 0);
	
	constant zeros8:						std_logic_vector(M-1 downto 0)  := (others=>'0');
	constant zerosMP:						std_logic_vector(N-P-1 downto 0):= (others=>'0');
	constant zerosNP:						std_logic_vector(N+P-1 downto 0):= (others=>'0');
	constant zerosMN:						std_logic_vector(2*N-M-1 downto 0):= (others=>'0');
	constant zeros2N:						std_logic_vector(2*N-1 downto 0):= (others=>'0');
	constant nulls2N:						std_logic_vector(2*N-1 downto 0):= (others=>'-');
	
	constant zero:							std_logic_vector(DIM_CNT-1 downto 0)  := std_logic_vector(to_unsigned(0, DIM_CNT));
	constant one:							std_logic_vector(DIM_CNT-1 downto 0)  := std_logic_vector(to_unsigned(1, DIM_CNT));
	
	
				
	begin
		-- REGISTERS
	REG_P:		regN generic map(DIM_CNT) port map(CLK, RST, loadPSHIFT, pshift_in, pshift_out);
	REG_N:		regN generic map(DIM_CNT) port map(CLK, RST, loadNSHIFT, nshift_in, nshift_out);
	
	REG_BM:		regN generic map(M) port map(CLK, RST, loadOUTBM, bm_in, bm_out);
	
	REG_RS:		regN generic map(2*N) port map(CLK, RST, loadRS, rs_in, rs_out);
	REG_S1:		regN generic map(2*N) port map(CLK, RST, loadS1, s1_in, s1_out);
	REG_S2:		regN generic map(2*N) port map(CLK, RST, loadS2, s2_in, s2_out);
	REG_ACCR:	regN generic map(2*N) port map(CLK, RST, loadACCR, accr_in, accr_out);
	REG_RES:	regN generic map(2*N) port map(CLK, RST, loadRESULT, result_in, result_out);
	REG_INT:	regN generic map(2*N) port map(CLK, RST, loadINT, int_in, int_out);
	REG_INT2:	regN generic map(2*N) port map(CLK, RST, loadINT2, int2_in, int2_out);
	
		-- MUXS
	MUX_P:		mux2N generic map(DIM_CNT) port map(selPSHIFT, zero, p_out, pshift_in);
	MUX_N:		mux2N generic map(DIM_CNT) port map(selNSHIFT, zero, n_out, nshift_in);
	MUX_BM:		mux2N generic map(M) port map(selOUTBM, bm_out, OUT_BM, bm_in);
	
	MUX_S1:		mux2N generic map(M) port map(selS1, adder1_out, zeros8, s1_in(2*N-1 downto 2*N-M));
	MUX_S2:		mux2N generic map(N+P) port map(selS2, adder2_out, zerosNP, s2_in(2*N-1 downto N-P));
	MUX_OPT1:	mux2N generic map(2*N-M) port map(selOPT1, zerosMN, int_out(2*N-M-1 downto 0), s1_in(2*N-M-1 downto 0));
	MUX_OPT2:	mux2N generic map(N-P) port map(selOPT2, zerosMP, accr_out(N-P-1 downto 0), s2_in(N-P-1 downto 0));
	MUX_ACCR:	mux4N generic map(2*N) port map(selACCR, shift_accr, s2_out, zeros2N, nulls2N, accr_in);
	MUX_RESULT:	mux2N generic map(2*N) port map(selRESULT, zeros2N, accr_out, result_in);
	MUX_RS:		mux4N generic map(2*N) port map(selRS, zeros2N, shift_rs, s1_out, rs_out, rs_in);
	MUX_INT:	mux2N generic map(2*N) port map(selINT, zeros2N, rs_out, int_in);
	MUX_INT2:	mux2N generic map(2*N) port map(selINT2, zeros2N, rs_out, int2_in);
	
		-- ADDERS
	--8 bit: S1 = BM + INT(2N-1,2N-M)
	ADDER1:		adderN generic map(M) port map(bm_out, int_out(2*N-1 downto 2*N-M), adder1_out);
	--20 bit: S2 = ACCR(2N-1,N-P) + INT2(2N-1,N-P)
	ADDER2:		adderN generic map(N+P) port map(accr_out(2*N-1 downto N-P), int2_out(2*N-1 downto N-P), adder2_out);
	
	-- increment PSHIFT and NSHIFT
	INC_P:		adderN generic map(DIM_CNT) port map(pshift_out, one, p_out);
	INC_N:		adderN generic map(DIM_CNT) port map(nshift_out, one, n_out);
	
		-- SHIFTERS
	SHIFTER1:	rightshiftN generic map(2*N,P) port map(rs_out, shift_rs);
	SHIFTER2:	rightshiftN generic map(2*N,P) port map(accr_out, shift_accr);
	
		-- status signals
	P_SHIFT <= pshift_out;
	N_SHIFT <= nshift_out;
	
		-- data outputs
	RESULT <= result_out;
end struct;