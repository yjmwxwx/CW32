	@cw32f030c8
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
shizhong:
	ldr r0, = 0x40022000   @FLASH访问控制
	ldr r1, = 0x5a51001a
	str r1, [r0, # 0x04]           @FLASH缓冲 缓冲开启
	ldr r0, = 0x40010000 @ rcc
	ldr r1, = 0x5a5a0183
	str r1, [r0, # 0x04]
deng_hse:
	ldr r1, [r0, # 0x1c]
	lsls r1, r1, # 12
	bpl deng_hse
	ldr r1, = 0x53884
	str r1, [r0, # 0x28]
	ldr r1, = 0x5a5a0187
	str r1, [r0, # 0x04]
deng_pll:	
	ldr r1, [r0, # 0x28]
	lsls r1, r1, # 16
	bpl deng_pll
	ldr r1, = 0x5a5a002a
	str r1, [r0]	@pll作为系统时钟	
	ldr r1, = 0x5a5a0186
	str r1, [r0, # 0x04]	@关HSI
	
__wai_she_shi_zhong:
	ldr r0, = 0x40010000
	@+0x30 0=DMA,1=FLASH,2=CRC,4=PA,5=PB,6=PC,9=PF
	ldr r1, = 0x273
	str r1, [r0, # 0x30]

	@+0X34 2=ADC,4=VC,7=ATIM,8=SPI1,9=UART1,10=GTIM3
	@11=GTIM4,12=BTIM,13=AWT
	
	@+0X38 1=GTIM1,2=GTIM2,3=RTC,4=WWDT,5=IWDT,6=SPI2
	@7=UART2,8=UART3,11=I2C1,12=I2C2

	

__pa_chu_shi_hua:	
	ldr r2, = 0x8000	@pa15
	ldr r3, = 0x1fff	
	ldr r0, = 0x48000000 @pa
	ldr r1, = 0x7fff
	str r3, [r0, # 0x1c]
	str r1, [r0]
	
ting:
	bl __led_kai_guan
	b ting
	
__led_kai_guan:
	push {r0-r2}
	ldr r0, = 0x48000000	@pa
	ldr r1, = 0x8000
	str r1, [r0, # 0x5c]
	ldr r2, = 0xfffff
__led_kai_yan_shi:
	subs r2, r2, # 1
	bne __led_kai_yan_shi
	str r1, [r0, # 0x58]
	ldr r2, = 0xfffff
__led_guan_yan_shi:
	subs r2, r2, # 1
	bne __led_guan_yan_shi
	pop {r0-r2}
	bx lr

_nmi:
_Hard_Fault:
_svc_handler:
_pendsv_handler:	
_systickzhongduan:
aaa:
	bx lr
	
	.section .data
	.equ zhanding,	0x20000100
	
