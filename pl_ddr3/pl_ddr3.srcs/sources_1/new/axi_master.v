/*=============================================================================
# FileName    :	axi_master.v
# Author      :	author
# Email       :	email@email.com
# Description :	axi_write_enable = 1时，从指定地址一直写入数据 
# Version     :	1.0
# LastChange  :	2018-09-19 14:03:19
# ChangeLog   :	
=============================================================================*/
`timescale  1 ns/1 ps

module axi_master #
(
    parameter C_M_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
    parameter C_M_AXI_BURST_LEN	= 16,
    parameter C_M_AXI_ID_WIDTH	= 6,
    parameter C_M_AXI_ADDR_WIDTH	= 32,
    parameter C_M_AXI_DATA_WIDTH	= 64
)
(
    input   wire                                m_axi_clk,
    input   wire                                m_axi_aresetn,

    input   wire                                axi_write_enable,

    output  wire [07:00]                        m_axi_awlen,        // x
    output  wire [02:00]                        m_axi_awsize,       // x
    output  wire [01:00]                        m_axi_awburst,      // x
    output  wire [01:00]                        m_axi_awlock,       // x
    output  wire [03:00]                        m_axi_awcache,      // x
    output  wire [02:00]                        m_axi_awprot,       // x

    output  wire [C_M_AXI_ID_WIDTH-1:00]        m_axi_awid,         // x
    output  wire [31:00]                        m_axi_awaddr,
    output  reg                                 m_axi_awvalid,
    input   wire                                m_axi_awready,

    output  wire [C_M_AXI_ID_WIDTH-1:00]        m_axi_wid,          // x
    output  reg  [C_M_AXI_DATA_WIDTH-1:00]      m_axi_wdata,
    output  wire [C_M_AXI_DATA_WIDTH/8-1:00]    m_axi_wstrb,
    output  reg                                 m_axi_wvalid,
    input   wire                                m_axi_wready,
    output  reg                                 m_axi_wlast,        // x

    input   wire [C_M_AXI_ID_WIDTH-1:00]        m_axi_bid,          // x
    input   wire [01:00]                        m_axi_bresp,
    input   wire                                m_axi_bvalid,
    output  reg                                 m_axi_bready,

    output  wire [C_M_AXI_ID_WIDTH-1:00]        m_axi_arid,         // x
    output  wire [C_M_AXI_ADDR_WIDTH-1:00]      m_axi_araddr,
    output  wire [07:00]                        m_axi_arlen,        // x
    output  wire [02:00]                        m_axi_arsize,       // x
    output  wire [01:00]                        m_axi_arburst,      // x
    output  wire                                m_axi_arvalid,
    input   wire                                m_axi_arready,
    output  wire [01:00]                        m_axi_arlock,       // x
    output  wire [03:00]                        m_axi_arcache,      // x
    output  wire [02:00]                        m_axi_arprot,       // x

    input   wire [C_M_AXI_ID_WIDTH-1:00]        m_axi_rid,          // x
    input   wire [C_M_AXI_DATA_WIDTH-1:00]      m_axi_rdata,
    input   wire [01:00]                        m_axi_rresp,
    input   wire                                m_axi_rlast,        // x
    input   wire                                m_axi_rvalid,
    output  wire                                m_axi_rready
);

wire    [07:00]             burst_size_bytes;
function integer clogb2 (input integer bit_depth);
    begin
        for(clogb2 = 0; bit_depth > 0; clogb2 = clogb2 + 1)
            bit_depth = bit_depth >> 1;
    end
endfunction

assign m_axi_awid	= 0;
assign m_axi_wid	= 0;
assign m_axi_awburst	= 2'b01;
assign m_axi_awlen	= C_M_AXI_BURST_LEN - 1;
assign m_axi_awsize	= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
assign m_axi_awlock	= 1'b0;
assign m_axi_awcache	= 4'b0010;
assign m_axi_awprot	= 3'h0;
assign m_axi_awqos	= 4'h0;

assign m_axi_arid	= 0;
assign m_axi_arlen	= C_M_AXI_BURST_LEN - 1;
assign m_axi_arsize	= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
assign m_axi_arburst	= 2'b01;

assign m_axi_wstrb	= {(C_M_AXI_DATA_WIDTH/8){1'b1}};

assign burst_size_bytes	= C_M_AXI_BURST_LEN * C_M_AXI_DATA_WIDTH/8;
/*
 * 简单的axi4状态机，不支持高级功能，各通道分时操作
 */
reg     [07:00]             wr_cnt;
localparam              IDLE        = 0;
localparam              WR_ADDR     = 1;
localparam              WR_DATA     = 2;
localparam              WR_RESP     = 3;
localparam              RD_ADDR     = 4;
localparam              RD_RESP     = 5;
localparam              OVER        = 6;
(* KEEP = "TRUE" *)reg     [OVER:00]       cs = 'd1, ns = 'd1;
reg     [15:00]         state_cnt;

// synthesis translate_off
reg [127:0] cs_STRING;
always @(*)
begin
    case(1'b1)
        cs[IDLE]: cs_STRING = "IDLE";
        cs[WR_ADDR]: cs_STRING = "WR_ADDR";
        cs[WR_DATA]: cs_STRING = "WR_DATA";
        cs[WR_RESP]: cs_STRING = "WR_RESP";
        cs[RD_ADDR]: cs_STRING = "RD_ADDR";
        cs[RD_RESP]: cs_STRING = "RD_RESP";
        default: cs_STRING = "XXXX";
    endcase
end
// synthesis translate_on

always @(posedge m_axi_clk)
begin
    if(~m_axi_aresetn)
        cs <= 'd1;
    else
        cs <= ns;
end

always @(*)
begin
    ns = 'd0;
    case(1'b1)
        cs[IDLE]:
        begin
            if(axi_write_enable & m_axi_awready)
                ns[WR_ADDR] = 1'b1;
            else
                ns[IDLE] = 1'b1;
        end
        cs[WR_ADDR]:
        begin
            ns[WR_DATA] = 1'b1;
        end
        cs[WR_DATA]:
        begin
            if(wr_cnt == C_M_AXI_BURST_LEN -1)
                ns[WR_RESP] = 1'b1;
            else
                ns[WR_DATA] = 1'b1;
        end
        cs[WR_RESP]:
        begin
            if(m_axi_bvalid & m_axi_bready)
            begin
                if(axi_write_enable)
                    ns[WR_ADDR] = 1'b1;
                else
                    ns[RD_ADDR] = 1'b1;
            end
            else
                ns[WR_RESP] = 1'b1;
        end
        cs[RD_ADDR]:
        begin
            ns[RD_ADDR] = 1'b1;
        end
        default:
            ns[IDLE] = 1'b1;
    endcase
end

always @ (posedge m_axi_clk)
begin
    if(~m_axi_aresetn)
        state_cnt <= 0;
    else if (cs != ns)
        state_cnt <= 0;
    else
        state_cnt <= state_cnt + 1'b1;
end

always @ (posedge m_axi_clk)
begin
    if(~m_axi_aresetn)
        m_axi_awvalid <= 0;
    else if(cs[WR_ADDR])
        m_axi_awvalid <= 1;
    else
        m_axi_awvalid <= 0;
end

/*
 * 地址自增
 */
reg     [C_M_AXI_ADDR_WIDTH-1:00]             axi_awaddr;
assign                  m_axi_awaddr = axi_awaddr + C_M_TARGET_SLAVE_BASE_ADDR;
always @ (posedge m_axi_clk)
begin
    if(~m_axi_aresetn)
        axi_awaddr <= 0;
    else if(m_axi_awvalid & m_axi_awready)
        axi_awaddr <= axi_awaddr + 'd4;
end

always @ (posedge m_axi_clk)
begin
    if(~m_axi_aresetn)
        m_axi_bready <= 0;
    else if(~m_axi_bready & m_axi_bvalid)
        m_axi_bready <= 1;
    else
        m_axi_bready <= 0;
end

always @ (posedge m_axi_clk)
begin
    if(~m_axi_aresetn)
        wr_cnt <= 0;
    else if(m_axi_wvalid & m_axi_wready)
        wr_cnt <= wr_cnt + 1'b1;
    else if(m_axi_bvalid)
        wr_cnt <= 0;
end

always @ (*)
begin
    if(m_axi_wvalid & m_axi_wready)
        m_axi_wdata = ({$random} % 65536);
    else
        m_axi_wdata = 0;
end

always @ (posedge m_axi_clk)
begin
    if(~m_axi_aresetn)
        m_axi_wvalid <= 0;
    else if(cs[WR_ADDR])
        m_axi_wvalid <= 1;
    else if(m_axi_wlast)
        m_axi_wvalid <= 0;
end

always @ (*)
begin
    if(m_axi_awlen == 0)
        m_axi_wlast = m_axi_wvalid & m_axi_wready;
    else
    begin
        m_axi_wlast = (cs[WR_DATA] & (wr_cnt == C_M_AXI_BURST_LEN-1));
    end
end
endmodule
