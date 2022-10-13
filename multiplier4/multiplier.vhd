
-- multiplier.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
	port(
      A, B	: in std_logic_vector(3 downto 0); 		-- operands
      P		: out std_logic_vector(7 downto 0) 	-- final result
	  );
end entity;


architecture behavior of multiplier is
  begin
    P <= std_logic_vector(unsigned(A) * unsigned(B));
end behavior;