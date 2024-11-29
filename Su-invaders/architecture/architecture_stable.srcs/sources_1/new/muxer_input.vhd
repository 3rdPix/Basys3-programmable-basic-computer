library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
    out_bus <=  direc_sw                    when "000000000001",
                "00000000000" & direc_btn   when "000000000011",
                timer_sec                   when "000000000100",
                timer_mil                   when "000000000101",
                timer_mic                   when "000000000110",
                ram_output                  when others;

end Behavioral;
