library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity yellow_block_rom is
    Port ( clock : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (11 downto 0);
           red_color : out STD_LOGIC_VECTOR (3 downto 0);
           green_color : out STD_LOGIC_VECTOR (3 downto 0);
           blue_color : out STD_LOGIC_VECTOR (3 downto 0));
end yellow_block_rom;

architecture Behavioral of yellow_block_rom is

component yellow_block_red is Port(
    clka: in std_logic;
    addra: in std_logic_vector(11 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

component yellow_block_green is Port(
    clka: in std_logic;
    addra: in std_logic_vector(11 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

component yellow_block_blue is Port(
    clka: in std_logic;
    addra: in std_logic_vector(11 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

begin

reddish: yellow_block_red port map(
    clka=>clock,
    addra=>addr,
    douta=>red_color);
    
greenish: yellow_block_green port map(
    clka=>clock,
    addra=>addr,
    douta=>green_color);
    
blueish: yellow_block_blue port map(
    clka=>clock,
    addra=>addr,
    douta=>blue_color);

end Behavioral;
