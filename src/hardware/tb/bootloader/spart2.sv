//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:   
// Design Name: 
// Module Name:    spart 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module spart2(
    input clk,
    input rst,
    input iocs,
    input iorw,
    output rda,
    output tbr,
    input [1:0] ioaddr,
    inout [7:0] databus,
    output txd,
    input rxd
);
    wire [7:0] databus_in;

    // spart transfer
    spart_tx2 iSPART_TX(.clk(clk), .rst_n(rst), .enable(enable), .addr(ioaddr), .iocs(iocs), .tx_data(databus_in), .iorw(iorw), .TBR(tbr), .TX(txd));

    // spart receive
    spart_rx2 iSPART_RX(.clk(clk), .rst_n(rst), .enable(enable), .addr(ioaddr), .iorw(iorw), .IOCS(iocs), .RX(rxd), .RDA(rda), .rx_data(databus_in));

    // baud generator
    baud_gen2 iBAUD_GEN(.clk(clk), .rst_n(rst), .iorw(iorw), .iocs(iocs), .addr(ioaddr), .bus_data(databus_in), .enable(enable));

    // bus interface
    bus_intf2 iBUS_INTF(.iocs(iocs), .iorw(iorw), .ioaddr(ioaddr), .tbr(tbr), .rda(rda), .databus(databus), .databus_in(databus_in));
endmodule
