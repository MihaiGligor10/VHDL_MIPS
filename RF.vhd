----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2021 11:17:13 AM
-- Design Name: 
-- Module Name: RF - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:s
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 


entity RF is
port ( clk : in std_logic;   
RegWr : in std_logic;    
WD :in std_logic_vector(15 downto 0);  
ra1 : in std_logic_vector(2 downto 0);   
ra2 : in std_logic_vector(2 downto 0);
WA : in std_logic_vector(2 downto 0);
rd1 : out std_logic_vector(15 downto 0);
rd2 : out std_logic_vector(15 downto 0)); 
end RF;

architecture Behavioral of RF is
type reg_array is array (0 to 15) of std_logic_vector(15 downto 0); 
signal reg_file : reg_array :=(
X"0000",
X"A45C",
X"7402",
X"9903",
X"AAAA",
X"0F21",
X"004C",
X"9907",
others =>X"0000");

begin

process(clk)  
begin 
if rising_edge(clk) then 
    if RegWr = '1' then 
      reg_file(conv_integer(wa)) <= wd; 
    end if; 
   end if; 
  end process;  
    
rd1 <= reg_file(conv_integer(ra1)); 
rd2 <= reg_file(conv_integer(ra2));  
--WD  <= rd1 + rd2; 

end Behavioral;
