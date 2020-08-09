# MIPS32 Architecture

## Avinash Prabhu 

## Instruction currently supported

As per the requirements specified by Saumya Ma’am, I have designed my processor in such a way
that it is able to carry out 28 instructions.

- a. ADD
- b. ADDI
- c. AND
- d. ANDI
- e. NOR
- f. OR
- g. ORI
- h. SLI
- i. SLIV
- j. SRA
- k. SRAV
- l. SRL
- m. SRLV
- n. SUB
- o. XOR
- p. XORI
- q. SLT
- r. SLTU
- s. SLTI
- t. SLTIO
- u. BEQ
- v. BGTZ
- w. BLEZ
- x. BNE
- y. J
- z. JAL
- aa. LW
- bb. SW
-
Here, I have implemented LW and SW instead of LB and SW according to the concepts learnt in
class. We learnt that the IFU fetches words instead of bytes which is why I implemented LW and
SW.

## Instructions currently not supported

All the remaining instructions in the MIPS32 manual are currently not supported. However, based
on demand, I can integrate the required instructions into my design.
Also, as mentioned above, instead of implementing LB and SB, I have implemented LW and SW.


## Processor Clock Frequency

To improve my processor’s performance, I have used to timing constraints wizard too on vivado.
After setting the desired setup time, hold time, etc, I have successfully increased my clock
frequency from 167 Mhz to 1.3 Ghz ( 0.750 ns worst pulse width slack).

## Architecural Diagram of Processor

## Main Memory Design

In my processor, I have 3 different sets of memories, a 32 bit register file consisting of 32 registers,
a 8 bit memory file consisting of 256 registers( 2 KB ) and a 8 bit instruction file consisting of 256
registers( 2 KB ).
Since I am using separate memory registers for memory and instructions, I am using harvard
architecture for my processor.
Since the LSB go the smalled byte address, we are using little-endian convention.


## Interesting Details

### Pros

- I have designed a 2-stage MIPS32 processor.
- Since we have pipelined it, the clock frequency increases.
- In order to make my processor run faster, I learnt to use the tool timing constraints wizard
    tool on Vivado which helped me speed up my processor by almost 10 times.
- Most fundamental instructions are implemented which enables me to run most codes
    possible.
- Since we are using harvard architecture, we will have an edge in performance compared to
    the princeton architecture.

### Cons

- Since I have not implemented some important instructions like div,mult and mod, these
    simple operations will become more complicated as I would have to use some sort of
    algorithm.
- There is a branch delay slot with is a problem as 2 clock cycles will be used up in the case of
    branch and jump.


