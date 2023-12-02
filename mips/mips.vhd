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
    HEX5: out std_logic_vector(6 downto 0)
  );
end entity;

architecture arquitetura of mips is

		signal CLK 								: std_logic;														-- Define sinal de clock utilizado na CPU
		signal zero 							: std_logic;
		signal DOUT_IFID 						: std_logic_vector(63 downto 0);
		signal endRegRT 						: std_logic_vector(4 downto 0);
		signal endRegRD 						: std_logic_vector(4 downto 0);
		signal DOUT_IDEX 						: std_logic_vector(179 downto 0);
		signal DOUT_EXMEM						: std_logic_vector(164 downto 0);
		signal DOUT_MEMWB						: std_logic_vector(130 downto 0);
		signal endRegRT_out_2				: std_logic_vector(4 downto 0);
		signal endRegRD_out_2				: std_logic_vector(4 downto 0);
		signal EndMais4_out_2 				: std_logic_vector(larguraDados-1 downto 0);
		signal sinal_controle_out_2		: std_logic_vector(13 downto 0);
		signal dadoLidoReg1_out_2 			: std_logic_vector(larguraDados-1 downto 0);
		signal dadoLidoReg2_out_2 			: std_logic_vector(larguraDados-1 downto 0);
		signal SigExtIm_out_2 				: std_logic_vector(larguraDados-1 downto 0);
		signal Imediato16_out_2 			: std_logic_vector(15 downto 0);
		signal opcode_out_2					: std_logic_vector(5 downto 0);
		signal funct_out_2					: std_logic_vector(5 downto 0);
		signal sinal_controle_out_4		: std_logic_vector(13 downto 0);
		signal ULASaida_out_4 				: std_logic_vector(larguraDados-1 downto 0);	
		signal RAMsaida_out_4				: std_logic_vector(larguraDados-1 downto 0);
		signal EndMais4_out_4 				: std_logic_vector(larguraDados-1 downto 0);	
		signal Imediato16_out_4				: std_logic_vector(15 downto 0);	
		signal endReg3_out_4					: std_logic_vector(4 downto 0);	
		signal sinal_controle 				: std_logic_vector (13 downto 0);						-- Define o sinal de controle da CPU, após decodificar a instrução
		signal Endereco 						: std_logic_vector (larguraDados-1 downto 0);
		signal proxEnd 						: std_logic_vector (larguraDados-1 downto 0);				-- Define o próximo endereço a ser executado
		signal proxEndJR 						: std_logic_vector (larguraDados-1 downto 0);				
		signal EndMais4 						: std_logic_vector (larguraDados-1 downto 0);				-- Define o endereço atual + 4
		signal EndMais4_out_1 				: std_logic_vector (larguraDados-1 downto 0);				-- Define o endereço atual + 4 que sai do registrador IF
		signal EndMais4MaisImShft 			: std_logic_vector (larguraDados-1 downto 0);		-- Define o endereço atual + 4 + Imediato shiftado
		signal SigExtIm 						: std_logic_vector (larguraDados-1 downto 0);				-- Define o sinal de extensão de sinal do imediato
		signal zeroANDbeq 					: std_logic;												-- Define o sinal de zero AND beq
		signal ULASaida 						: std_logic_vector (larguraDados-1 downto 0);				-- Define sinal de saída da ULA
		signal ROMsaida 						: std_logic_vector (larguraDados-1 downto 0);				-- Define sinal de saída da ROM
		signal ROMsaida_out_1 				: std_logic_vector (larguraDados-1 downto 0);				-- Define sinal de saída da ROM
		signal endReg3 						: std_logic_vector (4 downto 0);								-- Define sinal de endereço do registrador 3 (RT ou RD)
		signal opcode							: std_logic_vector (5 downto 0);							-- Define sinal de opcode que vem da ROM
		signal funct							: std_logic_vector (5 downto 0);							-- Define sinal de funct que vem da ROM
		signal Imediato16 					: std_logic_vector (15 downto 0);							-- Define o sinal dos 16 bits menos significativos do imediato
		signal entradaAMuxProxPC 			: std_logic_vector (larguraDados-1 downto 0);		-- Define o sinal de entrada A do MUX do próximo endereço
		signal entradaBMuxProxPC 			: std_logic_vector (larguraDados-1 downto 0);		-- Define o sinal de entrada B do MUX do próximo endereço
		signal selMuxProxPC 					: std_logic;											-- Define o sinal de seleção do MUX do próximo endereço
		signal habEscritaReg 				: std_logic;											-- Define o sinal de habilitação de escrita do registrador 3
		signal dadoEscritaReg3 				: std_logic_vector (larguraDados-1 downto 0);		-- Define o sinal de dado de escrita do registrador 3
		signal dadoLidoReg1 					: std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de dado lido do registrador 1
		signal dadoLidoReg2 					: std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de dado lido do registrador 2
		signal entradaB_ULA 					: std_logic_vector (larguraDados-1 downto 0);			-- Define o sinal de entrada B da ULA
		signal selMuxRegSig 					: std_logic;											-- Define o sinal de seleção do MUX do registrador 2 e sinal extendido
		signal selMuxEscreveReg3 			: std_logic_vector(1 downto 0);											-- Define o sinal de seleção do MUX da ULA e RAM para ir para o registrador 3
		signal saidaMUXbeq 					: std_logic;
		signal beqORbne 						: std_logic;
		signal RAMsaida 						: std_logic_vector (larguraDados-1 downto 0);				-- Define o sinal de saída da RAM
		signal selJR 							: std_logic;
		signal Imediato16_out_3				: std_logic_vector(15 downto 0);
		signal EndMais4MaisImShft_out_3 	: std_logic_vector(31 downto 0);
		signal endReg3_out_3 				: std_logic_vector(4 downto 0);
		signal ULASaida_out_3 				: std_logic_vector(31 downto 0);
		signal beqORbne_out_3 				: std_logic;
		signal saidaMUXbeq_out_3 			: std_logic;
		signal dadoLidoReg2_out_3 			: std_logic_vector(31 downto 0);
		signal sinal_controle_out_3 		: std_logic_vector(13 downto 0);
		signal EndMais4_out_3 				: std_logic_vector(31 downto 0);

		
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
	
		-- Define a entidade que implementa o MUX que seleciona entre
		-- o endereço atual + 4 e o endereço atual + 4 + Imediato shiftado.
		MUX_PC_SIGEXT : entity work.muxGenerico2x1
			generic map (larguraDados => larguraDados)
			port map (entradaA_MUX 	=> EndMais4,
						  entradaB_MUX => EndMais4MaisImShft_out_3,
						  seletor_MUX 	=> zeroANDbeq,
						  saida_MUX 	=> entradaAMuxProxPC);
					  
		-- Define a entidade que implementa o MUX que seleciona entre a
		-- saida do MUX_PC_SIGEXT e o endereco + 4 + imediato shiftado.
		MUX_PROX_PC : entity work.muxGenerico2x1
			generic map (larguraDados => larguraDados)
			port map  (entradaA_MUX => entradaAMuxProxPC,
						  entradaB_MUX => entradaBMuxProxPC,
						  seletor_MUX 	=> selMuxProxPC,
						  saida_MUX 	=> proxEnd);
					  
		MUX_PROX_PC_JR : entity work.muxGenerico2x1
			generic map (larguraDados => larguraDados)
			port map  (entradaA_MUX => proxEnd,
						  entradaB_MUX => dadoLidoReg1,
						  seletor_MUX 	=> selJR,
						  saida_MUX		=> proxEndJR);
	
		IF_BLOCK : entity work.ifBlock
			generic map (larguraDados => larguraDados)
			port map(CLK 		 => CLk,
						proxEndJR => proxEndJR,
						EndMais4  => EndMais4,
						ROMsaida  => ROMsaida,
						Endereco  => Endereco);
						
		IFID_register : entity work.registradorGenerico
			generic map (larguraDados => 64)
			port map (DIN 		=> EndMais4 & ROMsaida,
						 DOUT 	=> DOUT_IFID,
						 ENABLE 	=> '1',
						 CLK 		=> CLK,
						 RST 		=> '0');
						 
		ID_BLOCK : entity work.idBlock
			generic map (larguraDados => larguraDados)
			port map (CLK 						=> CLK,
						 habEscritaReg			=> habEscritaReg,
						 endReg3					=> endReg3_out_4,
						 dadoEscritaReg3		=> dadoEscritaReg3,
						 ROMsaida				=> ROMsaida_out_1,
						 EndMais4				=> EndMais4,
						 sinal_controle		=> sinal_controle,
						 dadoLidoReg1			=> dadoLidoReg1,
						 dadoLidoReg2			=> dadoLidoReg2,
						 SigExtIm				=> SigExtIm,
						 Imediato16				=> Imediato16,
						 entradaBMuxProxPC	=> entradaBMuxProxPC,
						 opcode					=> opcode,
						 funct					=> funct,
						 endRegRT				=> endRegRT,
						 endRegRD				=> endRegRD);
						 
		IDEX_register : entity work.registradorGenerico
			generic map (larguraDados => 180)
			port map (DIN 		=> endRegRT & endRegRD & EndMais4_out_1 & sinal_controle & dadoLidoReg1 & dadoLidoReg2 & SigExtIm & Imediato16 & opcode & funct,
						 DOUT 	=> DOUT_IDEX,
						 ENABLE 	=> '1',
						 CLK 		=> CLK,
						 RST 		=> '0');
						 
	----------------------------------------------------------------------------------------------------------------
						 
		EX_BLOCK : entity work.exBlock
			generic map (larguraDados => larguraDados)
			port map (CLK => CLK,
						 EndMais4 				=> EndMais4_out_2,
						 SigExtIm 				=> SigExtIm_out_2,
						 EndMais4MaisImShft 	=> EndMais4MaisImShft,
						 endRegRT 				=> endRegRT_out_2,
						 endRegRD 				=> endRegRD_out_2,
						 endReg3 				=> endReg3,
						 opcode 					=> opcode_out_2,
						 funct 					=> funct_out_2,
						 dadoLidoReg1 			=> dadoLidoReg1_out_2,
						 ULASaida				=> ULASaida,
						 beqORbne				=> beqORbne,
						 saidaMUXbeq			=> saidaMUXbeq,
						 dadoLidoReg2 			=> dadoLidoReg2_out_2,
						 sinal_controle 		=> sinal_controle_out_2,
						 zero						=> zero);
						 
		EXMEM_register : entity work.registradorGenerico
			generic map (larguraDados => 165)
			port map (DIN 		=> Imediato16_out_2 & EndMais4MaisImShft & endReg3 & ULASaida & beqORbne & saidaMUXbeq & dadoLidoReg2_out_2 & sinal_controle_out_2 & EndMais4_out_2,
						 DOUT 	=> DOUT_EXMEM,
						 ENABLE 	=> '1',
						 CLK 		=> CLK,
						 RST 		=> '0');
	
	---------------------------------------------------------------------------------------------------
	
		MEM_BLOCK : entity work.memBlock
			generic map (larguraDados => larguraDados)
			port map (CLK 					=> CLK,
						 ULASaida 			=> ULASaida_out_3,
						 dadoLidoReg2 		=> dadoLidoReg2_out_3,
						 RAMsaida 			=> RAMsaida,
						 sinal_controle	=> sinal_controle_out_3,
						 beqORbne			=> beqORbne_out_3,
						 saidaMUXbeq		=> saidaMUXbeq_out_3,
						 zeroANDbeq			=> zeroANDbeq);
	
		MEMWB_register : entity work.registradorGenerico
			generic map (larguraDados => 131)
			port map (DIN 		=> endReg3_out_3 & sinal_controle_out_3 & ULASaida_out_3 & RAMsaida & EndMais4_out_3 & Imediato16_out_3,
						 DOUT 	=> DOUT_MEMWB,
						 ENABLE 	=> '1',
						 CLK 		=> CLK,
						 RST 		=> '0');
	
		-- Define a entidade que implementa o MUX que seleciona entre o
		-- dado lido da RAM e a saída da ULA.
		MUX_ESCREVE_REG_3 : entity work.muxGenerico4x1
			generic map (larguraDados => larguraDados)
			port map (entradaA_MUX 	=> ULASaida_out_4,
						  entradaB_MUX => RAMsaida,
						  entradaC_MUX => EndMais4_out_4,
						  entradaD_MUX => Imediato16_out_4 & 16x"0",
						  seletor_MUX 	=> selMuxEscreveReg3,
						  saida_MUX 	=> dadoEscritaReg3);

	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
		-- Define as entidades utilizadas para testar o funcionamento da CPU.
		MUX_DISPLAY :  entity work.muxGenerico4x1
			generic map (larguraDados => larguraDados)
			port map( entradaA_MUX 	=> Endereco,
						 entradaB_MUX 	=> EndMais4_out_2,
						 entradaC_MUX 	=> ULASaida,
						 entradaD_MUX 	=> dadoEscritaReg3,
						 seletor_MUX 	=> SW(1 downto 0), 
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
		
		EndMais4_out_1 				<= DOUT_IFID(63 downto 32);
		ROMsaida_out_1 				<= DOUT_IFID(31 downto 0);
		
		endRegRT_out_2 				<= DOUT_IDEX(179 downto 175);
		endRegRD_out_2 				<= DOUT_IDEX(174 downto 170);
		EndMais4_out_2 				<= DOUT_IDEX(169 downto 138);
		sinal_controle_out_2 		<= DOUT_IDEX(137 downto 124);
		dadoLidoReg1_out_2 			<= DOUT_IDEX(123 downto 92);
		dadoLidoReg2_out_2 			<= DOUT_IDEX(91 downto 60);
		SigExtIm_out_2 				<= DOUT_IDEX(59 downto 28);
		Imediato16_out_2 				<= DOUT_IDEX(27 downto 12);
		opcode_out_2					<= DOUT_IDEX(11 downto 6);
		funct_out_2						<= DOUT_IDEX(5 downto 0);
		
		Imediato16_out_3				<= DOUT_EXMEM(164 downto 149);
		EndMais4MaisImShft_out_3 	<= DOUT_EXMEM(148 downto 117);
		endReg3_out_3 					<= DOUT_EXMEM(116 downto 112);
		ULASaida_out_3 				<= DOUT_EXMEM(111 downto 80);
		beqORbne_out_3 				<= DOUT_EXMEM(79);
		saidaMUXbeq_out_3 			<= DOUT_EXMEM(78);
		dadoLidoReg2_out_3 			<= DOUT_EXMEM(77 downto 46);
		sinal_controle_out_3 		<= DOUT_EXMEM(45 downto 32);
		EndMais4_out_3 				<= DOUT_EXMEM(31 downto 0);
		
		endReg3_out_4					<= DOUT_MEMWB(130 downto 126);
		sinal_controle_out_4			<= DOUT_MEMWB(125 downto 112);
		ULASaida_out_4 				<= DOUT_MEMWB(111 downto 80);
		RAMsaida_out_4					<= DOUT_MEMWB(79 downto 48);
		EndMais4_out_4 				<= DOUT_MEMWB(47 downto 16);
		Imediato16_out_4				<= DOUT_MEMWB(15 downto 0);

	
		-- Preenche os sinais da CPU com seus respectivos valores.
		
		selMuxEscreveReg3  			<= sinal_controle_out_4(5 downto 4);
		habEscritaReg 		 			<= sinal_controle_out_4(8);
		
		-----------------------------------------------------------
		
		selMuxProxPC		 			<= sinal_controle(12);
		selJR					 			<= sinal_controle(13);
	
		-- Preeche as saídas do top-level da CPU utilizadas para testar o funcionamento.
		HEX0 								<= entrada_hex0;
		HEX1 								<= entrada_hex1;
		HEX2 								<= entrada_hex2;
		HEX3 								<= entrada_hex3;
		HEX4 								<= entrada_hex4;
		HEX5 								<= entrada_hex5;
		
		
		LEDR(3 downto 0) 				<= saidaMUXDisplay(27 downto 24);
		LEDR(7 downto 4) 				<= saidaMUXDisplay(31 downto 28);
		LEDR(8)			  				<= habEscritaReg;
		LEDR(9)			  				<= zero;
		
end architecture;