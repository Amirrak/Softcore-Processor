library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tempo is
  Port (
    q   : out std_logic_vector(1 downto 0);
    clk, rst : in std_logic);
end tempo;

architecture Behavioral of tempo is
    component tempo_add is
        Port (
            a,b     : in std_logic_vector(1 downto 0);
            s       : out std_logic_vector(1 downto 0));
    end component;
    
    signal sq                : std_logic_vector(1 downto 0) := "00";
    signal s_add             : std_logic_vector(1 downto 0);
    signal a_add             : std_logic_vector(1 downto 0) := "10";
    signal b_add             : std_logic_vector(1 downto 0) := "01";
    
begin
    add: tempo_add port map(a => a_add, b => b_add, s => s_add);
    process(clk)
    begin
        if(clk'event and clk='1') then
            if(rst = '1') then
                sq <= "11";
            else
                sq <= sq + '1';

            end if;
        end if;
    end process;
        
    q <= sq;

end Behavioral;
