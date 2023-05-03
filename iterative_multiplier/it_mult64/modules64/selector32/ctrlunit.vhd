
-- ctrlunit.vhd

-- for multilplier select


----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package selector32_ctrlunit_package is
	component selector32_ctrlunit is
		generic(
			N	: integer := 32;
			K	: integer := 7;
			REF	: integer := 64;
			M	: integer := 4
			);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- control signal to/from extern
			DATAIN:			in std_logic;	-- new data to manipulate
			ADV_AM:			in std_logic_vector (1 downto 0);	-- new 4bits of A
			NW_PRD:			out std_logic;
			DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
			READY:			out std_logic;	-- m_sel can accept new data input
				-- control signal to datapath
			selAM:			out std_logic_vector (1 downto 0);
			selBM:			out std_logic_vector (1 downto 0);
			selINC_M:		out std_logic;
			selA_BM:		out std_logic;
			selB_BM:		out std_logic;
			selINT_A:		out std_logic;
			selINT_B:		out std_logic;
						
			loadAM:			out std_logic;
			loadBM:			out std_logic;
			loadINC_M:		out std_logic;
			loadA_BM:		out std_logic;
			loadB_BM:		out std_logic;
			loadINT_A:		out std_logic;
			loadINT_B:		out std_logic;
				-- status signals from datapath
			INC_M:			in std_logic_vector(K-1 downto 0)
		);
	end component;
end selector32_ctrlunit_package;
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	-- interface
entity selector32_ctrlunit is
	generic(
		N	: integer := 32;
		K	: integer := 7;
		REF	: integer := 64;
		M	: integer := 4
		);
	port(
		CLK:			in std_logic;
		RST:			in std_logic;
			-- control signal to/from extern
		DATAIN:			in std_logic;	-- new data to manipulate
		ADV_AM:			in std_logic_vector (1 downto 0);	-- new 4bits of A
		NW_PRD:			out std_logic;
		DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
		READY:			out std_logic;	-- m_sel can accept new data input
			-- control signal to datapath
		selAM:			out std_logic_vector (1 downto 0);
		selBM:			out std_logic_vector (1 downto 0);
		selINC_M:		out std_logic;
		selA_BM:		out std_logic;
		selB_BM:		out std_logic;
		selINT_A:		out std_logic;
		selINT_B:		out std_logic;
					
		loadAM:			out std_logic;
		loadBM:			out std_logic;
		loadINC_M:		out std_logic;
		loadA_BM:		out std_logic;
		loadB_BM:		out std_logic;
		loadINT_A:		out std_logic;
		loadINT_B:		out std_logic;
			-- status signals from datapath
		INC_M:			in std_logic_vector(K-1 downto 0)
	);
end entity;


architecture behavior of selector32_ctrlunit is


	type statetype is (INIT, LOAD_INTERNALS, SAVE_OPS, SHIFT_AM, NEW_PRODUCT,
						INC, SAVE_OPS_BM, OUTDATA_BM, WAITSELS);
	signal state, nextstate : statetype;
	
	begin
		-- FSM
			state <= INIT when RST='1' else
				nextstate when rising_edge(CLK);
				
	process(state, DATAIN, ADV_AM, INC_M)
	begin
		case state is
			when INIT =>
				if DATAIN = '0' then
					nextstate <= INIT;
				else
					nextstate <= LOAD_INTERNALS;
				end if;
			when LOAD_INTERNALS =>
				nextstate <= SAVE_OPS;
			when SAVE_OPS =>
				nextstate <= INC;
			when INC =>
				nextstate <= SAVE_OPS_BM;
			when SAVE_OPS_BM =>
				nextstate <= OUTDATA_BM;
			when OUTDATA_BM =>
				if INC_M = std_logic_vector(to_unsigned(REF, K)) then	-- b1000000 = 64
					nextstate <= INIT;
				else
					nextstate <= WAITSELS;
				end if;
			when WAITSELS =>
				if ADV_AM = "01" then		
					nextstate <= SHIFT_AM;
				elsif ADV_AM = "00" then										
					nextstate <= NEW_PRODUCT;
				else
					nextstate <= WAITSELS;
				end if;
			when SHIFT_AM =>
				nextstate <= INC;
			when NEW_PRODUCT =>
				nextstate <= INC;
			when others =>
				nextstate <= INIT;
		end case;
	end process;
	
		-- OUTPUTS
		loadAM		<=  '1'  when state=SAVE_OPS or 
							 state=NEW_PRODUCT or 
							 state=SHIFT_AM else
						'0';
		selAM		<=  "00"  when state=SAVE_OPS or
							 state=NEW_PRODUCT else
						"01"  when state=SHIFT_AM else
						"10";
						
		loadBM		<=  '1'  when state=SAVE_OPS or 
							 state=NEW_PRODUCT else
						'0';
		selBM		<=  "00"  when state=SAVE_OPS else
						"01"  when state=NEW_PRODUCT else
						"10";
		
		loadINC_M	<=	'1'  when state=INIT or
							 state=INC else
						'0';
		selINC_M	<=  '1'  when state=INC else
						'0';
						
		loadA_BM	<=	'1'  when state=SAVE_OPS_BM else
						'0';
		selA_BM		<=	'1'  when state=SAVE_OPS_BM else
						'0';
						
		loadB_BM	<=	'1'  when state=SAVE_OPS_BM else
						'0';
		selB_BM		<=	'1'  when state=SAVE_OPS_BM else
						'0';
						
		loadINT_A	<=	'1'  when state=LOAD_INTERNALS else
						'0';
		selINT_A	<=	'1'  when state=LOAD_INTERNALS else
						'0';
						
		loadINT_B	<=	'1'  when state=LOAD_INTERNALS else
						'0';
		selINT_B	<=	'1'  when state=LOAD_INTERNALS else
						'0';
						
						
		NW_PRD		<=	'1'  when state=SHIFT_AM or
							 state=NEW_PRODUCT else
						'0';
		DATAOUT		<=  '1'	 when state=OUTDATA_BM else
						'0';
		READY		<=  '1'	 when state=INIT else
						'0';
end behavior;
				