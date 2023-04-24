
-- it_mult16.vhdl



----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package it_mult16_package is
	component it_mult16 is
		generic(
			N	: integer := 16;
			M	: integer := 8;
			P	: integer := 4
			);
		port(
			CLK:			in std_logic;
			RST:			in std_logic;
				-- data inputs
			A_M:			in std_logic_vector(N-1 downto 0);
			B_M:			in std_logic_vector(N-1 downto 0);
				-- data outputs
			OUT_MULT16:		out std_logic_vector(2*N-1 downto 0);
				-- control signal to/from extern
			DATAIN:			in std_logic;	-- new data to manipulate
			DATAOUT:		out std_logic;	-- new data for bm_sel are ready to used it
			READY:			out std_logic	-- m_sel can accept new data input
		);
	end component;
end it_mult16_package;
----------------------------------------------------------------------
	