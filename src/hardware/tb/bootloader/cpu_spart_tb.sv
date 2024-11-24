module cpu_spart_tb ();

	logic rst_n, clk;
	
	wire [31:0] b_addr, b_data_ms, b_data_ss;
	wire b_write, b_read, b_ack;
	
	wire [3:0] bl_strobe;
	wire [31:0] bl_data;
	wire [13:0] bl_addr;
	wire bl_stall;
	
	logic txd, rxd;

	wire [7:0] databus;
    logic [1:0] ioaddr;
    logic iorw, iocs;

    logic db_w; // drive databus when high
    logic [7:0] db_data; // databus to drive databus
	assign databus = db_w  ? db_data : 8'hzz;
	
cpu u_cpu (
    .clk          (clk),
    .rst_n        (rst_n),

    .b_addr_o     (b_addr),
    .b_data_i     (b_data_ss),
    .b_data_o     (b_data_ms),
    .b_read_o     (b_read),
    .b_write_o    (b_write),
    .b_ack_i      (b_ack),
	
	.bl_strobe	(bl_strobe),
	.bl_data	(bl_data),
    .bl_addr	(bl_addr),
    .bl_stall	(bl_stall)
);

spart u_spart (
    .clk        (clk),
    .rst_n      (rst_n),
    .write_i    (b_write),
    .read_i     (b_read),
    .addr_i     (b_addr),
    .data_i     (b_data_ms),
    .data_o     (b_data_ss),
    .ack_o      (b_ack),
    .txd        (txd),
    .rxd        (rxd)
);

bootloader u_bootloader (
    .clk          (clk),
    .rst_n        (rst_n),
    // bus
    .write_o      (b_write),
    .read_o       (b_read),
    .data_i       (b_data_ss),
    .data_o       (b_data_ms),
    .ack_i        (b_ack),
    .addr_o       (b_addr),
    // bootloader to cpu
    .bl_strobe    (bl_strobe),
    .bl_data      (bl_data),
    .bl_addr      (bl_addr),
    .bl_stall     (bl_stall)
);

spart2 spart_tb(.clk(clk),
            .rst(rst_n),
            .iocs(iocs),
            .iorw(iorw),
            .rda(rda),
            .tbr(tbr),
            .ioaddr(ioaddr),
            .databus(databus),
            .txd(rxd),
            .rxd(txd)
);

assign iocs = 1'b1;

initial begin
	clk = 0;
	rst_n = 0;

    iorw = 1;
    ioaddr = 2'b01;
    db_data = 8'h00;
    db_w = 1'b0;
	
	#15;
	rst_n = 1;
	
	fork
        // wait for response
        begin
            @(posedge rda);
            disable timeout;
            @(posedge clk);
            #1;

            // rx buffer read
            if (!rda)
                $display("ERROR: RDA unset before read");
            ioaddr = 2'b00;
            iorw = 1;
            #1;
            $display("Data received: %h", databus);

            @(posedge clk);
            #1;
            ioaddr = 2'b01;
        end 
        // timeout
        begin : timeout
            #40000000;
            $display("ERROR: No signal received");
            $stop();
        end : timeout
    join
	
	send_instruction(13); // set instruction count
	
	//send_instruction(32'h67800093);
	//send_instruction(32'h01c00113);
	//send_instruction(32'h00110023);

    send_instruction(32'h01c00093);
    send_instruction(32'h05200113);
    send_instruction(32'h00208023);
    send_instruction(32'h04500113);
    send_instruction(32'h00208023);
    send_instruction(32'h04100113);
    send_instruction(32'h00208023);
    send_instruction(32'h04400113);
    send_instruction(32'h00208023);
    send_instruction(32'h05900113);
    send_instruction(32'h00208023);
    send_instruction(32'h05d00893);
    send_instruction(32'h00000073);

	 
	while (!tbr) begin
		@(posedge clk);
	end
	#100000000;
	$stop;
end

always
	#10 clk = ~clk;

// sends an instruction
task automatic send_instruction(bit [31:0] instr);
    // write to tx buffer
    @(posedge clk);
    #1;
    while (!tbr) begin
		@(posedge clk);
	end
    ioaddr = 2'b00;
    iorw = 0;
    db_data = instr[7:0];
    db_w = 1;
    @(posedge clk);
    #1;
    ioaddr = 2'b01;
    iorw = 1;
    db_w = 0;
	
	@(posedge clk);
    #1;
    while (!tbr) begin
		@(posedge clk);
	end
    ioaddr = 2'b00;
    iorw = 0;
    db_data = instr[15:8];
    db_w = 1;
    @(posedge clk);
    #1;
    ioaddr = 2'b01;
    iorw = 1;
    db_w = 0;
	
	@(posedge clk);
    #1;
    while (!tbr) begin
		@(posedge clk);
	end
    ioaddr = 2'b00;
    iorw = 0;
    db_data = instr[23:16];
    db_w = 1;
    @(posedge clk);
    #1;
    ioaddr = 2'b01;
    iorw = 1;
    db_w = 0;
	
	@(posedge clk);
    #1;
    while (!tbr) begin
		@(posedge clk);
	end
    ioaddr = 2'b00;
    iorw = 0;
    db_data = instr[31:24];
    db_w = 1;
    @(posedge clk);
    #1;
    ioaddr = 2'b01;
    iorw = 1;
    db_w = 0;
endtask
endmodule