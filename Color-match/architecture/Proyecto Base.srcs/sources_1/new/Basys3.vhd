library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Basys3 is
    Port (
        sw          : in   std_logic_vector (15 downto 0); -- No Tocar - Se�ales de entrada de los interruptores -- Arriba   = '1'   -- Los 16 swiches.
        btn         : in   std_logic_vector (4 downto 0);  -- No Tocar - Se�ales de entrada de los botones       -- Apretado = '1'   -- 0 central, 1 arriba, 2 izquierda, 3 derecha y 4 abajo.
        led         : out  std_logic_vector (15 downto 0); -- No Tocar - Se�ales de salida  a  los leds          -- Prendido = '1'   -- Los 16 leds.
        clk         : in   std_logic;                      -- No Tocar - Se�al de entrada del clock              -- 100Mhz.
        seg         : out  std_logic_vector (7 downto 0);  -- No Tocar - Salida de las se�ales de segmentos.
        an          : out  std_logic_vector (3 downto 0);  -- No Tocar - Salida del selector de diplay.
        tx          : out  std_logic;                      -- No Tocar - Se�al de salida para UART Tx.
        rx          : in   std_logic;                       -- No Tocar - Se�al de entrada para UART Rx.
        -- vamos a jugarnos la vida cierto? :D xdn't
        vgaRed      : out std_logic_vector(3 downto 0);
        vgaBlue     : out std_logic_vector(3 downto 0);
        vgaGreen    : out std_logic_vector(3 downto 0);
        Hsync       : out std_logic;
        Vsync       : out std_logic
          );
end Basys3;

architecture Behavioral of Basys3 is

-- Inicio de la declaraci�n de los componentes.

component Clock_Divider -- No Tocar
    Port (
        clk         : in    std_logic;
        speed       : in    std_logic_vector (1 downto 0);
        clock       : out   std_logic
          );
    end component;
    
component Display_Controller -- No Tocar
    Port (  
        dis_a       : in    std_logic_vector (3 downto 0);
        dis_b       : in    std_logic_vector (3 downto 0);
        dis_c       : in    std_logic_vector (3 downto 0);
        dis_d       : in    std_logic_vector (3 downto 0);
        clk         : in    std_logic;
        seg         : out   std_logic_vector (7 downto 0);
        an          : out   std_logic_vector (3 downto 0)
          );
    end component;
    
component Debouncer -- No Tocar
    Port (
        clk         : in    std_logic;
        signal_in      : in    std_logic;
        signal_out     : out   std_logic
          );
    end component;
            
component ROM -- No Tocar
    Port (
        clk         : in    std_logic;
        write       : in    std_logic;
        disable     : in    std_logic;
        address     : in    std_logic_vector (11 downto 0);
        dataout     : out   std_logic_vector (35 downto 0);
        datain      : in    std_logic_vector(35 downto 0)
          );
    end component;

component RAM -- No Tocar
    Port (  
        clock       : in    std_logic;
        write       : in    std_logic;
        address     : in    std_logic_vector (11 downto 0);
        datain      : in    std_logic_vector (15 downto 0);
        dataout     : out   std_logic_vector (15 downto 0)
          );
    end component;
    
component Programmer -- No Tocar
    Port (
        rx          : in    std_logic;
        tx          : out   std_logic;
        clk         : in    std_logic;
        clock       : in    std_logic;
        bussy       : out   std_logic;
        ready       : out   std_logic;
        address     : out   std_logic_vector(11 downto 0);
        dataout     : out   std_logic_vector(35 downto 0)
        );
    end component;
    
component CPU is
    Port (
           clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           ram_address : out STD_LOGIC_VECTOR (11 downto 0);
           ram_datain : out STD_LOGIC_VECTOR (15 downto 0);
           ram_dataout : in STD_LOGIC_VECTOR (15 downto 0);
           ram_write : out STD_LOGIC;
           rom_address : out STD_LOGIC_VECTOR (11 downto 0);
           rom_dataout : in STD_LOGIC_VECTOR (35 downto 0)
           --reiniciar : in STD_LOGIC
    ); end component;

component muxINPUT is
    Port ( ram_addrs : in STD_LOGIC_VECTOR (11 downto 0);
           ram_output : in STD_LOGIC_VECTOR (15 downto 0);
           timer_sec : in STD_LOGIC_VECTOR (15 downto 0);
           timer_mil : in STD_LOGIC_VECTOR (15 downto 0);
           timer_mic : in STD_LOGIC_VECTOR (15 downto 0);
           direc_btn : in STD_LOGIC_VECTOR (4 downto 0);
           direc_sw : in STD_LOGIC_VECTOR (15 downto 0);
           out_bus : out STD_LOGIC_VECTOR (15 downto 0)
           );
