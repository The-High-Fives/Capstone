package br_definitions;
	typedef enum logic [2:0] {
		BR_BEQ,
		BR_BNE,
		BR_NONE,	// DO NOT BRANCH
		BR_BLT = 3'b100,
		BR_BGE,
		BR_BLTU,
		BR_BGEU
	} br_func_t;
endpackage

package alu_definitions;
	typedef enum logic [3:0] {
		ALU_ADD,
		ALU_SUB,
		ALU_XOR,
		ALU_OR,
		ALU_AND,
		ALU_SLL,
		ALU_SRL,
		ALU_SRA,
		ALU_SLT,
		ALU_SLTU
	} alu_ctrl_t;	
endpackage

package sext_definitions;
	typedef enum logic [2:0] {
		sext_I_type,	// sign extend immediate
		sext_U_type,	// left shift by 12
		sext_S_type,
		sext_J_type,
		sext_B_type		// calculate imm for branch
	} sext_ctrl_t;
endpackage

package pc_defnitions;
	typedef enum logic [1:0] {
		PC_INC,
		PC_BR,
		PC_JAL
	} pc_source_t;
endpackage

package mem_definitions;
	typedef enum logic [2:0] {
		MEM_BYTE,
		MEM_HALF,
		MEM_WORD,
		MEM_UBYTE,
		MEM_UHALF
	} mem_mask_t;
endpackage