
-- ctrlunit.vhd

-- for multilplier resolver module

----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package resolver_ctrlunit_package is
	component resolver_ctrlunit is
		generic(
			N			: integer := 16;
			DIM_CNT		: integer := 3;
			REPETITION	: integer := 4
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
			loadINT:		out std_logic;
			selINT:			out std_logic;
			loadINT2:		out std_logic;
			selINT2:		out std_logic;
			loadS1:			out std_logic;
			selS1:			out std_logic;
			loadRS:			out std_logic;
			selRS:			out std_logic_vector(1 downto 0);
			loadS2:			out std_logic;
			selS2:			out std_logic;
			selOPT1:		out std_logic;
			selOPT2:		out std_logic;
			loadACCR:		out std_logic;
			selACCR:		out std_logic_vector(1 downto 0);
			loadRESULT:		out std_logic;
			selRESULT:		out std_logic;
				-- status signals from datapath
			P_SHIFT:		in std_logic_vector(DIM_CNT-1 downto 0);
			N_SHIFT:		in std_logic_vector(DIM_CNT-1 downto 0)
		);
	end component;
end resolver_ctrlunit_package;
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

	-- interface
entity resolver_ctrlunit is
	generic(
		N			: integer := 16;
		DIM_CNT		: integer := 3;
		REPETITION	: integer := 4
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
			loadINT:		out std_logic;
			selINT:			out std_logic;
			loadINT2:		out std_logic;
			selINT2:		out std_logic;
			loadS1:			out std_logic;
			selS1:			out std_logic;
			loadRS:			out std_logic;
			selRS:			out std_logic_vector(1 downto 0);
			loadS2:			out std_logic;
			selS2:			out std_logic;
			selOPT1:		out std_logic;
			selOPT2:		out std_logic;
			loadACCR:		out std_logic;
			selACCR:		out std_logic_vector(1 downto 0);
			loadRESULT:		out std_logic;
			selRESULT:		out std_logic;
				-- status signals from datapath
			P_SHIFT:		in std_logic_vector(DIM_CNT-1 downto 0);
			N_SHIFT:		in std_logic_vector(DIM_CNT-1 downto 0)
		);
end entity;




architecture behavior of resolver_ctrlunit is


	type statetype is (INIT, START, LOAD_DATA, SHIFT1, SUM1, ACC1, UP_ADV_AM,
						INC_P, P_WAITDATA, WAITSELS, SHIFT2, SUM2, ACC2, WAIT2, DOWN_ADV_AM, 
						INC_N, RESET_P, ACC3, OUTDATA, WAIT1, WAIT3, WAITSHIFT,WAITSHIFT2);
	signal state, nextstate : statetype;
	
	begin
		-- FSM
			state <= INIT when RST='1' else
				nextstate when rising_edge(CLK);
				
				
	process(state, DATAIN, NW_PRD, P_SHIFT, N_SHIFT)
	begin
		case state is
			when INIT =>
				if DATAIN = '0' then
					nextstate <= INIT;
				else
					nextstate <= START;
				end if;
			when START =>
				nextstate <= LOAD_DATA;
			when LOAD_DATA =>
				if P_SHIFT = std_logic_vector(to_unsigned(0, DIM_CNT)) then	-- b'00 = 0
					nextstate <= SUM1;
				else
					nextstate <= SHIFT1;
				end if;
			when SHIFT1 =>
				nextstate <= WAITSHIFT;
			when WAITSHIFT =>
				nextstate <= SUM1;
			when SUM1 =>
				nextstate <= ACC1;
			when ACC1 =>
				nextstate <= WAIT1;
				
			when WAIT1 =>
				if P_SHIFT = std_logic_vector(to_unsigned(REPETITION-1, DIM_CNT)) then	-- b011 = 3, --b1000 = 8
					nextstate <= WAITSELS;
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
			
			when WAITSELS =>
				if N_SHIFT = std_logic_vector(to_unsigned(0, DIM_CNT)) then	-- b'00 = 0
					nextstate <= SUM2;
				else
					nextstate <= SHIFT2;
				end if;
			when SHIFT2 =>
				nextstate <= WAITSHIFT2;
			when WAITSHIFT2 =>
				nextstate <= SUM2;
			when SUM2 =>
				nextstate <= ACC2;
			when ACC2 =>
				nextstate <= WAIT2;
				
			when WAIT2 =>
				if N_SHIFT = std_logic_vector(to_unsigned(REPETITION-1, DIM_CNT)) then	-- b011 = 3, --b1000 = 8
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
				nextstate <= WAIT3;
			when WAIT3 =>
				nextstate <= OUTDATA;
			when OUTDATA =>
				nextstate <= INIT;
				
			when others =>
				nextstate <= INIT;
		end case;
	end process;
	
		-- OUTPUTS
		loadNSHIFT		<=	'1' when state=START or
								state=INC_N else
							'0';
		selNSHIFT		<=	'0' when state=START else
							'1' when state=INC_N;
							
		loadPSHIFT		<= 	'1' when state=START or
								state=INC_P or 
								state=INC_N else
							'0';
		selPSHIFT		<=	'0' when state=START or 
								state=INC_N else
							'1' when state=INC_P;
							
		loadOUTBM		<=	'1' when state=LOAD_DATA else
							'0';
		selOUTBM		<=	'0' when state=LOAD_DATA else
							'1';
							
		loadINT			<=	'1' when state=WAITSHIFT or 
								state=RESET_P or 
								state=START else
							'0';
		selINT			<=	'1' when state=WAITSHIFT else
							'0';
							
		loadS1			<=	'1' when state=SUM1 or
								state=WAIT1 else
							'0';
		selS1			<=	'0' when state=SUM1 else
							'1';
							
		loadRS			<=	'1' when state=ACC1 or 
								state=SHIFT1 or 
								state=START or 
								state=RESET_P else
							'0';
		selRS			<=	"00" when state=START or
								 state=RESET_P else
							"01" when state=SHIFT1 else
							"10" when state=ACC1 else
							"11";
							
		
		loadINT2		<=	'1' when state=WAITSELS or 
								state=RESET_P or 
								state=START else
							'0';
		selINT2			<=	'1' when state=WAITSELS else
							'0' when state=START or
								state=RESET_P;	
				
		loadS2			<=	'1' when state=SUM2 or 
								state=WAIT2 else
							'0';
		selS2			<=	'0' when state=SUM2 else
							'1';
					
		selOPT1			<=	'0' when state=WAIT1 else
							'1';	
		selOPT2			<=	'0' when state=WAIT2 else
							'1';
							
		loadACCR		<=	'1' when state=ACC2 or 
								state=SHIFT2 or 
								state=WAIT3 else
							'0';
		selACCR			<=	"00" when state=SHIFT2 else
							"01" when state=ACC2 else
							"10" when state=WAIT3 else
							"11";
							
		loadRESULT		<=	'1' when state=ACC3 else
							'0';
		selRESULT		<=	'0' when state=ACC3 else
							'1';
								
				
		---
		ADV_AM			<=	"00" when state=DOWN_ADV_AM else
							"01" when state=UP_ADV_AM else
							"11";
		DATAOUT			<=	'1' when state=OUTDATA else
							'0';
		READY			<=	'1' when state=INIT or 
								state=P_WAITDATA or 
								state=RESET_P else
							'0';
		
		
end behavior;