end component;

component Timer is
    Port ( clk : in STD_LOGIC;
           clear   : in STD_LOGIC;
           seconds : out STD_LOGIC_VECTOR (15 downto 0);
           mseconds: out STD_LOGIC_VECTOR (15 downto 0);
           useconds: out STD_LOGIC_VECTOR (15 downto 0));
           
end component;

component Reg is
    Port ( clock    : in  std_logic;                        -- Se�al del clock (reducido).
           clear    : in  std_logic;                        -- Se�al de reset.
           load     : in  std_logic;                        -- Se�al de carga.
           up       : in  std_logic;                        -- Se�al de subida.
           down     : in  std_logic;                        -- Se�al de bajada.
           datain   : in  std_logic_vector (15 downto 0);   -- Se�ales de entrada de datos.
           dataout  : out std_logic_vector (15 downto 0)   -- Se�ales de salida de datos.
); end component;

component demuxOUTPUT is
    Port ( write_ram : in STD_LOGIC;
           ram_addrs : in STD_LOGIC_VECTOR (11 downto 0);
           write_regDis : out STD_LOGIC;
           write_regLed : out STD_LOGIC);
end component;

component Xelor is
    Port ( clock : in std_logic;
           h_sync : out std_logic;
           v_sync : out std_logic;
           en_display_area: out std_logic;
           pafuera_vcount: out integer;
           pafuera_hcount: out integer);
end component;

component reg_adivinanzas is
    Port ( clock    : in  std_logic;                        -- Se�al del clock (reducido).
           clear    : in  std_logic;                        -- Se�al de reset.
           load     : in  std_logic;                        -- Se�al de carga.
           up       : in  std_logic;                        -- Se�al de subida.
           down     : in  std_logic;                        -- Se�al de bajada.
           datain   : in  std_logic_vector (15 downto 0);   -- Se�ales de entrada de datos.
           dataout  : out std_logic_vector (15 downto 0)   -- Se�ales de salida de datos.
       ); end component;

component demux_adivinanza is
    Port ( write_ram : in std_logic;
           ram_addrs : in std_logic_vector (11 downto 0);
           write_reg_xadiv : out STD_LOGIC;
           write_reg_currt : out STD_LOGIC);
end component;

component GTX1050 is
  Port (
        clock: in std_logic;
        h_sync: in integer;
        y_sync: in integer;
        reg_xadiv: in std_logic_vector(15 downto 0);
        reg_currt: in std_logic_vector(15 downto 0);
        color_out: out std_logic_vector(11 downto 0)
   );
end component;

-- Fase1 aumentada
component clk_wiz_0 is
Port (
full_clk: in std_logic;
reset: in std_logic;
pixel_clock: out std_logic;
pixel_clock_locked: out std_logic
); end component;

-- Fin de la declaraci�n de los componentes.

-- Inicio de la declaraci�n de se�ales.

signal clock            : std_logic;                     -- Se�al del clock reducido.
            
signal dis_a            : std_logic_vector(3 downto 0);  -- Se�ales de salida al display A.    
signal dis_b            : std_logic_vector(3 downto 0);  -- Se�ales de salida al display B.     
signal dis_c            : std_logic_vector(3 downto 0);  -- Se�ales de salida al display C.    
signal dis_d            : std_logic_vector(3 downto 0);  -- Se�ales de salida al display D.

signal dis              : std_logic_vector(15 downto 0); -- Se�ales de salida totalidad de los displays.

signal d_btn            : std_logic_vector(4 downto 0);  -- Se�ales de botones con anti-rebote.

signal write_rom        : std_logic;                     -- Se�al de escritura de la ROM.
signal pro_address      : std_logic_vector(11 downto 0); -- Se�ales del direccionamiento de programaci�n de la ROM.
signal rom_datain       : std_logic_vector(35 downto 0); -- Se�ales de la palabra a programar en la ROM.

signal clear            : std_logic;                     -- Se�al de limpieza de registros durante la programaci�n.

signal cpu_rom_address  : std_logic_vector(11 downto 0); -- Se�ales del direccionamiento de lectura de la ROM.
signal rom_address      : std_logic_vector(11 downto 0); -- Se�ales del direccionamiento de la ROM.
signal rom_dataout      : std_logic_vector(35 downto 0); -- Se�ales de la palabra de salida de la ROM.

signal write_ram        : std_logic;                     -- Se�al de escritura de la RAM.
signal ram_address      : std_logic_vector(11 downto 0); -- Se�ales del direccionamiento de la RAM.
signal ram_datain       : std_logic_vector(15 downto 0); -- Se�ales de la palabra de entrada de la RAM.
signal ram_dataout      : std_logic_vector(15 downto 0); -- Se�ales de la palabra de salida de la RAM.

