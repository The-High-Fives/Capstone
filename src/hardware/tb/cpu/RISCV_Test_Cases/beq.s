.global _start
_start:
0      addi x1,x0,1
4      addi x2,x0,2
8      addi x3,x0,1
c      beq x1,x3,target_beq_pass
10      j exit

exit: 
14    li a7,93
18    ecall

target_beq_pass:
1c    addi x4,x0,1
20    beq x1,x2,target_beq_fail
24    j exit

target_beq_fail:
    addi x5,x0,1
    j exit
