
-- reg.vhdl

-- libraries
library ieee;
use ieee.std_logic_1164.all;

entity reg is
	generic(
	  N 	: integer := 4 );
	port(
		CLK, RST_N, LOAD : in std_logic;
		D : in std_logic_vector(N-1 downto 0);
		Q : out std_logic_vector(N-1 downto 0)
	);
end reg;

architecture behavior of reg is
	begin
	process(CLK, RST_N)
	begin
		if(RST_N = '0') then
			Q <= (others => '0');
		elsif rising_edge(CLK) and LOAD='1' then
			Q <= D;
		end if;
	end process;
end behavior;
