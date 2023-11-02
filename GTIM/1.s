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
	ldr r1, = 0x5a5a0022	@0x5a5a002a
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

	ldr r1, = 0x500
	str r1, [r0, # 0x34]
	
	@+0X38 1=GTIM1,2=GTIM2,3=RTC,4=WWDT,5=IWDT,6=SPI2
	@7=UART2,8=UART3,11=I2C1,12=I2C2

_neicunqingling:
	ldr r0, = 0x20002000
	ldr r2, = 0x20000000
	movs r1, # 0
_neicunqinglingxunhuan:
	subs r0, r0, # 4
	str r1, [r0]
	cmp r0, r2
	bne _neicunqinglingxunhuan
	

__pa_chu_shi_hua:
	ldr r0, = 0x48000000 @pa
	ldr r1, = 0x7Dff
	str r1, [r0]		@0=输出，1=输入
	ldr r1, = 0x1Dff
	str r1, [r0, # 0x1c]	@0=数字，1=模拟




	
	ldr r1, = 0x50000060
	str r1, [r0, # 0x14]	@复用8-15
	@str r1, [r0, # 0x18]	@复用0-7
	
__pb_chu_shi_hua:

	ldr r0, = 0x48000400 @pb
	ldr r1, = 0xffd7
	str r1, [r0]            @0=输出，1=输入
	str r1, [r0, # 0x1c]    @0=数字，1=模拟

	@str r1, [r0, # 0x14]    @复用8-15
	ldr r1, = 0x505000
	str r1, [r0, # 0x18]	@复用0-7

	
__pc_chu_shi_hua:	
	ldr r3, = 0xc000	
	ldr r0, = 0x48000800 @pc
	str r3, [r0, # 0x1c]
	str r3, [r0]


__spi1_chu_shi_hua:
	ldr r0, = 0x40013000
	ldr r1, = 0x7e74
	str r1, [r0]

__GTIM3_chu_shi_hua:
	ldr r0, = 0x40014000
	ldr r1, = 31999
	ldr r2, = 0x300
	str r1, [r0, r2]	@ARR
	ldr r2, = 0x320
	ldr r1, = 15999
	str r1, [r0, r2]	@CCR1
	ldr r1, = 0x0e
	ldr r2, = 0x308
	str r1, [r0, r2]	@CCMR
	movs r1, # 0x01
	ldr r2, = 0x310
	str r1, [r0, r2]		@CR0
	

	ldr r0, = jishu
	ldr r1, = 99999
	str r1, [r0]
	
ting:
	bl __jishu
	movs r1, # 4
	bl _zhuanshumaguanma
	bl _xieshumaguan
	@	bl __led_kai_guan
	b ting

__jishu:
	push {r1-r2}
	ldr r1, = jishu
	ldr r0, [r1]
	subs r0, r0, # 1
	str r0, [r1]
	bne __jisuan_fanhui
	ldr r0, = 99999
	str r0, [r1]
__jisuan_fanhui:
	pop {r1-r2}
	bx lr

_zhuanshumaguanma:		@ 16进制转数码管码
	@ R0要转的数据, r1小数点位置
	push {r2-r7,lr}
	mov r3, r8
	push {r3}
	mov r8, r1
	ldr r2, = shumaguanma
	ldr r7, = shumaguanmabiao
	mov r5, r0
	movs r3, # 5 @长度
	mov r6, r3
	movs r1, # 10
_xunhuanqiuma:
	bl _chufa
	mov r4, r0
	muls r4, r1
	subs r3, r5, r4
	ldrb r4, [r7, r3]
	cmp r6, r8
	beq __tian_jia_xiao_shu_dian
	b __bao_cun_shu_ma_guan_ma
__tian_jia_xiao_shu_dian:
	subs r4, r4, # 0x80
__bao_cun_shu_ma_guan_ma:
	strb r4, [r2]
	mov r5, r0
	adds r2, r2, # 1
	subs r6, # 1
	bne _xunhuanqiuma
	pop {r3}
	mov r8, r3
	pop {r2-r7,pc}
_xieshumaguan:		 @
	push {r0-r6,lr}
	movs r6, # 0
	ldr r5, = shumaguanma
	ldr r1, = danwei
	ldr r1, [r1]
	lsls r1, r1, # 8
	ldr r2, = shumaguanshuaxinbiao
_shumaguanshuaxin:
	ldrb r3, [r5, r6]
	ldrb r4, [r2, r6]
	lsls r4, r4, # 8
	orrs r4, r4, r3
	adds r4, r4, r1
	mov r0, r4
	bl __xie_spi
	adds  r6, r6, # 1
	cmp r6, # 6
	bne _shumaguanshuaxin

	pop {r0-r6,pc}

	
__xie_spi:
	push {r1-r2}
	ldr r1, = 0x40013000
	movs r2, # 0x00
	str r2, [r1, # 0x0c]
__deng_huan_chong_kong:
	ldr r2, [r1, # 0x10]
	lsls r2, r2, # 31
	bpl __deng_huan_chong_kong
	str r0, [r1, # 0x18]
__deng_huan_chong_kong1:
	ldr r2, [r1, # 0x10]
	lsls r2, r2, # 31
	bpl __deng_huan_chong_kong1
__busy_zong_xian_mang:
	ldr r2, [r1, # 0x10]
	lsls r2, r2, # 23
	bmi __busy_zong_xian_mang
	movs r2, # 0x01
	str r2, [r1, # 0x0c]
	pop {r1-r2}
	bx lr

	
	
	


	
__led_kai_guan:
	push {r0-r2}
	ldr r0, = 0x48000800	@pa
	ldr r1, = 0x2000
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
_chufa:						@软件除法
	@ r0 除以 r1 等于 商(r0)
	push {r1-r4,lr}
	cmp r0, # 0
	beq _chufafanhui
	cmp r1, # 0
	beq _chufafanhui
	mov r2, r0
	movs r3, # 1
	lsls r3, r3, # 31
	movs r0, # 0
	mov r4, r0
_chufaxunhuan:
	lsls r2, r2, # 1
	adcs r4, r4, r4
	cmp r4, r1
	bcc _chufaweishubudao0
	adds r0, r0, r3
	subs r4, r4, r1
_chufaweishubudao0:
	lsrs r3, r3, # 1
	bne _chufaxunhuan
_chufafanhui:
	pop {r1-r4,pc}
	.ltorg
_nmi:
_Hard_Fault:
_svc_handler:
_pendsv_handler:	
_systickzhongduan:
aaa:
	bx lr
	
	.section .data
	.equ zhanding,		0x20000100
	.equ shumaguanma,	0x20001ff0
	.equ jishu,		0x20001ff8
	.equ danwei,		0x20001ffc

shumaguanmabiao:
	.byte 0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90
	.align 4
shumaguanshuaxinbiao:
	.byte 0x20,0x10,0x08,0x04,0x02,0x00
