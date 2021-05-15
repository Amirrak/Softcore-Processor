library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CPU is
  Port (
      clk, rst                                      : in std_logic;
      addressWrite                                  : in std_logic_vector(7 downto 0);
      instructionWrite                              : in std_logic_vector(15 downto 0);
      enWrite                                       : in std_logic := '0';
      regSelect                                     : in std_logic_vector(3 downto 0);
                  
      -- sortie debug
      dbg_qa, dbg_qb, dbg_qc, dbg_qd                : out std_logic_vector(7 downto 0));
end CPU;

architecture Behavioral of CPU is
    
    component ControlUnit is
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
    end component;
    
    component ALU is
        Port (
            A, B    : in std_logic_vector(7 downto 0);
            aluOP   : in std_logic_vector(4 downto 0);
            q       : out std_logic_vector(7 downto 0);
            regFlag : out std_logic_vector(7 downto 0));
    end component;
    
    component regBank is
        Port (
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
    end component;

    component PC is
        Port (
                rst,attente,clk,jump    : in std_logic;
                loadpc               : in std_logic_vector(7 downto 0);
                PC                   : out std_logic_vector(7 downto 0));       
    end component;
    
    component Instruction_Memory is
        Port (
            pc                  : in std_logic_vector(7 downto 0);
            addressWrite        : in std_logic_vector(7 downto 0);
            instructionWrite    : in std_logic_vector(15 downto 0);
            enWrite             : in std_logic;
            instruction         : out std_logic_vector(15 downto 0));
    end component;
    
    -- signal PC
    signal program_counter      : std_logic_vector(7 downto 0);
    
    -- signal CU
    signal attente              : std_logic;
    signal A, B                 : std_logic_vector(7 downto 0);
    signal aluOp                : std_logic_vector(4 downto 0);
    signal rd1, rd2             : std_logic_vector(1 downto 0);
    signal wr                   : std_logic_vector(1 downto 0);
    signal WenRegFile           : std_logic;
    signal dataInRegFile        : std_logic_vector(7 downto 0);
    
    -- signal Instruction Memory
    signal instruction          : std_logic_vector(15 downto 0);
    
    -- signal ALU
    signal qAlu                 : std_logic_vector(7 downto 0);
    signal regFlag              : std_logic_vector(7 downto 0);
    
    -- signal RegFile
    signal  RF1, RF2                        : std_logic_vector(7 downto 0);
    
    
begin
    
    
    ProgramCounter: PC port map(
                rst => rst,
                clk => clk,
                attente => attente,
                jump => '0',
                loadpc => X"00",
                PC => program_counter);
                
    InstructionMemory: Instruction_Memory port map (
                    pc => program_counter,
                    addressWrite => addressWrite,
                    instructionWrite => instructionWrite,
                    enWrite => enWrite,
                    instruction => instruction);
    
    ArithmeticLogicUnit: ALU port map(
                A => A,
                B => B,
                aluOP => aluOP,
                q => qAlu,
                regFlag => regFlag);                

    RegisterFile: regBank port map(
                clk => clk,
                rst => rst,
                rd1 => rd1,
                rd2 => rd2,
                wr => wr,
                Wen => WenRegFile,
                dataIn => dataInRegFile,
                RF1 => RF1,
                RF2 => RF2,
                dbg_qa => dbg_qa,
                dbg_qb => dbg_qb,
                dbg_qc => dbg_qc,
                dbg_qd => dbg_qd);

    Control_Unit: ControlUnit port map(                
                rst => rst,
                clk => clk,
                next_instruction => instruction,
                RF1 => RF1,
                RF2 => RF2,
                qAlu => qAlu,
                RegFlagIn => regFlag,
                attente => attente,
                rd1 => rd1,
                rd2 => rd2,
                wrReg => wr,
                A => A,
                B => B,
                aluOp => aluOp,
                dataInRegFile => dataInRegFile);            
     
 
end Behavioral;
