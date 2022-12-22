
--- ctrlunit.vhd

--- for basic multiplier select
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package bmsel_ctrlunit_package is
	component bmsel_ctrlunit is
		generic(
			Q 	: integer := 2;
			M 	: integer := 4);
		port(
			CLK:				in std_logic;
			RST:				in std_logic;
				-- control signals to/from extern
			-- START:				in std_logic;	-- the module can go ahead
			DATAIN:				in std_logic;	-- will be equal to 1 when the module has the datas to process
			DATAOUT:			out std_logic;
			READY:				out std_logic;	-- the modules can do another operation
				-- control signals to datapath
			selOPA:				out std_logic;
			selOPB:				out std_logic;
			selA_BM:			out std_logic_vector(Q-1 downto 0);
			selB_BM:			out std_logic_vector(Q-1 downto 0);
			selOPR:				out std_logic_vector(Q-1 downto 0);
			selACC_BM:			out std_logic_vector(Q-1 downto 0);
			selSUM:				out std_logic;
			selINC_BM:			out std_logic;
			selADV_BM:			out std_logic;
			selRPM:				out std_logic;
			selOUT:				out std_logic;
			
			loadOPA:			out std_logic;
			loadOPB:			out std_logic;
			loadA_BM:			out std_logic;
			loadB_BM:			out std_logic;
			loadOPR:			out std_logic;
			loadACC_BM:			out std_logic;
			loadSUM:			out std_logic;
			loadINC_BM:			out std_logic;
			loadADV_BM:			out std_logic;
			loadOUT:			out std_logic;
			loadRPM:			out std_logic;
				-- status signals from datapath
			CNT_BM:				in std_logic_vector(Q downto 0);
			ADV_BM:				in std_logic				
			);
	end component;
end bmsel_ctrlunit_package;
----------------------------------------------------------------------

-- libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	-- interface
entity bmsel_ctrlunit is
	generic(
		Q 	: integer := 2;
		M 	: integer := 4);
	port(
		CLK:				in std_logic;
		RST:				in std_logic;
			-- control signals to/from extern
		-- START:				in std_logic;	-- the module can go ahead
		DATAIN:				in std_logic;	-- will be equal to 1 when the module has the datas to process
		DATAOUT:			out std_logic;
		READY:				out std_logic;	-- the modules can do another operation
			-- control signals to datapath
		selOPA:				out std_logic;
		selOPB:				out std_logic;
		selA_BM:			out std_logic_vector(Q-1 downto 0);
		selB_BM:			out std_logic_vector(Q-1 downto 0);
		selOPR:				out std_logic_vector(Q-1 downto 0);
		selACC_BM:			out std_logic_vector(Q-1 downto 0);
		selSUM:				out std_logic;
		selINC_BM:			out std_logic;
		selADV_BM:			out std_logic;
		selRPM:				out std_logic;
		selOUT:				out std_logic;
				
		loadOPA:			out std_logic;
		loadOPB:			out std_logic;
		loadA_BM:			out std_logic;
		loadB_BM:			out std_logic;
		loadOPR:			out std_logic;
		loadACC_BM:			out std_logic;
		loadSUM:			out std_logic;
		loadINC_BM:			out std_logic;
		loadADV_BM:			out std_logic;
		loadOUT:			out std_logic;
		loadRPM:			out std_logic;
			-- status signals from datapath
		CNT_BM:				in std_logic_vector(Q downto 0);
		ADV_BM:				in std_logic				
		);
end bmsel_ctrlunit;


