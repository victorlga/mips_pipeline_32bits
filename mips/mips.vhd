library ieee;
use ieee.std_logic_1164.all;

-- Definição da entidade MIPS com parâmetros genéricos e portas de I/O.
entity mips is
  generic (
    larguraDados : natural := 32;  -- Define a largura dos dados manipulados.
    simulacao : boolean := TRUE  -- Alterar para FALSE para gravação em placa.
  );
  port   (
    CLOCK_50 : in std_logic;  -- Clock de entrada de 50 MHz.
	 
    FPGA_RESET_N : in std_logic;  -- Sinal de reset.
    KEY : in std_logic_vector(3 downto 0);  -- Botões de entrada.
	 
    SW : in std_logic_vector(9 downto 0);  -- Chaves de entrada.
    
    LEDR : out std_logic_vector(9 downto 0);  -- LEDs de saída.
    
    -- Displays de 7 segmentos.
    HEX0: out std_logic_vector(6 downto 0);
    HEX1: out std_logic_vector(6 downto 0);
    HEX2: out std_logic_vector(6 downto 0);
    HEX3: out std_logic_vector(6 downto 0);
    HEX4: out std_logic_vector(6 downto 0);
    HEX5: out std_logic_vector(6 downto 0);
	 
	 -- Saida do MUX utilizado para visualizar o funcionamento do programa
	 saidaMUXDisplay : out std_logic_vector(larguraDados-1 downto 0)
  );
end entity;

architecture arquitetura of mips is

	signal CLK : std_logic;														-- Define sinal de clock utilizado na CPU
	
	signal sinal_controle : std_logic_vector (8 downto 0);						-- Define o sinal de controle da CPU, após decodificar a instrução
	
	signal proxEnd : std_logic_vector (larguraDados-1 downto 0);				-- Define o próximo endereço a ser executado
	signal Endereco : std_logic_vector (larguraDados-1 downto 0);				-- Define o endereço atual
	signal EndMais4 : std_logic_vector (larguraDados-1 downto 0);				-- Define o endereço atual + 4
	signal EndMais4MaisImShft : std_logic_vector (larguraDados-1 downto 0);		-- Define o endereço atual + 4 + Imediato shiftado
	signal SigExtIm : std_logic_vector (larguraDados-1 downto 0);				-- Define o sinal de extensão de sinal do imediato
	signal SigExtImShft : std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de extensão de sinal do imediato shiftado
	
	signal zeroANDbeq : std_logic;												-- Define o sinal de zero AND beq
	
	signal zero : std_logic;													-- Define sinal que indica se a saída da ULA é zero
	signal ULASaida : std_logic_vector (larguraDados-1 downto 0);				-- Define sinal de saída da ULA
	
	signal ROMsaida : std_logic_vector (larguraDados-1 downto 0);				-- Define sinal de saída da ROM
	
	signal endReg3 : std_logic_vector (4 downto 0);								-- Define sinal de endereço do registrador 3 (RT ou RD)
	
	signal opcode 	 : std_logic_vector (5 downto 0);							-- Define sinal de opcode que vem da ROM
	signal endRegRS : std_logic_vector (4 downto 0);							-- Define sinal de endereço do registrador RS
	signal endRegRT : std_logic_vector (4 downto 0);							-- Define sinal de endereço do registrador RT
	signal endRegRD : std_logic_vector (4 downto 0);							-- Define sinal de endereço do registrador RD
	signal shant 	 : std_logic_vector (4 downto 0);							-- Define sinal de shant que vem da ROM
	signal funct  	 : std_logic_vector (5 downto 0);							-- Define sinal de funct que vem da ROM
	
	signal Imediato26 : std_logic_vector (25 downto 0);							-- Define o sinal dos 26 bits menos significativos do imediato
	signal Imediato26Shft : std_logic_vector (27 downto 0);						-- Define o sinal dos 26 bits menos significativos do imediato shiftado
	
	signal Imediato16 : std_logic_vector (15 downto 0);							-- Define o sinal dos 16 bits menos significativos do imediato
	
	
	signal entradaAMuxProxPC : std_logic_vector (larguraDados-1 downto 0);		-- Define o sinal de entrada A do MUX do próximo endereço
	signal entradaBMuxProxPC : std_logic_vector (larguraDados-1 downto 0);		-- Define o sinal de entrada B do MUX do próximo endereço
	signal selMuxProxPC : std_logic;											-- Define o sinal de seleção do MUX do próximo endereço
	
	signal selMuxRTRD : std_logic;												-- Define o sinal de seleção do MUX do registrador 3
	signal habEscritaReg : std_logic;											-- Define o sinal de habilitação de escrita do registrador 3
	
	signal dadoEscritaReg3 : std_logic_vector (larguraDados-1 downto 0);		-- Define o sinal de dado de escrita do registrador 3
	signal dadoLidoReg1 : std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de dado lido do registrador 1
	signal dadoLidoReg2 : std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de dado lido do registrador 2
	signal entradaB_ULA : std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de entrada B da ULA
	
	signal selMuxRegSig : std_logic;											-- Define o sinal de seleção do MUX do registrador 2 e sinal extendido
	signal selMuxULARAM : std_logic;											-- Define o sinal de seleção do MUX da ULA e RAM para ir para o registrador 3
	signal beq : std_logic;														-- Define o sinal de beq que vem da decodificação da saida da ROM
	signal tipoR : std_logic;													-- Define o sinal de tipoR que vem da decodificação da saida da ROM
	
	signal ULActrl : std_logic_vector(3 downto 0);								-- Define o sinal de controle da ULA
	
	signal RAMsaida : std_logic_vector (larguraDados-1 downto 0);				-- Define o sinal de saída da RAM
	signal habEscritaRAM : std_logic;											-- Define o sinal de habilitação de escrita da RAM
	signal habLeituraRAM : std_logic;											-- Define o sinal de habilitação de leitura da RAM
	
	-- Define os sinais utilizados para testar o funcionamento da CPU.
	signal entrada_hex0,entrada_hex1,entrada_hex2,entrada_hex3,entrada_hex4,entrada_hex5: std_logic_vector(6 downto 0);
	signal saidaMUXDisplay: std_logic_vector(larguraDados-1 downto 0);
	
