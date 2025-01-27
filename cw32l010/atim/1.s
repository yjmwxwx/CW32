	@cw32L010
	@编译器ARM-NONE-EABI

	.thumb
	.syntax unified
	.section .text
vectors:
	.word zhanding
	.word kaishi + 1
	.word _nmi	+1
	.word _Hard_Fault +1
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	.word _svc_handler +1
	.word 0
	.word 0
	.word _pendsv_handler +1
	.word _systickzhongduan +1  @ 15
	.word aaa +1                @ 0		WDT
	.word aaa +1                @ 1		LVD
	.word aaa +1                @ 2	
	.word aaa +1                @ 3		FLASHRAM
	.word aaa +1                @ 4		RCC
	.word aaa +1         	    @ 5		GPIOA
	.word aaa +1                @ 6		GPIOB
	.word aaa +1                @ 7		GPIOC
	.word aaa +1                @ 8
	.word aaa +1                @ 9
	.word aaa +1                @ 10
	.word aaa +1                @ 11
	.word aaa +1                @ 12	ADC
	.word aaa +1                @ 13	ATIM
	.word aaa +1                @ 14	VC1
	.word aaa +1                @ 15	VC2
	.word aaa +1                @ 16	GTIM
	.word aaa +1                @ 17
	.word aaa +1                @ 18
	.word aaa +1                @ 19
	.word aaa +1                @ 20	BTIM1
	.word aaa +1                @ 21	BTIM2
	.word aaa +1                @ 22	BTIM3
	.word aaa +1                @ 23	I2C
	.word aaa +1                @ 24
	.word aaa +1                @ 25	SPI
	.word aaa +1                @ 26
	.word aaa +1                @ 27	UART1
	.word aaa +1		    @ 28	UART2
	.word aaa +1		    @ 29
	.word aaa +1		    @ 30	AWT
 	.word aaa +1		    @ 31
kaishi:
@	bkpt # 1


__shi_zhong:
	ldr r0, = 0x40004000
	ldr r1, = 0x240022	
	str r1, [r0, # 0x1c]	@SYSCTRL_HSE
	ldr r1, = 0x5a5a0003	@开HES
	str r1, [r0, # 0x04]
deng_hse:
	ldr r1, [r0, # 0x1c]
	lsls r1, r1, # 12
	bpl deng_hse
	ldr r1, = 0x5a5a0001
	str r1, [r0]		@切换到HSE时钟
	ldr r1, = 0x5a5a0002
	str r1, [r0, # 0x04]	@关闭HSI时钟
	
	ldr r1, =  0x5a5a0030
	str r1, [r0, # 0x30]	@开pa pb时钟
	ldr r1, = 0x5a5a0060
	str r1, [r0, # 0x38]	@开ATIM GTIM



__pa_chu_shi_hua:
        ldr r0, = 0x48000000 @pa
        ldr r1, = 0x1e7
        str r1, [r0]		@GPIOx_DIR GPIO 输入输出方向寄存器
        ldr r1, = 0x1e7
        str r1, [r0, # 0x1c]	@GPIOx_ANALOG GPIO 模拟数字配置寄存器
	movs r1, # 0x10		@pa4开漏
	str r1, [r0, # 0x04]	@GPIOx_OPENDRAIN GPIO 输出模式寄存器
	
        str r1, [r0, # 0x14]    @8-15
        ldr r1, = 0x67000       @pa3=ATIM_CH3 PA4=GTIM_CH3
        str r1, [r0, # 0x18]    @0-7

__pb_chu_shi_hua:
        ldr r0, = 0x48000100 @pb
        movs r1, #  0xbf
        str r1, [r0]
        movs r1, # 0x3f
        str r1, [r0, # 0x1c]

	str r1, [r0, # 0x14]    @8-15
        str r1, [r0, # 0x18]    @0-7










	
	
__ATIM_chu_shi_hua:
	ldr r0, = 0x40001400	@ATIM
	movs r1, # 0x30		@翻转模式
	str r1, [r0, # 0x1c]	@ATIM_CCMR2CMP 比较模式寄存器 1
	ldr r1, = 0x100
	str r1, [r0, # 0x20]	@开ATIM_CH3
	ldr r1, = 0x8000	@MOE=1
	str r1, [r0, # 0x44]
	movs r1, # 23		
	str r1, [r0, # 0x2c]	@ATIM_ARR 自动重载寄存器
	movs r1, # 0x01
	str r1, [r0]		@开定时器
__GTIM_chu_shi_hua:
        ldr r0, = 0x40001800    @GTIM
        movs r1, # 0x30         @翻转模式
	str r1, [r0, # 0x1c]    @GTIM_CCMR2CMP 比较模式寄存器 1
        ldr r1, = 0x100
	str r1, [r0, # 0x20]    @开GTIM_CH3
        ldr r1, =  4799
	str r1, [r0, # 0x2c]    @GTIM_ARR 自动重载寄存器
        movs r1, # 0x01
	str r1, [r0]            @开定时器

xun_huan:
__led_kai_guan:
	ldr r0, = 0x48000100	@pb
	ldr r1, = 0x40	@
	str r1, [r0, # 0x60]		@LED开
	
	ldr r2, = 0xfffff
__led_kai_yan_shi:
	subs r2, r2, # 1
	bne __led_kai_yan_shi
	
	str r1, [r0, # 0x60]		@led关
	
	ldr r2, = 0xfffff		@延时时间
__led_guan_yan_shi:
	subs r2, r2, # 1
	bne __led_guan_yan_shi
	
	b xun_huan

_nmi:
_Hard_Fault:
_svc_handler:
_pendsv_handler:	
_systickzhongduan:
aaa:
	bx lr
	
	.section .data
	.equ zhanding,	0x20000100
	
