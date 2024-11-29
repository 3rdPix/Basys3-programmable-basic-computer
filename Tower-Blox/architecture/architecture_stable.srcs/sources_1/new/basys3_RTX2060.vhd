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

component yellow_block_sprite is Port(
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
    signal yb_pixel: std_logic_vector(11 downto 0);
    signal yb_activate: std_logic;

constant background_color: std_logic_vector(11 downto 0) := "001111011110";
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

yb_controller: yellow_block_sprite port map(
    clock=>smol_clock,
    current_x=>x_pos, current_y=>y_pos,
    pixel_color=>yb_pixel, in_a_block=>yb_activate,
    update_registry=>ram_activate, ram_addressed=>ram_addressed, ram_receiving=>ram_receiving);
    
selector_color: process (smol_clock) begin
    if yb_activate = '1' then
        final_red <= yb_pixel(11 downto 8);
        final_green <= yb_pixel(7 downto 4);
        final_blue <= yb_pixel(3 downto 0);
    else
        final_red <= background_color(11 downto 8);
        final_green <= background_color(7 downto 4);
        final_blue <= background_color(3 downto 0);
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
