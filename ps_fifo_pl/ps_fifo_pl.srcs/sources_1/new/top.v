`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/09/11 15:51:30
// Design Name: 
// Module Name: top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top
(
    output  reg                 test_port,
    inout   [14:0]              DDR_addr,
    inout   [2:0]               DDR_ba,
    inout                       DDR_cas_n,
    inout                       DDR_ck_n,
    inout                       DDR_ck_p,
    inout                       DDR_cke,
    inout                       DDR_cs_n,
    inout   [3:0]               DDR_dm,
    inout   [31:0]              DDR_dq,
    inout   [3:0]               DDR_dqs_n,
    inout   [3:0]               DDR_dqs_p,
    inout                       DDR_odt,
    inout                       DDR_ras_n,
    inout                       DDR_reset_n,
    inout                       DDR_we_n,
    
    inout                       FIXED_IO_ddr_vrn,
    inout                       FIXED_IO_ddr_vrp,  // 接口电平参考引脚
    inout   [53:0]              FIXED_IO_mio,
    inout                       FIXED_IO_ps_clk,
    inout                       FIXED_IO_ps_porb,
    inout                       FIXED_IO_ps_srstb
);
(* keep="true" *)wire    [31:0]AXI_RX_tdata;
(* keep="true" *)wire    AXI_RX_tlast;
(* keep="true" *)wire    AXI_RX_tready;
(* keep="true" *)wire    AXI_RX_tvalid;

(* keep="true" *)wire    [31:0]AXI_TX_tdata;
(* keep="true" *)wire    AXI_TX_tlast;
(* keep="true" *)wire    AXI_TX_tready;
(* keep="true" *)wire    AXI_TX_tvalid;

wire    FCLK_CLK0_0;

always @(posedge FCLK_CLK0_0)
begin
    test_port <= (&AXI_TX_tdata) & AXI_TX_tlast & AXI_TX_tvalid & AXI_RX_tready & (&AXI_RX_tdata & AXI_RX_tvalid & AXI_RX_tlast);
end
assign                  AXI_TX_tready = 1'b1;


reg     [15:00]             cnt = 0;
always @ (posedge FCLK_CLK0_0)
begin
    cnt <= cnt + 1'b1;
end

//assign                  AXI_RX_tvalid = ((cnt >= 10) & (cnt <= 100)) ? 1 : 0;
//assign                  AXI_RX_tlast = (cnt == 100) ? 1 : 0;
assign                  AXI_RX_tvalid = 1;
assign                  AXI_RX_tdata = {15'b0, cnt};

  cpu cpu_i
       (.AXI_RX_tdata(AXI_RX_tdata),
        .AXI_RX_tlast(AXI_RX_tlast),
        .AXI_RX_tready(AXI_RX_tready),
        .AXI_RX_tvalid(AXI_RX_tvalid),
        .AXI_TX_tdata(AXI_TX_tdata),
        .AXI_TX_tlast(AXI_TX_tlast),
        .AXI_TX_tready(AXI_TX_tready),
        .AXI_TX_tvalid(AXI_TX_tvalid),
        .DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FCLK_CLK0_0(FCLK_CLK0_0),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb));
endmodule
