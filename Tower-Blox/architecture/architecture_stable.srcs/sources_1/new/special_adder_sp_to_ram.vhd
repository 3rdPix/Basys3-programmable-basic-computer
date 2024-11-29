----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.10.2024 05:19:41
-- Design Name: 
-- Module Name: AdderDataIn - Behavioral
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

entity AdderDataIn is
    Port ( addrs_in : in STD_LOGIC_VECTOR (11 downto 0);
           bus_1 : in STD_LOGIC_VECTOR (11 downto 0);
           result : out STD_LOGIC_VECTOR (11 downto 0));
end AdderDataIn;

architecture Behavioral of AdderDataIn is

component Adder16 is
    Port ( a  : in  std_logic_vector (15 downto 0); --/pasa de 7 a 15 para los 16 bits
           b  : in  std_logic_vector (15 downto 0); --/pasa de 7 a 15 para los 16 bits
           ci : in  std_logic;
           s  : out std_logic_vector (15 downto 0); --/pasa de 7 a 15 para los 16 bits
           co : out std_logic);
end component;

signal carry_out: std_logic;
signal to_adder: std_logic_vector(15 downto 0);
signal to_adder_1: std_logic_vector (15 downto 0);
signal from_adder: std_logic_vector(15 downto 0);

begin

to_adder <= "0000" & addrs_in;
to_adder_1 <= "0000" & bus_1;

inst_sum: Adder16 port map(
        a      =>  to_adder,
        b      =>  to_adder_1,
        ci     => '0',
        s      => from_adder,
        co     => carry_out
    );

result <= from_adder(11 downto 0);

end Behavioral;
