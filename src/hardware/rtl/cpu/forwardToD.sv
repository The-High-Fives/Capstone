// branch or jump instructions 
module forwardToD (
    // Inputs for decode stage instruction
    input wire [31:0] Instruction_IFID,    // instruction in the Decode stage
    input wire [31:0] Instruction_EXMEM,   // instruction in the MEM stage
    input wire [31:0] Instruction_MEMWB,   // instruction in the WB stage
    
    input wire we_EXMEM,                  
    input wire we_MEMWB,                  

    // Data to be forwarded
    input wire [31:0] execute_result_EXMEM, // result from EX/MEM stage
    input wire [31:0] WB_data, // data from MEM/WB stage
    
    // Data if no forwarding
    input wire [31:0] RegData1_IFID, // rs1 in D stage
    input wire [31:0] RegData2_IFID, // rs2 in D stage
    
    // Ouput data
    output wire [31:0] RegData1_forward_D, // forwarded data for rs1
    output wire [31:0] RegData2_forward_D  // forwarded data for rs2
);

    // source and destination registers
    wire [4:0] rs1_IFID, rs2_IFID;
    wire [4:0] rd_EXMEM, rd_MEMWB;
    
    assign rs1_IFID = Instruction_IFID[19:15];
    assign rs2_IFID = Instruction_IFID[24:20];
    assign rd_EXMEM = Instruction_EXMEM[11:7];
    assign rd_MEMWB = Instruction_MEMWB[11:7];

    // Forwarding for rs1
    // check if rs matched rd in MEM or WB
    // need to check if assignments are right
    wire [31:0] RegData1_MEMtoD;
    assign RegData1_MEMtoD = (we_MEMWB && (rd_MEMWB == rs1_IFID) && (rd_MEMWB != 0)) ? WB_data : RegData1_IFID;
    assign RegData1_forward_D = (rs1_IFID == 0) ? 32'b0 :
                                (we_EXMEM && (rd_EXMEM == rs1_IFID) && (rd_EXMEM != 0)) ? execute_result_EXMEM : RegData1_MEMtoD;

    // Forwarding for rs2
    wire [31:0] RegData2_MEMtoD;
    assign RegData2_MEMtoD = (we_MEMWB && (rd_MEMWB == rs2_IFID) && (rd_MEMWB != 0)) ? WB_data : RegData2_IFID;
    assign RegData2_forward_D = (rs2_IFID == 0) ? 32'b0 :
                                (we_EXMEM && (rd_EXMEM == rs2_IFID) && (rd_EXMEM != 0)) ? execute_result_EXMEM : RegData2_MEMtoD;

endmodule
