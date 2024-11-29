library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Basys3 is Port(
    sw: in std_logic_vector(15 downto 0);
    btn: in std_logic_vector(4 downto 0);
    led: out std_logic_vector(15 downto 0);
    clk: in std_logic;
    seg: out std_logic_vector(7 downto 0);
    an: out std_logic_vector(3 downto 0);
    tx: out std_logic;
    rx: in std_logic;
    vgaRed: out std_logic_vector(3 downto 0);
    vgaBlue: out std_logic_vector(3 downto 0);
    vgaGreen: out std_logic_vector(3 downto 0);
    Hsync: out std_logic;
    Vsync: out std_logic);
    end Basys3;

architecture Behavioral of Basys3 is

    component Clock_Divider Port(
        clk: in std_logic;
        speed: in std_logic_vector(1 downto 0);
        clock: out std_logic);
        end component;
    
    component ROM Port(
        clk: in std_logic;
        write: in std_logic;
        disable: in std_logic;
        address: in std_logic_vector(11 downto 0);
        dataout: out std_logic_vector(35 downto 0);
        datain: in std_logic_vector(35 downto 0));
        end component;

    component RAM Port(  
        clock: in std_logic;
        write: in std_logic;
        address: in std_logic_vector(11 downto 0);
        datain: in std_logic_vector(15 downto 0);
        dataout: out std_logic_vector(15 downto 0));
        end component;
    
    component Programmer Port(
        rx: in std_logic;
        tx: out std_logic;
        clk: in std_logic;
        clock: in std_logic;
        bussy: out std_logic;
        ready: out std_logic;
        address: out std_logic_vector(11 downto 0);
        dataout: out std_logic_vector(35 downto 0));
        end component;
    
    component CPU is Port(
        clock: in std_logic;
        clear: in std_logic;
        ram_address: out std_logic_vector(11 downto 0);
        ram_datain: out std_logic_vector(15 downto 0);
        ram_dataout: in std_logic_vector(15 downto 0);
        ram_write: out std_logic;
        rom_address: out std_logic_vector(11 downto 0);
        rom_dataout: in std_logic_vector(35 downto 0));
        end component;
    
    component basicIO_controller is Port(
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
        end component;
        
    component RTX2060 is Port(
        smol_clock: in std_logic;
        full_clock: in std_logic;
        horizontal_syncro: out std_logic;
        vertical_syncro: out std_logic;
        red_vector: out std_logic_vector(3 downto 0);
        green_vector: out std_logic_vector(3 downto 0);
        blue_vector: out std_logic_vector(3 downto 0));
        end component;
    
    signal clock: std_logic;
    signal write_rom: std_logic;
    signal pro_address: std_logic_vector(11 downto 0);
    signal rom_datain: std_logic_vector(35 downto 0);
    signal clear: std_logic;
    signal cpu_rom_address: std_logic_vector(11 downto 0);
    signal rom_address: std_logic_vector(11 downto 0);
    signal rom_dataout: std_logic_vector(35 downto 0);
    signal write_ram: std_logic;
    signal ram_address: std_logic_vector(11 downto 0);
    signal ram_datain: std_logic_vector(15 downto 0);
    signal ram_dataout: std_logic_vector(15 downto 0);
    signal io_to_cpu: std_logic_vector(15 downto 0);

begin
                    
    with clear select rom_address <=
        cpu_rom_address when '0',
        pro_address when '1';
                   
    basys3_LUT_ROM: ROM port map(
        clk=>clk,
        disable=>clear,
        write=>write_rom,
        address=>rom_address,
        dataout=>rom_dataout,
        datain=>rom_datain);

    basys3_LUT_RAM: RAM port map(
        clock=>clock,
        write=>write_ram,
        address=>ram_address,
        datain=>ram_datain,
        dataout=>ram_dataout);
    
    basys3_Clock_Divider: Clock_Divider port map(
        speed=>"00", 
        clk=>clk,
        clock=>clock);

    basys3_Programmer: Programmer port map(
        rx=>rx,
        tx=>tx,
        clk=>clk,
        clock=>clock,
        bussy=>clear,
        ready=>write_rom,
        address=>pro_address(11 downto 0),
        dataout=>rom_datain);
        
    basys3_CPU: CPU port map(
        clock=>clock,
        clear=>clear,
        ram_address=>ram_address,
        ram_datain=>ram_datain,
        ram_dataout=>io_to_cpu,
        ram_write=>write_ram,
        rom_address=>cpu_rom_address,
        rom_dataout=>rom_dataout);
        
    basys3_basicIO: basicIO_controller port map(
        data_to_cpu=>io_to_cpu,
        ram_pointer=>ram_address,
        data_to_ram=>ram_datain,
        data_from_ram=>ram_dataout,
        write_to_ram=>write_ram,
        cleanse=>clear,
        smol_clock=>clock,
        sped_clock=>clk,
        displays_selector=>an,
        displays_segments=>seg,
        leds=>led,
        buttons=>btn,
        switches=>sw);
        
    basys3_rtx2060: RTX2060 port map(
        smol_clock=>clock,
        full_clock=>clk,
        horizontal_syncro=>Hsync,
        vertical_syncro=>Vsync,
        red_vector=>vgaRed,
        green_vector=>vgaGreen,
        blue_vector=>vgaBlue);

end Behavioral;
