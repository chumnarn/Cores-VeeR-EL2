# Fixed ROM program, RV32I; boot.hex is supplied, no cross compiler required.
.option norvc
.section .text
.global _start
_start:
 lui x1, 0x10000
 addi x2, x0, 0x5a
 sw x2, 0(x1)
 lw x3, 0(x1)
 bne x3, x2, fail
 addi x2, x0, 0xa5
 sb x2, 5(x1)
 lbu x3, 5(x1)
 bne x3, x2, fail
 sh x2, 6(x1)
 lhu x3, 6(x1)
 bne x3, x2, fail
 lui x1, 0x20000
 addi x2, x0, 0xa5
 sw x2, 0(x1)
pass: j pass
 nop
fail:
 lui x1, 0x20000
 addi x2, x0, 0xee
 sw x2, 0(x1)
hang: j hang
