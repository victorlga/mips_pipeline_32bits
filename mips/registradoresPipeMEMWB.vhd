library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registradoresPipeMEMWB is
    generic (
        larguraDados : natural := 8
    );
    port (clk				: in std_logic;
	 
			  EndMais4_in 	: in std_logic_vector(larguraDados-1 downto 0);
			  EndMais4_out : out std_logic_vector(larguraDados-1 downto 0);
			  
			  ULASaida_in	: in std_logic_vector(larguraDados-1 downto 0);
			  ULASaida_out : out std_logic_vector(larguraDados-1 downto 0);
			  
			  sinal_controle_in	: in std_logic_vector(13 downto 0);
			  sinal_controle_out : out std_logic_vector(13 downto 0);
			  
			  RAMsaida_in	: in std_logic_vector(larguraDados-1 downto 0);
			  RAMsaida_out : out std_logic_vector(larguraDados-1 downto 0);
			  
			  endReg3_in	: in std_logic_vector(4 downto 0);
			  endReg3_out : out std_logic_vector(4 downto 0);
			  
			  Imediato16_in	: in std_logic_vector(15 downto 0);
			  Imediato16_out : out std_logic_vector(15 downto 0));
			  
end entity;

architecture comportamento of registradoresPipeMEMWB is
	begin
	
		END_MAIS_4 : entity work.registradorGenerico
			generic map (larguraDados => larguraDados)
			port map (DIN 		=> EndMais4_in,
						 DOUT 	=> EndMais4_out,
						 ENABLE 	=> clk,
						 CLK 		=> clk,
						 RST 		=> '0');
						 
						 
						 
		ULA_SAIDA : entity work.registradorGenerico
			generic map (larguraDados => larguraDados)
			port map (DIN 		=> ULASaida_in,
						 DOUT 	=> ULASaida_out,
						 ENABLE 	=> clk,
						 CLK 		=> clk,
						 RST 		=> '0');
						 
						 
		SINAL_CONTROLE : entity work.registradorGenerico
			generic map (larguraDados => 14)
			port map (DIN 		=> sinal_controle_in,
						 DOUT 	=> sinal_controle_out,
						 ENABLE 	=> clk,
						 CLK 		=> clk,
						 RST 		=> '0');
						 
		RAM_SAIDA : entity work.registradorGenerico
			generic map (larguraDados => larguraDados)
			port map (DIN 		=> RAMsaida_in,
						 DOUT 	=> RAMsaida_out,
						 ENABLE 	=> clk,
						 CLK 		=> clk,
						 RST 		=> '0');
						 
		END_REG_3 : entity work.registradorGenerico
			generic map (larguraDados => 5)
			port map (DIN 		=> endReg3_in,
						 DOUT 	=> endReg3_out,
						 ENABLE 	=> clk,
						 CLK 		=> clk,
						 RST 		=> '0');
						 
		IMEDIATO_16 : entity work.registradorGenerico
			generic map (larguraDados => 16)
			port map (DIN 		=> Imediato16_in,
						 DOUT 	=> Imediato16_out,
						 ENABLE 	=> clk,
						 CLK 		=> clk,
						 RST 		=> '0');
						 
end architecture;