
-- reg_testbench.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

-- interface
entity testbench is
	generic(N 	: integer := 4);
end testbench;

-- architecture
architecture reg_testbench of testbench is

	-- constants
	constant CLK_SEMIPERIOD0: time := 10 ns;
	constant CLK_SEMIPERIOD1: time := 15 ns;
	constant CLK_PERIOD : time := CLK_SEMIPERIOD0+CLK_SEMIPERIOD1;
	constant RESET_TIME : time := 3*CLK_PERIOD + 2 ns;
	
	-- signals for debugging and tb control
	 signal count : std_logic_vector(N downto 0) := (others=> '0');
	 signal int_count : integer := 0;
	 signal start : integer := 0;
	 signal done : integer := 0;
	 signal counter_data : std_logic_vector(N downto 0) := (others=> '0');
	 signal int_counter_data : integer := 0;

	-- signals for DUT
	signal CLK, RST: std_logic;
	signal LOAD: std_logic := '0';
	signal D: std_logic_vector(N-1 downto 0) := (others=> '0');
	signal Q: std_logic_vector(N-1 downto 0);
	
	-- DUT declaration
	component reg is
	port(
		CLK, RST, LOAD : in std_logic;
		D : in std_logic_vector(N-1 downto 0);
		Q : out std_logic_vector(N-1 downto 0)
	);
	end component;
	
	begin
	
	DUT : reg
	port map(
		CLK => CLK,
		RST => RST,
		LOAD => LOAD,
		D => D,
		Q => Q
		);
		
	-- RESET
	reset_process : process
	begin
		RST <= '0';
		wait for 1 ns;
		RST <= '1';
		wait for RESET_TIME;
		RST <= '0';
		start <= 1;
		wait;
	end process reset_process;
	

	-- read from datafile
	 read_file_process: process(CLK)
		 file infile : TEXT open READ_MODE is "C:\Users\lorenzo uni\Desktop\repositories\calcolatori-elettronici\modules\register\data.txt";
		 variable inputline : LINE;
		 variable in_D : bit_vector(D'range);
		 variable in_LOAD : bit;
	 begin
		 if (CLK='0') and (start = 1) then
		 -- read new data from file
			if not endfile(infile) then
				readline(infile, inputline);
				read(inputline, in_D); D <= to_UX01(in_D);
				readline(infile, inputline);
				read(inputline, in_LOAD); LOAD <= to_UX01(in_LOAD);
				readline(infile, inputline); -- separator (empty line)
				counter_data <= std_logic_vector(unsigned(counter_data) + 1);
				int_counter_data <= int_counter_data + 1;
			else
				done <= 1;
			end if;
		 end if;
	 end process read_file_process;

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
		end process done_process;
	
	-- CLOCK
	CLK_process: process
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
		end process CLK_process;
	
end reg_testbench;