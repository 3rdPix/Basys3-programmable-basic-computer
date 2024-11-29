"""
Minki assembler for iic2343
----------------------------
Expects `INPUT.txt` file containing specially crafted pseudo-assembly
code according to the course's rules. Optionally specify as second
argument `OUTPUT.bin`, default output is `minkibytes.bin` in the base
directory.
"""
# set working dir
from os.path import abspath
from os.path import dirname
import sys
qtfl_dir = abspath(dirname(__file__))
if qtfl_dir not in sys.path:
    sys.path.insert(0, qtfl_dir)

import logging
from minki_system import Minki
import argparse


# Script settings
if not __name__ == "__main__":
    logging.error("Module externally loaded. Why are you importing this?")
    exit(1)

script_parser = argparse.ArgumentParser(description="Minki assembler")

script_parser.add_argument('input', type=str, 
                           help="The input file containing the assembly code.")

script_parser.add_argument('--output', type=str, default='minkibytes.bin',
                           help=f"The output file where the final bytes will"
                           f" be written (default: minkibytes.bin)")

script_parser.add_argument('--log', action='store_true', help=f"Enable log"
                           f" mode, which will verbosely print steps taken by "
                           f"the assembler into minkilogs.txt file (default: False)")

script_parser.add_argument('--test-bin', action='store_true', help=f""
                           f"Adds to logs a description of the binary code"
                           f" that will go into Minki")

script_parser.add_argument('--test-out', type=str, default='minkibytes.txt',
                           help=f"Target file where description of bytes will "
                           f"be saved onto.")

options = script_parser.parse_args()

if options.log:
    logging.basicConfig(filename="minkilogs.txt", filemode='w')
    logging.getLogger().setLevel(logging.DEBUG)

# Open files
try:
    with open(options.input, 'r') as raw_file:
        input_code: tuple = tuple(raw_file.readlines())
except FileNotFoundError:
    logging.error(f"Couldn't find {options.input} file, please retry")
    exit(1)

try:
    output_file = open(options.output, mode="wb")
except FileNotFoundError:
    logging.error(f"Couldn't find {options.output} file, please retry")
    exit(1)

# Do the thing
our_machina = Minki()
code, code_x, data, data_x = our_machina.sectionize(input_code)
if data and data_x[0] != data_x[1]:
    our_machina.build_data(input_code[data_x[0] + 1:data_x[1] + 1])
if code and code_x[0] != code_x[1]:
    our_machina.parse_code(
        input_code[code_x[0] + 1:code_x[1] + 1], code_x[0] + 1)
output_file.write(our_machina.instructions)

output_file.close()

if options.test_bin and options.log:
    # Special functionality

    # Open files
    try:
        with open(options.output, 'rb') as raw_file:
            binary_code = raw_file.read()
    except FileNotFoundError:
        logging.error(f"Couldn't find {options.input} file, please retry")
        exit(1)
    try:
        test_output = open(options.test_out, 'w')
    except FileNotFoundError:
        logging.error(f"Couldn't find {options.test_out} file, please retry")
        exit(1)
    
    # Do the special thing xd
    test_output.write(f"LIT + OPCODE\n")
    for index in range(0, len(binary_code), 5):
        rom_ins = binary_code[index:index + 5]
        ins_as_str = ''.join(format(byte, '08b') for byte in rom_ins)
        lit_and_op = ins_as_str[-36:-20] + ' + ' + ins_as_str[-20:] + '\n'
        test_output.write(lit_and_op)
    
    test_output.close()

"""
Aquí inicia la carga a la placa. Toda esta lógica estaba anteriormente
en `main.py` pero fue deprecada
"""
from iic2343 import Basys3

placa_minki = Basys3()
placa_minki.begin(port_number=0)

# Abrimos el archivo que acabamos de escribir
try:
    with open(options.output, 'rb') as raw_file:
        binary_code = raw_file.read()
except FileNotFoundError:
    print(f"Auxilio, no se pudo abrir archivo binario a pesar de que "
          f"si pudimos escribir en él recién... ¿wtf?")
    exit(1)

# Leemos en chunks de 5 bytes
# No nos hacemos responsables si el número de instrucciones supera las 4096
rom_index = 0
for chunk_index in range(0, len(binary_code), 5):
    instruccion = binary_code[chunk_index:chunk_index + 5]
    placa_minki.write(rom_index, instruccion)
    rom_index += 1

while rom_index < 2**12:
    placa_minki.write(rom_index, bytearray([0x00, 0x00, 0x00, 0x00, 0x00]))
    rom_index += 1

placa_minki.end()
print('Todo el proceso se ha completado con éxito')
exit(0)