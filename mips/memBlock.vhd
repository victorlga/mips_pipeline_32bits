library ieee;
use ieee.std_logic_1164.all;

entity memBlock is
    generic (larguraDados     : natural := 32);
    port (CLK        		 	: in std_logic;
			 ULASaida				: in std_logic_vector(larguraDados-1 downto 0);
			 dadoLidoReg2			: in std_logic_vector(larguraDados-1 downto 0);
			 RAMsaida				: out std_logic_vector(larguraDados-1 downto 0);
			 
			 sinal_controle		: in std_logic_vector(13 downto 0);

			 beqORbne				: in std_logic;
			 saidaMUXbeq			: in std_logic;
			 zeroANDbeq				: out std_logic);
			 
end entity;
		
architecture arquitetura of memBlock is

		signal habEscritaRAM : std_logic;
		signal habLeituraRAM : std_logic;

	begin
	
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
						
		habEscritaRAM 		 <= sinal_controle(0);
		habLeituraRAM 		 <= sinal_controle(1);
		
		zeroANDbeq	  		 <= beqORbne and saidaMUXbeq;
	
end architecture;