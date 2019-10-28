set_property -dict {PACKAGE_PIN M14 IOSTANDARD LVCMOS33} [get_ports test_port]





connect_debug_port u_ila_0/probe4 [get_nets [list AXI_RX_tvalid1]]





create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 8192 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list cpu_i/processing_system7_0/inst/FCLK_CLK0]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 32 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {AXI_TX_tdata[0]} {AXI_TX_tdata[1]} {AXI_TX_tdata[2]} {AXI_TX_tdata[3]} {AXI_TX_tdata[4]} {AXI_TX_tdata[5]} {AXI_TX_tdata[6]} {AXI_TX_tdata[7]} {AXI_TX_tdata[8]} {AXI_TX_tdata[9]} {AXI_TX_tdata[10]} {AXI_TX_tdata[11]} {AXI_TX_tdata[12]} {AXI_TX_tdata[13]} {AXI_TX_tdata[14]} {AXI_TX_tdata[15]} {AXI_TX_tdata[16]} {AXI_TX_tdata[17]} {AXI_TX_tdata[18]} {AXI_TX_tdata[19]} {AXI_TX_tdata[20]} {AXI_TX_tdata[21]} {AXI_TX_tdata[22]} {AXI_TX_tdata[23]} {AXI_TX_tdata[24]} {AXI_TX_tdata[25]} {AXI_TX_tdata[26]} {AXI_TX_tdata[27]} {AXI_TX_tdata[28]} {AXI_TX_tdata[29]} {AXI_TX_tdata[30]} {AXI_TX_tdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 32 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {AXI_RX_tdata[0]} {AXI_RX_tdata[1]} {AXI_RX_tdata[2]} {AXI_RX_tdata[3]} {AXI_RX_tdata[4]} {AXI_RX_tdata[5]} {AXI_RX_tdata[6]} {AXI_RX_tdata[7]} {AXI_RX_tdata[8]} {AXI_RX_tdata[9]} {AXI_RX_tdata[10]} {AXI_RX_tdata[11]} {AXI_RX_tdata[12]} {AXI_RX_tdata[13]} {AXI_RX_tdata[14]} {AXI_RX_tdata[15]} {AXI_RX_tdata[16]} {AXI_RX_tdata[17]} {AXI_RX_tdata[18]} {AXI_RX_tdata[19]} {AXI_RX_tdata[20]} {AXI_RX_tdata[21]} {AXI_RX_tdata[22]} {AXI_RX_tdata[23]} {AXI_RX_tdata[24]} {AXI_RX_tdata[25]} {AXI_RX_tdata[26]} {AXI_RX_tdata[27]} {AXI_RX_tdata[28]} {AXI_RX_tdata[29]} {AXI_RX_tdata[30]} {AXI_RX_tdata[31]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list AXI_RX_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list AXI_RX_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list AXI_RX_tvalid]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list AXI_TX_tlast]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list AXI_TX_tready]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list AXI_TX_tvalid]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets FCLK_CLK0_0]
