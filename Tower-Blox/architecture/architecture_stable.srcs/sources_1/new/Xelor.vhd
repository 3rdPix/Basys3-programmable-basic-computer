library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Xelor is Port(
    clock_50mhz: in std_logic;
    h_sync: out std_logic;
    v_sync: out std_logic;
    valid_area: out std_logic;
    x_coordinate: out integer;
    y_coordinate: out integer);
    end Xelor;

architecture Behavioral of Xelor is

-- Estos nuevos valores son de http://tinyvga.com/vga-timing
-- Hechos para crear resolución 800x600 a 50Mhz

-- V-Sync (en líneas)
constant vsync_pulse : integer := 666;
constant vdisplay_time : integer := 600;
constant vpulse_width : integer := 6;
constant vfront_porch : integer := 37;
constant vback_porch : integer := 23;

-- H-Sync (en Clks)
constant hsync_pulse : integer := 1040;
constant hdisplay_time : integer := 800;
constant hpulse_width : integer := 120;
constant hfront_porch : integer := 56;
constant hback_porch : integer := 64;


signal h_count : integer := 0; 
signal v_count : integer := 0;
signal hsync : std_logic;
signal vsync : std_logic;

begin

process(clock_50mhz) begin
    if rising_edge(clock_50mhz) then
        if h_count < hsync_pulse - 1 then
            h_count <= h_count + 1;
        else
            h_count <= 0;
            if v_count < vsync_pulse - 1 then
                v_count <= v_count + 1;
            else
                v_count <= 0;
            end if;
        end if;
        if h_count < hpulse_width then
           hsync <= '0';
        else
            hsync <= '1';
        end if;
        if v_count < vpulse_width then
             vsync <= '0';
            else
            vsync <= '1';
        end if;
        if (h_count >= (hpulse_width + hback_porch)
          and h_count < (hpulse_width + hback_porch + hdisplay_time))
          and (v_count >= (vpulse_width + vback_porch)
          and v_count < (vpulse_width + vback_porch + vdisplay_time)) then
            valid_area <= '1';
            y_coordinate <= v_count - vpulse_width - vback_porch;
            x_coordinate <= h_count - hpulse_width - hback_porch;
        else
            valid_area <= '0';
            y_coordinate <= 0;
            x_coordinate <= 0;
        end if;
    end if;
end process;

h_sync <= hsync;
v_sync <= vsync;

end Behavioral;
