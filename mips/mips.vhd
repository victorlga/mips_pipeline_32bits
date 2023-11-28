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
	 
	 control : out std_logic_vector(13 downto 0);
	 proxEndeJR : out std_logic_vector (larguraDados-1 downto 0);
	 proxEnde : out std_logic_vector (larguraDados-1 downto 0);
	 opcode : out std_logic_vector (5 downto 0);
	 funct : out std_logic_vector (5 downto 0);
	 EndMais4 : out std_logic_vector (larguraDados-1 downto 0);
	 saida_ROM : out std_logic_vector (larguraDados-1 downto 0);
	 Endere : out std_logic_vector (larguraDados-1 downto 0);
	 zero : out std_logic;
	 escritaREG : out std_logic
  );
end entity;

architecture arquitetura of mips is

	signal CLK : std_logic;														-- Define sinal de clock utilizado na CPU
	
	signal sinal_controle_in_1 : std_logic_vector (13 downto 0);						-- Define o sinal de controle da CPU, após decodificar a instrução
	signal sinal_controle_out_1 : std_logic_vector (13 downto 0);						-- Define o sinal de controle da CPU, após decodificar a instrução
	signal sinal_controle_in_2 : std_logic_vector (13 downto 0);						-- Define o sinal de controle da CPU, após decodificar a instrução
	signal sinal_controle_out_2 : std_logic_vector (13 downto 0);						-- Define o sinal de controle da CPU, após decodificar a instrução
	signal sinal_controle_in_3 : std_logic_vector (13 downto 0);						-- Define o sinal de controle da CPU, após decodificar a instrução
	signal sinal_controle_out_3 : std_logic_vector (13 downto 0);						-- Define o sinal de controle da CPU, após decodificar a instrução
	
	signal proxEnd : std_logic_vector (larguraDados-1 downto 0);				-- Define o próximo endereço a ser executado
	signal proxEndJR : std_logic_vector (larguraDados-1 downto 0);				
	signal Endereco : std_logic_vector (larguraDados-1 downto 0);				-- Define o endereço atual
	
	signal EndMais4_in_1 : std_logic_vector (larguraDados-1 downto 0);				-- Define o endereço atual + 4 que entra no registrador 1
	signal EndMais4_out_1 : std_logic_vector (larguraDados-1 downto 0);				-- Define o endereço atual + 4 que sai no registrador 1
	signal EndMais4_in_2 : std_logic_vector (larguraDados-1 downto 0);				-- Define o endereço atual + 4 que entra no registrador 2
	signal EndMais4_out_2 : std_logic_vector (larguraDados-1 downto 0);				-- Define o endereço atual + 4 que sai no registrador 2
	signal EndMais4_in_3 : std_logic_vector (larguraDados-1 downto 0);				-- Define o endereço atual + 4 que entra no registrador 3
	signal EndMais4_out_3 : std_logic_vector (larguraDados-1 downto 0);				-- Define o endereço atual + 4 que sai no registrador 3
	signal EndMais4_in_4 : std_logic_vector (larguraDados-1 downto 0);				-- Define o endereço atual + 4 que entra no registrador 4
	signal EndMais4_out_4 : std_logic_vector (larguraDados-1 downto 0);				-- Define o endereço atual + 4 que sai no registrador 4
	
	signal EndMais4MaisImShft_in : std_logic_vector (larguraDados-1 downto 0);		-- Define o endereço atual + 4 + Imediato shiftado que entra no registrador do pipeline
	signal EndMais4MaisImShft_out : std_logic_vector (larguraDados-1 downto 0);	-- Define o endereço atual + 4 + Imediato shiftado que sai no registrador do pipeline
	
	signal SigExtIm_in : std_logic_vector (larguraDados-1 downto 0);				-- Define o sinal de extensão de sinal do imediato
	signal SigExtIm_out : std_logic_vector (larguraDados-1 downto 0);				-- Define o sinal de extensão de sinal do imediato
	signal SigExtImShft : std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de extensão de sinal do imediato shiftado
	
	signal zeroANDbeq : std_logic;												-- Define o sinal de zero AND beq
	
	signal zero_in : std_logic;													-- Define sinal que indica se a saída da ULA é zero
	signal zero_out : std_logic;													-- Define sinal que indica se a saída da ULA é zero


	signal ULASaida_in_1 : std_logic_vector (larguraDados-1 downto 0);				-- Define sinal de saída da ULA
	signal ULASaida_out_1 : std_logic_vector (larguraDados-1 downto 0);				-- Define sinal de saída da ULA
	signal ULASaida_in_2 : std_logic_vector (larguraDados-1 downto 0);				-- Define sinal de saída da ULA
	signal ULASaida_out_2 : std_logic_vector (larguraDados-1 downto 0);				-- Define sinal de saída da ULA

	
	signal ROMsaida_in : std_logic_vector (larguraDados-1 downto 0);				-- Define sinal de saída da ROM
	signal ROMsaida_out : std_logic_vector (larguraDados-1 downto 0);				-- Define sinal de saída da ROM que sai do registrador
	
	signal endReg3_in_1 : std_logic_vector (4 downto 0);								-- Define sinal de endereço do registrador 3 (RT ou RD)
	signal endReg3_out_1 : std_logic_vector (4 downto 0);
	signal endReg3_in_2 : std_logic_vector (4 downto 0);
	signal endReg3_out_2 : std_logic_vector (4 downto 0);
	
	signal opcode_in 	 : std_logic_vector (5 downto 0);							-- Define sinal de opcode que vem da ROM
	signal opcode_out 	 : std_logic_vector (5 downto 0);							-- Define sinal de opcode que vem da ROM
	signal endRegRS : std_logic_vector (4 downto 0);							-- Define sinal de endereço do registrador RS
	signal endRegRT_in : std_logic_vector (4 downto 0);							-- Define sinal de endereço do registrador RT
	signal endRegRD_in : std_logic_vector (4 downto 0);							-- Define sinal de endereço do registrador RD
	signal endRegRT_out : std_logic_vector (4 downto 0);							-- Define sinal de endereço do registrador RT
	signal endRegRD_out : std_logic_vector (4 downto 0);							-- Define sinal de endereço do registrador RD
	signal shant 	 : std_logic_vector (4 downto 0);							-- Define sinal de shant que vem da ROM
	signal funct_in  	 : std_logic_vector (5 downto 0);							-- Define sinal de funct que vem da ROM
	signal funct_out  	 : std_logic_vector (5 downto 0);							-- Define sinal de funct que vem da ROM
	
	signal Imediato26 : std_logic_vector (25 downto 0);							-- Define o sinal dos 26 bits menos significativos do imediato
	signal Imediato26Shft : std_logic_vector (27 downto 0);						-- Define o sinal dos 26 bits menos significativos do imediato shiftado
	
	signal Imediato16_in_1 : std_logic_vector (15 downto 0);							-- Define o sinal dos 16 bits menos significativos do imediato
	signal Imediato16_out_1 : std_logic_vector (15 downto 0);							-- Define o sinal dos 16 bits menos significativos do imediato
	signal Imediato16_in_2 : std_logic_vector (15 downto 0);							-- Define o sinal dos 16 bits menos significativos do imediato
	signal Imediato16_out_2 : std_logic_vector (15 downto 0);							-- Define o sinal dos 16 bits menos significativos do imediato
	signal Imediato16_in_3 : std_logic_vector (15 downto 0);							-- Define o sinal dos 16 bits menos significativos do imediato
	signal Imediato16_out_3 : std_logic_vector (15 downto 0);							-- Define o sinal dos 16 bits menos significativos do imediato
	
	
	signal entradaAMuxProxPC : std_logic_vector (larguraDados-1 downto 0);		-- Define o sinal de entrada A do MUX do próximo endereço
	signal entradaBMuxProxPC : std_logic_vector (larguraDados-1 downto 0);		-- Define o sinal de entrada B do MUX do próximo endereço
	signal selMuxProxPC : std_logic;											-- Define o sinal de seleção do MUX do próximo endereço
	
	signal selMuxRTRDRET : std_logic_vector(1 downto 0);					-- Define o sinal de seleção do MUX do registrador 3
	signal habEscritaReg : std_logic;											-- Define o sinal de habilitação de escrita do registrador 3
	
	signal dadoEscritaReg3 : std_logic_vector (larguraDados-1 downto 0);		-- Define o sinal de dado de escrita do registrador 3
	
	signal dadoLidoReg1_in : std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de dado lido do registrador 1 que entra no registrador do pipeline
	signal dadoLidoReg1_out : std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de dado lido do registrador 1 que sai no registrador do pipeline

	signal dadoLidoReg2_in_1 : std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de dado lido do registrador 2
	signal dadoLidoReg2_out_1 : std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de dado lido do registrador 2
	signal dadoLidoReg2_in_2 : std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de dado lido do registrador 2
	signal dadoLidoReg2_out_2 : std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de dado lido do registrador 2


	signal entradaB_ULA : std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de entrada B da ULA
	
	signal selMuxRegSig : std_logic;											-- Define o sinal de seleção do MUX do registrador 2 e sinal extendido
	signal selMuxEscreveReg3 : std_logic_vector(1 downto 0);											-- Define o sinal de seleção do MUX da ULA e RAM para ir para o registrador 3
	signal beq : std_logic;														-- Define o sinal de beq que vem da decodificação da saida da ROM
	signal bne : std_logic;														-- Define o sinal de bne que vem da decodificação da saida da ROM
	signal tipoR : std_logic;													-- Define o sinal de tipoR que vem da decodificação da saida da ROM
	signal saidaMUXbeq : std_logic;
	
	signal ULActrl : std_logic_vector(3 downto 0);								-- Define o sinal de controle da ULA
	
	signal RAMsaida_in : std_logic_vector (larguraDados-1 downto 0);				-- Define o sinal de saída da RAM
	signal RAMsaida_out : std_logic_vector (larguraDados-1 downto 0);				-- Define o sinal de saída da RAM

	signal habEscritaRAM : std_logic;											-- Define o sinal de habilitação de escrita da RAM
	signal habLeituraRAM : std_logic;											-- Define o sinal de habilitação de leitura da RAM
	
	signal sel_ORI_ANDI : std_logic;
	signal selJR : std_logic;
	
	-- Define os sinais utilizados para testar o funcionamento da CPU.
	signal entrada_hex0,entrada_hex1,entrada_hex2,entrada_hex3,entrada_hex4,entrada_hex5: std_logic_vector(6 downto 0);
	
	-- Saida do MUX utilizado para visualizar o funcionamento do programa
	signal saidaMUXDisplay : std_logic_vector(larguraDados-1 downto 0);
	
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
		port map (DIN 		=> proxEndJR,
					 DOUT 	=> Endereco,
					 ENABLE 	=> '1',
					 CLK 		=> CLK,
					 RST 		=> '0');
	
	-- Define a entidade que implementa a soma de 4 ao endereço atual.
	SOMA_CONST_4 : entity work.somaConstante
		generic map (larguraDados => larguraDados,
						 constante => 4)
		port map (entrada => Endereco,
					 saida 	=> EndMais4_in_1);
	
	-- Define a entidade que implementa a soma do endereço atual + 4 com o imediato shiftado.
	SOMA_PC_SIG : entity work.somadorGenerico
		generic map (larguraDados => larguraDados)
		port map (entradaA 	=> EndMais4_out_2,
					 entradaB 	=> SigExtImShft,
					 saida 		=> EndMais4MaisImShft_in);

	-- Define a entidade que implementa o banco de registradores.
	BLOCO_REGISTRADORES : entity work.bancoRegGenerico
		generic map (larguraDados => larguraDados,
						 larguraEndBancoRegs => 5)
		port map (clk 				=> CLK,
					 enderecoA 		=> endRegRS,
					 enderecoB 		=> endRegRT_in,
					 enderecoC 		=> endReg3_out_2,
					 dadoEscritaC 	=> dadoEscritaReg3,
					 escreveC 		=> habEscritaReg,
					 saidaA 			=> dadoLidoReg1_in,
					 saidaB 			=> dadoLidoReg2_in_1);
	
	-- Define a entidade que implementa a ULA.
	ULA : entity work.ULAMIPS
		generic map (larguraDados => larguraDados)
      port map (entradaA 	=> dadoLidoReg1_out,
					 entradaB 	=> entradaB_ULA,
					 saida 		=> ULASaida_in_1,
					 zero 		=> zero_in,
					 seletor 	=> ULActrl);
	
	-- Define a entidade que implementa a ROM.
	ROM : entity work.ROMMIPS
		generic map (dataWidth => larguraDados,
						 addrWidth => larguraDados,
						 memoryAddrWidth => 6)
		port map (Endereco 	=> Endereco,
					 Dado 		=> ROMsaida_in);
	
	-- Define a entidade que implementa a RAM.
	RAM : entity work.RAMMIPS
		generic map(dataWidth => larguraDados,
						addrWidth => larguraDados,
						memoryAddrWidth => 6)
		port map(clk 		=> CLK,
					Endereco => ULASaida_out_1,
					Dado_in 	=> dadoLidoReg2_out_2,
					we 		=> habEscritaRAM,
					re 		=> habLeituraRAM,
					habilita => '1',
					Dado_out => RAMsaida_in);
	
	-- Define a entidade que implementa o MUX do registrador 3.
	MUX_RT_RD_RET : entity work.muxGenerico4x1
		generic map (larguraDados => 5)
		port map (entradaA_MUX 	=> endRegRT_out,
                 entradaB_MUX => endRegRD_out,
					  entradaC_MUX => 5x"1F",
					  entradaD_MUX => 5x"0",
                 seletor_MUX 	=> selMuxRTRDRET,
                 saida_MUX 	=> endReg3_in_1);
	
	-- Define a entidade que implementa o MUX que seleciona entre
	-- o endereço atual + 4 e o endereço atual + 4 + Imediato shiftado.
	MUX_PC_SIGEXT : entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
		port map (entradaA_MUX 	=> EndMais4_in_1,
                 entradaB_MUX => EndMais4MaisImShft_out,
                 seletor_MUX 	=> zeroANDbeq,
                 saida_MUX 	=> entradaAMuxProxPC);
	
	-- Define a entidade que implementa o MUX que seleciona entre o 
	-- dado lido do registrador 2 e o imediato com sinal extendido.
	MUX_REG_SIGEXT : entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
		port map (entradaA_MUX 	=> dadoLidoReg2_out_1,
                 entradaB_MUX => SigExtIm_out,
                 seletor_MUX 	=> selMuxRegSig,
                 saida_MUX 	=> entradaB_ULA);
	
	-- Define a entidade que implementa o MUX que seleciona entre o
	-- dado lido da RAM e a saída da ULA.
	MUX_ESCREVE_REG_3 : entity work.muxGenerico4x1
		generic map (larguraDados => larguraDados)
		port map (entradaA_MUX 	=> ULASaida_out_2,
                 entradaB_MUX => RAMsaida_out,
					  entradaC_MUX => EndMais4_out_4,
					  entradaD_MUX => Imediato16_out_3 & 16x"0",
                 seletor_MUX 	=> selMuxEscreveReg3,
                 saida_MUX 	=> dadoEscritaReg3);
	
	-- Define a entidade que implementa o MUX que seleciona entre a
	-- saida do MUX_PC_SIGEXT e o endereco + 4 + imediato shiftado.
	MUX_PROX_PC : entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
		port map (entradaA_MUX 	=> entradaAMuxProxPC,
                 entradaB_MUX => entradaBMuxProxPC,
                 seletor_MUX 	=> selMuxProxPC,
                 saida_MUX 	=> proxEnd);
					  
	MUX_PROX_PC_JR : entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
		port map (entradaA_MUX 	=> proxEnd,
                 entradaB_MUX => dadoLidoReg1_out,
                 seletor_MUX 	=> selJR,
                 saida_MUX 	=> proxEndJR);
					  
	-- Define a entidade que implementa a extensão de sinal do
	-- imediato de 16 bits.
	ESTENDE_SIN_IM : entity work.estendeSinalGenerico
		generic map (larguraDadoEntrada => 16,
						 larguraDadoSaida => larguraDados)
		port map(estendeSinal_IN 	=> Imediato16_in_1,
					sel_ORI_ANDI 		=> sel_ORI_ANDI,
					estendeSinal_OUT 	=> SigExtIm_in);
	
	-- Define a entidade que implementa a unidade de controle de dados
	UNID_CONTROLE_DADOS : entity work.unidadeControleDados
		port map (opcode 				=> opcode_in,
					 funct 				=> funct_in,
					 sinal_controle 	=> sinal_controle_in_1);

	-- Define a entidade que implementa a unidade de controle da ULA
	UNID_CONTROLE_ULA : entity work.unidadeControleULA
		port map (opcode 	=> opcode_out,
					 funct 	=> funct_out,
					 tipoR 	=> tipoR,
					 ULActrl => ULActrl);
					 
					 
	REGS_PIPE_IFID : entity work.registradoresPipeIFID
		generic map (larguraDados => larguraDados)
		port map (clk 				=> CLK,
					 EndMais4_in 	=> EndMais4_in_1,
					 EndMais4_out 	=> EndMais4_out_1,
					 ROMsaida_in 	=> ROMsaida_in,
					 ROMsaida_out 	=> ROMsaida_out);
	
	
	REGS_PIPE_IDEX : entity work.registradoresPipeIDEX
		generic map (larguraDados => larguraDados)
		port map (clk 						=> CLK,
					 EndMais4_in 			=> EndMais4_in_2,
					 EndMais4_out 			=> EndMais4_out_2,
					 
					 dadoLidoReg1_in 		=> dadoLidoReg1_in,
					 dadoLidoReg1_out 	=> dadoLidoReg1_out,
					 dadoLidoReg2_in 		=> dadoLidoReg2_in_1,
					 dadoLidoReg2_out 	=> dadoLidoReg2_out_1,
					 
					 SigExtIm_in 			=> SigExtIm_in,
					 SigExtIm_out 			=> SigExtIm_out,
					 
					 endRegRT_in 			=> endRegRT_in,
					 endRegRT_out 			=> endRegRT_out,
					 endRegRD_in 			=> endRegRD_in,
					 endRegRD_out 			=> endRegRD_out,
					 
					 sinal_controle_in 	=> sinal_controle_in_1,
					 sinal_controle_out 	=> sinal_controle_out_1,
					 
					 opcode_in 				=> opcode_in,
					 opcode_out 			=> opcode_out,
					 funct_in 				=> funct_in,
					 funct_out 				=> funct_out,
					 
					 Imediato16_in 		=> Imediato16_in_1,
					 Imediato16_out 		=> Imediato16_out_1);
					 
					 
	REGS_PIPE_EXMEM : entity work.registradoresPipeEXMEM
		generic map (larguraDados => larguraDados)
		port map (clk 					  		=> CLK,
					 sinal_controle_in  		=> sinal_controle_in_2,
					 sinal_controle_out 		=> sinal_controle_out_2,
					 
					 zero_in 			  		=> zero_in,
					 zero_out 			  		=> zero_out,
					 ULASaida_in 		  		=> ULASaida_in_1,
					 ULASaida_out 		  		=> ULASaida_out_1,
					 
					 dadoLidoReg2_in 	  		=> dadoLidoReg2_in_2,
					 dadoLidoReg2_out   		=> dadoLidoReg2_out_2,
					 
					 EndMais4MaisImShft_in 	=> EndMais4MaisImShft_in,
					 EndMais4MaisImShft_out => EndMais4MaisImShft_out,
					 
					 EndMais4_in 				=> EndMais4_in_3,
					 EndMais4_out 				=> EndMais4_out_3,
					 
					 endReg3_in 				=> endReg3_in_1,
					 endReg3_out 				=> endReg3_out_1,
					 
					 Imediato16_in 			=> Imediato16_in_2,
					 Imediato16_out 			=> Imediato16_out_2);
					 
					 
	REGS_PIPE_MEMWB : entity work.registradoresPipeMEMWB
		generic map (larguraDados => larguraDados)
		port map (clk 					  => CLK,
		
					 sinal_controle_in  => sinal_controle_in_3,
					 sinal_controle_out => sinal_controle_out_3,
					 
					 EndMais4_in 		  => EndMais4_in_4,
					 EndMais4_out 		  => EndMais4_out_4,
					 
					 ULASaida_in 		  => ULASaida_in_2,
					 ULASaida_out 		  => ULASaida_out_2,
					 
					 Imediato16_in 	  => Imediato16_in_3,
					 Imediato16_out 	  => Imediato16_out_3,
					 
					 RAMsaida_in 		  => RAMsaida_in,
					 RAMsaida_out 		  => RAMsaida_out,
					 
					 endReg3_in 		  => endReg3_in_2,
					 endReg3_out 		  => endReg3_out_2);
					 
				
	-- Define as entidades utilizadas para testar o funcionamento da CPU.
	MUX_DISPLAY :  entity work.muxGenerico4x1
		generic map (larguraDados => larguraDados)
      port map( entradaA_MUX 	=> Endereco,
                entradaB_MUX 	=> EndMais4_out_2,
					 entradaC_MUX 	=> ULASaida_in_1,
					 entradaD_MUX 	=> dadoEscritaReg3,
                seletor_MUX 	=> SW(1) & SW(0),
                saida_MUX 		=> saidaMUXDisplay);
	
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
	
	EndMais4_in_2 <= EndMais4_out_1;
	EndMais4_in_3 <= EndMais4_out_2;
	EndMais4_in_4 <= EndMais4_out_3;
	
	endReg3_in_2 <= endReg3_out_1;
	
	Imediato16_in_3 <= Imediato16_out_2;
	Imediato16_in_2 <= Imediato16_out_1;
	
	ULASaida_in_2 <= ULASaida_out_1;
	
	sinal_controle_in_3 <= sinal_controle_out_2;
	sinal_controle_in_2 <= sinal_controle_out_1;
	
	dadoLidoReg2_in_2 <= dadoLidoReg2_out_1;
	
	
	-- Preenche os sinais da CPU com seus respectivos valores.
	SigExtImShft  		<= SigExtIm_out(29 downto 0) & "00";
	zeroANDbeq	  		<= (beq or bne) and saidaMUXbeq;
	
	opcode_in 		  	<= ROMsaida_out(31 downto 26);
	endRegRS   	  		<= ROMsaida_out(25 downto 21);
	endRegRT_in  	   <= ROMsaida_out(20 downto 16);
	endRegRD_in	  		<= ROMsaida_out(15 downto 11);
	shant 		  		<= ROMsaida_out(10 downto 6);
	funct_in 		  	<= ROMsaida_out(5 downto 0);
	
	Imediato26 	 	 	<= ROMsaida_out(25 downto 0);
	Imediato26Shft 	<= Imediato26 & "00";
	
	Imediato16_in_1	<= ROMsaida_out(15 downto 0);
	
	entradaBMuxProxPC <= EndMais4_in_1(31 downto 28) & Imediato26Shft;
	
	habEscritaRAM 		 <= sinal_controle_out_2(0);
	habLeituraRAM 		 <= sinal_controle_out_2(1);
	bne			  		 <= sinal_controle_out_2(2);
	beq 			  		 <= sinal_controle_out_2(3);
	selMuxEscreveReg3  <= sinal_controle_out_3(5 downto 4);
	tipoR 				 <= sinal_controle_out_1(6);
	selMuxRegSig 		 <= sinal_controle_out_2(7); ---------------%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	habEscritaReg 		 <= sinal_controle_out_3(8);
	sel_ORI_ANDI		 <= sinal_controle_in_1(9);
	selMuxRTRDRET 		 <= sinal_controle_out_1(11 downto 10);
	selMuxProxPC		 <= sinal_controle_out_2(12); ------------?????????????????????????????????????????????
	selJR					 <= sinal_controle_out_2(13);
	
	saidaMUXbeq <= zero_out when beq = '1' else not zero_out;
	
	
	
	-- Preeche as saídas do top-level da CPU utilizadas para testar o funcionamento.
	HEX0 <= entrada_hex0;
	HEX1 <= entrada_hex1;
	HEX2 <= entrada_hex2;
	HEX3 <= entrada_hex3;
	HEX4 <= entrada_hex4;
	HEX5 <= entrada_hex5;
	
	
	LEDR(3 downto 0) <= saidaMUXDisplay(27 downto 24);
	LEDR(7 downto 4) <= saidaMUXDisplay(31 downto 28);
	LEDR(8) <= habEscritaReg;
	LEDR(9) <= zero_in;
	
	control <= sinal_controle_in_1;
	proxEndeJR <= proxEndJR;
	proxEnde <= proxEnd;
	opcode <= opcode_in;
	funct <= funct_in;
	EndMais4 <= EndMais4_out_1;
	saida_ROM <= ROMsaida_in;
	Endere <= Endereco;
	zero <= zero_in;
	escritaREG <= habEscritaReg;
	
end architecture;