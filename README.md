<!-- TOC -->

- [软硬件环境](#%E8%BD%AF%E7%A1%AC%E4%BB%B6%E7%8E%AF%E5%A2%83)
- [zynq PS最小系统](#zynq-ps%E6%9C%80%E5%B0%8F%E7%B3%BB%E7%BB%9F)
    - [Hello World](#hello-world)
    - [最小系统下的端口](#%E6%9C%80%E5%B0%8F%E7%B3%BB%E7%BB%9F%E4%B8%8B%E7%9A%84%E7%AB%AF%E5%8F%A3)
    - [顶层文件模板](#%E9%A1%B6%E5%B1%82%E6%96%87%E4%BB%B6%E6%A8%A1%E6%9D%BF)
- [PS-PL数据交互方式](#ps-pl%E6%95%B0%E6%8D%AE%E4%BA%A4%E4%BA%92%E6%96%B9%E5%BC%8F)
    - [IO](#io)
        - [MIO](#mio)
        - [EMIO](#emio)
        - [GPIO](#gpio)
    - [中断](#%E4%B8%AD%E6%96%AD)
    - [FIFO](#fifo)
    - [BRAM](#bram)
    - [DMA](#dma)
    - [DDR3](#ddr3)
    - [自定义AXI接口IP](#%E8%87%AA%E5%AE%9A%E4%B9%89axi%E6%8E%A5%E5%8F%A3ip)
- [FAQ](#faq)

<!-- /TOC -->
主要学习使用PS和PL的交互方式，对于每一种交互方式，都会提供一个单独的例子.

# 软硬件环境
* ALINX7020开发板(XC7Z020-2CLG400I)
* vivado2017.4

# zynq PS最小系统
* 保留uart1外设
* 设置DDR型号
* 取消默认输出的时钟`FCLK_CLK0`和复位`FCLK_RESET0_N`
* 取消默认的`M_AXI_GP0`端口

# 如何使用demo
使用gitignore忽略了绝大部分可以重新生成的文件，所以再使用demo时必须先生成这些文件。
1. 根据bd文件，重新生成zynq cpu相关的文件(直接编译，会自动生成相关文件)
2. Export Hardware产生hdf文件
3. Launch SDK
4. 新建一个工程，将`zynq_code`放进去
  
## Hello World
- [x] [hello_world](https://gitee.com/kduant/zynq_study/tree/master/hello_world)
![pic](https://gitee.com/kduant/zynq_study/raw/master/image/min_system.png)

## 最小系统下的端口
![pic](https://gitee.com/kduant/zynq_study/raw/master/image/min_sys_pin.png)

## 顶层文件模板
修改zynq系统时可能会导致wrapper文件变化，所以不建议使用自动生成的wrapper文件作为顶层。
```verilog
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

// user code

// user code
/*
 * zynq arm系统例化, 可以从wrapper文件里直接copy
 */
  cpu cpu_i
       (.AXI_STR_RXD_0_tdata(AXI_STR_RXD_0_tdata),
        .AXI_STR_RXD_0_tlast(AXI_STR_RXD_0_tlast),
        .AXI_STR_RXD_0_tready(AXI_STR_RXD_0_tready),
        .AXI_STR_RXD_0_tvalid(AXI_STR_RXD_0_tvalid),
        .AXI_STR_TXD_0_tdata(AXI_STR_TXD_0_tdata),
        .AXI_STR_TXD_0_tlast(AXI_STR_TXD_0_tlast),
        .AXI_STR_TXD_0_tready(AXI_STR_TXD_0_tready),
        .AXI_STR_TXD_0_tvalid(AXI_STR_TXD_0_tvalid),
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

```
# PS-PL数据交互方式
## IO

|       | 个数  | 分布      | 控制              |
|-------|-------|-----------|-------------------|
|MIO    | 54    | BANK0, 1  | PS直接控制        |
|EMIO   | 64    | BANK2, 3  | 需要PL配置引脚    |
|GPIO   |       |           | AXI-GPIO          |

### MIO
- [x] [PS控制 MIO](https://gitee.com/kduant/zynq_study/tree/master/mio)

### EMIO
- [x] [PS控制PL侧EMIO](https://gitee.com/kduant/zynq_study/tree/master/ps_emio)

### GPIO
- [ ] [PS控制PL侧GPIO]()


## 中断
- [x] [PS读取PL中断](https://gitee.com/kduant/zynq_study/tree/master/pl_int)

## FIFO
FIFO类型               |    读接口    |      写接口        
----------------------|--------------|--------------
AXI Data FIFO         | AXI4-full    |  AXI4-full
AXI-Stream FIFO       | PS axi4-lite |  PL axi-stream
AXI4-Stream Data FIFO | axi-stream   |  axi-stream


通过`AXI-Stream FIFO`完成PS和PL部分的数据交互
- [x] [AXI-Stream FIFO](https://gitee.com/kduant/zynq_study/tree/master/ps_fifo_pl)
* FCLK_CLK0使用100MHz时，有警告。50MHz，125MHz没有发现警告
![pic](https://gitee.com/kduant/zynq_study/raw/master/image/axi_stream_fifo.png)

## BRAM
- [ ] [PS和PL通过BRAM交互]()

## DMA
- [x] [DMA环路](https://gitee.com/kduant/zynq_study/tree/master/dma_loop)

![loop](https://gitee.com/kduant/zynq_study/raw/master/image/dma_loop1.png)

**AXI Direct Memory Access**重要端口说明:
* S_AXI_LITE: 配置DMA工作模式
* M_AXI_MM2S：DDR到DMA数据接口
* M_AXI_S2MM：DMA数据到DDR接口
* S_AXIS_S2MM: 接收的DMA数据输出端口
* M_AXIS_MM2S: 想通过DMA输出的数据写入端口
![pic](https://gitee.com/kduant/zynq_study/raw/master/image/dma_loop.png)
- [ ] [AXI_CDMA]()

## DDR3
通过对`AXI HP`接口的操作来实现

- [ ] [PL读写PS侧DDR](https://gitee.com/kduant/zynq_study/tree/master/pl_ddr3)

原理：PL实现AXI4接口，通过`S AXI HP`接口读取ps侧DDR3数据.
例程功能：PL，PS向指定地址写数据，对方来读

> AXI-DMA：实现从PS内存到PL高速传输高速通道AXI-HP<---->AXI-Stream的转换    
> AXI-Datamover：实现从PS内存到PL高速传输高速通道AXI-HP<---->AXI-Stream的转换，只不过这次是完全由PL控制的，PS是完全被动的。       
> AXI-VDMA：实现从PS内存到PL高速传输高速通道AXI-HP<---->AXI-Stream的转换，只不过是专门针对视频、图像等二维数据的。             
> AXI-CDMA IP: 这个是由PL完成的将数据从内存的一个位置搬移到另一个位置，无需CPU来插手。这个和我们这里用的Stream没有关系          

## 自定义AXI接口IP

一般应用场景在于PS对某些寄存器的配置，传输少量的数据信息。
- [ ] [自定义AXI4-Lite接口IP](https://gitee.com/kduant/zynq_study/tree/master/user_define_ip)

# FAQ
1. 如何使用SDK 中的 Console 窗口显示串口发送的信息?         
`STDIO Connection`中选择**PS配置串口**连接到的`PC串口`。
> 串口必须连上，只是不需要另外开一个串口调试助手

2. "Error while running ps7_init method"      
A: sdk调试


3. `AXI interface port /AXI_RD is not associated to any clock port. It may not work correctly. Please update ASSOCIATED_BUSIF parameter of a clock port to include this interface port`     
A: 修改`FCLK_CLK0`为其他时钟，目前100MHz时出现过这个警告
