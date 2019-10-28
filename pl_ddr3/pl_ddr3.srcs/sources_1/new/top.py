module_head = 'module top\n (\n // user port\n \n // user port\n inout   [14:0]              DDR_addr,\n inout   [2:0]               DDR_ba,\n inout                       DDR_cas_n,\n inout                       DDR_ck_n,\n inout                       DDR_ck_p,\n inout                       DDR_cke,\n inout                       DDR_cs_n,\n inout   [3:0]               DDR_dm,\n inout   [31:0]              DDR_dq,\n inout   [3:0]               DDR_dqs_n,\n inout   [3:0]               DDR_dqs_p,\n inout                       DDR_odt,\n inout                       DDR_ras_n,\n inout                       DDR_reset_n,\n inout                       DDR_we_n,\n \n inout                       FIXED_IO_ddr_vrn,\n inout                       FIXED_IO_ddr_vrp,  // 接口电平参考引脚\n inout   [53:0]              FIXED_IO_mio,\n inout                       FIXED_IO_ps_clk,\n inout                       FIXED_IO_ps_porb,\n inout                       FIXED_IO_ps_srstb\n);\n'

f_src = open('../bd/cpu/hdl/cpu_wrapper.v', 'r')

is_add = False
line_number = 0
module_declare = ''
for line in f_src.readlines():
    if is_add:
        if line.find('input') == -1 and line.find('output') == -1 and line.find('inout') == -1:
            is_add = True
            break
        else:
            line = line.strip()
            line = line.replace('input', 'wire')
            line = line.replace('output', 'wire')
            line = line.replace('inout', 'wire')
            line = line + '\n'
            module_declare += line
    else:
        if line.strip() == 'inout FIXED_IO_ps_srstb;':
            is_add = True

# print(module_declare)

is_inst = False
module_inst = '\n// user code\n \n // user code\n /*\n * zynq arm系统例化, 可以从wrapper文件里直接copy\n */\n'
f_src.seek(0)
for line in f_src.readlines():
    if is_inst:
        module_inst += line
    else:
        if line.find('cpu_i') != -1:
            is_inst = True
            module_inst += line
is_inst = False
f_src.close()


f_dst = open('top.v', 'w')
f_dst.write(module_head + module_declare + module_inst)
f_dst.close()
