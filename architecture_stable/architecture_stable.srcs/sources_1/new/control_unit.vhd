----------------------------------------------------------------------------------
-- Company: Minki Inc.
-- Engineer: mpiavf, rocimarquez, 3rdPix
-- 
-- Create Date: 10.09.2024 16:52:03
-- Design Name: Minki v1
-- Module Name: CU - Behavioral
-- Project Name: Minki project
-- Target Devices: Minki
-- Tool Versions: Minki v.1
-- Description: Proyecto que le da vida a Minki
-- 
-- Dependencies: Minki
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: Minki es un nombre originalmente del koreano que significa
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU is
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
end CU;


architecture Behavioral of CU is

signal instruccion: std_logic_vector (16 downto 0);
signal inter_opcode: std_logic_vector (6 downto 0);

begin

inter_opcode <= opcode(6 downto 0);

with inter_opcode select 
    instruccion <=  "10010000000000000" when "1000011", -- MOV A, B     10010000000
                    "01001100000000000" when "1000010", -- MOV B, A     01001100000
                    "10011000000000000" when "1000001", -- MOV A, Lit   10011000000
                    "01011000000000000" when "1000000", -- MOV B, Lit   01011000000
                    "10010100000000000" when "0111111", -- MOV A, (Dir) 10010100000
                    "01010100000000000" when "0111110", -- MOV B, (Dir) 01010100000
                    "00001100001000000" when "0111101", -- MOV (Dir), A 00001100001
                    "00010000001000000" when "0111100", -- MOV (Dir), B 00010000001
                    "10000000000000000" when "0111011", -- ADD A, B     10000000000
                    "01000000000000000" when "0111010", -- ADD B, A     01000000000
                    "10001000000000000" when "0111001", -- ADD A, Lit   10001000000
                    "01001000000000000" when "0111000", -- ADD B, Lit   01001000000
                    "10000100000000000" when "0110111", -- ADD A, (Dir) 10000100000
                    "01000100000000000" when "0110110", -- ADD B, (Dir) 01000100000
                    "00000000001000000" when "0110101", -- ADD (Dir)    00000000001
                    "10000000100000000" when "0110100", -- SUB A, B     10000000100
                    "01000000100000000" when "0110011", -- SUB B, A     01000000100
                    "10001000100000000" when "0110010", -- SUB A, Lit   10001000100
                    "01001000100000000" when "0110001", -- SUB B, Lit   01001000100
                    "10000100100000000" when "0110000", -- SUB A, (Dir) 10000100100
                    "01000100100000000" when "0101111", -- SUB B, (Dir) 01000100100
                    "00000000101000000" when "0101110", -- SUB (Dir)    00000000101
                    "10000001000000000" when "0101101", -- AND A, B     10000001000
                    "01000001000000000" when "0101100", -- AND B, A     01000001000
                    "10001001000000000" when "0101011", -- AND A, Lit   10001001000
                    "01001001000000000" when "0101010", -- AND B, Lit   01001001000
                    "10000101000000000" when "0101001", -- AND A, (Dir) 10000101000
                    "01000101000000000" when "0101000", -- AND B, (Dir) 01000101000
                    "00000001001000000" when "0100111", -- AND (Dir)    00000001001
                    "10000001100000000" when "0100110", -- OR A, B      10000001100
                    "01000001100000000" when "0100101", -- OR B, A      01000001100
                    "10001001100000000" when "0100100", -- OR A, Lit    10001001100
                    "01001001100000000" when "0100011", -- OR B, Lit    01001001100
                    "10000101100000000" when "0100010", -- OR A, (Dir)  10000101100
                    "01000101100000000" when "0100001", -- OR B, (Dir)  01000101100
                    "00000001101000000" when "0100000", -- OR (Dir)     00000001101
                    "10000010000000000" when "0011111", -- XOR A, B     10000010000
                    "01000010000000000" when "0011110", -- XOR B, A     01000010000
                    "10001010000000000" when "0011101", -- XOR A, Lit   10001010000
                    "01001010000000000" when "0011100", -- XOR B, Lit   01001010000
                    "10000110000000000" when "0011011", -- XOR A, (Dir) 10000110000
                    "01000110000000000" when "0011010", -- XOR B, (Dir) 01000110000
                    "00000010001000000" when "0011001", -- XOR (Dir)    00000010001
                    "10001110100000000" when "0011000", -- NOT A        10001110100
                    "01001110100000000" when "0010111", -- NOT B, A     01001110100
                    "00001110101000000" when "0010110", -- NOT (Dir), A 00001110101
                    "10001111100000000" when "0010101", -- SHL A        10001111100
                    "01001111100000000" when "0010100", -- SHL B, A     01001111100
                    "00001111101000000" when "0010011", -- SHL (Dir), A 00001111101
                    "10001111000000000" when "0010010", -- SHR A        10001111000
                    "01001111000000000" when "0010001", -- SHR B, A     01001111000
                    "00001111001000000" when "0010000", -- SHR (Dir), A 00001111001
                    "10001000000000000" when "0001111", -- INC A        10001000000
                    "01100000000000000" when "0001110", -- INC B        01100000000
                    "00100100001000000" when "0001101", -- INC (Dir)    00100100001
                    "10001000100000000" when "0001100", -- DEC A        10001000100
                    "00011100000000000" when "0000000", -- NOP          00011100000
                    "00000000100000000" when "0001011", -- CMP A, B
                    "00001000100000000" when "0001010", -- CMP A, Lit
                    "00000100100000000" when "0001001", -- CMP A, (Dir)
		    -- Entrega 2
		    "10010100000010000" when "1000100", -- MOV A, (B)
		    "01010100000010000" when "1000101", -- MOV B, (B)
		    "00001100001010000" when "1000110", -- MOV (B), A
		    "00011000001010000" when "1000111", -- MOV (B), Lit
		    "10000100000010000" when "1001000", -- ADD A, (B)
		    "01000100000010000" when "1001001", -- ADD B, (B)
		    "10000100100010000" when "1001010", -- SUB A, (B)
		    "01000100100010000" when "1001011", -- SUB B, (B)
		    "10000101000010000" when "1001100", -- AND A, (B)
		    "01000101000010000" when "1001101", -- AND B, (B)
		    "10000101100010000" when "1001110", -- OR A, (B)
		    "01000101100010000" when "1001111", -- OR B, (B)
		    "10000110000010000" when "1010000", -- XOR A, (B)
		    "01000110000010000" when "1010001", -- XOR B, (B)
		    "00001110101010000" when "1010010", -- NOT (B), A
		    "00001111101010000" when "1010011", -- SHL (B), A
		    "00001111001010000" when "1010100", -- SHR (B), A
		    "00100100001010000" when "1010101", -- INC (B)
		    "00000100100010000" when "1010110", -- CMP A, (B)
		    "00001100001100100" when "1010111", -- PUSH A
		    "00010000001100100" when "1011000", -- PUSH B
		    "00000000000001000" when "1011001", -- POP A parte1
		    "10010100000100000" when "1011010", -- POP A parte2
		    "00000000000001000" when "1011011", -- POP B parte1
		    "01010100000100000" when "1011100", -- POP B parte2
		    "00000000011100101" when "1011101", -- CALL Ins
		    "00000000000001000" when "1011110", -- RET parte1
		    "00000000010100010" when "1011111", -- RET parte2
		    "00000000000000000" when others;
                    

