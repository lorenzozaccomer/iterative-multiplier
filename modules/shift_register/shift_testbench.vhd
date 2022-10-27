
-- shift_testbench.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- interface
entity testbench is
	generic(N 	: integer := 4);
end testbench;

-- architecture
architecture shift_testbench of testbench is

	-- constantss
	constant CLK_SEMIPERIOD0: time := 10 ns;
	constant CLK_SEMIPERIOD1: time := 10 ns;
	constant CLK_PERIOD : time := CLK_SEMIPERIOD0+CLK_SEMIPERIOD1;

	-- signals for DUT
	signal CLK, RST, SH_ENABLE: std_logic;
	signal D: std_logic_vector(N-1 downto 0);
	signal Q: std_logic_vector(N-1 downto 0);
	
	-- DUT declaration
	component shift is
	port(
		CLK, RST, SH_ENABLE : in std_logic;
		D : in std_logic_vector(N-1 downto 0);
		Q : out std_logic_vector(N-1 downto 0)
	);
	end component;
	
	begin
	
	DUT : shift
	port map(
		CLK => CLK,
		RST => RST,
		SH_ENABLE => SH_ENABLE,
		D => D,
		Q => Q
		);
		
	-- RESET
	reset_process : process
	begin
		RST <= '0';
		wait for 1 ns;
		RST <= '1';
		wait for 3 ns;
		RST <= '0';
		wait;
	end process reset_process;		
	
	-- SHIFT
	shift_process : process
	begin
		SH_ENABLE <= '1';
		wait for 1 ns;
		SH_ENABLE <= '0';
		wait for 3 ns;
		SH_ENABLE <= '1';
		wait;
	end process shift_process;
	
	process is
	begin
		D <= "1011";
		wait for 10 ns;
		D <= "1001";
		wait for 10 ns;
		D <= "0111";
		wait for 10 ns;
		-- D <= "0011";
		-- LOAD <= '1';
	end process;	
	
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
	
end shift_testbench;