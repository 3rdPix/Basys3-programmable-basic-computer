library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MuxPC is
    Port ( lit_from_ram: in STD_LOGIC_VECTOR (11 downto 0);
           lit_from_rom : in STD_LOGIC_VECTOR (11 downto 0);
           Selector : in STD_LOGIC;
           Salida : out STD_LOGIC_VECTOR (11 downto 0));
end MuxPC;

architecture Behavioral of MuxPC is

begin

   with Selector select
      Salida <= lit_from_rom when '0',
                lit_from_ram when '1';
			
end Behavioral;
