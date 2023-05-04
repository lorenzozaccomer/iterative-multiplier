
-- testbench16.vhd

-- for multilplier resolver module

----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;


entity tb32 is
	generic(
		N	: integer := 32;
		M	: integer := 8
		);
end tb32;

architecture behavior of tb32 is

	constant CLK_SEMIPERIOD0: 	time := 25 ns;
	constant CLK_SEMIPERIOD1: 	time := 25 ns;
	constant CLK_PERIOD: 		time := CLK_SEMIPERIOD0+CLK_SEMIPERIOD1;
	constant RESET_TIME:		time := 3*CLK_PERIOD + 9 ns;
	
		-- signals for debugging and tb32 control
	signal count: 				std_logic_vector(2*M-1 downto 0) 	:= (others=> '0');
	signal int_count: 			integer 							:= 0;
	signal start: 				integer 							:= 0;
	signal done: 				integer 							:= 0;
	signal counter_data: 		std_logic_vector(2*M-1 downto 0) 	:= (others=> '0');
	signal int_counter_data: 	integer 							:= 0;
	 
		-- signals for DUT
	signal CLK, RST: 			std_logic;
	signal OUT_BM:				std_logic_vector(M-1 downto 0)		:= (others=>'0');
	signal RESULT:				std_logic_vector(2*N-1 downto 0)	:= (others=>'0');
	signal DATAIN:				std_logic							:= '0';
	signal ADV_AM:				std_logic_vector(1 downto 0)		:= "00";
	signal NW_PRD:				std_logic							:= '0';
	signal DATAOUT:				std_logic;
	signal READY:				std_logic;
				
	component resolver is
	generic(
		N			: integer := 16;
		DIM_CNT		: integer := 3;
		M			: integer := 8;
		REPETITION	: integer := 4
		);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- data inputs
			OUT_BM:			in std_logic_vector(M-1 downto 0);
				-- data outputs
			RESULT:			out std_logic_vector(2*N-1 downto 0);
				-- control signal to/from extern
			DATAIN:			in std_logic;
			NW_PRD:			in std_logic;
			ADV_AM:			out std_logic_vector (1 downto 0);
			DATAOUT:		out std_logic;
			READY:			out std_logic
		);
	end component;
	
	begin
	DUT: resolver
		generic map(
			N => 32,
			REPETITION => 8
		)
		port map(CLK, RST,
			OUT_BM,
			RESULT,
			DATAIN,
			NW_PRD,
			ADV_AM,
			DATAOUT,
			READY
		);
	
	
	-- read from datafile
	read_file_process: process(CLK)
		file infile: 			TEXT open READ_MODE is 
		"C:\Users\lorenzo uni\Desktop\repositories\calcolatori-elettronici\iterative_multiplier\it_mult64\modules64\resolver\inputdata32.txt";
		variable inputline: 	LINE;
		variable in_A:			bit_vector(OUT_BM'range);
		variable in_DATAIN: 	bit;
	begin
		if (CLK = '0') and (start = 1) and (READY = '1') then
		-- read new data from file
			if not endfile(infile) then
				readline(infile, inputline);
				read(inputline, in_A); OUT_BM <= to_UX01(in_A);
				readline(infile, inputline);
				read(inputline, in_DATAIN); DATAIN <= to_UX01(in_DATAIN);
				counter_data<= std_logic_vector(unsigned(counter_data)+1);
				int_counter_data <= int_counter_data + 1;
			else
				done <= 1;
			end if;
		end if;
		
		if (CLK = '0') and (ADV_AM ="00" or ADV_AM="01") then
			NW_PRD <= '1';
		end if;
		
	end process;
	
	
	
	-- write result on output file
	write_result_process: process(CLK)
		file outputfile:			TEXT open WRITE_MODE is 
		"C:\Users\lorenzo uni\Desktop\repositories\calcolatori-elettronici\iterative_multiplier\it_mult64\modules64\resolver\output32.txt";
		variable inputline: 	LINE;
		variable in_RESULT:		bit_vector(RESULT'range);
	begin
		if (CLK = '0') and (DATAOUT = '1') then
		-- write result
				write(inputline, RESULT);
				writeline(outputfile, inputline);
		end if;
	end process;
	
	-- terminate the simulation when there are no more data in datafile
	done_process: process(done)
	variable outputline : LINE;
	begin
		if (done=1) then
			write(outputline, string'("End simulation - "));
			write(outputline, string'("cycle counter is "));
			write(outputline, int_counter_data);
			writeline(output, outputline);
		assert false
			report "NONE. End of simulation."
			severity failure;
		end if;
	end process;
	
	
	-- START
	start_process: process
	begin
		RST <= '0';
		wait for 1 ns;
		RST <= '1';
		wait for RESET_TIME;
		RST <= '0';
		start <= 1;
		wait;
	end process;
	
			
	-- CLOCK
	clock_process: process
		begin
			if CLK = '0' then
				CLK <= '1';
				wait for CLK_SEMIPERIOD1;
			else
				CLK <= '0';
				wait for CLK_SEMIPERIOD0;
					count <= std_logic_vector(unsigned(count) + 1);
					int_count <= int_count + 1;
			end if;
			if done = 1 then
				wait;
			end if;
		end process;
	
end behavior;