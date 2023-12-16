# RISC-V Unicycle Processor Implementation in VHDL

## Project Overview

This project involves the implementation of a RISC-V Unicycle processor in VHDL. It aims to mimic the functionality of a standard RISC-V simulator, like RARS, and includes a comprehensive testbench for verification.

## Project Structure

1. **Top-Level VHDL File (RV32_Processor.vhdl):**

   - Integrates all the processor components including PC, Instruction Memory, Register Bank, ALU, and Immediate Generator.
   - Handles the entire instruction cycle: fetch, decode, execute, memory access, and write-back.

2. **Testbench File (Testbench_RV32_Processor.vhdl):**
   - Provides a robust environment to verify the processor's functionality.
   - Includes stimulus generation, expected output checking, and performance analysis tools.

## File Descriptions

- **RV32_Processor.vhdl**: The main processor file that integrates various components like ALU, register bank, etc., into a functional RISC-V processor.
- **Testbench_RV32_Processor.vhdl**: A testbench file for simulating and verifying the processor's functionality against a series of test cases.

## Prerequisites

- GHDL: VHDL compiler and simulator.
- GTKWAVE (optional): For viewing the waveform of the simulation.

## Compilation and Running Instructions

1. **Using the Makefile**

   - A Makefile is provided to automate the compilation, elaboration, and simulation processes.
   - Run `make` to compile all VHDL files and execute the testbench.
   - Run `make run_processor` to simulate the processor itself.
   - Run `make view_waveform` to view the generated waveforms with GTKWAVE.
   - Run `make clean` to clean up generated files.

2. **Manual Compilation and Running**
   - If you prefer to manually compile and run the files, follow these steps:
     - Compile each VHDL file:
       ```bash
       ghdl -a ./PC/PC.vhdl
          ...
       ```
     - Compile the testbench file:
       ```bash
       ghdl -a Testbench_RV32_Processor.vhdl
       ```
     - Elaborate the design:
       ```bash
       ghdl -e RV32_Processor
       ghdl -e Testbench_RV32_Processor
       ```
     - Run the simulations:
       ```bash
       ghdl -r RV32_Processor --vcd=processor_waveform.vcd
       ghdl -r Testbench_RV32_Processor --vcd=testbench_waveform.vcd
       ```
     - View the waveforms with GTKWAVE:
       ```bash
       gtkwave processor_waveform.vcd
       gtkwave testbench_waveform.vcd
       ```
