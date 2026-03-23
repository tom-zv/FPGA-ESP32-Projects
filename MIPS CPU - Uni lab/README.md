# MIPS CPU in VHDL

Small MIPS-like / DLX-style CPU built in VHDL as part of a university computer architecture lab.

The repo keeps both the handwritten RTL and the schematic-generated VHDL used in the original Xilinx ISE flow, split so the source is easier to browse.

## Layout

```text
src/rtl/         handwritten source files
src/generated/   schematic-generated .vhf netlists
sim/testbenches/ simulation benches
docs/            short notes on structure and tool flow
```

## Start Here

- `src/rtl/control/` for the control FSM
- `src/rtl/state_machines/` for the read/write sequencing logic
- `src/rtl/datapath/` and `src/rtl/env/` for handwritten datapath helpers
- `src/generated/top/` for the assembled top-level design
- `sim/testbenches/` for the available benches

## Notes

- Generated `.vhf` files are kept because they are part of the original project, not because they are the best place to read the design.
- Full simulation of the generated top-level pieces still expects the old Xilinx `UNISIM` library setup.

More detail lives in [docs/architecture.md](docs/architecture.md) and [docs/toolchain.md](docs/toolchain.md).
