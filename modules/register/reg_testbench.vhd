
-- reg_testbench.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- interface
entity testbench is
	generic(
	  N 	: integer := 4 );
end testbench;

-- architecture
architecture reg_testbench of testbench is

	-- constantss
	constant CLK_SEMIPERIOD0: time := 25 ns;
	constant CLK_SEMIPERIOD1: time := 15 ns;
	constant CLK_PERIOD : time := CLK_SEMIPERIOD0+CLK_SEMIPERIOD1;

	-- signals for DUT
	signal CLK, RST, LOAD: std_logic;
	signal D, Q: std_logic_vector(N-1 downto 0);
	
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
		RST <= '1';
		wait for 1 ns;
		RST <= '0';
		wait for 3 ns;
		rst <= '1';
		wait;
	end process reset_process;
	
	
	-- CLOCK
	clk_process: process
	begin
		if CLK = '0' then
			CLK <= '1';
			wait for CLK_SEMIPERIOD1;
		else
			CLK <= '0';
			wait for CLK_SEMIPERIOD0;
		end if;
	end process clk_process;
		
	