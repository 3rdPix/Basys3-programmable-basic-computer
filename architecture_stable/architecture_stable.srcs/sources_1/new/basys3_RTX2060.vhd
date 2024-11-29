library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RTX2060 is Port(
    smol_clock: in std_logic;
    full_clock: in std_logic;
    horizontal_syncro: out std_logic;
    vertical_syncro: out std_logic;
    red_vector: out std_logic_vector(3 downto 0);
    green_vector: out std_logic_vector(3 downto 0);
    blue_vector: out std_logic_vector(3 downto 0));
    end RTX2060;

architecture Behavioral of RTX2060 is

component clock_halfener is Port(
    clk_in: in std_logic;
    clk_out: out std_logic);
    end component;
    signal half_clock: std_logic;

component Xelor is Port(
    clock_50mhz: in std_logic;
    h_sync: out std_logic;
    v_sync: out std_logic;
    valid_area: out std_logic;
    x_coordinate: out integer;
    y_coordinate: out integer);
    end component;
    signal valid_area: std_logic;
    signal y_pos: integer;
    signal x_pos: integer;

begin

instance_clock_halfener: clock_halfener port map(
    clk_in=>full_clock,
    clk_out=>half_clock);

xelorium: Xelor port map(
    clock_50mhz=>half_clock,
    h_sync=>horizontal_syncro,
    v_sync=>vertical_syncro,
    valid_area=>valid_area,
    y_coordinate=>y_pos,
    x_coordinate=>x_pos);

process (smol_clock) begin
    if valid_area = '1' then
        red_vector <= "1111";
        green_vector <= "1111";
        blue_vector <= "1111";
    else
        red_vector <= (others => '0');
        green_vector <= (others => '0');
        blue_vector <= (others => '0');
    end if;
end process;

end Behavioral;
