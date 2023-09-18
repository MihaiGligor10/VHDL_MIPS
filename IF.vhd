-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity InF is
 port(
clk :in std_logic ;
Jenable : in std_logic ;
PCsrc : in std_logic;
reset : in std_logic;
enable : in std_logic;
JAdress : in std_logic_vector (15 downto 0);
BAdress : in std_logic_vector(15 downto 0);
PCplus : out std_logic_vector(15 downto 0);
instruction : out std_logic_vector(15 downto 0));
end InF;

architecture Behavioral of InF is
signal outmux : std_logic_vector (15 downto 0);
signal outmux2 : std_logic_vector (15 downto 0);
signal Q : std_logic_vector (15 downto 0);
signal outalu : std_logic_vector (15 downto 0);
type reg_array is array (0 to 255) of std_logic_vector(15 downto 0); 
signal ROM : reg_array;
--B"001_000_001_0010100"     --ADDI $1, $0, 20
--B"001_000_010_0000101"     --ADDI $2, $0, 5
--B"001_000_100_0001110"     --ADDI $4, $0, 14
--B"000_000_000_0000000",     -- NoOp
--B"000_000_000_0000000",     -- NoOp
--B"000_001_010_011_0_001"   --SUB $3, $1, $2
--B"011_000_010_0000000"     --SW $3, 0($0)
--B"010_000_101_0000000"     --LW $5,0($0)
--B"000_000_000_0000000",     -- NoOp
--B"000_000_000_0000000",     -- NoOp
--B"000_101_100_110_0_100"   --AND $6,$5,$4
--B"000_000_000_0000000",     -- NoOp
--B"110_110_111_0000101"     --XORi $7 $6 5
--B"000_000_000_0000000",     -- NoOp
--B"000_111_010_110_0_001"   --SUB $6, $7, $2
--B"111_0000000000001"       --j 1
begin

process
begin
case PCsrc is
when '0' => outmux <= outalu ;
when others => outmux <= BAdress;
  end case;
end process;

process
begin
 case Jenable is
    when '0' => outmux2 <= outmux ;
    when others => outmux2 <= JAdress;
  end case;
end process;

process(clk)
 begin 
    if(rising_edge(clk)) then
        if reset = '1' then
             Q<="0000000000000000";
        else
            if enable = '1' then
               Q<= outmux2; 
            end if ; 
        end if;
    end if;       
 end process;  
 
instruction <= ROM(conv_integer(Q)); 

outalu <= Q+1;
PCplus <= Q+1;

end Behavioral;
