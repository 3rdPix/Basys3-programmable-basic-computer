

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Multiplexor is
    Port ( E0 : in STD_LOGIC_VECTOR (15 downto 0);
           E1 : in STD_LOGIC_VECTOR (15 downto 0);
	   E2 : in STD_LOGIC_VECTOR (15 downto 0);
	   E3: in STD_LOGIC_VECTOR (15 downto 0);
           Selector : in STD_LOGIC_VECTOR (1 downto 0);
           Salida : out STD_LOGIC_VECTOR (15 downto 0));
end Multiplexor;

architecture Behavioral of Multiplexor is

begin

   with Selector select
      Salida <= E0 when "00",
                E1 when "01",
                E2 when "10",
		        E3 when "11";
			

end Behavioral;
