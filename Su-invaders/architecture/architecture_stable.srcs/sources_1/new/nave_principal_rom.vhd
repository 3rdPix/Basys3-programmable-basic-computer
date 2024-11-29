library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity nave_principal_rom is
    Port ( clock : in STD_LOGIC;
           addr : in STD_LOGIC_VECTOR (12 downto 0);
           red_color : out STD_LOGIC_VECTOR (3 downto 0);
           green_color : out STD_LOGIC_VECTOR (3 downto 0);
           blue_color : out STD_LOGIC_VECTOR (3 downto 0));
end nave_principal_rom;

architecture Behavioral of nave_principal_rom is

component nave_principal_red is Port(
    clka: in std_logic;
    addra: in std_logic_vector(12 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

component nave_principal_green is Port(
    clka: in std_logic;
    addra: in std_logic_vector(12 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

component nave_principal_blue is Port(
    clka: in std_logic;
    addra: in std_logic_vector(12 downto 0);
    douta: out std_logic_vector(3 downto 0));
    end component;

begin

reddish: nave_principal_red port map(
    clka=>clock,
    addra=>addr,
    douta=>red_color);
    
greenish: nave_principal_green port map(
    clka=>clock,
    addra=>addr,
    douta=>green_color);
    
blueish: nave_principal_blue port map(
    clka=>clock,
    addra=>addr,
    douta=>blue_color);

end Behavioral;
