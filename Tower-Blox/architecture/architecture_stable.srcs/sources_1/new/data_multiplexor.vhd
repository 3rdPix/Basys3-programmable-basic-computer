library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MuxData is
    Port ( fromAdder_in : in STD_LOGIC_VECTOR (11 downto 0);
           fromALU_in : in STD_LOGIC_VECTOR (15 downto 0);
           Selector : in STD_LOGIC;
           Salida : out STD_LOGIC_VECTOR (15 downto 0));
end MuxData;

architecture Behavioral of MuxData is

begin

   with Selector select
      Salida <= fromALU_in when '0',
		"0000" & fromAdder_in when '1';

end Behavioral;
