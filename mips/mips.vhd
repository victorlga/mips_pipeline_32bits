library ieee;
use ieee.std_logic_1164.all;

entity mips is
  -- Total de bits das entradas e saidas
  generic ( larguraDados : natural := 32;
            simulacao : boolean := TRUE -- para gravar na placa, altere de TRUE para FALSE
  );
  port   (
    CLOCK_50 : in std_logic;
    KEY: in std_logic_vector(larguraDados-1 downto 0);
    SW: in std_logic_vector(9 downto 0);
    LEDR  : out std_logic_vector(9 downto 0)
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
	alias SigExtImShft : std_logic_vector (larguraDados-1 downto 0) is std_logic_vector(SigExtIm(29 downto 0) & "00");
	
	alias zeroANDbeq : std_logic is std_logic(bed and zero);
	
	signal zero : std_logic;
	signal ULASaida : std_logic_vector (larguraDados-1 downto 0);
	
	signal ROMsaida : std_logic_vector (larguraDados-1 downto 0);
	
	signal endReg3 : std_logic_vector (4 downto 0);
	
	alias opcode : std_logic_vector (5 downto 0) is ROMsaida(31 downto 26);
	alias endRegRS : std_logic_vector (4 downto 0) is ROMsaida(25 downto 21);
	alias endRegRT : std_logic_vector (4 downto 0) is ROMsaida(20 downto 16);
	alias endRegRD : std_logic_vector (4 downto 0) is ROMsaida(15 downto 11);
	alias shant : std_logic_vector (4 downto 0) is ROMsaida(10 downto 6);
	alias funct : std_logic_vector (4 downto 0) is ROMsaida(5 downto 0);
	
	alias Imediato26 : std_logic_vector (25 downto 0) is ROMsaida(25 downto 0);
	alias Imediato26Shft : std_logic_vector (27 downto 0) is std_logic_vector(Imediato26 & "00");
	
	alias Imediato16 : std_logic_vector (15 downto 0) is ROMsaida(15 downto 0);
	
	
	signal entradaAMuxProxPC : std_logic_vector (larguraDados-1 downto 0);
	alias entradaBMuxProxPC : std_logic_vector (larguraDados-1 downto 0) is std_logic_vector(EndMais4(31 downto 28) & Imediato26Shft);
	alias selMuxProxPC : std_logic is sinal_controle(8);
	
	alias selMuxRTRD : std_logic is sinal_controle(7);
	alias habEscritaReg : std_logic is sinal_controle(6);
	
	signal dadoEscritaReg3 : std_logic_vector (larguraDados-1 downto 0);
	signal dadoLidoReg1 : std_logic_vector (larguraDados-1 downto 0);
	signal dadoLidoReg2 : std_logic_vector (larguraDados-1 downto 0);
	signal entradaB_ULA : std_logic_vector (larguraDados-1 downto 0);
	
	alias selMuxRegSig : std_logic is sinal_controle(5);
	alias selMuxULARAM : std_logic is sinal_controle(3);
	alias beq : std_logic is sinal_controle(2);
	alias tipoR : std_logic is sinal_controle(4);
	
	signal ULActrl : std_logic_vector(3 downto 0);
	
	signal RAMsaida : std_logic_vector (larguraDados-1 downto 0);
	alias habEscritaRAM : std_logic is sinal_controle(0);
	alias habLeituraRAM : std_logic is sinal_controle(1);
	
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
					habilita => 1,
					Dado_out => RAMsaida);
					 
	MUX_RT_RD : entity work.muxGenerico2x1
		generic map (larguraDados => larguraDados)
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

end architecture;