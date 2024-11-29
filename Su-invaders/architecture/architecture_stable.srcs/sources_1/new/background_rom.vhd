library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity background_rom is
    Port ( clock : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (16 downto 0);
           red_color : out STD_LOGIC_VECTOR (3 downto 0);
           green_color : out STD_LOGIC_VECTOR (3 downto 0);
           blue_color : out STD_LOGIC_VECTOR (3 downto 0));
end background_rom;

architecture Behavioral of background_rom is

component background_red is Port(
    clka: in std_logic;
    addra: in std_logic_vector(16 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

component background_green is Port(
    clka: in std_logic;
    addra: in std_logic_vector(16 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

component background_blue is Port(
    clka: in std_logic;
    addra: in std_logic_vector(16 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

begin

reddish: background_red port map(
    clka=>clock,
    addra=>addr,
    douta=>red_color);
    
greenish: background_green port map(
    clka=>clock,
    addra=>addr,
    douta=>green_color);
    
blueish: background_blue port map(
    clka=>clock,
    addra=>addr,
    douta=>blue_color);

end Behavioral;
