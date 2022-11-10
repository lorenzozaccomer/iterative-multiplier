
-- adder.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity adder is
	generic(N 	: integer := 4);
	port(
      A_sum, B_sum	: in std_logic_vector(N-1 downto 0); 	-- operands
      Sum			: out std_logic_vector(N downto 0) 	-- final result
	  );
end entity;


architecture behavior of adder is

	signal Sum_int : std_logic_vector(N downto 0);

	begin
	Sum_int <= std_logic_vector( 
				unsigned('0' & A_sum) + 
				unsigned('0' & B_sum)	);
				
	Sum <= Sum_int;
end behavior;