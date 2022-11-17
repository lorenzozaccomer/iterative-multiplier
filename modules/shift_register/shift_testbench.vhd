
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

	signal X: std_logic_vector(N-1 downto 0);
	signal Y: std_logic_vector(N-1 downto 0);
	
	-- DUT declaration
	component shift is
	port(
		X : in std_logic_vector(N-1 downto 0);
		Y : out std_logic_vector(N-1 downto 0)
	);
	end component;
	
	begin
	
	DUT : shift
	port map(
		X => X,
		Y => Y
		);
		
	process is
	begin
		X <= "1011";
		wait for 10 ns;
		X <= "1001";
		wait for 10 ns;
		X <= "0111";
		wait for 10 ns;
		-- X <= "0011";
		-- LOAD <= '1';
	end process;	
		
end shift_testbench;