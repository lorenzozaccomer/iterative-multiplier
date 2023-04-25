
-- datapath.vhd

-- for multilplier selector

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package selector_datapath_package is
	component selector_datapath is
		generic(
			N	: integer := 16;
			M	: integer := 4
			);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- data inputs
			A_M:			in std_logic_vector(N-1 downto 0);
			B_M:			in std_logic_vector(N-1 downto 0);
			A_BM:			out std_logic_vector(M-1 downto 0);
			B_BM:			out std_logic_vector(M-1 downto 0);
				-- control signal to datapath
			selAM:			in std_logic;
			selBM:			in std_logic;
			selINC_M:		in std_logic;
			selA_BM:		in std_logic;
			selB_BM:		in std_logic;
						
			loadAM:			in std_logic;
			loadBM:			in std_logic;
			loadINC_M:		in std_logic;
			loadA_BM:		in std_logic;
			loadB_BM:		in std_logic;
				-- status signals from datapath
			INC_M:			out std_logic_vector(M downto 0)
		);
	end component;
end selector_datapath_package;
----------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.selector_components_package.all;

	-- interface
entity selector_datapath is
	generic(
		N	: integer := 16;
		M	: integer := 4
		);
	port(
		CLK:			in std_logic;
		RST:			in std_logic;
			-- data inputs
		A_M:			in std_logic_vector(N-1 downto 0);
		B_M:			in std_logic_vector(N-1 downto 0);
		A_BM:			out std_logic_vector(M-1 downto 0);
		B_BM:			out std_logic_vector(M-1 downto 0);
			-- control signal to datapath
		selAM:			in std_logic;
		selBM:			in std_logic;
		selINC_M:		in std_logic;
		selA_BM:		in std_logic;
		selB_BM:		in std_logic;
					
		loadAM:			in std_logic;
		loadBM:			in std_logic;
		loadINC_M:		in std_logic;
		loadA_BM:		in std_logic;
		loadB_BM:		in std_logic;
			-- status signals from datapath
		INC_M:			out std_logic_vector(M downto 0)
	);
end entity;

architecture struct of selector_datapath is

	-- signals
	signal a_bm_in, a_bm_out:			std_logic_vector(M-1 downto 0);
	signal b_bm_in, b_bm_out:			std_logic_vector(M-1 downto 0);
		
	signal inc_m_in, inc_m_out:			std_logic_vector(M downto 0);
	signal add_inc_m_out:				std_logic_vector(M downto 0);
	
	signal shift_am, shift_bm:			std_logic_vector(N-1 downto 0);
	
	signal am_in, am_out:				std_logic_vector(N-1 downto 0);
	signal bm_in, bm_out:				std_logic_vector(N-1 downto 0);
	-- internal signals
	
	begin
		-- REGISTERS
	REG_A_BM:	regN generic map(M) port map(CLK, RST, loadA_BM, a_bm_in, a_bm_out);
	REG_B_BM:	regN generic map(M) port map(CLK, RST, loadB_BM, b_bm_in, b_bm_out);
	
	REG_INC_M:	regN generic map(M+1) port map(CLK, RST, loadINC_M, inc_m_in, inc_m_out);
	
	REG_AM:		regN generic map(N) port map(CLK, RST, loadAM, am_in, am_out);
	REG_BM:		regN generic map(N) port map(CLK, RST, loadBM, bm_in, bm_out);
			
		-- MUXS
	MUX_A_BM:	mux2N generic map(M) port map(selA_BM, a_bm_out, am_out(M-1 downto 0), a_bm_in);
	MUX_B_BM:	mux2N generic map(M) port map(selB_BM, b_bm_out, bm_out(M-1 downto 0), b_bm_in);
	
	MUX_INC_M:	mux2N generic map(M+1) port map(selINC_M, (others=>'0'), add_inc_m_out, inc_m_in);
	
	MUX_AM:		mux2N generic map(N) port map(selAM, A_M, shift_am, am_in);
	MUX_BM:		mux2N generic map(N) port map(selBM, B_M, shift_bm, bm_in);
		
		-- ADDERS
	ADD_INC_M:	adderNotCOut generic map(M+1) port map(inc_m_out, "00001", add_inc_m_out);
	
		-- SHIFTERS
	SH_AM:		rightshiftN generic map(N,M) port map(am_out, shift_am);
	SH_BM:		rightshiftN generic map(N,M) port map(bm_out, shift_bm);
	
		-- status signals
	INC_M <= inc_m_out;
	
		-- data outputs
	A_BM <= a_bm_out;
	B_BM <= b_bm_out;
		
end struct;
