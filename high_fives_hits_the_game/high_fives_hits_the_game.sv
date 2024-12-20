
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module high_fives_hits_the_game(

	//////////// CLOCK //////////
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,
	input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// SEG7 //////////
	output		     [6:0]		HEX0,
	output		     [6:0]		HEX1,
	output		     [6:0]		HEX2,
	output		     [6:0]		HEX3,
	output		     [6:0]		HEX4,
	output		     [6:0]		HEX5,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW,

	//////////// VGA //////////
	output		          		VGA_BLANK_N,
	output		     [7:0]		VGA_B,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS,

	//////////// GPIO_0, GPIO_0 connect to GPIO Default //////////
	inout 		    [35:0]		GPIO,

	//////////// GPIO_1, GPIO_1 connect to D5M - 5M Pixel Camera //////////
	input 		    [11:0]		D5M_D,
	input 		          		D5M_FVAL,
	input 		          		D5M_LVAL,
	input 		          		D5M_PIXCLK,
	output		          		D5M_RESET_N,
	output		          		D5M_SCLK,
	inout 		          		D5M_SDATA,
	input 		          		D5M_STROBE,
	output		          		D5M_TRIGGER,
	output		          		D5M_XCLKIN
);



//=======================================================
//  REG/WIRE declarations
//=======================================================

// bootloader 
wire [3:0] bl_strobe;
wire [31:0] bl_data;
wire [13:0] bl_addr;
wire bl_stall;

// databus
wire bus_ack, bus_read, bus_write;
wire VGA_CTRL_CLK;
wire [31:0] bus_addr;
wire [31:0] bus_data_ms; // master source
wire [31:0] bus_data_ss; // slave source

// D5M
wire [11:0]	mCCD_DATA;
wire mCCD_DVAL;
reg [11:0] rCCD_DATA;
reg	rCCD_LVAL;
reg	rCCD_FVAL;

// IPU
wire [11:0] RG_RED, RG_GREEN, RG_BLUE;
wire RG_VAL;
wire [15:0] X_Cont;
wire [15:0]	Y_Cont;
wire [31:0] lut_instr_count, lut_rx_counter;

//debug
wire [9:0] debug_col, debug_row;

//=======================================================
//  Structural coding
//=======================================================

assign GPIO[3] = txd;
assign rxd = GPIO[5];

assign auto_start = ((KEY[0])&&(DLY_RST_3)&&(!DLY_RST_4))? 1'b1:1'b0;

assign	D5M_TRIGGER	=	1'b1;  // tRIGGER
assign	D5M_RESET_N	=	sys_rst_n;

Reset_Delay	u2	(	
	.iCLK(CLOCK_50),
	.iRST(KEY[0]),
	.oRST_0(DLY_RST_0),
	.oRST_1(sys_rst_n),
	.oRST_2(DLY_RST_2),
	.oRST_3(DLY_RST_3),
	.oRST_4(DLY_RST_4)
);

bootloader u_bootloader (
    .clk          (CLOCK_50),
    .rst_n        (sys_rst_n),
    .DISABLE      (SW[1]),
    // bus
    .write_o      (bus_write),
    .read_o       (bus_read),
    .data_i       (bus_data_ss),
    .data_o       (bus_data_ms),
    .ack_i        (bus_ack),
    .addr_o       (bus_addr),
    // bootloader to cpu
    .bl_strobe    (bl_strobe),
    .bl_data      (bl_data),
    .bl_addr      (bl_addr),
    .bl_stall     (bl_stall),
    //debug
    //.debug_state(debug_state),
	.lut_rx_counter(lut_rx_counter), 
    .lut_instr_count(lut_instr_count)
);

SEG7_LUT_6 	u_SEG7	(	
	.oSEG0(HEX0),.oSEG1(HEX1),
	.oSEG2(HEX2),.oSEG3(HEX3),
	.oSEG4(HEX4),.oSEG5(HEX5),
	.iDIG({2'b00, debug_col[9:0], 2'b00, debug_row[9:0]})
);


