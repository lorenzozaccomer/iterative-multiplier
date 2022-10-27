
-- TEST_Multiplier.vhdl

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity TEST_Multiplier is
	generic(
		N 	: integer := 4;
		M 	: integer := 2);
	port( 
		A_CM : in  STD_LOGIC_VECTOR (3 downto 0);
        B_CM : in  STD_LOGIC_VECTOR (3 downto 0);
        P_CM : out  STD_LOGIC_VECTOR (7 downto 0)
		);
end TEST_Multiplier;


architecture b of TEST_Multiplier is

	component basic_multiplier is
		port(
		  A, B	: in std_logic_vector(1 downto 0); 	-- operands
		  P		: out std_logic_vector(3 downto 0) 	-- final result
		  );
	end component;
	
	signal mL , mH , nL, nH: std_logic_vector (1 downto 0);
	signal mL_nL ,mH_nL ,mL_nH,mH_nH  :std_logic_vector (3 downto 0);
	signal mH_nH2: std_logic_vector (5 downto 0);
	
	signal first,second,third,fourth,answer : integer;	
	
	begin
	mL <= A_CM(1 downto 0);
	mH <= A_CM(3 downto 2);
	nL <= B_CM(1 downto 0);
	nH <= B_CM(3 downto 2);
	
	m00 :basic_multiplier port map(mL,nL,mL_nL);
	m01 :basic_multiplier port map(mH,nL,mH_nL);
	m02 :basic_multiplier port map(mL,nH,mL_nH);
	m03 :basic_multiplier port map(mH,nH,mH_nH);

	mH_nH2(3 downto 0) <= mH_nH(3 downto 0);

	first <= to_integer(unsigned(mL_nL));
	second <= to_integer(unsigned(mH_nL));
	third <= to_integer(unsigned(mL_nH));

	fourth <= to_integer(shift_left(unsigned(mH_nH2),3));

	answer <= first+(second+third)*256+fourth;

	P_CM <=std_logic_vector(to_signed(answer,8));
end b;
	
	
	
	