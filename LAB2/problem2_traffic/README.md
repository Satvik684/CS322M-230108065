# Problem 2 — Two-Road Traffic Light

# How to run:
```bash
  iverilog -o sim.out traffic_light.v tb_traffic_light.v
  vvp sim.out
  gtkwave dump.vcd
```

Notes:
  - The TB generates a 'tick' every 5 clock cycles (fast sim). In hardware, tick would be 1 Hz.  
  - Phase durations: NS green = 5 ticks, NS yellow = 2 ticks, EW green = 5 ticks, EW yellow = 2 ticks.
