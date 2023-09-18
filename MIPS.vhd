
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 


entity MIPS is
 port ( clk : in STD_LOGIC;
        btn : in STD_LOGIC_VECTOR (4 downto 0);
        sw : in STD_LOGIC_VECTOR (15 downto 0);
        led : out STD_LOGIC_VECTOR (15 downto 0);
        an :out STD_LOGIC_VECTOR (3 downto 0);
        cat : out STD_LOGIC_VECTOR (6 downto 0)
 );
end MIPS;


architecture Behavioral of MIPS is
component MPG is
port ( input : in STD_LOGIC;
           cl : in STD_LOGIC;
           en : out STD_LOGIC);
end component;

component SSD is
port(clk:in std_logic;
a : in std_logic_vector(15 downto 0);
AN : out std_logic_vector(3 downto 0);
CAT : out std_logic_vector(6 downto 0));
end component;


component RAM is
port ( clk : in std_logic;   
MemWrite : in std_logic;   
ALURes : in std_logic_vector(15 downto 0);   
RD2 : in std_logic_vector(15 downto 0);   
MemData : out std_logic_vector(15 downto 0); 
ALURes2 : out std_logic_vector(15 downto 0));  
end component;

component Inf is
port (clk :in std_logic ;
Jenable : in std_logic ;
PCsrc : in std_logic;
reset : in std_logic;
enable : in std_logic;
JAdress : in std_logic_vector (15 downto 0);
BAdress : in std_logic_vector(15 downto 0);
PCplus : out std_logic_vector(15 downto 0);
instruction : out std_logic_vector(15 downto 0));
end component;

component EX is
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
end component;

component ID is
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
end component;

component UC is
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
end component;

signal reset : std_logic;
signal en : std_logic;

signal PCplus : std_logic_vector(15 downto 0);
 
signal Instr :  std_logic_vector(15 downto 0);
signal RegDst : std_logic;
signal ExtOp:  std_logic;
signal  ALUSrc:  std_logic;
signal  Branch:  std_logic;
signal  Jump: std_logic;
signal  ALUOp:  std_logic_vector (2 downto 0);
signal  MemWrite: std_logic;
signal  MemToReg: std_logic;
signal  RegWrite: std_logic;

signal outmux : std_logic_vector(15 downto 0);
signal BranchAdress : std_logic_vector(15 downto 0);
signal JumpAdress : std_logic_vector(15 downto 0);
signal RD1 : std_logic_vector(15 downto 0);
signal RD2 : std_logic_vector(15 downto 0);
signal sa: std_logic;
signal func: std_logic_vector(2 downto 0);
signal zero: std_logic;
signal Ext_imm : std_logic_vector(15 downto 0);
signal alures : std_logic_vector(15 downto 0);
signal alures2 : std_logic_vector(15 downto 0);
signal PCsrc : std_logic;
signal MemData : std_logic_vector(15 downto 0);
signal WD : std_logic_vector(15 downto 0);


signal IF_and_ID: std_logic_vector(31 downto 0);
signal MEM_and_WD: std_logic_vector(33 downto 0);
signal EX_and_MEM: std_logic_vector(52 downto 0);
signal ID_and_EX: std_logic_vector(75 downto 0);

begin


m1: MPG port map(btn(0),clk,reset);
m2: MPG port map(btn(1),clk,en);
m3: InF port map(clk,Jump,PCSrc,reset,en,JumpAdress, EX_and_MEM(48 downto 33),PCplus,Instr);
m4: SSD port map(clk,outmux,an,cat);
m5: ID port map(clk,MEM_and_WD(32),IF_and_ID(15 downto 0),RegDst,ExtOp,WD,Ext_imm,func,sa,RD1,RD2);
m6: EX port map(ID_and_EX(67 downto 52),ID_and_EX(19 downto 4),ID_and_EX(3 downto 1),ID_and_EX(0),ID_and_EX(51 downto 36),ID_and_EX(35 downto 20),ID_and_EX(68), ID_and_EX(71 downto 69),zero,alures,BranchAdress);

m7: RAM port map(clk, EX_and_MEM(50),EX_and_MEM(31 downto 16),EX_and_MEM(15 downto 0),MemData,alures2);

