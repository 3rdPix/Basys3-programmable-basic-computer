library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity RegSP is
    Port ( clock    : in  std_logic;                        -- Se�al del clock (reducido).
           clear    : in std_logic;
           up       : in  std_logic;                        -- Se�al de subida.
           down     : in  std_logic;                        -- Se�al de bajada.
           dataout  : out std_logic_vector (11 downto 0)   -- Se�ales de salida de datos.
); end RegSP;

architecture Behavioral of RegSP is

signal reg : std_logic_vector(11 downto 0) := "111111111111"; -- Se�ales del registro. Parten en 2**12 - 1.

begin

reg_prosses : process (clock)        -- Proceso sensible a clock y clear.
        begin
          if (clear = '1') then
              reg <= "111111111111";
          elsif (rising_edge(clock)) then   -- Si flanco de subida de clock.
            if (up = '1') then           -- Si clear = 0,load = 0 y up = 1.
                reg <= reg + 1;             -- Incrementa el registro en 1.
            elsif (down = '1') then         -- Si clear = 0,load = 0, up = 0 y down = 1. 
                reg <= reg - 1;             -- Decrementa el registro en 1.          
            end if;
          end if;
        end process;

dataout <= reg;                             -- Los datos del registro salen sin importar el estado de clock.
            
end Behavioral;