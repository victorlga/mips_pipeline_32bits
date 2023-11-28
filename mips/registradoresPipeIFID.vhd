library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registradoresPipeIFID is
    generic (
        larguraDados : natural := 8
    );
    port ( clk				: in std_logic;
			  EndMais4_in 	: in std_logic_vector(larguraDados-1 downto 0);
			  EndMais4_out : out std_logic_vector(larguraDados-1 downto 0);
			  ROMsaida_in 	: in std_logic_vector(larguraDados-1 downto 0);
			  ROMsaida_out : out std_logic_vector(larguraDados-1 downto 0));
end entity;

architecture comportamento of registradoresPipeIFID is
	begin
	
		END_MAIS_4 : entity work.registradorGenerico
			generic map (larguraDados => larguraDados)
			port map (DIN 		=> EndMais4_in,
						 DOUT 	=> EndMais4_out,
						 ENABLE 	=> clk,
						 CLK 		=> clk,
						 RST 		=> '0');
						 
		ROM_SAIDA : entity work.registradorGenerico
			generic map (larguraDados => larguraDados)
			port map (DIN 		=> ROMsaida_in,
						 DOUT 	=> ROMsaida_out,
						 ENABLE 	=> clk,
						 CLK 		=> clk,
						 RST 		=> '0');
	
end architecture;