# MIPS-32-Pipelined-Processor
A complete 32-bit pipelined MIPS processor implemented in Verilog HDL with hazard detection, forwarding, branch handling, and pipeline flushing.

## Features

- 5-stage MIPS pipeline
  - IF
  - ID
  - EX
  - MEM
  - WB

- Hazard Handling
  - Data forwarding
  - Load-use hazard detection
  - Pipeline stalling
  - Pipeline flushing


- Supported Instructions
  - add
  - sub
  - and
  - or
  - slt
  - addi
  - lw
  - sw
  - beq

---

## Pipeline Architecture

The processor contains:

- Program Counter
- Instruction Memory
- Register File
- ALU
- Data Memory
- Pipeline Registers
- Hazard Detection Unit
- Forwarding Unit



## Hazard Management

### Data Hazards
Resolved using:
- Forwarding Unit
- Stall logic for load-use hazards

### Control Hazards
Resolved using:
- Branch decision in Decode stage
- IF/ID and ID/EX flushing

