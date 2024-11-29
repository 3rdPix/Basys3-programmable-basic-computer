library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity GTX1050 is
  Port (
        clock: in std_logic;
        h_sync: in integer;
        y_sync: in integer;
        reg_xadiv: in std_logic_vector(15 downto 0);
        reg_currt: in std_logic_vector(15 downto 0);
        color_out: out std_logic_vector(11 downto 0)
   );
end GTX1050;

architecture Behavioral of GTX1050 is

component logo_rom is Port(
    clock: in std_logic;
    addr: in std_logic_vector(13 downto 0);
    color_out: out std_logic_vector(11 downto 0));
    end component;
component name_rom is Port(
    clock: in std_logic;
    addr: in std_logic_vector(14 downto 0);
    color_out: out std_logic_vector(11 downto 0));
end component;
component indicate_1_rom is Port(
    clock: in std_logic;
    addr: in std_logic_vector(13 downto 0);
    color_out: out std_logic_vector(11 downto 0));
end component;
component indicate_2_rom is Port(
    clock: in std_logic;
    addr: in std_logic_vector(12 downto 0);
    color_out: out std_logic_vector(11 downto 0));
end component;
component pointer is Port(
    clock: in std_logic;
    addr: in std_logic_vector(11 downto 0);
    color_out: out std_logic_vector(11 downto 0));
end component;

signal vertical_position : integer := 0;
signal color_final : std_logic_vector(11 downto 0);
constant vsync_pulse : integer := 521;
constant vpulse_width : integer := 2;
constant vback_porch : integer := 29;


constant name_width: integer := 334;
constant name_height: integer := 51;
signal name_addr: std_logic_vector(14 downto 0);
signal name_color: std_logic_vector(11 downto 0);
constant logo_width: integer := 100;
constant logo_height: integer := 100;
signal logo_addr: std_logic_vector(13 downto 0);
signal logo_color: std_logic_vector(11 downto 0);
constant indicate_1_width: integer := 226;
constant indicate_1_height: integer := 59;
signal indicate_1_addr: std_logic_vector(13 downto 0);
signal indicate_1_color: std_logic_vector(11 downto 0);
constant indicate_2_width: integer := 265;
constant indicate_2_height: integer := 21;
signal indicate_2_addr: std_logic_vector(12 downto 0);
signal indicate_2_color: std_logic_vector(11 downto 0);
constant pointer_width: integer := 63;
constant pointer_height: integer := 38;
signal pointer1_addr: std_logic_vector(11 downto 0);
signal pointer2_addr: std_logic_vector(11 downto 0);
signal pointer1_color: std_logic_vector(11 downto 0);
signal pointer2_color: std_logic_vector(11 downto 0);

constant name_xpos: integer := 200;
constant name_ypos: integer := 30;
constant logo_xpos: integer := 20;
constant logo_ypos: integer := 30;
constant indicate_1_xpos: integer := 20;
constant indicate_1_ypos: integer := 200;
constant indicate_2_xpos: integer := 20;
constant indicate_2_ypos: integer := 300;
constant pointer1_xpos: integer := 300;
constant pointer1_ypos: integer := 200;
constant pointer2_xpos: integer := 300;
constant pointer2_ypos: integer := 300;
constant block_xpos: integer := 400;
constant xadiv_ypos: integer := 150;
constant block_width: integer := 250;
constant block_height: integer := 120;
constant currt_ypos: integer := (xadiv_ypos + block_height);


begin

inst_logo: logo_rom port map(
    clock=>clock,
    addr=>logo_addr,
    color_out=>logo_color);
inst_name: name_rom port map(
    clock=>clock,
    addr=>name_addr,
    color_out=>name_color);
inst_indicate_1: indicate_1_rom port map(
    clock=>clock,
    addr=>indicate_1_addr,
    color_out=>indicate_1_color);
inst_indicate_2: indicate_2_rom port map(
    clock=>clock,
    addr=>indicate_2_addr,
    color_out=>indicate_2_color);
inst_pointer1: pointer port map(
    clock=>clock,
    addr=>pointer1_addr,
    color_out=>pointer1_color);
inst_pointer2: pointer port map(
    clock=>clock,
    addr=>pointer2_addr,
    color_out=>pointer2_color);

-- DIVISION EN 4 SECTORES
process (h_sync, y_sync) begin
    if rising_edge(clock) then
        if (y_sync -2>= logo_xpos) and (y_sync  -2< logo_xpos + logo_width)
        and (h_sync >= logo_ypos) and (h_sync  < logo_ypos + logo_height) then
            logo_addr <= std_logic_vector(to_unsigned((y_sync - logo_xpos) + ((h_sync - logo_ypos) * logo_width), 14));
            color_final <= logo_color;
        
        elsif (y_sync-2  >= name_xpos) and (y_sync-2  < name_xpos + name_width)
        and (h_sync >= name_ypos) and (h_sync < name_ypos + name_height) then
            name_addr <= std_logic_vector(to_unsigned((y_sync - name_xpos) + ((h_sync - name_ypos) * name_width), 15));
            color_final <= name_color;
        
        elsif (y_sync-2  >= indicate_1_xpos) and (y_sync-2  < indicate_1_xpos + indicate_1_width)
        and (h_sync  >= indicate_1_ypos) and (h_sync < indicate_1_ypos + indicate_1_height) then
            indicate_1_addr <= std_logic_vector(to_unsigned((y_sync - indicate_1_xpos) + ((h_sync - indicate_1_ypos) * indicate_1_width), 14));
            color_final <= indicate_1_color;
        
        elsif (y_sync-2  >= indicate_2_xpos) and (y_sync-2  < indicate_2_xpos + indicate_2_width)
        and (h_sync  >= indicate_2_ypos) and (h_sync < indicate_2_ypos + indicate_2_height) then
            indicate_2_addr <= std_logic_vector(to_unsigned((y_sync - indicate_2_xpos) + ((h_sync - indicate_2_ypos) * indicate_2_width), 13));
            color_final <= indicate_2_color;
        
        elsif (y_sync-2  >= pointer1_xpos) and (y_sync-2  < pointer1_xpos + pointer_width)
        and (h_sync  >= pointer1_ypos) and (h_sync < pointer1_ypos + pointer_height) then
            pointer1_addr <= std_logic_vector(to_unsigned((y_sync - pointer1_xpos) + ((h_sync - pointer1_ypos) * pointer_width), 12));
            color_final <= pointer1_color;
        
        elsif (y_sync-2  >= pointer2_xpos) and (y_sync-2  < pointer2_xpos + pointer_width)
        and (h_sync  >= pointer2_ypos) and (h_sync < pointer2_ypos + pointer_height) then
            pointer2_addr <= std_logic_vector(to_unsigned((y_sync - pointer2_xpos) + ((h_sync - pointer2_ypos) * pointer_width), 12));
            color_final <= pointer2_color;
        
        elsif (y_sync-2  >= block_xpos) and (y_sync-2  < block_xpos + block_width)
        and (h_sync  >= xadiv_ypos) and (h_sync < xadiv_ypos + block_height) then
            color_final <= reg_xadiv(15 downto 12) & reg_xadiv(9 downto 6) & reg_xadiv(3 downto 0);
            
        elsif (y_sync-2  >= block_xpos) and (y_sync-2  < block_xpos + block_width)
        and (h_sync  >= currt_ypos) and (h_sync < currt_ypos + block_height) then
            color_final <= reg_currt(15 downto 12) & reg_currt(9 downto 6) & reg_currt(3 downto 0);
            
        else
            color_final <= (others => '0');
        end if;
     end if;
end process;

color_out <= color_final;
end Behavioral;
