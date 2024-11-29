library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity pointer is Port(
    clock: in std_logic;
    addr: in std_logic_vector(11 downto 0);
    color_out: out std_logic_vector(11 downto 0));
end pointer;

architecture Behavioral of pointer is

component pointer_red is Port(
    clka: in std_logic;
    addra: in std_logic_vector(11 downto 0);
    douta: out std_logic_vector(7 downto 0));
    end component;
component pointer_green is Port(
    clka: in std_logic;
    addra: in std_logic_vector(11 downto 0);
    douta: out std_logic_vector(7 downto 0));
    end component;
component pointer_blue is Port(
    clka: in std_logic;
    addra: in std_logic_vector(11 downto 0);
    douta: out std_logic_vector(7 downto 0));
    end component;
signal intermedio_r: std_logic_vector(7 downto 0);
signal intermedio_g: std_logic_vector(7 downto 0);
signal intermedio_b: std_logic_vector(7 downto 0);
begin

ins_r: pointer_red port map(
    clka=>clock,
    addra=>addr,
    douta=>intermedio_r);
ins_g: pointer_green port map(
    clka=>clock,
    addra=>addr,
    douta=>intermedio_g);
ins_b: pointer_blue port map(
    clka=>clock,
    addra=>addr,
    douta=>intermedio_b);
color_out <= intermedio_r(7 downto 4) & intermedio_g(7 downto 4) & intermedio_b(7 downto 4);

end Behavioral;
