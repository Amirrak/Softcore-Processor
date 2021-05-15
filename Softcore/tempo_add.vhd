library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tempo_add is
    Port (
        a,b     : in std_logic_vector(1 downto 0);
        s       : out std_logic_vector(1 downto 0));
end tempo_add;

architecture Behavioral of tempo_add is
    component full_adder is
        Port (
            a1,b1, cin    : in std_logic;
            s1, cout     : out std_logic);
    end component;
    
    signal s_signal         : std_logic_vector(1 downto 0);
    signal cout             : std_logic;
begin
    ADD1: full_adder port map (a1 => a(0), b1 => b(0), cin => '0', s1 => s_signal(0), cout => cout);    
    ADD2: full_adder port map (a1 => a(1), b1 => b(1), cin => cout, s1 => s_signal(1));
    
    s <= s_signal;

end Behavioral;