begin
	-- Define o clock da CPU.
	gravar:  if simulacao generate
		CLK <= KEY(0);
	else generate
		detectorSub0: work.edgeDetector(bordaSubida)
			  port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => CLK);
	end generate;

	-- Define a entidade que implementa o program counter.
	PROGRAM_COUNTER : entity work.registradorGenerico
		generic map (larguraDados => larguraDados)
		port map (DIN => proxEnd,
					 DOUT => Endereco,
					 ENABLE => '1',
					 CLK => CLK,
					 RST => '0');
	
	-- Define a entidade que implementa a soma de 4 ao endereço atual.
	SOMA_CONST_4 : entity work.somaConstante
		generic map (larguraDados => larguraDados,
						 constante => 4)
		port map (entrada => Endereco,
					 saida => EndMais4);
	
	-- Define a entidade que implementa a soma do endereço atual + 4 com o imediato shiftado.
	SOMA_PC_SIG : entity work.somadorGenerico
		generic map (larguraDados => larguraDados)
		port map (entradaA => EndMais4,
					 entradaB => SigExtImShft,
					 saida => EndMais4MaisImShft);

	-- Define a entidade que implementa o banco de registradores.
	BLOCO_REGISTRADORES : entity work.bancoRegGenerico
		generic map (larguraDados => larguraDados,
						 larguraEndBancoRegs => 5)
		port map (clk => CLK,
					 enderecoA => endRegRS,
					 enderecoB => endRegRT,
					 enderecoC => endReg3,
					 dadoEscritaC => dadoEscritaReg3,
					 escreveC => habEscritaReg,
					 saidaA => dadoLidoReg1,
					 saidaB => dadoLidoReg2);
	
	-- Define a entidade que implementa a ULA.
	ULA : entity work.ULAMIPS
		generic map (larguraDados => larguraDados)
      port map (entradaA => dadoLidoReg1,
					 entradaB => entradaB_ULA,
					 saida => ULASaida,
					 zero => zero,
					 seletor => ULActrl);
	
	-- Define a entidade que implementa a ROM.
	ROM : entity work.ROMMIPS
		generic map (dataWidth => larguraDados,
						 addrWidth => larguraDados,
						 memoryAddrWidth => 6)
		port map (Endereco => Endereco,
					 Dado => ROMsaida);
	
	-- Define a entidade que implementa a RAM.
	RAM : entity work.RAMMIPS
		generic map(dataWidth => larguraDados,
						addrWidth => larguraDados,
						memoryAddrWidth => 6)
		port map(clk => CLK,
					Endereco => ULASaida,
					Dado_in => dadoLidoReg2,
					we => habEscritaRAM,
					re => habLeituraRAM,
					habilita => '1',
					Dado_out => RAMsaida);
	
	-- Define a entidade que implementa o MUX do registrador 3.
	MUX_RT_RD : entity work.muxGenerico2x1
		generic map (larguraDados => 5)
		port map (entradaA_MUX => endRegRT,
                 entradaB_MUX => endRegRD,
                 seletor_MUX => selMuxRTRD,
                 saida_MUX => endReg3);
	
	-- Define a entidade que implementa o MUX que seleciona entre
	-- o endereço atual + 4 e o endereço atual + 4 + Imediato shiftado.
	MUX_PC_SIGEXT : entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
		port map (entradaA_MUX => EndMais4,
                 entradaB_MUX => EndMais4MaisImShft,
                 seletor_MUX => zeroANDbeq,
                 saida_MUX => entradaAMuxProxPC);
	
	-- Define a entidade que implementa o MUX que seleciona entre o 
	-- dado lido do registrador 2 e o imediato com sinal extendido.
	MUX_REG_SIGEXT : entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
		port map (entradaA_MUX => dadoLidoReg2,
                 entradaB_MUX => SigExtIm,
                 seletor_MUX => selMuxRegSig,
                 saida_MUX => entradaB_ULA);
	
	-- Define a entidade que implementa o MUX que seleciona entre o
	-- dado lido da RAM e a saída da ULA.
	MUX_ULA_RAM : entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
		port map (entradaA_MUX => ULASaida,
                 entradaB_MUX => RAMsaida,
                 seletor_MUX => selMuxULARAM,
                 saida_MUX => dadoEscritaReg3);
	
	-- Define a entidade que implementa o MUX que seleciona entre a
	-- saida do MUX_PC_SIGEXT e o endereco + 4 + imediato shiftado.
	MUX_PROX_PC : entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
		port map (entradaA_MUX => entradaAMuxProxPC,
                 entradaB_MUX => entradaBMuxProxPC,
                 seletor_MUX => selMuxProxPC,
                 saida_MUX => proxEnd);
	
	-- Define a entidade que implementa a extensão de sinal do
	-- imediato de 16 bits.
	ESTENDE_SIN_IM : entity work.estendeSinalGenerico
		generic map (larguraDadoEntrada => 16,
						 larguraDadoSaida => larguraDados)
		port map(estendeSinal_IN => Imediato16,
					estendeSinal_OUT => SigExtIm);
	
	-- Define a entidade que implementa a unidade de controle de dados
	UNID_CONTROLE_DADOS : entity work.unidadeControleDados
		port map (opcode => opcode,
					 sinal_controle => sinal_controle);

	-- Define a entidade que implementa a unidade de controle da ULA
	UNID_CONTROLE_ULA : entity work.unidadeControleULA
		port map (opcode => opcode,
					 funct => funct,
					 tipoR => tipoR,
					 ULActrl => ULActrl);
	
	-- Define as entidades utilizadas para testar o funcionamento da CPU.
	MUX_DISPLAY :  entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
      port map( entradaA_MUX => Endereco,
                entradaB_MUX => dadoEscritaReg3,
                seletor_MUX => SW(0), 
                saida_MUX => saidaMUXDisplay);
	
	HEX_0 : entity work.displayHEX
				 port map (	Data_IN => saidaMUXDisplay(3 downto 0),
								Entrada_HEX => entrada_hex0);
	HEX_1 : entity work.displayHEX
				 port map (	Data_IN => saidaMUXDisplay(7 downto 4),
								Entrada_HEX => entrada_hex1);
	HEX_2 : entity work.displayHEX
				 port map (	Data_IN => saidaMUXDisplay(11 downto 8),
								Entrada_HEX => entrada_hex2);
	HEX_3 : entity work.displayHEX
				 port map (	Data_IN => saidaMUXDisplay(15 downto 12),
								Entrada_HEX => entrada_hex3);
	HEX_4 : entity work.displayHEX
				 port map (	Data_IN => saidaMUXDisplay(19 downto 16),
								Entrada_HEX =>entrada_hex4 );
	HEX_5 : entity work.displayHEX
				 port map (	Data_IN => saidaMUXDisplay(23 downto 20),
								Entrada_HEX => entrada_hex5);
	-- Termina a definição das entidades utilizadas para testar o funcionamento da CPU.

	-- Preenche os sinais da CPU com seus respectivos valores.
	SigExtImShft  		<= SigExtIm(29 downto 0) & "00";
	zeroANDbeq	  		<= beq and zero;
	
	opcode 		  		<= ROMsaida(31 downto 26);
	endRegRS   	  		<= ROMsaida(25 downto 21);
	endRegRT   	  		<= ROMsaida(20 downto 16);
	endRegRD   	  		<= ROMsaida(15 downto 11);
	shant 		  		<= ROMsaida(10 downto 6);
	funct 		  		<= ROMsaida(5 downto 0);
	
	Imediato26 	 	 	<= ROMsaida(25 downto 0);
	Imediato26Shft 	<= Imediato26 & "00";
	
	Imediato16 	  		<= ROMsaida(15 downto 0);
	
	entradaBMuxProxPC <= EndMais4(31 downto 28) & Imediato26Shft;
	selMuxProxPC 		<= sinal_controle(8);
	
	selMuxRTRD 			<= sinal_controle(7);
	habEscritaReg 		<= sinal_controle(6);
	
	selMuxRegSig 		<= sinal_controle(5);
	selMuxULARAM 		<= sinal_controle(3);
	beq 					<= sinal_controle(2);
	tipoR 				<= sinal_controle(4);
	
	habEscritaRAM <= sinal_controle(0);
	habLeituraRAM <= sinal_controle(1);
	
	saidaROM <= ROMsaida;
	
	
	-- Preeche as saídas do top-level da CPU utilizadas para testar o funcionamento.
	HEX0 <= entrada_hex0;
	HEX1 <= entrada_hex1;
	HEX2 <= entrada_hex2;
	HEX3 <= entrada_hex3;
	HEX4 <= entrada_hex4;
	HEX5 <= entrada_hex5;
	
	
	LEDR(3 downto 0) <= saidaMUXDisplay(27 downto 24);
	LEDR(7 downto 4) <= saidaMUXDisplay(31 downto 28);


end architecture;