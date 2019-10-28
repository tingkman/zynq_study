1. 使用EMIO时不需要添加`AXI_GPIO`

2. PL侧有4个LED

3. EMIO的起始序号为**54**


```c
#include "xgpiops.h"
#include "sleep.h"
int main()
{
	static XGpioPs psGpioInstancePtr;
	XGpioPs_Config* GpioConfigPtr;
	int iPinNumber= 54; 
	u32 uPinDirection = 0x1; //1 表示输出， 0 表示输入
	int xStatus;
	//--MIO 的初始化
	GpioConfigPtr = XGpioPs_LookupConfig(XPAR_PS7_GPIO_0_DEVICE_ID);
	if(GpioConfigPtr == NULL)
	return XST_FAILURE;
	xStatus = XGpioPs_CfgInitialize(&psGpioInstancePtr,GpioConfigPtr,
	GpioConfigPtr->BaseAddr);
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
	return 0;
}
```
