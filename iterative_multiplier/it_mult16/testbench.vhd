
-- testbench.vhd

-- for iterative multiplier 16

----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;


entity tb is
	generic(
		N	: integer := 16;
		M	: integer := 8;
		P	: integer := 4
		);
end tb;

architecture behavior of tb is

	constant CLK_SEMIPERIOD0: 	time := 25 ns;
	constant CLK_SEMIPERIOD1: 	time := 25 ns;
	constant CLK_PERIOD: 		time := CLK_SEMIPERIOD0+CLK_SEMIPERIOD1;
	constant RESET_TIME:		time := 3*CLK_PERIOD + 9 ns;
	
		-- signals for debugging and tb control
	signal count: 				std_logic_vector(2*M-1 downto 0) := (others=> '0');
	signal int_count: 			integer := 0;
	signal start: 				integer := 0;
	signal done: 				integer := 0;
	signal counter_data: 		std_logic_vector(2*M-1 downto 0) := (others=> '0');
	signal int_counter_data: 	integer := 0;
	 
		-- signals for DUT
	signal CLK, RST: 			std_logic;
	signal A_M:					std_logic_vector(N-1 downto 0)	:= (others=>'0');
	signal B_M:					std_logic_vector(N-1 downto 0)	:= (others=>'0');
	signal OUT_MULT16:			std_logic_vector(2*N-1 downto 0):= (others=>'0');
	signal DATAIN:				std_logic	:= '0';
	signal DATAOUT:				std_logic;
	signal READY:				std_logic;
		
	
	type seq_array is array (natural range <>) of std_logic_vector(1 downto 0);
	
	component it_mult16 is
	generic(
		N	: integer := 16;
		M	: integer := 8;
		P	: integer := 4
		);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- data inputs
			A_M:			in std_logic_vector(N-1 downto 0);
			B_M:			in std_logic_vector(N-1 downto 0);
				-- data outputs
			OUT_MULT16:		out std_logic_vector(2*N-1 downto 0);
				-- control signal to/from extern
			DATAIN:			in std_logic;	-- new data to manipulate
			DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
			READY:			out std_logic	-- m_sel can accept new data input
		);
	end component;
	
	begin
	DUT: it_mult16
		port map(CLK, RST,
			A_M,
			B_M,
			OUT_MULT16,
			DATAIN,
			DATAOUT,
			READY
		);
	
	
	-- read from datafile
	read_file_process: process(CLK)
		file infile: 			TEXT open READ_MODE is 
		"C:\Users\lorenzo uni\Desktop\repositories\calcolatori-elettronici\iterative_multiplier\it_mult16\inputdata.txt";
		variable inputline: 	LINE;
		variable in_A:			bit_vector(A_M'range);
		variable in_B:			bit_vector(B_M'range);
		variable in_DATAIN: 	bit;
	begin
		if (CLK = '0') and (start = 1) and (READY = '1') then
		-- read new data from file
			if not endfile(infile) then
				readline(infile, inputline);
				read(inputline, in_A); A_M <= to_UX01(in_A);
				readline(infile, inputline);
				read(inputline, in_B); B_M <= to_UX01(in_B);
				readline(infile, inputline);
				read(inputline, in_DATAIN); DATAIN <= to_UX01(in_DATAIN);
				counter_data<= std_logic_vector(unsigned(counter_data)+1);
				int_counter_data <= int_counter_data + 1;
			else
				done <= 1;
			end if;
		end if;
				
	end process;
	
	-- terminate the simulation when there are no more data in datafile
	done_process: process(done)
	variable outputline : LINE;
	begin
		if (done=1) then
			write(outputline, string'("End simulation - "));
			write(outputline, string'("cycle counter is "));
			write(outputline, int_count);
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