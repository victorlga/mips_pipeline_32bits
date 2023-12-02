library ieee;
use ieee.std_logic_1164.all;

entity exBlock is
    generic (larguraDados     : natural := 32);
    port (CLK        		 	: in std_logic;
	 
			 EndMais4				: in std_logic_vector(larguraDados-1 downto 0);
			 SigExtIm				: in std_logic_vector(larguraDados-1 downto 0);
			 EndMais4MaisImShft	: out std_logic_vector(larguraDados-1 downto 0);
			 
			 endRegRT				: in std_logic_vector(4 downto 0);
			 endRegRD				: in std_logic_vector(4 downto 0);
			 endReg3					: out std_logic_vector(4 downto 0);
			 
			 opcode					: in std_logic_vector(5 downto 0);
			 funct					: in std_logic_vector(5 downto 0);
			 
			 dadoLidoReg1			: in std_logic_vector(larguraDados-1 downto 0);
			 ULASaida				: out std_logic_vector(larguraDados-1 downto 0);
			 
			 beqORbne				: out std_logic;
			 saidaMUXbeq			: out std_logic;
			 
			 dadoLidoReg2			: in std_logic_vector(larguraDados-1 downto 0);
			 
			 sinal_controle		: in std_logic_vector(13 downto 0)
			 
			 );
end entity;
		
architecture arquitetura of exBlock is

		signal SigExtImShft 	: std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de extensão de sinal do imediato shiftado
		signal ULActrl 		: std_logic_vector(3 downto 0);								-- Define o sinal de controle da ULA
		signal zero 			: std_logic;
		signal entradaB_ULA	: std_logic_vector(larguraDados-1 downto 0);
		
		signal beq				: std_logic;
		signal bne				: std_logic;
		signal selMuxRTRDRET : std_logic_vector(1 downto 0);
		signal tipoR			: std_logic;
		signal selMuxRegSig	: std_logic;

	begin
	
	
		-- Define a entidade que implementa a soma do endereço atual + 4 com o imediato shiftado.
		SOMA_PC_SIG : entity work.somadorGenerico
			generic map (larguraDados => larguraDados)
			port map (entradaA => EndMais4,
						 entradaB => SigExtImShft,
						 saida => EndMais4MaisImShft);
						 
		-- Define a entidade que implementa o MUX do registrador 3.
		MUX_RT_RD_RET : entity work.muxGenerico4x1
			generic map (larguraDados => 5)
			port map (entradaA_MUX => endRegRT,
						  entradaB_MUX => endRegRD,
						  entradaC_MUX => 5x"1F",
						  entradaD_MUX => 5x"0",
						  seletor_MUX => selMuxRTRDRET,
						  saida_MUX => endReg3);
						  
		-- Define a entidade que implementa a unidade de controle da ULA
		UNID_CONTROLE_ULA : entity work.unidadeControleULA
			port map (opcode => opcode,
						 funct => funct,
						 tipoR => tipoR,
						 ULActrl => ULActrl);
						 
		-- Define a entidade que implementa a ULA.
		ULA : entity work.ULAMIPS
			generic map (larguraDados => larguraDados)
			port map (entradaA => dadoLidoReg1,
						 entradaB => entradaB_ULA,
						 saida => ULASaida,
						 zero => zero,
						 seletor => ULActrl);
						 
		-- Define a entidade que implementa o MUX que seleciona entre o 
		-- dado lido do registrador 2 e o imediato com sinal extendido.
		MUX_REG_SIGEXT : entity work.muxGenerico2x1
			generic map (larguraDados => larguraDados)
			port map (entradaA_MUX => dadoLidoReg2,
						  entradaB_MUX => SigExtIm,
						  seletor_MUX => selMuxRegSig,
						  saida_MUX => entradaB_ULA);
						 
		bne			  		 <= sinal_controle(2);
		beq 			  		 <= sinal_controle(3);
		
		selMuxRTRDRET 		 <= sinal_controle(11 downto 10);
		tipoR 				 <= sinal_controle(6);
		selMuxRegSig 		 <= sinal_controle(7);
	
		SigExtImShft  		<= SigExtIm(29 downto 0) & "00";
		saidaMUXbeq 		<= zero when beq = '1' else not zero;
		beqORbne				<= beq or bne;
		
end architecture;