/******************************************************************************
*
* Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"

#include "xparameters.h"
#include "xscugic.h"
#include "xil_exception.h"
#include "xgpio.h"
// Parameter definitions
#define INTC_DEVICE_ID XPAR_PS7_SCUGIC_0_DEVICE_ID
#define LED_DEVICE_ID XPAR_AXI_GPIO_0_DEVICE_ID
#define BTNS_DEVICE_ID XPAR_AXI_GPIO_1_DEVICE_ID
#define INTC_GPIO_INTERRUPT_ID XPAR_FABRIC_AXI_GPIO_1_IP2INTC_IRPT_INTR
#define BTN_INT XGPIO_IR_CH1_MASK // This is the interrupt mask for channel one
XGpio LED;
XGpio BTNInst;
XScuGic INTCInst;
static u8 btn_value;
//----------------------------------------------------
// PROTOTYPE FUNCTIONS
//----------------------------------------------------
static void BTN_Intr_Handler(void *baseaddr_p);
static int InterruptSystemSetup(XScuGic *XScuGicInstancePtr);
static int IntcInitFunction(u16 DeviceId, XGpio *GpioInstancePtr);
// INTERRUPT SERVICE ROUTINE(ISR)
//also know as : INTERRUPT HANDLER FUNCTION
// - called by the buttons interrupt, performs push buttons read
//----------------------------------------------------
void BTN_Intr_Handler(void *InstancePtr)
{
	unsigned char led_val = 0;
	// Ignore additional button presses
	if ((XGpio_InterruptGetStatus(&BTNInst) & BTN_INT) != BTN_INT) {
		return;
		// Disable GPIO interrupts
		XGpio_InterruptDisable(&BTNInst, BTN_INT);
	}
	btn_value = ~XGpio_DiscreteRead(&BTNInst, 1)&0x0f;
	switch (btn_value)
	{
		case 0x01: led_val = 0x01; break;
		case 0x02: led_val = 0x02; break;
		case 0x04: led_val = 0x04; break;
		case 0x08: led_val = 0x08; break;
		default:break;
	}
	XGpio_DiscreteWrite(&LED,1,~led_val);
	// Acknowledge GPIO interrupts
	(void)XGpio_InterruptClear(&BTNInst, BTN_INT);
	// Enable GPIO interrupts
	XGpio_InterruptEnable(&BTNInst, BTN_INT);
}
//----------------------------------------------------
// MAIN FUNCTION
//----------------------------------------------------
int main (void)
{
	int status;
	// 刜始化挄键
	status = XGpio_Initialize(&BTNInst, BTNS_DEVICE_ID);
	if(status != XST_SUCCESS) return XST_FAILURE;
	//刜始化LED
	status = XGpio_Initialize(&LED, LED_DEVICE_ID);
	if(status != XST_SUCCESS) return XST_FAILURE;
	// 设置挄键IO癿方向为输入
	XGpio_SetDataDirection(&BTNInst, 1, 0xFF);
	//设置LED IO癿方向为输出
	XGpio_SetDataDirection(&LED, 1, 0x00);
	//设置LED 灯熄灭
	XGpio_DiscreteWrite(&LED,1,0x0f);
	// 刜始化挄键癿中断控刢器
	status = IntcInitFunction(INTC_DEVICE_ID, &BTNInst);
	if(status != XST_SUCCESS) return XST_FAILURE;
	while(1){
	}
	return (0);
}
//----------------------------------------------------
// INTERRUPT SETUP FUNCTIONS
//----------------------------------------------------
int IntcInitFunction(u16 DeviceId, XGpio *GpioInstancePtr)
{
	XScuGic_Config *IntcConfig;
	int status;
	// Interrupt controller initialization
	IntcConfig = XScuGic_LookupConfig(DeviceId);
	status = XScuGic_CfgInitialize(&INTCInst, IntcConfig,
	IntcConfig->CpuBaseAddress);
	if(status != XST_SUCCESS)
		return XST_FAILURE;
	// Call interrupt setup function
	status = InterruptSystemSetup(&INTCInst);
	if(status != XST_SUCCESS)
		return XST_FAILURE;
	// Register GPIO interrupt handler
	status = XScuGic_Connect(&INTCInst,
	INTC_GPIO_INTERRUPT_ID,
	(Xil_ExceptionHandler)BTN_Intr_Handler,
	(void *)GpioInstancePtr);
	if(status != XST_SUCCESS)
		return XST_FAILURE;
	// Enable GPIO interrupts
	XGpio_InterruptEnable(GpioInstancePtr, 1);
	XGpio_InterruptGlobalEnable(GpioInstancePtr);
	// Enable GPIO interrupts in the controller
	XScuGic_Enable(&INTCInst, INTC_GPIO_INTERRUPT_ID);
	return XST_SUCCESS;
}

int InterruptSystemSetup(XScuGic *XScuGicInstancePtr)
{
	// Register GIC interrupt handler
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
		(Xil_ExceptionHandler)XScuGic_InterruptHandler,
		XScuGicInstancePtr);
	Xil_ExceptionEnable();
	return XST_SUCCESS;
}
