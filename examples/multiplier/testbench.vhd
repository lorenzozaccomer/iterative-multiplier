
-- testbench.vhdl for multiplier

library ieee;
use ieee.std_logic_1164.all;

entity testbench is
end testbench;

architecture s of testbench is
  signal SIG1: std_logic_vector := '0000';
  signal SIG2: std_logic_vector := '0000';
  signal SIG_RES: std_logic_vector;
  
  component multiplier is
    port( 
      A   : in std_logic_vector,
      B   => SIG2,
      R   => SIG_RES  );
  end multiplier;
      
begin
  
  
