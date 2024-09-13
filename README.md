# ASIC Flow Digital IC Design Diploma Project
## Block Diagram
![image](https://github.com/user-attachments/assets/b779f34a-4bc2-4727-8e26-01f831658e7a)

## Project Overview
* Clock Domain 1 (REF_CLK):
  - ALU
  - RegFile
  - SYS_CTRL
  - Clock Gating
* Clock Domain 2 (UART_CLK):
  - UART_TX
  - UART_RX
  - PULSE_GEN
  - Clock Dividers
 * Data Synchronizers:
   - RST Synchronizer
   - Data Synchronizer
   - ASYNC FIFO
  ## Sequence of Operation
  - Perform configuration via Register File write operations.
  - Master sends various commands (RegFile and ALU operations).
  - Commands are processed by SYS_CTRL after reception through UART_RX.
  - Results are sent back to the master via UART_TX.

## Key Features
- ALU Operations: Addition, Subtraction, Multiplication, Division, AND, OR, NAND, NOR, XOR, XNOR, CMP, and Shift operations.
 - Register File Operations: Write and read capabilities with specific command frames.
 - System Specifications: REF_CLK at 50 MHz, UART_CLK at 3.6864 MHz, and always-on clock divider.