m8: UC port map(IF_and_ID(15 downto 0),RegDst,ExtOp,ALUSrc, Branch,Jump,ALUOp,MemWrite,MemToReg,RegWrite);


--process(en) -- EX/MEM
--begin 
--    if rising_edge(en) then 
--         EX_and_MEM(52)<=ID_and_EX(75);
--         EX_and_MEM(51)<=ID_and_EX(74);
--         EX_and_MEM(50)<=ID_and_EX(73);
--         EX_and_MEM(49)<=ID_and_EX(72);
--         EX_and_MEM(48 downto 33) <=BranchAdress;
--         EX_and_MEM(32)<=zero;
--         EX_and_MEM(31 downto 16) <=alures;
--         EX_and_MEM(15 downto 0) <=ID_and_EX(35 downto 20);
--    end if;
--end process;

PCsrc<=EX_and_MEM(49) and EX_and_MEM(32);
JumpAdress <= IF_and_ID(31 downto 29) & IF_and_ID(12 downto 0);
WD<=  MEM_and_WD(15 downto 0) when MEM_and_WD(33)='0' else MEM_and_WD(31 downto 16);

process
begin
 case sw(7 downto 5)is
when "000" => outmux <= IF_and_ID(15 downto 0);
when "001" => outmux <= IF_and_ID(31 downto 16) ;
when "010" => outmux <=  ID_and_EX(51 downto 36) ;
when "011" => outmux <=  ID_and_EX(35 downto 20) ;
when "100" => outmux <= ID_and_EX(19 downto 4);
when "101" => outmux <= EX_and_MEM(31 downto 16) ;
when "110" => outmux <=   MEM_and_WD(31 downto 16) ;
when "111" => outmux <= WD ;
when others  => outmux <= "000" ;
  end case;
end process;


led(0)<= RegDst ;
led(1)<= ExtOp;
led(2)<= ALUSrc;
led(3)<= Branch;
led(4)<= Jump;
led(5)<= MemWrite;
led(6)<= MemToReg;
led(7)<= RegWrite;
led(8)<= sa;
led(9)<= zero;
led(10)<= PCsrc;

process(en) -- IF/ID 
begin 
    if rising_edge(en) then 
       IF_and_ID(31 downto 16) <=PCplus;
       IF_and_ID(15 downto 0) <= instr;
    end if;
end process;

process(en) --ID/EX
begin 
    if rising_edge(en) then 
         ID_and_EX(75)<=MemtoReg;
         ID_and_EX(74)<=RegWrite;
         ID_and_EX(73)<=MemWrite;
         ID_and_EX(72)<=Branch;
         ID_and_EX(71 downto 69)<=ALUOp;
         ID_and_EX(68)<=ALUSrc;
         ID_and_EX(67 downto 52) <=IF_and_ID(31 downto 16);
         ID_and_EX(51 downto 36) <=RD1;
         ID_and_EX(35 downto 20) <=RD2;
         ID_and_EX(19 downto 4) <=ext_imm;
         ID_and_EX(3 downto 1) <=IF_and_ID(2 downto 0);
         ID_and_EX(0) <=IF_and_ID(3);
    end if;
end process;

process(en) -- EX/MEM
begin 
    if rising_edge(en) then 
         EX_and_MEM(52)<=ID_and_EX(75);
         EX_and_MEM(51)<=ID_and_EX(74);
         EX_and_MEM(50)<=ID_and_EX(73);
         EX_and_MEM(49)<=ID_and_EX(72);
         EX_and_MEM(48 downto 33) <=BranchAdress;
         EX_and_MEM(32)<=zero;
         EX_and_MEM(31 downto 16) <=alures;
         EX_and_MEM(15 downto 0) <=ID_and_EX(35 downto 20);
    end if;
end process;

process(en) -- MEM/WB
begin 
    if rising_edge(en) then 
         MEM_and_WD(33)<=EX_and_MEM(52);
         MEM_and_WD(32)<=EX_and_MEM(51);
         MEM_and_WD(31 downto 16) <=MemData;
         MEM_and_WD(15 downto 0) <= alures2;
    end if;
end process;


end Behavioral;
