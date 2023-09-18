
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity EX is
port (
PCinc : in std_logic_vector(15 downto 0);
Ext_Imm : in std_logic_vector(15 downto 0);
func :in std_logic_vector (2 downto 0);
sa : in std_logic;
RD1 : in std_logic_vector(15 downto 0);
RD2 : in std_logic_vector(15 downto 0);
ALUSrc : in std_logic;
ALUOp :in std_logic_vector(2 downto 0);
zero : out std_logic;
ALURes : out std_logic_vector(15 downto 0);
BranchAdress : out std_logic_vector(15 downto 0) );
end EX;

architecture Behavioral of EX is

signal ALUCtrl : std_logic_vector(3 downto 0);
signal outmux : std_logic_vector(15 downto 0);
signal aux : std_logic_vector(15 downto 0);

begin

process(ALUOp,func)
begin
case ALUOp is 
when "000" => case func is 
                when "000" => ALUCtrl <= "0000"; --add
                when "001" => ALUCtrl <= "0001"; --sub
                when "010" => ALUCtrl <= "0010"; --sll
                when "011" => ALUCtrl <= "0011"; --srl
                when "100" => ALUCtrl <= "0100"; --and
                when "101" => ALUCtrl <= "0101"; --or
                when "110" => ALUCtrl <= "0110"; --xor
                when "111" => ALUCtrl <= "0111"; --sllv
                when others => ALUCtrl <=(others => 'X');
                end case;
when "001" => ALUCtrl <= "0000";  --addi
when "010" => ALUCtrl <= "0000";  --lw
when "011" => ALUCtrl <= "0000";  --sw
when "100" => ALUCtrl <= "1111";  --beq
when "101" => ALUCtrl <= "0101";  --ori
when "110" => ALUCtrl <= "0110";  --xori
when others => ALUCtrl <=(others => 'X');
end case;      
end process;

process(ALUCtrl,RD1,aux,outmux,sa)
begin
case ALUCtrl is 
when "0000" => aux <= RD1 + outmux;
when "0001" => aux <= RD1 - outmux;
when "0010" => if sa='1' then aux<= outmux(14 downto 0) & '0'; else aux<=outmux; end if;
when "0011" => if sa='1' then aux<='0' & outmux(15 downto 1) ; else aux<=outmux; end if;
when "0100" => aux <= RD1 and outmux;
when "0101" => aux <= RD1 or outmux;
when "1111" =>
if RD1 = outmux then
    aux<="0000000000000000";
else
    aux<="0000000000000001";
end if;
when "0110" => aux <= RD1 xor outmux;
when "0111" => if sa='1' then aux<= RD1(14 downto 0) & '0'; else aux<=RD1; end if;--sllv---------
when others => aux <=(others => 'X');
end case;      
end process;

process(RD2,Ext_imm,ALUSrc)
begin
if ALUSrc = '1' then
outmux<=Ext_Imm;
else
outmux<=RD2;
end if;
end process;

zero<='1' when aux="0000000000000000" else '0';
BranchAdress<=PCinc + Ext_imm;
AluRes<=aux;
end Behavioral;
