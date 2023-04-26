
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
			sel_EN1:		out std_logic;
			load_EN1:		out std_logic;
			sel_OPA:		out std_logic;
			load_OPA:		out std_logic;
			sel_OPB:		out std_logic;
			load_OPB:		out std_logic;
			sel_EN2:		out std_logic;
			load_EN2:		out std_logic;
			sel_OUTBM:		out std_logic;
			load_OUTBM:		out std_logic;
			sel_EN3:		out std_logic;
			load_EN3:		out std_logic;
			sel_OUT16:		out std_logic;
			load_OUT16:		out std_logic;
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
			sel_EN1:		out std_logic;
			load_EN1:		out std_logic;
			sel_OPA:		out std_logic;
			load_OPA:		out std_logic;
			sel_OPB:		out std_logic;
			load_OPB:		out std_logic;
			sel_EN2:		out std_logic;
			load_EN2:		out std_logic;
			sel_OUTBM:		out std_logic;
			load_OUTBM:		out std_logic;
			sel_EN3:		out std_logic;
			load_EN3:		out std_logic;
			sel_OUT16:		out std_logic;
			load_OUT16:		out std_logic;
				-- status signals from datapath
			ADV_BM:			in std_logic_vector(1 downto 0);
			DATAOUT_SEL:	in std_logic;
			DATAOUT_BM:		in std_logic;
			DATAOUT_RES:	in std_logic
		);
end entity;



architecture behavior of it_mult16_ctrlunit is


	type statetype is (INIT, LOAD_OPS, ENABLE_SEL, EXEC_SEL,
						SAVE_OPS_BM, ENABLE_BM, EXEC_BM,
						SAVE_OP_RES, ENABLE_RES, EXEC_RES, SAVE_OUT, 
						OUTSTATE, EMPTY1);
	signal state, nextstate : statetype;
	
	begin
		-- FSM
			state <= INIT when RST='1' else
				nextstate when rising_edge(CLK);
				
				
	process(state, DATAOUT_SEL, DATAOUT_BM, DATAOUT_RES, ADV_BM)
	begin
		case state is
			when INIT =>
				if DATAIN = '0' then
					nextstate <= INIT;
				else
					nextstate <= LOAD_OPS;
				end if;
				
				-- SELECTOR
			when LOAD_OPS =>
					nextstate <= ENABLE_SEL;
			when ENABLE_SEL =>
					nextstate <= EXEC_SEL;
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
					nextstate <= EMPTY1;
				end if;
			when EMPTY1 =>
				if DATAOUT_RES = '1' then
					nextstate <= SAVE_OUT;
				else
					nextstate <= EXEC_RES;
				end if;
					
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
		loadA		<=  '1' when state=LOAD_OPS else
						'0';
		selA		<=	'1' when state=LOAD_OPS else
						'0';
		loadB		<=  '1' when state=LOAD_OPS else
						'0';
		selB		<=	'1' when state=LOAD_OPS else
						'0';
					
			-- SELECTOR
		sel_EN1		<=  '1' when state=ENABLE_SEL else
					'0';
		load_EN1	<=	'1' when state=ENABLE_SEL else
					'0';
		sel_OPA		<=	'1' when state=SAVE_OPS_BM else
						'0';
		load_OPA	<=	'1' when state=SAVE_OPS_BM else
						'0';
		sel_OPB		<=	'1' when state=SAVE_OPS_BM else
						'0';
		load_OPB	<=	'1' when state=SAVE_OPS_BM else
						'0';
		
			-- BASIC_MULT
		sel_EN2		<=  '1' when state=ENABLE_BM else
						'0';
		load_EN2	<=	'1' when state=ENABLE_BM else
						'0';
		sel_OUTBM	<=  '1' when state=SAVE_OP_RES else
						'0';
		load_OUTBM	<=	'1' when state=SAVE_OP_RES else
						'0';
						
			-- RESOLVER
		sel_EN3		<=  '1' when state=ENABLE_RES else
						'0';
		load_EN3	<=	'1' when state=ENABLE_RES else
						'0';
		
			-- SAVE OUT
		sel_OUT16	<=  '1' when state=SAVE_OUT else
						'0';
		load_OUT16	<=	'1' when state=SAVE_OUT else
						'0';
		
		--
		DATAOUT		<=	'1' when state=OUTSTATE else
						'0';
		READY		<=	'1' when state=INIT else
						'0';
		
		
		
		
end behavior;