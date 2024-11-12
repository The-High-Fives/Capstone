.global _start
_start:
      addi x1,x0,0xffffffff
      addi x2,x0,2
      addi x3,x0,1
      addi x4,x0,1
      jal x20, function1
      addi x5,x5,5
      jal x20, function2
      addi x10, x10, 3
      j exit
exit: 
    li a7,93
    ecall

function1:
    add x5, x2, x3
    jalr x0, 0(x20)

function2:
    addi x10,x0,5
    jalr x0, 0(x20)