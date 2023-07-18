# Iterative Multiplier

Project for Computer Design course.

The goal was to design an iterative multiplier with two inputs, described in the VHDL language, with a 2-bit multiplier automatically synthesised by the synthesis tool and used to obtain the desired multiplier, first a 16-bit output unit and then a 64-bit unit, by parameterisation.

I followed a divide et impera approach, this by designing 3 independent modules which were linked together in the right way.

Using a Xilinx Spartan 6 board as a reference, I synthesised all the modules on the FPGA using Xilinx ISE.

![iterative-multiplier](https://github.com/lorenzozaccomer/iterative-multiplier/assets/80517436/99e97f81-8672-4bf6-ab7a-e2cc857e2151)

### Documentation

Folders:
- images: some screen about the simulation with ModelSim
- report: generated via Xilinx ISE  
- software: advice to install Xilinx ISE on your computer
- asm chart: contain all the execution graph

### Code

Contain all the file for the iterative multiplier
- (folder) modules: all the module's file for the iterative multiplier
- (folder) standard multiplier: simple multiplier loaded via ModelSim used to test the result of the iterative multiplier
