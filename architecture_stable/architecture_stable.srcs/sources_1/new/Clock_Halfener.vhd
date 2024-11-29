library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_halfener is
    Port ( clk_in  : in  STD_LOGIC;  
           clk_out : out STD_LOGIC  
         );
end clock_halfener;

architecture Behavioral of clock_halfener is
    signal clk_div : STD_LOGIC := '0';
begin
    process(clk_in)
    begin
        if rising_edge(clk_in) then
            clk_div <= not clk_div; 
        end if;
    end process;

    clk_out <= clk_div; 
end Behavioral;
