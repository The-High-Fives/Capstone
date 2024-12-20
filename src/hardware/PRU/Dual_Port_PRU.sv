module Dual_Port_PRU(clk,we,re_addr,wr_addr,wrt_data,rd_data);
input clk;
input we;
input [18:0] re_addr;
input [1:0] wrt_data;
input [18:0] wr_addr;

output reg [1:0] rd_data;

reg [1:0] imagebuffer [307199:0];

always @ (posedge clk) begin
    if (we)
        imagebuffer[wr_addr] <= wrt_data;
    rd_data <= imagebuffer[re_addr];
end
        

initial begin
    $readmemb("307199_zeroes.mem", imagebuffer);
end

endmodule