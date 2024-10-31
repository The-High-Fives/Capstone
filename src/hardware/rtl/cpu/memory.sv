module memory (
    input logic clk,
    input logic rst_n,

    // Control signals from EX/MEM buffer
    input logic m_MemRead,         // Memory read enable
    input logic m_MemWrite,        // Memory write enable 
    input m_JAL,
    input m_LUI,

    // Data signals from EX/MEM buffer
    input logic [31:0] m_alu_out,      
    input logic [31:0] m_mem_data, // Data to write to memory
    input [31:0] wb_data, // Data forwarded from writeback
    input wb_forward, // selects data source for memory writes
    input [31:0]       m_imm,
    input logic [31:0] m_pc_inc,
    input logic [4:0] m_rd,          

    // Stall control
    output logic stall_mem,           // Stall signal for memory read delay

    // Output signals to MEM/WB buffer
    output logic [31:0] read_data_MEMWB, // Data read from memory for WB stage
    output logic [31:0] reg_data_MEMWB       

    // Memory interface
    // output logic [31:0] memory_data_out, // Data to memory (write)
    // input  logic [31:0] memory_data_in,  // Data from memory (read)
    // output logic [14:0] memory_addr,     // Memory address
    // output logic memory_we,              // Memory write enable
    // output logic memory_re               // Memory read enable
);

    assign reg_data = m_JAL ? m_pc_inc : 
                      m_LUI ? m_imm : m_alu_out;

    assign write_data = wb_forward ? wb_data : m_mem_data;

    // Bank selection (use bits [3:2] of address to select one of the four banks)
    logic [1:0] bank_select;
    assign bank_select = m_alu_out[3:2]; // Use bits [3:2] for bank selection

    // Output data from each memory bank
    logic [31:0] bank_rdata[0:3];

    // Instantiate four banks of dmem32 for the memory
    // Use bits [17:2] as address within the bank
    dmem32 dmem_bank0 (.clk(clk), .rst_n(rst_n), .addr(m_alu_out[17:2]), .re(m_MemRead && (bank_select == 2'b00)),
                        .we(m_MemWrite && (bank_select == 2'b00)), .wdata(write_data), .rdata(bank_rdata[0]));

    dmem32 dmem_bank1 (.clk(clk), .rst_n(rst_n), .addr(m_alu_out[17:2]), .re(m_MemRead && (bank_select == 2'b01)),
                        .we(m_MemWrite && (bank_select == 2'b01)), .wdata(write_data), .rdata(bank_rdata[1]));

    dmem32 dmem_bank2 (.clk(clk), .rst_n(rst_n), .addr(m_alu_out[17:2]), .re(m_MemRead && (bank_select == 2'b10)),
                        .we(m_MemWrite && (bank_select == 2'b10)), .wdata(write_data), .rdata(bank_rdata[2]));

    dmem32 dmem_bank3 (.clk(clk), .rst_n(rst_n), .addr(m_alu_out[17:2]), .re(m_MemRead && (bank_select == 2'b11)),
                        .we(m_MemWrite && (bank_select == 2'b11)), .wdata(write_data), .rdata(bank_rdata[3]));

    // Memory read data multiplexing based on selected bank
    always_comb begin
        case (bank_select)
            2'b00: read_data_MEMWB = bank_rdata[0];
            2'b01: read_data_MEMWB = bank_rdata[1];
            2'b10: read_data_MEMWB = bank_rdata[2];
            2'b11: read_data_MEMWB = bank_rdata[3];
            default: read_data_MEMWB = 32'h0; // Default to zero if no valid bank is selected
        endcase
    end

    // Stall signal for memory reads (set if MemRead is high and data is being accessed)
    // assign stall_mem = m_MemRead;
    assign stall_mem = 0;

    // Memory interface signals (for compatibility with any external memory systems)
    // assign memory_data_out = m_mem_data;     // Data to write to memory
    // assign memory_addr = m_alu_out[16:2];    // Address for memory access (assuming 4-byte aligned)
    // assign memory_we = m_MemWrite;           // Write enable for memory
    // assign memory_re = m_MemRead;            // Read enable for memory

endmodule
