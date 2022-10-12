
-- multiplier.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
  port(
      A,B: in std_logic_vector(3 downto 0);
      R: out std_logic_vector(7 downto 0) );
end entity;


architecture behavior of multiplier is
  
  begin
    R <= std_logic_vector(unsigned(A) * unsigned(B));

end behavior;