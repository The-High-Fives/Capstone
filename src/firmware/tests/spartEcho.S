main:
        addi    sp,sp,-32
        sw      ra,28(sp)
        sw      s0,24(sp)
        addi    s0,sp,32
.L2:
        call    getSPART
        mv      a5,a0
        sb      a5,-17(s0)
        lbu     a5,-17(s0)
        mv      a0,a5
        call    setSPART
        j       .L2
getSPART:
        addi    sp,sp,-32
        sw      s0,28(sp)
        addi    s0,sp,32
        li      a5,1073741824
        addi    a5,a5,29
        sw      a5,-20(s0)
        lw      a5,-20(s0)
        lbu     a5,0(a5)
        mv      a0,a5
        lw      s0,28(sp)
        addi    sp,sp,32
        jr      ra
setSPART:
        addi    sp,sp,-48
        sw      s0,44(sp)
        addi    s0,sp,48
        mv      a5,a0
        sb      a5,-33(s0)
        li      a5,1073741824
        addi    a5,a5,28
        sw      a5,-20(s0)
        lbu     a5,-33(s0)
        sw      a5,-24(s0)
        lw      a5,-20(s0)
        lw      a4,-24(s0)
        sw      a4,0(a5)
        nop
        lw      s0,44(sp)
        addi    sp,sp,48
        jr      ra