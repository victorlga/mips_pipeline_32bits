library ieee;
use ieee.std_logic_1164.all;

entity mips is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 32;
            simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLOCK_50 : in std_logic; -- clock de 50 MHz
	 FPGA_RESET_N : in std_logic; -- botão de reset
    KEY : in std_logic_vector(3 downto 0); -- 4 botões
	 SW : in std_logic_vector(9 downto 0); -- 10 chaves
	 
	 LEDR : out std_logic_vector(9 downto 0); -- 10 leds
	
	-- 6 displays de 7 segmentos
	--ROM_AddressOUT : out std_logic_vector(addrWidth - 1 downto 0);
	 HEX0: out std_logic_vector(6 downto 0);
	 HEX1: out std_logic_vector(6 downto 0);
	 HEX2: out std_logic_vector(6 downto 0);
	 HEX3: out std_logic_vector(6 downto 0);
	 HEX4: out std_logic_vector(6 downto 0);
	 HEX5: out std_logic_vector(6 downto 0);
	 
	 saidaMUXDisplay : out std_logic_vector(larguraDados-1 downto 0);
	 saidaROM : out std_logic_vector (larguraDados-1 downto 0)
  );
end entity;

architecture arquitetura of mips is

	signal CLK : std_logic;
	
	signal sinal_controle : std_logic_vector (8 downto 0);
	
	signal proxEnd : std_logic_vector (larguraDados-1 downto 0);
	signal Endereco : std_logic_vector (larguraDados-1 downto 0);
	signal EndMais4 : std_logic_vector (larguraDados-1 downto 0);
	signal EndMais4MaisImShft : std_logic_vector (larguraDados-1 downto 0);
	signal SigExtIm : std_logic_vector (larguraDados-1 downto 0);
	signal SigExtImShft : std_logic_vector (larguraDados-1 downto 0);
	
	signal zeroANDbeq : std_logic;
	
	signal zero : std_logic;
	signal ULASaida : std_logic_vector (larguraDados-1 downto 0);
	
	signal ROMsaida : std_logic_vector (larguraDados-1 downto 0);
	
	signal endReg3 : std_logic_vector (4 downto 0);
	
	signal opcode 	 : std_logic_vector (5 downto 0);
	signal endRegRS : std_logic_vector (4 downto 0);
	signal endRegRT : std_logic_vector (4 downto 0);
	signal endRegRD : std_logic_vector (4 downto 0);
	signal shant 	 : std_logic_vector (4 downto 0);
	signal funct  	 : std_logic_vector (5 downto 0);
	
	signal Imediato26 : std_logic_vector (25 downto 0);
	signal Imediato26Shft : std_logic_vector (27 downto 0);
	
	signal Imediato16 : std_logic_vector (15 downto 0);
	
	
	signal entradaAMuxProxPC : std_logic_vector (larguraDados-1 downto 0);
	signal entradaBMuxProxPC : std_logic_vector (larguraDados-1 downto 0);
	signal selMuxProxPC : std_logic;
	
	signal selMuxRTRD : std_logic;
	signal habEscritaReg : std_logic;
	
	signal dadoEscritaReg3 : std_logic_vector (larguraDados-1 downto 0);
	signal dadoLidoReg1 : std_logic_vector (larguraDados-1 downto 0);
	signal dadoLidoReg2 : std_logic_vector (larguraDados-1 downto 0);
	signal entradaB_ULA : std_logic_vector (larguraDados-1 downto 0);
	
	signal selMuxRegSig : std_logic;
	signal selMuxULARAM : std_logic;
	signal beq : std_logic;
	signal tipoR : std_logic;
	
	signal ULActrl : std_logic_vector(3 downto 0);
	
	signal RAMsaida : std_logic_vector (larguraDados-1 downto 0);
	signal habEscritaRAM : std_logic;
	signal habLeituraRAM : std_logic;
	
	-- signal entrada_hex0,entrada_hex1,entrada_hex2,entrada_hex3,entrada_hex4,entrada_hex5: std_logic_vector(6 downto 0);
	
	-- signal saidaMUXDisplay: std_logic_vector(larguraDados-1 downto 0);
	
