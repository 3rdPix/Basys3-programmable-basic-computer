library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;

entity yellow_block_sprite is Port(
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
    end yellow_block_sprite;

architecture Behavioral of yellow_block_sprite is

----------------------------------------
--          DATA & CONTROL            --
----------------------------------------
-- refs
constant arista: integer := 64;
constant bpxA: std_logic_vector(11 downto 0) := "000000001000";
constant bpyA: std_logic_vector(11 downto 0) := "000000001001";
constant bmxA: std_logic_vector(11 downto 0) := "000000001010";
constant bmyA: std_logic_vector(11 downto 0) := "000000001011";
constant bbxA: std_logic_vector(11 downto 0) := "000000001100";
constant bbyA: std_logic_vector(11 downto 0) := "000000001101";
-- regs""
signal bpx: integer := 0;
signal bpy: integer := 0;
signal bmx: integer := 0;
signal bmy: integer := 0;
signal bbx: integer := 0;
signal bby: integer := 0;

----------------------------------------
--               FLUX                 --
----------------------------------------
signal out_in_a_block: std_logic;

signal inter_read_address: std_logic_vector(11 downto 0) := (others => '0');
signal inter_red_color: std_logic_vector(3 downto 0);
signal inter_green_color: std_logic_vector(3 downto 0);
signal inter_blue_color: std_logic_vector(3 downto 0);
component yellow_block_rom is Port(
    clock: in std_logic;
    addr: in std_logic_vector(11 downto 0);
    red_color: out std_logic_vector(3 downto 0);
    green_color: out std_logic_vector(3 downto 0);
    blue_color: out std_logic_vector(3 downto 0));
    end component;

begin

block_pixels: yellow_block_rom port map(
    clock=>clock,
    addr=>inter_read_address,
    red_color=>inter_red_color,
    green_color=>inter_green_color,
    blue_color=>inter_blue_color);

carga_posiciones: process (clock, update_registry) begin
    if rising_edge(clock) then
    if update_registry = '1' then
        if ram_addressed = bpxA then
            bpx <= to_integer(unsigned(ram_receiving));
        elsif ram_addressed = bpyA then
            bpy <= to_integer(unsigned(ram_receiving));
        elsif ram_addressed = bmxA then
            bmx <= to_integer(unsigned(ram_receiving));
        elsif ram_addressed = bmyA then
            bmy <= to_integer(unsigned(ram_receiving));
        elsif ram_addressed = bbxA then
            bbx <= to_integer(unsigned(ram_receiving));
        elsif ram_addressed = bbyA then
            bby <= to_integer(unsigned(ram_receiving));
        end if;
    end if;
    end if;
end process;

deteccion_color: process (clock) begin
    if rising_edge(clock) then
        -- bloque principal
        if (current_x-4  >= bpx ) and (current_x  < bpx + arista) and
        (current_y >= bpy) and (current_y < bpy + arista) then
            out_in_a_block <= '1';
            inter_read_address <= std_logic_vector(to_unsigned((current_x - bpx) + ((current_y - bpy) * arista), 12));
        
        -- bloque medio
        elsif (current_x-4  >= bmx ) and (current_x  < bmx + arista) and
        (current_y >= bmy) and (current_y < bmy + arista) then
            out_in_a_block <= '1';
            inter_read_address <= std_logic_vector(to_unsigned((current_x - bmx) + ((current_y - bmy) * arista), 12));
        
        -- bloque bajo
        elsif (current_x-4 >= bbx ) and (current_x  < bbx + arista) and
        (current_y >= bby) and (current_y < bby + arista) then
            out_in_a_block <= '1';
            inter_read_address <= std_logic_vector(to_unsigned((current_x - bbx) + ((current_y - bby) * arista), 12));
        
        else
            out_in_a_block <= '0';
            inter_read_address <= (others=>'0');
        end if;
    end if;
end process;

in_a_block <= out_in_a_block;
pixel_color <= inter_red_color & inter_green_color & inter_blue_color;

end Behavioral;
