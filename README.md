Simple Dual-Port RAM (1024 × 32)

A beginner-friendly Verilog project implementing a 4 KB Simple Dual-Port RAM in AMD/Xilinx Vivado.

The RAM uses:

Port A for writing

Port B for reading

A common clock

1024 memory locations

32-bit data width

10-bit address width

No byte enable

No parity

No ECC


RAM Capacity

4 KB
Organization

1024 × 32
Address Width

10 bits

Data Width

32 bits

RAM Type

Simple Dual-Port RAM

Clock

Common clock

Write Port

Port A

Read Port

Port B

Byte Enable

No

Parity

No

ECC

No

Capacity Calculation

Each memory location stores 32 bits = 4 bytes.

1024 locations × 32 bits
= 32768 bits
= 4096 bytes
= 4 KB

A 10-bit address is enough because:

2^10 = 1024

So the valid memory addresses are:

0 to 1023
Architecture
The memory contains one 1024 × 32 memory array shared by both ports.

Port A: Write Port

Inputs:

addr_a[9:0] selects the memory location to write

din_a[31:0] provides the 32-bit data

we_a enables the write

clk controls when the write happens

On the rising edge of the clock:

if we_a = 1
    RAM[addr_a] <- din_a

If we_a = 0, no write occurs.

Port B: Read Port

Inputs/outputs:

addr_b[9:0] selects the memory location to read

dout_b[31:0] gives the 32-bit data stored at that address

On the rising edge of the clock:

dout_b <- RAM[addr_b]

This makes the read synchronous.
