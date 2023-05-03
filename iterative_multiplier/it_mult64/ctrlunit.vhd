
-- ctrlunit.vhd

-- for iterative multiplier 16

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package it_mult16_ctrlunit_package is
	component it_mult16_ctrlunit is
		generic(
			N	: integer := 16;
			M	: integer := 8;
			P	: integer := 4
			);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- control signal to/from extern
			DATAIN:			in std_logic;	-- new data to manipulate
			DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
			READY:			out std_logic;	-- m_sel can accept new data input
				-- control signal to datapath
			loadA:			out std_logic;
			selA:			out std_logic;
			loadB:			out std_logic;
			selB:			out std_logic;
			selEN1:			out std_logic;
			loadEN1:		out std_logic;
			selOPA:			out std_logic;
			loadOPA:		out std_logic;
			selOPB:			out std_logic;
			loadOPB:		out std_logic;
			selEN2:			out std_logic;
			loadEN2:		out std_logic;
			selOUTBM:		out std_logic;
			loadOUTBM:		out std_logic;
			selEN3:			out std_logic;
			loadEN3:		out std_logic;
			selOUT16:		out std_logic;
			loadOUT16:		out std_logic;
				-- status signals from datapath
			ADV_BM:			in std_logic_vector(1 downto 0);
			DATAOUT_SEL:	in std_logic;
			DATAOUT_BM:		in std_logic;
			DATAOUT_RES:	in std_logic
		);
	end component;
end it_mult16_ctrlunit_package;
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	-- interface
entity it_mult16_ctrlunit is
	generic(
		N	: integer := 16;
		M	: integer := 8;
		P	: integer := 4
		);
	port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- control signal to/from extern
			DATAIN:			in std_logic;	-- new data to manipulate
			DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
			READY:			out std_logic;	-- m_sel can accept new data input
				-- control signal to datapath
			loadA:			out std_logic;
			selA:			out std_logic;
			loadB:			out std_logic;
			selB:			out std_logic;
			selEN1:			out std_logic;
			loadEN1:		out std_logic;
			selOPA:			out std_logic;
			loadOPA:		out std_logic;
			selOPB:			out std_logic;
			loadOPB:		out std_logic;
			selEN2:			out std_logic;
			loadEN2:		out std_logic;
			selOUTBM:		out std_logic;
			loadOUTBM:		out std_logic;
			selEN3:			out std_logic;
			loadEN3:		out std_logic;
			selOUT16:		out std_logic;
			loadOUT16:		out std_logic;
				-- status signals from datapath
			ADV_BM:			in std_logic_vector(1 downto 0);
			DATAOUT_SEL:	in std_logic;
			DATAOUT_BM:		in std_logic;
			DATAOUT_RES:	in std_logic
		);
end entity;



architecture behavior of it_mult16_ctrlunit is


	type statetype is (INIT, LOAD_OPERANDS, ENABLE_SEL, EXEC_SEL,
						SAVE_OPS_BM, ENABLE_BM, EXEC_BM,
						SAVE_OP_RES, ENABLE_RES, EXEC_RES, SAVE_OUT, 
						OUTSTATE, LOW_ENABLE1, LOW_ENABLE2, LOW_ENABLE3);
	signal state, nextstate : statetype;
	
	begin
		-- FSM
			state <= INIT when RST='1' else
				nextstate when rising_edge(CLK);
				
				
	process(state, DATAIN, DATAOUT_SEL, DATAOUT_BM, DATAOUT_RES, ADV_BM)
	begin
		case state is
			when INIT =>
				if DATAIN = '0' then
					nextstate <= INIT;
				else
					nextstate <= LOAD_OPERANDS;
				end if;
				
				-- SELECTOR
			when LOAD_OPERANDS =>
					nextstate <= ENABLE_SEL;
			when ENABLE_SEL =>
					nextstate <= EXEC_SEL;
			-- when EXEC_SEL =>
					-- nextstate <= LOW_ENABLE1;
			when EXEC_SEL =>
				if DATAOUT_SEL = '1' then
					nextstate <= SAVE_OPS_BM;
				else
					nextstate <= EXEC_SEL;
				end if;
			
				-- BASIC_MULT
			when SAVE_OPS_BM =>
				nextstate <= ENABLE_BM;
			when ENABLE_BM =>
				nextstate <= EXEC_BM;
			-- when EXEC_BM =>
				-- nextstate <= LOW_ENABLE2;
			when EXEC_BM =>
				if DATAOUT_BM = '1' then
					nextstate <= SAVE_OP_RES;
				else
					nextstate <= EXEC_BM;
				end if;
					
				-- RESOLVER
			when SAVE_OP_RES =>
				nextstate <= ENABLE_RES;
			when ENABLE_RES =>
				nextstate <= EXEC_RES; 
			when EXEC_RES =>
				if ADV_BM="00" or ADV_BM="01" then
					nextstate <= EXEC_SEL;
				else
					if DATAOUT_RES = '1' then
						nextstate <= SAVE_OUT;
					else
						nextstate <= EXEC_RES;
					end if;
				end if;
			-- when LOW_ENABLE3 =>
				-- if DATAOUT_RES = '1' then
					-- nextstate <= SAVE_OUT;
				-- else
					-- nextstate <= EXEC_RES;
				-- end if;
					
				-- SAVE RESULT
			when SAVE_OUT =>
				nextstate <= OUTSTATE;
			when OUTSTATE=>
				nextstate <= INIT;
				
			when others =>
				nextstate <= INIT;
			
		end case;
	end process;
	
		-- OUTPUTS
		loadA		<=  '1' when state=LOAD_OPERANDS else
						'0';
		selA		<=	'1' when state=LOAD_OPERANDS else
						'0';
		loadB		<=  '1' when state=LOAD_OPERANDS else
						'0';
		selB		<=	'1' when state=LOAD_OPERANDS else
						'0';
					
			-- SELECTOR
		selEN1		<=  '1' when state=ENABLE_SEL else
						'0';
		loadEN1		<=	'1' when state=ENABLE_SEL or 
							state=EXEC_SEL or
							state=INIT else
						'0';
		selOPA		<=	'1' when state=SAVE_OPS_BM else
						'0';
		loadOPA		<=	'1' when state=SAVE_OPS_BM else
						'0';
		selOPB		<=	'1' when state=SAVE_OPS_BM else
						'0';
		loadOPB		<=	'1' when state=SAVE_OPS_BM else
						'0';
		
			-- BASIC_MULT
		selEN2		<=  '1' when state=ENABLE_BM else
						'0';
		loadEN2		<=	'1' when state=ENABLE_BM or 
							state=EXEC_BM or
							state=INIT else
						'0';
		selOUTBM	<=  '1' when state=SAVE_OP_RES else
						'0';
		loadOUTBM	<=	'1' when state=SAVE_OP_RES else
						'0';
						
			-- RESOLVER
		selEN3		<=  '1' when state=ENABLE_RES else
						'0';
		loadEN3		<=	'1' when state=ENABLE_RES or
							state=INIT or 
							state=EXEC_RES else
						'0';
		
			-- SAVE OUT
		selOUT16	<=  '1' when state=SAVE_OUT else
						'0';
		loadOUT16	<=	'1' when state=SAVE_OUT else
						'0';
		
		--
		DATAOUT		<=	'1' when state=OUTSTATE else
						'0';
		READY		<=	'1' when state=INIT else
						'0';
		
		
		
		
end behavior;