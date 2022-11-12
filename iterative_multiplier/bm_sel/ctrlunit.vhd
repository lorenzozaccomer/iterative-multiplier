
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
		CLK, RST:			in std_logic;
			-- control inputs
		CALC:				in std_logic;
		DATAIN:				in std_logic;
			-- control outputs
		loadOPA:			out std_logic;
		loadOPB:			out std_logic;
		selRA_BM:			out std_logic;
		loadRB_BM:			out std_logic;
		selRB_BM:			out std_logic;
		loadTEMP_BM:		out std_logic;
		selTEMP_BM:			out std_logic;
		loadOPR:			out std_logic;
		selOPR:				out std_logic;
		loadACC:			out std_logic;
		selACC:				out std_logic;
		loadSUM:			out std_logic;
		selSUM:				out std_logic;
		selINC:				out std_logic;
		loadINC:			out std_logic;
		selSH:				out std_logic;
		loadSH:				out std_logic;
		OK:					out std_logic;
			-- status signals
		INT_CNT:			in std_logic_vector(Q downto 0);
		BM_SHIFT:			in std_logic				
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
	process(state, CALC, DATAIN, BM_SHIFT, INT_CNT)
	begin
		case state is
			when INIT_BM =>
				if CALC /= '0'	then
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
				if BM_SHIFT = '0' then
					nextstate <= SUM_BM;
				else
					nextstate <= SHIFT_PRODUCT;
				end if;
			when SHIFT_PRODUCT =>
				nextstate <= SUM_BM;
			when ACC_BM =>
				nextstate <= INC_BM;
			when INC_BM =>
				if INT_CNT <= "010" then
					nextstate <= WAIT_BM;
				else
					nextstate <= NEW_OPA;
				end if;
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
				nextstate <= INIT_BM;
			when others =>
				nextstate <= INIT_BM;
		end case;
	end process;
	
		-- OUTPUTS
		loadOPA		<= '1' when state=NEW_OPERAND_BM or
							state=NEW_OPA or
							state=PRODUCT else '0';
							
		loadOPB 	<= '1' when state=NEW_OPERAND_BM or 
								state=PRODUCT else '0';
								
		selRA_BM	<= '1' when state=SAVE_OPA or
								state=NEW_PRODUCT_BM else '0';
								
		loadRB_BM	<= '1' when state=NEW_PRODUCT_BM else '0';
		selRB_BM	<= '1' when state=NEW_OPERAND_BM or
							state=NEW_PRODUCT_BM else '0';
		
		loadTEMP_BM <= '1' when state=SAVE_OPA or
							state=NEW_PRODUCT_BM or
							state=SHIFT_OPA else '0';
		selTEMP_BM	<= '1' when state=NEW_OPA or 
							state=NEW_OPERAND_BM or
							state=SHIFT_OPA else '0';
							
		loadOPR 	<= '1' when state=PRODUCT or
							state=SHIFT_PRODUCT or
							state=NEW_OPA or 
							state=RESET_BM else '0';
		selOPR		<= '1' when state=SHIFT_PRODUCT or
							state=SUM_BM else '0';
							
		loadACC		<= '1' when state=ACC_BM or
							state=RESET_BM or
							state=SHIFT_ACC else '0';
							
		selACC		<= '1' when state=SHIFT_ACC or
							state=NEW_PRODUCT_BM or
							state=SUM_BM or
							state=SUBPRODUCT else '0';
								
		loadSUM 	<= '1' when state=SUM_BM or
							state=RESET_BM else '0';
		selSUM		<= '1' when state=SUM_BM else '0';

		selINC		<= '1' when state=INC_BM or
							state=INIT_BM else '0';
		loadINC		<= '1' when state=INC_BM else '0';
		
		selSH		<= '1' when state=INC_BM or
							state=INIT_BM else '0';
		loadSH		<= '1' when state=INC_BM else '0';
end behavior;