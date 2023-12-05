# Project - RISC-V Memory (RAM and ROM)

Objective: To design, simulate, and synthesize the data and instruction memories (RAM and ROM) of the RISC-V architecture in VHDL.

## Software Installation

This VHDL project can be simulated using various tools. Recommended software includes:

1. **GHDL**: A VHDL compiler and simulator suitable for running VHDL code. Download GHDL from [here](https://github.com/ghdl/ghdl).

2. **ModelSim**: Another VHDL simulation tool that can be used for this project. Information about ModelSim can be found [here](https://www.intel.com/content/www/us/en/software/programmable/quartus-prime/model-sim.html).

3. **EDA Playground**: An online platform for VHDL/Verilog simulations. Access it [here](https://www.edaplayground.com/).

4. **GTKWave**: For waveform visualization of simulation results. Download GTKWave from [here](http://gtkwave.sourceforge.net/).

## Running the Simulation

To simulate the RISC-V memory modules, follow these steps in your chosen simulation environment:

```bash
cd src/
```

### Compiling the VHDL Files

For GHDL:

```bash
ghdl -a --std=08 RAM_RV32.vhdl
ghdl -a --std=08 ROM_RV32.vhdl
ghdl -a --std=08 Testbench_RAM_ROM.vhdl
```

For ModelSim or EDA Playground, follow their respective compilation procedures.

### Running the Testbench

For GHDL:

```bash
ghdl -e --std=08 Testbench_RAM_ROM
ghdl -r --std=08 Testbench_RAM_ROM --vcd=wave.vcd
```

For ModelSim or EDA Playground, execute the testbench according to their specific run commands.

### Viewing the Waveform

If using GTKWave:

```bash
gtkwave wave.vcd
```

## Report

A comprehensive report about this project is available in the file `Projeto_6_OAC.pdf` (in Portuguese). This report includes screenshots of the waveform and detailed analysis of the results.
