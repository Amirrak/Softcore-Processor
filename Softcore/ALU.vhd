library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU is
    port (
        A, B    : in std_logic_vector(7 downto 0);
        aluOP   : in std_logic_vector(4 downto 0);
        q       : out std_logic_vector(7 downto 0);
        regFlag : out std_logic_vector(7 downto 0));
end ALU;

architecture Behavioral of ALU is
    component ADD is 
        port (
            a,b     : in std_logic_vector(7 downto 0);
            s       : out std_logic_vector(7 downto 0);
            cr, R7  : out std_logic);
    end component; 

-- Signaux internes
signal resultat         : std_logic_vector(7 downto 0) := (others=>'0');
signal cr               : std_logic := '0';
signal R7               : std_logic := '0';


-- Signaux instruction ADD
signal s_add            : std_logic_vector(7 downto 0);
signal cr_add, R7_add   : std_logic := '0';

-- Signaux instruction SUB
signal b_1cmp,b_sub             : std_logic_vector(7 downto 0);
signal osef1, osef2             : std_logic;
signal s_sub                    : std_logic_vector(7 downto 0);
signal cr_sub, R7_sub           : std_logic := '0';


signal zero_flag                : std_logic := '0';
signal overflow_flag            : std_logic := '0';


begin
    -- ADD OP
    ADD_op: ADD port map (a => A, b => B, s => s_add, cr => cr_add, R7 => R7_add);
        
    -- SUB OP
    b_1cmp <= not(B);
    b_2cmp: ADD port map (a => b_1cmp, b => "00000001", s => b_sub, cr => osef1, R7 => osef2);
    SUB_op: ADD port map (a => A, b => b_sub, s => s_sub, cr => cr_sub, R7 => R7_sub);
    
    resultat <= s_add when aluOP(4 downto 3) = "01" and aluOP(1 downto 0) = "00" else
                s_sub when (aluOP(4 downto 3) = "01" or aluOP(4 downto 3) = "10") and aluOP(1 downto 0) = "01" else
                (A and B) when aluOP(4 downto 3) = "01" and aluOP(1 downto 0) = "10" else 
                (A or B) when aluOP(4 downto 3) = "01" and aluOP(1 downto 0) = "11" else
                (A xor B) when aluOP(4 downto 3) = "10" and aluOP(1 downto 0) = "00" else
                not(A) when aluOP = "11000" else
                "00000000";
                
         cr <= cr_add when aluOP(4 downto 3) = "01" and aluOP(1 downto 0) = "00" else
               cr_sub when aluOP(4 downto 3) = "01" and aluOP(1 downto 0) = "01" else
               cr;

         R7 <= R7_add when aluOP(4 downto 3) = "01" and aluOP(1 downto 0) = "00" else
               R7_sub when aluOP(4 downto 3) = "01" and aluOP(1 downto 0) = "01" else
               R7;                                  
    
    q <= resultat;
                    
    zero_flag <= not( resultat(0) OR resultat(1) OR resultat(2) OR resultat(3) OR resultat(4) OR resultat(5) OR resultat(6) OR resultat(7) );
    overflow_flag <= ( not(A(7)) AND not(B(7)) AND R7 ) OR ( A(7) AND B(7) AND not(R7) ) when aluOP(4 downto 3) = "01" and aluOP(1 downto 0) = "00" else
                     ( not(A(7)) AND not(b_sub(7)) AND R7 ) OR ( A(7) AND b_sub(7) AND not(R7) )when aluOP(4 downto 3) = "01" and aluOP(1 downto 0) = "01" else
                     overflow_flag;
    
    regFlag <= "0000" & resultat(7) & zero_flag & cr & overflow_flag;

end Behavioral;
