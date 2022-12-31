
-- ctrlunit.vhd

-- for multilplier res module


----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package res_ctrlunit_package is
	component res_ctrlunit is
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
			NW_PRD:			in std_logic;
			ADV_AM:			out std_logic_vector (1 downto 0);	-- new 4bits of A
			DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
			READY:			out std_logic;	-- m_sel can accept new data input
				-- control signal to datapath
			loadNSHIFT:		out std_logic;
			selNSHIFT:		out std_logic;
			loadPSHIFT:		out std_logic;
			selPSHIFT:		out std_logic;
			loadOUTBM:		out std_logic;
			selOUTBM:		out std_logic;
			loadBM:			out std_logic;
			selBM:			out std_logic;
			loadS1:			out std_logic;
			selS1:			out std_logic;
			loadRS:			out std_logic;
			selRS:			out std_logic;
			loadS2:			out std_logic;
			selS2:			out std_logic;
			loadACCR:		out std_logic;
			selACCR:		out std_logic;
			loadRES:		out std_logic;
			selRES:			out std_logic;
				-- status signals from datapath
			P_SHIFT:		in std_logic_vector(P-1 downto 0);
			N_SHIFT:		in std_logic_vector(P downto 0);
			CNT_R:			in std_logic_vector(P downto 0)
		);
	end component;
end res_ctrlunit_package;
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	-- interface
entity res_ctrlunit is
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
			NW_PRD:			in std_logic;
			ADV_AM:			out std_logic_vector (1 downto 0);	-- new 4bits of A
			DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
			READY:			out std_logic;	-- m_sel can accept new data input
				-- control signal to datapath
			loadNSHIFT:		out std_logic;
			selNSHIFT:		out std_logic;
			loadPSHIFT:		out std_logic;
			selPSHIFT:		out std_logic;
			loadOUTBM:		out std_logic;
			selOUTBM:		out std_logic;
			loadBM:			out std_logic;
			selBM:			out std_logic;
			loadS1:			out std_logic;
			selS1:			out std_logic;
			loadRS:			out std_logic;
			selRS:			out std_logic;
			loadS2:			out std_logic;
			selS2:			out std_logic;
			loadACCR:		out std_logic;
			selACCR:		out std_logic;
			loadRES:		out std_logic;
			selRES:			out std_logic;
				-- status signals from datapath
			P_SHIFT:		in std_logic_vector(P-1 downto 0);
			N_SHIFT:		in std_logic_vector(P downto 0);
			CNT_R:			in std_logic_vector(P downto 0)
		);
end entity;




architecture behavior of res_ctrlunit is


	type statetype is (INIT, RESET, LOAD_DATA, SUM1, ACC1, INC_CNT, UP_ADV_AM,
						INC_P, P_WAITDATA, SUM2, ACC2, WAIT2, DOWN_ADV_AM, 
						INC_N, RESET_P, ACC3, OUTDATA);
	signal state, nextstate : statetype;
	
	begin
		-- FSM
			state <= INIT when RST='1' else
				nextstate when rising_edge(CLK);
				
				
	process(state, DATAIN, NW_PRD)
	begin
		case state is
			when INIT =>
				if DATAIN = '0' then
					nextstate <= INIT;
				else
					nextstate <= RESET;
				end if;
			when RESET =>
				nextstate <= LOAD_DATA;
			when LOAD_DATA =>
				nextstate <= SUM1;
			when SUM1 =>
				nextstate <= INC_CNT;
			when INC_CNT =>
				if P_SHIFT = "1100" then	-- b'1100 = 12
					nextstate <= SUM2;
				else
					nextstate <= UP_ADV_AM;
				end if;
			when UP_ADV_AM =>
				if NW_PRD = '1' then
					nextstate <= INC_P;
				else
					nextstate <= UP_ADV_AM;
				end if;
			when INC_P =>
				nextstate <= P_WAITDATA;
			when P_WAITDATA =>
				if DATAIN = '0' then
					nextstate <= P_WAITDATA;
				else
					nextstate <= LOAD_DATA;
				end if;
			when SUM2 =>
				nextstate <= ACC2;
			when ACC2 =>
				nextstate <= WAIT2;
			when WAIT2 =>
				if CNT_R = "10000" then	-- b10000 = 16
					nextstate <= ACC3;
				else
					nextstate <= DOWN_ADV_AM;
				end if;
			when DOWN_ADV_AM =>
				if NW_PRD = '1' then
					nextstate <= INC_N;
				else
					nextstate <= DOWN_ADV_AM;
				end if;
			when INC_N =>
				nextstate <= RESET_P;
			when RESET_P =>
				if DATAIN = '0' then
					nextstate <= RESET_P;
				else
					nextstate <= LOAD_DATA;
				end if;
			when ACC3 =>
				nextstate <= OUTDATA;
			when OUTDATA =>
				nextstate <= INIT;
			when others =>
				nextstate <= INIT;
		end case;
	end process;
	
		-- OUTPUTS
		loadNSHIFT		<=	'1' when state=RESET or
								state=INC_N else
							'0';
		selNSHIFT		<=	'0' when state=RESET else
							'1' when state=INC_N;
							
		loadPSHIFT		<= 	'1' when state=RESET or
								state=INC_P or 
								state=RESET_P else
							'0';
		selPSHIFT		<=	'0' when state=RESET or 
								state=RESET_P else
							'1' when state=INC_N;
							
		loadOUTBM		<=	'1' when state=LOAD_DATA else
							'0';
		selOUTBM		<=	'0' when state=LOAD_DATA else
							'1';
							
		loadBM			<=	'1' when state=LOAD_DATA else
							'0';
		selBM			<=	'1' when state=SUM1 else
							'0';
							
		loadS1			<=	'1' when state=SUM1 else
							'0';
		selS1			<=	'1' when state=ACC1 else
							'0';
							
		loadRS			<=	'1' when state=ACC1 else
							'0';
		selRS			<=	'1' when state=SUM1 or 
								state=SUM2 else
							'0';
							
		loadS2			<=	'1' when state=SUM2 else
							'0';
		selS2			<=	'1' when state=ACC2 else
							'0';	
							
		loadACCR		<=	'1' when state=ACC2 else
							'0';
		selACCR			<=	'1' when state=SUM1 or 
								state=SUM2 else
							'0';
							
		loadRES			<=	'1' when state=ACC3 else
							'0';
		selRES			<=	'1' when state=ACC3 else
							'0';
											
							
		---
		ADV_AM			<=	"00" when state=DOWN_ADV_AM else
							"01" when state=UP_ADV_AM else
							"11";
		DATAOUT			<=	'1' when state=OUTDATA else
							'0';
		READY			<=	'1' when state=INIT else
							'0';
		
		
end behavior;