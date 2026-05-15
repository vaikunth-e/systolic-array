# Systolic Array for 1D Convolution in SystemVerilog

This project implements a parameterizable systolic array for 1D convolution-style multiply-accumulate operations in SystemVerilog. The design is built from reusable processing elements that pass input samples across the array while accumulating weighted partial sums through a pipeline.

The project includes:

- parameterized SystemVerilog RTL
- reusable MAC-style systolic slice module
- self-checking-style simulation testbench structure
- Python reference model for validating timing and output behavior
- Vivado waveform capture

## Project Goal

The goal of this project was to design and verify a small hardware accelerator structure similar to the datapath pattern used in convolution accelerators and TPU-style systolic arrays.

Instead of computing every multiply-accumulate operation in one large combinational block, the design breaks the computation into a chain of processing elements. Each slice stores and forwards data while contributing one weighted product to the accumulated output.

This makes the design easier to parameterize, pipeline, and scale.

## Repository Structure

```text
.
├── systolic_array_conv1d.sv        # top-level systolic array module
├── unit_slice.sv                   # reusable processing element
├── tb_systolic_array_conv1d.sv     # SystemVerilog simulation testbench
├── systolic_model.py               # Python reference/timing model
├── tb_systolic_array_conv1d_behav.wcfg
└── waveform562lab3.png             # Vivado waveform screenshot
