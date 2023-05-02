
-- mult8.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult8 is
	generic(
	  N 	: integer := 4);
	port(
      A			: in std_logic_vector(N-1 downto 0); 	-- operand
      B			: in std_logic_vector(N-1 downto 0); 	-- operand
      P			: out std_logic_vector(2*N-1 downto 0) 	-- final result
	  );
end entity;


architecture struct of mult8 is
  begin
		P <= std_logic_vector(unsigned(A) * unsigned(B));
end struct;