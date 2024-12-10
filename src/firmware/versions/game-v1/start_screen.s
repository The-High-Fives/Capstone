        li      a4,0
        li      a3,38
        li      a2,368
        li      a1,150
        li      a0,200
        call    drawRect
        li      a3,3
        li      a2,104
        li      a1,150
        li      a0,200
        call    drawChar
        li      a3,3
        li      a2,105
        li      a1,150
        li      a0,216
        call    drawChar
        li      a3,3
        li      a2,103
        li      a1,150
        li      a0,232
        call    drawChar
        li      a3,3
        li      a2,104
        li      a1,150
        li      a0,248
        call    drawChar
        li      a3,3
        li      a2,45
        li      a1,150
        li      a0,264
        call    drawChar
        li      a3,3
        li      a2,102
        li      a1,150
        li      a0,280
        call    drawChar
        li      a3,3
        li      a2,105
        li      a1,150
        li      a0,296
        call    drawChar
        li      a3,3
        li      a2,118
        li      a1,150
        li      a0,312
        call    drawChar
        li      a3,3
        li      a2,101
        li      a1,150
        li      a0,328
        call    drawChar
        li      a3,3
        li      a2,104
        li      a1,150
        li      a0,360
        call    drawChar
        li      a3,3
        li      a2,105
        li      a1,150
        li      a0,376
        call    drawChar
        li      a3,3
        li      a2,116
        li      a1,150
        li      a0,392
        call    drawChar
        li      a3,3
        li      a2,115
        li      a1,150
        li      a0,408
        call    drawChar
        li      a3,3
        li      a2,58
        li      a1,150
        li      a0,424
        call    drawChar
        li      a3,1
        li      a2,116
        li      a1,200
        li      a0,248
        call    drawChar
        li      a3,1
        li      a2,104
        li      a1,200
        li      a0,264
        call    drawChar
        li      a3,1
        li      a2,101
        li      a1,200
        li      a0,280
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
        li      a2,109
        li      a1,200
        li      a0,344
        call    drawChar
        li      a3,1
        li      a2,101
        li      a1,200
        li      a0,360
        call    drawChar
        li      a3,1
        li      a2,33
        li      a1,200
        li      a0,376
        call    drawChar
        
        li      a3,3
        li      a2,20
        li	 a1, 380
        li	 a0, 320
        call    drawCircle
        
.loop:
      lui  t0, 0x40000
      addi t0, t0, 0x200
	lw t1, 0(t0)
	andi t3, t1, 0x1 # valid
      andi t4, t1, 0x2 # present
      srli  t4, t4, 1
      srli  t5, t1, 2	 # x
      andi t5, t5, 0x3FF 
      addi t0, zero, 640
      sub  t5, t0, t5
      srli  t6, t1, 12	 # y
      andi t6, t6, 0x3FF
      
        li      a3,3
        li      a2,20
        mv 	 a1, t6
        mv	 a0, t5
        call    drawCircle
      
      # check valid && ready
      and  t0, t3, t4
      beqz t0, .loop
      # check bounds
        li      t0,290		#  check x
        ble     t5,t0, .loop
        li      t0,349
        bgt     t5,t0, .loop
        li      t0,350		# check y
        ble     t6,t0,	.loop
        li      t0,409
        bgt     t6,t0,	.loop
        
        li      a0,112
        call    setSPART
      
	# clear screen
      li      a4,0
      li      a3,480
      li      a2,640
      li      a1,0
      li      a0,0
      call    drawRect