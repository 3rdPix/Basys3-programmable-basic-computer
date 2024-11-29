library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MuxAddrs is
    Port ( stack_pointer : in STD_LOGIC_VECTOR (11 downto 0);
           lit_from_rom : in STD_LOGIC_VECTOR (11 downto 0);
	       from_regB : in STD_LOGIC_VECTOR (11 downto 0);
	       E3: in STD_LOGIC_VECTOR (11 downto 0);
           Selector : in STD_LOGIC_VECTOR (1 downto 0);
           Salida : out STD_LOGIC_VECTOR (11 downto 0));
end MuxAddrs;

architecture Behavioral of MuxAddrs is

begin

   with Selector select
      Salida <= lit_from_rom when "00",
                from_regB when "01",
                stack_pointer when "10",
		        E3 when "11";
			

end Behavioral;
