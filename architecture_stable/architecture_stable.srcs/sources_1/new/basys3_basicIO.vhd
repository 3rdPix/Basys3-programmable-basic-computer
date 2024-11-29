library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity basicIO_controller is Port(
    data_to_cpu: out std_logic_vector(15 downto 0);
    ram_pointer: in std_logic_vector(11 downto 0);
    data_to_ram: in std_logic_vector(15 downto 0);
    data_from_ram: in std_logic_vector(15 downto 0);
    write_to_ram: in std_logic;
    cleanse: std_logic;
    smol_clock: in std_logic;
    sped_clock: in std_logic;
    displays_selector: out std_logic_vector(3 downto 0);
    displays_segments: out std_logic_vector(7 downto 0);
    leds: out std_logic_vector(15 downto 0);
    buttons: in std_logic_vector(4 downto 0);
    switches: in std_logic_vector(15 downto 0));
    end basicIO_controller;

architecture Behavioral of basicIO_controller is

    component Debouncer Port(
        clk: in std_logic;
        signal_in: in std_logic;
        signal_out: out std_logic);
        end component;
    signal d_btn: std_logic_vector(4 downto 0);

    component Display_Controller Port(  
        dis_a: in std_logic_vector(3 downto 0);
        dis_b: in std_logic_vector(3 downto 0);
        dis_c: in std_logic_vector(3 downto 0);
        dis_d: in std_logic_vector(3 downto 0);
        clk: in std_logic;
        seg: out std_logic_vector(7 downto 0);
        an: out std_logic_vector(3 downto 0));
        end component;
    signal dis_a: std_logic_vector(3 downto 0);
    signal dis_b: std_logic_vector(3 downto 0);
    signal dis_c: std_logic_vector(3 downto 0);
    signal dis_d: std_logic_vector(3 downto 0);

    component muxINPUT is Port(
        ram_addrs: in std_logic_vector(11 downto 0);
        ram_output: in std_logic_vector(15 downto 0);
        timer_sec: in std_logic_vector(15 downto 0);
        timer_mil: in std_logic_vector(15 downto 0);
        timer_mic: in std_logic_vector(15 downto 0);
        direc_btn: in std_logic_vector(4 downto 0);
        direc_sw: in std_logic_vector(15 downto 0);
        out_bus: out std_logic_vector(15 downto 0));
        end component;

    component Reg is Port(
        clock: in std_logic;
        clear: in  std_logic;
        load: in  std_logic;
        up: in  std_logic;
        down: in  std_logic;
        datain: in  std_logic_vector (15 downto 0);
        dataout: out std_logic_vector (15 downto 0));
        end component;
    signal dis: std_logic_vector(15 downto 0);
    
    component demuxOUTPUT is Port(
        write_ram: in std_logic;
        ram_addrs: in std_logic_vector(11 downto 0);
        write_regDis: out std_logic;
        write_regLed: out std_logic);
        end component;
    signal write_reg_dis: std_logic;
    signal write_reg_led: std_logic;

    component Timer is Port(
        clk: in std_logic;
        clear: in std_logic;
        seconds: out std_logic_vector(15 downto 0);
        mseconds: out std_logic_vector(15 downto 0);
        useconds: out std_logic_vector(15 downto 0));
        end component;
    signal timer_secon: std_logic_vector(15 downto 0);
    signal timer_milis: std_logic_vector(15 downto 0);
    signal timer_useco: std_logic_vector(15 downto 0);

begin

dis_a  <= dis(15 downto 12);
dis_b  <= dis(11 downto 8);
dis_c  <= dis(7 downto 4);
dis_d  <= dis(3 downto 0);

btn_central: Debouncer port map(clk=>sped_clock, signal_in=>buttons(0), signal_out=>d_btn(0));
btn_top: Debouncer port map(clk=>sped_clock, signal_in=>buttons(1), signal_out=>d_btn(1));
btn_left: Debouncer port map(clk=>sped_clock, signal_in=>buttons(2), signal_out=>d_btn(2));
btn_right: Debouncer port map(clk=>sped_clock, signal_in=>buttons(3), signal_out=>d_btn(3));
btn_bottom: Debouncer port map(clk=>sped_clock, signal_in=>buttons(4), signal_out=>d_btn(4));

inst_timer: Timer port map(
clk     => sped_clock,
clear   => cleanse,
seconds => timer_secon,
mseconds=> timer_milis,
useconds=> timer_useco
);

inst_Display_Controller: Display_Controller port map(
    dis_a       => dis_a,                   -- No Tocar - Entrada de se�ales para el display A.
    dis_b       => dis_b,                   -- No Tocar - Entrada de se�ales para el display B.
    dis_c       => dis_c,                   -- No Tocar - Entrada de se�ales para el display C.
    dis_d       => dis_d,                   -- No Tocar - Entrada de se�ales para el display D.
    clk         => sped_clock,                     -- No Tocar - Entrada del clock completo (100Mhz).
    seg         => displays_segments,                     -- No Tocar - Salida de las se�ales de segmentos.
    an          => displays_selector                       -- No Tocar - Salida del selector de diplay.
	);

inst_regDis: Reg port map(
clock   => smol_clock,
clear   => cleanse,
load    => write_reg_dis,
up      => '0',
down    => '0',
datain  => data_to_ram,
dataout => dis
);

inst_regLed: Reg port map(
clock   => smol_clock,
clear   => cleanse,
load    => write_reg_led,
up      => '0',
down    => '0',
datain  => data_to_ram,
dataout => leds
);

inst_demuxoutput: demuxOUTPUT port map(
write_ram   => write_to_ram,
ram_addrs   => ram_pointer,
write_regDis=> write_reg_dis,
write_regLed=> write_reg_led
);

inst_muxinput: muxINPUT port map(
ram_addrs   => ram_pointer,
ram_output  => data_from_ram,
timer_sec   => timer_secon,
timer_mil   => timer_milis,
timer_mic   => timer_useco,
direc_btn   => d_btn,
direc_sw    => switches,
out_bus     => data_to_cpu
);

end Behavioral;
