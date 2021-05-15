library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Memory is
    Port (
        pc                  : in std_logic_vector(7 downto 0);
        addressWrite        : in std_logic_vector(7 downto 0);
        instructionWrite    : in std_logic_vector(15 downto 0);
        enWrite             : in std_logic;
        instruction         : out std_logic_vector(15 downto 0));
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is  

    type regMem is array(0 to 254) of std_logic_vector(15 downto 0);
    signal ramInst : regMem := (X"3001", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0001", X"0020", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",
                                X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",
                                X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",
                                X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",
                                X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",
                                X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",
                                X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",
                                X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0001", X"0020", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",
                                X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",
                                X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",
                                X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",
                                X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",
                                X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",
                                X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",
                                X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000",X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000", X"0000");
begin
    instruction <= ramInst(to_integer(unsigned(pc)));
    process(enWrite)
    begin
        if(enWrite = '1') then
            ramInst(to_integer(unsigned(addressWrite))) <= instructionWrite;
        end if;
    end process;
            
end Behavioral;
