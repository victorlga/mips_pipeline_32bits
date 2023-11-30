library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registradoresPipeIDEX is
    generic (
        larguraDados : natural := 8
    );
    port ( clk				: in std_logic;
	 
			  EndMais4_in 	: in std_logic_vector(larguraDados-1 downto 0);
			  EndMais4_out : out std_logic_vector(larguraDados-1 downto 0);
			  
			  dadoLidoReg1_in	: in std_logic_vector(larguraDados-1 downto 0);
			  dadoLidoReg1_out : out std_logic_vector(larguraDados-1 downto 0);
			  
			  dadoLidoReg2_in	: in std_logic_vector(larguraDados-1 downto 0);
			  dadoLidoReg2_out : out std_logic_vector(larguraDados-1 downto 0);
			  
			  SigExtIm_in	: in std_logic_vector(larguraDados-1 downto 0);
			  SigExtIm_out : out std_logic_vector(larguraDados-1 downto 0);
				
			  endRegRT_in	: in std_logic_vector(4 downto 0);
			  endRegRT_out : out std_logic_vector(4 downto 0);
			  
			  endRegRD_in	: in std_logic_vector(4 downto 0);
			  endRegRD_out : out std_logic_vector(4 downto 0);
			  
			  sinal_controle_in	: in std_logic_vector(13 downto 0);
			  sinal_controle_out : out std_logic_vector(13 downto 0);
			  
			  opcode_in	: in std_logic_vector(5 downto 0);
			  opcode_out : out std_logic_vector(5 downto 0);
			  
			  funct_in	: in std_logic_vector(5 downto 0);
			  funct_out : out std_logic_vector(5 downto 0);
			  
			  Imediato16_in	: in std_logic_vector(15 downto 0);
			  Imediato16_out : out std_logic_vector(15 downto 0));
			  
end entity;

architecture comportamento of registradoresPipeIDEX is
	begin
	
		END_MAIS_4 : entity work.registradorGenerico
			generic map (larguraDados => larguraDados)
			port map (DIN 		=> EndMais4_in,
						 DOUT 	=> EndMais4_out,
						 ENABLE 	=> '1',
						 CLK 		=> clk,
						 RST 		=> '0');
						 
		DADO_REG_1 : entity work.registradorGenerico
			generic map (larguraDados => larguraDados)
			port map (DIN 		=> dadoLidoReg1_in,
						 DOUT 	=> dadoLidoReg1_out,
						 ENABLE 	=> '1',
						 CLK 		=> clk,
						 RST 		=> '0');
						 
		DADO_REG_2 : entity work.registradorGenerico
			generic map (larguraDados => larguraDados)
			port map (DIN 		=> dadoLidoReg2_in,
						 DOUT 	=> dadoLidoReg2_out,
						 ENABLE 	=> '1',
						 CLK 		=> clk,
						 RST 		=> '0');
						 
		SINAL_EXT_IMED : entity work.registradorGenerico
			generic map (larguraDados => larguraDados)
			port map (DIN 		=> SigExtIm_in,
						 DOUT 	=> SigExtIm_out,
						 ENABLE 	=> '1',
						 CLK 		=> clk,
						 RST 		=> '0');
						 
		END_REG_RT : entity work.registradorGenerico
			generic map (larguraDados => 5)
			port map (DIN 		=> endRegRT_in,
						 DOUT 	=> endRegRT_out,
						 ENABLE 	=> '1',
						 CLK 		=> clk,
						 RST 		=> '0');
						 
		END_REG_RD : entity work.registradorGenerico
			generic map (larguraDados => 5)
			port map (DIN 		=> endRegRD_in,
						 DOUT 	=> endRegRD_out,
						 ENABLE 	=> '1',
						 CLK 		=> clk,
						 RST 		=> '0');
						 
		SINAL_CONTROLE : entity work.registradorGenerico
			generic map (larguraDados => 14)
			port map (DIN 		=> sinal_controle_in,
						 DOUT 	=> sinal_controle_out,
						 ENABLE 	=> '1',
						 CLK 		=> clk,
						 RST 		=> '0');
						 
		OPCODE : entity work.registradorGenerico
			generic map (larguraDados => 6)
			port map (DIN 		=> opcode_in,
						 DOUT 	=> opcode_out,
						 ENABLE 	=> '1',
						 CLK 		=> clk,
						 RST 		=> '0');
						 
		FUNCT : entity work.registradorGenerico
			generic map (larguraDados => 6)
			port map (DIN 		=> funct_in,
						 DOUT 	=> funct_out,
						 ENABLE 	=> '1',
						 CLK 		=> clk,
						 RST 		=> '0');
						 
		IMEDIATO_16 : entity work.registradorGenerico
			generic map (larguraDados => 16)
			port map (DIN 		=> Imediato16_in,
						 DOUT 	=> Imediato16_out,
						 ENABLE 	=> '1',
						 CLK 		=> clk,
						 RST 		=> '0');
						 
end architecture;