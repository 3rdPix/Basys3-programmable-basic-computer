----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2024 02:20:14
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity demuxOUTPUT is
    Port ( write_ram : in STD_LOGIC;
           ram_addrs : in STD_LOGIC_VECTOR (11 downto 0);
           write_regDis : out STD_LOGIC;
           write_regLed : out STD_LOGIC);
end demuxOUTPUT;

architecture Behavioral of demuxOUTPUT is

signal selector : std_logic_vector(1 downto 0);

begin

with ram_addrs select
    selector <= "00" when "00000000000",         -- leds
                "01" when "00000000010",         -- displays
                "10" when others;
           
with selector select
    write_regLed <= write_ram when "00",
                    '0' when others;
                    
with selector select
    write_regDis <= write_ram when "01",
                    '0' when others;          
 
end Behavioral;
