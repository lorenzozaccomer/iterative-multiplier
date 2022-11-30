
-- basic_multiplier.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity basic_multiplier is
	generic(
	  N 	: integer := 4);
	port(
      A, B	: in std_logic_vector(N-1 downto 0); 	-- operands
      P		: out std_logic_vector(2*N-1 downto 0) 	-- final result
	  );
end entity;


architecture behavior of basic_multiplier is
  begin
    P <= std_logic_vector(unsigned(A) * unsigned(B));
end behavior;