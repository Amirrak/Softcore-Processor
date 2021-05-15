library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regBank is
    port (
        clk,rst     : in std_logic;
        rd1, rd2    : in std_logic_vector(1 downto 0);
        wr          : in std_logic_vector(1 downto 0);
        Wen         : in std_logic;
        dataIn      : in std_logic_vector(7 downto 0);
        RF1, RF2    : out std_logic_vector(7 downto 0);
        
        -- DEBUGGING OUTPUT
        dbg_qa : out STD_LOGIC_VECTOR(7 downto 0);
        dbg_qb : out STD_LOGIC_VECTOR(7 downto 0);
        dbg_qc : out STD_LOGIC_VECTOR(7 downto 0);
        dbg_qd : out STD_LOGIC_VECTOR(7 downto 0));
end regBank;
    
architecture Behavioral of regBank is
    signal csReg            : std_logic_vector(3 downto 0);
    signal cs               : std_logic_vector(3 downto 0);
    signal qa, qb, qc, qd   : std_logic_vector(7 downto 0);
    
     component registre is 
           port (
               dataIn          : in std_logic_vector(7 downto 0);  -- entree donnee sur 8 bits
               cs, rst, clk    : in std_logic;                     -- chip select, reset, et clock
               q               : out std_logic_vector(7 downto 0)  -- sortie du registre sur 8 bits
           );
       end component;
       
begin
    RA: registre port map (cs => cs(0), rst => rst, clk => clk, dataIn => dataIn, q => qa);
    RB: registre port map (cs => cs(1), rst => rst, clk => clk, dataIn => dataIn, q => qb);
    RC: registre port map (cs => cs(2), rst => rst, clk => clk, dataIn => dataIn, q => qc);
    RD: registre port map (cs => cs(3), rst => rst, clk => clk, dataIn => dataIn, q => qd);
    
    
    with wr select
        csReg <= "0001" when "00",
                 "0010" when "01",
                 "0100" when "10",
                 "1000" when others;
              
    with Wen select
        cs <= "0000" when '0',
               csReg when others;

    with rd1 select
        RF1 <= qa when "00",
               qb when "01",
               qc when "10",
               qd when others;
               
    with rd2 select
        RF2 <= qa when "00",
               qb when "01",
               qc when "10",
               qd when others; 
               
    -- DEBUGING OUTPUT
    
    dbg_qa <= qa;
    dbg_qb <= qb;
    dbg_qc <= qc;
    dbg_qd <= qd;
    dbg_wrReg <= wr;                  
               
end Behavioral;
