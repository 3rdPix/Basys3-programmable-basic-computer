----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 7/11
-- Design Name: 
-- Module Name: demuxOUTPUT - Behavioral
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


entity demux_adivinanza is
    Port ( write_ram : in std_logic;
           ram_addrs : in std_logic_vector (11 downto 0);
           write_reg_xadiv : out STD_LOGIC;
           write_reg_currt : out STD_LOGIC);
end demux_adivinanza;

architecture Behavioral of demux_adivinanza is

signal selector : std_logic_vector(1 downto 0);

begin

with ram_addrs select
    selector <= "00" when "00000001000", --xadiv
                "01" when "00000001001", --currt
                "10" when others;
           
with selector select
    write_reg_xadiv <= write_ram when "00",
                    '0' when others;
                    
with selector select
    write_reg_currt <= write_ram when "01",
                    '0' when others;          
 
end Behavioral;