signal timer_secon      : std_logic_vector(15 downto 0);
signal timer_milis      : std_logic_vector(15 downto 0);
signal timer_useco      : std_logic_vector(15 downto 0);
signal salida_muxinput  : std_logic_vector(15 downto 0);
signal write_reg_dis    : std_logic;
signal write_reg_led    : std_logic;

signal sincro_h         : std_logic;
signal sincro_v         : std_logic;
signal enable_rgb       : std_logic;

signal from_ram_vga_color : std_logic_vector (15 downto 0);
signal from_ram_vga_addrs : std_logic_vector (15 downto 0);
signal from_ram_vga_selector : std_logic_vector (15 downto 0);

signal from_vram_vga_color : std_logic_vector (6 downto 0);
signal paint_color : std_logic;

-- FASE 1
signal load_reg_xadiv : std_logic;
signal load_reg_currt : std_logic;
signal salida_reg_xadiv : std_logic_vector(15 downto 0);
signal salida_reg_currt : std_logic_vector(15 downto 0);
signal salida_color_gpu : std_logic_vector(11 downto 0);
signal ignorar_switch_malo : std_logic_vector(11 downto 0);
-- Fin de la declaraci�n de los señales.

-- Fase1 aumentada
signal xelor_IP: std_logic;
signal xelor_IP_locked: std_logic;
signal v_pos: integer;
signal h_pos: integer;

begin

dis_a  <= dis(15 downto 12);
dis_b  <= dis(11 downto 8);
dis_c  <= dis(7 downto 4);
dis_d  <= dis(3 downto 0);
                    
-- Muxer del address de la ROM.          
with clear select
    rom_address <= cpu_rom_address when '0',
                   pro_address when '1';
                   
-- Inicio de declaraci�n de instancias.



-- Instancia de la memoria RAM.
inst_ROM: ROM port map(
    clk         => clk,
    disable     => clear,
    write       => write_rom,
    address     => rom_address,
    dataout     => rom_dataout,
    datain      => rom_datain
    );

-- Instancia de la memoria ROM.
inst_RAM: RAM port map(
    clock       => clock,
    write       => write_ram,
    address     => ram_address,
    datain      => ram_datain,
    dataout     => ram_dataout
    );
    
 -- Intancia del divisor de la se�al del clock.
inst_Clock_Divider: Clock_Divider port map(
    speed       => "00",                    -- Selector de velocidad: "00" full, "01" fast, "10" normal y "11" slow. 
    clk         => clk,                     -- No Tocar - Entrada de la se�al del clock completo (100Mhz).
    clock       => clock                    -- No Tocar - Salida de la se�al del clock reducido: 25Mhz, 8hz, 2hz y 0.5hz.
    );

inst_MyXelor: clk_wiz_0 port map(
    reset               => clear,
    full_clk            => clk,
    pixel_clock         => xelor_IP,
    pixel_clock_locked  => xelor_IP_locked
);

 -- No Tocar - Intancia del controlador de los displays de 8 segmentos.    
inst_Display_Controller: Display_Controller port map(
    dis_a       => dis_a,                   -- No Tocar - Entrada de se�ales para el display A.
    dis_b       => dis_b,                   -- No Tocar - Entrada de se�ales para el display B.
    dis_c       => dis_c,                   -- No Tocar - Entrada de se�ales para el display C.
    dis_d       => dis_d,                   -- No Tocar - Entrada de se�ales para el display D.
    clk         => clk,                     -- No Tocar - Entrada del clock completo (100Mhz).
    seg         => seg,                     -- No Tocar - Salida de las se�ales de segmentos.
    an          => an                       -- No Tocar - Salida del selector de diplay.
	);
    
-- No Tocar - Intancias de los Debouncers.    
inst_Debouncer0: Debouncer port map( clk => clk, signal_in => btn(0), signal_out => d_btn(0) );
inst_Debouncer1: Debouncer port map( clk => clk, signal_in => btn(1), signal_out => d_btn(1) );
inst_Debouncer2: Debouncer port map( clk => clk, signal_in => btn(2), signal_out => d_btn(2) );
inst_Debouncer3: Debouncer port map( clk => clk, signal_in => btn(3), signal_out => d_btn(3) );
inst_Debouncer4: Debouncer port map( clk => clk, signal_in => btn(4), signal_out => d_btn(4) );

