library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity ULAMIPS is
    generic ( larguraDados : natural := 4 );
    port (
      entradaA, entradaB:  in STD_LOGIC_VECTOR((larguraDados-1) downto 0);
      seletor:  in STD_LOGIC_VECTOR(3 downto 0);
      saida:    out STD_LOGIC_VECTOR((larguraDados-1) downto 0);
		zero: 	 out std_logic
    );
end entity;

architecture comportamento of ULAMIPS is

	signal overflow : std_logic;
	signal saida_intermed : std_logic_vector((larguraDados-1) downto 0);
	
	alias inverteA : std_logic is seletor(3);
	alias inverteB : std_logic is seletor(2);
	
	signal carry_in_0 : std_logic;
	signal saida_intermed_MUX_A_0 : std_logic;
	signal saida_intermed_MUX_B_0 : std_logic;
	signal carry_out_0 : std_logic;
	signal and_op_0 : std_logic;
	signal or_op_0 : std_logic;
	signal sum_sub_op_0 : std_logic;
	signal slt_op_0 : std_logic;
	
	
	
	signal carry_in_1 : std_logic;
	signal saida_intermed_MUX_A_1 : std_logic;
	signal saida_intermed_MUX_B_1 : std_logic;
	signal carry_out_1 : std_logic;
	signal and_op_1 : std_logic;
	signal or_op_1 : std_logic;
	signal sum_sub_op_1 : std_logic;
	signal slt_op_1 : std_logic;
	
    
	
	signal carry_in_2 : std_logic;
	signal saida_intermed_MUX_A_2 : std_logic;
	signal saida_intermed_MUX_B_2 : std_logic;
	signal carry_out_2 : std_logic;
	signal and_op_2 : std_logic;
	signal or_op_2 : std_logic;
	signal sum_sub_op_2 : std_logic;
	signal slt_op_2 : std_logic;
	
    
	
	signal carry_in_3 : std_logic;
	signal saida_intermed_MUX_A_3 : std_logic;
	signal saida_intermed_MUX_B_3 : std_logic;
	signal carry_out_3 : std_logic;
	signal and_op_3 : std_logic;
	signal or_op_3 : std_logic;
	signal sum_sub_op_3 : std_logic;
	signal slt_op_3 : std_logic;
	
    
	
	signal carry_in_4 : std_logic;
	signal saida_intermed_MUX_A_4 : std_logic;
	signal saida_intermed_MUX_B_4 : std_logic;
	signal carry_out_4 : std_logic;
	signal and_op_4 : std_logic;
	signal or_op_4 : std_logic;
	signal sum_sub_op_4 : std_logic;
	signal slt_op_4 : std_logic;
	
    
	
	signal carry_in_5 : std_logic;
	signal saida_intermed_MUX_A_5 : std_logic;
	signal saida_intermed_MUX_B_5 : std_logic;
	signal carry_out_5 : std_logic;
	signal and_op_5 : std_logic;
	signal or_op_5 : std_logic;
	signal sum_sub_op_5 : std_logic;
	signal slt_op_5 : std_logic;
	
    
	
	signal carry_in_6 : std_logic;
	signal saida_intermed_MUX_A_6 : std_logic;
	signal saida_intermed_MUX_B_6 : std_logic;
	signal carry_out_6 : std_logic;
	signal and_op_6 : std_logic;
	signal or_op_6 : std_logic;
	signal sum_sub_op_6 : std_logic;
	signal slt_op_6 : std_logic;
	
    
	
	signal carry_in_7 : std_logic;
	signal saida_intermed_MUX_A_7 : std_logic;
	signal saida_intermed_MUX_B_7 : std_logic;
	signal carry_out_7 : std_logic;
	signal and_op_7 : std_logic;
	signal or_op_7 : std_logic;
	signal sum_sub_op_7 : std_logic;
	signal slt_op_7 : std_logic;
	
    
	
	signal carry_in_8 : std_logic;
	signal saida_intermed_MUX_A_8 : std_logic;
	signal saida_intermed_MUX_B_8 : std_logic;
	signal carry_out_8 : std_logic;
	signal and_op_8 : std_logic;
	signal or_op_8 : std_logic;
	signal sum_sub_op_8 : std_logic;
	signal slt_op_8 : std_logic;
	
    
	
	signal carry_in_9 : std_logic;
	signal saida_intermed_MUX_A_9 : std_logic;
	signal saida_intermed_MUX_B_9 : std_logic;
	signal carry_out_9 : std_logic;
	signal and_op_9 : std_logic;
	signal or_op_9 : std_logic;
	signal sum_sub_op_9 : std_logic;
	signal slt_op_9 : std_logic;
	
    
	
	signal carry_in_10 : std_logic;
	signal saida_intermed_MUX_A_10 : std_logic;
	signal saida_intermed_MUX_B_10 : std_logic;
	signal carry_out_10 : std_logic;
	signal and_op_10 : std_logic;
	signal or_op_10 : std_logic;
	signal sum_sub_op_10 : std_logic;
	signal slt_op_10 : std_logic;
	
    
	
	signal carry_in_11 : std_logic;
	signal saida_intermed_MUX_A_11 : std_logic;
	signal saida_intermed_MUX_B_11 : std_logic;
	signal carry_out_11 : std_logic;
	signal and_op_11 : std_logic;
	signal or_op_11 : std_logic;
	signal sum_sub_op_11 : std_logic;
	signal slt_op_11 : std_logic;
	
    
	
	signal carry_in_12 : std_logic;
	signal saida_intermed_MUX_A_12 : std_logic;
	signal saida_intermed_MUX_B_12 : std_logic;
	signal carry_out_12 : std_logic;
	signal and_op_12 : std_logic;
	signal or_op_12 : std_logic;
	signal sum_sub_op_12 : std_logic;
	signal slt_op_12 : std_logic;
	
    
	
	signal carry_in_13 : std_logic;
	signal saida_intermed_MUX_A_13 : std_logic;
	signal saida_intermed_MUX_B_13 : std_logic;
	signal carry_out_13 : std_logic;
	signal and_op_13 : std_logic;
	signal or_op_13 : std_logic;
	signal sum_sub_op_13 : std_logic;
	signal slt_op_13 : std_logic;
	
    
	
	signal carry_in_14 : std_logic;
	signal saida_intermed_MUX_A_14 : std_logic;
	signal saida_intermed_MUX_B_14 : std_logic;
	signal carry_out_14 : std_logic;
	signal and_op_14 : std_logic;
	signal or_op_14 : std_logic;
	signal sum_sub_op_14 : std_logic;
	signal slt_op_14 : std_logic;
	
    
	
	signal carry_in_15 : std_logic;
	signal saida_intermed_MUX_A_15 : std_logic;
	signal saida_intermed_MUX_B_15 : std_logic;
	signal carry_out_15 : std_logic;
	signal and_op_15 : std_logic;
	signal or_op_15 : std_logic;
	signal sum_sub_op_15 : std_logic;
	signal slt_op_15 : std_logic;
	
    
	
	signal carry_in_16 : std_logic;
	signal saida_intermed_MUX_A_16 : std_logic;
	signal saida_intermed_MUX_B_16 : std_logic;
	signal carry_out_16 : std_logic;
	signal and_op_16 : std_logic;
	signal or_op_16 : std_logic;
	signal sum_sub_op_16 : std_logic;
	signal slt_op_16 : std_logic;
	
    
	
	signal carry_in_17 : std_logic;
	signal saida_intermed_MUX_A_17 : std_logic;
	signal saida_intermed_MUX_B_17 : std_logic;
	signal carry_out_17 : std_logic;
	signal and_op_17 : std_logic;
	signal or_op_17 : std_logic;
	signal sum_sub_op_17 : std_logic;
	signal slt_op_17 : std_logic;
	
    
	
	signal carry_in_18 : std_logic;
	signal saida_intermed_MUX_A_18 : std_logic;
	signal saida_intermed_MUX_B_18 : std_logic;
	signal carry_out_18 : std_logic;
	signal and_op_18 : std_logic;
	signal or_op_18 : std_logic;
	signal sum_sub_op_18 : std_logic;
	signal slt_op_18 : std_logic;
	
    
	
	signal carry_in_19 : std_logic;
	signal saida_intermed_MUX_A_19 : std_logic;
	signal saida_intermed_MUX_B_19 : std_logic;
	signal carry_out_19 : std_logic;
	signal and_op_19 : std_logic;
	signal or_op_19 : std_logic;
	signal sum_sub_op_19 : std_logic;
	signal slt_op_19 : std_logic;
	
    
	
	signal carry_in_20 : std_logic;
	signal saida_intermed_MUX_A_20 : std_logic;
	signal saida_intermed_MUX_B_20 : std_logic;
	signal carry_out_20 : std_logic;
	signal and_op_20 : std_logic;
	signal or_op_20 : std_logic;
	signal sum_sub_op_20 : std_logic;
	signal slt_op_20 : std_logic;
	
    
	
	signal carry_in_21 : std_logic;
	signal saida_intermed_MUX_A_21 : std_logic;
	signal saida_intermed_MUX_B_21 : std_logic;
	signal carry_out_21 : std_logic;
	signal and_op_21 : std_logic;
	signal or_op_21 : std_logic;
	signal sum_sub_op_21 : std_logic;
	signal slt_op_21 : std_logic;
	
    
	
	signal carry_in_22 : std_logic;
	signal saida_intermed_MUX_A_22 : std_logic;
	signal saida_intermed_MUX_B_22 : std_logic;
	signal carry_out_22 : std_logic;
	signal and_op_22 : std_logic;
	signal or_op_22 : std_logic;
	signal sum_sub_op_22 : std_logic;
	signal slt_op_22 : std_logic;
	
    
	
	signal carry_in_23 : std_logic;
	signal saida_intermed_MUX_A_23 : std_logic;
	signal saida_intermed_MUX_B_23 : std_logic;
	signal carry_out_23 : std_logic;
	signal and_op_23 : std_logic;
	signal or_op_23 : std_logic;
	signal sum_sub_op_23 : std_logic;
	signal slt_op_23 : std_logic;
	
    
	
	signal carry_in_24 : std_logic;
	signal saida_intermed_MUX_A_24 : std_logic;
	signal saida_intermed_MUX_B_24 : std_logic;
	signal carry_out_24 : std_logic;
	signal and_op_24 : std_logic;
	signal or_op_24 : std_logic;
	signal sum_sub_op_24 : std_logic;
	signal slt_op_24 : std_logic;
	
    
	
	signal carry_in_25 : std_logic;
	signal saida_intermed_MUX_A_25 : std_logic;
	signal saida_intermed_MUX_B_25 : std_logic;
	signal carry_out_25 : std_logic;
	signal and_op_25 : std_logic;
	signal or_op_25 : std_logic;
	signal sum_sub_op_25 : std_logic;
	signal slt_op_25 : std_logic;
	
    
	
	signal carry_in_26 : std_logic;
	signal saida_intermed_MUX_A_26 : std_logic;
	signal saida_intermed_MUX_B_26 : std_logic;
	signal carry_out_26 : std_logic;
	signal and_op_26 : std_logic;
	signal or_op_26 : std_logic;
	signal sum_sub_op_26 : std_logic;
	signal slt_op_26 : std_logic;
	
    
	
	signal carry_in_27 : std_logic;
	signal saida_intermed_MUX_A_27 : std_logic;
	signal saida_intermed_MUX_B_27 : std_logic;
	signal carry_out_27 : std_logic;
	signal and_op_27 : std_logic;
	signal or_op_27 : std_logic;
	signal sum_sub_op_27 : std_logic;
	signal slt_op_27 : std_logic;
	
    
	
	signal carry_in_28 : std_logic;
	signal saida_intermed_MUX_A_28 : std_logic;
	signal saida_intermed_MUX_B_28 : std_logic;
	signal carry_out_28 : std_logic;
	signal and_op_28 : std_logic;
	signal or_op_28 : std_logic;
	signal sum_sub_op_28 : std_logic;
	signal slt_op_28 : std_logic;
	
    
	
	signal carry_in_29 : std_logic;
	signal saida_intermed_MUX_A_29 : std_logic;
	signal saida_intermed_MUX_B_29 : std_logic;
	signal carry_out_29 : std_logic;
	signal and_op_29 : std_logic;
	signal or_op_29 : std_logic;
	signal sum_sub_op_29 : std_logic;
	signal slt_op_29 : std_logic;
	
    
	
	signal carry_in_30 : std_logic;
	signal saida_intermed_MUX_A_30 : std_logic;
	signal saida_intermed_MUX_B_30 : std_logic;
	signal carry_out_30 : std_logic;
	signal and_op_30 : std_logic;
	signal or_op_30 : std_logic;
	signal sum_sub_op_30 : std_logic;
	signal slt_op_30 : std_logic;
	
	
	
	signal carry_in_31 : std_logic;
	signal saida_intermed_MUX_A_31 : std_logic;
	signal saida_intermed_MUX_B_31 : std_logic;
	signal and_op_31 : std_logic;
	signal or_op_31 : std_logic;
	signal sum_sub_op_31 : std_logic;
	signal slt_op_31 : std_logic;
	
    
	
   begin
	
		saida_intermed_MUX_A_0 <= (not entradaA(0)) when (inverteA = '1') else entradaA(0);
      saida_intermed_MUX_B_0 <= (not entradaB(0)) when (inverteB = '1') else entradaB(0);
		
		and_op_0 	  <= std_logic(saida_intermed_MUX_B_0 and saida_intermed_MUX_A_0);
		or_op_0  	  <= std_logic(saida_intermed_MUX_B_0 or saida_intermed_MUX_A_0);
		
		carry_in_0	  <= inverteB;
		sum_sub_op_0  <= std_logic((saida_intermed_MUX_A_0 xor saida_intermed_MUX_B_0) xor carry_in_0);
		carry_out_0	  <= std_logic((saida_intermed_MUX_A_0 and saida_intermed_MUX_B_0) or ((saida_intermed_MUX_A_0 xor saida_intermed_MUX_B_0) and carry_in_0));
		
		slt_op_0		  <= overflow;
		
      saida_intermed(0) 	  <= and_op_0  	when (seletor(1 downto 0) = "00") else
							  or_op_0 	  	when (seletor(1 downto 0) = "01") else
							  sum_sub_op_0 when (seletor(1 downto 0) = "10") else
							  slt_op_0;

        saida_intermed_MUX_A_1 <= (not entradaA(1)) when (inverteA = '1') else entradaA(1);
        saida_intermed_MUX_B_1 <= (not entradaB(1)) when (inverteB = '1') else entradaB(1);
            
        and_op_1 	    <= std_logic(saida_intermed_MUX_B_1 and saida_intermed_MUX_A_1);
        or_op_1  	    <= std_logic(saida_intermed_MUX_B_1 or saida_intermed_MUX_A_1);
        
        carry_in_1	<= carry_out_0;
        sum_sub_op_1  <= std_logic((saida_intermed_MUX_A_1 xor saida_intermed_MUX_B_1) xor carry_in_1);
        carry_out_1	<= std_logic((saida_intermed_MUX_A_1 and saida_intermed_MUX_B_1) or ((saida_intermed_MUX_A_1 xor saida_intermed_MUX_B_1) and carry_in_1));
        
        slt_op_1		<= '0';
            
        saida_intermed(1) 	    <= and_op_1  	  when (seletor(1 downto 0) = "00") else
                           or_op_1 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_1 when (seletor(1 downto 0) = "10") else
                           slt_op_1;
    
        saida_intermed_MUX_A_2 <= (not entradaA(2)) when (inverteA = '1') else entradaA(2);
        saida_intermed_MUX_B_2 <= (not entradaB(2)) when (inverteB = '1') else entradaB(2);
            
        and_op_2 	    <= std_logic(saida_intermed_MUX_B_2 and saida_intermed_MUX_A_2);
        or_op_2  	    <= std_logic(saida_intermed_MUX_B_2 or saida_intermed_MUX_A_2);
        
        carry_in_2	<= carry_out_1;
        sum_sub_op_2  <= std_logic((saida_intermed_MUX_A_2 xor saida_intermed_MUX_B_2) xor carry_in_2);
        carry_out_2	<= std_logic((saida_intermed_MUX_A_2 and saida_intermed_MUX_B_2) or ((saida_intermed_MUX_A_2 xor saida_intermed_MUX_B_2) and carry_in_2));
        
        slt_op_2		<= '0';
            
        saida_intermed(2) 	    <= and_op_2  	  when (seletor(1 downto 0) = "00") else
                           or_op_2 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_2 when (seletor(1 downto 0) = "10") else
                           slt_op_2;
    
        saida_intermed_MUX_A_3 <= (not entradaA(3)) when (inverteA = '1') else entradaA(3);
        saida_intermed_MUX_B_3 <= (not entradaB(3)) when (inverteB = '1') else entradaB(3);
            
        and_op_3 	    <= std_logic(saida_intermed_MUX_B_3 and saida_intermed_MUX_A_3);
        or_op_3  	    <= std_logic(saida_intermed_MUX_B_3 or saida_intermed_MUX_A_3);
        
        carry_in_3	<= carry_out_2;
        sum_sub_op_3  <= std_logic((saida_intermed_MUX_A_3 xor saida_intermed_MUX_B_3) xor carry_in_3);
        carry_out_3	<= std_logic((saida_intermed_MUX_A_3 and saida_intermed_MUX_B_3) or ((saida_intermed_MUX_A_3 xor saida_intermed_MUX_B_3) and carry_in_3));
        
        slt_op_3		<= '0';
            
        saida_intermed(3) 	    <= and_op_3  	  when (seletor(1 downto 0) = "00") else
                           or_op_3 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_3 when (seletor(1 downto 0) = "10") else
                           slt_op_3;
    
        saida_intermed_MUX_A_4 <= (not entradaA(4)) when (inverteA = '1') else entradaA(4);
        saida_intermed_MUX_B_4 <= (not entradaB(4)) when (inverteB = '1') else entradaB(4);
            
        and_op_4 	    <= std_logic(saida_intermed_MUX_B_4 and saida_intermed_MUX_A_4);
        or_op_4  	    <= std_logic(saida_intermed_MUX_B_4 or saida_intermed_MUX_A_4);
        
        carry_in_4	<= carry_out_3;
        sum_sub_op_4  <= std_logic((saida_intermed_MUX_A_4 xor saida_intermed_MUX_B_4) xor carry_in_4);
        carry_out_4	<= std_logic((saida_intermed_MUX_A_4 and saida_intermed_MUX_B_4) or ((saida_intermed_MUX_A_4 xor saida_intermed_MUX_B_4) and carry_in_4));
        
        slt_op_4		<= '0';
            
        saida_intermed(4) 	    <= and_op_4  	  when (seletor(1 downto 0) = "00") else
                           or_op_4 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_4 when (seletor(1 downto 0) = "10") else
                           slt_op_4;
    
        saida_intermed_MUX_A_5 <= (not entradaA(5)) when (inverteA = '1') else entradaA(5);
        saida_intermed_MUX_B_5 <= (not entradaB(5)) when (inverteB = '1') else entradaB(5);
            
        and_op_5 	    <= std_logic(saida_intermed_MUX_B_5 and saida_intermed_MUX_A_5);
        or_op_5  	    <= std_logic(saida_intermed_MUX_B_5 or saida_intermed_MUX_A_5);
        
        carry_in_5	<= carry_out_4;
        sum_sub_op_5  <= std_logic((saida_intermed_MUX_A_5 xor saida_intermed_MUX_B_5) xor carry_in_5);
        carry_out_5	<= std_logic((saida_intermed_MUX_A_5 and saida_intermed_MUX_B_5) or ((saida_intermed_MUX_A_5 xor saida_intermed_MUX_B_5) and carry_in_5));
        
        slt_op_5		<= '0';
            
        saida_intermed(5) 	    <= and_op_5  	  when (seletor(1 downto 0) = "00") else
                           or_op_5 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_5 when (seletor(1 downto 0) = "10") else
                           slt_op_5;
    
        saida_intermed_MUX_A_6 <= (not entradaA(6)) when (inverteA = '1') else entradaA(6);
        saida_intermed_MUX_B_6 <= (not entradaB(6)) when (inverteB = '1') else entradaB(6);
            
        and_op_6 	    <= std_logic(saida_intermed_MUX_B_6 and saida_intermed_MUX_A_6);
        or_op_6  	    <= std_logic(saida_intermed_MUX_B_6 or saida_intermed_MUX_A_6);
        
        carry_in_6	<= carry_out_5;
        sum_sub_op_6  <= std_logic((saida_intermed_MUX_A_6 xor saida_intermed_MUX_B_6) xor carry_in_6);
        carry_out_6	<= std_logic((saida_intermed_MUX_A_6 and saida_intermed_MUX_B_6) or ((saida_intermed_MUX_A_6 xor saida_intermed_MUX_B_6) and carry_in_6));
        
        slt_op_6		<= '0';
            
        saida_intermed(6) 	    <= and_op_6  	  when (seletor(1 downto 0) = "00") else
                           or_op_6 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_6 when (seletor(1 downto 0) = "10") else
                           slt_op_6;
    
        saida_intermed_MUX_A_7 <= (not entradaA(7)) when (inverteA = '1') else entradaA(7);
        saida_intermed_MUX_B_7 <= (not entradaB(7)) when (inverteB = '1') else entradaB(7);
            
        and_op_7 	    <= std_logic(saida_intermed_MUX_B_7 and saida_intermed_MUX_A_7);
        or_op_7  	    <= std_logic(saida_intermed_MUX_B_7 or saida_intermed_MUX_A_7);
        
        carry_in_7	<= carry_out_6;
        sum_sub_op_7  <= std_logic((saida_intermed_MUX_A_7 xor saida_intermed_MUX_B_7) xor carry_in_7);
        carry_out_7	<= std_logic((saida_intermed_MUX_A_7 and saida_intermed_MUX_B_7) or ((saida_intermed_MUX_A_7 xor saida_intermed_MUX_B_7) and carry_in_7));
        
        slt_op_7		<= '0';
            
        saida_intermed(7) 	    <= and_op_7  	  when (seletor(1 downto 0) = "00") else
                           or_op_7 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_7 when (seletor(1 downto 0) = "10") else
                           slt_op_7;
    
        saida_intermed_MUX_A_8 <= (not entradaA(8)) when (inverteA = '1') else entradaA(8);
        saida_intermed_MUX_B_8 <= (not entradaB(8)) when (inverteB = '1') else entradaB(8);
            
        and_op_8 	    <= std_logic(saida_intermed_MUX_B_8 and saida_intermed_MUX_A_8);
        or_op_8  	    <= std_logic(saida_intermed_MUX_B_8 or saida_intermed_MUX_A_8);
        
        carry_in_8	<= carry_out_7;
        sum_sub_op_8  <= std_logic((saida_intermed_MUX_A_8 xor saida_intermed_MUX_B_8) xor carry_in_8);
        carry_out_8	<= std_logic((saida_intermed_MUX_A_8 and saida_intermed_MUX_B_8) or ((saida_intermed_MUX_A_8 xor saida_intermed_MUX_B_8) and carry_in_8));
        
        slt_op_8		<= '0';
            
        saida_intermed(8) 	    <= and_op_8  	  when (seletor(1 downto 0) = "00") else
                           or_op_8 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_8 when (seletor(1 downto 0) = "10") else
                           slt_op_8;
    
        saida_intermed_MUX_A_9 <= (not entradaA(9)) when (inverteA = '1') else entradaA(9);
        saida_intermed_MUX_B_9 <= (not entradaB(9)) when (inverteB = '1') else entradaB(9);
            
        and_op_9 	    <= std_logic(saida_intermed_MUX_B_9 and saida_intermed_MUX_A_9);
        or_op_9  	    <= std_logic(saida_intermed_MUX_B_9 or saida_intermed_MUX_A_9);
        
        carry_in_9	<= carry_out_8;
        sum_sub_op_9  <= std_logic((saida_intermed_MUX_A_9 xor saida_intermed_MUX_B_9) xor carry_in_9);
        carry_out_9	<= std_logic((saida_intermed_MUX_A_9 and saida_intermed_MUX_B_9) or ((saida_intermed_MUX_A_9 xor saida_intermed_MUX_B_9) and carry_in_9));
        
        slt_op_9		<= '0';
            
        saida_intermed(9) 	    <= and_op_9  	  when (seletor(1 downto 0) = "00") else
                           or_op_9 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_9 when (seletor(1 downto 0) = "10") else
                           slt_op_9;
    
        saida_intermed_MUX_A_10 <= (not entradaA(10)) when (inverteA = '1') else entradaA(10);
        saida_intermed_MUX_B_10 <= (not entradaB(10)) when (inverteB = '1') else entradaB(10);
            
        and_op_10 	    <= std_logic(saida_intermed_MUX_B_10 and saida_intermed_MUX_A_10);
        or_op_10  	    <= std_logic(saida_intermed_MUX_B_10 or saida_intermed_MUX_A_10);
        
        carry_in_10	<= carry_out_9;
        sum_sub_op_10  <= std_logic((saida_intermed_MUX_A_10 xor saida_intermed_MUX_B_10) xor carry_in_10);
        carry_out_10	<= std_logic((saida_intermed_MUX_A_10 and saida_intermed_MUX_B_10) or ((saida_intermed_MUX_A_10 xor saida_intermed_MUX_B_10) and carry_in_10));
        
        slt_op_10		<= '0';
            
        saida_intermed(10) 	    <= and_op_10  	  when (seletor(1 downto 0) = "00") else
                           or_op_10 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_10 when (seletor(1 downto 0) = "10") else
                           slt_op_10;
    
        saida_intermed_MUX_A_11 <= (not entradaA(11)) when (inverteA = '1') else entradaA(11);
        saida_intermed_MUX_B_11 <= (not entradaB(11)) when (inverteB = '1') else entradaB(11);
            
        and_op_11 	    <= std_logic(saida_intermed_MUX_B_11 and saida_intermed_MUX_A_11);
        or_op_11  	    <= std_logic(saida_intermed_MUX_B_11 or saida_intermed_MUX_A_11);
        
        carry_in_11	<= carry_out_10;
        sum_sub_op_11  <= std_logic((saida_intermed_MUX_A_11 xor saida_intermed_MUX_B_11) xor carry_in_11);
        carry_out_11	<= std_logic((saida_intermed_MUX_A_11 and saida_intermed_MUX_B_11) or ((saida_intermed_MUX_A_11 xor saida_intermed_MUX_B_11) and carry_in_11));
        
        slt_op_11		<= '0';
            
        saida_intermed(11) 	    <= and_op_11  	  when (seletor(1 downto 0) = "00") else
                           or_op_11 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_11 when (seletor(1 downto 0) = "10") else
                           slt_op_11;
    
        saida_intermed_MUX_A_12 <= (not entradaA(12)) when (inverteA = '1') else entradaA(12);
        saida_intermed_MUX_B_12 <= (not entradaB(12)) when (inverteB = '1') else entradaB(12);
            
        and_op_12 	    <= std_logic(saida_intermed_MUX_B_12 and saida_intermed_MUX_A_12);
        or_op_12  	    <= std_logic(saida_intermed_MUX_B_12 or saida_intermed_MUX_A_12);
        
        carry_in_12	<= carry_out_11;
        sum_sub_op_12  <= std_logic((saida_intermed_MUX_A_12 xor saida_intermed_MUX_B_12) xor carry_in_12);
        carry_out_12	<= std_logic((saida_intermed_MUX_A_12 and saida_intermed_MUX_B_12) or ((saida_intermed_MUX_A_12 xor saida_intermed_MUX_B_12) and carry_in_12));
        
        slt_op_12		<= '0';
            
        saida_intermed(12) 	    <= and_op_12  	  when (seletor(1 downto 0) = "00") else
                           or_op_12 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_12 when (seletor(1 downto 0) = "10") else
                           slt_op_12;
    
        saida_intermed_MUX_A_13 <= (not entradaA(13)) when (inverteA = '1') else entradaA(13);
        saida_intermed_MUX_B_13 <= (not entradaB(13)) when (inverteB = '1') else entradaB(13);
            
        and_op_13 	    <= std_logic(saida_intermed_MUX_B_13 and saida_intermed_MUX_A_13);
        or_op_13  	    <= std_logic(saida_intermed_MUX_B_13 or saida_intermed_MUX_A_13);
        
        carry_in_13	<= carry_out_12;
        sum_sub_op_13  <= std_logic((saida_intermed_MUX_A_13 xor saida_intermed_MUX_B_13) xor carry_in_13);
        carry_out_13	<= std_logic((saida_intermed_MUX_A_13 and saida_intermed_MUX_B_13) or ((saida_intermed_MUX_A_13 xor saida_intermed_MUX_B_13) and carry_in_13));
        
        slt_op_13		<= '0';
            
        saida_intermed(13) 	    <= and_op_13  	  when (seletor(1 downto 0) = "00") else
                           or_op_13 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_13 when (seletor(1 downto 0) = "10") else
                           slt_op_13;
    
        saida_intermed_MUX_A_14 <= (not entradaA(14)) when (inverteA = '1') else entradaA(14);
        saida_intermed_MUX_B_14 <= (not entradaB(14)) when (inverteB = '1') else entradaB(14);
            
        and_op_14 	    <= std_logic(saida_intermed_MUX_B_14 and saida_intermed_MUX_A_14);
        or_op_14  	    <= std_logic(saida_intermed_MUX_B_14 or saida_intermed_MUX_A_14);
        
        carry_in_14	<= carry_out_13;
        sum_sub_op_14  <= std_logic((saida_intermed_MUX_A_14 xor saida_intermed_MUX_B_14) xor carry_in_14);
        carry_out_14	<= std_logic((saida_intermed_MUX_A_14 and saida_intermed_MUX_B_14) or ((saida_intermed_MUX_A_14 xor saida_intermed_MUX_B_14) and carry_in_14));
        
        slt_op_14		<= '0';
            
        saida_intermed(14) 	    <= and_op_14  	  when (seletor(1 downto 0) = "00") else
                           or_op_14 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_14 when (seletor(1 downto 0) = "10") else
                           slt_op_14;
    
        saida_intermed_MUX_A_15 <= (not entradaA(15)) when (inverteA = '1') else entradaA(15);
        saida_intermed_MUX_B_15 <= (not entradaB(15)) when (inverteB = '1') else entradaB(15);
            
        and_op_15 	    <= std_logic(saida_intermed_MUX_B_15 and saida_intermed_MUX_A_15);
        or_op_15  	    <= std_logic(saida_intermed_MUX_B_15 or saida_intermed_MUX_A_15);
        
        carry_in_15	<= carry_out_14;
        sum_sub_op_15  <= std_logic((saida_intermed_MUX_A_15 xor saida_intermed_MUX_B_15) xor carry_in_15);
        carry_out_15	<= std_logic((saida_intermed_MUX_A_15 and saida_intermed_MUX_B_15) or ((saida_intermed_MUX_A_15 xor saida_intermed_MUX_B_15) and carry_in_15));
        
        slt_op_15		<= '0';
            
        saida_intermed(15) 	    <= and_op_15  	  when (seletor(1 downto 0) = "00") else
                           or_op_15 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_15 when (seletor(1 downto 0) = "10") else
                           slt_op_15;
    
        saida_intermed_MUX_A_16 <= (not entradaA(16)) when (inverteA = '1') else entradaA(16);
        saida_intermed_MUX_B_16 <= (not entradaB(16)) when (inverteB = '1') else entradaB(16);
            
        and_op_16 	    <= std_logic(saida_intermed_MUX_B_16 and saida_intermed_MUX_A_16);
        or_op_16  	    <= std_logic(saida_intermed_MUX_B_16 or saida_intermed_MUX_A_16);
        
        carry_in_16	<= carry_out_15;
        sum_sub_op_16  <= std_logic((saida_intermed_MUX_A_16 xor saida_intermed_MUX_B_16) xor carry_in_16);
        carry_out_16	<= std_logic((saida_intermed_MUX_A_16 and saida_intermed_MUX_B_16) or ((saida_intermed_MUX_A_16 xor saida_intermed_MUX_B_16) and carry_in_16));
        
        slt_op_16		<= '0';
            
        saida_intermed(16) 	    <= and_op_16  	  when (seletor(1 downto 0) = "00") else
                           or_op_16 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_16 when (seletor(1 downto 0) = "10") else
                           slt_op_16;
    
        saida_intermed_MUX_A_17 <= (not entradaA(17)) when (inverteA = '1') else entradaA(17);
        saida_intermed_MUX_B_17 <= (not entradaB(17)) when (inverteB = '1') else entradaB(17);
            
        and_op_17 	    <= std_logic(saida_intermed_MUX_B_17 and saida_intermed_MUX_A_17);
        or_op_17  	    <= std_logic(saida_intermed_MUX_B_17 or saida_intermed_MUX_A_17);
        
        carry_in_17	<= carry_out_16;
        sum_sub_op_17  <= std_logic((saida_intermed_MUX_A_17 xor saida_intermed_MUX_B_17) xor carry_in_17);
        carry_out_17	<= std_logic((saida_intermed_MUX_A_17 and saida_intermed_MUX_B_17) or ((saida_intermed_MUX_A_17 xor saida_intermed_MUX_B_17) and carry_in_17));
        
        slt_op_17		<= '0';
            
        saida_intermed(17) 	    <= and_op_17  	  when (seletor(1 downto 0) = "00") else
                           or_op_17 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_17 when (seletor(1 downto 0) = "10") else
                           slt_op_17;
    
        saida_intermed_MUX_A_18 <= (not entradaA(18)) when (inverteA = '1') else entradaA(18);
        saida_intermed_MUX_B_18 <= (not entradaB(18)) when (inverteB = '1') else entradaB(18);
            
        and_op_18 	    <= std_logic(saida_intermed_MUX_B_18 and saida_intermed_MUX_A_18);
        or_op_18  	    <= std_logic(saida_intermed_MUX_B_18 or saida_intermed_MUX_A_18);
        
        carry_in_18	<= carry_out_17;
        sum_sub_op_18  <= std_logic((saida_intermed_MUX_A_18 xor saida_intermed_MUX_B_18) xor carry_in_18);
        carry_out_18	<= std_logic((saida_intermed_MUX_A_18 and saida_intermed_MUX_B_18) or ((saida_intermed_MUX_A_18 xor saida_intermed_MUX_B_18) and carry_in_18));
        
        slt_op_18		<= '0';
            
        saida_intermed(18) 	    <= and_op_18  	  when (seletor(1 downto 0) = "00") else
                           or_op_18 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_18 when (seletor(1 downto 0) = "10") else
                           slt_op_18;
    
        saida_intermed_MUX_A_19 <= (not entradaA(19)) when (inverteA = '1') else entradaA(19);
        saida_intermed_MUX_B_19 <= (not entradaB(19)) when (inverteB = '1') else entradaB(19);
            
        and_op_19 	    <= std_logic(saida_intermed_MUX_B_19 and saida_intermed_MUX_A_19);
        or_op_19  	    <= std_logic(saida_intermed_MUX_B_19 or saida_intermed_MUX_A_19);
        
        carry_in_19	<= carry_out_18;
        sum_sub_op_19  <= std_logic((saida_intermed_MUX_A_19 xor saida_intermed_MUX_B_19) xor carry_in_19);
        carry_out_19	<= std_logic((saida_intermed_MUX_A_19 and saida_intermed_MUX_B_19) or ((saida_intermed_MUX_A_19 xor saida_intermed_MUX_B_19) and carry_in_19));
        
        slt_op_19		<= '0';
            
        saida_intermed(19) 	    <= and_op_19  	  when (seletor(1 downto 0) = "00") else
                           or_op_19 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_19 when (seletor(1 downto 0) = "10") else
                           slt_op_19;
    
        saida_intermed_MUX_A_20 <= (not entradaA(20)) when (inverteA = '1') else entradaA(20);
        saida_intermed_MUX_B_20 <= (not entradaB(20)) when (inverteB = '1') else entradaB(20);
            
        and_op_20 	    <= std_logic(saida_intermed_MUX_B_20 and saida_intermed_MUX_A_20);
        or_op_20  	    <= std_logic(saida_intermed_MUX_B_20 or saida_intermed_MUX_A_20);
        
        carry_in_20	<= carry_out_19;
        sum_sub_op_20  <= std_logic((saida_intermed_MUX_A_20 xor saida_intermed_MUX_B_20) xor carry_in_20);
        carry_out_20	<= std_logic((saida_intermed_MUX_A_20 and saida_intermed_MUX_B_20) or ((saida_intermed_MUX_A_20 xor saida_intermed_MUX_B_20) and carry_in_20));
        
        slt_op_20		<= '0';
            
        saida_intermed(20) 	    <= and_op_20  	  when (seletor(1 downto 0) = "00") else
                           or_op_20 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_20 when (seletor(1 downto 0) = "10") else
                           slt_op_20;
    
        saida_intermed_MUX_A_21 <= (not entradaA(21)) when (inverteA = '1') else entradaA(21);
        saida_intermed_MUX_B_21 <= (not entradaB(21)) when (inverteB = '1') else entradaB(21);
            
        and_op_21 	    <= std_logic(saida_intermed_MUX_B_21 and saida_intermed_MUX_A_21);
        or_op_21  	    <= std_logic(saida_intermed_MUX_B_21 or saida_intermed_MUX_A_21);
        
        carry_in_21	<= carry_out_20;
        sum_sub_op_21  <= std_logic((saida_intermed_MUX_A_21 xor saida_intermed_MUX_B_21) xor carry_in_21);
        carry_out_21	<= std_logic((saida_intermed_MUX_A_21 and saida_intermed_MUX_B_21) or ((saida_intermed_MUX_A_21 xor saida_intermed_MUX_B_21) and carry_in_21));
        
        slt_op_21		<= '0';
            
        saida_intermed(21) 	    <= and_op_21  	  when (seletor(1 downto 0) = "00") else
                           or_op_21 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_21 when (seletor(1 downto 0) = "10") else
                           slt_op_21;
    
        saida_intermed_MUX_A_22 <= (not entradaA(22)) when (inverteA = '1') else entradaA(22);
        saida_intermed_MUX_B_22 <= (not entradaB(22)) when (inverteB = '1') else entradaB(22);
            
        and_op_22 	    <= std_logic(saida_intermed_MUX_B_22 and saida_intermed_MUX_A_22);
        or_op_22  	    <= std_logic(saida_intermed_MUX_B_22 or saida_intermed_MUX_A_22);
        
        carry_in_22	<= carry_out_21;
        sum_sub_op_22  <= std_logic((saida_intermed_MUX_A_22 xor saida_intermed_MUX_B_22) xor carry_in_22);
        carry_out_22	<= std_logic((saida_intermed_MUX_A_22 and saida_intermed_MUX_B_22) or ((saida_intermed_MUX_A_22 xor saida_intermed_MUX_B_22) and carry_in_22));
        
        slt_op_22		<= '0';
            
        saida_intermed(22) 	    <= and_op_22  	  when (seletor(1 downto 0) = "00") else
                           or_op_22 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_22 when (seletor(1 downto 0) = "10") else
                           slt_op_22;
    
        saida_intermed_MUX_A_23 <= (not entradaA(23)) when (inverteA = '1') else entradaA(23);
        saida_intermed_MUX_B_23 <= (not entradaB(23)) when (inverteB = '1') else entradaB(23);
            
        and_op_23 	    <= std_logic(saida_intermed_MUX_B_23 and saida_intermed_MUX_A_23);
        or_op_23  	    <= std_logic(saida_intermed_MUX_B_23 or saida_intermed_MUX_A_23);
        
        carry_in_23	<= carry_out_22;
        sum_sub_op_23  <= std_logic((saida_intermed_MUX_A_23 xor saida_intermed_MUX_B_23) xor carry_in_23);
        carry_out_23	<= std_logic((saida_intermed_MUX_A_23 and saida_intermed_MUX_B_23) or ((saida_intermed_MUX_A_23 xor saida_intermed_MUX_B_23) and carry_in_23));
        
        slt_op_23		<= '0';
            
        saida_intermed(23) 	    <= and_op_23  	  when (seletor(1 downto 0) = "00") else
                           or_op_23 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_23 when (seletor(1 downto 0) = "10") else
                           slt_op_23;
    
        saida_intermed_MUX_A_24 <= (not entradaA(24)) when (inverteA = '1') else entradaA(24);
        saida_intermed_MUX_B_24 <= (not entradaB(24)) when (inverteB = '1') else entradaB(24);
            
        and_op_24 	    <= std_logic(saida_intermed_MUX_B_24 and saida_intermed_MUX_A_24);
        or_op_24  	    <= std_logic(saida_intermed_MUX_B_24 or saida_intermed_MUX_A_24);
        
        carry_in_24	<= carry_out_23;
        sum_sub_op_24  <= std_logic((saida_intermed_MUX_A_24 xor saida_intermed_MUX_B_24) xor carry_in_24);
        carry_out_24	<= std_logic((saida_intermed_MUX_A_24 and saida_intermed_MUX_B_24) or ((saida_intermed_MUX_A_24 xor saida_intermed_MUX_B_24) and carry_in_24));
        
        slt_op_24		<= '0';
            
        saida_intermed(24) 	    <= and_op_24  	  when (seletor(1 downto 0) = "00") else
                           or_op_24 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_24 when (seletor(1 downto 0) = "10") else
                           slt_op_24;
    
        saida_intermed_MUX_A_25 <= (not entradaA(25)) when (inverteA = '1') else entradaA(25);
        saida_intermed_MUX_B_25 <= (not entradaB(25)) when (inverteB = '1') else entradaB(25);
            
        and_op_25 	    <= std_logic(saida_intermed_MUX_B_25 and saida_intermed_MUX_A_25);
        or_op_25  	    <= std_logic(saida_intermed_MUX_B_25 or saida_intermed_MUX_A_25);
        
        carry_in_25	<= carry_out_24;
        sum_sub_op_25  <= std_logic((saida_intermed_MUX_A_25 xor saida_intermed_MUX_B_25) xor carry_in_25);
        carry_out_25	<= std_logic((saida_intermed_MUX_A_25 and saida_intermed_MUX_B_25) or ((saida_intermed_MUX_A_25 xor saida_intermed_MUX_B_25) and carry_in_25));
        
        slt_op_25		<= '0';
            
        saida_intermed(25) 	    <= and_op_25  	  when (seletor(1 downto 0) = "00") else
                           or_op_25 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_25 when (seletor(1 downto 0) = "10") else
                           slt_op_25;
    
        saida_intermed_MUX_A_26 <= (not entradaA(26)) when (inverteA = '1') else entradaA(26);
        saida_intermed_MUX_B_26 <= (not entradaB(26)) when (inverteB = '1') else entradaB(26);
            
        and_op_26 	    <= std_logic(saida_intermed_MUX_B_26 and saida_intermed_MUX_A_26);
        or_op_26  	    <= std_logic(saida_intermed_MUX_B_26 or saida_intermed_MUX_A_26);
        
        carry_in_26	<= carry_out_25;
        sum_sub_op_26  <= std_logic((saida_intermed_MUX_A_26 xor saida_intermed_MUX_B_26) xor carry_in_26);
        carry_out_26	<= std_logic((saida_intermed_MUX_A_26 and saida_intermed_MUX_B_26) or ((saida_intermed_MUX_A_26 xor saida_intermed_MUX_B_26) and carry_in_26));
        
        slt_op_26		<= '0';
            
        saida_intermed(26) 	    <= and_op_26  	  when (seletor(1 downto 0) = "00") else
                           or_op_26 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_26 when (seletor(1 downto 0) = "10") else
                           slt_op_26;
    
        saida_intermed_MUX_A_27 <= (not entradaA(27)) when (inverteA = '1') else entradaA(27);
        saida_intermed_MUX_B_27 <= (not entradaB(27)) when (inverteB = '1') else entradaB(27);
            
        and_op_27 	    <= std_logic(saida_intermed_MUX_B_27 and saida_intermed_MUX_A_27);
        or_op_27  	    <= std_logic(saida_intermed_MUX_B_27 or saida_intermed_MUX_A_27);
        
        carry_in_27	<= carry_out_26;
        sum_sub_op_27  <= std_logic((saida_intermed_MUX_A_27 xor saida_intermed_MUX_B_27) xor carry_in_27);
        carry_out_27	<= std_logic((saida_intermed_MUX_A_27 and saida_intermed_MUX_B_27) or ((saida_intermed_MUX_A_27 xor saida_intermed_MUX_B_27) and carry_in_27));
        
        slt_op_27		<= '0';
            
        saida_intermed(27) 	    <= and_op_27  	  when (seletor(1 downto 0) = "00") else
                           or_op_27 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_27 when (seletor(1 downto 0) = "10") else
                           slt_op_27;
    
        saida_intermed_MUX_A_28 <= (not entradaA(28)) when (inverteA = '1') else entradaA(28);
        saida_intermed_MUX_B_28 <= (not entradaB(28)) when (inverteB = '1') else entradaB(28);
            
        and_op_28 	    <= std_logic(saida_intermed_MUX_B_28 and saida_intermed_MUX_A_28);
        or_op_28  	    <= std_logic(saida_intermed_MUX_B_28 or saida_intermed_MUX_A_28);
        
        carry_in_28	<= carry_out_27;
        sum_sub_op_28  <= std_logic((saida_intermed_MUX_A_28 xor saida_intermed_MUX_B_28) xor carry_in_28);
        carry_out_28	<= std_logic((saida_intermed_MUX_A_28 and saida_intermed_MUX_B_28) or ((saida_intermed_MUX_A_28 xor saida_intermed_MUX_B_28) and carry_in_28));
        
        slt_op_28		<= '0';
            
        saida_intermed(28) 	    <= and_op_28  	  when (seletor(1 downto 0) = "00") else
                           or_op_28 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_28 when (seletor(1 downto 0) = "10") else
                           slt_op_28;
    
        saida_intermed_MUX_A_29 <= (not entradaA(29)) when (inverteA = '1') else entradaA(29);
        saida_intermed_MUX_B_29 <= (not entradaB(29)) when (inverteB = '1') else entradaB(29);
            
        and_op_29 	    <= std_logic(saida_intermed_MUX_B_29 and saida_intermed_MUX_A_29);
        or_op_29  	    <= std_logic(saida_intermed_MUX_B_29 or saida_intermed_MUX_A_29);
        
        carry_in_29	<= carry_out_28;
        sum_sub_op_29  <= std_logic((saida_intermed_MUX_A_29 xor saida_intermed_MUX_B_29) xor carry_in_29);
        carry_out_29	<= std_logic((saida_intermed_MUX_A_29 and saida_intermed_MUX_B_29) or ((saida_intermed_MUX_A_29 xor saida_intermed_MUX_B_29) and carry_in_29));
        
        slt_op_29		<= '0';
            
        saida_intermed(29) 	    <= and_op_29  	  when (seletor(1 downto 0) = "00") else
                           or_op_29 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_29 when (seletor(1 downto 0) = "10") else
                           slt_op_29;
    
        saida_intermed_MUX_A_30 <= (not entradaA(30)) when (inverteA = '1') else entradaA(30);
        saida_intermed_MUX_B_30 <= (not entradaB(30)) when (inverteB = '1') else entradaB(30);
            
        and_op_30 	    <= std_logic(saida_intermed_MUX_B_30 and saida_intermed_MUX_A_30);
        or_op_30  	    <= std_logic(saida_intermed_MUX_B_30 or saida_intermed_MUX_A_30);
        
        carry_in_30	<= carry_out_29;
        sum_sub_op_30  <= std_logic((saida_intermed_MUX_A_30 xor saida_intermed_MUX_B_30) xor carry_in_30);
        carry_out_30	<= std_logic((saida_intermed_MUX_A_30 and saida_intermed_MUX_B_30) or ((saida_intermed_MUX_A_30 xor saida_intermed_MUX_B_30) and carry_in_30));
        
        slt_op_30		<= '0';
            
        saida_intermed(30) 	    <= and_op_30  	  when (seletor(1 downto 0) = "00") else
                           or_op_30 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_30 when (seletor(1 downto 0) = "10") else
                           slt_op_30;
									
			
		  saida_intermed_MUX_A_31 <= (not entradaA(31)) when (inverteA = '1') else entradaA(31);
        saida_intermed_MUX_B_31 <= (not entradaB(31)) when (inverteB = '1') else entradaB(31);
            
        and_op_31 	    <= std_logic(saida_intermed_MUX_B_31 and saida_intermed_MUX_A_31);
        or_op_31  	    <= std_logic(saida_intermed_MUX_B_31 or saida_intermed_MUX_A_31);
        
        carry_in_31	<= carry_out_30;
        sum_sub_op_31  <= std_logic((saida_intermed_MUX_A_31 xor saida_intermed_MUX_B_31) xor carry_in_31);
        carry_out_31	<= std_logic((saida_intermed_MUX_A_31 and saida_intermed_MUX_B_31) or ((saida_intermed_MUX_A_31 xor saida_intermed_MUX_B_31) and carry_in_31));
        
        slt_op_31		<= '0';
            
        saida_intermed(31) 	    <= and_op_31    when (seletor(1 downto 0) = "00") else
                           or_op_31 	  when (seletor(1 downto 0) = "01") else
                           sum_sub_op_31 when (seletor(1 downto 0) = "10") else
                           slt_op_31;
			
		  overflow <= (carry_out_31 xor carry_in_31) xor sum_sub_op_31;
    
		  saida <= saida_intermed;
		  zero 	  <= not (saida_intermed(0) or saida_intermed(1) or saida_intermed(2) or saida_intermed(3) or saida_intermed(4) or saida_intermed(5) or saida_intermed(6) or saida_intermed(7) or saida_intermed(8) or saida_intermed(9) or saida_intermed(10) or saida_intermed(11) or saida_intermed(12) or saida_intermed(13) or saida_intermed(14) or saida_intermed(15) or saida_intermed(16) or saida_intermed(17) or saida_intermed(18) or saida_intermed(19) or saida_intermed(20) or saida_intermed(21) or saida_intermed(22) or saida_intermed(23) or saida_intermed(24) or saida_intermed(25) or saida_intermed(26) or saida_intermed(27) or saida_intermed(28) or saida_intermed(29) or saida_intermed(30) or saida_intermed(31));
end architecture;