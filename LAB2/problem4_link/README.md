# Problem 4 — Master–Slave Handshake Link

Implements a 4-phase `req/ack` handshake for 4 bytes (`A0`..`A3`).  
- Master sends data, asserts `req`, waits for `ack`.  
- Slave latches data, holds `ack` high for 2 cycles.  
- After 4 transfers, Master pulses `done`.  

## Master FSM
```mermaid
stateDiagram-v2
    [*] --> IDLE
    IDLE --> SEND
    SEND --> WAIT_ACK
    WAIT_ACK --> DROP_REQ: ack=1
    DROP_REQ --> WAIT_ACK_LOW
    WAIT_ACK_LOW --> NEXT
    NEXT --> SEND: more bytes
    NEXT --> DONE: last byte
    DONE --> IDLE
```
## Slave FSM
```mermaid
stateDiagram-v2
    [*] --> WAIT_REQ
    WAIT_REQ --> ACK1: req=1
    ACK1 --> ACK2
    ACK2 --> DROP_ACK
    DROP_ACK --> WAIT_REQ
```

## How to run
```bash
iverilog -o sim.out tb_link_top.v master_fsm.v slave_fsm.v link_top.v
vvp sim.out
gtkwave waves/link.vcd
```

