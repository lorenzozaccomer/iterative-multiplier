
-- datapath.vhd

-- for multilplier res module

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
			RES:			out std_logic_vector(2*N-1 downto 0);
				-- control signal to datapath
			loadNSHIFT:		in std_logic;
			selNSHIFT:		in std_logic;
			loadPSHIFT:		in std_logic;
			selPSHIFT:		in std_logic;
			loadOUTBM:		in std_logic;
			selOUTBM:		in std_logic;
			loadBM:			in std_logic;
			selBM:			in std_logic;
			loadS1:			in std_logic;
			selS1:			in std_logic;
			loadRS:			in std_logic;
			selRS:			in std_logic;
			loadS2:			in std_logic;
			selS2:			in std_logic;
			loadACCR:		in std_logic;
			selACCR:		in std_logic;
			loadRES:		in std_logic;
			selRES:			in std_logic;
				-- status signals from datapath
			P_SHIFT:		out std_logic_vector(P-1 downto 0);
			N_SHIFT:		out std_logic_vector(P downto 0)
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
		RES:			out std_logic_vector(2*N-1 downto 0);
			-- control signal to datapath
		loadNSHIFT:		in std_logic;
		selNSHIFT:		in std_logic;
		loadPSHIFT:		in std_logic;
		selPSHIFT:		in std_logic;
		loadOUTBM:		in std_logic;
		selOUTBM:		in std_logic;
		loadBM:			in std_logic;
		selBM:			in std_logic;
		loadS1:			in std_logic;
		selS1:			in std_logic;
		loadRS:			in std_logic;
		selRS:			in std_logic;
		loadS2:			in std_logic;
		selS2:			in std_logic;
		loadACCR:		in std_logic;
		selACCR:		in std_logic;
		loadRES:		in std_logic;
		selRES:			in std_logic;
			-- status signals from datapath
		P_SHIFT:		out std_logic_vector(P-1 downto 0);
		N_SHIFT:		out std_logic_vector(P downto 0)
	);
end entity;


architecture struct of res_datapath is

	-- signals
	
	signal pshift_in, pshift_out:			std_logic_vector(1 downto 0);
	signal adder2_out:						std_logic_vector(1 downto 0);
	
	signal nshift_in, nshift_out:			std_logic_vector(P downto 0);
	signal adder3_out:						std_logic_vector(P downto 0);
	
	signal out_bm_in, out_bm_out:			std_logic_vector(M-1 downto 0);
	signal bm_in, bm_out:					std_logic_vector(M-1 downto 0);
		
	signal rs_in, rs_out:					std_logic_vector(2*N-1 downto 0);
	signal s1_in, s1_out:					std_logic_vector(2*N-1 downto 0);
	signal a1_in, a1_out:					std_logic_vector(2*N-1 downto 0);
	signal s2_in, s2_out:					std_logic_vector(2*N-1 downto 0);
	signal a2_in, a2_out:					std_logic_vector(2*N-1 downto 0);
	signal adder1_out:						std_logic_vector(2*N-1 downto 0);
	signal shift_rs:						std_logic_vector(2*N-1 downto 0);
	
	
	signal zeros32:						std_logic_vector(2*N-1 downto 0):= (others=>'0');
	
	
				
	begin
		-- REGISTERS
	REG_P:		regN generic map(2*P-1) port map(CLK, RST, loadOUTBM, bm_in, bm_out);
	
	REG_BM:		regN generic map(2*P-1) port map(CLK, RST, loadOUTBM, bm_in, bm_out);
	
	REG_RS:		regN generic map(2*N-1) port map(CLK, RST, loadRS, rs_in, rs_out);
	REG_S1:		regN generic map(2*N-1) port map(CLK, RST, loadS1, s1_in, s1_out);
	REG_S2:		regN generic map(2*N-1) port map(CLK, RST, loadS2, s2_in, s2_out);
	
		-- MUXS
	MUX_P:		mux2N generic map(2) port map(selPSHIFT, "00", bm_out, pshift_in);
	
	MUX_N:		mux2N generic map(P) port map(selNSHIFT, "00000", bm_out, nshift_in);
	
	MUX_BM:		mux2N generic map(M-1) port map(selOUTBM, OUT_BM, bm_out, bm_in);
	
	MUX_RS:		mux2N generic map(2*N-1) port map(selRS, shift_rs, rs_out, rs_in);
	MUX_S1:		mux2N generic map(2*N-1) port map(selS1, zeros32, s1_out, s1_in);
	MUX_A1:		mux2N generic map(2*N-1) port map(selS2, zeros32, a1_out, a1_in);
	MUX_S2:		mux2N generic map(2*N-1) port map(selS2, zeros32, s2_out, s2_in);
	MUX_A2:		mux2N generic map(2*N-1) port map(selS2, zeros32, a2_out, a2_in);
	
		-- ADDERS
	ADDER1:		adderNotCout generic map(M-1) port map(bm_out, rs_out(2*N-1 downto M+N-1), adder1_out(2*N-1 downto M+N-1));
	
	INC_P:		adderNotCout generic map(2) port map(pshift_out, "01", adder2_out);
	INC_N:		adderNotCout generic map(P) port map(nshift_out, "00001", adder3_out);
	
		-- SHIFTERS
	SHIFT1:		leftshiftN generic map(2*N,P) port map(rs_out, shift_rs);
	
end struct;