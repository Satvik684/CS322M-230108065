# Problem 1 — Mealy Sequence Detector (1101)

## How to build & run
```bash
iverilog -o sim.out tb_seq_detect_mealy.v seq_detect_mealy.v
vvp sim.out
gtkwave waves/dump.vcd
