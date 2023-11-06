	@cw32f030c8
	@编译器ARM-NONE-EABI
	@电池内租测试仪
	@yjmwxwx-2023-11-06
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
	.word aaa +1                @ 2		RTC
	.word aaa +1                @ 3		FLASHRAM
	.word aaa +1                @ 4		RCC
	.word aaa +1         	    @ 5		GPIOA
	.word aaa +1                @ 6		GPIOB
	.word aaa +1                @ 7		GPIOC
	.word aaa +1                @ 8		GPIOF
	.word aaa +1		    @ 9		DMA1
	.word aaa +1                @ 10	DMA23
	.word aaa +1                @ 11	DMA45
	.word aaa +1                @ 12	ADC
	.word aaa +1                @ 13	ATIM
	.word aaa +1                @ 14	VC1
	.word aaa +1                @ 15	VC2
	.word aaa +1                @ 16	GTIM1
	.word aaa +1                @ 17	GITM2
	.word aaa +1                @ 18	GTIM3
	.word aaa +1                @ 19	GTIM4
	.word aaa +1                @ 20	BTIM1
	.word aaa +1                @ 21	BTIM2
	.word aaa +1                @ 22	BTIM3
	.word aaa +1                @ 23	I2C1
	.word aaa +1                @ 24	I2C2
	.word aaa +1                @ 25	SPI1
	.word aaa +1                @ 26	SPI2
	.word aaa +1                @ 27	UART1
	.word aaa +1		    @ 28	UART2
	.word aaa +1		    @ 29	UART3
	.word aaa +1		    @ 30	AWT
 	.word aaa +1		    @ 31	FAULT
