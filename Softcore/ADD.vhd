library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ADD is
    Port (
        a,b     : in std_logic_vector(7 downto 0);
        s       : out std_logic_vector(7 downto 0);
        cr, R7  : out std_logic);
end ADD;


architecture Behavioral of ADD is
    component full_adder is
        Port (
            a1,b1, cin    : in std_logic;
            s1, cout     : out std_logic);
    end component;    

signal s_signal         : std_logic_vector(7 downto 0) := (others=>'0');
signal cout             : std_logic_vector(6 downto 0) := (others=>'0');

begin
    ADD1: full_adder port map (a1 => a(0), b1 => b(0), cin => '0', s1 => s_signal(0), cout => cout(0));
    ADD2: full_adder port map (a1 => a(1), b1 => b(1), cin => cout(0), s1 => s_signal(1), cout => cout(1));
    ADD3: full_adder port map (a1 => a(2), b1 => b(2), cin => cout(1), s1 => s_signal(2), cout => cout(2));
    ADD4: full_adder port map (a1 => a(3), b1 => b(3), cin => cout(2), s1 => s_signal(3), cout => cout(3));
    ADD5: full_adder port map (a1 => a(4), b1 => b(4), cin => cout(3), s1 => s_signal(4), cout => cout(4));
    ADD6: full_adder port map (a1 => a(5), b1 => b(5), cin => cout(4), s1 => s_signal(5), cout => cout(5));
    ADD7: full_adder port map (a1 => a(6), b1 => b(6), cin => cout(5), s1 => s_signal(6), cout => cout(6));
    ADD8: full_adder port map (a1 => a(7), b1 => b(7), cin => cout(6), s1 => s_signal(7), cout => cr);
    
    s <= s_signal;    
    R7 <= s_signal(7);
        

end Behavioral;
