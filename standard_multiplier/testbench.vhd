
-- testbench.vhdl for basic_multiplier

-- libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;


-- interface
entity tb is
	generic(
		M	: integer := 8;
		N 	: integer := 16
	);
end tb;


-- architecture
architecture behavior of tb is

	-- constant CLK_SEMIPERIOD0: 	time := 25 ns;
	-- constant CLK_SEMIPERIOD1: 	time := 25 ns;
	-- constant CLK_PERIOD: 		time := CLK_SEMIPERIOD0+CLK_SEMIPERIOD1;
	-- constant RESET_TIME:		time := 3*CLK_PERIOD + 9 ns;
	
		-- signals for debugging and tb control
	signal count: 				std_logic_vector(2*M-1 downto 0) := (others=> '0');
	signal int_count: 			integer := 0;
	signal start: 				integer := 0;
	signal done: 				integer := 0;
	signal counter_data: 		std_logic_vector(2*M-1 downto 0) := (others=> '0');
	signal int_counter_data: 	integer := 0;
	
	signal DATAIN:				std_logic	:= '0';
	signal DATAOUT:				std_logic	:= '0';
		
	signal A: std_logic_vector(N-1 downto 0);
	signal B: std_logic_vector(N-1 downto 0);
	signal P: std_logic_vector(2*N-1 downto 0);

	component basic_multiplier is
		generic(
		  N 	: integer := 16);
		port( 
		  A   		: in std_logic_vector(N-1 downto 0);
		  B   		: in std_logic_vector(N-1 downto 0);
		  P   		: out std_logic_vector(2*N-1 downto 0)
		  );
	end component;
      
	begin
  
	DUT : basic_multiplier
	port map(
		A, 
		B, 
		P
	);
	
	
	-- read from datafile
	read_process: process is
		file infile: 			TEXT open READ_MODE is 
		"C:\Users\lorenzo uni\Desktop\repositories\calcolatori-elettronici\standard_multiplier\inputdata.txt";
		variable inputline: 	LINE;
		variable in_A:			bit_vector(A'range);
		variable in_B:			bit_vector(B'range);
		variable in_DATAIN: 	bit;
		begin
			if not endfile(infile) then
				readline(infile, inputline);
				read(inputline, in_A); A <= to_UX01(in_A);
				readline(infile, inputline);
				read(inputline, in_B); B <= to_UX01(in_B);
				readline(infile, inputline);
				read(inputline, in_DATAIN); DATAIN <= to_UX01(in_DATAIN);
				counter_data<= std_logic_vector(unsigned(counter_data)+1);
				int_counter_data <= int_counter_data + 1;
			else
				done <= 1;
			end if;
			wait for 200 ns;
	end process;
	
	
			-- write result on output file
	-- write_result_process: process is
		-- file outputfile:			TEXT open WRITE_MODE is 
		-- "C:\Users\lorenzo uni\Desktop\repositories\calcolatori-elettronici\standard_multiplier\result.txt";
		-- variable inputline: 	LINE;
	-- begin
		-- if (DATAOUT = '1') then
		-- -- write result
				-- write(inputline, A);
				-- writeline(outputfile, inputline);
				-- write(inputline, B);
				-- writeline(outputfile, inputline);
				-- write(inputline, P);
				-- writeline(outputfile, inputline);
		-- end if;
	-- end process;
	
	
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
	
end behavior;
