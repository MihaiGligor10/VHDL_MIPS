
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity ID is
Port (
clk : in std_logic;   
RegWrite : in std_logic;
Instr : in std_logic_vector(15 downto 0);
RegDst : in std_logic;
ExtOp :in std_logic;
WD :in std_logic_vector(15 downto 0);
Ext_imm : out std_logic_vector(15 downto 0);
func : out std_logic_vector(2 downto 0);
sa : out std_logic;
RD1 : out std_logic_vector(15 downto 0);
RD2 : out std_logic_vector(15 downto 0));
end ID;

architecture Behavioral of ID is
component RF is
port (clk : in std_logic;   
RegWr : in std_logic;   
WD :in std_logic_vector(15 downto 0);  
ra1 : in std_logic_vector(2 downto 0);   
ra2 : in std_logic_vector(2 downto 0);
WA : in std_logic_vector(2 downto 0);
rd1 : out std_logic_vector(15 downto 0);
rd2 : out std_logic_vector(15 downto 0)); 
end component;
signal mout : std_logic_vector(2 downto 0);
begin
id_rf: RF port map (clk,RegWrite,WD,Instr(12 downto 10),Instr(9 downto 7),mout,RD1,RD2);

process
begin
if RegDst ='1' then
mout <= Instr(6 downto 4);
else
mout <= Instr(9 downto 7);
end if;
end process;


Ext_Imm(6 downto 0) <= Instr(6 downto 0); 
    with ExtOp select
        Ext_Imm(15 downto 7) <= (others => Instr(6)) when '1',
                                (others => '0') when '0',
                                (others => '0') when others;

func<=Instr(2 downto 0);
sa <= Instr(3);

end Behavioral;
