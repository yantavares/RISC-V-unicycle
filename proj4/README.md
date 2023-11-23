# Project 4 - RISC-V ALU

Objective: to design, simulate, and synthesize a 32-bit RISC-V ALU (Arithmetic Logic Unit) version in VHDL.

## How to run using GHDL and GTKWave

Using your terminal, execute the following commands:

```bash
ghdl -a RISCV32_ALU.vhdl

```

```bash

ghdl -a Testbench_RISCV32_ALU.vhdl

```

These commands will compile the files. Then, execute the following commands:

```bash
ghdl -e Testbench_RISCV32_ALU

```

```bash
ghdl -r Testbench_RISCV32_ALU --vcd=wave.vcd

```

This should generate the reports in the terminal and the wave.vcd file. To open the wave.vcd file, execute the following command:

```bash
gtkwave wave.vcd

```
