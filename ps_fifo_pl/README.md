* PS可以读写FIFO
* PL可以读写FIFO

# PS写流程

1. 读取FIFO剩余空间，和IP设置有关
```c
u32 XLlFifo_iTxVacancy(XLlFifo *InstancePtr)
```

2. 将需要发送的数据，暂时放到缓冲区
```c
void XLlFifo_TxPutWord(XLlFifo *InstancePtr, u32 Word)
```

3. 将数据一起发送出去
```c
void XLlFifo_iTxSetLen(XLlFifo *InstancePtr, u32 Bytes)
```
注意第二个参数

4. 等待发送完成
```
XLlFifo_IsTxDone(InstancePtr)
```
