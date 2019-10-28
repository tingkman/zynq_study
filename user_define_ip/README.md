# 使用场合
AIX4-Lite一般用于

# 流程
必须打开一个工程后，才能去创建自定义IP。
![pic](https://gitee.com/kduant/zynq_study/raw/master/user_define_ip/image/step1.png)

![pic](https://gitee.com/kduant/zynq_study/raw/master/user_define_ip/image/step2.png)
![pic](https://gitee.com/kduant/zynq_study/raw/master/user_define_ip/image/step3.png)
![pic](https://gitee.com/kduant/zynq_study/raw/master/user_define_ip/image/step4.png)
![pic](https://gitee.com/kduant/zynq_study/raw/master/user_define_ip/image/step5.png)

* 选择`Add IP to the repository`后会在指定目录下建立一个`ip_name`的文件夹
* 选择`Edit IP`后，除了在指定目录下建立了一个`ip_name`的文件夹后，还会包含一个vivado工程，这个工程已经包含了IP框架文件

在axi-lite接口实现文件里添加用户逻辑代码。AXI4-Lite传递下来的寄存器参数，相当于是用户逻辑的参数等。


IP代码编写完成后，打包步骤如下:
![pic](https://gitee.com/kduant/zynq_study/raw/master/user_define_ip/image/step1.png)
![pic](https://gitee.com/kduant/zynq_study/raw/master/user_define_ip/image/step6.png)
![pic](https://gitee.com/kduant/zynq_study/raw/master/user_define_ip/image/step7.png)
![pic](https://gitee.com/kduant/zynq_study/raw/master/user_define_ip/image/step8.png)
![pic](https://gitee.com/kduant/zynq_study/raw/master/user_define_ip/image/step9.png)
![pic](https://gitee.com/kduant/zynq_study/raw/master/user_define_ip/image/step10.png)

# 新工程里添加IP
![pic](https://gitee.com/kduant/zynq_study/raw/master/user_define_ip/image/step20.png)



```c
/*
 * 单点坐标
 */
typedef struct __coor
{
    unsigned int x;
    unsigned int y;
}coor_t;
/*
 * 单个报警区域最多支持由几个点组成
 */
#define MAX_POINT_PER_REGION  10
typedef struct __region
{
    coor_t region[MAX_POINT_PER_REGION];
}region_t;
/*
 * 最多可以预设32个
 */
//可以预设几个报警区域
#define MAX_PRE_REGION      10
typedef struct __all_region
{
    unsigned int valid_region;   // 对应bit置1选择那个预设区域有效
    region_t alarm[MAX_PRE_REGION];
}all_region_t;
```