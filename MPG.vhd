

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity MPG is
    Port ( input : in STD_LOGIC;
           cl : in STD_LOGIC;
           en : out STD_LOGIC);
end MPG;

architecture Behavioral of MPG is
signal c:std_logic_vector(15 downto 0):="0000000000000000";
signal Q1 : std_logic:= '0';
signal Q2 : std_logic:= '0';
signal Q3 : std_logic:= '0';

begin
en <= Q2 AND (not Q3);
process(cl)
begin
if cl'event and cl='1' then
c <= c + 1;
end if;
end process;

process(cl)
begin
if cl'event and cl='1' then
if c="1111111111111111" then
Q1<=input;
end if;
end if;
end process;

process (cl)
begin
if cl'event and cl='1' then
Q2 <= Q1;
Q3 <= Q2;
end if;
end process;

end Behavioral;
