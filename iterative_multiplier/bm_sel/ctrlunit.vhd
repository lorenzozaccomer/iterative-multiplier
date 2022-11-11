
--- ctrlunit.vhd

--- for basic multiplier select

-- libraries
library ieee;
use ieee.std_logic_1164.all;

entity ctrlunit is
	generic(
		Q 	: integer := 2;
		M 	: integer := 4);
	port(
		CLK, RST:			in std_logic
			-- control inputs
		CALC:				in std_logic;
		DATAIN:				in std_logic;
			-- control outputs
		OK:					out std_logic;
			-- status signals
		INT_CNT:			in std_logic_vector(Q downto 0);
		BM_SHIFT:			in std_logic;				
		);
end ctrlunit;


architecture behavior of ctrlunit is
	type statetype is (INIT_BM, NEW_OPERAND_BM, RESET_BM, PRODUCT, SHIFT_PRODUCT, 
						SUM_BM, ACC_BM, INC_BM, WAIT_BM, NEW_OPA, NEW_PRODUCT_BM, SUBPRODUCT);
	signal state, nextstate : statetype;
	
	begin
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

			when NEW_OPERAND_BM =>
				nextstate <= RESET_BM;
				
			when RESET_BM =>
				nextstate <= PRODUCT;
				
			when PRODUCT =>
				if BM_SHIFT = "00" then
					nextstate <= SUM_BM;
				else
					nextstate <= SHIFT_PRODUCT;
					
			when SHIFT_PRODUCT =>
				nextstate <= SUM_BM;
				
			when ACC_BM =>
				nextstate <= INC_BM;
				
			when INC_BM =>
				if BM_SHIFT = "010" then
					nextstate <= WAIT_BM;
				else
					nextstate <= NEW_OPA;
					
			when NEW_OPA =>
				nextstate <= PRODUCT;
				
			when WAIT_BM =>
				if INT_CNT = "100" then
					nextstate <= SUBPRODUCT;
				else
					nextstate <= NEW_PRODUCT_BM;
					
			when NEW_PRODUCT_BM =>
				nextstate <= NEW_OPERAND_BM;
				
			when others =>
				nextstate <= INIT_BM;
			
			
			
	
	
	
	
	
end behavior;