library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GRAM is Port(
    clock: in std_logic;
    reading_address: in std_logic_vector(15 downto 0);
    item_selector: in integer;
    red: out std_logic_vector(3 downto 0);
    green: out std_logic_vector(3 downto 0);
    blue: out std_logic_vector(3 downto 0));
    end GRAM;

architecture Behavioral of GRAM is

-- entity 0
constant id_0_red: std_logic_vector(3 downto 0) := "0100";
constant id_0_green: std_logic_vector(3 downto 0) := "1111";
constant id_0_blue: std_logic_vector(3 downto 0) := "1110";

-- entity 1
component yellow_block_rom is Port(
    clock: in std_logic;
    addr: in std_logic_vector(11 downto 0);
    red_color: out std_logic_vector(3 downto 0);
    green_color: out std_logic_vector(3 downto 0);
    blue_color: out std_logic_vector(3 downto 0));
    end component;
    signal id_1_red: std_logic_vector(3 downto 0);
    signal id_1_green: std_logic_vector(3 downto 0);
    signal id_1_blue: std_logic_vector(3 downto 0);

signal lectura_intermedia: std_logic_vector(11 downto 0);

begin

data_yellow_block: yellow_block_rom port map(
    clock=>clock, addr=>reading_address(11 downto 0),
    red_color=>id_1_red,
    green_color=>id_1_green,
    blue_color=>id_1_blue);

with item_selector select red <=
    id_0_red when 0,
    id_1_red when 1,
    (others=>'0') when others;
with item_selector select green <=
    id_0_green when 0,
    id_1_green when 1,
    (others=>'0') when others;
with item_selector select blue <=
    id_0_blue when 0,
    id_1_blue when 1,
    (others=>'0') when others;


end Behavioral;