architecture behavior of bmsel_ctrlunit is

	type statetype is (INIT_BM, LOAD_DATA, NEW_OPERAND_BM, RESET_BM, PRODUCT, SHIFT_PRODUCT, 
						SUM_BM, ACC_BM, INC_CNT, ADV, WAIT_BM, SHIFT_OPA, SHIFT_ACC, 
						NEW_OPA, SHIFT_RB_BM, NEW_PRODUCT_BM, SUBPRODUCT, OUTSTATE, WAITDATA);
	signal state, nextstate : statetype;
	
	begin
		-- FSM
			state <= INIT_BM when RST='1' else
				nextstate when rising_edge(CLK);
	process(state, DATAIN, ADV_BM, CNT_BM)
	begin
		case state is
			when INIT_BM =>
				if DATAIN /= '1' then
					nextstate <= INIT_BM;
				else
					nextstate <= LOAD_DATA;
				end if;
			when LOAD_DATA =>
				nextstate <= NEW_OPERAND_BM;
			when NEW_OPERAND_BM =>
				nextstate <= RESET_BM;
			when RESET_BM =>
				nextstate <= PRODUCT;
			when PRODUCT =>
				if ADV_BM = '0' then
					nextstate <= SUM_BM;
				else
					nextstate <= SHIFT_PRODUCT;
				end if;
			when SHIFT_PRODUCT =>
				nextstate <= SUM_BM;
			when SUM_BM =>
				nextstate <= ACC_BM;
			when ACC_BM =>
				nextstate <= INC_CNT;
			when INC_CNT =>
				nextstate <= ADV;
			when ADV =>
				if CNT_BM = "010" or CNT_BM = "100" then
					nextstate <= WAIT_BM;
				else
					nextstate <= SHIFT_OPA;
				end if;
			when SHIFT_OPA =>
				nextstate <= NEW_OPA;
			when NEW_OPA =>
				nextstate <= PRODUCT;
			when WAIT_BM =>
				if CNT_BM = "100" then
					nextstate <= SHIFT_ACC;
				else
					nextstate <= SHIFT_RB_BM;
				end if;
			when SHIFT_RB_BM =>
				nextstate <= NEW_PRODUCT_BM;
			when NEW_PRODUCT_BM =>
				nextstate <= NEW_OPERAND_BM;
			when SHIFT_ACC =>
				nextstate <= SUBPRODUCT;
			when SUBPRODUCT =>
				nextstate <= OUTSTATE;
			when OUTSTATE =>
					nextstate <= WAITDATA;
			when WAITDATA =>
				if DATAIN = '0' then
					nextstate <= WAITDATA;
				else
					nextstate <= LOAD_DATA;
				end if;
			when others =>
				nextstate <= INIT_BM;
		end case;
	end process;
	
		-- OUTPUTS
		loadOPA		<= 	'1'  when state=NEW_OPERAND_BM or
							 state=NEW_OPA else 
						'0';
		selOPA		<= 	'0'  when state=NEW_OPERAND_BM or 
							 state=NEW_OPA else
						'1';
		
		loadOPB 	<= 	'1'  when state=NEW_OPERAND_BM else 
						'0';
		selOPB		<= 	'0'  when state=NEW_OPERAND_BM else 
						'1';
		
		loadA_BM	<=	'1' when state=LOAD_DATA or 
							state=NEW_PRODUCT_BM or 
							state=SHIFT_OPA else
						'0';
		selA_BM		<=	"00" when state=LOAD_DATA or 
							 state=NEW_PRODUCT_BM else
						"01" when state=NEW_OPERAND_BM or 
							 state=NEW_OPA else 
						"10" when state=SHIFT_OPA else
						"11";
								
		loadB_BM	<= 	'1'  when state=LOAD_DATA or 
							 state=SHIFT_RB_BM or
							 state=WAITDATA else 
						'0';
		selB_BM	<= 		"00" when state=LOAD_DATA or
							 state=WAITDATA else
						"01" when state=NEW_OPERAND_BM else
						"10" when state=SHIFT_RB_BM else
						"11";
						
		loadOPR 	<= 	'1'  when state=PRODUCT or
							 state=SHIFT_PRODUCT or
							 state=NEW_OPA or 
							 state=RESET_BM else 
						'0';
		selOPR		<=  "00" when state=RESET_BM or 
							 state=NEW_OPA else 
						"01" when state=SHIFT_PRODUCT else
						"10" when state=SUM_BM else
						"11" when state=PRODUCT;
							
		loadACC_BM	<= 	'1'  when state=ACC_BM or
							 state=RESET_BM or
							 state=SHIFT_ACC else 
						'0';
		selACC_BM	<=  "00" when state=RESET_BM else
						"01" when state=SHIFT_ACC else
						"10" when state=NEW_PRODUCT_BM or
							 state=SUBPRODUCT or 
							 state=SUM_BM else
						"11" when state=ACC_BM;
								
		loadSUM 	<= 	'1'  when state=SUM_BM or
							 state=RESET_BM else 
						'0';
		selSUM		<= 	'0'  when state=ACC_BM or 
							 state=SUM_BM else 
						'1'  when state=RESET_BM;

		loadINC_BM	<= 	'1'  when state = LOAD_DATA or 
							 state=INC_CNT or 
							 state=WAITDATA 
							 else 
						'0';
		selINC_BM	<= 	'0'  when state=LOAD_DATA or 
							 state=WAITDATA else
						'1'	 when state=INC_CNT;
		
		loadADV_BM	<= 	'1'  when state=ADV or 
							 state=RESET_BM else 
						'0';
		selADV_BM	<= 	'0'  when state=RESET_BM else
						'1'  when state=ADV;
		
		loadRPM		<= 	'1'  when state=NEW_PRODUCT_BM else 
						'0';
		selRPM		<= 	'0'  when state=NEW_PRODUCT_BM else
						'1';
		
		loadOUT		<= 	'1'  when state=SUBPRODUCT else 
						'0';
						
		selOUT		<=	'0'  when state=SUBPRODUCT else
						'1';
						
		DATAOUT		<=	'1' when state=OUTSTATE else
						'0';
		READY		<=  '1'	 when state=INIT_BM or 
							 state=WAITDATA else
						'0';
end behavior;