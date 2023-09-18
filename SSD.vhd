----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2021 04:23:07 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity SSD is
port(clk:in std_logic;
a : in std_logic_vector(15 downto 0):= (others => '0');
AN : out std_logic_vector(3 downto 0);
CAT : out std_logic_vector(6 downto 0));
end SSD;

architecture Behavioral of SSD is

signal count :std_logic_vector(15 downto 0);
signal o :std_logic_vector(3 downto 0);
signal i :std_logic_vector(1 downto 0);

begin

process(clk)
begin
if clk'event and clk='1' then
count <= count + 1;
end if;
end process;

process(count,a,i)
begin
    i<=count(15)&count(14);
    case i is 
     when "00"    => o <= a(3 downto 0);         
     when "01"    => o <= a(7 downto 4);         
     when "10"    => o <= a(11 downto 8); 
     when "11"  => o <= a(15 downto 12);        
    when others => o <=(others =>'0');
end case;
end process;

process(count)
begin
i<=count(15)&count(14);
    case i is 
     when "00"   => AN <= "1110";         
     when "01"   => AN <= "1101";         
     when "10"   => AN <= "1011";  
     when "11" => AN <= "0111";   
     when others => AN <=(others =>'0');    
end case;
end process;

process (o)
begin
    case o is
        when "0000"=>  CAT  <="1000000";  -- '0'
        when "0001"=>  CAT  <="1111001";  -- '1'
        when "0010"=>  CAT  <="0100100";  -- '2'
        when "0011"=>  CAT  <="0110000";  -- '3'
        when "0100"=>  CAT  <="0011001";  -- '4' 
        when "0101"=>  CAT  <="0010010";  -- '5'
        when "0110"=>  CAT  <="0000010";  -- '6'
        when "0111"=>  CAT  <="1111000";  -- '7'
        when "1000"=>  CAT  <="0000000";  -- '8'
        when "1001"=>  CAT  <="0010000";  -- '9'
        when "1010"=>  CAT  <="0001000";  -- 'A'
        when "1011"=>  CAT  <="0000011";  -- 'b'
        when "1100"=>  CAT  <="1000110";  -- 'C'
        when "1101"=>  CAT  <="0100001";  -- 'd'
        when "1110"=>  CAT  <="0000110";  -- 'E'
        when "1111"=>  CAT  <="0001110";  -- 'F'
        when others =>  NULL;
    end case;
end process;


end Behavioral;
