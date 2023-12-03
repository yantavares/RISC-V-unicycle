# Define the compiler
GHDL=ghdl
GTKWAVE=gtkwave

# VHDL source files
SOURCES=pc.vhdl instruction_memory.vhdl register_bank.vhdl alu.vhdl immediate_generator.vhdl risc_v_processor.vhdl Processor_Testbench.vhdl

# Top level entity
TOP_LEVEL=risc_v_processor

# Testbench
TESTBENCH=Processor_Testbench

# Default target: compile all VHDL files and run the testbench
all: compile run_testbench

# Compile VHDL files
compile: $(SOURCES)
    $(GHDL) -a $(SOURCES)

# Elaborate top level
elaborate: compile
    $(GHDL) -e $(TOP_LEVEL)
    $(GHDL) -e $(TESTBENCH)

# Run the testbench
run_testbench: elaborate
    $(GHDL) -r $(TESTBENCH) --vcd=testbench_waveform.vcd

# Run the processor simulation
run_processor: elaborate
    $(GHDL) -r $(TOP_LEVEL) --vcd=processor_waveform.vcd

# Open the waveform with GTKWave
view_waveform:
    $(GTKWAVE) testbench_waveform.vcd

# Clean up generated files
clean:
    $(GHDL) --clean
    rm -f *.vcd

.PHONY: all compile elaborate run_testbench run_processor view_waveform clean
