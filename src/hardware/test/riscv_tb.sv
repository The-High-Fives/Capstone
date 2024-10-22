module riscv_tb;
  reg         clk;
  reg         rst;
  reg  [31:0] instr;       // 32-bit risk-v instruction
  wire [31:0] pc;          // program counter
  
  // instantiate the processor
  riscv_processor uut (
    .clk(clk),
    .rst(rst),
    .instr(instr),
    .pc(pc),
  );
  
  // clock
  initial begin
    clk = 0;
    forever #5 clk = ~clk;  
  end

  initial begin
    // Apply reset
    rst = 1;
    #10;
    rst = 0;
    
	// Test case 1: Load upper immediate to x9
	instr = 32'h00009037;  // LUI x9, 0x00000  (Set upper 20 bits of x9 to 0)
	#10;
	
	// Test case 2: Add upper immediate to PC and store in x10
	instr = 32'h00009017;  // AUIPC x10, 0x00000  (Add upper immediate to PC, store result in x10)
	#10;
	
	// Test case 3: Branch if equal, branch to label if x1 equals x2
	instr = 32'h00208063;  // BEQ x1, x2, offset (Branch if x1 == x2)
	#10;
	
	// Test case 4: Branch if not equal, branch to label if x3 does not equal x4
	instr = 32'h0041A063;  // BNE x3, x4, offset (Branch if x3 != x4)
	#10;
	
	// Test case 5: Branch if less than, branch to label if x5 is less than x6 (signed comparison)
	instr = 32'h0062C063;  // BLT x5, x6, offset (Branch if x5 < x6, signed)
	#10;
	
	// Test case 6: Branch if greater than or equal, branch to label if x7 is greater than or equal to x8 (signed comparison)
	instr = 32'h00834063;  // BGE x7, x8, offset (Branch if x7 >= x8, signed)
	#10;
	
	// Test case 7: Branch if less than unsigned, branch to label if x9 is less than x10 (unsigned comparison)
	instr = 32'h00A46063;  // BLTU x9, x10, offset (Branch if x9 < x10, unsigned)
	#10;
	
	// Test case 8: Branch if greater than or equal unsigned, branch to label if x11 is greater than or equal to x12 (unsigned comparison)
	instr = 32'h00C5E063;  // BGEU x11, x12, offset (Branch if x11 >= x12, unsigned)
	#10;
	
	// Test case 9: Load byte from memory address in x1 to x15
	instr = 32'h00012783;  // LB x15, 0(x1)  (Load byte from memory at x1 into x15, sign-extended)
	#10;
	
	// Test case 10: Load halfword from memory address in x1 to x14
	instr = 32'h00012083;  // LH x14, 0(x1)  (Load halfword from memory at x1 into x14)
	#10;
	
	// Test case 11: Load word from memory address in x1 to x2
	instr = 32'h00012003;  // LW x2, 0(x1)  (Load word from memory at x1 into x2)
	#10;
	
	// Test case 12: Load byte unsigned from memory address in x1 to x16
	instr = 32'h00013783;  // LBU x16, 0(x1)  (Load byte unsigned from memory at x1 into x16, zero-extended)
	#10;
	
	// Test case 13: Load halfword unsigned from memory address in x1 to x17
	instr = 32'h00014783;  // LHU x17, 0(x1)  (Load halfword unsigned from memory at x1 into x17, zero-extended)
	#10;
	
	// Test case 14: Store byte from x3 into memory address in x2
	instr = 32'h00312223;  // SB x3, 0(x2)  (Store byte from x3 into memory at x2)
	#10;
	
	// Test case 15: Store halfword from x3 into memory address in x2
	instr = 32'h003122A3;  // SH x3, 0(x2)  (Store halfword from x3 into memory at x2)
	#10;
	
	// Test case 16: Store word from x2 into memory address in x3
	instr = 32'h00212023;  // SW x2, 0(x3)  (Store word from x2 into memory at x3)
	#10;
	
    // Test case 17: Load immediate value to register x1
	instr = 32'h00000093;  // ADDI x1, x0, 0  (Set x1 to 0)
	#10;
	
	// Test case 18: Set less than immediate signed, x1 compared to 5, result in x18
	instr = 32'h0050A293;  // SLTI x18, x1, 5  (x18 = (x1 < 5))
	#10;
	
	// Test case 19: Set less than immediate unsigned, x2 compared to 10, result in x19
	instr = 32'h00A0B293;  // SLTIU x19, x2, 10  (x19 = (x2 < 10) unsigned)
	#10;
	
	// Test case 20: Bitwise XOR immediate, x1 XOR 0x1, store result in x22
	instr = 32'h0010A393;  // XORI x22, x1, 0x1  (x22 = x1 ^ 0x1)
	#10;
	
	// Test case 21: Bitwise OR immediate, x2 OR 0x0F, store result in x21
	instr = 32'h00F0B313;  // ORI x21, x2, 0x0F  (x21 = x2 | 0x0F)
	#10;
	
	// Test case 22: Bitwise AND immediate, x1 AND 0xFF, store result in x20
	instr = 32'h0FF0A313;  // ANDI x20, x1, 0xFF  (x20 = x1 & 0xFF)
	#10;
	
	// Test case 23: Shift left logical x2 by 1, store result in x6
	instr = 32'h00112113;  // SLLI x6, x2, 1  (x6 = x2 << 1)
	#10;
	
	// Test case 24: Shift right logical x2 by 2, store result in x11
	instr = 32'h00212133;  // SRLI x11, x2, 2  (x11 = x2 >> 2)
	#10;
	
	// Test case 25: Shift right arithmetic immediate, shift x2 right by 3, store result in x23
	instr = 32'h40312113;  // SRAI x23, x2, 3  (x23 = x2 >>> 3, arithmetic shift)
	#10;
	
	// Test case 26: Add registers x1 and x2, store result in x3
	instr = 32'h002081B3;  // ADD x3, x1, x2  (x3 = x1 + x2)
	#10;
	
	// Test case 27: Subtract x2 from x3, store result in x4
	instr = 32'h402181B3;  // SUB x4, x3, x2  (x4 = x3 - x2)
	#10;
	
	// Test case 28: Shift left logical, shift x4 left by the value in x2, store result in x25
	instr = 32'h00220133;  // SLL x25, x4, x2  (x25 = x4 << x2)
	#10;
	
	// Test case 29: Set less than (signed) x1 and x2, store result in x12
	instr = 32'h0020A233;  // SLT x12, x1, x2  (x12 = (x1 < x2))
	#10;
	
	// Test case 30: Set less than (unsigned) x2 and x3, store result in x13
	instr = 32'h0030A333;  // SLTU x13, x2, x3  (x13 = (x2 < x3) unsigned)
	#10;
	
	// Test case 31: Bitwise XOR x2 and x4, store result in x8
	instr = 32'h0040A433;  // XOR x8, x2, x4  (x8 = x2 ^ x4)
	#10;
	
	// Test case 32: Shift right logical, shift x3 right by 2, store result in x24
	instr = 32'h00218133;  // SRL x24, x3, x2  (x24 = x3 >> x2, logical shift)
	#10;
	
	// Test case 33: Shift right arithmetic, shift x4 right by 4, store result in x25
	instr = 32'h40420133;  // SRA x25, x4, x2  (x25 = x4 >>> x2, arithmetic shift)
    #10;
	
	// Test case 34: Bitwise OR x1 and x3, store result in x7
	instr = 32'h0030A333;  // OR x7, x1, x3  (x7 = x1 | x3)
	#10;
	
	// Test case 35: Bitwise AND x1 and x2, store result in x5
	instr = 32'h0020A233;  // AND x5, x1, x2  (x5 = x1 & x2)
	#10;
	

	
	

    #100 $finish;
  end

  // Monitor signals
  initial begin
    $monitor("Time: %0d, PC: %0h, Instr: %0h",
             $time, pc, instr);
  end

endmodule
