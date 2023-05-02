
-- testbench.vhdl for mult8

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
		N 	: integer := 4
	);
end tb;


-- architecture
architecture behavior of tb is
	
		-- signals for debugging and tb control
	signal count: 				std_logic_vector(2*M-1 downto 0) := (others=> '0');
	signal done: 				integer := 0;
	signal counter_data: 		std_logic_vector(2*M-1 downto 0) := (others=> '0');
	signal int_counter_data: 	integer := 0;
	
	signal DATAIN:				std_logic	:= '0';
		
	signal A: std_logic_vector(N-1 downto 0);
	signal B: std_logic_vector(N-1 downto 0);
	signal P: std_logic_vector(2*N-1 downto 0);

	component mult8 is
		generic(
		  N 	: integer := 4);
		port( 
		  A   		: in std_logic_vector(N-1 downto 0);
		  B   		: in std_logic_vector(N-1 downto 0);
		  P   		: out std_logic_vector(2*N-1 downto 0)
		  );
	end component;
      
	begin
  
	DUT : mult8
	port map(
		A, 
		B, 
		P
	);
	
	
	-- read from datafile
	read_process: process is
		file infile: 			TEXT open READ_MODE is 
		"C:\Users\lorenzo uni\Desktop\repositories\calcolatori-elettronici\tester\mult8\inputdata.txt";
		variable inputline: 	LINE;
		variable in_A:			bit_vector(A'range);
		variable in_B:			bit_vector(B'range);
		variable in_DATAIN: 	bit;
		
		--
		file outputfile:	TEXT open WRITE_MODE is 
		"C:\Users\lorenzo uni\Desktop\repositories\calcolatori-elettronici\tester\mult8\result.txt";
		variable outputline: 	LINE;
		
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
			
			wait for 10 ns;
			write(outputline, A);
			writeline(outputfile, outputline);
			write(outputline, B);
			writeline(outputfile, outputline);
			write(outputline, P);
			writeline(outputfile, outputline);
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
	
end behavior;
