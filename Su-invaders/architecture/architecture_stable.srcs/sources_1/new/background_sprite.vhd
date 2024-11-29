library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity background_sprite is Port(
    -- generales de control
    clock: in std_logic;
    current_x: in integer;
    current_y: in integer;
    pixel_color: out std_logic_vector(11 downto 0));
    end background_sprite;

architecture Behavioral of background_sprite is

----------------------------------------
--          DATA & CONTROL            --
----------------------------------------
-- refs
constant background_width: integer := 300;
constant background_height: integer := 300;

----------------------------------------
--               FLUX                 --
----------------------------------------

signal inter_read_address: std_logic_vector(16 downto 0) := (others => '0');
signal inter_red_color: std_logic_vector(3 downto 0);
signal inter_green_color: std_logic_vector(3 downto 0);
signal inter_blue_color: std_logic_vector(3 downto 0);
component background_rom is Port(
    clock: in std_logic;
    addr: in std_logic_vector(16 downto 0);
    red_color: out std_logic_vector(3 downto 0);
    green_color: out std_logic_vector(3 downto 0);
    blue_color: out std_logic_vector(3 downto 0));
    end component;

begin

block_pixels: background_rom port map(
    clock=>clock,
    addr=>inter_read_address,
    red_color=>inter_red_color,
    green_color=>inter_green_color,
    blue_color=>inter_blue_color);

deteccion_color: process (clock) begin
    if rising_edge(clock) then
        inter_read_address <= std_logic_vector(to_unsigned((current_x mod background_width) + ((current_y mod background_height) * background_width), 17));
    end if;
end process;

pixel_color <= inter_red_color & inter_green_color & inter_blue_color;

end Behavioral;
