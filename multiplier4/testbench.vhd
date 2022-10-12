
-- testbench.vhdl for multiplier

library ieee;
use ieee.std_logic_1164.all;

entity testbench is
end testbench;

architecture s of testbench is
  signal SIG1: std_logic_vector(3 downto 0);
  signal SIG2: std_logic_vector(3 downto 0);
  signal SIG_RES: std_logic_vector(7 downto 0);
  
  component multiplier is
    port( 
      A   : in std_logic_vector(3 downto 0);
      B   : in std_logic_vector(3 downto 0);
      R   : out std_logic_vector(7 downto 0)  );
  end component multiplier;
      
begin
  
	multiplier_INST : multiplier
	port map(
		A	=> SIG1,
		B	=> SIG2,
		R	=> SIG_RES	);
	
	process is
	begin
		SIG1 <= "0000";
		SIG2 <= "0000";
		wait for 10 ns;
		SIG1 <= "0001";
		SIG2 <= "0001";
		wait for 10 ns;
		SIG1 <= "1011";
		SIG2 <= "0010";
		wait for 10 ns;
	end process;
	
end s;
