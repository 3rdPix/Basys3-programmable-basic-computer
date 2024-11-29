library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;


entity CPU is
    Port (
           clock : in STD_LOGIC;
           clear : in STD_LOGIC;
           rom_dataout : in STD_LOGIC_VECTOR (35 downto 0);
           ram_dataout : in STD_LOGIC_VECTOR (15 downto 0);
 	       --reiniciar	: in STD_LOGIC;
	       ram_address : out STD_LOGIC_VECTOR (11 downto 0);
	       ram_datain : out STD_LOGIC_VECTOR (15 downto 0);
	       ram_write : out STD_LOGIC;
           rom_address : out STD_LOGIC_VECTOR (11 downto 0)
           );
end CPU;

architecture Behavioral of CPU is

component RegContPC is
    Port ( clock    : in  std_logic;                        -- Se�al del clock (reducido).
           clear    : in  std_logic;                        -- Se�al de reset.
           load     : in  std_logic;                        -- Se�al de carga.
           up       : in  std_logic;                        -- Se�al de subida.
           down     : in  std_logic;                        -- Se�al de bajada.
           datain   : in  std_logic_vector (11 downto 0);   -- Se�ales de entrada de datos.
           dataout  : out std_logic_vector (11 downto 0)  -- Se�ales de salida de datos.
); end component;

component ALU is
    Port ( a        : in  std_logic_vector (15 downto 0);   -- Primer operando. /pasa de 7 a 15 para los 16 bits
           b        : in  std_logic_vector (15 downto 0);   -- Segundo operando. /pasa de 7 a 15 para los 16 bits
           sop      : in  std_logic_vector (2 downto 0);   -- Selector de la operaci�n.
           c        : out std_logic;                       -- Se�al de 'carry'.
           z        : out std_logic;                       -- Se�al de 'zero'.
           n        : out std_logic;                       -- Se�al de 'nagative'.
           result   : out std_logic_vector (15 downto 0));  -- Resultado de la operaci�n. /pasa de 7 a 15 para los 16 bits
end component;

