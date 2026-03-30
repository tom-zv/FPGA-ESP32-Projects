# FPGA – TCP Server Controlled IO

A bare-metal Zynq PS application that runs a TCP server over lwIP and interacts with a state machine that drives a pair of RGB LEDs via AXI GPIO.

## Hardware

- **SoC**: Xilinx Zynq-7000 / UltraScale+ (ARM Cortex-A, PS GEM Ethernet)
- **IO**: AXI GPIO block connected to 2 × RGB LEDs (6-bit channel)

## Behaviour

The server accepts multiple simultaneous TCP connections. Each received packet is echoed back to the sender and advances the LED state machine one step:

`off → R0 → G0 → B0 → R1 → G1 → B1 → off → …`

LED state is per-connection and resets when a client disconnects.

## Build

Built with Xilinx SDK / Vitis. Requires a BSP generated for the target board with lwIP and the AXI GPIO driver (`XGpio`) enabled.
