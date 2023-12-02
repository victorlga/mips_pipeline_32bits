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
	 
	 constant ANND: std_logic_vector(5 downto 0) := 6x"24";
	 constant ORR : std_logic_vector(5 downto 0) := 6x"25";
	 constant ADD : std_logic_vector(5 downto 0) := 6x"20";
	 constant SUB : std_logic_vector(5 downto 0) := 6x"22";
	 constant SLT : std_logic_vector(5 downto 0) := 6x"2a";
	 constant NORR: std_logic_vector(5 downto 0) := 6x"27";
	 
	 constant LW  : std_logic_vector(5 downto 0) := 6x"23";
	 constant SW  : std_logic_vector(5 downto 0) := 6x"2b";
	 constant BEQ : std_logic_vector(5 downto 0) := 6x"4";
	 constant BNE : std_logic_vector(5 downto 0) := 6x"5";
	 
	 constant ADDI: std_logic_vector(5 downto 0) := 6x"8";
	 constant ORI : std_logic_vector(5 downto 0) := 6x"d";
	 constant ANDI: std_logic_vector(5 downto 0) := 6x"c";
	 constant LUI : std_logic_vector(5 downto 0) := 6x"f";
	 constant SLTI: std_logic_vector(5 downto 0) := 6x"a";
	 
	 constant JMP : std_logic_vector(5 downto 0) := 6x"2";
	 constant JAL : std_logic_vector(5 downto 0) := 6x"3";
	 
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
							  "0110" when opcode = BNE else
							  "0000" when opcode = JMP else
							  "0000" when opcode = JAL else
							  "0010" when opcode = ADDI else
							  "0001" when opcode = ORI else
							  "0000" when opcode = ANDI else
							  "0000" when opcode = LUI else
							  "0111" when opcode = SLTI else
							  "0000";
			
			ULActrl <= funct_dec when (tipoR = '1') else opcode_dec;
			
end architecture;