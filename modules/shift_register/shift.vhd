
-- shift.vhdl

-- libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- use ieee.std_logic_arith.all;
-- use ieee.std_logic_usigned.all;

entity shift is
	generic(
	  N 	: integer := 4 );
	port( 
	CLK, RST, LOAD: in std_logic;
	D: in std_logic_vector(N-1 downto 0);
	Q: out std_logic_vector(N-1 downto 0)
	);
end entity;

architecture behavior of shift is
begin
	process(CLK, RST)
	begin
	end process;
end behavior;