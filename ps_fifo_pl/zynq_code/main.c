#if 0
#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xil_io.h"
#include "xparameters.h"

int main()
{
    int num;
    init_platform();

    print("Hello World\n\r");
    while(1)
    {
		for(num = 0; num <= 0xff; num++)
		{
			Xil_Out32(XPAR_AXI_FIFO_MM_S_0_BASEADDR, 0x10000000);
		}
    }
    cleanup_platform();
    return 0;
}

#else

#include "xparameters.h"
#include "xil_exception.h"
#include "xstreamer.h"
#include "xil_cache.h"
#include "xllfifo.h"
#include "xstatus.h"

#define FIFO_DEV_ID 				XPAR_AXI_FIFO_MM_S_0_DEVICE_ID
#define WORD_SIZE 					4 /* Size of words in bytes */
#define MAX_PACKET_LEN 				4
#define NO_OF_PACKETS 				64
#define MAX_DATA_BUFFER_SIZE 		NO_OF_PACKETS* MAX_PACKET_LEN
XLlFifo FifoInstance;
u32 DestinationBuffer[MAX_DATA_BUFFER_SIZE * WORD_SIZE];

int TxSend(XLlFifo *InstancePtr, u32 *SourceAddr);
int RxReceive(XLlFifo *InstancePtr, u32 *DestinationAddr);
int main()
{
    int i, Status;
    u32 SourceBuffer[MAX_DATA_BUFFER_SIZE * WORD_SIZE];
    XLlFifo_Config *Config;
    /* Filling the buffer with data */
    for(i = 0; i < MAX_DATA_BUFFER_SIZE; i++)
        SourceBuffer[i] = 1 + i;

    Config = XLlFfio_LookupConfig(FIFO_DEV_ID);
    if(!Config)
    {
        xil_printf("No config found for %d\r\n", FIFO_DEV_ID);
        return XST_FAILURE;
    }

    Status = XLlFifo_CfgInitialize(&FifoInstance, Config, Config->BaseAddress);
    if(Status != XST_SUCCESS)
    {
        xil_printf("Initialization failed\n\r");
        return Status;
    }
    Status = XLlFifo_Status(&FifoInstance);
    XLlFifo_IntClear(&FifoInstance, 0xffffffff);
    Status = XLlFifo_Status(&FifoInstance);
    if(Status != 0x0)
    {
        xil_printf(
            "\n ERROR : Reset value of ISR0 : 0x%x\t"
            "Expected : 0x0\n\r",
            XLlFifo_Status(&FifoInstance));
        return XST_FAILURE;
    }
#if 1
    /* Transmit the Data Stream */
    while(1)
    {
		Status = TxSend(&FifoInstance, SourceBuffer);
		if (Status != XST_SUCCESS){
			xil_printf("Transmisson of Data failed\n\r");
			return XST_FAILURE;
		}
    }
#else
    /* Revceive the Data Stream */
    while(1)
    {
        Status = RxReceive(&FifoInstance, DestinationBuffer);
        if(Status != XST_SUCCESS)
        {
            xil_printf("Receiving data failed");
            return XST_FAILURE;
        }
    }
#endif
}

/*****************************************************************************/
/**
 *
 * TxSend routine, It will send the requested amount of data at the
 * specified addr.
 *
 * @param	InstancePtr is a pointer to the instance of the
 *		XLlFifo component.
 *
 * @param	SourceAddr is the address where the FIFO stars writing
 *
 * @return
 *		-XST_SUCCESS to indicate success
 *		-XST_FAILURE to indicate failure
 *
 * @note		None
 *
 ******************************************************************************/
int TxSend(XLlFifo *InstancePtr, u32 *SourceAddr)
{
    int i;
    int j;
    xil_printf(" Transmitting Data ... \r\n");

//    for(i = 0; i < NO_OF_PACKETS / 16; i++)			// 64/16 = 4
//    {
//        /* Writing into the FIFO Transmit Port Buffer */
//        for(j = 0; j < MAX_PACKET_LEN; j++)			// 4
//        {
//            if(XLlFifo_iTxVacancy(InstancePtr))
//            {
//                XLlFifo_TxPutWord(InstancePtr, *(SourceAddr + (i * MAX_PACKET_LEN) + j));
//            }
//        }
//    }
//
//    XLlFifo_iTxSetLen(InstancePtr, (MAX_DATA_BUFFER_SIZE / 16 * WORD_SIZE));  	// 64*4 /16 * 4

    j = XLlFifo_iTxVacancy(InstancePtr);
    for(i = 0; i < 128; i++)
    {
		if(XLlFifo_iTxVacancy(InstancePtr))
		{
			XLlFifo_TxPutWord(InstancePtr, *(SourceAddr + i));
		}
    }

    /* Start Transmission by writing transmission length into the TLR */
    XLlFifo_iTxSetLen(InstancePtr, 128*4);

    /* Check for Transmission completion */
    while(!(XLlFifo_IsTxDone(InstancePtr)))
    {
    }

    /* Transmission Complete */
    return XST_SUCCESS;
}

/*****************************************************************************/
/**
 *
 * RxReceive routine.It will receive the data from the FIFO.
 *
 * @param	InstancePtr is a pointer to the instance of the
 *		XLlFifo instance.
 *
 * @param	DestinationAddr is the address where to copy the received data.
 *
 * @return
 *		-XST_SUCCESS to indicate success
 *		-XST_FAILURE to indicate failure
 *
 * @note		None
 *
 ******************************************************************************/
int RxReceive(XLlFifo *InstancePtr, u32 *DestinationAddr)
{
    int i;
    int Status;
    u32 RxWord;
    static u32 ReceiveLength;

    xil_printf(" Receiving data ....\n\r");
    /* Read Recieve Length */
    ReceiveLength = (XLlFifo_iRxGetLen(InstancePtr)) / WORD_SIZE;

    /* Start Receiving */
    for(i = 0; i < ReceiveLength; i++)
    {
        RxWord = 0;
        RxWord = XLlFifo_RxGetWord(InstancePtr);

        //		if(XLlFifo_iRxOccupancy(InstancePtr))
        //		{
        //			RxWord = XLlFifo_RxGetWord(InstancePtr);
        //		}
        *(DestinationAddr + i) = RxWord;
    }

    Status = XLlFifo_IsRxDone(InstancePtr);
    if(Status != TRUE)
    {
        xil_printf("Failing in receive complete ... \r\n");
        return XST_FAILURE;
    }

    return XST_SUCCESS;
}
#endif
