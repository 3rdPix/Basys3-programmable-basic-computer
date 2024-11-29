"""
A simple script to turn raw 8-bit depth non-planar RGB
image data into a `.coe` file targetting Basys3 color
depth.
"""
from sys import argv
if len(argv) != 5:
    print("archivo.data archivofinal trim/scale b/*")
    exit(0)
with open(argv[1], "rb") as raw: data = raw.read()
counter = 1
red_file, green_file, blue_file = argv[2] + "_RED.coe", argv[2] + "_GREEN.coe", argv[2] + "_BLUE.coe"
with open(red_file, "w") as rf, open(green_file, "w") as gf, open(blue_file, "w") as bf:
    rf.write("memory_initialization_radix=16;\n")
    rf.write("memory_initialization_vector=\n")
    gf.write("memory_initialization_radix=16;\n")
    gf.write("memory_initialization_vector=\n")
    bf.write("memory_initialization_radix=16;\n")
    bf.write("memory_initialization_vector=\n")
    red_whole, green_whole, blue_whole = str(), str(), str()
    for byte in data:
        if argv[3] == "trim":
            scaled = byte >> 4
        elif argv[3] == "scale":
            scaled = (byte * 15) // 255
        else:
            print("Indica un modo de conversión")
            exit(1)
        if 0 < scaled < 14 and argv[4] == "b": scaled = scaled + 2
        stringed = ''.join(format(scaled, "01x"))
        if counter % 3 == 1: red_whole += stringed + ", "
        elif counter % 3 == 2: green_whole += stringed + ", "
        elif counter % 3 == 0: blue_whole += stringed + ", "
        else: print("Ojo: error")
        counter += 1
    red_whole = red_whole[:-2] + ";\n"
    rf.write(red_whole)
    green_whole = green_whole[:-2] + ";\n"
    gf.write(green_whole)
    blue_whole = blue_whole[:-2] + ";\n"
    bf.write(blue_whole)
