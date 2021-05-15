library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity PC is
Port (
        rst,attente,clk,jump    : in std_logic;
        loadpc               : in std_logic_vector(7 downto 0) := X"00";
        PC                   : out std_logic_vector(7 downto 0));       
end PC;

architecture Behavioral of PC is
    component registre is 
        port (
            dataIn          : in std_logic_vector(7 downto 0);  -- entree donnee sur 8 bits
            cs, rst, clk    : in std_logic;                     -- chip select, reset, et clock
            q               : out std_logic_vector(7 downto 0)  -- sortie du registre sur 8 bits
       );
    end component;
    
    component ADD is 
        Port (
            a,b     : in std_logic_vector(7 downto 0);
            s       : out std_logic_vector(7 downto 0);
            cr, R7  : out std_logic);
    end component;
          
    signal Pc_next: std_logic_vector(7 downto 0);
    signal Pc_out: std_logic_vector(7 downto 0);
    signal add_out: std_logic_vector(7 downto 0);
         
         
begin
    rpc: registre port map( rst => rst, dataIn => Pc_next, cs => attente, clk => clk, q => Pc_out);
    adi: ADD port map ( a => Pc_out, b => "00000001", s => add_out);
    with jump select 
        Pc_next <= loadpc when '1', 
                   add_out when others ;
    PC <= Pc_out;
end Behavioral; 
