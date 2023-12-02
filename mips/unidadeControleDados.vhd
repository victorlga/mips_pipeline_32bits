library ieee;
use ieee.std_logic_1164.all;

entity unidadeControleDados is
    port (
      opcode : in std_logic_vector(5 downto 0);
		funct  : in std_logic_vector(5 downto 0);
		sinal_controle : out std_logic_vector(13 downto 0)
    );
end entity;

architecture comportamento of unidadeControleDados is

	 constant R   : std_logic_vector(5 downto 0) := "000000";
	 
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
	 constant JR  : std_logic_vector(5 downto 0) := 6x"8";
	 
    begin
			sinal_controle  <= "10" & "00" & "000" & '1' & "00" & "00" & "00" when opcode = R and funct = JR   else
									 "00" & "01" & "010" & '1' & "00" & "00" & "00" when opcode               = R    else
									 "00" & "00" & "011" & '0' & "01" & "00" & "10" when opcode               = LW   else
									 "00" & "00" & "001" & '0' & "01" & "00" & "01" when opcode               = SW   else
									 
									 "00" & "00" & "000" & '0' & "00" & "10" & "00" when opcode               = BEQ  else
									 "00" & "00" & "000" & '0' & "00" & "01" & "00" when opcode               = BNE  else
									 
									 "01" & "00" & "000" & '0' & "00" & "00" & "00" when opcode               = JMP  else
									 "01" & "10" & "010" & '0' & "10" & "00" & "00" when opcode               = JAL  else
									 
									 "00" & "00" & "011" & '0' & "00" & "00" & "00" when opcode               = ADDI else
									 "00" & "00" & "111" & '0' & "00" & "00" & "00" when opcode               = ORI  else
									 "00" & "00" & "111" & '0' & "00" & "00" & "00" when opcode               = ANDI else
									 "00" & "00" & "011" & '0' & "11" & "00" & "00" when opcode               = LUI  else
									 "00" & "00" & "011" & '0' & "00" & "00" & "00" when opcode               = SLTI else
									 "00" & "00" & "000" & '0' & "00" & "00" & "00";
			
end architecture;