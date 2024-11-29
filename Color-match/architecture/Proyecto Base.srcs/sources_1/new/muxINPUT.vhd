----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2024 02:20:14
-- Design Name: 
-- Module Name: muxINPUT - Behavioral
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

entity muxINPUT is
    Port ( ram_addrs : in STD_LOGIC_VECTOR (11 downto 0);
           ram_output : in STD_LOGIC_VECTOR (15 downto 0);
           timer_sec : in STD_LOGIC_VECTOR (15 downto 0);
           timer_mil : in STD_LOGIC_VECTOR (15 downto 0);
           timer_mic : in STD_LOGIC_VECTOR (15 downto 0);
           direc_btn : in STD_LOGIC_VECTOR (4 downto 0);
           direc_sw : in STD_LOGIC_VECTOR (15 downto 0);
           out_bus : out STD_LOGIC_VECTOR (15 downto 0)
           );
end muxINPUT;

architecture Behavioral of muxINPUT is



begin

with ram_addrs select
    out_bus <=  direc_sw                    when "0000000000000001",
                "00000000000" & direc_btn   when "0000000000000011",
                timer_sec                   when "0000000000000100",
                timer_mil                   when "0000000000000101",
                timer_mic                   when "0000000000000110",
                ram_output                  when others;

end Behavioral;
