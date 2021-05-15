library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity registre2 is
    port (
        dataIn          : in std_logic_vector(1 downto 0);  
        cs, rst, clk    : in std_logic;                    
        q               : out std_logic_vector(1 downto 0) 
    );
end registre2;

architecture Behavioral of registre2 is

begin

    process(clk)
    begin
    
        if (clk'event and clk='1') then
            if rst = '1' then
                q <= (others => '0');
            else
                if cs = '1' then
                    q <= dataIn;
                end if;
            end if;
        end if;
        
    end process;

end Behavioral;