sdram_pll 			u6	(
							.refclk(CLOCK_50),
							.rst(1'b0),
							.outclk_0(sdram_ctrl_clk),
							.outclk_1(DRAM_CLK),
							.outclk_2(D5M_XCLKIN),    //25M
					      .outclk_3(VGA_CLK)       //25M

						   );
						   


spart u_spart (
    .clk        (CLOCK_50),
    .rst_n      (sys_rst_n),
    .write_i    (bus_write),
    .read_i     (bus_read),
    .addr_i     (bus_addr),
    .data_i     (bus_data_ms),
    .data_o     (bus_data_ss),
    .ack_o      (bus_ack),
    .txd        (txd),
    .rxd        (rxd)
);

//D5M read 
always@(posedge D5M_PIXCLK)
begin
	rCCD_DATA	<=	D5M_D;
	rCCD_LVAL	<=	D5M_LVAL;
	rCCD_FVAL	<=	D5M_FVAL;
end

//D5M I2C control
I2C_CCD_Config 	u8	(	//	Host Side
	.iCLK(CLOCK2_50),
	.iRST_N(~DLY_RST_2),
	.iEXPOSURE_ADJ(KEY[1]),
	.iEXPOSURE_DEC_p(SW[0]),
	.iZOOM_MODE_SW(SW[9]),
	//	I2C Side
	.I2C_SCLK(D5M_SCLK),
	.I2C_SDAT(D5M_SDATA)
);

CCD_Capture	uCCD_Capture (	
	.oDATA(mCCD_DATA),
	.oDVAL(mCCD_DVAL),
	.oX_Cont(X_Cont),
	.oY_Cont(Y_Cont),
	.oFrame_Cont(Frame_Cont),
	.iDATA(rCCD_DATA),
	.iFVAL(rCCD_FVAL),
	.iLVAL(rCCD_LVAL),
	.iSTART(!KEY[3]|auto_start),
	.iEND(!KEY[2]),
	.iCLK(~D5M_PIXCLK),
	.iRST(DLY_RST_2)
);

RAW2RGB	u_RAW2RGB	(	
	.iCLK(D5M_PIXCLK),
	.iRST(sys_rst_n),
	.iDATA(mCCD_DATA),
	.iDVAL(mCCD_DVAL),
	.oRed(RG_RED),
	.oGreen(RG_GREEN),
	.oBlue(RG_BLUE),
	.oDVAL(RG_VAL),
	.iX_Cont(X_Cont),
	.iY_Cont(Y_Cont)
);

IPU_wrapper u_IPU_wrapper (
    .camera_clk (D5M_PIXCLK),
	.sys_clk	(CLOCK_50),
    .rst_n      (sys_rst_n),
	.w_rst_n	(DLY_RST_2),
    // RGB input
    .iDVAL      (RG_VAL),
    .iRed       (RG_RED),
    .iGreen     (RG_GREEN),
    .iBlue      (RG_BLUE),
    // bus
    .write_i    (bus_write),
    .read_i     (bus_read),
    .addr_i     (bus_addr),
    .data_i     (bus_data_ms),
    .data_o     (bus_data_ss),
    .ack_o      (bus_ack),

    .debug_col  (debug_col),
    .debug_row  (debug_row)
);


//PRU and VGA
wire sys_rst_n; // reset from reset delay
wire Read;
wire	       [9:0]			oVGA_R;   				//	VGA Red[9:0]
wire	       [9:0]			oVGA_G;	 				//	VGA Green[9:0]
wire	       [9:0]			oVGA_B;   				//	VGA Blue[9:0]

assign  VGA_R = oVGA_R[9:2];
assign  VGA_G = oVGA_G[9:2];
assign  VGA_B = oVGA_B[9:2];
assign   VGA_CTRL_CLK = VGA_CLK;
wire [9:0] PRU_RED, PRU_GREEN, PRU_BLUE;
    reg [1:0] color;
    reg [8:0] row;
    reg [9:0] col;
    
    reg [9:0] width;
    reg [8:0] height_radius;
    // reg [31:0] bitmap_addr;
    reg [1:0] shape_select;
	 reg [31:0] pru_addr;
    reg [31:0] pru_data;
    reg start;
    reg subtract;
    reg i_color_load;
    // reg i_busy,i_write;
    reg done;
    reg [31:0] bitmap_addr;


cpu u_cpu (
    .clk          (CLOCK_50),
    .rst_n        (sys_rst_n),

    .b_addr_o     (bus_addr),
    .b_data_i     (bus_data_ss),
    .b_data_o     (bus_data_ms),
    .b_read_o     (bus_read),
    .b_write_o    (bus_write),
    .b_ack_i      (bus_ack),
	
	//.bl_strobe	(4'b0000),
    .bl_strobe	(bl_strobe),
	.bl_data	(bl_data),
    .bl_addr	(bl_addr),
    //.bl_stall	(1'b0)
    .bl_stall	(bl_stall)
);


PRU_Preprocessing pru_buffer (
    .clk(CLOCK_50),
    .rst_n(sys_rst_n),
    .write(bus_write),
    .data(bus_data_ms),
    .bus_addr(bus_addr),
    .bitmap_addr(bitmap_addr),
    .busy(busy),
    .color(color),
    .row(row),
    .col(col),
    .width(width),
    .height_radius(height_radius),
    .shape_select(shape_select),
    .start(start),
    .subtract(subtract),
    .color_load(i_color_load),
    .ack(bus_ack),
    .in_idle(in_idle),
    .in_load_2(in_load_2)
);

// Instantiate the PRU module
PRU DRAW (
    .clk(CLOCK_50),
    .rst_n(sys_rst_n),
    .color(color),
    .row(row),
    .col(col),
    .width(width),
    .height_radius(height_radius),
    .pru_addr(bus_addr),
    .pru_data(bus_data_ms),
    .bitmap_addr(bitmap_addr),
    .shape_select(shape_select),
    .start(start),
    .subtract(subtract),
    .busy(busy),
    .done(done),
    .color_load(i_color_load),
    .VGA_CTRL_CLK(VGA_CTRL_CLK),
    .VGA_Read(Read),                 
    .pru_red(PRU_RED),
    .pru_green(PRU_GREEN),
    .pru_blue(PRU_BLUE)
);

timer u_timer (
    .clk        (CLOCK_50),
    .rst_n      (sys_rst_n),
    // bus signals
    .write_i    (bus_write),
    .read_i     (bus_read),
    .addr_i     (bus_addr),
    .data_i     (bus_data_ms),
    .data_o     (bus_data_ss),
    .ack_o      (bus_ack)
);

led_mm u_led_mm (
    .clk        (CLOCK_50),
    .rst_n      (sys_rst_n),
    .LEDR       (LEDR),
    // bus signals
    .write_i    (bus_write),
    .read_i     (bus_read),
    .addr_i     (bus_addr),
    .data_i     (bus_data_ms),
    .data_o     (bus_data_ss),
    .ack_o      (bus_ack)
);


VGA_Controller	  u1	(	//	Host Side
							.oRequest(Read),
							.iRed(PRU_RED),
					      .iGreen(PRU_GREEN),
						   .iBlue(PRU_BLUE),
						
							//	VGA Side
							.oVGA_R(oVGA_R),
							.oVGA_G(oVGA_G),
							.oVGA_B(oVGA_B),
							.oVGA_H_SYNC(VGA_HS),
							.oVGA_V_SYNC(VGA_VS),
							.oVGA_SYNC(VGA_SYNC_N),
							.oVGA_BLANK(VGA_BLANK_N),
							//	Control Signal
							.iCLK(VGA_CTRL_CLK),
							.iRST_N(DLY_RST_2),
							.iZOOM_MODE_SW(SW[9])
						   );
endmodule
