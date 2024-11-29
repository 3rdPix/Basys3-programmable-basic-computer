library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nave_azul_rom is
    Port ( clock : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (9 downto 0);
           red_color : out STD_LOGIC_VECTOR (3 downto 0);
           green_color : out STD_LOGIC_VECTOR (3 downto 0);
           blue_color : out STD_LOGIC_VECTOR (3 downto 0));
end nave_azul_rom;

architecture Behavioral of nave_azul_rom is

component nave_azuk_red is Port(
    clka: in std_logic;
    addra: in std_logic_vector(9 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

component nave_azul_green is Port(
    clka: in std_logic;
    addra: in std_logic_vector(9 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

component nave_azul_blue is Port(
    clka: in std_logic;
    addra: in std_logic_vector(9 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

begin

reddish: nave_azuk_red port map(
    clka=>clock,
    addra=>addr,
    douta=>red_color);
    
greenish: nave_azul_green port map(
    clka=>clock,
    addra=>addr,
    douta=>green_color);
    
blueish: nave_azul_blue port map(
    clka=>clock,
    addra=>addr,
    douta=>blue_color);

end Behavioral;
