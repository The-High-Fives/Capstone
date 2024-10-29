// store instructions
module forwardToMem (
    // Inputs for MEM stage instruction
    input wire [31:0] Instruction_EXMEM, // instruction in the MEM stage
    input wire [31:0] Instruction_MEMWB, // instruction in the WB stage
    input wire we_MEMWB,                     
    input wire memWrite_EXMEM, // indicates store operation in MEM stage
    
    // Data to be forwarded
    input wire [31:0] WB_data, // from MEM/WB
    
    // Data if no forwarding
    input wire [31:0] RegData2_EXMEM,

    // Output data
    output wire [31:0] RegData2_forward_M
);

    // Source/Destination registers
    wire [4:0] rs2_EXMEM;
    wire [4:0] rd_MEMWB;
    
    assign rs2_EXMEM = Instruction_EXMEM[24:20]; // Source register for store
    assign rd_MEMWB = Instruction_MEMWB[11:7];   // Destination register in WB stage

    // Forwarding for store data (rs2 in MEM stage)
    // check if rs2 in MEM matches rd in WB
    assign RegData2_forward_M = (we_MEMWB && (rd_MEMWB == rs2_EXMEM) && (rd_MEMWB != 0) && memWrite_EXMEM) ? WB_data : RegData2_EXMEM;

endmodule
