module Single_Port_PRU_l(clk,re,re_addr,wr_addr,wrt_data,rd_data);
input clk;
input re;
input [18:0] re_addr;
input [1:0] wrt_data;
input [18:0] wr_addr;

output reg rd_data;

reg imagebuffer [20479:0];

always @ (posedge clk) begin
	if (re)     
    rd_data <= imagebuffer[re_addr];
end     

initial begin
    $readmemb("Letters.mem", imagebuffer);
end

endmodule
