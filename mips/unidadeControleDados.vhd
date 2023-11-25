library ieee;
use ieee.std_logic_1164.all;

entity unidadeControleDados is
    port (
      opcode : in std_logic_vector(5 downto 0);
		sinal_controle : out std_logic_vector(8 downto 0)
    );
end entity;

architecture comportamento of unidadeControleDados is

	 constant R   : std_logic_vector(5 downto 0) := "000000";
	 
	 constant LW  : std_logic_vector(5 downto 0) := "100011";
	 constant SW  : std_logic_vector(5 downto 0) := "101011";
	 constant BEQ : std_logic_vector(5 downto 0) := "000100";
	 
	 constant JMP : std_logic_vector(5 downto 0) := "000010";
	 
    begin
			sinal_controle  <= "011010000" when opcode = R   else
									 "001101010" when opcode = LW  else
									 "000101001" when opcode = SW  else
									 "000000100" when opcode = BEQ else
									 "100000000" when opcode = JMP else
									 "000000000";
			
end architecture;