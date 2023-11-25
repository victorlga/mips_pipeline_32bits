library ieee;
use ieee.std_logic_1164.all;

entity unidadeControleULA is
    port (
      opcode  : in std_logic_vector(5 downto 0);
		funct   : in std_logic_vector(5 downto 0);
		tipoR	  : in std_logic;
		ULActrl : out std_logic_vector(3 downto 0)
    );
end entity;

architecture comportamento of unidadeControleULA is

	 signal funct_dec : std_logic_vector(3 downto 0);
	 signal opcode_dec : std_logic_vector(3 downto 0);
	 
	 constant ANND: std_logic_vector(5 downto 0) := "100100";
	 constant ORR : std_logic_vector(5 downto 0) := "100101";
	 constant ADD : std_logic_vector(5 downto 0) := "100000";
	 constant SUB : std_logic_vector(5 downto 0) := "100010";
	 constant SLT : std_logic_vector(5 downto 0) := "101010";
	 constant NORR: std_logic_vector(5 downto 0) := "100111";
	 
	 constant LW  : std_logic_vector(5 downto 0) := "100011";
	 constant SW  : std_logic_vector(5 downto 0) := "101011";
	 constant BEQ : std_logic_vector(5 downto 0) := "000100";
	 
	 constant JMP : std_logic_vector(5 downto 0) := "000010";
	 
    begin
			
			funct_dec  <= "0000" when funct = ANND else
							  "0001" when funct = ORR  else
							  "0010" when funct = ADD  else
							  "0110" when funct = SUB  else
							  "0111" when funct = SLT  else
							  "1100" when funct = NORR else
							  "0000";
							  
			opcode_dec <= "0010" when opcode = LW  else
							  "0010" when opcode = SW  else
							  "0110" when opcode = BEQ else
							  "0000" when opcode = JMP else
							  "0000";
			
			ULActrl <= funct_dec when (tipoR = '1') else opcode_dec;
			
end architecture;