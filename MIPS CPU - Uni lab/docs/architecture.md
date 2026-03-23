# Architecture Notes

## Overview

- `src/rtl/control/DLX_Control.vhd` drives the CPU state flow: fetch, decode, execute, load/store, branch, and writeback.
- `src/rtl/datapath/` and `src/rtl/env/` hold handwritten helper blocks around the datapath.
- `src/rtl/state_machines/` contains read/write side state machines.
- `src/rtl/mmu/MMU.vhd` and `src/rtl/io/io_simul.vhd` handle address shaping and the simple simulation-side memory wrapper.
- `src/rtl/primitives/` contains small reusable blocks: muxes, registers, counters, SRAM helpers, and simple logic units.

## Generated Netlists

The larger assembled pieces are generated `.vhf` files:

- `src/generated/datapath/`
- `src/generated/debug/`
- `src/generated/top/`

## Simulation

`sim/testbenches/` 