# Project 4 - RISC-V ALU

Objective: to design, simulate, and synthesize a 32-bit RISC-V ALU (Arithmetic Logic Unit) version in VHDL.

## GHDL and GTKWave installation

The program was written in VHDL and simulated using GHDL software. You can download GHDL [here](https://github.com/ghdl/ghdl), however, it should run on any VHDL simulator.

You can see the values generated in wave form in the file wave.vcd, which can be opened using GTKWave software. You can download GTKWave [here](http://gtkwave.sourceforge.net/).

## How to run using GHDL and GTKWave

Using your terminal, execute the following commands:

```bash
cd src/

```

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

The file wave.vcd is already in the repository, so you can skip the previous steps and just open it using GTKWave.

## Report

There is a full report about this project in the file `Projeto_5_OAC.pdf` (in Portuguese). If you want to see screenshots of the waveform and some analysis of the results, check it out.
