
-- standard_multiplier.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity standard_multiplier is
	generic(
	  N 	: integer := 32);
	port(
      A			: in std_logic_vector(N-1 downto 0); 	-- operand
      B			: in std_logic_vector(N-1 downto 0); 	-- operand
      P			: out std_logic_vector(2*N-1 downto 0) 	-- final result
	  );
end entity;


architecture struct of standard_multiplier is
  begin
		P <= std_logic_vector(unsigned(A) * unsigned(B));
end struct;