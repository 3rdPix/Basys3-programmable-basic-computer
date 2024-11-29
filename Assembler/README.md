# Minki Assembler!



## Usage

The assembler receives a `.suasm` file as argument and writes a `.bin` file with the instructions to be loaded into the ROM of the FPGA. Once the file is written, it automatically tries to load them into the connected board. If it fails, try changing the port.

Direct example:

```bash
python minki_assembler.py code.suasm
```

Additionally, you can specify a few arguments:

1. `--output`: changes the default name of the binary file.

```bash
python minki_assembler.py code.suasm --output custom_output.bin
```

2. `--log`: Creates a `minkilogs.txt` file with all the details of the process.

3. `--test-bin`: Creates a `minkibytes.txt` file where the output binary file is decomposed into its structure. That is, it shows the Literal + operation code for each instruction loaded.

4. `--test-out`: Changes the default name of the `test-bin` output file

A full example with all options:

```bash
python minki_assembler.py tests/my_test.suasm --output tests_output/output_1.bin --log --test-bin --test-out tests_output/binary_test_1.txt
```