kaishi:
@	bkpt # 1
shizhong:
@	ldr r0, = 0x40022000   @FLASH访问控制
@	ldr r1, = 0x5a51001a
@	str r1, [r0, # 0x04]           @FLASH缓冲 缓冲开启
	
	ldr r0, = 0x40010000 @ rcc
	ldr r1, = 0x5a5a0183
	str r1, [r0, # 0x04]
deng_hse:
	ldr r1, [r0, # 0x1c]
	lsls r1, r1, # 12
	bpl deng_hse
	ldr r1, = 0x53864	@48MHZ (64MHZ=0x53884)
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

	ldr r1, = 0x584
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

@__zhong_duan:
@	ldr r0, = 0xe000e100
@	movs r1, # 1
@	lsls r1, r1, # 9
@	str r1, [r0]
	
__GTIM3_chu_shi_hua:
	ldr r0, = 0x40014000
	ldr r1, = 23999		@31999
	ldr r2, = 0x300
	str r1, [r0, r2]	@ARR
	ldr r2, = 0x320
	ldr r1, = 12000		@15999
	str r1, [r0, r2]	@CCR1
	ldr r1, = 0x0e
	ldr r2, = 0x308
	str r1, [r0, r2]	@CCMR
	movs r1, # 0x01
	ldr r2, = 0x310
	str r1, [r0, r2]		@CR0
	
__ATIM_chu_shi_hua:
	ldr r0, = 0x40012C00
	movs r1, # 0x81
	str r1, [r0, # 0x20]	@触发ADC
	ldr r1, = 239        
	str r1, [r0]        @ARR
	ldr r1, = 0x2001
	str r1, [r0, # 0x0c]

__adc_chu_shi_hua:
	ldr r0, = 0x40012400
	movs r1, # 0xc1 	@0xc1	@0xc5
	str r1, [r0]			@开ADC
	movs r1, # 0x01
	str r1, [r0, # 0x1c]		@ATIM触发ADC
__deng_chu_shi_hua:
	ldr r1, [r0, # 0x3c]
	lsls r1, r1, # 24
	bpl __deng_chu_shi_hua		@等ADC初始化完成
	movs r1, # 0x80
	str r1, [r0, # 0x04]		@开DMA和通道选择
@	movs r1, # 0x01
@	str r1, [r0, # 0x08]		@开ADC转换

	ldr r4, = 0xe000e010
	ldr r3, = 239999
	str r3, [r4, # 4]
	str r3, [r4, # 8]
	movs r3, # 0x07
	str r3, [r4]    @systick 开
	
__DMA_chu_shi_hua:
	ldr r0, = 0x40020000
	ldr r1, = 0x103e8
	str r1, [r0, # 0x24]    @传输数量
	ldr r1, = 0x40012420
	str r1, [r0, # 0x28]    @传输源
	ldr r1, = dianyabiao
	str r1, [r0, # 0x2c]    @目的地
	movs r1, # 0x29
	str r1, [r0, # 0x30]    @触发源
	movs r1, # 0x69
	str r1, [r0, # 0x20]    @模式设置和开DMA
	
	ldr r0, = lvbo_changdu
	ldr r1, = lvbo_youyi
	movs r2, # 200
	str r2, [r0]
	movs r2, # 14
	str r2, [r1]

	ldr r0, = cossin
	ldr r1, = cos_sin_biao_1k
	str r1, [r0]


	
	ldr r0, = jishu
	ldr r1, = 99999
	str r1, [r0]
	
ting:
	ldr r0, = fudu	
	ldr r0, [r0]
@	ldr r0, = 12345
        movs r1, # 0xff
	bl _zhuanshumaguanma
	bl _xieshumaguan
	b ting

	
	bl __jishu
	movs r1, # 4
	bl _zhuanshumaguanma
	bl _xieshumaguan
	@	bl __led_kai_guan
	b ting
	.ltorg


__dft:
	push {r2-r7,lr}
	mov r5, r10
	mov r6, r11
	mov r7, r12
	push {r5-r7}
	ldr r0, = cossin
	ldr r1, = dianyabiao
	ldr r0, [r0]
	movs r6, # 0
	mov r7, r6
	mov r12, sp
	mov r11, r0
	mov r10, r1
	b __dft_xunhuan
	.ltorg
__dft_xunhuan:
	@0
	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	muls r2, r2, r5		@R
	muls r3, r3, r5		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2	 @r
	adds r1, r1, r3	 @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2  @r
	adds r1, r1, r3  @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	@1
	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	muls r2, r2, r5		@R
	muls r3, r3, r5		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2	 @r
	adds r1, r1, r3	 @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2  @r
	adds r1, r1, r3  @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	@2
	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	muls r2, r2, r5		@R
	muls r3, r3, r5		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2	 @r
	adds r1, r1, r3	 @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2  @r
	adds r1, r1, r3  @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	@3
	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	muls r2, r2, r5		@R
	muls r3, r3, r5		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2	 @r
	adds r1, r1, r3	 @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2  @r
	adds r1, r1, r3  @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	@4
	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	muls r2, r2, r5		@R
	muls r3, r3, r5		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2	 @r
	adds r1, r1, r3	 @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2  @r
	adds r1, r1, r3  @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	@5
	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	muls r2, r2, r5		@R
	muls r3, r3, r5		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2	 @r
	adds r1, r1, r3	 @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2  @r
	adds r1, r1, r3  @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	@6
	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	muls r2, r2, r5		@R
	muls r3, r3, r5		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2	 @r
	adds r1, r1, r3	 @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2  @r
	adds r1, r1, r3  @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	@7
	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	muls r2, r2, r5		@R
	muls r3, r3, r5		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2	 @r
	adds r1, r1, r3	 @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2  @r
	adds r1, r1, r3  @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	@8
	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	muls r2, r2, r5		@R
	muls r3, r3, r5		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2	 @r
	adds r1, r1, r3	 @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2  @r
	adds r1, r1, r3  @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	@9
	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	muls r2, r2, r5		@R
	muls r3, r3, r5		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2	 @r
	adds r1, r1, r3	 @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2  @r
	adds r1, r1, r3  @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	@10
	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	muls r2, r2, r5		@R
	muls r3, r3, r5		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2	 @r
	adds r1, r1, r3	 @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2  @r
	adds r1, r1, r3  @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	@11
	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	muls r2, r2, r5		@R
	muls r3, r3, r5		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2	 @r
	adds r1, r1, r3	 @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2  @r
	adds r1, r1, r3  @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1

	@12
	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4         @R
	muls r1, r1, r4         @I
	muls r2, r2, r5         @R
	muls r3, r3, r5         @I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2  @r
	adds r1, r1, r3  @i
	adds r6, r6, r0
	adds r7, r7, r1

	mov sp, r11
	pop {r0-r3}
	mov r11, sp
	mov sp, r10
	pop {r4}
	mov r10, sp
	mov r5, r4
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r5, r5, # 16
	muls r0, r0, r4
	muls r1, r1, r4
	muls r2, r2, r5
	muls r3, r3, r5
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	adds r0, r0, r2         @r
	adds r1, r1, r3         @i
	adds r6, r6, r0
	adds r7, r7, r1


	@	bkpt # 1
	ldr r0, = dianyabiao
	ldr r1, = 0x7d0
	adds r0, r0, r1
	cmp r10, r0
	beq __dft_fanhuile
	ldr r0, = cossin
	ldr r0, [r0]
	mov r11, r0
	ldr r0, = __dft_xunhuan
	adds r0, r0, # 1
	mov pc, r0
	@	b __dft_xunhuan
__dft_fanhuile:
	mov r0, r6
	mov r1, r7
	asrs r0, r0, # 9	@dfdf
	asrs r1, r1, # 9
	mov sp, r12
	pop {r2-r4}
	mov r10, r2
	mov r11, r3
	mov r12, r4
	pop {r2-r7,pc}
	.ltorg



__lv_bo_qi:
	@地址顺序：指针，累加值，缓冲区
	@入口R0=缓冲区，R1=数据, r2,=指针
	@出口R0
	push {r3-r7,lr}
	ldr r4, = lvbo_changdu
	ldr r7, = lvbo_youyi
	ldr r4, [r4]
	ldr r7, [r7]
	ldr r5, [r2]
	mov r3, r5
	lsls r3, r5, # 2
	ldr r6, [r0, r3]
	str r1, [r0, r3]
	adds r5, r5, # 1
	str r5, [r2]
	cmp r5, r4
	bne __huanchong_leijia
	movs r5, # 0
	str r5, [r2]
__huanchong_leijia:
	subs r0, r0, # 4
	ldr r5, [r0]
	adds r1, r1, r5
	subs r1, r1, r6
	str r1, [r0]
	asrs r1, r1, r7	 @# 12 @12 @  7	@128
	mov r0, r1
	pop {r3-r7,pc}
	.ltorg
__ji_suan_fu_du:			    @ 计算幅度
	@ 入r0= 实部，r1= 虚部
	@ 出r0 = 幅度
	@ Mag ~=Alpha * max(|I|, |Q|) + Beta * min(|I|, |Q|)
	@ Alpha * Max + Beta * Min
	push {r1-r3,lr}
	movs r0, r0
	bpl _shibubushifushu
	mvns r0, r0                             @ 是负数转成正数
	adds r0, r0, # 1
_shibubushifushu:			                               @ 实部不是负数
	movs r1, r1
	bpl _xububushifushu
	mvns r1, r1                             @ 是负数转成正数
	adds r1, r1, # 1
_xububushifushu:			                                @ 虚部不是负数
	cmp r0, # 0
	bne _panduanxubushibushi0
	mov r0, r1
	pop {r1-r3,pc}
_panduanxubushibushi0:
	cmp r1, # 0
	bne _jisuanfudu1
	pop {r1-r3,pc}
_jisuanfudu1:
	ldr r2, = 31066		@ Alpha q15 0.948059448969
	ldr r3, = 12867		@ Beta q15 0.392699081699
	cmp r1, r0
	bhi _alpha_min_beta_max
_alpha_max_beta_min:
	muls r0, r0, r2
	muls r1, r1, r3
	asrs r0, r0, # 15
	asrs r1, r1, # 15
	adds r0, r0, r1
	movs r1, # 1
	pop {r1-r3,pc}
_alpha_min_beta_max:
	muls r0, r0, r3
	muls r1, r1, r2
	asrs r0, r0, # 15
	asrs r1, r1, # 15
	adds r0, r0, r1
	movs r1, # 0
	pop {r1-r3,pc}
	








	
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
	push {r0-r4,lr}
	ldr r0, = 0x40020000
	ldr r1, = 0x103e8
	str r1, [r0, # 0x24]    @传输数量
	ldr r1, = dianyabiao
	str r1, [r0, # 0x2c]    @目的地
	movs r1, # 0x69
	str r1, [r0, # 0x20]    @模式设置和开DMA

__suan_dft:
	bl __dft
	ldr r2, = shangbi_rr
	ldr r3, = shangbi_ii
	str r0, [r2]
	str r1, [r3]
	mov r4, r0
	ldr r2, = lvboqizhizhen1
	ldr r0, =lvboqihuanchong1
	bl __lv_bo_qi
	ldr r1, = shangbi_i
	str r0, [r1]
	mov r1, r4
	ldr r2, = lvboqizhizhen
	ldr r0, =lvboqihuanchong
	bl __lv_bo_qi
	ldr r1, = shangbi_r
	str r0, [r1]


	
	ldr r0, = shangbi_r
	ldr r1, = shangbi_i
	ldr r0, [r0]
	ldr r1, [r1]
	bl __ji_suan_fu_du
	ldr r2, = fudu
	str r0, [r2]
__systick_fanhui:
	ldr r0, = 0xe0000d04
	ldr r1, = 0x02000000
	str r1, [r0]                 @ 清除SYSTICK中断
	pop {r0-r4,pc}
aaa:
	bx lr

	
	.section .data
	.equ zhanding,		0x20000160
	.equ dianyabiao,	0x20000160
	.equ lvboqizhizhen,             0x20001100
	.equ lvboqihuanchong,           0x20001108
	.equ lvboqizhizhen1,            0x20001500
	.equ lvboqihuanchong1,          0x20001508

	.equ fudu,			0x20001fd0
	.equ lvbo_youyi,		0x20001fd4
	.equ lvbo_changdu,		0x20001fd8
	.equ cossin,                    0x20001fdc
	.equ shangbi_r,			0x20001fe0	
	.equ shangbi_i,			0x20001fe4
	.equ shangbi_rr,		0x20001fe8
	.equ shangbi_ii,		0x20001fec
	.equ shumaguanma,		0x20001ff0
	.equ jishu,			0x20001ff8
	.equ danwei,			0x20001ffc
	.align 4
shumaguanmabiao:
	.byte 0xc0,0xf9,0xa4,0xb0,0x99,0x92,0x82,0xf8,0x80,0x90
	.align 4
shumaguanshuaxinbiao:
	.byte 0x20,0x10,0x08,0x04,0x02,0x00
	.align 4
cos_sin_biao_1k:
	.int 0x8000,0x0000,0x7FBF,0xFFFFF7F7,0x7EFD,0xFFFFEFF6,0x7DBB,0xFFFFE804,0x7BFA,0xFFFFE02B,0x79BC,0xFFFFD873,0x7702,0xFFFFD0E2,0x73D1,0xFFFFC981,0x702A,0xFFFFC256,0x6C12,0xFFFFBB6B,0x678D,0xFFFFB4C4,0x62A0,0xFFFFAE69,0x5D4E,0xFFFFA861,0x579F,0xFFFFA2B2,0x5197,0xFFFF9D60,0x4B3C,0xFFFF9873,0x4495,0xFFFF93EE,0x3DAA,0xFFFF8FD6,0x367F,0xFFFF8C2F,0x2F1E,0xFFFF88FE,0x278D,0xFFFF8644,0x1FD5,0xFFFF8406,0x17FC,0xFFFF8245,0x100A,0xFFFF8103,0x0809,0xFFFF8041,0x0000,0xFFFF8000,0xFFFFF7F7,0xFFFF8041,0xFFFFEFF6,0xFFFF8103,0xFFFFE804,0xFFFF8245,0xFFFFE02B,0xFFFF8406,0xFFFFD873,0xFFFF8644,0xFFFFD0E2,0xFFFF88FE,0xFFFFC981,0xFFFF8C2F,0xFFFFC256,0xFFFF8FD6,0xFFFFBB6B,0xFFFF93EE,0xFFFFB4C4,0xFFFF9873,0xFFFFAE69,0xFFFF9D60,0xFFFFA861,0xFFFFA2B2,0xFFFFA2B2,0xFFFFA861,0xFFFF9D60,0xFFFFAE69,0xFFFF9873,0xFFFFB4C4,0xFFFF93EE,0xFFFFBB6B,0xFFFF8FD6,0xFFFFC256,0xFFFF8C2F,0xFFFFC981,0xFFFF88FE,0xFFFFD0E2,0xFFFF8644,0xFFFFD873,0xFFFF8406,0xFFFFE02B,0xFFFF8245,0xFFFFE804,0xFFFF8103,0xFFFFEFF6,0xFFFF8041,0xFFFFF7F7,0xFFFF8000,0x0000,0xFFFF8041,0x0809,0xFFFF8103,0x100A,0xFFFF8245,0x17FC,0xFFFF8406,0x1FD5,0xFFFF8644,0x278D,0xFFFF88FE,0x2F1E,0xFFFF8C2F,0x367F,0xFFFF8FD6,0x3DAA,0xFFFF93EE,0x4495,0xFFFF9873,0x4B3C,0xFFFF9D60,0x5197,0xFFFFA2B2,0x579F,0xFFFFA861,0x5D4E,0xFFFFAE69,0x62A0,0xFFFFB4C4,0x678D,0xFFFFBB6B,0x6C12,0xFFFFC256,0x702A,0xFFFFC981,0x73D1,0xFFFFD0E2,0x7702,0xFFFFD873,0x79BC,0xFFFFE02B,0x7BFA,0xFFFFE804,0x7DBB,0xFFFFEFF6,0x7EFD,0xFFFFF7F7,0x7FBF,0x0000,0x8000,0x0809,0x7FBF,0x100A,0x7EFD,0x17FC,0x7DBB,0x1FD5,0x7BFA,0x278D,0x79BC,0x2F1E,0x7702,0x367F,0x73D1,0x3DAA,0x702A,0x4495,0x6C12,0x4B3C,0x678D,0x5197,0x62A0,0x579F,0x5D4E,0x5D4E,0x579F,0x62A0,0x5197,0x678D,0x4B3C,0x6C12,0x4495,0x702A,0x3DAA,0x73D1,0x367F,0x7702,0x2F1E,0x79BC,0x278D,0x7BFA,0x1FD5,0x7DBB,0x17FC,0x7EFD,0x100A,0x7FBF,0x0809,0x8000,0x0000,0x7FBF,0xFFFFF7F7,0x7EFD,0xFFFFEFF6,0x7DBB,0xFFFFE804,0x7BFA,0xFFFFE02B,0x79BC,0xFFFFD873,0x7702,0xFFFFD0E2,0x73D1,0xFFFFC981,0x702A,0xFFFFC256,0x6C12,0xFFFFBB6B,0x678D,0xFFFFB4C4,0x62A0,0xFFFFAE69,0x5D4E,0xFFFFA861,0x579F,0xFFFFA2B2,0x5197,0xFFFF9D60,0x4B3C,0xFFFF9873,0x4495,0xFFFF93EE,0x3DAA,0xFFFF8FD6,0x367F,0xFFFF8C2F,0x2F1E,0xFFFF88FE,0x278D,0xFFFF8644,0x1FD5,0xFFFF8406,0x17FC,0xFFFF8245,0x100A,0xFFFF8103,0x0809,0xFFFF8041,0x0000,0xFFFF8000,0xFFFFF7F7,0xFFFF8041,0xFFFFEFF6,0xFFFF8103,0xFFFFE804,0xFFFF8245,0xFFFFE02B,0xFFFF8406,0xFFFFD873,0xFFFF8644,0xFFFFD0E2,0xFFFF88FE,0xFFFFC981,0xFFFF8C2F,0xFFFFC256,0xFFFF8FD6,0xFFFFBB6B,0xFFFF93EE,0xFFFFB4C4,0xFFFF9873,0xFFFFAE69,0xFFFF9D60,0xFFFFA861,0xFFFFA2B2,0xFFFFA2B2,0xFFFFA861,0xFFFF9D60,0xFFFFAE69,0xFFFF9873,0xFFFFB4C4,0xFFFF93EE,0xFFFFBB6B,0xFFFF8FD6,0xFFFFC256,0xFFFF8C2F,0xFFFFC981,0xFFFF88FE,0xFFFFD0E2,0xFFFF8644,0xFFFFD873,0xFFFF8406,0xFFFFE02B,0xFFFF8245,0xFFFFE804,0xFFFF8103,0xFFFFEFF6,0xFFFF8041,0xFFFFF7F7,0xFFFF8000,0x0000,0xFFFF8041,0x0809,0xFFFF8103,0x100A,0xFFFF8245,0x17FC,0xFFFF8406,0x1FD5,0xFFFF8644,0x278D,0xFFFF88FE,0x2F1E,0xFFFF8C2F,0x367F,0xFFFF8FD6,0x3DAA,0xFFFF93EE,0x4495,0xFFFF9873,0x4B3C,0xFFFF9D60,0x5197,0xFFFFA2B2,0x579F,0xFFFFA861,0x5D4E,0xFFFFAE69,0x62A0,0xFFFFB4C4,0x678D,0xFFFFBB6B,0x6C12,0xFFFFC256,0x702A,0xFFFFC981,0x73D1,0xFFFFD0E2,0x7702,0xFFFFD873,0x79BC,0xFFFFE02B,0x7BFA,0xFFFFE804,0x7DBB,0xFFFFEFF6,0x7EFD,0xFFFFF7F7,0x7FBF,0x0000,0x8000,0x0809,0x7FBF,0x100A,0x7EFD,0x17FC,0x7DBB,0x1FD5,0x7BFA,0x278D,0x79BC,0x2F1E,0x7702,0x367F,0x73D1,0x3DAA,0x702A,0x4495,0x6C12,0x4B3C,0x678D,0x5197,0x62A0,0x579F,0x5D4E,0x5D4E,0x579F,0x62A0,0x5197,0x678D,0x4B3C,0x6C12,0x4495,0x702A,0x3DAA,0x73D1,0x367F,0x7702,0x2F1E,0x79BC,0x278D,0x7BFA,0x1FD5,0x7DBB,0x17FC,0x7EFD,0x100A,0x7FBF,0x0809,0x8000,0x0000,0x7FBF,0xFFFFF7F7,0x7EFD,0xFFFFEFF6,0x7DBB,0xFFFFE804,0x7BFA,0xFFFFE02B,0x79BC,0xFFFFD873,0x7702,0xFFFFD0E2,0x73D1,0xFFFFC981,0x702A,0xFFFFC256,0x6C12,0xFFFFBB6B,0x678D,0xFFFFB4C4,0x62A0,0xFFFFAE69,0x5D4E,0xFFFFA861,0x579F,0xFFFFA2B2,0x5197,0xFFFF9D60,0x4B3C,0xFFFF9873,0x4495,0xFFFF93EE,0x3DAA,0xFFFF8FD6,0x367F,0xFFFF8C2F,0x2F1E,0xFFFF88FE,0x278D,0xFFFF8644,0x1FD5,0xFFFF8406,0x17FC,0xFFFF8245,0x100A,0xFFFF8103,0x0809,0xFFFF8041,0x0000,0xFFFF8000,0xFFFFF7F7,0xFFFF8041,0xFFFFEFF6,0xFFFF8103,0xFFFFE804,0xFFFF8245,0xFFFFE02B,0xFFFF8406,0xFFFFD873,0xFFFF8644,0xFFFFD0E2,0xFFFF88FE,0xFFFFC981,0xFFFF8C2F,0xFFFFC256,0xFFFF8FD6,0xFFFFBB6B,0xFFFF93EE,0xFFFFB4C4,0xFFFF9873,0xFFFFAE69,0xFFFF9D60,0xFFFFA861,0xFFFFA2B2,0xFFFFA2B2,0xFFFFA861,0xFFFF9D60,0xFFFFAE69,0xFFFF9873,0xFFFFB4C4,0xFFFF93EE,0xFFFFBB6B,0xFFFF8FD6,0xFFFFC256,0xFFFF8C2F,0xFFFFC981,0xFFFF88FE,0xFFFFD0E2,0xFFFF8644,0xFFFFD873,0xFFFF8406,0xFFFFE02B,0xFFFF8245,0xFFFFE804,0xFFFF8103,0xFFFFEFF6,0xFFFF8041,0xFFFFF7F7,0xFFFF8000,0x0000,0xFFFF8041,0x0809,0xFFFF8103,0x100A,0xFFFF8245,0x17FC,0xFFFF8406,0x1FD5,0xFFFF8644,0x278D,0xFFFF88FE,0x2F1E,0xFFFF8C2F,0x367F,0xFFFF8FD6,0x3DAA,0xFFFF93EE,0x4495,0xFFFF9873,0x4B3C,0xFFFF9D60,0x5197,0xFFFFA2B2,0x579F,0xFFFFA861,0x5D4E,0xFFFFAE69,0x62A0,0xFFFFB4C4,0x678D,0xFFFFBB6B,0x6C12,0xFFFFC256,0x702A,0xFFFFC981,0x73D1,0xFFFFD0E2,0x7702,0xFFFFD873,0x79BC,0xFFFFE02B,0x7BFA,0xFFFFE804,0x7DBB,0xFFFFEFF6,0x7EFD,0xFFFFF7F7,0x7FBF,0x0000,0x8000,0x0809,0x7FBF,0x100A,0x7EFD,0x17FC,0x7DBB,0x1FD5,0x7BFA,0x278D,0x79BC,0x2F1E,0x7702,0x367F,0x73D1,0x3DAA,0x702A,0x4495,0x6C12,0x4B3C,0x678D,0x5197,0x62A0,0x579F,0x5D4E,0x5D4E,0x579F,0x62A0,0x5197,0x678D,0x4B3C,0x6C12,0x4495,0x702A,0x3DAA,0x73D1,0x367F,0x7702,0x2F1E,0x79BC,0x278D,0x7BFA,0x1FD5,0x7DBB,0x17FC,0x7EFD,0x100A,0x7FBF,0x0809,0x8000,0x0000,0x7FBF,0xFFFFF7F7,0x7EFD,0xFFFFEFF6,0x7DBB,0xFFFFE804,0x7BFA,0xFFFFE02B,0x79BC,0xFFFFD873,0x7702,0xFFFFD0E2,0x73D1,0xFFFFC981,0x702A,0xFFFFC256,0x6C12,0xFFFFBB6B,0x678D,0xFFFFB4C4,0x62A0,0xFFFFAE69,0x5D4E,0xFFFFA861,0x579F,0xFFFFA2B2,0x5197,0xFFFF9D60,0x4B3C,0xFFFF9873,0x4495,0xFFFF93EE,0x3DAA,0xFFFF8FD6,0x367F,0xFFFF8C2F,0x2F1E,0xFFFF88FE,0x278D,0xFFFF8644,0x1FD5,0xFFFF8406,0x17FC,0xFFFF8245,0x100A,0xFFFF8103,0x0809,0xFFFF8041,0x0000,0xFFFF8000,0xFFFFF7F7,0xFFFF8041,0xFFFFEFF6,0xFFFF8103,0xFFFFE804,0xFFFF8245,0xFFFFE02B,0xFFFF8406,0xFFFFD873,0xFFFF8644,0xFFFFD0E2,0xFFFF88FE,0xFFFFC981,0xFFFF8C2F,0xFFFFC256,0xFFFF8FD6,0xFFFFBB6B,0xFFFF93EE,0xFFFFB4C4,0xFFFF9873,0xFFFFAE69,0xFFFF9D60,0xFFFFA861,0xFFFFA2B2,0xFFFFA2B2,0xFFFFA861,0xFFFF9D60,0xFFFFAE69,0xFFFF9873,0xFFFFB4C4,0xFFFF93EE,0xFFFFBB6B,0xFFFF8FD6,0xFFFFC256,0xFFFF8C2F,0xFFFFC981,0xFFFF88FE,0xFFFFD0E2,0xFFFF8644,0xFFFFD873,0xFFFF8406,0xFFFFE02B,0xFFFF8245,0xFFFFE804,0xFFFF8103,0xFFFFEFF6,0xFFFF8041,0xFFFFF7F7,0xFFFF8000,0x0000,0xFFFF8041,0x0809,0xFFFF8103,0x100A,0xFFFF8245,0x17FC,0xFFFF8406,0x1FD5,0xFFFF8644,0x278D,0xFFFF88FE,0x2F1E,0xFFFF8C2F,0x367F,0xFFFF8FD6,0x3DAA,0xFFFF93EE,0x4496,0xFFFF9873,0x4B3C,0xFFFF9D60,0x5197,0xFFFFA2B2,0x579F,0xFFFFA861,0x5D4E,0xFFFFAE69,0x62A0,0xFFFFB4C4,0x678D,0xFFFFBB6B,0x6C13,0xFFFFC256,0x702A,0xFFFFC981,0x73D1,0xFFFFD0E2,0x7702,0xFFFFD873,0x79BC,0xFFFFE02B,0x7BFA,0xFFFFE804,0x7DBB,0xFFFFEFF6,0x7EFD,0xFFFFF7F7,0x7FBF,0x0000,0x8000,0x0809,0x7FBF,0x100A,0x7EFD,0x17FC,0x7DBB,0x1FD5,0x7BFA,0x278D,0x79BC,0x2F1E,0x7702,0x367F,0x73D1,0x3DAA,0x702A,0x4495,0x6C12,0x4B3C,0x678D,0x5197,0x62A0,0x579F,0x5D4E,0x5D4E,0x579F,0x62A0,0x5197,0x678D,0x4B3C,0x6C12,0x4495,0x702A,0x3DAA,0x73D1,0x367F,0x7702,0x2F1E,0x79BC,0x278D,0x7BFA,0x1FD5,0x7DBB,0x17FC,0x7EFD,0x100A,0x7FBF,0x0809,0x8000,0x0000,0x7FBF,0xFFFFF7F7,0x7EFD,0xFFFFEFF6,0x7DBB,0xFFFFE804,0x7BFA,0xFFFFE02B,0x79BC,0xFFFFD873,0x7702,0xFFFFD0E2,0x73D1,0xFFFFC980,0x702A,0xFFFFC256,0x6C12,0xFFFFBB6B,0x678D,0xFFFFB4C4,0x62A0,0xFFFFAE69,0x5D4E,0xFFFFA861,0x579F,0xFFFFA2B2,0x5197,0xFFFF9D60,0x4B3C,0xFFFF9873,0x4495,0xFFFF93EE,0x3DAA,0xFFFF8FD6,0x367F,0xFFFF8C2F,0x2F1E,0xFFFF88FE,0x278D,0xFFFF8644,0x1FD5,0xFFFF8406,0x17FC,0xFFFF8245,0x100A,0xFFFF8103,0x0809,0xFFFF8041,0x0000,0xFFFF8000,0xFFFFF7F7,0xFFFF8041,0xFFFFEFF6,0xFFFF8103,0xFFFFE804,0xFFFF8245,0xFFFFE02B,0xFFFF8406,0xFFFFD873,0xFFFF8644,0xFFFFD0E2,0xFFFF88FE,0xFFFFC981,0xFFFF8C2F,0xFFFFC256,0xFFFF8FD6,0xFFFFBB6A,0xFFFF93EE,0xFFFFB4C4,0xFFFF9873,0xFFFFAE69,0xFFFF9D60,0xFFFFA861,0xFFFFA2B2,0xFFFFA2B2,0xFFFFA861,0xFFFF9D60,0xFFFFAE69,0xFFFF9873,0xFFFFB4C4,0xFFFF93EE,0xFFFFBB6B,0xFFFF8FD6,0xFFFFC256,0xFFFF8C2F,0xFFFFC981,0xFFFF88FE,0xFFFFD0E2,0xFFFF8644,0xFFFFD873,0xFFFF8406,0xFFFFE02B,0xFFFF8245,0xFFFFE804,0xFFFF8103,0xFFFFEFF6,0xFFFF8041,0xFFFFF7F7,0xFFFF8000,0x0000,0xFFFF8041,0x0809,0xFFFF8103,0x100A,0xFFFF8245,0x17FC,0xFFFF8406,0x1FD5,0xFFFF8644,0x278D,0xFFFF88FE,0x2F1E,0xFFFF8C2F,0x3680,0xFFFF8FD6,0x3DAA,0xFFFF93EE,0x4496,0xFFFF9873,0x4B3C,0xFFFF9D60,0x5197,0xFFFFA2B2,0x579F,0xFFFFA861,0x5D4E,0xFFFFAE69,0x62A0,0xFFFFB4C4,0x678D,0xFFFFBB6B,0x6C12,0xFFFFC256,0x702A,0xFFFFC981,0x73D1,0xFFFFD0E2,0x7702,0xFFFFD873,0x79BC,0xFFFFE02C,0x7BFA,0xFFFFE804,0x7DBB,0xFFFFEFF6,0x7EFD,0xFFFFF7F7,0x7FBF,0x0000,0x8000,0x0809,0x7FBF,0x100B,0x7EFD,0x17FC,0x7DBB,0x1FD5,0x7BFA,0x278D,0x79BC,0x2F1E,0x7702,0x367F,0x73D1,0x3DAA,0x702A,0x4495,0x6C12,0x4B3C,0x678D,0x5197,0x62A0,0x579F,0x5D4E,0x5D4E,0x579F,0x62A0,0x5197,0x678D,0x4B3C,0x6C12,0x4495,0x702A,0x3DAA,0x73D1,0x367F,0x7702,0x2F1E,0x79BC,0x278D,0x7BFA,0x1FD5,0x7DBB,0x17FC,0x7EFD,0x100A,0x7FBF,0x0809,0x8000,0x0000,0x7FBF,0xFFFFF7F7,0x7EFD,0xFFFFEFF6,0x7DBB,0xFFFFE804,0x7BFA,0xFFFFE02B,0x79BC,0xFFFFD873,0x7702,0xFFFFD0E2,0x73D1,0xFFFFC981,0x702A,0xFFFFC256,0x6C12,0xFFFFBB6A,0x678D,0xFFFFB4C4,0x62A0,0xFFFFAE69,0x5D4E,0xFFFFA861,0x579F,0xFFFFA2B2,0x5197,0xFFFF9D60,0x4B3C,0xFFFF9873,0x4495,0xFFFF93EE,0x3DAA,0xFFFF8FD6,0x367F,0xFFFF8C2F,0x2F1E,0xFFFF88FE,0x278D,0xFFFF8644,0x1FD5,0xFFFF8406,0x17FC,0xFFFF8245,0x100A,0xFFFF8103,0x0809,0xFFFF8041,0x0000,0xFFFF8000,0xFFFFF7F7,0xFFFF8041,0xFFFFEFF6,0xFFFF8103,0xFFFFE804,0xFFFF8245,0xFFFFE02B,0xFFFF8406,0xFFFFD873,0xFFFF8644,0xFFFFD0E2,0xFFFF88FE,0xFFFFC980,0xFFFF8C2F,0xFFFFC256,0xFFFF8FD6,0xFFFFBB6A,0xFFFF93EE,0xFFFFB4C4,0xFFFF9873,0xFFFFAE69,0xFFFF9D60,0xFFFFA861,0xFFFFA2B2,0xFFFFA2B2,0xFFFFA861,0xFFFF9D60,0xFFFFAE69,0xFFFF9873,0xFFFFB4C4,0xFFFF93EE,0xFFFFBB6B,0xFFFF8FD6,0xFFFFC256,0xFFFF8C2F,0xFFFFC981,0xFFFF88FE,0xFFFFD0E2,0xFFFF8644,0xFFFFD873,0xFFFF8406,0xFFFFE02C,0xFFFF8245,0xFFFFE804,0xFFFF8103,0xFFFFEFF6,0xFFFF8041,0xFFFFF7F7,0xFFFF8000,0x0000,0xFFFF8041,0x0809,0xFFFF8103,0x100A,0xFFFF8245,0x17FC,0xFFFF8406,0x1FD5,0xFFFF8644,0x278D,0xFFFF88FE,0x2F1E,0xFFFF8C2F,0x3680,0xFFFF8FD6,0x3DAA,0xFFFF93EE,0x4496,0xFFFF9873,0x4B3C,0xFFFF9D60,0x5197,0xFFFFA2B2,0x579F,0xFFFFA861,0x5D4E,0xFFFFAE69,0x62A0,0xFFFFB4C4,0x678D,0xFFFFBB6B,0x6C12,0xFFFFC256,0x702A,0xFFFFC981,0x73D1,0xFFFFD0E2,0x7702,0xFFFFD873,0x79BC,0xFFFFE02B,0x7BFA,0xFFFFE804,0x7DBB,0xFFFFEFF6,0x7EFD,0xFFFFF7F7,0x7FBF,0x0000,0x8000,0x0809,0x7FBF,0x100A,0x7EFD,0x17FC,0x7DBB,0x1FD5,0x7BFA,0x278D,0x79BC,0x2F1E,0x7702,0x3680,0x73D1,0x3DAA,0x702A,0x4496,0x6C12,0x4B3C,0x678D,0x5197,0x62A0,0x579F,0x5D4E,0x5D4E,0x579F,0x62A0,0x5197,0x678D,0x4B3C,0x6C12,0x4495,0x702A,0x3DAA,0x73D1,0x367F,0x7702,0x2F1E,0x79BC,0x278D,0x7BFA,0x1FD5,0x7DBB,0x17FC,0x7EFD,0x100A,0x7FBF,0x0809,0x8000,0x0000,0x7FBF,0xFFFFF7F7,0x7EFD,0xFFFFEFF6,0x7DBB,0xFFFFE804,0x7BFA,0xFFFFE02C,0x79BC,0xFFFFD873,0x7702,0xFFFFD0E2,0x73D1,0xFFFFC980,0x702A,0xFFFFC256,0x6C12,0xFFFFBB6A,0x678D,0xFFFFB4C4,0x62A0,0xFFFFAE69,0x5D4E,0xFFFFA861,0x579F,0xFFFFA2B2,0x5197,0xFFFF9D60,0x4B3C,0xFFFF9873,0x4495,0xFFFF93EE,0x3DAA,0xFFFF8FD6,0x367F,0xFFFF8C2F,0x2F1E,0xFFFF88FE,0x278D,0xFFFF8644,0x1FD5,0xFFFF8406,0x17FC,0xFFFF8245,0x100A,0xFFFF8103,0x0809,0xFFFF8041,0x0000,0xFFFF8000,0xFFFFF7F7,0xFFFF8041,0xFFFFEFF6,0xFFFF8103,0xFFFFE804,0xFFFF8245,0xFFFFE02B,0xFFFF8406,0xFFFFD873,0xFFFF8644,0xFFFFD0E2,0xFFFF88FE,0xFFFFC981,0xFFFF8C2F,0xFFFFC256,0xFFFF8FD6,0xFFFFBB6A,0xFFFF93EE,0xFFFFB4C4,0xFFFF9873,0xFFFFAE69,0xFFFF9D60,0xFFFFA861,0xFFFFA2B2,0xFFFFA2B2,0xFFFFA861,0xFFFF9D60,0xFFFFAE69,0xFFFF9873,0xFFFFB4C4,0xFFFF93EE,0xFFFFBB6B,0xFFFF8FD6,0xFFFFC256,0xFFFF8C2F,0xFFFFC981,0xFFFF88FE,0xFFFFD0E2,0xFFFF8644,0xFFFFD873,0xFFFF8406,0xFFFFE02B,0xFFFF8245,0xFFFFE804,0xFFFF8103,0xFFFFEFF6,0xFFFF8041,0xFFFFF7F7,0xFFFF8000,0x0000,0xFFFF8041,0x0809,0xFFFF8103,0x100A,0xFFFF8245,0x17FC,0xFFFF8406,0x1FD4,0xFFFF8644,0x278D,0xFFFF88FE,0x2F1E,0xFFFF8C2F,0x367F,0xFFFF8FD6,0x3DAA,0xFFFF93EE,0x4496,0xFFFF9873,0x4B3C,0xFFFF9D60,0x5197,0xFFFFA2B2,0x579F,0xFFFFA861,0x5D4E,0xFFFFAE69,0x62A0,0xFFFFB4C4,0x678D,0xFFFFBB6B,0x6C12,0xFFFFC256,0x702A,0xFFFFC981,0x73D1,0xFFFFD0E2,0x7702,0xFFFFD873,0x79BC,0xFFFFE02B,0x7BFA,0xFFFFE804,0x7DBB,0xFFFFEFF6,0x7EFD,0xFFFFF7F7,0x7FBF,0x0000,0x8000,0x0809,0x7FBF,0x100A,0x7EFD,0x17FC,0x7DBB,0x1FD5,0x7BFA,0x278D,0x79BC,0x2F1E,0x7702,0x3680,0x73D1,0x3DAA,0x702A,0x4496,0x6C12,0x4B3C,0x678D,0x5197,0x62A0,0x579F,0x5D4E,0x5D4E,0x579F,0x62A0,0x5197,0x678D,0x4B3C,0x6C12,0x4495,0x702A,0x3DAA,0x73D1,0x367F,0x7702,0x2F1E,0x79BC,0x278D,0x7BFA,0x1FD4,0x7DBB,0x17FC,0x7EFD,0x100A,0x7FBF,0x0809,0x8000,0x0000,0x7FBF,0xFFFFF7F7,0x7EFD,0xFFFFEFF5,0x7DBB,0xFFFFE804,0x7BFA,0xFFFFE02B,0x79BC,0xFFFFD873,0x7702,0xFFFFD0E2,0x73D1,0xFFFFC981,0x702A,0xFFFFC256,0x6C12,0xFFFFBB6B,0x678D,0xFFFFB4C4,0x62A0,0xFFFFAE69,0x5D4E,0xFFFFA861,0x579F,0xFFFFA2B2,0x5197,0xFFFF9D60,0x4B3C,0xFFFF9873,0x4495,0xFFFF93EE,0x3DAA,0xFFFF8FD6,0x367F,0xFFFF8C2F,0x2F1E,0xFFFF88FE,0x278D,0xFFFF8644,0x1FD5,0xFFFF8406,0x17FC,0xFFFF8245,0x100A,0xFFFF8103,0x0809,0xFFFF8041,0x0000,0xFFFF8000,0xFFFFF7F7,0xFFFF8041,0xFFFFEFF6,0xFFFF8103,0xFFFFE804,0xFFFF8245,0xFFFFE02B,0xFFFF8406,0xFFFFD873,0xFFFF8644,0xFFFFD0E2,0xFFFF88FE,0xFFFFC980,0xFFFF8C2F,0xFFFFC256,0xFFFF8FD6,0xFFFFBB6B,0xFFFF93EE,0xFFFFB4C4,0xFFFF9873,0xFFFFAE69,0xFFFF9D60,0xFFFFA861,0xFFFFA2B2,0xFFFFA2B2,0xFFFFA861,0xFFFF9D60,0xFFFFAE69,0xFFFF9873,0xFFFFB4C4,0xFFFF93EE,0xFFFFBB6B,0xFFFF8FD6,0xFFFFC256,0xFFFF8C2F,0xFFFFC981,0xFFFF88FE,0xFFFFD0E2,0xFFFF8644,0xFFFFD873,0xFFFF8406,0xFFFFE02B,0xFFFF8245,0xFFFFE804,0xFFFF8103,0xFFFFEFF6,0xFFFF8041,0xFFFFF7F7,0xFFFF8000,0x0000,0xFFFF8041,0x0809,0xFFFF8103,0x100A,0xFFFF8245,0x17FC,0xFFFF8406,0x1FD5,0xFFFF8644,0x278D,0xFFFF88FE,0x2F1E,0xFFFF8C2F,0x367F,0xFFFF8FD6,0x3DAA,0xFFFF93EE,0x4496,0xFFFF9873,0x4B3C,0xFFFF9D60,0x5197,0xFFFFA2B2,0x579F,0xFFFFA861,0x5D4E,0xFFFFAE69,0x62A0,0xFFFFB4C4,0x678D,0xFFFFBB6B,0x6C12,0xFFFFC256,0x702A,0xFFFFC981,0x73D1,0xFFFFD0E2,0x7702,0xFFFFD873,0x79BC,0xFFFFE02B,0x7BFA,0xFFFFE804,0x7DBB,0xFFFFEFF6,0x7EFD,0xFFFFF7F7,0x7FBF,0x0000,0x8000,0x0809,0x7FBF,0x100A,0x7EFD,0x17FC,0x7DBB,0x1FD5,0x7BFA,0x278D,0x79BC,0x2F1E,0x7702,0x367F,0x73D1,0x3DAA,0x702A,0x4496,0x6C12,0x4B3C,0x678D,0x5197,0x62A0,0x579F,0x5D4E,0x5D4E,0x579F,0x62A0,0x5197,0x678D,0x4B3C,0x6C12,0x4495,0x702A,0x3DAA,0x73D1,0x367F,0x7702,0x2F1E,0x79BC,0x278D,0x7BFA,0x1FD5,0x7DBB,0x17FC,0x7EFD,0x100A,0x7FBF,0x0809,0x8000,0x0000,0x7FBF,0xFFFFF7F7,0x7EFD,0xFFFFEFF6,0x7DBB,0xFFFFE804,0x7BFA,0xFFFFE02B,0x79BC,0xFFFFD873,0x7702,0xFFFFD0E2,0x73D1,0xFFFFC981,0x702A,0xFFFFC256,0x6C12,0xFFFFBB6A,0x678D,0xFFFFB4C4,0x62A0,0xFFFFAE69,0x5D4E,0xFFFFA861,0x579F,0xFFFFA2B2,0x5196,0xFFFF9D60,0x4B3C,0xFFFF9873,0x4495,0xFFFF93ED,0x3DAA,0xFFFF8FD6,0x367F,0xFFFF8C2F,0x2F1E,0xFFFF88FE,0x278D,0xFFFF8644,0x1FD5,0xFFFF8406,0x17FC,0xFFFF8245,0x100A,0xFFFF8103,0x0809,0xFFFF8041,0x0000,0xFFFF8000,0xFFFFF7F7,0xFFFF8041,0xFFFFEFF6,0xFFFF8103,0xFFFFE804,0xFFFF8245,0xFFFFE02B,0xFFFF8406,0xFFFFD873,0xFFFF8644,0xFFFFD0E2,0xFFFF88FE,0xFFFFC981,0xFFFF8C2F,0xFFFFC256,0xFFFF8FD6,0xFFFFBB6B,0xFFFF93EE,0xFFFFB4C4,0xFFFF9873,0xFFFFAE69,0xFFFF9D60,0xFFFFA861,0xFFFFA2B2,0xFFFFA2B2,0xFFFFA861,0xFFFF9D60,0xFFFFAE6A,0xFFFF9873,0xFFFFB4C4,0xFFFF93ED,0xFFFFBB6B,0xFFFF8FD6,0xFFFFC256,0xFFFF8C2F,0xFFFFC981,0xFFFF88FE,0xFFFFD0E2,0xFFFF8644,0xFFFFD873,0xFFFF8406,0xFFFFE02B,0xFFFF8245,0xFFFFE804,0xFFFF8103,0xFFFFEFF6,0xFFFF8041,0xFFFFF7F7,0xFFFF8000,0x0000,0xFFFF8041,0x0809,0xFFFF8103,0x100A,0xFFFF8245,0x17FC,0xFFFF8406,0x1FD5,0xFFFF8644,0x278D,0xFFFF88FE,0x2F1E,0xFFFF8C2F,0x367F,0xFFFF8FD6,0x3DAA,0xFFFF93EE,0x4495,0xFFFF9873,0x4B3C,0xFFFF9D60,0x5197,0xFFFFA2B2,0x579F,0xFFFFA861,0x5D4E,0xFFFFAE69,0x62A0,0xFFFFB4C4,0x678D,0xFFFFBB6B,0x6C12,0xFFFFC256,0x702A,0xFFFFC981,0x73D1,0xFFFFD0E2,0x7702,0xFFFFD873,0x79BC,0xFFFFE02C,0x7BFA,0xFFFFE804,0x7DBB,0xFFFFEFF6,0x7EFD,0xFFFFF7F7,0x7FBF,0x0000,0x8000,0x0809,0x7FBF,0x100A,0x7EFD,0x17FC,0x7DBB,0x1FD5,0x7BFA,0x278D,0x79BC,0x2F1E,0x7702,0x367F,0x73D1,0x3DAA,0x702A,0x4495,0x6C12,0x4B3C,0x678D,0x5197,0x62A0,0x579F,0x5D4E,0x5D4E,0x579F,0x62A0,0x5197,0x678D,0x4B3C,0x6C13,0x4495,0x702A,0x3DA9,0x73D1,0x367F,0x7702,0x2F1E,0x79BC,0x278D,0x7BFA,0x1FD4,0x7DBB,0x17FB,0x7EFD,0x100A,0x7FBF,0x0809,0x8000,0x0000,0x7FBF,0xFFFFF7F7,0x7EFD,0xFFFFEFF6,0x7DBB,0xFFFFE804,0x7BFA,0xFFFFE02B,0x79BC,0xFFFFD873,0x7702,0xFFFFD0E2,0x73D1,0xFFFFC981,0x702A,0xFFFFC256,0x6C12,0xFFFFBB6B,0x678D,0xFFFFB4C4,0x62A0,0xFFFFAE69,0x5D4E,0xFFFFA861,0x579F,0xFFFFA2B2,0x5197,0xFFFF9D60,0x4B3C,0xFFFF9873,0x4495,0xFFFF93ED,0x3DA9,0xFFFF8FD6,0x367F,0xFFFF8C2F,0x2F1E,0xFFFF88FE,0x278D,0xFFFF8644,0x1FD4,0xFFFF8406,0x17FB,0xFFFF8245,0x100A,0xFFFF8103,0x0809,0xFFFF8041,0x0000,0xFFFF8000,0xFFFFF7F7,0xFFFF8041,0xFFFFEFF5,0xFFFF8103,0xFFFFE804,0xFFFF8245,0xFFFFE02C,0xFFFF8406,0xFFFFD873,0xFFFF8644,0xFFFFD0E2,0xFFFF88FE,0xFFFFC981,0xFFFF8C2F,0xFFFFC256,0xFFFF8FD6,0xFFFFBB6A,0xFFFF93EE,0xFFFFB4C4,0xFFFF9873,0xFFFFAE69,0xFFFF9D60,0xFFFFA861,0xFFFFA2B2,0xFFFFA2B2,0xFFFFA861,0xFFFF9D60,0xFFFFAE69,0xFFFF9873,0xFFFFB4C4,0xFFFF93EE,0xFFFFBB6B,0xFFFF8FD6,0xFFFFC257,0xFFFF8C2F,0xFFFFC981,0xFFFF88FE,0xFFFFD0E2,0xFFFF8644,0xFFFFD873,0xFFFF8406,0xFFFFE02C,0xFFFF8245,0xFFFFE804,0xFFFF8103,0xFFFFEFF6,0xFFFF8041,0xFFFFF7F7,0xFFFF8000,0x0000,0xFFFF8041,0x0809,0xFFFF8103,0x100B,0xFFFF8245,0x17FC,0xFFFF8406,0x1FD5,0xFFFF8644,0x278D,0xFFFF88FE,0x2F1E,0xFFFF8C2F,0x367F,0xFFFF8FD6,0x3DAA,0xFFFF93EE,0x4495,0xFFFF9873,0x4B3C,0xFFFF9D60,0x5197,0xFFFFA2B2,0x579F,0xFFFFA861,0x5D4E,0xFFFFAE69,0x62A0,0xFFFFB4C4,0x678D,0xFFFFBB6B,0x6C12,0xFFFFC256,0x702A,0xFFFFC981,0x73D1,0xFFFFD0E2,0x7702,0xFFFFD873,0x79BC,0xFFFFE02B,0x7BFA,0xFFFFE804,0x7DBB,0xFFFFEFF6,0x7EFD,0xFFFFF7F7,0x7FBF,0x0000,0x8000,0x0809,0x7FBF,0x100A,0x7EFD,0x17FC,0x7DBB,0x1FD5,0x7BFA,0x278D,0x79BC,0x2F1E,0x7702,0x3680,0x73D1,0x3DAA,0x702A,0x4495,0x6C12,0x4B3C,0x678D,0x5197,0x62A0,0x579F,0x5D4E,0x5D4E,0x579F,0x62A0,0x5197,0x678D,0x4B3C,0x6C12,0x4495,0x702A,0x3DAA,0x73D1,0x367F,0x7702,0x2F1E,0x79BC,0x278D,0x7BFA,0x1FD4,0x7DBB,0x17FC,0x7EFD,0x100A,0x7FBF,0x0809