-- No Tocar - Intancia del ROM Programmer.           
inst_Programmer: Programmer port map(
    rx          => rx,                      -- No Tocar - Salida de la se�al de transmici�n.
    tx          => tx,                      -- No Tocar - Entrada de la se�al de recepci�n.
    clk         => clk,                     -- No Tocar - Entrada del clock completo (100Mhz).
    clock       => clock,                   -- No Tocar - Entrada del clock reducido.
    bussy       => clear,                   -- No Tocar - Salida de la se�al de programaci�n.
    ready       => write_rom,               -- No Tocar - Salida de la se�al de escritura de la ROM.
    address     => pro_address(11 downto 0),-- No Tocar - Salida de se�ales del address de la ROM.
    dataout     => rom_datain               -- No Tocar - Salida de se�ales palabra de entrada de la ROM.
        );
        
-- Instancia de la CPU.        
inst_CPU: CPU port map(
    clock       => clock,
    clear       => clear,
    ram_address => ram_address,
    ram_datain  => ram_datain,
    ram_dataout => salida_muxinput,
    ram_write   => write_ram,
    rom_address => cpu_rom_address,
    rom_dataout => rom_dataout
    --reiniciar	=> d_btn(0)
    );

inst_muxinput: muxINPUT port map(
ram_addrs   => ram_address,
ram_output  => ram_dataout,
timer_sec   => timer_secon,
timer_mil   => timer_milis,
timer_mic   => timer_useco,
direc_btn   => d_btn,
direc_sw    => sw,
out_bus     => salida_muxinput
);

inst_timer: Timer port map(
clk     => clk,
clear   => clear,
seconds => timer_secon,
mseconds=> timer_milis,
useconds=> timer_useco
);

inst_regDis: Reg port map(
clock   => clock,
clear   => clear,
load    => write_reg_dis,
up      => '0',
down    => '0',
datain  => ram_datain,
dataout => dis
);

inst_regLed: Reg port map(
clock   => clock,
clear   => clear,
load    => write_reg_led,
up      => '0',
down    => '0',
datain  => ram_datain,
dataout => led
);

inst_demuxoutput: demuxOUTPUT port map(
write_ram   => write_ram,
ram_addrs   => ram_address,
write_regDis=> write_reg_dis,
write_regLed=> write_reg_led
);

inst_xelor: Xelor port map(
clock => clock,
h_sync => sincro_h,
v_sync => sincro_v,
en_display_area => enable_rgb,
pafuera_vcount => v_pos,
pafuera_hcount => h_pos
);

Hsync <= sincro_h;
Vsync <= sincro_v;

-- Necesitamos un componente que identifique los bloques de la pantalla
-- y elija output a partir de ello
-- A partir de aqui comienza la fase 1

--signal load_reg_xadiv : std_logic;
--signal load_reg_currt : std_logic;
--signal salida_reg_xadiv : std_logic_vector(11 downto 0);
--signal salida_reg_currt : std_logic_vector(11 downto 0);
--signal salida_color_gpu : std_logic_vector(11 downto 0);

-- Esta señal de conexion la agregamos porque uno de los switches esta malo
--signal ignorar_switch_malo : std_logic_vector(11 downto 0);


inst_reg_xadiv: reg_adivinanzas port map(
clock => clock,
clear => clear,
load => load_reg_xadiv,
up => '0',
down => '0',
datain => ram_datain,
dataout => salida_reg_xadiv
);

inst_reg_currt: reg_adivinanzas port map(
clock => clock,
clear => clear,
load => load_reg_currt,
up => '0',
down => '0',
datain => ram_datain,
dataout => salida_reg_currt
);

inst_demux_adivinanzas: demux_adivinanza port map(
write_ram => write_ram,
ram_addrs => ram_address,
write_reg_xadiv => load_reg_xadiv,
write_reg_currt => load_reg_currt
);

inst_gtx1050: GTX1050 port map(
clock => clock,
h_sync => v_pos,
y_sync => h_pos,
reg_xadiv => salida_reg_xadiv,
reg_currt => salida_reg_currt,
color_out => salida_color_gpu
);

with enable_rgb select
    vgaRed <= salida_color_gpu(11 downto 8) when '1',
              (others => '0') when others;
              
with enable_rgb select
    vgaGreen <= salida_color_gpu(7 downto 4) when '1',
                (others => '0') when others;              

with enable_rgb select
    vgaBlue <= salida_color_gpu(3 downto 0) when '1',
               (others => '0') when others;

--RTX4080S: GPU port map (
--clock => clock,
--write_into_block => paint_color,
--write_block_selector => from_ram_vga_selector(2 downto 0),
--color_in => from_ram_vga_color(6 downto 0),
--write_addrs => from_ram_vga_addrs,
--color_out => from_vram_vga_color,
--on_display => enable_rgb
--);

--vgaRed <= "001" & from_vram_vga_color(6);
--vgaGreen <= from_vram_vga_color(5 downto 3) & '1';
--vgaBlue <= from_vram_vga_color(2 downto 0) & '0';

end Behavioral;
