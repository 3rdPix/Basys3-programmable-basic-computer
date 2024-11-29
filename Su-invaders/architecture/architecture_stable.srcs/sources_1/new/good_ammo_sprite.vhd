library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity good_ammo_sprite is Port(
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
    end good_ammo_sprite;

architecture Behavioral of good_ammo_sprite is

----------------------------------------
--          DATA & CONTROL            --
----------------------------------------
-- refs
constant o_width: integer := 10;
constant o_height: integer := 10;
-- addss
constant Ax1: std_logic_vector(11 downto 0) := "000000011110";
constant Ay1: std_logic_vector(11 downto 0) := "000000011111";
constant Ax2: std_logic_vector(11 downto 0) := "000000100000";
constant Ay2: std_logic_vector(11 downto 0) := "000000100001";
constant Ax3: std_logic_vector(11 downto 0) := "000000100010";
constant Ay3: std_logic_vector(11 downto 0) := "000000100011";
-- regs""
signal x1: integer := 800;
signal y1: integer := 0;
signal x2: integer := 800;
signal y2: integer := 0;
signal x3: integer := 800;
signal y3: integer := 0;

----------------------------------------
--               FLUX                 --
----------------------------------------
signal out_in_a_block: std_logic;

signal inter_read_address: std_logic_vector(6 downto 0) := (others => '0');
signal inter_red_color: std_logic_vector(3 downto 0);
signal inter_green_color: std_logic_vector(3 downto 0);
signal inter_blue_color: std_logic_vector(3 downto 0);
signal inter_pixel: std_logic_vector(11 downto 0);
component good_ammo_rom is Port(
    clock: in std_logic;
    addr: in std_logic_vector(6 downto 0);
    red_color: out std_logic_vector(3 downto 0);
    green_color: out std_logic_vector(3 downto 0);
    blue_color: out std_logic_vector(3 downto 0));
    end component;

begin

block_pixels: good_ammo_rom port map(
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
        elsif ram_addressed = Ax2 then
            x2 <= to_integer(unsigned(ram_receiving));
        elsif ram_addressed = Ay2 then
            y2 <= to_integer(unsigned(ram_receiving));
        elsif ram_addressed = Ax3 then
            x3 <= to_integer(unsigned(ram_receiving));
        elsif ram_addressed = Ay3 then
            y3 <= to_integer(unsigned(ram_receiving));
        end if;
    end if;
    end if;
end process;

deteccion_color: process (clock) begin
    if rising_edge(clock) then
        if (current_x  >= x1 - 4 ) and (current_x  < x1 + o_width - 4 ) and
        (current_y >= y1) and (current_y < y1 + o_height) then
            out_in_a_block <= '1';
            inter_read_address <= std_logic_vector(to_unsigned((current_x+4 - x1) + ((current_y - y1) * o_width), 7));
        
        elsif (current_x  >= x2 - 4 ) and (current_x  < x2 + o_width - 4 ) and
        (current_y >= y2) and (current_y < y2 + o_height) then
            out_in_a_block <= '1';
            inter_read_address <= std_logic_vector(to_unsigned((current_x+4 - x2) + ((current_y - y2) * o_width), 7));
        
        elsif (current_x  >= x3 - 4 ) and (current_x  < x3 + o_width - 4 ) and
        (current_y >= y3) and (current_y < y3 + o_height) then
            out_in_a_block <= '1';
            inter_read_address <= std_logic_vector(to_unsigned((current_x+4 - x3) + ((current_y - y3) * o_width), 7));
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
