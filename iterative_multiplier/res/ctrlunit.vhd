
-- ctrlunit.vhd

-- for multilplier resolver module


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
			loadBM:			out std_logic; -- da togliere
			selBM:			out std_logic; -- da togliere
			loadS1:			out std_logic;
			selS1:			out std_logic;
			loadRS:			out std_logic;
			selRS:			out std_logic_vector(1 downto 0);
			loadS2:			out std_logic;
			selS2:			out std_logic;
			loadACCR:		out std_logic;
			selACCR:		out std_logic;
			loadRES:		out std_logic;
			selRES:			out std_logic;
				-- status signals from datapath
			P_SHIFT:		in std_logic_vector(1 downto 0);
			N_SHIFT:		in std_logic_vector(1 downto 0)
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
			loadBM:			out std_logic; -- da togliere
			selBM:			out std_logic; -- da togliere
			loadS1:			out std_logic;
			selS1:			out std_logic;
			loadRS:			out std_logic;
			selRS:			out std_logic_vector(1 downto 0);
			loadS2:			out std_logic;
			selS2:			out std_logic;
			loadACCR:		out std_logic;
			selACCR:		out std_logic;
			loadRES:		out std_logic;
			selRES:			out std_logic;
				-- status signals from datapath
			P_SHIFT:		in std_logic_vector(1 downto 0);
			N_SHIFT:		in std_logic_vector(1 downto 0)
		);
end entity;




architecture behavior of res_ctrlunit is


	type statetype is (INIT, START, LOAD_DATA, SHIFT1, SUM1, ACC1, UP_ADV_AM,
						INC_P, P_WAITDATA, WAITSELS, SHIFT2, SUM2, ACC2, WAIT2, DOWN_ADV_AM, 
						INC_N, RESET_P, ACC3, OUTDATA, WAIT1, WAIT3, WAITSHIFT);
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
					nextstate <= START;
				end if;
			when START =>
				nextstate <= LOAD_DATA;
			when LOAD_DATA =>
				if P_SHIFT = "00" then	-- b'00 = 0
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
				if P_SHIFT = "11" then	-- b'11 = 3
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
				if N_SHIFT = "00" then	-- b'00 = 0
					nextstate <= SUM2;
				else
					nextstate <= SHIFT2;
				end if;
			when SHIFT2 =>
				nextstate <= SUM2;
			when SUM2 =>
				nextstate <= WAIT2;
			when WAIT2 =>
				nextstate <= ACC2;
				
			when ACC2 =>
				if N_SHIFT = "11" then	-- b11 = 3
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
								state=RESET_P else
							'0';
		selPSHIFT		<=	'0' when state=START or 
								state=RESET_P else
							'1' when state=INC_P;
							
		loadOUTBM		<=	'1' when state=LOAD_DATA else
							'0';
		selOUTBM		<=	'0' when state=LOAD_DATA else
							'1';
							
		-- loadBM			<=	'1' when state=LOAD_DATA else
							-- '0';
		-- selBM			<=	'1' when state=SUM1 else
							-- '0';
							
		loadS1			<=	'1' when state=SUM1 else
							'0';
		selS1			<=	'0' when state=SUM1 else
							'1';
							
		loadRS			<=	'1' when state=ACC1 or 
								state=SHIFT1 or 
								state=START else
							'0';
		selRS			<=	"00" when state=START else
							"01" when state=SHIFT1 else
							"10" when state=ACC1 else
							"11";
							
		loadS2			<=	'1' when state=SUM2 else
							'0';
		selS2			<=	'0' when state=SUM2 else
							'1' when state=ACC2;	
							
		loadACCR		<=	'1' when state=ACC2 else
							'0';
		selACCR			<=	'1' when state=ACC2 else
							'0' when state=ACC3 or
									 state=SUM2;
							
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
		READY			<=	'1' when state=INIT or 
								state=P_WAITDATA or 
								state=RESET_P else
							'0';
		
		
end behavior;