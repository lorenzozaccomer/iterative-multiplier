
--- ctrlunit.vhd

--- for basic multiplier select

-- libraries
library ieee;
use ieee.std_logic_1164.all;

	-- interface
entity ctrlunit is
	generic(
		Q 	: integer := 2;
		M 	: integer := 4);
	port(
		CLK:				in std_logic;
		RST:				in std_logic;
			-- control signals to/from extern
		START:				in std_logic;	-- the module can go ahead
		DATAIN:				in std_logic;	-- will be equal to 1 when the module has the datas to process
		READY:				out std_logic;	-- the modules can do another operation
			-- control singals to datapath
		selOPA:				out std_logic;
		selOPB:				out std_logic;
		selRA_BM:			out std_logic;
		selRB_BM:			out std_logic;
		selTEMP_BM:			out std_logic;
		selOPR:				out std_logic_vector(Q-1 downto 0);
		selACC_BM:			out std_logic_vector(Q-1 downto 0);
		selSUM:				out std_logic;
		selINC_CNT:			out std_logic;
		selADV_BM:			out std_logic;
		selRPM:				out std_logic;
		
		loadOPA:			out std_logic;
		loadOPB:			out std_logic;
		loadRA_BM:			out std_logic;
		loadRB_BM:			out std_logic;
		loadTEMP_BM:		out std_logic;
		loadOPR:			out std_logic;
		loadACC_BM:			out std_logic;
		loadSUM:			out std_logic;
		loadINC_CNT:		out std_logic;
		loadADV_BM:			out std_logic;
		loadOUT:			out std_logic;
		loadRPM:			out std_logic;
			-- status signals from datapath
		INT_CNT:			in std_logic_vector(Q downto 0);
		ADV_BM:				in std_logic				
		);
end ctrlunit;


architecture behavior of ctrlunit is

	type statetype is (INIT_BM, SAVE_OPA, NEW_OPERAND_BM, RESET_BM, PRODUCT, SHIFT_PRODUCT, 
						SUM_BM, ACC_BM, INC_BM, WAIT_BM, SHIFT_OPA, SHIFT_ACC, NEW_OPA, NEW_PRODUCT_BM, SUBPRODUCT);
	signal state, nextstate : statetype;
	
	begin
		-- FSM
			state <= INIT_BM when RST='1' else
				nextstate when rising_edge(CLK);
	process(state, START, DATAIN, ADV_BM, INT_CNT)
	begin
		case state is
			when INIT_BM =>
				if START /= '1'	then
					nextstate <= INIT_BM;
				elsif DATAIN /= '1' then
					nextstate <= INIT_BM;
				else
					nextstate <= NEW_OPERAND_BM;
				end if;
			when SAVE_OPA =>
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
				nextstate <= INC_BM;
			when INC_BM =>
				if INT_CNT <= "010" then
					nextstate <= WAIT_BM;
				else
					nextstate <= SHIFT_OPA;
				end if;
			when SHIFT_OPA =>
				nextstate <= NEW_OPA;
			when NEW_OPA =>
				nextstate <= PRODUCT;
			when WAIT_BM =>
				if INT_CNT = "100" then
					nextstate <= SUBPRODUCT;
				else
					nextstate <= NEW_PRODUCT_BM;
				end if;
			when NEW_PRODUCT_BM =>
				nextstate <= NEW_OPERAND_BM;
			when SUBPRODUCT =>
				if START = '1' then
					nextstate <= INIT_BM;
				end if;
			when others =>
				nextstate <= INIT_BM;
		end case;
	end process;
	
		-- OUTPUTS
		loadOPA		<= 	'1'  when state=NEW_OPERAND_BM or
							 state=NEW_OPA else 
						'0';
		selOPA		<= 	'1'  when state=PRODUCT else 
						'0';
		
		loadOPB 	<= 	'1'  when state=NEW_OPERAND_BM else 
						'0';
		selOPB		<= 	'1'  when state=PRODUCT else 
						'0';
		
		loadRA_BM	<=	'1' when state=INIT_BM else
						'0';
		selRA_BM	<= 	'1'  when state=SAVE_OPA or 
							 state=NEW_PRODUCT_BM else 
						'0';
								
		loadRB_BM	<= 	'1'  when state=WAIT_BM else 
						'0';
		selRB_BM	<= 	'0'  when state=WAIT_BM else
						'1'  when state=NEW_OPERAND_BM;
		
		loadTEMP_BM <= 	'1'  when state=SAVE_OPA or
							 state=NEW_PRODUCT_BM or
							 state=SHIFT_OPA else '0';
		selTEMP_BM	<=  '1'  when state=NEW_OPA or 
							 state=NEW_OPERAND_BM else
						'0'  when state=SHIFT_OPA;
							
		loadOPR 	<= 	'1'  when state=PRODUCT or
							 state=SHIFT_PRODUCT or
							 state=NEW_OPA or 
							 state=RESET_BM else '0';
		selOPR		<=  "00" when state=RESET_BM or 
							 state=NEW_OPA else 
						"01" when state=SHIFT_PRODUCT else
						"10" when state=SUM_BM else
						"11";
							
		loadACC_BM	<= 	'1'  when state=ACC_BM or
							 state=RESET_BM or
							 state=SHIFT_ACC else '0';
		selACC_BM	<=  "00" when state=RESET_BM else
						"01" when state=SHIFT_ACC else
						"10" when state=NEW_PRODUCT_BM or
							 state=SUM_BM or
							 state=SUBPRODUCT else
						"11";
								
		loadSUM 	<= 	'1'  when state=SUM_BM or
							 state=RESET_BM else '0';
		selSUM		<= 	'1'  when state=ACC_BM else 
						'0'  when state=RESET_BM;

		loadINC_CNT	<= 	'1'  when state=INC_BM or 
							 state=INIT_BM else 
						'0';
		selINC_CNT	<= 	'1'  when state=INC_BM else 
						'0';
		
		loadADV_BM	<= 	'1'  when state=INC_BM or 
							 state=INIT_BM else 
						'0';
		selADV_BM	<= 	'0'  when state=INIT_BM or
							 state=RESET_BM else
						'1'  when state=INC_BM;
		
		loadRPM		<= 	'1'  when state=NEW_PRODUCT_BM else 
						'0';
		selRPM		<= 	'1'  when state=SUBPRODUCT else 
						'0';
		
		loadOUT		<= 	'1'  when state=SUBPRODUCT else 
						'0';
						
						
		READY		<=  '1'	 when state=SUBPRODUCT else
						'0';
end behavior;