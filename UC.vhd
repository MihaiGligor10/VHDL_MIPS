
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity UC is

Port( 
Instr : in std_logic_vector(15 downto 0);
    RegDst: out std_logic;
    ExtOp: out std_logic;
    ALUSrc: out std_logic;
    Branch: out std_logic;
    Jump: out std_logic;
    ALUOp: out std_logic_vector (2 downto 0);
    MemWrite: out std_logic;
    MemToReg: out std_logic;
    RegWrite: out std_logic);
end UC;

architecture Behavioral of UC is

begin
process(Instr)
begin
RegDst<='0';
ExtOp<='0';
ALUSrc<='0';
Branch<='0';
Jump<='0';
MemWrite<='0';
MemtoReg<='0';
RegWrite<='0';
ALUOp<="000";

 case Instr(15 downto 13) is
 when "000" => ALUOp<="000"; RegDst<='1'; RegWrite<='1';--------------------------------------------
 when "001" => ALUOp<="001"; RegWrite<='1'; ALUSrc<='1'; ExtOp<='1'; ------------------------------- 
 when "010" => ALUOp<="010"; RegWrite<='1'; ALUSrc<='1'; ExtOp<='1'; MemtoReg<='1';-----------------
 when "011" => ALUOp<="011"; ALUSrc<='1'; ExtOp<='1'; MemWrite<='1';--------------------------------
 when "100" => ALUOp<="100"; ExtOp<='1'; Branch<='1';-----------------------------------------------
 when "101" => ALUOp<="101"; RegWrite<='1'; ALUSrc<='1';--------------------------------------------
 when "110" => ALUOp<="110"; RegWrite<='1'; ALUSrc<='1';--------------------------------------------
 when "111" => ALUOp<="111"; Jump<='1';-------------------------------------------------------------
 when others => null;
end case; 
end process;

end Behavioral;

