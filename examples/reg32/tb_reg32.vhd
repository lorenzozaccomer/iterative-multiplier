
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

 -- interface 
entity TB is
end TB;

 -- architecture 
architecture tb_reg32 of TB is

 constant CLK_SEMIPERIOD0: time := 25 ns;
 constant CLK_SEMIPERIOD1: time := 15 ns;
 constant CLK_PERIOD : time := CLK_SEMIPERIOD0+CLK_SEMIPERIOD1;
 constant RESET_TIME : time := 3*CLK_PERIOD + 9 ns;
 signal CLK, rst_n : std_logic;
 
 -- signals for debugging and tb control
 signal count : std_logic_vector(23 downto 0) := (others=> '0');
 signal int_count : integer := 0;
 signal start : integer := 0;
 signal done : integer := 0;
 signal counter_data : std_logic_vector(23 downto 0) := (others=> '0');
 signal int_counter_data : integer := 0;
 
 -- signals for DUT (Device Under Test)
 signal load : std_logic := '0';
 signal D : std_logic_vector(31 downto 0);
 signal Q : std_logic_vector(31 downto 0);

 -- DUT declaration
 component reg32 is
 port(
	 CLK, rst_n, load : in std_logic;
	 D : in std_logic_vector(31 downto 0);
	 Q : out std_logic_vector(31 downto 0)	);
 end component;
 
 -- TB architecture definition
begin

 -- DUT instance
 DUT : reg32
 port map(
	 CLK => CLK, 
	 rst_n => rst_n,
	 load => load,
	 D => D,
	 Q => Q  );
	
-- RESET
 start_process: process
 begin
	rst_n <= '1';
 wait for 1 ns;
	rst_n <= '0';
 wait for RESET_TIME;
	rst_n <= '1';
	start <= 1;
 wait;
 end process start_process;

-- read from datafile
 read_file_process: process(clk)
	 file infile : TEXT open READ_MODE is "C:\Users\lorenzo uni\Desktop\repositories\calcolatori-elettronici\examples\reg32\data.txt";
	 variable inputline : LINE;
	 variable in_D : bit_vector(D'range);
	 variable in_load : bit;
 begin
	 if (clk='0') and (start = 1) then
	 -- read new data from file
		if not endfile(infile) then
			readline(infile, inputline);
			read(inputline, in_D); D <= to_UX01(in_D);
			readline(infile, inputline);
			read(inputline, in_load); load <= to_UX01(in_load);
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
	
	
 -- CLOCK generator
clk_process: process
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
	end process clk_process;

end tb_reg32;