begin

	gravar:  if simulacao generate
		CLK <= KEY(0);
	else generate
		detectorSub0: work.edgeDetector(bordaSubida)
			  port map (clk => CLOCK_50, entrada => (not KEY(0)), saida => CLK);
	end generate;

	PROGRAM_COUNTER : entity work.registradorGenerico
		generic map (larguraDados => larguraDados)
		port map (DIN => proxEnd,
					 DOUT => Endereco,
					 ENABLE => '1',
					 CLK => CLK,
					 RST => '0');
	
	SOMA_CONST_4 : entity work.somaConstante
		generic map (larguraDados => larguraDados,
						 constante => 4)
		port map (entrada => Endereco,
					 saida => EndMais4);
	
	SOMA_PC_SIG : entity work.somadorGenerico
		generic map (larguraDados => larguraDados)
		port map (entradaA => EndMais4,
					 entradaB => SigExtImShft,
					 saida => EndMais4MaisImShft);

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
					  
	ULA : entity work.ULAMIPS
		generic map (larguraDados => larguraDados)
      port map (entradaA => dadoLidoReg1,
					 entradaB => entradaB_ULA,
					 saida => ULASaida,
					 zero => zero,
					 seletor => ULActrl);
					 
	ROM : entity work.ROMMIPS
		generic map (dataWidth => larguraDados,
						 addrWidth => larguraDados,
						 memoryAddrWidth => 6)
		port map (Endereco => Endereco,
					 Dado => ROMsaida);
					 
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
					 
	MUX_RT_RD : entity work.muxGenerico2x1
		generic map (larguraDados => 5)
		port map (entradaA_MUX => endRegRT,
                 entradaB_MUX => endRegRD,
                 seletor_MUX => selMuxRTRD,
                 saida_MUX => endReg3);
	
	MUX_PC_SIGEXT : entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
		port map (entradaA_MUX => EndMais4,
                 entradaB_MUX => EndMais4MaisImShft,
                 seletor_MUX => zeroANDbeq,
                 saida_MUX => entradaAMuxProxPC);
					  
	MUX_REG_SIGEXT : entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
		port map (entradaA_MUX => dadoLidoReg2,
                 entradaB_MUX => SigExtIm,
                 seletor_MUX => selMuxRegSig,
                 saida_MUX => entradaB_ULA);
					  
	MUX_ULA_RAM : entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
		port map (entradaA_MUX => ULASaida,
                 entradaB_MUX => RAMsaida,
                 seletor_MUX => selMuxULARAM,
                 saida_MUX => dadoEscritaReg3);
					  
	MUX_PROX_PC : entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
		port map (entradaA_MUX => entradaAMuxProxPC,
                 entradaB_MUX => entradaBMuxProxPC,
                 seletor_MUX => selMuxProxPC,
                 saida_MUX => proxEnd);
					  
	ESTENDE_SIN_IM : entity work.estendeSinalGenerico
		generic map (larguraDadoEntrada => 16,
						 larguraDadoSaida => larguraDados)
		port map(estendeSinal_IN => Imediato16,
					estendeSinal_OUT => SigExtIm);
	
	UNID_CONTROLE_DADOS : entity work.unidadeControleDados
		port map (opcode => opcode,
					 sinal_controle => sinal_controle);
					 
	UNID_CONTROLE_ULA : entity work.unidadeControleULA
		port map (opcode => opcode,
					 funct => funct,
					 tipoR => tipoR,
					 ULActrl => ULActrl);
					 
	MUX_DISPLAY :  entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
      port map( entradaA_MUX => Endereco,
                entradaB_MUX => dadoEscritaReg3,
                seletor_MUX => SW(0), 
                saida_MUX => saidaMUXDisplay);
	/*	 
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
	*/

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
	
	/*
	HEX0 <= entrada_hex0;
	HEX1 <= entrada_hex1;
	HEX2 <= entrada_hex2;
	HEX3 <= entrada_hex3;
	HEX4 <= entrada_hex4;
	HEX5 <= entrada_hex5;
	
	
	LEDR(3 downto 0) <= saidaMUXDisplay(27 downto 24);
	LEDR(7 downto 4) <= saidaMUXDisplay(31 downto 28);
	*/
	

end architecture;