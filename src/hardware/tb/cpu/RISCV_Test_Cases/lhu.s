.global _start
_start:
      lui x1,0x12345
      addi x1,x1,0x678

      addi x28,x0,0x700
      sw x1,0(x28)
      lhu x24,0(x28)
      lhu x25,1(x28)
      lhu x26,2(x28)
      lhu x27,3(x28)
      
      lui x1,0x84838
      addi x1,x1,0x281
      addi x5,x0,0x400
      sw x1,0(x5)
      
      lhu x6,0(x5)
      lhu x7,1(x5)
      lhu x8,2(x5)
      lhu x9,3(x5)
      
      j exit

exit: 
    li a7,93
    ecall

