library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RTX2060 is Port(
    smol_clock: in std_logic;
    full_clock: in std_logic;
    ram_addressed: in std_logic_vector(11 downto 0);
    ram_receiving: in std_logic_vector(15 downto 0);
    ram_activate: in std_logic;
    cleanse: in std_logic;
    horizontal_syncro: out std_logic;
    vertical_syncro: out std_logic;
    red_vector: out std_logic_vector(3 downto 0);
    green_vector: out std_logic_vector(3 downto 0);
    blue_vector: out std_logic_vector(3 downto 0));
    end RTX2060;

architecture Behavioral of RTX2060 is

component clock_halfener is Port(
    clk_in: in std_logic;
    clk_out: out std_logic);
    end component;
    signal half_clock: std_logic;

component Xelor is Port(
    clock_50mhz: in std_logic;
    h_sync: out std_logic;
    v_sync: out std_logic;
    valid_area: out std_logic;
    x_coordinate: out integer;
    y_coordinate: out integer);
    end component;
    signal valid_area: std_logic;
    signal y_pos: integer;
    signal x_pos: integer;

component nave_amarilla_sprite is Port(
    -- generales de control
    clock: in std_logic;
    current_x: in integer;
    current_y: in integer;
    pixel_color: out std_logic_vector(11 downto 0);
    in_a_block: out std_logic;
    --escritura
    update_registry: in std_logic;
    ram_addressed: in std_logic_vector(11 downto 0);
    ram_receiving: in std_logic_vector(15 downto 0));
    end component;
    signal na_pixel: std_logic_vector(11 downto 0);
    signal na_activate: std_logic;

component nave_azul_sprite is Port(
    -- generales de control
    clock: in std_logic;
    current_x: in integer;
    current_y: in integer;
    pixel_color: out std_logic_vector(11 downto 0);
    in_a_block: out std_logic;
    --escritura
    update_registry: in std_logic;
    ram_addressed: in std_logic_vector(11 downto 0);
    ram_receiving: in std_logic_vector(15 downto 0));
    end component;
    signal nz_pixel: std_logic_vector(11 downto 0);
    signal nz_activate: std_logic;

component background_sprite is Port(
    -- generales de control
    clock: in std_logic;
    current_x: in integer;
    current_y: in integer;
    pixel_color: out std_logic_vector(11 downto 0));
    end component;
    signal background_color: std_logic_vector(11 downto 0);

component nave_principal_sprite is Port(
    -- generales de control
    clock: in std_logic;
    current_x: in integer;
    current_y: in integer;
    pixel_color: out std_logic_vector(11 downto 0);
    in_a_block: out std_logic;
    --escritura
    update_registry: in std_logic;
    ram_addressed: in std_logic_vector(11 downto 0);
    ram_receiving: in std_logic_vector(15 downto 0));
    end component;
    signal np_pixel: std_logic_vector(11 downto 0);
    signal np_activate: std_logic;
    
component good_ammo_sprite is Port(
    -- generales de control
    clock: in std_logic;
    current_x: in integer;
    current_y: in integer;
    pixel_color: out std_logic_vector(11 downto 0);
    in_a_block: out std_logic;
    --escritura
    update_registry: in std_logic;
    ram_addressed: in std_logic_vector(11 downto 0);
    ram_receiving: in std_logic_vector(15 downto 0));
    end component;
    signal ga_pixel: std_logic_vector(11 downto 0);
    signal ga_activate: std_logic;

signal final_red: std_logic_vector(3 downto 0);
signal final_green: std_logic_vector(3 downto 0);
signal final_blue: std_logic_vector(3 downto 0);

begin

instance_clock_halfener: clock_halfener port map(
    clk_in=>full_clock,
    clk_out=>half_clock);

xelorium: Xelor port map(
    clock_50mhz=>half_clock,
    h_sync=>horizontal_syncro,
    v_sync=>vertical_syncro,
    valid_area=>valid_area,
    y_coordinate=>y_pos,
    x_coordinate=>x_pos);

na_controller: nave_amarilla_sprite port map(
    clock=>smol_clock,
    current_x=>x_pos, current_y=>y_pos,
    pixel_color=>na_pixel, in_a_block=>na_activate,
    update_registry=>ram_activate, ram_addressed=>ram_addressed, ram_receiving=>ram_receiving);

nz_controller: nave_azul_sprite port map(
    clock=>smol_clock,
    current_x=>x_pos, current_y=>y_pos,
    pixel_color=>nz_pixel, in_a_block=>nz_activate,
    update_registry=>ram_activate, ram_addressed=>ram_addressed, ram_receiving=>ram_receiving);

np_controller: nave_principal_sprite port map(
    clock=>smol_clock,
    current_x=>x_pos, current_y=>y_pos,
    pixel_color=>np_pixel, in_a_block=>np_activate,
    update_registry=>ram_activate, ram_addressed=>ram_addressed, ram_receiving=>ram_receiving);

ga_controller: good_ammo_sprite port map(
    clock=>smol_clock,
    current_x=>x_pos, current_y=>y_pos,
    pixel_color=>ga_pixel, in_a_block=>ga_activate,
    update_registry=>ram_activate, ram_addressed=>ram_addressed, ram_receiving=>ram_receiving);

background_controller: background_sprite port map(
    clock=>smol_clock,
    current_x=>x_pos, current_y=>y_pos,
    pixel_color=>background_color);

selector_color: process (smol_clock) begin
if rising_edge(smol_clock) then
    if ga_activate = '1' then
        final_red <= ga_pixel(11 downto 8);
        final_green <= ga_pixel(7 downto 4);
        final_blue <= ga_pixel(3 downto 0);
    elsif na_activate = '1' then
        final_red <= na_pixel(11 downto 8);
        final_green <= na_pixel(7 downto 4);
        final_blue <= na_pixel(3 downto 0);
    elsif nz_activate = '1' then
        final_red <= nz_pixel(11 downto 8);
        final_green <= nz_pixel(7 downto 4);
        final_blue <= nz_pixel(3 downto 0);
    elsif np_activate = '1' then
        final_red <= np_pixel(11 downto 8);
        final_green <= np_pixel(7 downto 4);
        final_blue <= np_pixel(3 downto 0);
    else
        final_red <= background_color(11 downto 8);
        final_green <= background_color(7 downto 4);
        final_blue <= background_color(3 downto 0);
    end if;
end if;
end process;

with valid_area select red_vector <=
    final_red when '1',
    (others => '0') when others;
with valid_area select green_vector <=
    final_green when '1',
    (others => '0') when others;
with valid_area select blue_vector <=
    final_blue when '1',
    (others => '0') when others;
end Behavioral;
