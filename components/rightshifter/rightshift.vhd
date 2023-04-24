
-- shift_register.vhdl

-- libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	-- needed to shift op
-- use ieee.std_logic_arith.all;
-- use ieee.std_logic_usigned.all;

entity rightshiftN is
	generic(
		N: 	integer := 4;
		SH:	integer := 2);
	port( 
		X: in std_logic_vector(N-1 downto 0);
		Y: out std_logic_vector(N-1 downto 0)
	);
end entity;

architecture behavior of rightshiftN is
	begin
		Y <= std_logic_vector(shift_right(unsigned(X), SH)) after 1 ns;
end behavior;