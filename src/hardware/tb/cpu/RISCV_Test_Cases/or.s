.global _start
_start:
      addi x1,x0,0x0101
      addi x2,x1,0xfffff800
      or x3,x2,x1
      addi x4,x0,0xfffff801
      addi x5,x4,0x0303
      or x6,x5,x4
      addi x7,x6,0x0404
      addi x8,x7,0xfffff803
      or x9,x8,x7
      addi x10,x0,0xfffff804
      addi x11,x10,0x0606
      or x12,x11,x10
      addi x13,x12,0x0707
      addi x14,x13,0xfffff806
      or x15,x14,x13
      addi x16,x0,0xfffff807
      addi x17,x16,0x0709
      or x18,x17,x16
      addi x19,x18,0x070a
      addi x20,x19,0xfffff809
      or x21,x20,x19
      addi x22,x0,0xfffff80a
      addi x23,x22,0x070c
      or x24,x23,x22
      addi x25,x24,0x070d
      addi x26,x25,0xfffff80c
      or x27,x26,x25
      addi x28,x0,0xfffff80d
      addi x29,x28,0x070f
      or x30,x29,x28
      or x31,x30,x30
      or x31,x31,x31
      j exit

exit: 
    li a7,93
    ecall

