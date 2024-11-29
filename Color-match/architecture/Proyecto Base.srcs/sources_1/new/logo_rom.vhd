library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity logo_rom is Port(
    clock: in std_logic;
    addr: in std_logic_vector(13 downto 0);
    color_out: out std_logic_vector(11 downto 0));
end logo_rom;

architecture Behavioral of logo_rom is

component logo_red is Port(
    clka: in std_logic;
    addra: in std_logic_vector(13 downto 0);
    douta: out std_logic_vector(7 downto 0));
    end component;

component logo_green is Port(
    clka: in std_logic;
    addra: in std_logic_vector(13 downto 0);
    douta: out std_logic_vector(7 downto 0));
    end component;

component logo_blue is Port(
    clka: in std_logic;
    addra: in std_logic_vector(13 downto 0);
    douta: out std_logic_vector(7 downto 0));
    end component;
signal intermedio_r: std_logic_vector(7 downto 0);
signal intermedio_g: std_logic_vector(7 downto 0);
signal intermedio_b: std_logic_vector(7 downto 0);

begin

inst_red: logo_red port map(
    clka=>clock,
    addra=>addr,
    douta=>intermedio_r);
    
inst_green: logo_green port map(
    clka=>clock,
    addra=>addr,
    douta=>intermedio_g);
    
inst_blue: logo_blue port map(
    clka=>clock,
    addra=>addr,
    douta=>intermedio_b);
    
color_out <= intermedio_r(7 downto 4) & intermedio_g(7 downto 4) & intermedio_b(7 downto 4);

end Behavioral;
