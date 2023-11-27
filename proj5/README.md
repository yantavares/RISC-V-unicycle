# Project - RISC-V Register File

Objective: to design, simulate, and synthesize a RISC-V compatible bank of registers file in VHDL.

## Software Installation

The project is implemented in VHDL and requires simulation tools. The following software can be used:

1. **GHDL**: This is a VHDL simulator that can run VHDL code. You can download GHDL from [here](https://github.com/ghdl/ghdl). Although this project is designed for GHDL, it should be compatible with other VHDL simulators.

2. **GTKWave**: To visualize the simulation results in waveform, use GTKWave. It can open `.vcd` files generated during simulation. Download GTKWave from [here](http://gtkwave.sourceforge.net/).

## Running the Simulation with GHDL and GTKWave

To simulate the RISC-V register file, follow these steps using your terminal:

### Compiling the VHDL Files

```bash
ghdl -a --std=08 XREG.vhdl
ghdl -a --std=08 Testbench_XREG.vhdl
```

Ensure you use the `--std=08` flag to indicate the VHDL version, as some commands in the VHDL files require VHDL 2008 or later.

### Running the Testbench

```bash
ghdl -e --std=08 Testbench_XREG
ghdl -r --std=08 Testbench_XREG --vcd=wave.vcd
```

These commands will run the testbench, generating output in the terminal and a `wave.vcd` file.

### Viewing the Waveform

To view the simulation results:

```bash
gtkwave wave.vcd
```

Note: The `wave.vcd` file is created during the simulation, so you need to run the testbench before you can view it.

## Report

There is a full report about this project in the file `Projeto_5_OAC.pdf` (in Portuguese). If you want to see screenshots of the waveform and some analysis of the results, check it out.
