
--- ctrlunit.vhd

--- for internal multiplier
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package internal_mult_ctrlunit_package is
	component internal_mult_ctrlunit is
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
			selCNT_BM:			out std_logic;
			selRPM:				out std_logic;
			selOUT:				out std_logic;
			selINT_A:			out std_logic;
			selINT_B:			out std_logic;
			
			loadOPA:			out std_logic;
			loadOPB:			out std_logic;
			loadA_BM:			out std_logic;
			loadB_BM:			out std_logic;
			loadOPR:			out std_logic;
			loadACC_BM:			out std_logic;
			loadSUM:			out std_logic;
			loadCNT_BM:			out std_logic;
			loadRPM:			out std_logic;
			loadOUT:			out std_logic;
			loadINT_A:			out std_logic;
			loadINT_B:			out std_logic;
				-- status signals from datapath			
			CNT_BM:				in std_logic_vector(Q downto 0)
			);
	end component;
end internal_mult_ctrlunit_package;
----------------------------------------------------------------------

-- libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	-- interface
entity internal_mult_ctrlunit is
	generic(
		Q 	: integer := 2;
		M 	: integer := 4);
	port(
		CLK:				in std_logic;
		RST:				in std_logic;
			-- control signals to/from extern
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
		selCNT_BM:			out std_logic;
		selRPM:				out std_logic;
		selOUT:				out std_logic;
		selINT_A:			out std_logic;
		selINT_B:			out std_logic;
				
		loadOPA:			out std_logic;
		loadOPB:			out std_logic;
		loadA_BM:			out std_logic;
		loadB_BM:			out std_logic;
		loadOPR:			out std_logic;
		loadACC_BM:			out std_logic;
		loadSUM:			out std_logic;
		loadCNT_BM:			out std_logic;
		loadRPM:			out std_logic;
		loadOUT:			out std_logic;
		loadINT_A:			out std_logic;
		loadINT_B:			out std_logic;
			-- status signals from datapath
		CNT_BM:				in std_logic_vector(Q downto 0)
		);
end internal_mult_ctrlunit;


architecture behavior of internal_mult_ctrlunit is

	type statetype is (INIT, LOAD_INTERNALS, LOAD_DATA, NEW_OPERAND_BM, RESET_BM, PRODUCT, SHIFT_PRODUCT, 
						SUM_BM, ACC_BM, INC_CNT, ADV, WAIT_BM, SHIFT_OPA, SHIFT_ACC, 
						NEW_OPA, SHIFT_RB_BM, NEW_PRODUCT_BM, SUBPRODUCT, OUTSTATE);
	signal state, nextstate : statetype;
	
	begin
		-- FSM
			state <= INIT when RST='1' else
				nextstate when rising_edge(CLK);
	process(state, DATAIN, CNT_BM)
	begin
		case state is
			when INIT =>
				if DATAIN = '0' then
					nextstate <= INIT;
				else
					nextstate <= LOAD_INTERNALS;
				end if;
			when LOAD_INTERNALS =>
				nextstate <= LOAD_DATA;
			when LOAD_DATA =>
				nextstate <= NEW_OPERAND_BM;
			when NEW_OPERAND_BM =>
				nextstate <= RESET_BM;
			when RESET_BM =>
				nextstate <= PRODUCT;
			when PRODUCT =>
				if CNT_BM = "000" or CNT_BM = "010" then
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
					nextstate <= INIT;
			when others =>
				nextstate <= INIT;
		end case;
	end process;
	
		-- OUTPUTS
		loadOPA		<= 	'1'  when state=NEW_OPERAND_BM or
							 state=NEW_OPA else 
						'0';
		selOPA		<= 	'1'  when state=NEW_OPERAND_BM or 
							 state=NEW_OPA else
						'0';
		
		loadOPB 	<= 	'1'  when state=NEW_OPERAND_BM else 
						'0';
		selOPB		<= 	'1'  when state=NEW_OPERAND_BM else 
						'0';
		
		loadA_BM	<=	'1'  when state=LOAD_DATA or 
							 state=NEW_PRODUCT_BM or 
							 state=SHIFT_OPA else
						'0';
		selA_BM		<=	"00" when state=LOAD_DATA or 
							 state=NEW_PRODUCT_BM else
						"01" when state=SHIFT_OPA else 
						"10";
								
		loadB_BM	<= 	'1'  when state=LOAD_DATA or 
							 state=SHIFT_RB_BM else 
						'0';
		selB_BM	<= 		"00" when state=LOAD_DATA else
						"01" when state=SHIFT_RB_BM else
						"10";
						
		loadOPR 	<= 	'1'  when state=PRODUCT or
							 state=SHIFT_PRODUCT or
							 state=NEW_OPA or 
							 state=RESET_BM else 
						'0';
		selOPR		<=  "00" when state=RESET_BM or 
							 state=NEW_OPA else 
						"01" when state=SHIFT_PRODUCT else
						"10" when state=PRODUCT else
						"11";
							
		loadACC_BM	<= 	'1'  when state=ACC_BM or
							 state=RESET_BM or
							 state=SHIFT_ACC else 
						'0';
		selACC_BM	<=  "00" when state=RESET_BM else
						"01" when state=SHIFT_ACC else
						"10" when state=ACC_BM else
						"11";
								
		loadSUM 	<= 	'1'  when state=SUM_BM or
							 state=RESET_BM else 
						'0';
		selSUM		<= 	'1'  when state=SUM_BM else 
						'0';

		loadCNT_BM	<= 	'1'  when state=LOAD_DATA or 
							 state=INC_CNT else 
						'0';
		selCNT_BM	<= 	'1'  when state=INC_CNT else
						'0';
		
		loadRPM		<= 	'1'  when state=NEW_PRODUCT_BM else 
						'0';
		selRPM		<= 	'1'  when state=NEW_PRODUCT_BM else
						'0';
		
		loadOUT		<= 	'1'  when state=SUBPRODUCT else 
						'0';
						
		selOUT		<=	'1'  when state=SUBPRODUCT else
						'0';
						
		loadINT_A	<= 	'1'  when state=LOAD_INTERNALS else 
						'0';
						
		selINT_A	<=	'1'  when state=LOAD_INTERNALS else
						'0';
						
		loadINT_B	<= 	'1'  when state=LOAD_INTERNALS else 
						'0';
						
		selINT_B	<=	'1'  when state=LOAD_INTERNALS else
						'0';
						
		DATAOUT		<=	'1'  when state=OUTSTATE else
						'0';
		READY		<=  '1'	 when state=INIT else
						'0';
end behavior;