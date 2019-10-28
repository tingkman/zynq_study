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

#include "xgpiops.h"
#include "sleep.h"
int main()
{
#if 0
    static XGpioPs psGpioInstancePtr;
    XGpioPs_Config* GpioConfigPtr;
    int iPinNumber= 54; //想想为什么是 54
    u32 uPinDirection = 0x1; //1 表示输出， 0 表示输入
    int xStatus;
    //--MIO 的初始化
    GpioConfigPtr = XGpioPs_LookupConfig(XPAR_PS7_GPIO_0_DEVICE_ID);
    if(GpioConfigPtr == NULL)
        return XST_FAILURE;
    xStatus = XGpioPs_CfgInitialize(&psGpioInstancePtr,GpioConfigPtr, GpioConfigPtr->BaseAddr);
    if(XST_SUCCESS != xStatus)
        print(" PS GPIO INIT FAILED \n\r");
    //--MIO 的输入输出操作
    XGpioPs_SetDirectionPin(&psGpioInstancePtr, iPinNumber,uPinDirection);//	配置 IO 输出方向
    XGpioPs_SetOutputEnablePin(&psGpioInstancePtr, iPinNumber,1);//配置 IO	的输出
    while(1)
    {
        XGpioPs_WritePin(&psGpioInstancePtr, iPinNumber, 1);//输出 1
        sleep(1);//延时
        XGpioPs_WritePin(&psGpioInstancePtr, iPinNumber, 0);//输出 0
        sleep(1);//延时
    }
#endif

#if 1
    static XGpioPs psGpioInstancePtr;
    XGpioPs_Config* GpioConfigPtr;
    int xStatus;
    GpioConfigPtr = XGpioPs_LookupConfig(XPAR_PS7_GPIO_0_DEVICE_ID);
    if(GpioConfigPtr == NULL)
        return XST_FAILURE;
    xStatus = XGpioPs_CfgInitialize(&psGpioInstancePtr,GpioConfigPtr, GpioConfigPtr->BaseAddr);
    if(XST_SUCCESS != xStatus)
        print(" PS GPIO INIT FAILED \n\r");
    XGpioPs_SetDirection(&psGpioInstancePtr, 2, 0xffff);
    XGpioPs_SetOutputEnable(&psGpioInstancePtr, 2, 0xffff);
    while(1)
    {
        XGpioPs_Write(&psGpioInstancePtr, 2, 0x0f);
        sleep(1);//延时
        XGpioPs_Write(&psGpioInstancePtr, 2, 0x00);
        sleep(1);//延时
    }
#endif
    return 0;
}

