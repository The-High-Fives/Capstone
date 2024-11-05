import alu_definitions::*;

module alu(alu_op1, alu_op2, alu_ctrl, alu_result);
	input [31:0] alu_op1;
	input [31:0] alu_op2;
	input alu_ctrl_t [3:0] alu_ctrl;
	output logic [31:0] alu_result;

	always_comb begin
		alu_result = 0;
		
		case (alu_ctrl)
			ALU_ADD: alu_result = alu_op1 + alu_op2;
			ALU_SUB: alu_result = alu_op1 - alu_op2;
			ALU_XOR: alu_result = alu_op1 ^ alu_op2;
			ALU_OR: alu_result = alu_op1 | alu_op2;
			ALU_AND: alu_result = alu_op1 & alu_op2;
			
			ALU_SLL: alu_result = alu_op1 << alu_op2[4:0];
			ALU_SRL: alu_result = alu_op1 >> alu_op2[4:0];
			ALU_SRA: alu_result = $signed(alu_op1) >>> alu_op2[4:0];
			
			ALU_SLT: alu_result = ($signed(alu_op1) < $signed(alu_op2));
			ALU_SLTU: alu_result = (alu_op1 < alu_op2);
		endcase
	end

endmodule