-- c,z,n
-- status(2), status(1), status(0)
with inter_opcode select 
    loadPc <=   '1' when "0001000",                                     -- JMP
                status(1) when "0000111",                       -- JEQ , Cuando Z = 1
                not status(1) when "0000110",                   -- JNE , Cuando Z = 0
                (not status(1)) and (not status(0)) when "0000101", -- JGT , Cuando N = 0 y Z = 0
                not status(0) when "0000100",                   -- JGE , Cuando N = 0
                status(0) when "0000011",                       -- JLT , Cuando N = 1
                (status(1) or status(0)) when "0000010",        -- JLE , Cuando N = 1 o Z = 1
                status(2) when "0000001",                       -- JCR , Cuando C = 1
                '1' when "1011101",                             -- CALL
                '1' when "1011111",                             -- RET parte2
                '0' when others; 
    
enableA <= instruccion(16);
enableB <= instruccion(15);
selectorA <= instruccion(14 downto 13);
selectorB <= instruccion(12 downto 11);
selectorALU <= instruccion(10 downto 8);
writeRAM <= instruccion(6);
selectorAddrs <= instruccion(5 downto 4);
increaseSP <= instruccion(3);
decreaseSP <= instruccion(2);
selectorPC <= instruccion(1);
selectorData <= instruccion(0);

end Behavioral;
