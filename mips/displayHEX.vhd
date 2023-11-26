library ieee;
use ieee.std_logic_1164.all;

entity displayHEX	 is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 4;
				larguraEnderecos : natural := 9
  );
  port   (
	 Data_IN: in std_logic_vector(larguraDados-1 downto 0);
	 --saída da displayHEX
	 Entrada_HEX: out std_logic_vector(6 downto 0)
);
end entity;


architecture arquitetura of displayHEX is
	signal entrada_displayHEX: std_logic_vector(6 downto 0);
	


begin

			 
DECODER_HEX0 :  entity work.conversorHex7Seg
        port map(dadoHex => Data_IN,
                 saida7seg => entrada_displayHEX);
					  
					  
Entrada_HEX <= entrada_displayHEX;					  
end architecture;