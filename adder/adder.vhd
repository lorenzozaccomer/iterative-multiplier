
-- adder.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity adder is
	generic(
	  N 	: integer := 4 );
	port(
      A_sum, B_sum	: in std_logic_vector(N-1 downto 0); 	-- operands
      Sum			: out std_logic_vector(N downto 0) 		-- final result
	  );
end entity;


architecture behavior of adder is
  begin
    Sum <= std_logic_vector(('0'&unsigned(A_sum)) + unsigned(B_sum));
end behavior;