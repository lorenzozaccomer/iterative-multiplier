
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
	signal out_bm_in, out_bm_out:			std_logic_vector(M-1 downto 0);
	signal bm_in, bm_out:					std_logic_vector(M-1 downto 0);
	
	signal p_shift_in, p_shift_out:			std_logic_vector(M downto 0);
	signal n_shift_in, n_shift_out:			std_logic_vector(M downto 0);
	
	signal rs_in, rs_out:					std_logic_vector(N+P-1 downto 0);
	signal s1_in, s1_out:					std_logic_vector(N+P-1 downto 0);
	signal adder1_out:						std_logic_vector(N+P-1 downto 0);
	
	
	signal zeros20:						std_logic_vector(N+P-1 downto 0):= (others=>'0');
	
	
				
	begin
		-- REGISTERS
	REG_BM:		regN generic map(2*P-1) port map(CLK, RST, loadOUTBM, bm_in, bm_out);
	
	REG_RS:		regN generic map(N+P-1) port map(CLK, RST, loadRS, rs_in, rs_out);
	REG_S1:		regN generic map(N+P-1) port map(CLK, RST, loadS1, s1_in, s1_out);
	REG_S2:		regN generic map(N+P-1) port map(CLK, RST, loadS2, s2_in, s2_out);
	
		-- MUXS
	MUX_BM:		mux2N generic map(2*P-1) port map(selOUTBM, OUT_BM, bm_out, bm_in);
	MUX_RS:		mux4N generic map(2*P-1) port map(selRS, zeros20, shift_rs, rs_out, zeros20, rs_in);
	MUX_S1:		mux2N generic map(2*P-1) port map(selS1, xyz, s1_out, s1_in);
	MUX_S2:		mux2N generic map(2*P-1) port map(selS2, xyz, s2_out, s2_in);
	
		-- ADDERS
	-- ADDER1:		adderNotCout generic map(2*P-1) port map(bm_out, rs_out((2*P-1+P_SHIFT) downto P_SHIFT), adder1_out((2*P-1+P_SHIFT) downto P_SHIFT));
	
		-- SHIFTERS
	SHIFT1:		leftshiftN generic map(2*N,P) port map(rs_out, shift_rs);
	
end struct;