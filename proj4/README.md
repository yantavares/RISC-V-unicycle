# Project 4 - RISC-V ALU

Objective: to design, simulate, and synthesize a 32-bit RISC-V ALU (Arithmetic Logic Unit) version in VHDL.

## How to run using GHDL and GTKWave

Using your terminal, execute the following commands:

```bash
ghdl -a --std=08 AluRV32.vhdl

```

The --std=08 flag is used to specify the VHDL version. The AluRV32.vhdl file contains commands that are only available in VHDL 2008 and up.

````bash

```bash

ghdl -a --std=08 Testbench_AluRV32.vhdl

````

These commands will compile the files. Then, execute the following commands:

```bash
ghdl -e --std=08 Testbench_AluRV32

```

```bash
ghdl -r --std=08 Testbench_AluRV32 --vcd=wave.vcd

```

This should generate the reports in the terminal and the wave.vcd file. To open the wave.vcd file, execute the following command:

```bash
gtkwave wave.vcd

```