library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity nave_principal_sprite is Port(
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
    end nave_principal_sprite;

architecture Behavioral of nave_principal_sprite is

----------------------------------------
--          DATA & CONTROL            --
----------------------------------------
-- refs
constant o_width: integer := 69;
constant o_height: integer := 90;
-- addss
constant Ax1: std_logic_vector(11 downto 0) := "000000011100";
constant Ay1: std_logic_vector(11 downto 0) := "000000011101";
-- regs""
signal x1: integer := 800;
signal y1: integer := 0;

----------------------------------------
--               FLUX                 --
----------------------------------------
signal out_in_a_block: std_logic;

signal inter_read_address: std_logic_vector(12 downto 0) := (others => '0');
signal inter_red_color: std_logic_vector(3 downto 0);
signal inter_green_color: std_logic_vector(3 downto 0);
signal inter_blue_color: std_logic_vector(3 downto 0);
signal inter_pixel: std_logic_vector(11 downto 0);
component nave_principal_rom is Port(
    clock: in std_logic;
    addr: in std_logic_vector(12 downto 0);
    red_color: out std_logic_vector(3 downto 0);
    green_color: out std_logic_vector(3 downto 0);
    blue_color: out std_logic_vector(3 downto 0));
    end component;

begin

block_pixels: nave_principal_rom port map(
    clock=>clock,
    addr=>inter_read_address,
    red_color=>inter_red_color,
    green_color=>inter_green_color,
    blue_color=>inter_blue_color);

carga_posiciones: process (clock, update_registry) begin
    if rising_edge(clock) then
    if update_registry = '1' then
        if ram_addressed = Ax1 then
            x1 <= to_integer(unsigned(ram_receiving));
        elsif ram_addressed = Ay1 then
            y1 <= to_integer(unsigned(ram_receiving));
        end if;
    end if;
    end if;
end process;

deteccion_color: process (clock) begin
    if rising_edge(clock) then
        if (current_x  >= x1 - 4 ) and (current_x  < x1 + o_width - 4 ) and
        (current_y >= y1) and (current_y < y1 + o_height) then
            out_in_a_block <= '1';
            inter_read_address <= std_logic_vector(to_unsigned((current_x+4 - x1) + ((current_y - y1) * o_width), 13));
        else
            out_in_a_block <= '0';
            inter_read_address <= (others=>'0');
        end if;
     end if;
end process;
inter_pixel <= inter_red_color & inter_green_color & inter_blue_color; 
with inter_pixel select in_a_block <=
    '0' when "010011111110", out_in_a_block when others;
pixel_color <= inter_pixel;
end Behavioral;
