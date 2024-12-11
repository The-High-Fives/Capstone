.global _start
_start:
      addi x1, x0, 0x1C
      addi x3, x0, 0x71
_echo:
      # read from rx
      lw x2, 1(x1)	      
      # tx letters 'READY'
      beq x3, x2, stop
      sw x2, 0(x1)
      j _echo
stop:
      addi x2, x0, 0x71
      sb x2, 0(x1)
      addi x2, x0, 0x75
      sb x2, 0(x1)
      addi x2, x0, 0x69
      sb x2, 0(x1)
      addi x2, x0, 0x74
      sb x2, 0(x1)
      j exit

exit: 
    j exit

