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
	ldr r1, = 0x5a5a0065
	str r1, [r0, # 0x38]	@

	ldr r1, = 0xc01
	str r1, [r0, # 0x08]	@PB07 作为 GPIO 端口


__pa_chu_shi_hua:
        ldr r0, = 0x48000000 @pa
        ldr r1, = 0x187
        str r1, [r0]		@GPIOx_DIR GPIO 输入输出方向寄存器
        ldr r1, = 0x187
        str r1, [r0, # 0x1c]	@GPIOx_ANALOG GPIO 模拟数字配置寄存器
	
        str r1, [r0, # 0x14]    @8-15
	ldr r1, = 0x330000
        str r1, [r0, # 0x18]    @0-7

__pb_chu_shi_hua:
        ldr r0, = 0x48000100 @pb
        movs r1, #  0x8c
        str r1, [r0]
        movs r1, # 0X0C
        str r1, [r0, # 0x1c]

	str r1, [r0, # 0x14]    @8-15
	movs r1, # 0x07		@PB0=ATIM_CH1
        str r1, [r0, # 0x18]    @0-7



__GTIM_chu_shi_hua:
        ldr r0, = 0x40001800    @GTIM
        movs r1, # 0x30         @翻转模式
	str r1, [r0, # 0x18]    @GTIM_CCMR1CMP 比较模式寄存器 1
        ldr r1, = 0x01
	str r1, [r0, # 0x20]    @开GTIM_CH1
        ldr r1, =  47999	
	str r1, [r0, # 0x2c]    @GTIM_ARR 自动重载寄存器
	movs r1, # 0x70		@OC1REF 信号用作触发输出 (TRGO)
	str r1, [r0, # 0x04]
	movs r1, # 0x01
	str r1, [r0]            @开定时器
	
	
__ATIM_chu_shi_hua:
	ldr r0, = 0x40001400	@ATIM
	movs r1, # 0x30		@翻转模式
	str r1, [r0, # 0x18]	@ATIM_CCMR1CMP 比较模式寄存器 1
	movs r1, # 0x01
	str r1, [r0, # 0x20]	@开ATIM_CH1
	ldr r1, = 0x8000	@MOE=1
	str r1, [r0, # 0x44]
	ldr r1, =  154		@52		
	str r1, [r0, # 0x2c]	@ATIM_ARR 自动重载寄存器
@	movs r1, # 0x25
@	str r1, [r0, # 0x08]	@门控模式
	movs r1, # 0x01
	str r1, [r0]		@开定时器



	

	
__spi_chu_shi_hua_ST7735S:
	ldr r0, = 0x40000800
	ldr r1, = 0x10703	@0x10773	@8位，主机单发模式
	str r1, [r0]
	movs r1, # 0x01
	str r1, [r0, # 0x04]	@开SPI

	ldr r0, = 0x48000100 @PB
	movs r1, # 0x02
	str r1, [r0, # 0x58]	@lcd_cs=0
	
	bl __lcd_chushihua
	bl __lcd_qingping
	
	ldr r2, = 999
	movs r1, # 0
ting:
	mov r0, r1
	bl __xianshi_shuzi
	adds r1, r1, # 1
	cmp r1, r2
	bne ting
        ldr r0, = 0x48000100 @PB
	movs r1, # 0x02
	str r1, [r0, # 0x5c]    @lcd_cs=0
__hc595:
__spi_chu_shi_hua_74hc595:
        ldr r0, = 0x40000800
        ldr r1, = 0x10F03       @0x10773        @8位，主机单发模式
        str r1, [r0]
        movs r1, # 0x01
        str r1, [r0, # 0x04]    @开SPI

        movs r3, # 0
adad:
        bl __lcd_xie_ming_ling
        ldr r1, = led_biao
        ldrh r0, [r1]
        bl __xie_spi1
        bl __lcd_xie_shu_ju

dd:
	b dd
__bbkk:
        bkpt # 3

led_biao:
        .short 0xfdfe,0xfbfd,0xf7fb,0xeff7,0xdfef,0xbfdf,0x7fbf,0xfe7f

	
	

__xianshi_shuzi:
        push {r1-r3,lr}
	@入口R0
       @ ldr r0, = 123456789
        movs r1, # 9    @转换几个字符
        ldr r2, = asciibiao
        movs r3, # 0xff            @小数点位置
        bl __zhuanascii
        ldr r0, = asciibiao
        movs r1, # 9    @显示几个字
        ldr r2, =  0x200020    @位置高16=行，低16=列
        bl __xie_ascii_16
	pop {r1-r3,pc}

	
__lcd_qingping:
	push {r0,r5,r6,lr}
	bl __lcd_xie_ming_ling
	movs r0, # 0x2a        
	bl __xie_spi1
	bl __lcd_xie_shu_ju
	movs r0, # 0
	bl __xie_spi1
        movs r0, # 24
	bl __xie_spi1
        movs r0, # 0
	bl __xie_spi1
	movs r0, # 104
	bl __xie_spi1

        bl __lcd_xie_ming_ling
	movs r0, # 0x2b
        bl __xie_spi1
        bl __lcd_xie_shu_ju
        movs r0, # 0
        bl __xie_spi1
        movs r0, # 0
        bl __xie_spi1
        movs r0, # 0
	bl __xie_spi1
        movs r0, # 159
	bl __xie_spi1

        bl __lcd_xie_ming_ling
	movs r0, # 0x2c
        bl __xie_spi1
        bl __lcd_xie_shu_ju
	ldr r6, = 12958
	movs r5, # 0
__qingping_xunhuan:	
        movs r0, # 0xff		@背景颜色
        bl __xie_spi1
        movs r0, # 0xff
        bl __xie_spi1
	subs r6, r6, # 1
	bne __qingping_xunhuan
	pop {r0,r5,r6,pc}

	
__zhuanascii:	@ 转ASCII
	@ R0要转的数据， R1长度，R2结果表首地址, r3=小数点位置
	push {r4-r7,lr}
	mov r7, r3
	mov r5, r0
	mov r6, r1
	movs r1, # 10
__xunhuanqiuma:
	bl _chufa
	mov r4, r0
	muls r4, r1
	subs r3, r5, r4
	adds r3, r3, # 0x30     @ascii偏移
	mov r5, r0
	subs r6, r6, # 1
	beq __qiumafanhui
	cmp r6, r7
	bne __meidaoxiaoshudian
	movs r4, # 0x2e         @小数点
	strb r4, [r2,r6]        @插入小数点
	subs r6, r6, # 1
__meidaoxiaoshudian:
	strb r3, [r2,r6]
	movs r6, r6
	bne __xunhuanqiuma
	pop {r4-r7,pc}
__qiumafanhui:
	strb r3, [r2, r6]
	pop {r4-r7,pc}
	.ltorg

	
__xie_ascii_16:
	push {r3-r7,lr}
	@入口r0=ascii地址
	@r1=写几个字
	@r2=要写的地址
	mov r6, r9
	push {r6}
	mov r9, r2
	mov r7, r1
	movs r1, # 18
	movs r2, # 2
	mov r5, r0
	movs r6, # 0
__xie_lcd_dizhi_16:
	mov r0, r9
	bl __xie_lcd_weizhi_16
__du_ascii_16:
	ldrb r0, [r5, r6]
	subs r0, r0, # 32
	muls r0, r0, r1
	ldr r3, = ascii_biao_16
	add r3, r3, r0
__du_ziku_chu_shi_hua:
	movs r4, # 0
__du_ziku_16:
	ldrh r0, [r3, r4]
	add r4, r4, r2
	cmp r4, r1
	bhi __duwan_ziku_16
	bl __xie_lcd_lie_16
	b __du_ziku_16
__duwan_ziku_16:
	adds r6, r6, # 1
	cmp r6, r7
	bne __du_ascii_16
	pop {r6}
	mov r6, r9
	pop {r3-r7,pc}


__xie_lcd_weizhi_16:
	@入口R0= 高16行，低16列
	push {r1,r2,lr}
	mov r1, r0
	mov r2, r1
	lsrs r1, r1, # 16
	lsls r2, r2, # 16
	lsrs r2, r2, # 16

	bl __lcd_xie_ming_ling
        movs r0, # 0x2a
        bl __xie_spi1
        bl __lcd_xie_shu_ju
        movs r0, # 0x00
        bl __xie_spi1
	
        movs r0, # 24
	adds r0, r0, r1
        bl __xie_spi1
	
	movs r0, # 0x00
	bl __xie_spi1
	
	movs r0, # 24
	adds r0, r0, r1
	adds r0, r0, # 15
	bl __xie_spi1

	
	
        bl __lcd_xie_ming_ling
        movs r0, # 0x2b
        bl __xie_spi1
        bl __lcd_xie_shu_ju
	
        movs r0, # 0x00
        bl __xie_spi1
	
        movs r0, # 0
	adds r0, r0, r2
        bl __xie_spi1

        bl __lcd_xie_ming_ling
        movs r0, # 0x2c
        bl __xie_spi1
	bl __lcd_xie_shu_ju
	pop {r1,r2,pc}






	
__xie_lcd_lie_16:
	@入口R0=16位
	push {r1-r2, lr}
	mov r1, r0
	lsls r1, r1, # 15
	movs r2, # 16
__xie_lcd_lie16_xunhuan:
	lsls r1, r1, # 1
	bmi __xie_lcd_16_1
        movs r0, # 0xff
        bl __xie_spi1
        movs r0, # 0x00
        bl __xie_spi1
	subs r2, r2, # 1
	bne __xie_lcd_lie16_xunhuan
	pop {r1-r2,pc}
__xie_lcd_16_1:
        movs r0, # 0
        bl __xie_spi1
        movs r0, # 0x00
        bl __xie_spi1
	subs r2, r2, # 1
	bne __xie_lcd_lie16_xunhuan
	pop {r1-r2,pc}

	.ltorg



















	


__xie_ascii:
	push {r3-r7,lr}
	@入口r0=ascii地址
	@r1=写几个字
	@r2=要写的地址
	mov r6, r9
	push {r6}
	mov r9, r2
	mov r7, r1
	movs r1, # 6
	movs r2, # 1
	mov r5, r0
	movs r6, # 0
__xie_lcd_dizhi2:
	mov r0, r9
	bl __xie_lcd_weizhi_1
__du_ascii2:
	ldrb r0, [r5, r6]
	subs r0, r0, # 32
	muls r0, r0, r1
	ldr r3, = ascii_biao
	add r3, r3, r0
__du_ziku_chushihua2:
	movs r4, # 0
__du_ziku1:
	ldrb r0, [r3, r4]
	add r4, r4, r2
	cmp r4, r1
	bhi __duwan_ziku1
	bl __xie_lcd_lie
	b __du_ziku1
__duwan_ziku1:
	adds r6, r6, # 1
	cmp r6, r7
	bne __du_ascii2
	pop {r6}
	mov r6, r9
	pop {r3-r7,pc}


__xie_lcd_weizhi_1:
	@入口R0= 高16行，低16列
	push {r1,r2,lr}
	mov r1, r0
	mov r2, r1
	lsrs r1, r1, # 16
	lsls r2, r2, # 16
	lsrs r2, r2, # 16

	bl __lcd_xie_ming_ling
        movs r0, # 0x2a
        bl __xie_spi1
        bl __lcd_xie_shu_ju
        movs r0, # 0x00
        bl __xie_spi1
	
        movs r0, # 24
	adds r0, r0, r1
        bl __xie_spi1
	
	movs r0, # 0x00
	bl __xie_spi1
	
	movs r0, # 24
	adds r0, r0, r1
	adds r0, r0, # 7
	bl __xie_spi1

	
	
        bl __lcd_xie_ming_ling
        movs r0, # 0x2b
        bl __xie_spi1
        bl __lcd_xie_shu_ju
	
        movs r0, # 0x00
        bl __xie_spi1
	
        movs r0, # 0
	adds r0, r0, r2
        bl __xie_spi1

        bl __lcd_xie_ming_ling
        movs r0, # 0x2c
        bl __xie_spi1
	bl __lcd_xie_shu_ju
	pop {r1,r2,pc}






	
__xie_lcd_lie:
	@入口R0=8位
	push {r1-r2, lr}
	mov r1, r0
	lsls r1, r1, # 23
	movs r2, # 8
__xie_lcd_lie_xunhuan:
	lsls r1, r1, # 1
	bmi __xie_lcd_8_1
        movs r0, # 0xff
        bl __xie_spi1
        movs r0, # 0x00
        bl __xie_spi1
	subs r2, r2, # 1
	bne __xie_lcd_lie_xunhuan
	pop {r1-r2,pc}
__xie_lcd_8_1:
        movs r0, # 0
        bl __xie_spi1
        movs r0, # 0x00
        bl __xie_spi1
	subs r2, r2, # 1
	bne __xie_lcd_lie_xunhuan
	pop {r1-r2,pc}





	



	
__lcd_chushihua:
	push {r0-r2,lr}
	ldr r0,  = 0x48000000
	movs r1, # 0x40
	str r1, [r0, 0x5c]            @RST=1
	ldr r2, = 0x1ffff
	bl __lcd_yanshi

	str r1, [r0, 0x58]            @RST=0
	ldr r2, = 0x1ffff
	bl __lcd_yanshi

	str r1, [r0, # 0x5c]            @RST=1
	ldr r2, = 0x1ffff
	bl __lcd_yanshi

	ldr r2, = 0x1ffff
	bl __lcd_yanshi

	bl __lcd_xie_ming_ling
	movs r0, # 0x01		@软件复位
	bl __xie_spi1
	ldr r2, = 0x1ffff
	bl __lcd_yanshi
	movs r0, # 0x11		@退出休眠
	bl __xie_spi1
	ldr r2, = 0x1ffff
	bl __lcd_yanshi

	
	movs r0, # 0xb1		@设置帧率
	bl __xie_spi1
	bl __lcd_xie_shu_ju
	movs r0, # 0x01
	bl __xie_spi1
	movs r0, # 0x2c
	bl __xie_spi1
	movs r0, # 0x2d
	bl __xie_spi1

	bl __lcd_xie_ming_ling
	movs r0, # 0xb2		@设置帧率
	bl __xie_spi1
	bl __lcd_xie_shu_ju
	movs r0, # 0x01
	bl __xie_spi1
	movs r0, # 0x2c
	bl __xie_spi1
	movs r0, # 0x2d
	bl __xie_spi1


	bl __lcd_xie_ming_ling
	movs r0, # 0xb3		@设置帧率
	bl __xie_spi1
	bl __lcd_xie_shu_ju
	movs r0, # 0x01
	bl __xie_spi1
	movs r0, # 0x2c
	bl __xie_spi1
	movs r0, # 0x2d
	bl __xie_spi1
	movs r0, # 0x01
	bl __xie_spi1
	movs r0, # 0x2c
	bl __xie_spi1
	movs r0, # 0x2d
	bl __xie_spi1

	bl __lcd_xie_ming_ling
	movs r0, # 0xb4		@关闭外部振荡器
	bl __xie_spi1
	bl __lcd_xie_shu_ju
	movs r0, # 0x07
	bl __xie_spi1

	bl __lcd_xie_ming_ling
	movs r0, # 0xc0		@设置电源控制1
	bl __xie_spi1
	bl __lcd_xie_shu_ju
	movs r0, # 0xa2
	bl __xie_spi1
	movs r0, # 0x02
	bl __xie_spi1
	movs r0, # 0x84
	bl __xie_spi1

	bl __lcd_xie_ming_ling
	movs r0, # 0xc1		@设置电源控制2
	bl __xie_spi1
	bl __lcd_xie_shu_ju
	movs r0, # 0xc5
	bl __xie_spi1

	bl __lcd_xie_ming_ling
	movs r0, # 0xc2		@设置电源控制3
	bl __xie_spi1
	bl __lcd_xie_shu_ju
	movs r0, # 0x0a
	bl __xie_spi1
	movs r0, # 0x00
	bl __xie_spi1

	bl __lcd_xie_ming_ling
	movs r0, # 0xc3		@设置电源控制4
	bl __xie_spi1
	bl __lcd_xie_shu_ju
	movs r0, # 0x8a
	bl __xie_spi1
	movs r0, # 0x2a
	bl __xie_spi1

	bl __lcd_xie_ming_ling
	movs r0, # 0xc4		@设置电源控制5
	bl __xie_spi1
	bl __lcd_xie_shu_ju
	movs r0, # 0x8a
	bl __xie_spi1
	movs r0, # 0xee
	bl __xie_spi1

	bl __lcd_xie_ming_ling
	movs r0, # 0xc5
	bl __xie_spi1
	bl __lcd_xie_shu_ju
	movs r0, # 0x0e
	bl __xie_spi1

	bl __lcd_xie_ming_ling
	movs r0, # 0x36
	bl __xie_spi1
	bl __lcd_xie_shu_ju
	movs r0, # 0xc8
	bl __xie_spi1

	bl __lcd_xie_ming_ling
	movs r0, # 0x3a
	bl __xie_spi1
	bl __lcd_xie_shu_ju
	movs r0, # 0x05
	bl __xie_spi1
	
	bl __lcd_xie_ming_ling
	movs r0, # 0x29
	bl __xie_spi1
	pop {r0-r2,pc}

__lcd_yanshi:
	subs r2, r2, # 1
	bne __lcd_yanshi
	bx lr

__xie_spi1:
        push {r1-r2}
        ldr r1, = 0x40000800
__deng_huan_chong_kong:
        ldr r2, [r1, # 0x14]
        lsls r2, r2, # 31
        bpl __deng_huan_chong_kong
	str r0, [r1, # 0x1c]
__deng_huan_chong_kong1:
        ldr r2, [r1, # 0x14]
        lsls r2, r2, # 31
        bpl __deng_huan_chong_kong1
__busy_zong_xian_mang:
        ldr r2, [r1, # 0x14]
        lsls r2, r2, # 23
        bmi __busy_zong_xian_mang
        pop {r1-r2}
        bx lr
__lcd_xie_ming_ling:
	push {r0-r1}
	ldr r0, = 0x48000000
	movs r1, # 0x08
	str r1, [r0, # 0x58]            @0写命令
	pop {r0-r1}
	bx lr
__lcd_xie_shu_ju:
        push {r0-r1}
        ldr r0, = 0x48000000
        movs r1, # 0x08
	str r1, [r0, # 0x5c]            @1写数据
        pop {r0-r1}
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
	.equ zhanding,	0x20000100
	.equ asciibiao,	0x20000500

a0123456789:
	.ascii "0123456789"
	.align 4
ascii_biao:				@6*8
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 @
	.byte 0x00, 0x00, 0x00, 0x4F, 0x00, 0x00 @ !
	.byte 0x00, 0x00, 0x07, 0x00, 0x07, 0x00 @ "
	.byte 0x00, 0x14, 0x7F, 0x14, 0x7F, 0x14 @ #
	.byte 0x00, 0x24, 0x2A, 0x7F, 0x2A, 0x12 @ $
	.byte 0x00, 0x23, 0x13, 0x08, 0x64, 0x62 @ %
	.byte 0x00, 0x36, 0x49, 0x55, 0x22, 0x50 @ &
	.byte 0x00, 0x00, 0x05, 0x03, 0x00, 0x00 @ '
	.byte 0x00, 0x00, 0x1C, 0x22, 0x41, 0x00 @ (
	.byte 0x00, 0x00, 0x41, 0x22, 0x1C, 0x00 @ )
	.byte 0x00, 0x14, 0x08, 0x3E, 0x08, 0x14 @ *
	.byte 0x00, 0x08, 0x08, 0x3E, 0x08, 0x08 @ +
	.byte 0x00, 0x00, 0x50, 0x30, 0x00, 0x00 @ ,
	.byte 0x00, 0x08, 0x08, 0x08, 0x08, 0x08 @ -
	.byte 0x00, 0x00, 0x60, 0x60, 0x00, 0x00 @ .
	.byte 0x00, 0x20, 0x10, 0x08, 0x04, 0x02 @ /
	.byte 0x00, 0x3E, 0x51, 0x49, 0x45, 0x3E @ 0
	.byte 0x00, 0x00, 0x42, 0x7F, 0x40, 0x00 @ 1
	.byte 0x00, 0x42, 0x61, 0x51, 0x49, 0x46 @ 2
	.byte 0x00, 0x21, 0x41, 0x45, 0x4B, 0x31 @ 3
	.byte 0x00, 0x18, 0x14, 0x12, 0x7F, 0x10 @ 4
	.byte 0x00, 0x27, 0x45, 0x45, 0x45, 0x39 @ 5
	.byte 0x00, 0x3C, 0x4A, 0x49, 0x49, 0x30 @ 6
	.byte 0x00, 0x01, 0x01, 0x79, 0x05, 0x03 @ 7
	.byte 0x00, 0x36, 0x49, 0x49, 0x49, 0x36 @ 8
	.byte 0x00, 0x06, 0x49, 0x49, 0x29, 0x1E @ 9
	.byte 0x00, 0x00, 0x36, 0x36, 0x00, 0x00 @ :
	.byte 0x00, 0x00, 0x56, 0x36, 0x00, 0x00 @ ;
	.byte 0x00, 0x08, 0x14, 0x22, 0x41, 0x00 @ <
	.byte 0x00, 0x14, 0x14, 0x14, 0x14, 0x14 @ =
	.byte 0x00, 0x00, 0x41, 0x22, 0x14, 0x08 @ >
	.byte 0x02, 0x01, 0x51, 0x09, 0x06, 0x00 @ ?
	.byte 0x00, 0x32, 0x49, 0x79, 0x41, 0x3E @ @
	.byte 0x00, 0x7E, 0x11, 0x11, 0x11, 0x7E @ A
	.byte 0x00, 0x41, 0x7F, 0x49, 0x49, 0x36 @ B
	.byte 0x00, 0x3E, 0x41, 0x41, 0x41, 0x22 @ C
	.byte 0x00, 0x41, 0x7F, 0x41, 0x41, 0x3E @ D
	.byte 0x00, 0x7F, 0x49, 0x49, 0x49, 0x49 @ E
	.byte 0x00, 0x7F, 0x09, 0x09, 0x09, 0x09 @ F
	.byte 0x00, 0x3E, 0x41, 0x41, 0x51, 0x72 @ G
	.byte 0x00, 0x7F, 0x08, 0x08, 0x08, 0x7F @ H
	.byte 0x00, 0x00, 0x41, 0x7F, 0x41, 0x00 @ I
	.byte 0x00, 0x20, 0x40, 0x41, 0x3F, 0x01 @ J
	.byte 0x00, 0x7F, 0x08, 0x14, 0x22, 0x41 @ K
	.byte 0x00, 0x7F, 0x40, 0x40, 0x40, 0x40 @ L
	.byte 0x00, 0x7F, 0x02, 0x0C, 0x02, 0x7F @ M
	.byte 0x81, 0x7F, 0x06, 0x08, 0x30, 0x7F @ N
	.byte 0x00, 0x3E, 0x41, 0x41, 0x41, 0x3E @ O
	.byte 0x00, 0x7F, 0x09, 0x09, 0x09, 0x06 @ P
	.byte 0x00, 0x3E, 0x41, 0x51, 0x21, 0x5E @ Q
	.byte 0x00, 0x7F, 0x09, 0x19, 0x29, 0x46 @ R
	.byte 0x00, 0x26, 0x49, 0x49, 0x49, 0x32 @ S
	.byte 0x00, 0x01, 0x01, 0x7F, 0x01, 0x01 @ T
	.byte 0x00, 0x3F, 0x40, 0x40, 0x40, 0x3F @ U
	.byte 0x00, 0x1F, 0x20, 0x40, 0x20, 0x1F @ V
	.byte 0x00, 0x7F, 0x20, 0x18, 0x20, 0x7F @ W
	.byte 0x00, 0x63, 0x14, 0x08, 0x14, 0x63 @ X
	.byte 0x00, 0x07, 0x08, 0x70, 0x08, 0x07 @ Y
	.byte 0x00, 0x61, 0x51, 0x49, 0x45, 0x43 @ Z
	.byte 0x00, 0x00, 0x7F, 0x41, 0x41, 0x00 @ [
	.byte 0x00, 0x02, 0x04, 0x08, 0x10, 0x20 @ BackSlash
	.byte 0x00, 0x00, 0x41, 0x41, 0x7F, 0x00 @ ]
	.byte 0x00, 0x04, 0x02, 0x01, 0x02, 0x04 @ ^
	.byte 0x00, 0x40, 0x40, 0x40, 0x40, 0x40 @ _
	.byte 0x00, 0x01, 0x02, 0x04, 0x00, 0x00 @ `
	.byte 0x00, 0x20, 0x54, 0x54, 0x54, 0x78 @ a
	.byte 0x00, 0x7F, 0x48, 0x44, 0x44, 0x38 @ b
	.byte 0x00, 0x38, 0x44, 0x44, 0x44, 0x28 @ c
	.byte 0x00, 0x38, 0x44, 0x44, 0x48, 0x7F @ d
	.byte 0x00, 0x38, 0x54, 0x54, 0x54, 0x18 @ e
	.byte 0x00, 0x00, 0x08, 0x7E, 0x09, 0x02 @ f
	.byte 0x00, 0x0C, 0x52, 0x52, 0x4C, 0x3E @ g
	.byte 0x00, 0x7F, 0x08, 0x04, 0x04, 0x78 @ h
	.byte 0x00, 0x00, 0x44, 0x7D, 0x40, 0x00 @ i
	.byte 0x00, 0x20, 0x40, 0x44, 0x3D, 0x00 @ j
	.byte 0x00, 0x00, 0x7F, 0x10, 0x28, 0x44 @ k
	.byte 0x00, 0x00, 0x41, 0x7F, 0x40, 0x00 @ l
	.byte 0x00, 0x78, 0x04, 0x78, 0x04, 0x78 @ m
	.byte 0x00, 0x7C, 0x08, 0x04, 0x04, 0x78 @ n
	.byte 0x00, 0x38, 0x7C, 0x7C, 0x7C, 0x38 @ o
	.byte 0x00, 0x7E, 0x0C, 0x12, 0x12, 0x0C @ p
	.byte 0x00, 0x0C, 0x12, 0x12, 0x0C, 0x7E @ q
	.byte 0x00, 0x7C, 0x08, 0x04, 0x04, 0x08 @ r
	.byte 0x00, 0x58, 0x54, 0x54, 0x54, 0x64 @ s
	.byte 0x00, 0x04, 0x3F, 0x44, 0x40, 0x20 @ t
	.byte 0x00, 0x3C, 0x40, 0x40, 0x3C, 0x40 @ u
	.byte 0x00, 0x1C, 0x20, 0x40, 0x20, 0x1C @ v
	.byte 0x00, 0x3C, 0x40, 0x30, 0x40, 0x3C @ w
	.byte 0x00, 0x44, 0x28, 0x10, 0x28, 0x44 @ x
	.byte 0x00, 0x1C, 0xA0, 0xA0, 0x90, 0x7C @ y
	.byte 0x00, 0x44, 0x64, 0x54, 0x4C, 0x44 @ z
	.byte 0x00, 0x00, 0x08, 0x36, 0x41, 0x00 @ {
	.byte 0x00, 0x00, 0x00, 0x77, 0x00, 0x00 @ |
	.byte 0x00, 0x00, 0x41, 0x36, 0x08, 0x00 @ }
	.byte 0x00, 0x02, 0x01, 0x02, 0x04, 0x02 @ ~
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 @

	.align 4
ascii_biao_16:	@hack 9*16	
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   @  
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFE, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   @ !
 .byte 0x00, 0x00, 0x00, 0x00, 0x1E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   @ "
 .byte 0x00, 0x01, 0x10, 0x09, 0xD0, 0x07, 0x7C, 0x01, 0x16, 0x0D, 0xD0, 0x07, 0x7C, 0x01, 0x16, 0x01, 0x10, 0x00   @ #
 .byte 0x00, 0x00, 0x00, 0x00, 0x78, 0x0C, 0x44, 0x08, 0xFE, 0x3F, 0xC4, 0x08, 0x8C, 0x08, 0x08, 0x07, 0x00, 0x00   @ $
 .byte 0x18, 0x01, 0xA4, 0x00, 0xA4, 0x00, 0xA4, 0x00, 0x58, 0x07, 0xC0, 0x08, 0xC0, 0x08, 0xA0, 0x08, 0x20, 0x07   @ %
 .byte 0x00, 0x00, 0x80, 0x03, 0x7C, 0x04, 0x62, 0x08, 0xC2, 0x08, 0x82, 0x09, 0x06, 0x0F, 0x00, 0x0E, 0xC0, 0x09   @ &
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x1E, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   @ '
 .byte 0x00, 0x00, 0x00, 0x00, 0xF8, 0x0F, 0x06, 0x30, 0x02, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   @ (
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x20, 0x06, 0x30, 0xF8, 0x0F, 0x00, 0x00, 0x00, 0x00   @ )
 .byte 0x00, 0x00, 0x08, 0x00, 0x90, 0x00, 0x70, 0x00, 0x3E, 0x00, 0x70, 0x00, 0x90, 0x00, 0x08, 0x00, 0x00, 0x00   @ *
 .byte 0x00, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0xF0, 0x07, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00   @ +
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x00, 0x4C, 0x00, 0x3C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   @ ,
 .byte 0x00, 0x00, 0x00, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x00, 0x00   @ -
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x0C, 0x00, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   @ .
 .byte 0x00, 0x00, 0x00, 0x10, 0x00, 0x1C, 0x00, 0x07, 0xC0, 0x00, 0x38, 0x00, 0x0E, 0x00, 0x02, 0x00, 0x00, 0x00   @ /
 .byte 0x00, 0x00, 0xF8, 0x03, 0x04, 0x04, 0x02, 0x08, 0xF2, 0x09, 0x02, 0x08, 0x04, 0x04, 0xF8, 0x03, 0x00, 0x00   @ 0
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x08, 0x06, 0x08, 0xFE, 0x0F, 0x00, 0x08, 0x00, 0x08, 0x00, 0x00   @ 1
 .byte 0x00, 0x00, 0x04, 0x0C, 0x02, 0x0E, 0x02, 0x09, 0x82, 0x08, 0x42, 0x08, 0x3C, 0x08, 0x00, 0x00, 0x00, 0x00   @ 2
 .byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x0C, 0x02, 0x08, 0x42, 0x08, 0x42, 0x08, 0x42, 0x08, 0xBC, 0x07, 0x00, 0x00   @ 3
 .byte 0x00, 0x00, 0x00, 0x01, 0xC0, 0x01, 0x30, 0x01, 0x18, 0x01, 0x06, 0x01, 0xFE, 0x0F, 0x00, 0x01, 0x00, 0x00   @ 4
 .byte 0x00, 0x00, 0x40, 0x0C, 0x3E, 0x08, 0x22, 0x08, 0x22, 0x08, 0x62, 0x0C, 0xC2, 0x07, 0x00, 0x00, 0x00, 0x00   @ 5
 .byte 0x00, 0x00, 0xF8, 0x03, 0xC4, 0x07, 0x62, 0x0C, 0x22, 0x08, 0x22, 0x08, 0x22, 0x08, 0xC2, 0x07, 0x00, 0x00   @ 6
 .byte 0x00, 0x00, 0x02, 0x00, 0x02, 0x08, 0x02, 0x0E, 0x82, 0x07, 0xF2, 0x00, 0x3E, 0x00, 0x06, 0x00, 0x00, 0x00   @ 7
 .byte 0x00, 0x00, 0x9C, 0x07, 0xA6, 0x0C, 0x42, 0x08, 0x42, 0x08, 0x42, 0x08, 0xA2, 0x08, 0x9C, 0x07, 0x00, 0x00   @ 8
 .byte 0x00, 0x00, 0x7C, 0x0C, 0x82, 0x08, 0x82, 0x08, 0x82, 0x08, 0xC6, 0x08, 0x7C, 0x04, 0xF8, 0x03, 0x00, 0x00   @ 9
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x70, 0x0C, 0x20, 0x0C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   @ :
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x40, 0x70, 0x4C, 0x20, 0x3C, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   @ ;
 .byte 0x00, 0x00, 0x80, 0x01, 0xC0, 0x01, 0x40, 0x01, 0x40, 0x02, 0x20, 0x02, 0x20, 0x06, 0x30, 0x04, 0x00, 0x00   @ <
 .byte 0x00, 0x00, 0x20, 0x01, 0x20, 0x01, 0x20, 0x01, 0x20, 0x01, 0x20, 0x01, 0x20, 0x01, 0x20, 0x01, 0x00, 0x00   @ =
 .byte 0x00, 0x00, 0x30, 0x04, 0x20, 0x06, 0x20, 0x02, 0x40, 0x02, 0x40, 0x01, 0xC0, 0x01, 0x80, 0x01, 0x00, 0x00   @ >
 .byte 0x00, 0x00, 0x00, 0x00, 0x06, 0x00, 0x02, 0x00, 0xC2, 0x0D, 0x22, 0x00, 0x1E, 0x00, 0x00, 0x00, 0x00, 0x00   @ ?
 .byte 0xE0, 0x07, 0x10, 0x18, 0x08, 0x10, 0xC4, 0x23, 0x24, 0x24, 0x24, 0x24, 0x24, 0x24, 0x68, 0x06, 0xF0, 0x07   @ @
 .byte 0x00, 0x08, 0x00, 0x0F, 0xE0, 0x01, 0x3E, 0x01, 0x02, 0x01, 0x3E, 0x01, 0xE0, 0x01, 0x00, 0x0F, 0x00, 0x08   @ A
 .byte 0x00, 0x00, 0xFE, 0x0F, 0x42, 0x08, 0x42, 0x08, 0x42, 0x08, 0x42, 0x08, 0x42, 0x08, 0xBC, 0x07, 0x00, 0x00   @ B
 .byte 0x00, 0x00, 0xF8, 0x03, 0x06, 0x0C, 0x02, 0x08, 0x02, 0x08, 0x02, 0x08, 0x06, 0x0C, 0x00, 0x00, 0x00, 0x00   @ C
 .byte 0x00, 0x00, 0xFE, 0x0F, 0x02, 0x08, 0x02, 0x08, 0x02, 0x08, 0x02, 0x08, 0x04, 0x04, 0xF8, 0x03, 0x00, 0x00   @ D
 .byte 0x00, 0x00, 0x00, 0x00, 0xFE, 0x0F, 0x42, 0x08, 0x42, 0x08, 0x42, 0x08, 0x42, 0x08, 0x42, 0x08, 0x00, 0x00   @ E
 .byte 0x00, 0x00, 0x00, 0x00, 0xFE, 0x0F, 0x42, 0x00, 0x42, 0x00, 0x42, 0x00, 0x42, 0x00, 0x42, 0x00, 0x00, 0x00   @ F
 .byte 0x00, 0x00, 0xF8, 0x03, 0x04, 0x04, 0x02, 0x08, 0x02, 0x08, 0x82, 0x08, 0x82, 0x08, 0x86, 0x07, 0x00, 0x00   @ G
 .byte 0x00, 0x00, 0xFC, 0x0F, 0x40, 0x00, 0x40, 0x00, 0x40, 0x00, 0x40, 0x00, 0x40, 0x00, 0xFC, 0x0F, 0x00, 0x00   @ H
 .byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x08, 0x02, 0x08, 0xFE, 0x0F, 0x02, 0x08, 0x02, 0x08, 0x00, 0x00, 0x00, 0x00   @ I
 .byte 0x00, 0x00, 0x00, 0x0C, 0x00, 0x08, 0x02, 0x08, 0x02, 0x08, 0x02, 0x08, 0xFE, 0x07, 0x00, 0x00, 0x00, 0x00   @ J
 .byte 0x00, 0x00, 0xFE, 0x0F, 0x60, 0x00, 0x70, 0x00, 0xD8, 0x01, 0x0C, 0x03, 0x06, 0x0E, 0x02, 0x08, 0x00, 0x00   @ K
 .byte 0x00, 0x00, 0x00, 0x00, 0xFE, 0x0F, 0x00, 0x08, 0x00, 0x08, 0x00, 0x08, 0x00, 0x08, 0x00, 0x08, 0x00, 0x00   @ L
 .byte 0x00, 0x00, 0xFE, 0x0F, 0x0E, 0x00, 0x78, 0x00, 0x80, 0x00, 0x78, 0x00, 0x0E, 0x00, 0xFE, 0x0F, 0x00, 0x00   @ M
 .byte 0x00, 0x00, 0xFE, 0x0F, 0x0E, 0x00, 0x3C, 0x00, 0xF0, 0x01, 0x80, 0x07, 0x00, 0x0E, 0xFE, 0x0F, 0x00, 0x00   @ N
 .byte 0x00, 0x00, 0xF8, 0x03, 0x04, 0x04, 0x02, 0x08, 0x02, 0x08, 0x02, 0x08, 0x06, 0x0C, 0xF8, 0x03, 0x00, 0x00   @ O
 .byte 0x00, 0x00, 0xFE, 0x0F, 0x82, 0x00, 0x82, 0x00, 0x82, 0x00, 0x82, 0x00, 0xC6, 0x00, 0x7C, 0x00, 0x00, 0x00   @ P
 .byte 0x00, 0x00, 0xF8, 0x03, 0x04, 0x04, 0x02, 0x08, 0x02, 0x08, 0x02, 0x08, 0x06, 0x3C, 0xF8, 0x23, 0x00, 0x00   @ Q
 .byte 0x00, 0x00, 0xFE, 0x0F, 0x42, 0x00, 0x42, 0x00, 0x42, 0x00, 0xC2, 0x00, 0xBC, 0x03, 0x00, 0x0E, 0x00, 0x08   @ R
 .byte 0x00, 0x00, 0x3C, 0x0C, 0x64, 0x08, 0x62, 0x08, 0x42, 0x08, 0x42, 0x08, 0xC2, 0x08, 0x86, 0x07, 0x00, 0x00   @ S
 .byte 0x00, 0x00, 0x02, 0x00, 0x02, 0x00, 0x02, 0x00, 0xFE, 0x0F, 0x02, 0x00, 0x02, 0x00, 0x02, 0x00, 0x00, 0x00   @ T
 .byte 0x00, 0x00, 0xFE, 0x07, 0x00, 0x08, 0x00, 0x08, 0x00, 0x08, 0x00, 0x08, 0xFE, 0x07, 0x00, 0x00, 0x00, 0x00   @ U
 .byte 0x02, 0x00, 0x1E, 0x00, 0xF8, 0x00, 0x80, 0x0F, 0x00, 0x08, 0x80, 0x0F, 0xF8, 0x00, 0x1E, 0x00, 0x02, 0x00   @ V
 .byte 0x0E, 0x00, 0xFC, 0x07, 0x00, 0x0C, 0xE0, 0x03, 0x30, 0x00, 0xE0, 0x03, 0x00, 0x0C, 0xFC, 0x07, 0x1E, 0x00   @ W
 .byte 0x00, 0x08, 0x02, 0x0C, 0x0C, 0x07, 0xB8, 0x01, 0xE0, 0x00, 0xF0, 0x01, 0x0C, 0x07, 0x06, 0x0C, 0x02, 0x08   @ X
 .byte 0x02, 0x00, 0x06, 0x00, 0x1C, 0x00, 0x30, 0x00, 0xC0, 0x0F, 0x30, 0x00, 0x1C, 0x00, 0x06, 0x00, 0x02, 0x00   @ Y
 .byte 0x00, 0x00, 0x02, 0x0C, 0x02, 0x0E, 0x82, 0x0B, 0xC2, 0x08, 0x72, 0x08, 0x1E, 0x08, 0x0E, 0x08, 0x00, 0x08   @ Z
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFE, 0x3F, 0x00, 0x20, 0x00, 0x20, 0x00, 0x00, 0x00, 0x00   @ [
 .byte 0x00, 0x00, 0x02, 0x00, 0x0E, 0x00, 0x38, 0x00, 0xC0, 0x00, 0x00, 0x07, 0x00, 0x1C, 0x00, 0x10, 0x00, 0x00   @ BackSlash
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x20, 0xFE, 0x3F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   @ ]
 .byte 0x00, 0x00, 0x10, 0x00, 0x08, 0x00, 0x06, 0x00, 0x02, 0x00, 0x06, 0x00, 0x08, 0x00, 0x10, 0x00, 0x10, 0x00   @ ^
 .byte 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x80, 0x00, 0x00   @ _
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x06, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   @ `
 .byte 0x00, 0x00, 0x30, 0x07, 0x90, 0x08, 0x90, 0x08, 0x90, 0x08, 0x90, 0x04, 0xE0, 0x0F, 0x00, 0x00, 0x00, 0x00   @ a
 .byte 0x00, 0x00, 0xFE, 0x0F, 0x20, 0x0C, 0x10, 0x08, 0x10, 0x08, 0x10, 0x08, 0x30, 0x0C, 0xE0, 0x07, 0x00, 0x00   @ b
 .byte 0x00, 0x00, 0x00, 0x00, 0xE0, 0x07, 0x30, 0x0C, 0x10, 0x08, 0x10, 0x08, 0x10, 0x08, 0x30, 0x0C, 0x00, 0x00   @ c
 .byte 0x00, 0x00, 0xE0, 0x07, 0x10, 0x08, 0x10, 0x08, 0x10, 0x08, 0x30, 0x04, 0xFE, 0x0F, 0x00, 0x00, 0x00, 0x00   @ d
 .byte 0x00, 0x00, 0xC0, 0x03, 0xA0, 0x04, 0x90, 0x08, 0x90, 0x08, 0x90, 0x08, 0xB0, 0x08, 0xE0, 0x0C, 0x00, 0x00   @ e
 .byte 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x10, 0x00, 0xFC, 0x0F, 0x12, 0x00, 0x12, 0x00, 0x12, 0x00, 0x00, 0x00   @ f
 .byte 0x00, 0x00, 0xC0, 0x67, 0x30, 0x48, 0x10, 0x48, 0x10, 0x48, 0x20, 0x64, 0xF0, 0x3F, 0x00, 0x00, 0x00, 0x00   @ g
 .byte 0x00, 0x00, 0xFE, 0x0F, 0x20, 0x00, 0x10, 0x00, 0x10, 0x00, 0x10, 0x00, 0xE0, 0x0F, 0x00, 0x00, 0x00, 0x00   @ h
 .byte 0x00, 0x00, 0x00, 0x00, 0x10, 0x00, 0x10, 0x00, 0xF2, 0x07, 0x00, 0x08, 0x00, 0x08, 0x00, 0x08, 0x00, 0x00   @ i
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x40, 0x10, 0x40, 0x10, 0x40, 0xF2, 0x3F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   @ j
 .byte 0x00, 0x00, 0x00, 0x00, 0xFE, 0x0F, 0x80, 0x00, 0xC0, 0x00, 0x60, 0x03, 0x30, 0x06, 0x10, 0x0C, 0x00, 0x08   @ k
 .byte 0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x02, 0x00, 0xFE, 0x07, 0x00, 0x08, 0x00, 0x08, 0x00, 0x08, 0x00, 0x00   @ l
 .byte 0x00, 0x00, 0xF0, 0x0F, 0x10, 0x00, 0x10, 0x00, 0xF0, 0x0F, 0x10, 0x00, 0x10, 0x00, 0xF0, 0x0F, 0x00, 0x00   @ m
 .byte 0x00, 0x00, 0xF0, 0x0F, 0x20, 0x00, 0x10, 0x00, 0x10, 0x00, 0x10, 0x00, 0xE0, 0x0F, 0x00, 0x00, 0x00, 0x00   @ n
 .byte 0x00, 0x00, 0xC0, 0x03, 0x20, 0x04, 0x10, 0x08, 0x10, 0x08, 0x10, 0x08, 0x30, 0x0C, 0xE0, 0x07, 0x00, 0x00   @ o
 .byte 0x00, 0x00, 0xF0, 0x7F, 0x20, 0x04, 0x10, 0x08, 0x10, 0x08, 0x10, 0x08, 0x30, 0x0C, 0xE0, 0x07, 0x00, 0x00   @ p
 .byte 0x00, 0x00, 0xE0, 0x07, 0x10, 0x0C, 0x10, 0x08, 0x10, 0x08, 0x20, 0x04, 0xF0, 0x7F, 0x00, 0x00, 0x00, 0x00   @ q
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xF0, 0x0F, 0x20, 0x00, 0x10, 0x00, 0x10, 0x00, 0x30, 0x00, 0x00, 0x00   @ r
 .byte 0x00, 0x00, 0x00, 0x00, 0xE0, 0x0C, 0x90, 0x08, 0x90, 0x08, 0x10, 0x09, 0x30, 0x07, 0x00, 0x00, 0x00, 0x00   @ s
 .byte 0x00, 0x00, 0x10, 0x00, 0x10, 0x00, 0xFC, 0x07, 0x10, 0x08, 0x10, 0x08, 0x10, 0x08, 0x00, 0x00, 0x00, 0x00   @ t
 .byte 0x00, 0x00, 0xF0, 0x07, 0x00, 0x08, 0x00, 0x08, 0x00, 0x08, 0x00, 0x04, 0xF0, 0x0F, 0x00, 0x00, 0x00, 0x00   @ u
 .byte 0x00, 0x00, 0x30, 0x00, 0xE0, 0x01, 0x00, 0x0F, 0x00, 0x08, 0x00, 0x0F, 0xE0, 0x01, 0x30, 0x00, 0x00, 0x00   @ v
 .byte 0x30, 0x00, 0xE0, 0x03, 0x00, 0x0E, 0x00, 0x07, 0xC0, 0x00, 0x00, 0x07, 0x00, 0x0E, 0xE0, 0x03, 0x30, 0x00   @ w
 .byte 0x00, 0x00, 0x10, 0x08, 0x30, 0x06, 0x40, 0x03, 0x80, 0x01, 0xC0, 0x03, 0x30, 0x06, 0x10, 0x08, 0x00, 0x00   @ x
 .byte 0x00, 0x00, 0x30, 0x40, 0xE0, 0x40, 0x80, 0x67, 0x00, 0x3C, 0x00, 0x07, 0xE0, 0x01, 0x30, 0x00, 0x00, 0x00   @ y
 .byte 0x00, 0x00, 0x00, 0x00, 0x10, 0x0C, 0x10, 0x0E, 0x10, 0x0B, 0xD0, 0x08, 0x70, 0x08, 0x30, 0x08, 0x00, 0x00   @ z
 .byte 0x00, 0x00, 0x40, 0x00, 0x40, 0x00, 0x40, 0x00, 0xBE, 0x1F, 0x00, 0x20, 0x00, 0x20, 0x00, 0x00, 0x00, 0x00   @ {
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xFE, 0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   @ |
 .byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x20, 0x00, 0x20, 0xBE, 0x1F, 0xC0, 0x00, 0x40, 0x00, 0x40, 0x00, 0x00, 0x00   @ }
 .byte 0x00, 0x00, 0xC0, 0x00, 0x40, 0x00, 0x40, 0x00, 0x40, 0x00, 0x80, 0x00, 0x80, 0x00, 0xC0, 0x00, 0x00, 0x00   @ ~
 .byte 0xF0, 0x0F, 0x10, 0x08, 0xF0, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00   @ 




