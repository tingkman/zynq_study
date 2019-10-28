module top
 (
 // user port
 
 // user port
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
wire [31:0]s_axi_araddr;
wire [1:0]s_axi_arburst;
wire [3:0]s_axi_arcache;
wire [5:0]s_axi_arid;
wire [7:0]s_axi_arlen;
wire [0:0]s_axi_arlock;
wire [2:0]s_axi_arprot;
wire [3:0]s_axi_arqos;
wire s_axi_arready;
wire [3:0]s_axi_arregion;
wire [2:0]s_axi_arsize;
wire s_axi_arvalid;
wire [31:0]s_axi_awaddr;
wire [1:0]s_axi_awburst;
wire [3:0]s_axi_awcache;
wire [5:0]s_axi_awid;
wire [7:0]s_axi_awlen;
wire [0:0]s_axi_awlock;
wire [2:0]s_axi_awprot;
wire [3:0]s_axi_awqos;
wire s_axi_awready;
wire [3:0]s_axi_awregion;
wire [2:0]s_axi_awsize;
(*mark_debug="true"*)wire s_axi_awvalid;
wire [5:0]s_axi_bid;
wire s_axi_bready;
wire [1:0]s_axi_bresp;
wire s_axi_bvalid;
wire [63:0]s_axi_rdata;
wire [5:0]s_axi_rid;
wire s_axi_rlast;
wire s_axi_rready;
wire [1:0]s_axi_rresp;
wire s_axi_rvalid;
wire [63:0]s_axi_wdata;
wire s_axi_wlast;
wire s_axi_wready;
wire [7:0]s_axi_wstrb;
wire s_axi_wvalid;

wire                        FCLK_CLK0_0;
wire                        FCLK_RESET0;
// user code
axi_master #
(
    .C_M_TARGET_SLAVE_BASE_ADDR  (  32'h40000000                ),
    .C_M_AXI_BURST_LEN           (  16                          ),
    .C_M_AXI_ID_WIDTH            (  6                           ),
    .C_M_AXI_ADDR_WIDTH          (  32                          ),
    .C_M_AXI_DATA_WIDTH          (  64                          )
)
axi_masterEx01
(
    .m_axi_clk                         (  clk                             ),
    .m_axi_aresetn                     (  reset_n                         ),
    .axi_write_enable                   (  1                       ),
    .m_axi_awid                  (  m_axi_awid                      ),
    .m_axi_awaddr                (  m_axi_awaddr                    ),
    .m_axi_awlen                 (  m_axi_awlen                     ),
    .m_axi_awsize                (  m_axi_awsize                    ),
    .m_axi_awburst               (  m_axi_awburst                   ),
    .m_axi_awvalid               (  m_axi_awvalid                   ),
    .m_axi_awready               (  m_axi_awready                   ),
    .m_axi_awlock                (  m_axi_awlock                    ),
    .m_axi_awcache               (  m_axi_awcache                   ),
    .m_axi_awprot                (  m_axi_awprot                    ),
    .m_axi_wid                   (  m_axi_wid                       ),
    .m_axi_wdata                 (  m_axi_wdata                     ),
    .m_axi_wstrb                 (  m_axi_wstrb                     ),
    .m_axi_wlast                 (  m_axi_wlast                     ),
    .m_axi_wvalid                (  m_axi_wvalid                    ),
    .m_axi_wready                (  m_axi_wready                    ),
    .m_axi_bid                   (  m_axi_bid                       ),
    .m_axi_bresp                 (  m_axi_bresp                     ),
    .m_axi_bvalid                (  m_axi_bvalid                    ),
    .m_axi_bready                (  m_axi_bready                    ),
    .m_axi_arid                  (  m_axi_arid                      ),
    .m_axi_araddr                (  m_axi_araddr                    ),
    .m_axi_arlen                 (  m_axi_arlen                     ),
    .m_axi_arsize                (  m_axi_arsize                    ),
    .m_axi_arburst               (  m_axi_arburst                   ),
    .m_axi_arvalid               (  m_axi_arvalid                   ),
    .m_axi_arready               (  m_axi_arready                   ),
    .m_axi_arlock                (  m_axi_arlock                    ),
    .m_axi_arcache               (  m_axi_arcache                   ),
    .m_axi_arprot                (  m_axi_arprot                    ),
    .m_axi_rid                   (  m_axi_rid                       ),
    .m_axi_rdata                 (  m_axi_rdata                     ),
    .m_axi_rresp                 (  m_axi_rresp                     ),
    .m_axi_rlast                 (  m_axi_rlast                     ),
    .m_axi_rvalid                (  m_axi_rvalid                    ),
    .m_axi_rready                (  m_axi_rready                    )
);
 // user code
 /*
 * zynq arm系统例化, 可以从wrapper文件里直接copy
 */
  cpu cpu_i
       (.DDR_addr(DDR_addr),
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
        .FCLK_RESET0(FCLK_RESET0),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arburst(s_axi_arburst),
        .s_axi_arcache(s_axi_arcache),
        .s_axi_arid(s_axi_arid),
        .s_axi_arlen(s_axi_arlen),
        .s_axi_arlock(s_axi_arlock),
        .s_axi_arprot(s_axi_arprot),
        .s_axi_arqos(s_axi_arqos),
        .s_axi_arready(s_axi_arready),
        .s_axi_arregion(s_axi_arregion),
        .s_axi_arsize(s_axi_arsize),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awburst(s_axi_awburst),
        .s_axi_awcache(s_axi_awcache),
        .s_axi_awid(s_axi_awid),
        .s_axi_awlen(s_axi_awlen),
        .s_axi_awlock(s_axi_awlock),
        .s_axi_awprot(s_axi_awprot),
        .s_axi_awqos(s_axi_awqos),
        .s_axi_awready(s_axi_awready),
        .s_axi_awregion(s_axi_awregion),
        .s_axi_awsize(s_axi_awsize),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bid(s_axi_bid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rid(s_axi_rid),
        .s_axi_rlast(s_axi_rlast),
        .s_axi_rready(s_axi_rready),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wlast(s_axi_wlast),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid));
endmodule