component Multiplexor is
    Port ( E0 : in STD_LOGIC_VECTOR (15 downto 0);
           E1 : in STD_LOGIC_VECTOR (15 downto 0);
	       E2 : in STD_LOGIC_VECTOR (15 downto 0);
	       E3: in STD_LOGIC_VECTOR (15 downto 0);
           Selector : in STD_LOGIC_VECTOR (1 downto 0);
           Salida : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component RegStatus is
    Port ( clock    : in  std_logic;                        -- Se�al del clock (reducido).
           clear    : in  std_logic;                        -- Se�al de reset.
           load     : in  std_logic;                        -- Se�al de carga.
	       up       : in  std_logic;
	       down	    : in  std_logic;
           c        : in  std_logic; --c,n y z vienen de la AlU
           z        : in  std_logic;
           n        : in  std_logic;
           salida   : out std_logic_vector (2 downto 0));
end component;

component CU is
    Port ( opcode : in STD_LOGIC_VECTOR (19 downto 0);
           status : in STD_LOGIC_VECTOR (2 downto 0);
           enableA : out STD_LOGIC;
           enableB : out STD_LOGIC;
           selectorA : out STD_LOGIC_VECTOR (1 downto 0);
           selectorB : out STD_LOGIC_VECTOR (1 downto 0);
           loadPC : out STD_LOGIC;
           selectorALU : out STD_LOGIC_VECTOR (2 downto 0);
           writeRAM : out STD_LOGIC;
           selectorAddrs : out STD_LOGIC_VECTOR (1 downto 0);
	       increaseSP : out STD_LOGIC;
	       decreaseSP : out STD_LOGIC;
	       selectorPC : out STD_LOGIC;
	       selectorData : out STD_LOGIC);
end component;

component Reg is
    Port ( clock    : in  std_logic;                        -- Se�al del clock (reducido).
           clear    : in  std_logic;                        -- Se�al de reset.
           load     : in  std_logic;                        -- Se�al de carga.
           up       : in  std_logic;                        -- Se�al de subida.
           down     : in  std_logic;                        -- Se�al de bajada.
           datain   : in  std_logic_vector (15 downto 0);   -- Se�ales de entrada de datos.
           dataout  : out std_logic_vector (15 downto 0));  -- Se�ales de salida de datos.
end component;

component MuxData is
    Port ( fromAdder_in : in STD_LOGIC_VECTOR (11 downto 0);
           fromALU_in : in STD_LOGIC_VECTOR (15 downto 0);
           Selector : in STD_LOGIC;
           Salida : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component AdderDataIn is
    Port ( addrs_in : in STD_LOGIC_VECTOR (11 downto 0);
           bus_1 : in STD_LOGIC_VECTOR (11 downto 0);
           result : out STD_LOGIC_VECTOR (11 downto 0));
end component;

component RegSP is
    Port ( clock    : in  std_logic;                        -- Se�al del clock (reducido).
           clear    : in  std_logic;
           up       : in  std_logic;                        -- Se�al de subida.
           down     : in  std_logic;                        -- Se�al de bajada.
           dataout  : out std_logic_vector (11 downto 0)   -- Se�ales de salida de datos.
); end component;

component MuxAddrs is
    Port ( stack_pointer : in STD_LOGIC_VECTOR (11 downto 0);
           lit_from_rom : in STD_LOGIC_VECTOR (11 downto 0);
	       from_regB : in STD_LOGIC_VECTOR (11 downto 0);
	       E3: in STD_LOGIC_VECTOR (11 downto 0);
           Selector : in STD_LOGIC_VECTOR (1 downto 0);
           Salida : out STD_LOGIC_VECTOR (11 downto 0));
end component;

component MuxPC is
    Port ( lit_from_ram: in STD_LOGIC_VECTOR (11 downto 0);
           lit_from_rom : in STD_LOGIC_VECTOR (11 downto 0);
           Selector : in STD_LOGIC;
           Salida : out STD_LOGIC_VECTOR (11 downto 0));
end component;

-- señales intermedias propias
signal clock_intermedio	:	std_logic;
signal op_code		:	std_logic_vector (19 downto 0);
signal op_literal	:	std_logic_vector (15 downto 0);
signal puntero_rom  :   std_logic_vector (11 downto 0);

-- señales de los registros
signal salida_regA	:	std_logic_vector (15 downto 0);
signal salida_regB	:	std_logic_vector (15 downto 0);

-- señales de los muxer
signal salida_muxA	:	std_logic_vector (15 downto 0);
signal salida_muxB	:	std_logic_vector (15 downto 0);

-- señales de la unidad de control CU
signal load_regA	:	std_logic;
signal load_regB	:	std_logic;
signal selector_muxA	:	std_logic_vector (1 downto 0);
signal selector_muxB	:	std_logic_vector (1 downto 0);
signal load_PC		:	std_logic;
signal selector_ALU	:	std_logic_vector (2 downto 0);
signal load_RAM		:	std_logic;

-- señales de la ALU
signal result_alu	:	std_logic_vector (15 downto 0);
signal result_alu_c	:	std_logic;
signal result_alu_z	:	std_logic;
signal result_alu_n	:	std_logic;

-- señal del registro de estado
signal status_vector	:	std_logic_vector (2 downto 0);

-- señales entrega 2
signal salida_muxPC : std_logic_vector (11 downto 0);
signal selector_Addrs : std_logic_vector (1 downto 0);
signal increase_SP : std_logic;
signal decrease_SP : std_logic;
signal selector_PC : std_logic;
signal selector_Data : std_logic;
signal salida_AdderData : std_logic_vector (11 downto 0);
signal salida_stack_pointer : std_logic_vector (11 downto 0);
signal salida_muxAddrs : std_logic_vector (11 downto 0);
signal salida_muxData : std_logic_vector (15 downto 0);

begin

-- establecimiento señales básicas propias
clock_intermedio <= clock;
op_code <= rom_dataout(19 downto 0);
op_literal <= rom_dataout(35 downto 20);

-- creación instancias
instancia_PC: RegContPC port map(
clock => clock_intermedio,
clear => clear,
load => load_PC,
up => '1',
down => '0',
datain => salida_muxPC,
dataout => puntero_rom
);

instancia_regA: Reg port map(
clock 	=> clock_intermedio,
clear 	=> clear,
load 	=> load_regA,
up 	=> '0',
down 	=> '0',
datain 	=> result_alu,
dataout => salida_regA
);

instancia_regB: Reg port map(
clock 	=> clock_intermedio,
clear 	=> clear,
load 	=> load_regB,
up 	=> '0',
down 	=> '0',
datain 	=> result_alu,
dataout => salida_regB
);

instancia_ALU: ALU port map(
a	=> salida_muxA,
b	=> salida_muxB,
sop	=> selector_ALU,
c	=> result_alu_c,
z	=> result_alu_z,
n	=> result_alu_n,
result	=> result_alu
);

instancia_muxA: Multiplexor port map(
Selector=> selector_muxA,
Salida	=> salida_muxA,
E0	=> salida_regA,
E1	=> "0000000000000000",
E2	=> "0000000000000001",
-- Para el muxer A no hay entrada 3, ni se usa, ponemos 0
E3	=> "0000000000000000"
);

instancia_muxB: Multiplexor port map(
Selector=> selector_muxB,
Salida 	=> salida_muxB,
E0	=> salida_regB,
E1	=> ram_dataout,
E2	=> op_literal,
E3	=> "0000000000000000"
);

instancia_CU: CU port map(
opcode	=> op_code,
status	=> status_vector,
enableA	=> load_regA,
enableB	=> load_regB,
selectorA => selector_muxA,
selectorB => selector_muxB,
loadPC	=> load_PC,
selectorALU => selector_ALU,
writeRAM => load_RAM,
selectorAddrs => selector_Addrs,
increaseSP => increase_SP,
decreaseSP => decrease_SP,
selectorPC => selector_PC,
selectorData => selector_Data
);

instancia_regStatus: RegStatus port map(
clock	=> clock_intermedio,
clear	=> '0',
load	=> '1',
up	=> '0',
down	=> '0',
c	=> result_alu_c,
z	=> result_alu_z,
n	=> result_alu_n,
salida	=> status_vector
);

-- Entrega 2
instancia_adderData: AdderDatain port map(
addrs_in => puntero_rom,
bus_1 => "000000000001",
result => salida_AdderData
);

instancia_sp: RegSP port map(
clock => clock_intermedio,
clear => clear,
up => increase_SP,
down => decrease_SP,
dataout => salida_stack_pointer
);

instancia_muxAddrs: MuxAddrs port map(
stack_pointer => salida_stack_pointer,
lit_from_rom => op_literal(11 downto 0),
from_regB => salida_regB(11 downto 0),
E3 => (others => '0'),
Selector => selector_Addrs,
Salida => salida_muxAddrs
);

instancia_muxPC: MuxPC port map(
lit_from_ram => ram_dataout(11 downto 0),
lit_from_rom => op_literal(11 downto 0),
Selector => selector_PC,
Salida => salida_muxPC
);

instancia_muxdata: MuxData port map(
fromAdder_in => salida_AdderData,
fromALU_in => result_alu,
Selector => selector_Data,
Salida => salida_muxData
);


ram_address <= salida_muxAddrs;
ram_datain <= salida_muxData;
ram_write <= load_RAM;
rom_address <= puntero_rom;

end Behavioral;
