theRealEndScreen:
        li      a0,115      # send s
        call    setSPART

        j       .L4
        li      a4,0
        li      a3,480
        li      a2,640
        li      a1,0
        li      a0,0
        call    drawRect

                li      a3,3
        li      a2,103
        li      a1,150
        li      a0,224
        call    drawChar
        li      a3,3
        li      a2,97
        li      a1,150
        li      a0,240
        call    drawChar
        li      a3,3
        li      a2,109
        li      a1,150
        li      a0,256
        call    drawChar
        li      a3,3
        li      a2,101
        li      a1,150
        li      a0,272
        call    drawChar
        li      a3,3
        li      a2,111
        li      a1,150
        li      a0,304
        call    drawChar
        li      a3,3
        li      a2,118
        li      a1,150
        li      a0,320
        call    drawChar
        li      a3,3
        li      a2,101
        li      a1,150
        li      a0,336
        call    drawChar
        li      a3,3
        li      a2,114
        li      a1,150
        li      a0,352
        call    drawChar
        li      a3,3
        li      a2,33
        li      a1,150
        li      a0,368
        call    drawChar
        li      a3,1
        li      a2,112
        li      a1,200
        li      a0,216
        call    drawChar
        li      a3,1
        li      a2,108
        li      a1,200
        li      a0,232
        call    drawChar
        li      a3,1
        li      a2,97
        li      a1,200
        li      a0,248
        call    drawChar
        li      a3,1
        li      a2,121
        li      a1,200
        li      a0,264
        call    drawChar
        li      a3,1
        li      a2,97
        li      a1,200
        li      a0,296
        call    drawChar
        li      a3,1
        li      a2,103
        li      a1,200
        li      a0,312
        call    drawChar
        li      a3,1
        li      a2,97
        li      a1,200
        li      a0,328
        call    drawChar
        li      a3,1
        li      a2,105
        li      a1,200
        li      a0,344
        call    drawChar
        li      a3,1
        li      a2,110
        li      a1,200
        li      a0,360
        call    drawChar
        li      a3,1
        li      a2,63
        li      a1,200
        li      a0,376
        call    drawChar
        li      a3,2
        li      a2,104
        li      a1,250
        li      a0,200
        call    drawChar
        li      a3,2
        li      a2,105
        li      a1,250
        li      a0,216
        call    drawChar
        li      a3,2
        li      a2,116
        li      a1,250
        li      a0,232
        call    drawChar
        li      a3,2
        li      a2,45
        li      a1,250
        li      a0,248
        call    drawChar
        li      a3,2
        li      a2,108
        li      a1,250
        li      a0,264
        call    drawChar
        li      a3,2
        li      a2,101
        li      a1,250
        li      a0,280
        call    drawChar
        li      a3,2
        li      a2,118
        li      a1,250
        li      a0,296
        call    drawChar
        li      a3,2
        li      a2,101
        li      a1,250
        li      a0,312
        call    drawChar
        li      a3,2
        li      a2,108
        li      a1,250
        li      a0,328
        call    drawChar
        li      a3,2
        li      a2,58
        li      a1,250
        li      a0,344
        call    drawChar
        li      a3,2
        lw      a2,-20(s0)
        li      a1,250
        li      a0,360
        call    drawNumber
endLoop:
    j endLoop