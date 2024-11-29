library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VRAM is Port(
    -- senales de control placa general
    clock: in std_logic;
    cleanse: in std_logic;
    -- modificadores provenientes de cpu
    ram_addressed: in std_logic_vector(11 downto 0);
    ram_receiving: in std_logic_vector(15 downto 0);
    ram_activate: in std_logic;
    -- solicitudes posicionales
    is_there_x: in integer;
    is_there_y: in integer;
    -- respuestas posicionales
    is_there: out std_logic;
    there_x: out integer;
    there_y: out integer;
    there_width: out integer;
    there_height: out integer;
    item_type: out integer);
    end VRAM;

architecture Behavioral of VRAM is

-- componentes genericos de header
component vram_header_reg is Port(
    clock: in std_logic;
    clear: in std_logic;
    load: in std_logic;
    datain: in std_logic_vector(15 downto 0);
    dataout: out integer range 0 to 65535);
    end component;

---------------------------------
--         DATA TABLE          --
---------------------------------

constant bloque_w: integer := 64;
constant bloque_h: integer := 64;

constant bpxa: std_logic_vector(11 downto 0) := "000000001000";
constant bpya: std_logic_vector(11 downto 0) := "000000001001";
constant bmxa: std_logic_vector(11 downto 0) := "000000001010";
constant bmya: std_logic_vector(11 downto 0) := "000000001011";
constant bbxa: std_logic_vector(11 downto 0) := "000000001100";
constant bbya: std_logic_vector(11 downto 0) := "000000001101";

---------------------------------
--         DATA WIRES          --
---------------------------------

-- bloques
signal bpx: integer;
signal bpy: integer;
signal bmx: integer;
signal bmy: integer;
signal bbx: integer;
signal bby: integer;

-- senales de modificacion
signal bpxL: std_logic;
signal bpyL: std_logic;
signal bmxL: std_logic;
signal bmyL: std_logic;
signal bbxL: std_logic;
signal bbyL: std_logic;

begin

bloque_principal_x: vram_header_reg port map(clock=>clock, clear=>cleanse,
    load=>bpxL, datain=>ram_receiving, dataout=>bpx);
bloque_principal_y: vram_header_reg port map(clock=>clock, clear=>cleanse,
    load=>bpyL, datain=>ram_receiving, dataout=>bpy);
    
bloque_medio_x: vram_header_reg port map(clock=>clock, clear=>cleanse,
    load=>bmxL, datain=>ram_receiving, dataout=>bmx);
bloque_medio_y: vram_header_reg port map(clock=>clock, clear=>cleanse,
    load=>bmyL, datain=>ram_receiving, dataout=>bmy);

bloque_bajo_x: vram_header_reg port map(clock=>clock, clear=>cleanse,
    load=>bbxL, datain=>ram_receiving, dataout=>bbx);
bloque_bajo_y: vram_header_reg port map(clock=>clock, clear=>cleanse,
    load=>bbyL, datain=>ram_receiving, dataout=>bby);
    
with ram_addressed select bpxL <= ram_activate when bpxa, '0' when others;
with ram_addressed select bpyL <= ram_activate when bpya, '0' when others;
with ram_addressed select bmxL <= ram_activate when bmxa, '0' when others;
with ram_addressed select bmyL <= ram_activate when bmya, '0' when others;
with ram_addressed select bbxL <= ram_activate when bbxa, '0' when others;
with ram_addressed select bbyL <= ram_activate when bbya, '0' when others;

procesar_solicitud: process (clock, is_there_x, is_there_y) begin
    if rising_edge(clock) then
        -- aqui se revisa cada elemento
        
        -- BLOQUE PRINCIPAL
        if (is_there_x -8 >= bpx) and (is_there_x < bpx + bloque_w)
        and (is_there_y >= bpy) and (is_there_y < bpy + bloque_h) then
        
            is_there <= '1';
            there_x <= bpx;
            there_y <= bpy;
            there_width <= bloque_w;
            there_height <= bloque_h;
            item_type <= 1;

        -- BLOQUE MEDIO
        elsif (is_there_x -8>= bmx) and (is_there_x < bmx + bloque_w)
        and (is_there_y >= bmy) and (is_there_y < bmy + bloque_h) then
        
            is_there <= '1';
            there_x <= bmx;
            there_y <= bmy;
            there_width <= bloque_w;
            there_height <= bloque_h;
            item_type <= 1;

        -- BLOQUE BAJO
        elsif (is_there_x -8>= bbx) and (is_there_x < bbx + bloque_w)
        and (is_there_y >= bby) and (is_there_y < bby + bloque_h) then
        
            is_there <= '1';
            there_x <= bbx;
            there_y <= bby;
            there_width <= bloque_w;
            there_height <= bloque_h;
            item_type <= 1;

        else
            is_there <= '0';
            there_x <= 0;
            there_y <= 0;
            there_width <= 0;
            there_height <= 0;
            item_type <= 0;
        end if;
    end if;
    end process;


end Behavioral;
