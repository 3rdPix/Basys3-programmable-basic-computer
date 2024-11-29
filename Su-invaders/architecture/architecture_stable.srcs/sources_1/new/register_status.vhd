library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity RegStatus is
    Port ( clock    : in  std_logic;                        -- Se�al del clock (reducido).
           clear    : in  std_logic;                        -- Se�al de reset.
           load     : in  std_logic;                        -- Se�al de carga.
	       up	: in std_logic;
	       down : in std_logic;
           c        : in  std_logic; --c,n y z vienen de la AlU
           z        : in  std_logic;
           n        : in  std_logic;
           salida   : out  std_logic_vector (2 downto 0));
end RegStatus;

architecture Behavioral of RegStatus is

signal reg : std_logic_vector(2 downto 0) := (others => '0'); -- Se�ales del registro. Parten en 0.
signal datain	:	std_logic_vector(2 downto 0); -- senal transitoria para no modificar proceso :D

begin

datain(2) <= c;
datain(1) <= z;
datain(0) <= n;

reg_prosses : process (clock, clear)        -- Proceso sensible a clock y clear.
        begin
          if (clear = '1') then             -- Si clear = 1
            reg <= (others => '0');         -- Carga 0 en el registro.
          elsif (rising_edge(clock)) then   -- Si flanco de subida de clock.
            if (load = '1') then            -- Si clear = 0, load = 1.
                reg <= datain;              -- Carga la entrada de datos en el registro.
            elsif (up = '1') then           -- Si clear = 0,load = 0 y up = 1.
                reg <= reg + 1;             -- Incrementa el registro en 1.
            elsif (down = '1') then         -- Si clear = 0,load = 0, up = 0 y down = 1. 
                reg <= reg - 1;             -- Decrementa el registro en 1.          
            end if;
          end if;
        end process;

-- todo sale todo el tiempo 
salida <= reg;
end Behavioral;
