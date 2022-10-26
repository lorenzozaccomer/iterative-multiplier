
-- adder.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity adder is
	generic(
	  N 	: integer := 4 );
	port(
      A_sum, B_sum	: in std_logic_vector(N-1 downto 0); 	-- operands
	  C_in			: in std_logic;							-- carry in
      Sum			: out std_logic_vector(N-1 downto 0); 	-- final result
	  C_out			: out std_logic							-- carry out
	  );
end entity;


architecture behavior of adder is

	signal Sum_int : std_logic_vector(N+1 downto 0);

	begin
	Sum_int <= std_logic_vector( 
				unsigned('0' & A_sum & '1') + 
				unsigned('0' & B_sum & C_in)	);
				
	Sum <= Sum_int(N downto 1);
	C_out <= Sum_int(N+1);
end behavior;