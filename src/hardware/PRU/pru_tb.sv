module  VGA_tb();
    //Image calc to manipulate bit map
    //Internal Storage
    //Buffer
    //Writing to VGA Interface

    //readmemh();
	logic iclk, irst_n, iVGA_CLK, i_color_load, iREAD;
	logic [31:0] ipru_addr, idata;
	VGA_converter iDUT (.clk(iclk), .rst_n(irst_n), .VGA_CTRL_CLK(iVGA_CLK),.pru_addr(ipru_addr), .pru_data(idata), .VGA_Read(iREAD), 
		.color_load(i_color_load),
		.pru_red(),
		.pru_green(),
		.pru_blue());

	always #5 iclk = ~iclk;
	always #10 iVGA_CLK= ~iVGA_CLK;

    //Output
    initial begin
		// Initialize inputs
		iclk = 0;
		iVGA_CLK = 1; 
		irst_n = 1;
		iREAD = 0;
		i_color_load = 0;
		
		// Reset the system
        repeat (5) @(posedge iclk); 
        irst_n = 0;
				// Reset the system
        repeat (5) @(posedge iclk);
		        irst_n = 1;
        repeat (5) @(posedge iclk); 
        iREAD = 1;
				// Reset the system
        repeat (100) @(posedge iclk);
		iREAD = 0;
		repeat (1000) @(posedge iclk);
		$stop;
	end
endmodule
