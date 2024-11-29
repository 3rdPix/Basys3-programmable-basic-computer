library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity vram_header_reg is
    Port (
        clock    : in  std_logic;
        clear    : in  std_logic;
        load     : in  std_logic;
        datain   : in std_logic_vector(15 downto 0);
        dataout  : out integer
    );
end vram_header_reg;

architecture Behavioral of vram_header_reg is
    signal reg : integer := 0;
begin

reg_process : process (clock, clear)
begin
    if (clear = '1') then
        reg <= 0;
    elsif (rising_edge(clock)) then
        if (load = '1') then
            reg <= to_integer(unsigned(datain)); 
        end if;
    end if;
end process;

dataout <= reg;

end Behavioral;
