
-- shift_register.vhdl

-- libraries
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	-- needed to shift op
-- use ieee.std_logic_arith.all;
-- use ieee.std_logic_usigned.all;

entity shift is
	generic(
	  N 	: integer := 4 );
	port( 
		CLK, RST, SH_ENABLE: in std_logic;
		D: in std_logic_vector(N-1 downto 0);
		Q: out std_logic_vector(N-1 downto 0)
	);
end entity;

architecture behavior of shift is
	begin
		process(CLK, RST)
		begin
			if rising_edge(CLK) then
				if RST = '1' then			-- clear
					Q <= (others => '0');
				elsif SH_ENABLE = '1' then	-- shift
					Q <= std_logic_vector(shift_left(unsigned(D), 1));
				end if;
			end if;
		end process;
end behavior;