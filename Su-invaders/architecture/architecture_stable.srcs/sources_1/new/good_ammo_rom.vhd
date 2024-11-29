library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity good_ammo_rom is
    Port ( clock : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (6 downto 0);
           red_color : out STD_LOGIC_VECTOR (3 downto 0);
           green_color : out STD_LOGIC_VECTOR (3 downto 0);
           blue_color : out STD_LOGIC_VECTOR (3 downto 0));
end good_ammo_rom;

architecture Behavioral of good_ammo_rom is

component good_ammo_red is Port(
    clka: in std_logic;
    addra: in std_logic_vector(6 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

component good_ammo_green is Port(
    clka: in std_logic;
    addra: in std_logic_vector(6 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

component good_ammo_blue is Port(
    clka: in std_logic;
    addra: in std_logic_vector(6 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

begin

reddish: good_ammo_red port map(
    clka=>clock,
    addra=>addr,
    douta=>red_color);
    
greenish: good_ammo_green port map(
    clka=>clock,
    addra=>addr,
    douta=>green_color);
    
blueish: good_ammo_blue port map(
    clka=>clock,
    addra=>addr,
    douta=>blue_color);

end Behavioral;
