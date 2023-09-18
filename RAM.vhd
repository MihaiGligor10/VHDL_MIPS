library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 


entity RAM is  
port ( clk : in std_logic;   
MemWrite : in std_logic;   
ALURes : in std_logic_vector(15 downto 0);   
RD2 : in std_logic_vector(15 downto 0);   
MemData : out std_logic_vector(15 downto 0); 
ALURes2 : out std_logic_vector(15 downto 0));  
end  RAM ;  
 
 
architecture bh of  RAM  is   
type ram_type is array (0 to 31) of STD_LOGIC_VECTOR(15 downto 0);
signal RAM : ram_type := (
    X"000A",
    X"000B",
    X"000C",
    X"000D",
    X"000E",
    X"000F",
    X"0009",
    X"0008",
    
    others => X"0000");

begin  

 process (clk)  
 begin   
 if clk'event and clk = '1' then    
    if MemWrite = '1' then          
         RAM(conv_integer(ALURes(4 downto 0))) <= RD2;   
   end if;   
  end if;  
end process;  

 MemData <= RAM( conv_integer(ALURes(4 downto 0))); 
 ALURes2 <=ALURes;
end bh;   