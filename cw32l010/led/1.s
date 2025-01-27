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
__shi_zhong:
	ldr r0, = 0x40004000
	ldr r1, =  0x5a5a0020
	str r1, [r0, # 0x30]	@开pb时钟

__pb_chu_shi_hua:
	ldr r0, = 0x48000100 @pb
	movs r1, #  0xbf
	strh r1, [r0]
	movs r1, # 0x3f
	str r1, [r0, # 0x1c]
	
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
	
