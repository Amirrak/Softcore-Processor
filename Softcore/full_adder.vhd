library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    Port (
        a1,b1, cin    : in std_logic;
        s1, cout     : out std_logic);
end full_adder;

architecture Behavioral of full_adder is

begin

    s1 <= (not(a1) AND not(b1) AND cin) OR (not(b1) AND a1 AND not(cin)) OR (b1 AND a1 AND cin) OR (b1 AND not(a1) AND not(cin));
    cout <= (cin AND a1) OR (cin AND b1) OR (a1 AND b1);
    
   
end Behavioral;
