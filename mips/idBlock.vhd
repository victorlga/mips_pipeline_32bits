library ieee;
use ieee.std_logic_1164.all;

entity idBlock is
    generic (larguraDados        : natural := 32);
    port (CLK        		 	: in std_logic;
			 habEscritaReg			: in std_logic;
			 endReg3					: in std_logic_vector(4 downto 0);
			 dadoEscritaReg3		: in std_logic_vector(larguraDados-1 downto 0);
			 ROMsaida			 	: in std_logic_vector(larguraDados-1 downto 0);
			 EndMais4				: in std_logic_vector(larguraDados-1 downto 0);
			 
			 endRegRT				: out std_logic_vector(4 downto 0);
			 endRegRD				: out std_logic_vector(4 downto 0);
			 opcode					: out std_logic_vector(5 downto 0);
			 funct					: out std_logic_vector(5 downto 0);
			 sinal_controle		: out std_logic_vector(13 downto 0);
			 Imediato16				: out std_logic_vector(15 downto 0);
			 dadoLidoReg1			: out std_logic_vector(larguraDados-1 downto 0);
			 dadoLidoReg2			: out std_logic_vector(larguraDados-1 downto 0);
			 SigExtIm				: out std_logic_vector(larguraDados-1 downto 0);
			 entradaBMuxProxPC	: out std_logic_vector(larguraDados-1 downto 0)
			 );
end entity;
		
architecture arquitetura of idBlock is
		
		signal opcode_local				: std_logic_vector (5 downto 0);							-- Define sinal de opcode que vem da ROM
		signal endRegRS 					: std_logic_vector (4 downto 0);							-- Define sinal de endereço do registrador RS
		signal endRegRT_local			: std_logic_vector (4 downto 0);							-- Define sinal de endereço do registrador RT
		signal shant 	 					: std_logic_vector (4 downto 0);							-- Define sinal de shant que vem da ROM
		signal funct_local				: std_logic_vector (5 downto 0);							-- Define sinal de funct que vem da ROM
		
		signal sinal_controle_local 	: std_logic_vector(13 downto 0);
		signal sel_ORI_ANDI 	 		 	: std_logic;
		
		signal Imediato26 : std_logic_vector (25 downto 0);							-- Define o sinal dos 26 bits menos significativos do imediato
		signal Imediato26Shft : std_logic_vector (27 downto 0);						-- Define o sinal dos 26 bits menos significativos do imediato shiftado	
		signal Imediato16_local : std_logic_vector (15 downto 0);
		
	begin
	
		-- Define a entidade que implementa a unidade de controle de dados
		UNID_CONTROLE_DADOS : entity work.unidadeControleDados
			port map (opcode => opcode_local,
						 funct => funct_local,
						 sinal_controle => sinal_controle_local);
						 
					 
		-- Define a entidade que implementa o banco de registradores.
		BLOCO_REGISTRADORES : entity work.bancoRegGenerico
			generic map (larguraDados => larguraDados,
							 larguraEndBancoRegs => 5)
			port map (clk => CLK,
						 enderecoA 	  => endRegRS,
						 enderecoB 	  => endRegRT_local,
						 enderecoC 	  => endReg3,
						 dadoEscritaC => dadoEscritaReg3,
						 escreveC 	  => habEscritaReg,
						 saidaA 		  => dadoLidoReg1,
						 saidaB 		  => dadoLidoReg2);
						 
		-- Define a entidade que implementa a extensão de sinal do
		-- imediato de 16 bits.
		ESTENDE_SIN_IM : entity work.estendeSinalGenerico
			generic map (larguraDadoEntrada => 16,
							 larguraDadoSaida => larguraDados)
			port map(estendeSinal_IN => Imediato16_local,
						sel_ORI_ANDI => sel_ORI_ANDI,
						estendeSinal_OUT => SigExtIm);
		
		opcode_local  		<= ROMsaida(31 downto 26);
		endRegRS   	  		<= ROMsaida(25 downto 21);
		endRegRT_local		<= ROMsaida(20 downto 16);
		endRegRD   	  		<= ROMsaida(15 downto 11);
		shant 		  		<= ROMsaida(10 downto 6);
		funct_local	  		<= ROMsaida(5 downto 0);
		
		endRegRT				<= endRegRT_local;
		
		opcode				<= opcode_local;
		funct					<= funct_local;
		
		sel_ORI_ANDI		<= sinal_controle_local(9);
		
		sinal_controle 	<= sinal_controle_local;
		
		Imediato16_local 	<= ROMsaida(15 downto 0);
		Imediato16 			<= Imediato16_local;
		Imediato26 	 	 	<= ROMsaida(25 downto 0);
		Imediato26Shft 	<= Imediato26 & "00";
		
		entradaBMuxProxPC <= EndMais4(31 downto 28) & Imediato26Shft;
	
	
end architecture;