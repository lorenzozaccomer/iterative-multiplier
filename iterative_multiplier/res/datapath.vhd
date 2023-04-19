
-- datapath.vhd

-- for multilplier resolver module

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package res_datapath_package is
	component res_datapath is
		generic(
			N	: integer := 16;
			M	: integer := 8;
			P	: integer := 4
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
			loadBM:			in std_logic;
			selINT:			in std_logic;
			loadS1:			in std_logic;
			selS1:			in std_logic;
			loadRS:			in std_logic;
			selRS:			in std_logic_vector(1 downto 0);
			loadS2:			in std_logic;
			selS2:			in std_logic;
			loadACCR:		in std_logic;
			selACCR:		in std_logic;
			loadRES:		in std_logic;
			selRES:			in std_logic;
				-- status signals from datapath
			P_SHIFT:		out std_logic_vector(1 downto 0);
			N_SHIFT:		out std_logic_vector(1 downto 0)
		);
	end component;
end res_datapath_package;
----------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.res_components_package.all;

	-- interface
entity res_datapath is
	generic(
		N	: integer := 16;
		M	: integer := 8;
		P	: integer := 4
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
		loadBM:			in std_logic; -- da togliere
		selINT:			in std_logic; -- da togliere
		loadS1:			in std_logic;
		selS1:			in std_logic;
		loadRS:			in std_logic;
		selRS:			in std_logic_vector(1 downto 0);
		loadS2:			in std_logic;
		selS2:			in std_logic;
		loadACCR:		in std_logic;
		selACCR:		in std_logic;
		loadRES:		in std_logic;
		selRES:			in std_logic;
			-- status signals from datapath
		P_SHIFT:		out std_logic_vector(1 downto 0);
		N_SHIFT:		out std_logic_vector(1 downto 0)
	);
end entity;


architecture struct of res_datapath is

	-- signals
	
	signal pshift_in, pshift_out, p_out:	std_logic_vector(1 downto 0);
	signal nshift_in, nshift_out, n_out:	std_logic_vector(1 downto 0);
	
	-- signal out_bm_in, out_bm_out:			std_logic_vector(M-1 downto 0); -- da togliere
	signal bm_in, bm_out:					std_logic_vector(M-1 downto 0);
		
	signal rs_in, rs_out:					std_logic_vector(2*N-1 downto 0);
	signal s1_in, s1_out:					std_logic_vector(2*N-1 downto 0);
	signal s2_in, s2_out:					std_logic_vector(2*N-1 downto 0);
	signal accr_in, accr_out:				std_logic_vector(2*N-1 downto 0);
	signal res_in, res_out:					std_logic_vector(2*N-1 downto 0);
	
	signal adder1_out:						std_logic_vector(2*N-1 downto 0) := (others=>'0');
	signal adder2_out:						std_logic_vector(2*N-1 downto 0);
	signal shift_rs:						std_logic_vector(2*N-1 downto 0);
	signal shift_accr:						std_logic_vector(2*N-1 downto 0);
	
	signal zeros32:						std_logic_vector(2*N-1 downto 0):= (others=>'0');
	
	
				
	begin
		-- REGISTERS
	REG_P:		regN generic map(2) port map(CLK, RST, loadPSHIFT, pshift_in, pshift_out);
	REG_N:		regN generic map(2) port map(CLK, RST, loadNSHIFT, nshift_in, nshift_out);
	
	REG_BM:		regN generic map(M) port map(CLK, RST, loadOUTBM, bm_in, bm_out);
	
	REG_RS:		regN generic map(2*N) port map(CLK, RST, loadRS, rs_in, rs_out);
	REG_S1:		regN generic map(2*N) port map(CLK, RST, loadS1, s1_in, s1_out);
	REG_S2:		regN generic map(2*N) port map(CLK, RST, loadS2, s2_in, s2_out);
	REG_ACCR:	regN generic map(2*N) port map(CLK, RST, loadACCR, accr_in, accr_out);
	REG_RES:	regN generic map(2*N) port map(CLK, RST, loadRES, res_in, res_out);
	
		-- MUXS
	MUX_P:		mux2N generic map(2) port map(selPSHIFT, "00", p_out, pshift_in);
	MUX_N:		mux2N generic map(2) port map(selNSHIFT, "00", n_out, nshift_in);
	MUX_BM:		mux2N generic map(M) port map(selOUTBM, OUT_BM, bm_out, bm_in);
	
	MUX_S1:		mux2N generic map(2*N) port map(selS1, adder1_out, s1_out, s1_in);
	MUX_S2:		mux2N generic map(2*N) port map(selS2, adder2_out, s2_out, s2_in);
	MUX_ACCR:	mux2N generic map(2*N) port map(selACCR, accr_out, s2_out, accr_in);
	MUX_RES:	mux2N generic map(2*N) port map(selRES, accr_out, res_out, res_in);
	MUX_RS:		mux4N generic map(2*N) port map(selRS, zeros32, shift_rs, s1_out, rs_out, rs_in);
	
		-- ADDERS
	ADDER1:		adderNotCout generic map(M) port map(bm_out, rs_out(2*N-1 downto M+N), adder1_out(2*N-1 downto M+N));
	ADDER2:		adderNotCout generic map(2*N) port map(accr_out, rs_out, adder2_out);
	
	-- increment PSHIFT and NSHIFT
	INC_P:		adderNotCout generic map(2) port map(pshift_out, "01", p_out);
	INC_N:		adderNotCout generic map(2) port map(nshift_out, "01", n_out);
	
		-- SHIFTERS
	SHIFTER1:	rightshiftN generic map(2*N,P) port map(rs_out, shift_rs);
	SHIFTER2:	rightshiftN generic map(2*N,P) port map(accr_out, shift_accr);
	
		-- status signals
	P_SHIFT <= pshift_out;
	N_SHIFT <= nshift_out;
	
		-- data outputs
	RESULT <= res_out;
end struct;