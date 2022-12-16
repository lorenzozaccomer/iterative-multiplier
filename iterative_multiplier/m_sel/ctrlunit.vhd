
-- ctrlunit.vhd

-- for multilplier select


----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package msel_ctrlunit_package is
	component msel_ctrlunit is
		generic(
			N	: integer := 16;
			M	: integer := 4
			);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- control signal to/from extern
			DATAIN:			in std_logic;	-- new data to manipulate
			ADV_AM:			in std_logic;
			NW_PRD:			in std_logic;
			DATAIN_BM:		out std_logic;	-- new data for bm_sel are ready to used it
			READY:			out std_logic;	-- m_sel can accept new data input
				-- control signal to datapath
			selAM:			out std_logic;
			selBM:			out std_logic;
			selINC_M:		out std_logic;
			selA_BM:		out std_logic;
			selB_BM:		out std_logic;
						
			loadAM:			out std_logic;
			loadBM:			out std_logic;
			loadINC_M:		out std_logic;
			loadA_BM:		out std_logic;
			loadB_BM:		out std_logic;
				-- status signals from datapath
			INC_M:			in std_logic_vector(M downto 0)
		);
	end component;
end msel_ctrlunit_package;
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	-- interface
entity msel_ctrlunit is
	generic(
		N	: integer := 16;
		M	: integer := 4
		);
	port(
		CLK:			in std_logic;
		RST:			in std_logic;
			-- control signal to/from extern
		DATAIN:			in std_logic;	-- new data to manipulate
		ADV_AM:			in std_logic;	-- new 4bits of A
		NW_PRD:			in std_logic;	-- shift B and restore A
		DATAIN_BM:		out std_logic;	-- new data for bm_sel are ready to used it
		READY:			out std_logic;	-- m_sel can accept new data input
			-- control signal to datapath
		selAM:			out std_logic;
		selBM:			out std_logic;
		selINC_M:		out std_logic;
		selA_BM:		out std_logic;
		selB_BM:		out std_logic;
					
		loadAM:			out std_logic;
		loadBM:			out std_logic;
		loadINC_M:		out std_logic;
		loadA_BM:		out std_logic;
		loadB_BM:		out std_logic;
			-- status signals from datapath
		INC_M:			in std_logic_vector(M downto 0)
	);
end entity;


architecture behavior of msel_ctrlunit is


	type statetype is (INIT_M, SAVE_OPS, WAIT_M, SHIFT_AM, NEW_PRODUCT,
						INC, SAVE_OPS_BM, OUTDATA_BM, WAITDATA);
	signal state, nextstate : statetype;
	
	begin
		-- FSM
			state <= INIT_M when RST='1' else
				nextstate when rising_edge(CLK);
				
	process(state, DATAIN, ADV_AM, NW_PRD)
	begin
		case state is
			when INIT_M =>
				if DATAIN /= '1' then
					nextstate <= INIT_M;
				else
					nextstate <= SAVE_OPS;
				end if;
			when SAVE_OPS =>
				nextstate <= WAIT_M;
			when WAIT_M =>
				if ADV_AM = '1' then
					nextstate <= SHIFT_AM;
				elsif NW_PRD = '1' then
					nextstate <= NEW_PRODUCT;
				else
					nextstate <= INC;
				end if;
			when SHIFT_AM =>
				nextstate <= INC;
			when NEW_PRODUCT =>
				nextstate <= INC;
			when INC =>
				nextstate <= SAVE_OPS_BM;
			when SAVE_OPS_BM =>
				nextstate <= OUTDATA_BM;
			when OUTDATA_BM =>
				nextstate <= WAITDATA;
			when WAITDATA =>
				if INC_M = "10000" then	-- b10000 = 16
					nextstate <= INIT_M;
				elsif ADV_AM = '1' then
					nextstate <= SHIFT_AM;
				elsif NW_PRD = '1' then
					nextstate <= NEW_PRODUCT;
				else
					nextstate <= WAITDATA;
				end if;
			when others =>
				nextstate <= INIT_M;
		end case;
	end process;
	
		-- OUTPUTS
		loadAM		<=  '1'  when state=SAVE_OPS or 
							 state=NEW_PRODUCT or 
							 state=SHIFT_AM else
						'0';
		selAM		<=  '0'  when state=SAVE_OPS or
							 state=NEW_PRODUCT else
						'1'  when state=SHIFT_AM;
						
		loadBM		<=  '1'  when state=SAVE_OPS or 
							 state=NEW_PRODUCT else
						'0';
		selBM		<=  '0'  when state=SAVE_OPS or 
							 state=NEW_PRODUCT else
						'1';
		
		loadINC_M	<=	'1'  when state=INIT_M or
							 state=INC else
						'0';
		selINC_M	<=  '0'  when state=INIT_M else
						'1'  when state=INC;
						
		loadA_BM	<=	'1'  when state=SAVE_OPS_BM else
						'0';
		selA_BM		<=	'1'  when state=SAVE_OPS_BM else
						'0';
						
		loadB_BM	<=	'1'  when state=SAVE_OPS_BM else
						'0';
		selB_BM		<=	'1'  when state=SAVE_OPS_BM else
						'0';
						
						
		DATAIN_BM	<=  '1'	 when state=OUTDATA_BM else
						'0';
						
		READY		<=  '1'	 when state=INIT_M else
						'0';
end behavior;
				