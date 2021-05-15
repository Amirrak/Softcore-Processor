library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ControlUnit is
  Port (
      next_instruction      : in std_logic_vector(15 downto 0);
      rst, clk              : in std_logic;
      RF1, RF2              : in std_logic_vector(7 downto 0);
      qAlu                  : in std_logic_vector(7 downto 0);
      RegFlagIn             : in std_logic_vector(7 downto 0);
      attente, jump         : out std_logic;                  
      rd1, rd2              : out std_logic_vector(1 downto 0);
      wrReg                 : out std_logic_vector(1 downto 0);
      A, B                  : out std_logic_vector(7 downto 0);
      aluOp                 : out std_logic_vector(4 downto 0);
      dataInRegFile         : out std_logic_vector(7 downto 0);
      WenRegFile            : out std_logic);
end ControlUnit;

architecture Behavioral of ControlUnit is

    component tempo is
      Port (
        q   : out std_logic_vector(1 downto 0);
        clk, rst : in std_logic);
    end component;
    
    component registre16 is
        port (
            dataIn          : in std_logic_vector(15 downto 0);
            cs, rst, clk    : in std_logic;                   
            q               : out std_logic_vector(15 downto 0)
        );
    end component;
    
    component registre is 
       port (
           dataIn          : in std_logic_vector(7 downto 0); 
           cs, rst, clk    : in std_logic;                    
           q               : out std_logic_vector(7 downto 0) 
       );       
    end component;
    
    component registre5 is
        port (
            dataIn          : in std_logic_vector(4 downto 0);  
            cs, rst, clk    : in std_logic;                    
            q               : out std_logic_vector(4 downto 0) 
        );
    end component;  
    
    component registre2 is
        port (
            dataIn          : in std_logic_vector(1 downto 0);  
            cs, rst, clk    : in std_logic;                    
            q               : out std_logic_vector(1 downto 0) 
        );
    end component;  
    
    signal instruction                  : std_logic_vector(15 downto 0);
    
    signal sync                         : std_logic_vector(1 downto 0);
    
    signal opCode, instCode             : std_logic_vector(2 downto 0);
    signal dstCode                      : std_logic_vector(1 downto 0);
    signal srcCode                      : std_logic_vector(7 downto 0);
    
    signal csALU, csMove, csJump        : std_logic := '0';
    
    -- signal CS
    -- Fetch
    signal csFetch                           : std_logic := '0';
    -- CS ALU
    signal csRegALU, csRegFile, csRegFlag    : std_logic := '0';
    -- CS MOVE
    
    
    -- signal Registre ALU
    signal dataInA, dataInB             : std_logic_vector(7 downto 0);
    signal dataInAluOp                  : std_logic_vector(4 downto 0);

    -- signal Flag
    signal RegFlagOut                          : std_logic_vector(7 downto 0);
    
    -- signal rd1 pour reinjecter dans wr
    signal rd1_signal                   : std_logic_vector(1 downto 0);
    
begin
    jump <= '0';
    attente <= sync(1) and not(sync(0));

    tempo1: tempo port map (q => sync, clk => clk, rst => rst);
    RI: registre16 port map (dataIn => next_instruction,
                           cs => csFetch,
                           rst => rst,
                           clk => clk,
                           q => instruction);
    RegAluA: registre port map (dataIn => dataInA,
                                cs => csRegALU,
                                clk => clk,
                                rst => rst,
                                q => A);   
                                    
    RegAluB: registre port map (dataIn => dataInB,
                                cs => csRegALU,  
                                clk => clk,      
                                rst => rst,      
                                q => B); 
    RegAluOp: registre5 port map (dataIn => dataInAluOp,
                                cs => csRegALU,  
                                clk => clk,      
                                rst => rst,      
                                q => aluOp);                                                                                                                                                              
    
    RegFlag: registre port map (dataIn => RegFlagIn,
                                cs => csRegFlag,
                                clk => clk,
                                rst => rst,
                                q => RegFlagOut);
    
    RegWr: registre2 port map(dataIn => rd1_signal,
                              cs => csRegAlu,
                              clk => clk,
                              rst => rst,
                              q => wrReg);
                                                        
    -- Activation des Chip Select
    csFetch <= not(sync(0)) and not(sync(1));
    csRegALU <= sync(0) and not(sync(1)) and csALU;
    csRegFile <= not(sync(0)) and sync(1) and csALU and not(opCode(1) and instCode(0));
    csRegFlag <= not(sync(0)) and sync(1) and csALU;
    -- Demux pour decoder l'instruction
    opCode <= instruction(15 downto 13);
    instCode <= instruction(12 downto 10);
    dstCode <= instruction(9 downto 8);
    srcCode <= instruction(7 downto 0);
    
    
    -- Demux pour selectionner le bon circuit d'execution    
    csMove <= '1' when opCode = "000" else
              '0';
    csALU <= '1' when opCode = "001" or opCode = "010" or opCode = "011" else
             '0';
    csJump <= '1' when opCode = "101" else
              '0';
    
   
    -- PARTIE ALU DU CONTROL UNIT
    with csALU select
        rd1_signal <= dstCode when '1',
               "--" when others;
    with csALU select
        rd2 <= srcCode(1 downto 0) when '1',
               "--" when others;
    rd1 <= rd1_signal;
    -- Entree Registre Alu
    dataInA <= RF1;
    
    with instCode(2) select
        dataInB <= RF2 when '0',
               srcCode when others;
    
    dataInAluOp <= opCode(1 downto 0) & instCode;
               
    -- Ecrire dans la destination dans le registre file
    with csALU select
        dataInRegFile <= qAlu when '1',
                         "ZZZZZZZZ" when others;
    
    WenRegFile <= csRegFile;
   
    
end Behavioral;
