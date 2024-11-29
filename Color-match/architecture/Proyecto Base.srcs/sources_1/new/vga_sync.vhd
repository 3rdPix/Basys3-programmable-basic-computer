----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2024 19:10:00
-- Design Name: 
-- Module Name: vga_sync - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Xelor is
    Port ( clock : in std_logic;
           h_sync : out std_logic;
           v_sync : out std_logic;
           en_display_area: out std_logic;
           -- fase1 especial
           -- esto funcionó, es mejor utilizar el count como identificador posicional
           pafuera_vcount: out integer;
           pafuera_hcount: out integer
           );
end Xelor;

architecture Behavioral of Xelor is

-- De acuerdo al manual de referencia los valores son xd
-- 640x480 a 25MHz (el más rápido del clock_divider)

-- hay diferencia entre usar los clocks y usar las lineas... usa clocks en horizontal y lineas en vertical si¿?

-- V-Sync (en líneas)
constant vsync_pulse : integer := 521;
constant vdisplay_time : integer := 480;
constant vpulse_width : integer := 2;
constant vfront_porch : integer := 10;
constant vback_porch : integer := 29;

-- H-Sync (en Clks)
constant hsync_pulse : integer := 800;
constant hdisplay_time : integer := 640;
constant hpulse_width : integer := 96;
constant hfront_porch : integer := 16;
constant hback_porch : integer := 48;

-- pa contar donde estamos supuestamente, podriamos outputear esto para usarlo en la DMA directamente
signal h_count : integer := 0; 
signal v_count : integer := 0;

-- no me dejaba pasarlas directo (necesita definicion)
signal hsync : std_logic;
signal vsync : std_logic;

begin


process(clock) begin

    if rising_edge(clock) then

        -- Incrementar el contador horizontal
        if h_count < hsync_pulse - 1 then
            h_count <= h_count + 1;
        
        else
            h_count <= 0; -- Reiniciar el contador horizontal
            -- Incrementar el contador vertical
            if v_count < vsync_pulse - 1 then
                v_count <= v_count + 1;
            
            else
                v_count <= 0; -- Reiniciar el contador vertical
            end if;
        end if;

        -- crear HSync
        if h_count < hpulse_width then
           hsync <= '0'; -- low
        else
            hsync <= '1'; -- high
        end if;

        -- deberia ser lo mismo (el contador se hace cargo)
        if v_count < vpulse_width then
             vsync <= '0'; -- low
            else
            vsync <= '1'; -- high
        end if;

-- Además de las señales de h_sync y v_sync necesitamos algo que nos diga si estamos dentro del área display
-- Se supone que las señales rgb están low en cualquier zona fuera del display... quiźa por eso no hay color      

        if (
            h_count >= (hpulse_width + hback_porch)
            and h_count < (hpulse_width + hback_porch + hdisplay_time))
            and (v_count >= (vpulse_width + vback_porch)
            and v_count < (vpulse_width + vback_porch + vdisplay_time)) then
                en_display_area <= '1';
        else
                en_display_area <= '0';
        end if;
        
        
    end if;
end process;

-- si¿? :C
h_sync <= hsync;
v_sync <= vsync;

-- NO xD (ln. 105)

-- 3 doritos después: POR FIN LOCO (xd) (funciona :D)
        
-- fase1 especial
pafuera_vcount <= v_count - vpulse_width - vback_porch;
pafuera_hcount <= h_count - hpulse_width - hback_porch;

end Behavioral;
