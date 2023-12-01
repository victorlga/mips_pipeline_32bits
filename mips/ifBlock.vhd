library ieee;
use ieee.std_logic_1164.all;

entity ifBlock is
    generic (larguraDados        : natural := 32);
    port (CLK        		 	: in std_logic;
			 proxEndJR			 	: in std_logic_vector(larguraDados-1 downto 0);
			 
			 EndMais4				: out std_logic_vector(larguraDados-1 downto 0);
			 ROMsaida				: out std_logic_vector(larguraDados-1 downto 0);
			 Endereco 				: out std_logic_vector(larguraDados-1 downto 0));
end entity;

architecture arquitetura of ifBlock is
		
		signal Endereco_local : std_logic_vector(larguraDados-1 downto 0);
		
	begin
		
		-- Define a entidade que implementa o program counter.
		PROGRAM_COUNTER : entity work.registradorGenerico
			generic map (larguraDados => larguraDados)
			port map (DIN 		=> proxEndJR,
						 DOUT 	=> Endereco_local,
						 ENABLE 	=> '1',
						 CLK 		=> CLK,
						 RST 		=> '0');
		
		-- Define a entidade que implementa a soma de 4 ao endereço atual.
		SOMA_CONST_4 : entity work.somaConstante
			generic map (larguraDados 	=> larguraDados,
							 constante 		=> 4)
			port map (entrada => Endereco_local,
						 saida 	=> EndMais4);
	
		-- Define a entidade que implementa a ROM.
		ROM : entity work.ROMMIPS
			generic map (dataWidth 			=> larguraDados,
							 addrWidth 			=> larguraDados,
							 memoryAddrWidth 	=> 6)
			port map (Endereco 	=> Endereco_local,
						 Dado 		=> ROMsaida);
					 
		Endereco <= Endereco_local;
		
end architecture;