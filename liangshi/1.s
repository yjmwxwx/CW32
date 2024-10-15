	@cw32f030c8t6
	@编译器ARM-NONE-EABI
	@yjmwxwx-2024-08-18
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

	ldr r1, = 0x800
	str r1, [r0, # 0x38]
	

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
	ldr r1, = 0x7De7
	str r1, [r0]		@0=输出，1=输入
	ldr r1, = 0x1De7
	str r1, [r0, # 0x1c]	@0=数字，1=模拟

	movs r1, # 0x18
	str r1, [r0, # 0x04]	@pa3 pa4 开漏



	
	ldr r1, = 0x50000060
	str r1, [r0, # 0x14]	@复用8-15
	@str r1, [r0, # 0x18]	@复用0-7



__pb_chu_shi_hua:

	ldr r0, = 0x48000400 @pb
	ldr r1, = 0xfcc7
	str r1, [r0]            @0=输出，1=输入
	ldr r1, = 0xfc07
	str r1, [r0, # 0x1c]    @0=数字，1=模拟

	ldr r1, = 0x300
	str r1, [r0, # 0x04]	@pb8 pb9 开漏

	
	movs r1, # 0xc0
	str r1, [r0, # 0x10]	@上拉

@	movs r1, # 0x11		@pb8 pb9 I2C1
@	str r1, [r0, # 0x14]    @复用8-15
	ldr r1, = 0x505000
	str r1, [r0, # 0x18]	@复用0-7

	
__pc_chu_shi_hua:	
	ldr r3, = 0xc000	
	ldr r0, = 0x48000800 @pc
	str r3, [r0, # 0x1c]
	str r3, [r0]

__si5351_chu_shi_hua:
	movs r3, # 0
	ldr r4, = si5351
	ldr r5, = 138 		@76
__xie_si5351_xun_huan:
	cmp r3, r5
	beq __xie_wan_si5351
	movs r0, # 0xc0
	adds r3, r3, # 1
	ldrb r1, [r4, r3]
	adds r3, r3, # 1
	ldrb r2, [r4, r3]
	bl __xie_i2c_8_wei
	cmp r1, # 0xf0
	beq __si5351_mang
	b __xie_si5351_xun_huan
__si5351_mang:
	subs r3, r3, # 2
	b __xie_si5351_xun_huan
__xie_wan_si5351:	

__pf_00_OSC_IN:
	ldr r0, = 0x48001400
	movs r1, # 0xc2
	str r1, [r0, # 0x1c]

__si5351_zuowei_mcu_shizhong:
	ldr r0, = 0x40010000	@SYSCTRL 基地址
	ldr r1, = 0x5a5a0003
	str r1, [r0, # 0x04]	@HSE HSL开
	
	ldr r1, = 0x7ff62 	@HSE输入模式
	str r1, [r0, # 0x1c]	@SYSCTRL_HSE
__deng_HSE_wending:
	ldr r1, [r0, # 0x1c]
	lsls r1, r1, # 12
	bpl __deng_HSE_wending
	ldr r1, = 0x5a5a0001
	str r1, [r0]		@HSE做为系统时钟	
	ldr r1, = 0x5A5A0182
	str r1, [r0, # 0x04]	@HSE做为系统时钟
	
	
@__i2c1_chu_shi_hua:
@	ldr r0, = 0x40010048
@	ldr r1, = 0x11ff
@	str r1, [r0]
@	ldr r1, = 0x19ff
@	str r1, [r0]
@	ldr r0, = 0x40005400	@I2C1
@	movs r1, # 0xff		@传输速率
@	str r1, [r0, # 0x04]
@	movs r1, # 0x01
@	str r1, [r0]		@开时钟
@	movs r1, # 0x40
@	str r1, [r0, # 0x08]	@控制寄存器

@__GTIM3_chu_shi_hua:
@	ldr r0, = 0x40014000
@	ldr r1, = 23999		@31999
@	ldr r2, = 0x300
@	str r1, [r0, r2]	@ARR
@	ldr r2, = 0x320
@	ldr r1, = 12000		@15999
@	str r1, [r0, r2]	@CCR1
@	ldr r1, = 0x0e
@	ldr r2, = 0x308
@	str r1, [r0, r2]	@CCMR
@	movs r1, # 0x01
@	ldr r2, = 0x310
@	str r1, [r0, r2]		@CR0
	


	
@__ATIM_chu_shi_hua:
@	ldr r0, = 0x40012C00
@	movs r1, # 0x81
@	str r1, [r0, # 0x20]	@触发ADC
@	ldr r1, = 239        
@	str r1, [r0]        @ARR
@	ldr r1, = 0x2001
@	str r1, [r0, # 0x0c]
	
__adc_chu_shi_hua:
	ldr r0, = 0x40012400
	ldr r1, = 0x1c7 	@0xc1	@0xc5
	str r1, [r0]			@开ADC
@	movs r1, # 0x01
@	str r1, [r0, # 0x1c]		@ATIM触发ADC
__deng_chu_shi_hua:
	ldr r1, [r0, # 0x3c]
	lsls r1, r1, # 24
	bpl __deng_chu_shi_hua		@等ADC初始化完成
	movs r1, # 0x80
	str r1, [r0, # 0x04]		@开DMA和通道选择
	ldr r1, = 0x10010
	str r1, [r0, # 0x0c]
	movs r1, # 0x01
	str r1, [r0, # 0x08]		@开ADC转换

	ldr r4, = 0xe000e010
	ldr r3, =  47999	@23999  @0xffffff @ 4799
	str r3, [r4, # 4]
	str r3, [r4, # 8]
	movs r3, # 0x07
	str r3, [r4]    @systick 开

@	bl __atan2_ji_suan
@	ldr r0, = 0xe000e018
@	ldr r1, [r0]
@	bkpt # 1

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

	ldr r1, = 0x103e8
        str r1, [r0, # 0x44]    @传输数量
	ldr r1, = 0x40012424
        str r1, [r0, # 0x48]    @传输源
	ldr r1, = dianyabiao1
	str r1, [r0, # 0x4c]    @目的地
	movs r1, # 0x29
	str r1, [r0, # 0x50]    @触发源
        movs r1, # 0x69
        str r1, [r0, # 0x40]    @模式设置和开DMA

	ldr r0, = lvbo_changdu
	ldr r1, = lvbo_youyi
	ldr r2, =  50
	str r2, [r0]
	movs r2, # 6
	str r2, [r1]

	ldr r0, = cossin
	ldr r1, = cos_sin_biao_1khz
	str r1, [r0]
	
	
	
__spi1_chu_shi_hua:
	ldr r0, = 0x40013000
	ldr r1, = 0x5e74	@8位	@0x7e74 16位
	str r1, [r0]

	bl __lcd_chushihua
	bl __lcd_qingping

	ldr r0, = yjmwxwx
	movs r1, # 18           @显示几个字符
	ldr r2, = 0x0000         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii

	 bl __lcd_qingping



__anjian0:
	b ting
__anjian1:
        ldr r0, = yjmwxwx
        movs r1, # 18           @显示几个字符
        ldr r2, = 0x0000         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
        bl __xie_ascii

	b __ren_wu_diao_du
__anjian2:
	b __ren_wu_diao_du
__anjian3:
	bl __an_jian
	cmp r0, # 3
	beq __anjian3
__deng_anjian_3_song_kai:
	bl __an_jian
	cmp r0, # 0
	bne __deng_anjian_3_song_kai
       bl __lcd_qingping
        ldr r0, = kai_shi_jiao_zhun
        movs r1, # 18           @显示几个字符
        ldr r2, = 0x0001         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
        bl __xie_ascii
        bl __anjian3_yanshi
	bl __anjian3_yanshi
	bl __anjian3_yanshi
	bl __anjian3_yanshi



	
__anjian3_xunhuan:	
        bl __jisuan_s11
	ldr r2, = s11_r
	ldr r3, = s11_i
	str r0, [r2]
	str r1, [r3]
	bl __xianshi_zukang1
        ldr r5, = jiao_zhun_xian_shi_biao
	ldr r6, = jiaozhun_caidan_zhizhen
	ldr r7, [r6]
	ldr r0, [r5, r7]
        movs r1, # 18           @显示几个字符
        ldr r2, = 0x0001         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
        bl __xie_ascii

	bl __an_jian
	cmp r0, # 2
	bne __anjian3_xunhuan
        ldr r0, = ok
        movs r1, # 18           @显示几个字符
	ldr r2, = 0x0001         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	bl __anjian3_yanshi
	bl __an_jian
	cmp r0, # 0
	bne __anjian3_xunhuan
	ldr r0, = jiao_zhun_bao_cun_biao
	ldr  r1, [r0, r7]
	ldr r2, = s11_r
	ldr r3, = s11_i
	ldr r2, [r2]
	ldr r3, [r3]
	str r2, [r1]
	str r3, [r1, # 0x04]

	adds r7, r7, # 4
	str r7, [r6]
	cmp r7, # 0x0c
	bne __anjian3_xunhuan
	ldr r0, [r5, r7]
	movs r1, # 18           @显示几个字符
        ldr r2, = 0x0001         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	bl __jiaozhun
	bl __xie_flash
	bkpt # 3
	

__anjian3_yanshi:
	push {r0}
	ldr r0, = 0x3fffff
__anjian3_yanshi_xunhuan:	
	subs r0, r0, # 1
	bne __anjian3_yanshi_xunhuan
	pop {r0}
	bx lr
	
	
__ren_wu_diao_du:
	bl __an_jian
	lsls r0, r0, # 2
	ldr r1, = an_jian_biao
	ldr r2, [r1, r0]
	mov pc, r2
	
	
__an_jian:
	@入口PA2=按键1，PA3=按键2
	@出口R0
	ldr r0, = 0x48000450
	ldr r0, [r0]	@pb6 pb7
	mvns r0, r0
	lsls r0, r0, # 24
	lsrs r0, r0, # 30
	bx lr

__xie_flash:
	
	ldr r0, = 0x40022000
	ldr r1, = 0x5a5a0000
	str r1, [r0, # 0x04]
	ldr r1, = 0x5a5a0002
	str r1, [r0]
	ldr r1, = 0x5a5a8000	@#15
	str r1, [r0, # 0x08]	@页解锁
	movs r1, # 0xaa
	ldr r2, = 0xf000
	str r1, [r2]
	bl __flash_mang
	
	ldr r1, = 0x5a5a0001
	str r1, [r0]
	ldr r2, = 0xf000
	ldr r1, = kailu_r
	movs r3, # 6
__xie_flash_xun_huan:
	ldr r4, [r1]
	str r4, [r2]
	adds r1, r1, # 0x04
	adds r2, r2, # 0x04
	bl __flash_mang
	subs r3, r3, # 1
	bne __xie_flash_xun_huan

	
        ldr r1, = 0x5a5a0000
	str r1, [r0]
	ldr r1, = 0x5a5a0000    @#15
	str r1, [r0, # 0x08]    @页解锁

	ldr r0, = 0xe000ed0c
	ldr r1, = 0x05fa0004
	str r1, [r0]          		@复位
	bkpt # 33
	
__flash_mang:
	push {r1}
	ldr r1, [r0]
	lsls r1, r1, # 26
	bmi __flash_mang
	pop {r1}
	bx lr

	
	.ltorg


	
shiyan:
	ldr r0, = pm1
	ldr r1, = pm1i
	ldr r6, = 4346
	ldr r7, = 7421
	str r6, [r0]
	str r7, [r1]

	
	ldr r2, = pm2
	ldr r3, = pm2i
	ldr r6, = -8
	ldr r7, = -5419
	str r6, [r2]
	str r7, [r3]
	
	ldr r4, = pm3
	ldr r5, = pm3i
	ldr r6, = -69
	ldr r7, = 280
	str r6, [r4]
	str r7, [r5]

	bl __jiaozhun
	
	ldr r0, = s11_r
	ldr r1, = s11_i
	ldr r2, = 6199
	ldr r3, = 1182
	str r2, [r0]
	str r3, [r1]

	
        bl __osm_jiao_zhun
        bl __jisuan_zukang
        ldr r2, = z_r
        ldr r3, = z_i
        str r0, [r2]
        str r1, [r3]
        bl __xianshi_zukang
	bkpt # 55




ting:	
	bl __jisuan_s11
	ldr r2, = s11_r
        ldr r3, = s11_i
	str r0, [r2]
	str r1, [r3]
	bl __xianshi_zukang1
	bl __osm_jiao_zhun
	bl __jisuan_zukang
	ldr r2, = z_r
	ldr r3, = z_i
	str r0, [r2]
	str r1, [r3]
	bl __xianshi_zukang
	bl __xianshi_zukang_danwei
	
	b __ren_wu_diao_du
	.ltorg


__xianshi_zukang_danwei:
	push {r0-r4,lr}
	movs r0, # 91		@欧
	movs r1, # 2             @两个字符
	ldr r2, = asciibiao
	movs r3, # 0xff
	bl _zhuanascii
	movs r0, # 2            @写几个字
	movs r1, # 45           @字库单字长度
	movs r2, # 3            @宽度
	ldr r3, = 0x6502              @lcd位置(高8位0-0x83,低8位0-7)
	ldr r4, = danweibiao
	bl __xie_alabo

	movs r0, # 2            @写几个字
        movs r1, # 45           @字库单字长度
        movs r2, # 3            @宽度
	ldr r3, = 0x6505              @lcd位置(高8位0-0x83,低8位0-7)
	ldr r4, = danweibiao
        bl __xie_alabo

	pop {r0-r4,pc}
	

	
__jiaozhun:	@校准开路短路匹配误差
	push {r0-r7,lr}
	bl __det
	mov r2, r0
	mov r3, r1
	mov r6, r2
	mov r7, r3
	bl __det1
	bl __fu_shu_chu_fa
	ldr r4, = kailu_r
	ldr r5, = kailu_i
	str r2, [r4]
	str r1, [r5]
	bl __det2
	mov r2, r6
	mov r3, r7
	ldr r4, = 32768
	muls r0, r0, r4
	muls r1, r1, r4
	bl __fu_shu_chu_fa
	ldr r4, = duanlu_r
	ldr r5, = duanlu_i
	str r2, [r4]
	str r1, [r5]
	bl __det3
	mov r2, r6
	mov r3, r7
	bl __fu_shu_chu_fa
	ldr r4, = pipei_r
	ldr r5, = pipei_i
	str r2, [r4]
	str r1, [r5]
	pop {r0-r7,pc}
__det:
	push {r2-r7,lr}
	@a b c
	@d e f
	@g h i
	@a*e
	@ae*i=0
	@b*f
	ldr r0, = pm1
	ldr r1, = pm1i
	ldr r0, [r0]
	ldr r1, [r1]
	@bf*g
	@d*h=0
	@dh*c=0
	@g*e
	ldr r2, = pm2
	ldr r3, = pm2i
	ldr r2, [r2]
	ldr r3, [r3]
	@ge*c
	@h*f=0
	@hf*a=0
	@d*b
	@db*i=0
	@a*e*i+b*f*g+d*h*c-g*e*c-h*f*a-d*b*i
	subs r0, r0, r2
	subs r1, r1, r3
	pop {r2-r7,pc}
__det1:
        push {r2-r7,lr}
        @a b c
        @d e f
        @g h i
        @a*e
        @ae*i=0
        @b*f
        ldr r0, = pm1
        ldr r1, = pm1i
        ldr r0, [r0]
        ldr r1, [r1]
        @bf*g
	ldr r2, = pm3
	ldr r3, = pm3i
	ldr r2, [r2]
	ldr r3, [r3]
	mov r4, r2
	mov r5, r3
	bl __fu_shu_cheng_fa
	mov r6, r0
	mov r7, r1
        @d*h=0
        @dh*c=0
        @g*e
        ldr r0, = pm2
        ldr r1, = pm2i
        ldr r0, [r0]
        ldr r1, [r1]
	mov r2, r4
	mov r3, r5
	bl __fu_shu_cheng_fa
        @ge*c
        @h*f=0
        @hf*a=0
        @d*b
        @db*i=0
        @a*e*i+b*f*g+d*h*c-g*e*c-h*f*a-d*b*i
        subs r6, r6, r0
        subs r7, r7, r1
	mov r0, r6
	mov r1, r7
        pop {r2-r7,pc}
__det2:	
        push {r2-r7,lr}
        @a b c
        @d e f
        @g h i
        @a*e
        @ae*i=0
        @b*f
        ldr r0, = pm1
        ldr r1, = pm1i
        ldr r0, [r0]
        ldr r1, [r1]
        @bf*g
        @d*h
	ldr r4, = pm3
	ldr r5, = pm3i
	ldr r4, [r4]
	ldr r5, [r5]
        @dh*c
	mvns r4, r4
	adds r4, r4, # 1
	mvns r5, r5
	adds r5, r5, # 1
        @g*e
        ldr r2, = pm2
        ldr r3, = pm2i
        ldr r2, [r2]
        ldr r3, [r3]
        @ge*c
	mvns r2, r2
	adds r2, r2, # 1
	mvns r3, r3
	adds r3, r3, # 1
	@h*f
	ldr r6, = pm3
	ldr r7, = pm3i
	ldr r6, [r6]
	ldr r7, [r7]
        @hf*a
        @d*b
	@db*i=0
	@a*e*i+b*f*g+d*h*c-g*e*c-h*f*a-d*b*i
	adds r0, r0, r4
	adds r1, r1, r5
	subs r0, r0, r2
	subs r1, r1, r3
	subs r0, r0, r6
	subs r1, r1, r7
	pop {r2-r7,pc}
__det3:
        push {r2-r7,lr}
        @a b c
        @d e f
        @g h i
        @a*e
	ldr r0, = pm2
	ldr r1, = pm2i
	ldr r0, [r0]
	ldr r1, [r1]
	mov r4, r0
	mov r5, r1
	mvns r0, r0
	adds r0, r0, # 1
	mvns r1, r1
	adds r1, r1, # 1
        @ae*i
	ldr r2, = pm3
	ldr r3, = pm3i
	ldr r2, [r2]
	ldr r3, [r3]
	bl __fu_shu_cheng_fa
	push {r0-r1}
        @b*f
        ldr r0, = pm1
        ldr r1, = pm1i
        ldr r0, [r0]
        ldr r1, [r1]
	mov r6, r0
	mov r7, r1
	mov r2, r4
	mov r3, r5
	bl __fu_shu_cheng_fa
	push {r0-r1}
        @bf*g
        @d*h=0
        @dh*c=0
        @g*e
	mov r0, r6
	mov r1, r7
	mvns r2, r4
	adds r2, r2, # 1
	mvns r3, r5
	adds r3, r3, # 1
        @ge*c
	bl __fu_shu_cheng_fa
	push {r0-r1}
	@h*f=0
        @hf*a=0
        @d*b
	mov r2, r6
	mov r3, r7
	@db*i
	ldr r0, = pm3
	ldr r1, = pm3i
	ldr r0, [r0]
	ldr r1, [r1]
	bl __fu_shu_cheng_fa
	mov r6, r0
	mov r7, r1
	pop {r4-r5}
	pop {r2-r3}
	pop {r0-r1}
	@a*e*i+b*f*g+d*h*c-g*e*c-h*f*a-d*b*i
	adds r0, r0, r2
	adds r1, r1, r3
	subs r0, r0, r4
	subs r1, r1, r5
	subs r0, r0, r6
	subs r1, r1, r7
	pop {r2-r7,pc}
__fu_shu_cheng_fa:
	push {r2-r7,lr}
	@r0=a,r1=b,r2=c,r3=d
        mov r4, r0      @a
        mov r5, r1      @b
	mov r6, r2	@c
	mov r7, r3	@d
        muls r0, r0, r2 @a*c
	muls r1, r1, r3 @b*d
        subs r0, r0, r1 @ac-bd
        muls r4, r4, r7 @a*d
        muls r5, r5, r6 @b*c
        adds r4, r4, r5 @ad+bc
	mov r1, r4
	pop {r2-r7,pc}


	

__osm_jiao_zhun:
	push {r2-r7,lr}
	ldr r0, = s11_r
	ldr r1, = s11_i
	ldr r0, [r0]
	ldr r1, [r1]

	ldr r6, = kai_lu_r 	@开路R
	ldr r7, = kai_lu_i	@开路I
	ldr r6, [r6]
	ldr r7, [r7]
	
	subs r6, r0, r6		@p1-x
	subs r7, r1, r7
	
	ldr r2, = duan_lu_r	@c	@短路R
	ldr r3, = duan_lu_i	@d	@短路I
	ldr r2, [r2]
	ldr r3, [r3]
	bl __fu_shu_cheng_fa
	asrs r0, r0, # 15
	asrs r1, r1, # 15

	ldr r4, = pi_pei_r		@50欧姆R
	ldr r5, = pi_pei_i		@50欧姆I
	ldr r4, [r4]
	ldr r5, [r5]
	subs r0, r0, r4
	subs r1, r1, r5
	mov r2, r0
	mov r3, r1
	mov r0, r6
	mov r1, r7
	ldr r4, = 10000
	muls r0, r0, r4
	muls r1, r1, r4
	bl __fu_shu_chu_fa
	mov r0, r2
	ldr r2, = p_jz_r
	ldr r3, = p_jz_i
	str r0, [r2]
	str r1, [r3]
	pop {r2-r7,pc}


	




	
__xianshi_zukang:
	push {r0-r4,lr}
	ldr r0, = z_r
	ldr r4, [r0]
	movs r4, r4
	bpl __xianshi_zr
__z_r_shi_fu:
	mvns r4, r4
	adds r4, r4, # 1
	ldr r0, = afu
	movs r1, # 2           @显示几个字符
	ldr r2, = 0x0003         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	b __xianshi_z_r
__xianshi_zr:
	ldr r0, = akong
	movs r1, # 2           @显示几个字符
	ldr r2, = 0x0003         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
__xianshi_z_r:
	mov r0, r4
	movs r1, # 6
	ldr r2, = asciibiao
	movs r3, # 3            @小数点位置
	bl _zhuanascii
	movs r0, # 6            @写几个字
	movs r1, # 48           @字库单字长度
	movs r2, # 3            @宽度
	ldr r3, = 0x1102              @lcd位置
	bl __xie_lcd_ascii


        ldr r0, = z_i
        ldr r4, [r0]
        movs r4, r4
        bpl __xianshi_zi
__z_i_shi_fu:
        mvns r4, r4
        adds r4, r4, # 1
        ldr r0, = afu
        movs r1, # 2           @显示几个字符
        ldr r2, = 0x0006         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
        bl __xie_ascii
        b __xianshi_z_i
__xianshi_zi:
        ldr r0, = akong
        movs r1, # 2           @显示几个字符
        ldr r2, = 0x0006         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
        bl __xie_ascii
__xianshi_z_i:
        mov r0, r4
        movs r1, # 6
        ldr r2, = asciibiao
        movs r3, # 3            @小数点位置
        bl _zhuanascii
        movs r0, # 6            @写几个字
        movs r1, # 48           @字库单字长度
        movs r2, # 3            @宽度
        ldr r3, = 0x1105              @lcd位置
        bl __xie_lcd_ascii

	
	pop {r0-r4,pc}
	


__xianshi_zukang1:
	push {r0-r7,lr}
        ldr r0, = s11_r
        ldr r1, = s11_i
        ldr r0, [r0]
        ldr r7, [r1]
        movs r6, r0
        bmi __shangbi_r_shi_fu1
__shangbi_r_bushi_fu1:
        ldr r0, = akong
        movs r1, # 1           @显示几个字符
        movs r2, # 0x00         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
        bl __xie_ascii
        b __xianshi_shangbi_r1
__shangbi_r_shi_fu1:
        ldr r0, = a_fu
        movs r1, # 1           @显示几个字符
        movs r2, # 0x00         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
        bl __xie_ascii
        mvns r6, r6
        adds r6, r6, # 1
__xianshi_shangbi_r1:
        mov r0, r6
        movs r1, # 8             @转换几个字符
        ldr r2, = asciibiao
        movs r3, # 0xff             @小数点位置
        bl __zhuanascii
        ldr r0, = asciibiao
        movs r1, # 8           @显示几个字符
        ldr r2, = 0x800         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
        bl __xie_ascii

        movs r6, r7
        bmi __shangbi_i_shi_fu1
__shangbi_i_bushi_fu1:
        ldr r0, = akong
        movs r1, # 1           @显示几个字符
        ldr r2, = 0x4200         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
        bl __xie_ascii
        b __xianshi_shangbi_i1
__shangbi_i_shi_fu1:
        ldr r0, = a_fu
        movs r1, # 1           @显示几个字符
        ldr r2, = 0x4200         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
        bl __xie_ascii
        mvns r6, r6
        adds r6, r6, # 1
__xianshi_shangbi_i1:
        mov r0, r6
        movs r1, # 8             @转换几个字符
        ldr r2, = asciibiao
        movs r3, # 0xff             @小数点位置
        bl __zhuanascii
        ldr r0, = asciibiao
        movs r1, # 8           @显示几个字符
        ldr r2, = 0x4a00         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
        bl __xie_ascii
	pop {r0-r7,pc}



	
__jisuan_s11:
	push {r2-r4,lr}
	ldr r2, = vr_r
	ldr r3, = vr_i
	ldr r2, [r2]
	ldr r3, [r3]
	ldr r0, = vt_r
	ldr r1, = vt_i
	ldr r4, = 10000
	ldr r0, [r0]
	ldr r1, [r1]
	muls r0, r0, r4
	muls r1, r1, r4
	bl __fu_shu_chu_fa
	mov r0, r2
	pop {r2-r4,pc}

__jisuan_zukang:
        push {r2-r4,lr}
	ldr r4, = p_jz_r	@s11_r
	ldr r4, [r4]
	ldr r1, = p_jz_i	@s11_i
	ldr r1, [r1]

	
	mov r3, r1
	mvns r3, r3
	adds r3, r3, # 1
	
	ldr r0, = 10000
	mov r2, r0
	adds r0, r0, r4
	subs r2, r2, r4

	ldr r4, = 5000
	muls r0, r0, r4
	muls r1, r1, r4
	
        bl __fu_shu_chu_fa
        mov r0, r2
        pop {r2-r4,pc}

	


__dft:
	push {r4-r7,lr}
	mov r4, r8
	mov r5, r9
	mov r6, r10
	mov r7, r12
	push {r4-r7}
	ldr r0, = cossin
	ldr r1, = dianyabiao
	ldr r2, = dianyabiao1
	ldr r0, [r0]
	movs r6, # 0
	mov r7, r6
	mov r8, r6
	mov r9, r6
	mov r12, sp
	mov r10, r1
	mov r14, r2
	mov sp, r0
	b __dft_xunhuan
	.ltorg
__dft_xunhuan:
	@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm1
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm2
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm3
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm4
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm5
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm6
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm7
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm8
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

@yjm9
		@0
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@1
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@2
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@3
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@4
	pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@5
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I
	
	@6
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@7
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@8
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I

	@9
		pop {r0-r1}
	mov r2, r0
	mov r3, r1
	
	mov r5, r10
	ldrh r4, [r5]
	adds r5, r5, # 2
	mov r10, r5
	muls r0, r0, r4		@R
	muls r1, r1, r4		@I
	asrs r0, r0, # 6
	asrs r1, r1, # 6
	adds r6, r6, r0	       @COS_R
	adds r7, r7, r1	       @COS_I

        mov r5, r14
        ldrh r4, [r5]
        adds r5, r5, # 2
        mov r14, r5
        muls r2, r2, r4         @R
        muls r3, r3, r4         @I
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	mov r4, r8
	mov r5, r9
	adds r4, r4, r2        
	adds r5, r5, r3
	mov r8, r4		@SIN_R
	mov r9, r5		@SIN_I





	








	


	ldr r0, = 0x200008d0	@0x200001c8
	cmp r10, r0
	beq __dft_fanhuile
	ldr r0, = __dft_xunhuan
	adds r0, r0, # 1
	mov pc, r0
__dft_fanhuile:
	mov r0, r6	@cos_r
	mov r1, r7	@cos_i
	mov r2, r8	@sin_r
	mov r3, r9	@sin_i
	asrs r0, r0, # 9	@dfdf
	asrs r1, r1, # 9
	asrs r2, r2, # 9
	asrs r3, r3, # 9
	mov sp, r12
	pop {r4-r7}
	mov r8, r4
	mov r9, r5
	mov r10, r6
	mov r12, r7
	pop {r4-r7,pc}
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






	

__xie_i2c_8_wei:
	push {r3-r7,lr}
	@r0=从地址，r1=数据地址，r2=数据
	ldr r7, = 0x48000000
	ldr r3, = 0x10 		@pa4=SDA
	ldr r4, = 0x08		@pb3=SCL
__i2c_qi_8:	
	str r3, [r7, # 0x5c]	@ SDA=1
	str r4, [r7, # 0x5c]	@ SCL=1
	bl __i2c_yan_shi
	str r3, [r7, # 0x58]	@ SDA=0
	bl __i2c_yan_shi
	str r4, [r7, # 0x58]	@ SCL=0
	bl __i2c_yan_shi
	movs r6, # 0
__xie_cong_di_zhi_8:
	movs r5, # 8
	lsls r0, r0, # 23
	b __xie_shu_ju_8
__xie_cong_ji_di_zhi:
	mov r0, r1
	movs r5, # 8
	lsls r0, r0, # 23
	b __xie_shu_ju_8
__xie_cong_ji_shu_ju:
	mov r0, r2
	movs r5, # 8
	lsls r0, r0, # 23
__xie_shu_ju_8:
	lsls r0, r0, # 1
	bpl __SDA_8_deng_yu_0
	str r3, [r7, # 0x5c]	@SDA=1
	b __SCL_8_gao
__SDA_8_deng_yu_0:
	str r3, [r7, # 0x58]	@SDA=0
__SCL_8_gao:	
	str r4, [r7, # 0x5c]	@SCL=1
	bl __i2c_yan_shi
	str r4, [r7, # 0x58]	@SCL=0
	bl __i2c_yan_shi
	subs r5, r5, # 1
	bne __xie_shu_ju_8
	str r3, [r7, # 0x5c]	@SDA=1
	bl __i2c_yan_shi
	str r4, [r7, # 0x5c]	@SCL=1
	bl __i2c_yan_shi
__du_apk_8:
	ldr r5, [r7, # 0x10]	@读APK
	lsls r5, r5, # 27	@pa4 sda	
	bpl __apk_di_8
__apk_gao_8:
	movs r1, # 0xf0
	b __i2c_ting_8
__apk_di_8:
	str r4, [r7, # 0x58]	@SCL=0
	bl __i2c_yan_shi
	adds r6, r6, # 1
	cmp r6, # 1
	beq __xie_cong_ji_di_zhi
	cmp r6, # 2
	beq __xie_cong_ji_shu_ju
__i2c_ting_8:
	str r3, [r7, # 0x58]	@SDA=0
	bl __i2c_yan_shi
	str r4, [r7, # 0x5c]	@SCL=1
	bl __i2c_yan_shi
	str r3, [r7, # 0x5c]	@SDA=1
	pop {r3-r7,pc}
	__i2c_yan_shi:
	push {r3, lr}
	ldr r3, = 0x500
__i2c_yan_shi_xun_huan:
	subs r3, r3, # 1
	bne __i2c_yan_shi_xun_huan
	pop {r3, pc}

	.ltorg











	

__du_24c64:	
	@r0=结果
	push {lr}
        bl __fasong_i2c_qishi
        movs r0, # 0xa0
        bl __xie_i2c8wei
        movs r0, # 0x00
        bl __xie_i2c8wei
        movs r0, # 0x00
        bl __xie_i2c8wei
        bl __fasong_i2c_qishi
        movs r0, # 0xa1
        bl __xie_i2c8wei
        bl __du_i2c8wei
        bl __i2c1_ting
	pop {pc}

__xie_24c64:
	push {r0,lr}
        bl __fasong_i2c_qishi
        movs r0, # 0xa0
        bl __xie_i2c8wei
        movs r0, # 0x00		@要写的地址
        bl __xie_i2c8wei
        movs r0, # 0x00		@要写的地址
        bl __xie_i2c8wei
        movs r0, r1		@要写的数据
        bl __xie_i2c8wei
        bl __i2c1_ting
	pop {r0,pc}

	

__fasong_i2c_qishi:
	push {r0-r1}
	ldr r0, = 0x40005400
        movs r1, # 0x60
        str r1, [r0, # 0x08]    @发送START
__du_si:
        ldr r1, [r0, # 0x08]
        lsls r1, r1, # 28
        bpl __du_si
	pop {r0-r1}
	bx lr
		
__xie_i2c8wei:
	push {r1}
	ldr r1, = 0x40005400
        str r0, [r1, # 0x0c]    @要写的数据

	movs r0, # 0x40
	str r0, [r1, # 0x08]

__du_si1:
        ldr r0, [r1, # 0x08]
        lsls r0, r0, # 28
        bpl __du_si1
	pop {r1}
	bx lr
__du_i2c8wei:
	push {r1}
	ldr r1, = 0x40005400
	movs r0, # 0x4c
	str r0, [r1, # 0x08]
	ldr r0, = 0xff
__i2c_yanshi:
	subs r0, r0, # 1
	bne __i2c_yanshi
	movs r0, # 0x44
	str r0, [r1, # 0x08]
__du_si2:
	ldr r0, [r1, # 0x08]
        lsls r0, r0, # 28
	bpl __du_si2
	ldr r0, [r1, # 0x0c]
	pop {r1}
	bx lr


__i2c1_ting:
	push {r0-r1}
	ldr r0, = 0x40005400
	movs r1, # 0x50
	str r1, [r0, # 0x08]    @i2c1停止
	pop {r0-r1}
	bx lr




	

__lcd_chushihua:
	push {r0-r2,lr}
	ldr r0,  = 0x48000400
	movs r1, # 0x10
	str r1, [r0, 0x5c]            @RST=1
	ldr r2, = 0x1ffff
	bl __lcd_yanshi

	str r1, [r0, 0x58]            @RST=0
	ldr r2, = 0x1ffff
	bl __lcd_yanshi

	str r1, [r0, # 0x5c]            @RST=1
	ldr r2, = 0x1ffff
	bl __lcd_yanshi

	ldr r0, = 0x40013000
	movs r1, # 0x00
	str r1, [r0, # 0x0c]		@A0=0
	
	ldr r2, = 0x1ffff
	bl __lcd_yanshi

	movs r0, # 0xa2         @ 偏置选择
	bl __xie_spi1
	movs r0, # 0xa0         @SEG方向（横 0=0到131，1=131到0）
	bl __xie_spi1
	movs r0, # 0xc8         @选择COM方向（竖 0=0到63, 1=63到1）
	bl __xie_spi1
	movs r0, # 0x2f         @选择调节率
	bl __xie_spi1
	movs r0, # 0x81         @设置EV命令
	bl __xie_spi1
	movs r0, # 0x25         @设置EV（0x00-0x3f 对比度）
	bl __xie_spi1
	movs r0, # 0x2f         @助推器开启
	bl __xie_spi1           @调节器开、追踪器开
	movs r0, # 0xaf         @显示开
	bl __xie_spi1
	pop {r0-r2,pc}

__lcd_yanshi:
	subs r2, r2, # 1
	bne __lcd_yanshi
	bx lr
	
__xie_spi1:
	push {r1-r2}
	ldr r1, = 0x40013000
@	movs r2, # 0x00
@	str r2, [r1, # 0x0c]
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
@	movs r2, # 0x01
@	str r2, [r1, # 0x0c]
	pop {r1-r2}
	bx lr

__xie_lcd_ye:
	@入口R0=数据首地址
	push {r1-r4,lr}
	movs r3, # 0xb0
	subs r3, r3, # 1
	mov r4, r0
__ye_jia:
        ldr r0, = 0x40013000
	movs r1, # 0x01
	str r1, [r0, # 0x0c]            @A0=1
	ldr r2, = 0xff
	bl __lcd_yanshi
	adds r3, r3, # 1
	cmp r3, # 0xb9
	bne __xie_ye_dizhi
	pop {r1-r4,pc}
	@       movs r3, # 0xb0
	@       mvns r4, r4
	@       lsls r4, r4, # 24
	@       lsrs r4, r4, # 24
__xie_ye_dizhi:
	movs r0, # 0x10
	bl __xie_spi1
	movs r0, # 0
	bl __xie_spi1
	mov r0, r3
	bl __xie_spi1

        ldr r0, = 0x40013000
	movs r1, # 0x01
	str r1, [r0, # 0x0c]            @A0=1
	ldr r2, = 0xff
	bl __lcd_yanshi

	movs r1, # 132
__heng_sao:
	ldrb r0, [r4]
	@       mov r0, r4
	bl __xie_spi1
	adds r4, r4, # 1
	subs r1, r1, # 1
	bne __heng_sao
	b __ye_jia

__lcd_qingping:
	push {r0-r4,lr}
	movs r3, # 0xb0
	subs r3, r3, # 1
	movs r4, # 0
__ye_jia1:
        ldr r0, = 0x40013000
	movs r1, # 0x00
	str r1, [r0, # 0x0c]            @A0=0
	ldr r2, = 0xff
	bl __lcd_yanshi
	adds r3, r3, # 1
	cmp r3, # 0xb9
	bne __xie_ye_dizhi1
	pop {r0-r4,pc}
__xie_ye_dizhi1:
	movs r0, # 0x10
	bl __xie_spi1
	movs r0, # 0
	bl __xie_spi1
	mov r0, r3
	bl __xie_spi1
	movs r2, # 0xff
	bl __lcd_yanshi

        ldr r0, = 0x40013000
	movs r1, # 0x01
	str r1, [r0, # 0x0c]            @A0=1
	ldr r2, = 0xff
	bl __lcd_yanshi
	movs r1, # 133
__heng_sao1:
	mov r0, r4
	bl __xie_spi1
	subs r1, r1, # 1
	bne __heng_sao1
	b __ye_jia1


__xie_lcd_weizhi:
	@入口R0=要写的地址(低8=X，高8=Y=（0-131(r5=高4,R4=低4))
	push {r1-r5,lr}
	mov r5, r0
	mov r4, r0
	lsls r0, r0, # 24
	lsrs r0, r0, # 24
	lsrs r5, r5, # 12	@高4
	lsls r4, r4, # 20
	lsrs r4, r4, # 28
        ldr r1, = 0x40013000
	movs r3, # 0x00
	str r3, [r1, # 0x0c]            @A0=0
	ldr r2, = 0xff
	bl __lcd_yanshi
	adds r0, r0, # 0xb0     @写页命令0XB0
	bl __xie_spi1		@写页地址0-8页

	movs r0, # 0x10
	orrs r0, r0, r5
	bl __xie_spi1

	mov r0, r4
	bl __xie_spi1

	movs r3, # 0x01
	strh r3, [r1, # 0x0c]            @A0=1
	ldr r2, = 0xff
	bl __lcd_yanshi
	pop {r1-r5,pc}


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
	bl __xie_lcd_weizhi
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
	bl __xie_spi1
	b __du_ziku1
__duwan_ziku1:
	adds r6, r6, # 1
	cmp r6, r7
	bne __du_ascii2
	pop {r6}
	mov r6, r9
	pop {r3-r7,pc}

__xie_alabo:
	push {r5-r7,lr}
	@入口r0=写几个字
	@r1=字库单字长度
	@r2=y宽（几行）
	@r3=要写的地址
	mov r5, r9
	mov r6, r10
	mov r7, r11
	push {r5-r7}
	mov r5, r12
	push {r5}
	ldr r5, = asciibiao
	mov r12, r4
	mov r9, r3
	movs r6, # 0
	mov r7, r6
	mov r10, r0
	mov r11, r2
__xie_lcd_dizhi1:
	mov r0, r9
	bl __xie_lcd_weizhi
__du_ascii1:
	ldrb r0, [r5, r6]
	muls r0, r0, r1
	mov r3, r12
	add r3, r3, r0
	adds r3, r3, r7
__du_ziku_chushihua1:
	movs r4, # 0
__du_ziku:
	ldrb r0, [r3, r4]
	add r4, r4, r2
	cmp r4, r1
	bhi __duwan_ziku
	bl __xie_spi1
	b __du_ziku
__duwan_ziku:
	adds r6, r6, # 1
	cmp r6, r10
	bne __du_ascii1
	movs r6, # 0
	adds r7, r7, # 1        @字库地址偏移
	mov r0, r9
	adds r0, r0, # 1        @Y偏移
	mov r9, r0
	cmp r7, r11
	bne __xie_lcd_dizhi1
	pop {r5}
	mov r12, r5
	pop {r5-r7}
	mov r9, r5
	mov r10, r6
	mov r11, r7
	pop {r5-r7,pc}



__xie_lcd_ascii:
	push {r4-r7,lr}
	@入口r0=写几个字
	@r1=字库单字长度
	@r2=y宽（几行）
	@r3=要写的地址
	mov r4, r9
	mov r5, r10
	mov r6, r11
	mov r7, r12
	push {r4-r7}
	ldr r5, = asciibiao
	mov r9, r3
	movs r6, # 0
	mov r7, r6
	mov r12, r6
	mov r10, r0
	mov r11, r2
__xie_lcd_dizhi:
	mov r0, r9
	bl __xie_lcd_weizhi
__du_ascii:
	ldrb r0, [r5, r6]
	cmp r0, # 0x2e
	beq __xie_ascii_xiaoshudian
	muls r0, r0, r1

	ldr r3, = da_a_labo_hack  @da_a_labo_shuzi
	add r3, r3, r0
	adds r3, r3, r7
__du_ziku_16_chushihua:
	movs r4, # 0
__du_ziku_16:
	ldrb r0, [r3, r4]
	add r4, r4, r2
	cmp r4, r1
	bhi __duwan_16
	bl __xie_spi1
	b __du_ziku_16
__duwan_16:
	adds r6, r6, # 1
	cmp r6, r10
	bne __du_ascii
	movs r6, # 0
	adds r7, r7, # 1	@字库地址偏移
	mov r0, r9
	adds r0, r0, # 1	@Y偏移
	mov r9, r0
	cmp r7, r11
	bne __xie_lcd_dizhi
	pop {r4-r7}
	mov r9, r4
	mov r10, r5
	mov r11, r6
	mov r12, r7
	pop {r4-r7,pc}

__xie_ascii_xiaoshudian:
	mov r0, r12
	adds r0, r0, # 1
	mov r12, r0
	cmp r12, r2
	beq __xie_ru_xiaoshudian
	movs r0, # 0
	bl __xie_spi1
	movs r0, # 0
	bl __xie_spi1
	movs r0, # 0
	bl __xie_spi1
	movs r0, # 0
	bl __xie_spi1

	b __duwan_16
__xie_ru_xiaoshudian:
	movs r0, # 0
	bl __xie_spi1
	movs r0, # 0x70
	bl __xie_spi1
	movs r0, # 0x70
	bl __xie_spi1
	movs r0, # 0x70
	bl __xie_spi1
	b __duwan_16

_zhuanascii:														@ 16进制转ASCII
	@ R0要转的数据， R1长度，R2结果表首地址, r3=小数点位置
	push {r4-r7,lr}
	mov r7, r3
	mov r5, r0
	mov r6, r1
	movs r1, # 10
_xunhuanqiuma:
	bl _chufa
	mov r4, r0
	muls r4, r1
	subs r3, r5, r4
	@	adds r3, r3, # 0x30	@ascii偏移
	mov r5, r0
	subs r6, r6, # 1
	beq _qiumafanhui
	cmp r6, r7
	bne _meidaoxiaoshudian
	movs r4, # 0x2e		@小数点
	strb r4, [r2,r6]	@插入小数点
	subs r6, r6, # 1
_meidaoxiaoshudian:
	strb r3, [r2,r6]
	movs r6, r6
	bne _xunhuanqiuma
	pop {r4-r7,pc}
_qiumafanhui:
	strb r3, [r2, r6]
	pop {r4-r7,pc}

__zhuanascii:								              @ 转ASCII
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
__fu_shu_chu_fa:
	@入口R0=a R1=b,R2=c R3=d
	@出口R2=实部 R1=虚部
	push {r4-r7,lr}
	cmp r2, # 0
	bne __tiao_guo_bei_chu_shu_0_pan_duan
	cmp r3, # 0
	bne __tiao_guo_bei_chu_shu_0_pan_duan
	mov r2, r0
	pop {r4-r7,pc}
__tiao_guo_bei_chu_shu_0_pan_duan:
	mov r4, r8
	mov r5, r9
	mov r6, r10
	mov r7, r11
	push {r4-r7}
__ji_suan_chu_fa:
	mov r8, r0	@a
	mov r9, r1	@b
	mov r10, r2	@c
	mov r11, r3	@d
	movs r7, # 0
	@ (a+bi)/(c+di)=(ac+bd)/(c*c+d*d)+(bc-ad)/(c*c+d*d)
	movs r0, r0
	bpl b1
	mvns r0, r0
	adds r0, r0, # 1
	movs r7, # 1
b1:
	mov r1, r10
	movs r1, r1
	bpl b2
	mvns r1, r1
	adds r1, r1, # 1
	adds r7, r7, # 1
b2:
	bl __chengfa
b3:
	cmp r7, # 1
	bne a1
	mvns r0, r0
	mvns r1, r1
a1:
	mov r4, r0	@a*c高32
	mov r5, r1	@a*c低32
	movs r7, # 0
	mov r0, r9
	mov r1, r11
	movs r0, r0
	bpl b4
	mvns r0, r0
	adds r0, r0, # 1
	adds r7, r7, # 1
b4:
	movs r1, r1
	bpl b5
	mvns r1, r1
	adds r1, r1, # 1
	adds r7, r7, # 1
b5:
	bl __chengfa
b6:
	cmp r7, # 1
	bne a2
	mvns r0, r0
	mvns r1, r1
a2:
	adds r1, r1, r5	@ac+bd低32
	adcs r0, r0, r4	@ac+bd高32
	mov r6, r0
	mov r7, r1
	mov r0, r10
	muls r0, r0, r0
	mov r4, r0	@c*c
	mov r0, r11
	muls r0, r0, r0
	adds r0, r0, r4
	push {r0}
	mov r1, r7
	movs r7, # 0
	movs r2, r0
	bpl b7
	mvns r2, r2
	adds r2, r2, # 1
	adds r7, r7, # 1
b7:
	movs r0, r6
	bpl b8
	mvns r0, r0
	mvns r1, r1
	adds r7, r7, # 1
b8:
	bl __chufa64
	cmp r7, # 1
	bne __bao_cun_chu_fa_shi_bu_jie_guo
	mvns r0, r0
	mvns r1, r1
__bao_cun_chu_fa_shi_bu_jie_guo:
	mov r6, r0	@实部高32
	mov r7, r1	@实部低32
	@r8=a, r9=b, r10=c, r11=d
	@(b*c-a*d)/(c*c+d*d)
	movs r5, # 0
	mov r0, r9
	movs r0, r0
	bpl b9
	mvns r0, r0
	adds r0, r0, # 1
	adds r5, r5, # 1
b9:
	mov r1, r10
	movs r1, r1
	bpl b10
	mvns r1, r1
	adds r1, r1, # 1
	adds r5, r5, # 1
b10:
	bl __chengfa
	cmp r5, # 1
	bne a3
	mvns r0, r0
	mvns r1, r1
a3:
	mov r4, r0      @b*c高32
	mov r5, r1      @b*c低32
	movs r3, # 0
	mov r0, r8
	movs r0, r0
	bpl b11
	mvns r0, r0
	adds r0, r0, # 1
	adds r3, r3, # 1
b11:
	mov r1, r11
	movs r1, r1
	bpl b12
	mvns r1, r1
	adds r1, r1, # 1
	adds r3, r3, # 1
b12:
	bl __chengfa
	cmp r3, # 1
	bne a4
	mvns r0, r0
	mvns r1, r1
a4:
	subs r5, r5, r1 @bc-ad低32
	sbcs r4, r4, r0 @bc-ad高32
	pop {r2}
	mov r1, r5
	movs r5, # 0
	movs r2, r2
	bpl b13
	mvns r2, r2
	adds r2, r2, # 1
	adds r5, r5, # 1
b13:
	movs r0, r4
	bpl b14
	mvns r0, r0
	mvns r1, r1
	adds r5, r5, # 1
b14:
	bl __chufa64
	cmp r5, # 1
	bne __bao_cun_chu_fa_xu_bu_jie_guo
	mvns r1, r1
	mvns r0, r0
	adds r1, r1, # 1
__bao_cun_chu_fa_xu_bu_jie_guo:
	mov r2, r7
	pop {r4-r7}
	mov r8, r4
	mov r9, r5
	mov r10, r6
	mov r11, r7
	pop {r4-r7,pc}

__chufa64:
	@64位除32位
	@ （R0=高32位R1=低32位）除（R2)= （R0高32）（R1低32）
	push {r3-r7,lr}
	cmp r2, # 0
	beq __chu_fa64_fan_hui0
	cmp r1, # 0
	bne __chu_fa64_ji_suan
	cmp r0, # 0
	beq __chu_fa64_fan_hui0
__chu_fa64_ji_suan:
	movs r4, # 0
	mov r7, r4
	mov r3, r4
	mov r5, r4
	movs r6, # 1
	lsls r6, r6, # 31
__chu_fa64_xun_huan:
	lsls r1, r1, # 1
	adcs r0, r0, r0
	adcs r4, r4, r4
	cmp r4, r2
	bcc __chu_fa_yi_wei
	adds r3, r3, r6
	adcs r5, r5, r7
	subs r4, r4, r2
__chu_fa_yi_wei:
	movs r6, r6
	beq __di_yi_wei
	lsrs r6, r6, # 1        @高32位移位
	bne __chu_fa64_xun_huan
	movs r7, # 1
	lsls r7, r7, # 31
	b __chu_fa64_xun_huan
__di_yi_wei:	            @低32位移位
	lsrs r7, r7, # 1
	bne __chu_fa64_xun_huan
	mov r0, r3
	mov r1, r5
	pop {r3-r7,pc}
__chu_fa64_fan_hui0:
	movs r0, # 0
	movs r1, # 0
	pop {r3-r7,pc}
__chengfa:
	@入R0 乘以 R1
	@出 R0高32 ， R1低32
	@0xffffffff*0xffffffff
	@4        F F F E 0 0 0 1                       @4
	@3                F F F E 0 0 0 1               @3
	@2                F F F E 0 0 0 1               @2
	@1                        F F F E 0 0 0 1       @1
	@         F F F F F F F E 0 0 0 0 0 0 0 1
	push {r2-r7,lr}
	cmp r0, # 0
	beq __cheng_fa_fan_hui
	cmp r1, # 0
	beq __cheng_fa_fan_hui
__ji_suan_cheng_fa:
	mov r2, r0
	mov r3, r1
	lsrs r0, r0, # 16       @高16
	lsls r2, r2, # 16       @ 低16
	lsrs r2, r2, # 16
	lsrs r1, r1, # 16       @高16
	lsls r3, r3, # 16       @低16
	lsrs r3, r3, # 16
	mov r4, r2
	mov r5, r0
	muls r2, r2, r3         @1
	muls r0, r0, r3         @2
	muls r4, r4, r1         @3
	muls r5, r5, r1         @4
	mov r6, r0
	mov r7, r4
	lsls r0, r0, # 16       @2低32
	lsls r4, r4, # 16       @3低32
	lsrs r6, r6, # 16       @2高32
	lsrs r7, r7, # 16       @3高32
	movs r1, # 0
	adds r2, r2, r0         @低32
	adcs r6, r6, r1         @高32
	adds r2, r2, r4
	adcs r6, r6, r7
	adds r6, r6, r5
	mov r0, r6
	mov r1, r2
	pop {r2-r7,pc}
__cheng_fa_fan_hui:
	movs r0, # 0
	movs r1, # 0
	pop {r2-r7,pc}
	


	__chu_fa:	@带符号
	push {r1-r7,lr}
        cmp r0, # 0
        beq _chufafanhui1
        cmp r1, # 0
        beq _chufafanhui1
	movs r5, # 0
	movs r0, r0
	bpl __pan_duan_bei_chu_shu
	adds r5, r5, # 1
	mvns r0, r0
	adds r0, r0, # 1
__pan_duan_bei_chu_shu:
	movs r1, r1
	bpl __ji_suan_chu_fa11
	adds r5, r5, # 1
	mvns r1, r1
	adds r1, r1, # 1
__ji_suan_chu_fa11:	
        mov r2, r0
        movs r3, # 1
        lsls r3, r3, # 31
        movs r0, # 0
        mov r4, r0
_chufaxunhuan1:
        lsls r2, r2, # 1
        adcs r4, r4, r4
        cmp r4, r1
	bcc _chufaweishubudao00
	adds r0, r0, r3
	subs r4, r4, r1
_chufaweishubudao00:
	lsrs r3, r3, # 1
	bne _chufaxunhuan1
	cmp r5, # 1
	bne _chufafanhui1
	mvns r0, r0
	adds r0, r0, # 1
_chufafanhui1:
	pop {r1-r7,pc}
	
_nmi:
_Hard_Fault:
_svc_handler:
_pendsv_handler:
aaa:
	bx lr
	
_systickzhongduan:
		push {r0-r6,lr}

	ldr r0, = 0x40020000
	ldr r1, = 0x103e8
	str r1, [r0, # 0x24]    @传输数量
	ldr r1, = dianyabiao
	str r1, [r0, # 0x2c]    @目的地
	movs r1, # 0x69
	str r1, [r0, # 0x20]    @模式设置和开DMA

        ldr r1, = 0x103e8
        str r1, [r0, # 0x44]    @传输数量
	ldr r1, = dianyabiao1
	str r1, [r0, # 0x4c]    @目的地
	movs r1, # 0x69
        str r1, [r0, # 0x40]    @模式设置和开DMA


	bl __dft
	asrs r0, r0, # 4
	asrs r1, r1, # 4
	asrs r2, r2, # 4
	asrs r3, r3, # 4

	mov r4, r0
	mov r5, r2
	mov r6, r3

        ldr r2, = lvboqizhizhen1
        ldr r0, =lvboqihuanchong1
        bl __lv_bo_qi
        ldr r1, = vr_i
        str r0, [r1]

	mov r1, r4
        ldr r2, = lvboqizhizhen0
        ldr r0, =lvboqihuanchong0
        bl __lv_bo_qi
        ldr r1, = vr_r
        str r0, [r1]
	
	mov r1, r5
	ldr r2, = lvboqizhizhen2
	ldr r0, =lvboqihuanchong2
	bl __lv_bo_qi
        ldr r1, = vt_r
	str r0, [r1]

	mov r1, r6
	ldr r2, = lvboqizhizhen3
	ldr r0, =lvboqihuanchong3
	bl __lv_bo_qi
        ldr r1, = vt_i
        str r0, [r1]

__systick_fanhui:
	ldr r0, = 0xe0000d04
	ldr r1, = 0x02000000
	str r1, [r0]                 @ 清除SYSTICK中断
	pop {r0-r6,pc}


	.section .data
	.equ kai_lu_r,			0xf000
	.equ kai_lu_i,			0xf004
	.equ duan_lu_r,			0xf008
	.equ duan_lu_i,			0xf00c
	.equ pi_pei_r,			0xf010
	.equ pi_pei_i,			0xf014
	
	.equ zhanding,			0x200000fc
	.equ dianyabiao,		0x20000100
	.equ dianyabiao1,		0x200008e0

	.equ lvboqizhizhen0,            0x200010c0
	.equ lvboqihuanchong0,          0x200010c8
	.equ lvboqizhizhen1,            0x200012c0
	.equ lvboqihuanchong1,          0x200012c8
        .equ lvboqizhizhen2,            0x200014c0
        .equ lvboqihuanchong2,          0x200014c8
	.equ lvboqizhizhen3,            0x20001600
        .equ lvboqihuanchong3,          0x20001608








	.equ jiaozhun_caidan_zhizhen,	0x20001f58
	
	.equ kailu_r,			0x20001f5c
	.equ kailu_i,			0x20001f60
	.equ duanlu_r,			0x20001f64
	.equ duanlu_i,			0x20001f68
	.equ pipei_r,			0x20001f6c
	.equ pipei_i,			0x20001f70
	.equ pm1,			0x20001f74
	.equ pm1i,			0x20001f78
	.equ pm2,			0x20001f7c
	.equ pm2i,			0x20001f80
	.equ pm3,			0x20001f84
	.equ pm3i,			0x20001f88
	
	.equ p_jz_r,			0x20001f8c
	.equ p_jz_i,			0x20001f90
	.equ p_shibu,			0x20001f94
	.equ p_xubu,			0x20001f98
	.equ z_r,			0x20001fb4
	.equ z_i,			0x20001fb8
	.equ s11_r,			0x20001fbc
	.equ s11_i,			0x20001fc0
	.equ vr_r,			0x20001fc4	
	.equ vr_i,			0x20001fc8
	.equ vt_r,			0x20001fcc
	.equ vt_i,			0x20001fd0
	.equ lvbo_changdu,		0x20001fd4
	.equ lvbo_youyi,		0x20001fd8
	.equ cossin,			0x20001fdc 
	.equ asciibiao,			0x20001fe0

	.align 4
yjmwxwx:
	.ascii "yjmwxwx 2024 10 01"

akong:
	.int 0x20202020
	.int 0x20202020
	.int 0x20202020
	.int 0x20202020
	.int 0x20202020
	.int 0x20202020
afu:
	.ascii "!!"
a_fu:
	.ascii "-"
aCs:
	.ascii "Cs"
aLs:
	.ascii "Ls"
aD:
	.ascii "D"
aQ:
	.ascii "Q"
kai_shi_jiao_zhun:
	.ascii "kai shi  jiao zhun"
ok:
	.ascii "========OK========"
a_kai_lu_jiao_zhun:
	.ascii "kai  lu  jiao zhun"
a_duan_lu_jiao_zhun:
	.ascii "duan lu   jiao zhun"
a_50_ou_jiao_zhun:
	.ascii "dianzu 50R jiaozhun"
a_jiao_zhun_wan_cheng:
	.ascii "jiao zhun wancheng!"

	.align 4
jiao_zhun_bao_cun_biao:
	.word pm1
	.word pm2
	.word pm3
jiao_zhun_xian_shi_biao:
	.word a_kai_lu_jiao_zhun
	.word a_duan_lu_jiao_zhun
	.word a_50_ou_jiao_zhun
	.word a_jiao_zhun_wan_cheng

	.align 4
an_jian_biao:
	.word __anjian0	+1
	.word __anjian1	+1
	.word __anjian2	+1
	.word __anjian3	+1



	
	.align 4
cos_sin_biao_1khz:
	.int 0x8000,0x0000,0x7FFD,0xFFFFFE65,0x7FF5,0xFFFFFCC9,0x7FE8,0xFFFFFB2D,0x7FD6,0xFFFFF992,0x7FBF,0xFFFFF7F7,0x7FA2,0xFFFFF65C,0x7F81,0xFFFFF4C2,0x7F5A,0xFFFFF328,0x7F2E,0xFFFFF18E,0x7EFD,0xFFFFEFF6,0x7EC7,0xFFFFEE5D,0x7E8C,0xFFFFECC6,0x7E4B,0xFFFFEB2F,0x7E06,0xFFFFE999,0x7DBB,0xFFFFE804,0x7D6B,0xFFFFE670,0x7D17,0xFFFFE4DD,0x7CBD,0xFFFFE34C,0x7C5E,0xFFFFE1BB,0x7BFA,0xFFFFE02B,0x7B91,0xFFFFDE9D,0x7B23,0xFFFFDD10,0x7AB0,0xFFFFDB85,0x7A39,0xFFFFD9FB,0x79BC,0xFFFFD873,0x793A,0xFFFFD6EC,0x78B3,0xFFFFD567,0x7828,0xFFFFD3E3,0x7798,0xFFFFD262,0x7702,0xFFFFD0E2,0x7668,0xFFFFCF64,0x75CA,0xFFFFCDE8,0x7526,0xFFFFCC6E,0x747E,0xFFFFCAF6,0x73D1,0xFFFFC981,0x731F,0xFFFFC80D,0x7269,0xFFFFC69C,0x71AE,0xFFFFC52D,0x70EE,0xFFFFC3C0,0x702A,0xFFFFC256,0x6F62,0xFFFFC0EF,0x6E95,0xFFFFBF8A,0x6DC3,0xFFFFBE27,0x6CED,0xFFFFBCC8,0x6C12,0xFFFFBB6B,0x6B34,0xFFFFBA10,0x6A50,0xFFFFB8B9,0x6969,0xFFFFB764,0x687D,0xFFFFB613,0x678D,0xFFFFB4C4,0x6699,0xFFFFB378,0x65A1,0xFFFFB230,0x64A5,0xFFFFB0EA,0x63A4,0xFFFFAFA8,0x62A0,0xFFFFAE69,0x6197,0xFFFFAD2E,0x608B,0xFFFFABF5,0x5F7B,0xFFFFAAC1,0x5E66,0xFFFFA98F,0x5D4E,0xFFFFA861,0x5C33,0xFFFFA737,0x5B13,0xFFFFA610,0x59F0,0xFFFFA4ED,0x58C9,0xFFFFA3CD,0x579F,0xFFFFA2B2,0x5671,0xFFFFA19A,0x553F,0xFFFFA085,0x540B,0xFFFF9F75,0x52D2,0xFFFF9E69,0x5197,0xFFFF9D60,0x5058,0xFFFF9C5C,0x4F16,0xFFFF9B5B,0x4DD0,0xFFFF9A5F,0x4C88,0xFFFF9967,0x4B3C,0xFFFF9873,0x49ED,0xFFFF9783,0x489C,0xFFFF9697,0x4747,0xFFFF95B0,0x45F0,0xFFFF94CC,0x4495,0xFFFF93EE,0x4338,0xFFFF9313,0x41D9,0xFFFF923D,0x4076,0xFFFF916B,0x3F11,0xFFFF909E,0x3DAA,0xFFFF8FD6,0x3C40,0xFFFF8F12,0x3AD3,0xFFFF8E52,0x3964,0xFFFF8D97,0x37F3,0xFFFF8CE1,0x367F,0xFFFF8C2F,0x350A,0xFFFF8B82,0x3392,0xFFFF8ADA,0x3218,0xFFFF8A36,0x309C,0xFFFF8998,0x2F1E,0xFFFF88FE,0x2D9E,0xFFFF8868,0x2C1D,0xFFFF87D8,0x2A99,0xFFFF874D,0x2914,0xFFFF86C6,0x278D,0xFFFF8644,0x2605,0xFFFF85C7,0x247B,0xFFFF8550,0x22F0,0xFFFF84DD,0x2163,0xFFFF846F,0x1FD5,0xFFFF8406,0x1E45,0xFFFF83A2,0x1CB4,0xFFFF8343,0x1B23,0xFFFF82E9,0x1990,0xFFFF8295,0x17FC,0xFFFF8245,0x1667,0xFFFF81FA,0x14D1,0xFFFF81B5,0x133A,0xFFFF8174,0x11A3,0xFFFF8139,0x100A,0xFFFF8103,0x0E72,0xFFFF80D2,0x0CD8,0xFFFF80A6,0x0B3E,0xFFFF807F,0x09A4,0xFFFF805E,0x0809,0xFFFF8041,0x066E,0xFFFF802A,0x04D3,0xFFFF8018,0x0337,0xFFFF800B,0x019B,0xFFFF8003,0x0000,0xFFFF8000,0xFFFFFE65,0xFFFF8003,0xFFFFFCC9,0xFFFF800B,0xFFFFFB2D,0xFFFF8018,0xFFFFF992,0xFFFF802A,0xFFFFF7F7,0xFFFF8041,0xFFFFF65C,0xFFFF805E,0xFFFFF4C2,0xFFFF807F,0xFFFFF328,0xFFFF80A6,0xFFFFF18E,0xFFFF80D2,0xFFFFEFF6,0xFFFF8103,0xFFFFEE5D,0xFFFF8139,0xFFFFECC6,0xFFFF8174,0xFFFFEB2F,0xFFFF81B5,0xFFFFE999,0xFFFF81FA,0xFFFFE804,0xFFFF8245,0xFFFFE670,0xFFFF8295,0xFFFFE4DD,0xFFFF82E9,0xFFFFE34C,0xFFFF8343,0xFFFFE1BB,0xFFFF83A2,0xFFFFE02B,0xFFFF8406,0xFFFFDE9D,0xFFFF846F,0xFFFFDD10,0xFFFF84DD,0xFFFFDB85,0xFFFF8550,0xFFFFD9FB,0xFFFF85C7,0xFFFFD873,0xFFFF8644,0xFFFFD6EC,0xFFFF86C6,0xFFFFD567,0xFFFF874D,0xFFFFD3E3,0xFFFF87D8,0xFFFFD262,0xFFFF8868,0xFFFFD0E2,0xFFFF88FE,0xFFFFCF64,0xFFFF8998,0xFFFFCDE8,0xFFFF8A36,0xFFFFCC6E,0xFFFF8ADA,0xFFFFCAF6,0xFFFF8B82,0xFFFFC981,0xFFFF8C2F,0xFFFFC80D,0xFFFF8CE1,0xFFFFC69C,0xFFFF8D97,0xFFFFC52D,0xFFFF8E52,0xFFFFC3C0,0xFFFF8F12,0xFFFFC256,0xFFFF8FD6,0xFFFFC0EF,0xFFFF909E,0xFFFFBF8A,0xFFFF916B,0xFFFFBE27,0xFFFF923D,0xFFFFBCC8,0xFFFF9313,0xFFFFBB6B,0xFFFF93EE,0xFFFFBA10,0xFFFF94CC,0xFFFFB8B9,0xFFFF95B0,0xFFFFB764,0xFFFF9697,0xFFFFB613,0xFFFF9783,0xFFFFB4C4,0xFFFF9873,0xFFFFB378,0xFFFF9967,0xFFFFB230,0xFFFF9A5F,0xFFFFB0EA,0xFFFF9B5B,0xFFFFAFA8,0xFFFF9C5C,0xFFFFAE69,0xFFFF9D60,0xFFFFAD2E,0xFFFF9E69,0xFFFFABF5,0xFFFF9F75,0xFFFFAAC1,0xFFFFA086,0xFFFFA98F,0xFFFFA19A,0xFFFFA861,0xFFFFA2B2,0xFFFFA737,0xFFFFA3CD,0xFFFFA610,0xFFFFA4ED,0xFFFFA4ED,0xFFFFA610,0xFFFFA3CD,0xFFFFA737,0xFFFFA2B2,0xFFFFA861,0xFFFFA19A,0xFFFFA98F,0xFFFFA086,0xFFFFAAC1,0xFFFF9F75,0xFFFFABF6,0xFFFF9E69,0xFFFFAD2E,0xFFFF9D60,0xFFFFAE69,0xFFFF9C5C,0xFFFFAFA8,0xFFFF9B5B,0xFFFFB0EA,0xFFFF9A5F,0xFFFFB230,0xFFFF9967,0xFFFFB378,0xFFFF9873,0xFFFFB4C4,0xFFFF9783,0xFFFFB613,0xFFFF9697,0xFFFFB764,0xFFFF95B0,0xFFFFB8B9,0xFFFF94CC,0xFFFFBA10,0xFFFF93EE,0xFFFFBB6B,0xFFFF9313,0xFFFFBCC8,0xFFFF923D,0xFFFFBE27,0xFFFF916B,0xFFFFBF8A,0xFFFF909E,0xFFFFC0EF,0xFFFF8FD6,0xFFFFC256,0xFFFF8F12,0xFFFFC3C0,0xFFFF8E52,0xFFFFC52D,0xFFFF8D97,0xFFFFC69C,0xFFFF8CE1,0xFFFFC80D,0xFFFF8C2F,0xFFFFC981,0xFFFF8B82,0xFFFFCAF6,0xFFFF8ADA,0xFFFFCC6E,0xFFFF8A36,0xFFFFCDE8,0xFFFF8998,0xFFFFCF64,0xFFFF88FE,0xFFFFD0E2,0xFFFF8868,0xFFFFD262,0xFFFF87D8,0xFFFFD3E3,0xFFFF874D,0xFFFFD567,0xFFFF86C6,0xFFFFD6EC,0xFFFF8644,0xFFFFD873,0xFFFF85C7,0xFFFFD9FB,0xFFFF8550,0xFFFFDB85,0xFFFF84DD,0xFFFFDD10,0xFFFF846F,0xFFFFDE9D,0xFFFF8406,0xFFFFE02B,0xFFFF83A2,0xFFFFE1BB,0xFFFF8343,0xFFFFE34C,0xFFFF82E9,0xFFFFE4DD,0xFFFF8295,0xFFFFE670,0xFFFF8245,0xFFFFE804,0xFFFF81FA,0xFFFFE999,0xFFFF81B5,0xFFFFEB2F,0xFFFF8174,0xFFFFECC6,0xFFFF8139,0xFFFFEE5D,0xFFFF8103,0xFFFFEFF6,0xFFFF80D2,0xFFFFF18E,0xFFFF80A6,0xFFFFF328,0xFFFF807F,0xFFFFF4C2,0xFFFF805E,0xFFFFF65C,0xFFFF8041,0xFFFFF7F7,0xFFFF802A,0xFFFFF992,0xFFFF8018,0xFFFFFB2D,0xFFFF800B,0xFFFFFCC9,0xFFFF8003,0xFFFFFE65,0xFFFF8000,0x0000,0xFFFF8003,0x019B,0xFFFF800B,0x0337,0xFFFF8018,0x04D3,0xFFFF802A,0x066E,0xFFFF8041,0x0809,0xFFFF805E,0x09A4,0xFFFF807F,0x0B3E,0xFFFF80A6,0x0CD8,0xFFFF80D2,0x0E72,0xFFFF8103,0x100A,0xFFFF8139,0x11A3,0xFFFF8174,0x133A,0xFFFF81B5,0x14D1,0xFFFF81FA,0x1667,0xFFFF8245,0x17FC,0xFFFF8295,0x1990,0xFFFF82E9,0x1B23,0xFFFF8343,0x1CB4,0xFFFF83A2,0x1E45,0xFFFF8406,0x1FD5,0xFFFF846F,0x2163,0xFFFF84DD,0x22F0,0xFFFF8550,0x247B,0xFFFF85C7,0x2605,0xFFFF8644,0x278D,0xFFFF86C6,0x2914,0xFFFF874D,0x2A99,0xFFFF87D8,0x2C1D,0xFFFF8868,0x2D9E,0xFFFF88FE,0x2F1E,0xFFFF8998,0x309C,0xFFFF8A36,0x3218,0xFFFF8ADA,0x3392,0xFFFF8B82,0x350A,0xFFFF8C2F,0x367F,0xFFFF8CE1,0x37F3,0xFFFF8D97,0x3964,0xFFFF8E52,0x3AD3,0xFFFF8F12,0x3C40,0xFFFF8FD6,0x3DAA,0xFFFF909E,0x3F11,0xFFFF916B,0x4076,0xFFFF923D,0x41D9,0xFFFF9313,0x4338,0xFFFF93EE,0x4495,0xFFFF94CC,0x45F0,0xFFFF95B0,0x4747,0xFFFF9697,0x489C,0xFFFF9783,0x49ED,0xFFFF9873,0x4B3C,0xFFFF9967,0x4C88,0xFFFF9A5F,0x4DD0,0xFFFF9B5B,0x4F16,0xFFFF9C5C,0x5058,0xFFFF9D60,0x5197,0xFFFF9E69,0x52D2,0xFFFF9F75,0x540B,0xFFFFA085,0x553F,0xFFFFA19A,0x5671,0xFFFFA2B2,0x579F,0xFFFFA3CD,0x58C9,0xFFFFA4ED,0x59F0,0xFFFFA610,0x5B13,0xFFFFA737,0x5C33,0xFFFFA861,0x5D4E,0xFFFFA98F,0x5E66,0xFFFFAAC1,0x5F7B,0xFFFFABF5,0x608B,0xFFFFAD2E,0x6197,0xFFFFAE69,0x62A0,0xFFFFAFA8,0x63A4,0xFFFFB0EA,0x64A5,0xFFFFB230,0x65A1,0xFFFFB378,0x6699,0xFFFFB4C4,0x678D,0xFFFFB613,0x687D,0xFFFFB764,0x6969,0xFFFFB8B9,0x6A50,0xFFFFBA10,0x6B34,0xFFFFBB6B,0x6C12,0xFFFFBCC8,0x6CED,0xFFFFBE27,0x6DC3,0xFFFFBF8A,0x6E95,0xFFFFC0EF,0x6F62,0xFFFFC256,0x702A,0xFFFFC3C0,0x70EE,0xFFFFC52D,0x71AE,0xFFFFC69C,0x7269,0xFFFFC80D,0x731F,0xFFFFC981,0x73D1,0xFFFFCAF6,0x747E,0xFFFFCC6E,0x7526,0xFFFFCDE8,0x75CA,0xFFFFCF64,0x7668,0xFFFFD0E2,0x7702,0xFFFFD262,0x7798,0xFFFFD3E3,0x7828,0xFFFFD567,0x78B3,0xFFFFD6EC,0x793A,0xFFFFD873,0x79BC,0xFFFFD9FB,0x7A39,0xFFFFDB85,0x7AB0,0xFFFFDD10,0x7B23,0xFFFFDE9D,0x7B91,0xFFFFE02B,0x7BFA,0xFFFFE1BB,0x7C5E,0xFFFFE34C,0x7CBD,0xFFFFE4DD,0x7D17,0xFFFFE670,0x7D6B,0xFFFFE804,0x7DBB,0xFFFFE999,0x7E06,0xFFFFEB2F,0x7E4B,0xFFFFECC6,0x7E8C,0xFFFFEE5D,0x7EC7,0xFFFFEFF6,0x7EFD,0xFFFFF18E,0x7F2E,0xFFFFF328,0x7F5A,0xFFFFF4C2,0x7F81,0xFFFFF65C,0x7FA2,0xFFFFF7F7,0x7FBF,0xFFFFF992,0x7FD6,0xFFFFFB2D,0x7FE8,0xFFFFFCC9,0x7FF5,0xFFFFFE65,0x7FFD,0x0000,0x8000,0x019B,0x7FFD,0x0337,0x7FF5,0x04D3,0x7FE8,0x066E,0x7FD6,0x0809,0x7FBF,0x09A4,0x7FA2,0x0B3E,0x7F81,0x0CD8,0x7F5A,0x0E72,0x7F2E,0x100A,0x7EFD,0x11A3,0x7EC7,0x133A,0x7E8C,0x14D1,0x7E4B,0x1667,0x7E06,0x17FC,0x7DBB,0x1990,0x7D6B,0x1B23,0x7D17,0x1CB4,0x7CBD,0x1E45,0x7C5E,0x1FD5,0x7BFA,0x2163,0x7B91,0x22F0,0x7B23,0x247B,0x7AB0,0x2605,0x7A39,0x278D,0x79BC,0x2914,0x793A,0x2A99,0x78B3,0x2C1D,0x7828,0x2D9E,0x7798,0x2F1E,0x7702,0x309C,0x7668,0x3218,0x75CA,0x3392,0x7526,0x350A,0x747E,0x367F,0x73D1,0x37F3,0x731F,0x3964,0x7269,0x3AD3,0x71AE,0x3C40,0x70EE,0x3DAA,0x702A,0x3F11,0x6F62,0x4076,0x6E95,0x41D9,0x6DC3,0x4338,0x6CED,0x4495,0x6C12,0x45F0,0x6B34,0x4747,0x6A50,0x489C,0x6969,0x49ED,0x687D,0x4B3C,0x678D,0x4C88,0x6699,0x4DD0,0x65A1,0x4F16,0x64A5,0x5058,0x63A4,0x5197,0x62A0,0x52D2,0x6197,0x540B,0x608B,0x553F,0x5F7A,0x5671,0x5E66,0x579F,0x5D4E,0x58C9,0x5C33,0x59F0,0x5B13,0x5B13,0x59F0,0x5C33,0x58C9,0x5D4E,0x579F,0x5E66,0x5671,0x5F7B,0x553F,0x608B,0x540B,0x6197,0x52D2,0x62A0,0x5197,0x63A4,0x5058,0x64A5,0x4F16,0x65A1,0x4DD0,0x6699,0x4C88,0x678D,0x4B3C,0x687D,0x49ED,0x6969,0x489C,0x6A50,0x4747,0x6B34,0x45F0,0x6C12,0x4495,0x6CED,0x4338,0x6DC3,0x41D9,0x6E95,0x4076,0x6F62,0x3F11,0x702A,0x3DAA,0x70EE,0x3C40,0x71AE,0x3AD3,0x7269,0x3964,0x731F,0x37F3,0x73D1,0x367F,0x747E,0x350A,0x7526,0x3392,0x75CA,0x3218,0x7668,0x309C,0x7702,0x2F1E,0x7798,0x2D9E,0x7828,0x2C1D,0x78B3,0x2A99,0x793A,0x2914,0x79BC,0x278D,0x7A39,0x2605,0x7AB0,0x247B,0x7B23,0x22F0,0x7B91,0x2163,0x7BFA,0x1FD5,0x7C5E,0x1E45,0x7CBD,0x1CB4,0x7D17,0x1B23,0x7D6B,0x1990,0x7DBB,0x17FC,0x7E06,0x1667,0x7E4B,0x14D1,0x7E8C,0x133A,0x7EC7,0x11A3,0x7EFD,0x100A,0x7F2E,0x0E72,0x7F5A,0x0CD8,0x7F81,0x0B3E,0x7FA2,0x09A4,0x7FBF,0x0809,0x7FD6,0x066E,0x7FE8,0x04D3,0x7FF5,0x0337,0x7FFD,0x019B,0x8000,0x0000,0x7FFD,0xFFFFFE65,0x7FF5,0xFFFFFCC9,0x7FE8,0xFFFFFB2D,0x7FD6,0xFFFFF992,0x7FBF,0xFFFFF7F7,0x7FA2,0xFFFFF65C,0x7F81,0xFFFFF4C2,0x7F5A,0xFFFFF328,0x7F2E,0xFFFFF18E,0x7EFD,0xFFFFEFF6,0x7EC7,0xFFFFEE5D,0x7E8C,0xFFFFECC6,0x7E4B,0xFFFFEB2F,0x7E06,0xFFFFE999,0x7DBB,0xFFFFE804,0x7D6B,0xFFFFE670,0x7D17,0xFFFFE4DD,0x7CBD,0xFFFFE34C,0x7C5E,0xFFFFE1BB,0x7BFA,0xFFFFE02B,0x7B91,0xFFFFDE9D,0x7B23,0xFFFFDD10,0x7AB0,0xFFFFDB85,0x7A39,0xFFFFD9FB,0x79BC,0xFFFFD873,0x793A,0xFFFFD6EC,0x78B3,0xFFFFD567,0x7828,0xFFFFD3E3,0x7798,0xFFFFD262,0x7702,0xFFFFD0E2,0x7668,0xFFFFCF64,0x75CA,0xFFFFCDE8,0x7526,0xFFFFCC6E,0x747E,0xFFFFCAF6,0x73D1,0xFFFFC981,0x731F,0xFFFFC80D,0x7269,0xFFFFC69C,0x71AE,0xFFFFC52D,0x70EE,0xFFFFC3C0,0x702A,0xFFFFC256,0x6F62,0xFFFFC0EF,0x6E95,0xFFFFBF8A,0x6DC3,0xFFFFBE27,0x6CED,0xFFFFBCC8,0x6C12,0xFFFFBB6B,0x6B34,0xFFFFBA10,0x6A50,0xFFFFB8B9,0x6969,0xFFFFB764,0x687D,0xFFFFB613,0x678D,0xFFFFB4C4,0x6699,0xFFFFB378,0x65A1,0xFFFFB230,0x64A5,0xFFFFB0EA,0x63A4,0xFFFFAFA8,0x62A0,0xFFFFAE69,0x6197,0xFFFFAD2E,0x608B,0xFFFFABF5,0x5F7A,0xFFFFAAC1,0x5E66,0xFFFFA98F,0x5D4E,0xFFFFA861,0x5C33,0xFFFFA737,0x5B13,0xFFFFA610,0x59F0,0xFFFFA4ED,0x58C9,0xFFFFA3CD,0x579F,0xFFFFA2B2,0x5671,0xFFFFA19A,0x553F,0xFFFFA085,0x540A,0xFFFF9F75,0x52D2,0xFFFF9E69,0x5197,0xFFFF9D60,0x5058,0xFFFF9C5C,0x4F16,0xFFFF9B5B,0x4DD0,0xFFFF9A5F,0x4C88,0xFFFF9967,0x4B3C,0xFFFF9873,0x49ED,0xFFFF9783,0x489C,0xFFFF9697,0x4747,0xFFFF95B0,0x45F0,0xFFFF94CC,0x4495,0xFFFF93EE,0x4338,0xFFFF9313,0x41D9,0xFFFF923D,0x4076,0xFFFF916B,0x3F11,0xFFFF909E,0x3DAA,0xFFFF8FD6,0x3C40,0xFFFF8F12,0x3AD3,0xFFFF8E52,0x3964,0xFFFF8D97,0x37F3,0xFFFF8CE1,0x367F,0xFFFF8C2F,0x350A,0xFFFF8B82,0x3392,0xFFFF8ADA,0x3218,0xFFFF8A36,0x309C,0xFFFF8998,0x2F1E,0xFFFF88FE,0x2D9E,0xFFFF8868,0x2C1D,0xFFFF87D8,0x2A99,0xFFFF874D,0x2914,0xFFFF86C6,0x278D,0xFFFF8644,0x2605,0xFFFF85C7,0x247B,0xFFFF8550,0x22F0,0xFFFF84DD,0x2163,0xFFFF846F,0x1FD5,0xFFFF8406,0x1E45,0xFFFF83A2,0x1CB4,0xFFFF8343,0x1B23,0xFFFF82E9,0x1990,0xFFFF8295,0x17FC,0xFFFF8245,0x1667,0xFFFF81FA,0x14D1,0xFFFF81B5,0x133A,0xFFFF8174,0x11A3,0xFFFF8139,0x100A,0xFFFF8103,0x0E72,0xFFFF80D2,0x0CD8,0xFFFF80A6,0x0B3E,0xFFFF807F,0x09A4,0xFFFF805E,0x0809,0xFFFF8041,0x066E,0xFFFF802A,0x04D3,0xFFFF8018,0x0337,0xFFFF800B,0x019B,0xFFFF8003,0x0000,0xFFFF8000,0xFFFFFE65,0xFFFF8003,0xFFFFFCC9,0xFFFF800B,0xFFFFFB2D,0xFFFF8018,0xFFFFF992,0xFFFF802A,0xFFFFF7F7,0xFFFF8041,0xFFFFF65C,0xFFFF805E,0xFFFFF4C2,0xFFFF807F,0xFFFFF328,0xFFFF80A6,0xFFFFF18E,0xFFFF80D2,0xFFFFEFF6,0xFFFF8103,0xFFFFEE5D,0xFFFF8139,0xFFFFECC6,0xFFFF8174,0xFFFFEB2F,0xFFFF81B5,0xFFFFE999,0xFFFF81FA,0xFFFFE804,0xFFFF8245,0xFFFFE670,0xFFFF8295,0xFFFFE4DD,0xFFFF82E9,0xFFFFE34C,0xFFFF8343,0xFFFFE1BB,0xFFFF83A2,0xFFFFE02B,0xFFFF8406,0xFFFFDE9D,0xFFFF846F,0xFFFFDD10,0xFFFF84DD,0xFFFFDB85,0xFFFF8550,0xFFFFD9FB,0xFFFF85C8,0xFFFFD873,0xFFFF8644,0xFFFFD6EC,0xFFFF86C6,0xFFFFD567,0xFFFF874D,0xFFFFD3E3,0xFFFF87D8,0xFFFFD262,0xFFFF8868,0xFFFFD0E2,0xFFFF88FE,0xFFFFCF64,0xFFFF8998,0xFFFFCDE8,0xFFFF8A36,0xFFFFCC6E,0xFFFF8ADA,0xFFFFCAF6,0xFFFF8B82,0xFFFFC981,0xFFFF8C2F,0xFFFFC80D,0xFFFF8CE1,0xFFFFC69C,0xFFFF8D97,0xFFFFC52D,0xFFFF8E52,0xFFFFC3C0,0xFFFF8F12,0xFFFFC256,0xFFFF8FD6,0xFFFFC0EF,0xFFFF909E,0xFFFFBF8A,0xFFFF916B,0xFFFFBE27,0xFFFF923D,0xFFFFBCC8,0xFFFF9313,0xFFFFBB6B,0xFFFF93EE,0xFFFFBA10,0xFFFF94CC,0xFFFFB8B9,0xFFFF95B0,0xFFFFB764,0xFFFF9697,0xFFFFB613,0xFFFF9783,0xFFFFB4C4,0xFFFF9873,0xFFFFB378,0xFFFF9967,0xFFFFB230,0xFFFF9A5F,0xFFFFB0EA,0xFFFF9B5B,0xFFFFAFA8,0xFFFF9C5C,0xFFFFAE69,0xFFFF9D60,0xFFFFAD2E,0xFFFF9E69,0xFFFFABF5,0xFFFF9F75,0xFFFFAAC1,0xFFFFA086,0xFFFFA98F,0xFFFFA19A,0xFFFFA861,0xFFFFA2B2,0xFFFFA737,0xFFFFA3CD,0xFFFFA610,0xFFFFA4ED,0xFFFFA4ED,0xFFFFA610,0xFFFFA3CD,0xFFFFA737,0xFFFFA2B2,0xFFFFA861,0xFFFFA19A,0xFFFFA98F,0xFFFFA085,0xFFFFAAC1,0xFFFF9F75,0xFFFFABF6,0xFFFF9E69,0xFFFFAD2E,0xFFFF9D60,0xFFFFAE69,0xFFFF9C5C,0xFFFFAFA8,0xFFFF9B5B,0xFFFFB0EA,0xFFFF9A5F,0xFFFFB230,0xFFFF9967,0xFFFFB378,0xFFFF9873,0xFFFFB4C4,0xFFFF9783,0xFFFFB613,0xFFFF9697,0xFFFFB764,0xFFFF95B0,0xFFFFB8B9,0xFFFF94CC,0xFFFFBA10,0xFFFF93EE,0xFFFFBB6B,0xFFFF9313,0xFFFFBCC8,0xFFFF923D,0xFFFFBE27,0xFFFF916B,0xFFFFBF8A,0xFFFF909E,0xFFFFC0EF,0xFFFF8FD6,0xFFFFC256,0xFFFF8F12,0xFFFFC3C0,0xFFFF8E52,0xFFFFC52D,0xFFFF8D97,0xFFFFC69C,0xFFFF8CE1,0xFFFFC80D,0xFFFF8C2F,0xFFFFC981,0xFFFF8B82,0xFFFFCAF6,0xFFFF8ADA,0xFFFFCC6E,0xFFFF8A36,0xFFFFCDE8,0xFFFF8998,0xFFFFCF64,0xFFFF88FE,0xFFFFD0E2,0xFFFF8868,0xFFFFD262,0xFFFF87D8,0xFFFFD3E3,0xFFFF874D,0xFFFFD567,0xFFFF86C6,0xFFFFD6EC,0xFFFF8644,0xFFFFD873,0xFFFF85C7,0xFFFFD9FB,0xFFFF8550,0xFFFFDB85,0xFFFF84DD,0xFFFFDD10,0xFFFF846F,0xFFFFDE9D,0xFFFF8406,0xFFFFE02B,0xFFFF83A2,0xFFFFE1BB,0xFFFF8343,0xFFFFE34C,0xFFFF82E9,0xFFFFE4DD,0xFFFF8295,0xFFFFE670,0xFFFF8245,0xFFFFE804,0xFFFF81FA,0xFFFFE999,0xFFFF81B5,0xFFFFEB2F,0xFFFF8174,0xFFFFECC6,0xFFFF8139,0xFFFFEE5D,0xFFFF8103,0xFFFFEFF6,0xFFFF80D2,0xFFFFF18E,0xFFFF80A6,0xFFFFF328,0xFFFF807F,0xFFFFF4C2,0xFFFF805E,0xFFFFF65C,0xFFFF8041,0xFFFFF7F7,0xFFFF802A,0xFFFFF992,0xFFFF8018,0xFFFFFB2D,0xFFFF800B,0xFFFFFCC9,0xFFFF8003,0xFFFFFE65,0xFFFF8000,0x0000,0xFFFF8003,0x019B,0xFFFF800B,0x0337,0xFFFF8018,0x04D3,0xFFFF802A,0x066E,0xFFFF8041,0x0809,0xFFFF805E,0x09A4,0xFFFF807F,0x0B3E,0xFFFF80A6,0x0CD8,0xFFFF80D2,0x0E72,0xFFFF8103,0x100A,0xFFFF8139,0x11A3,0xFFFF8174,0x133A,0xFFFF81B5,0x14D1,0xFFFF81FA,0x1667,0xFFFF8245,0x17FC,0xFFFF8295,0x1990,0xFFFF82E9,0x1B23,0xFFFF8343,0x1CB4,0xFFFF83A2,0x1E45,0xFFFF8406,0x1FD5,0xFFFF846F,0x2163,0xFFFF84DD,0x22F0,0xFFFF8550,0x247B,0xFFFF85C7,0x2605,0xFFFF8644,0x278D,0xFFFF86C6,0x2914,0xFFFF874D,0x2A99,0xFFFF87D8,0x2C1D,0xFFFF8868,0x2D9E,0xFFFF88FE,0x2F1E,0xFFFF8998,0x309C,0xFFFF8A36,0x3218,0xFFFF8ADA,0x3392,0xFFFF8B82,0x350A,0xFFFF8C2F,0x367F,0xFFFF8CE1,0x37F3,0xFFFF8D97,0x3964,0xFFFF8E52,0x3AD3,0xFFFF8F12,0x3C40,0xFFFF8FD6,0x3DAA,0xFFFF909E,0x3F11,0xFFFF916B,0x4076,0xFFFF923D,0x41D9,0xFFFF9313,0x4338,0xFFFF93EE,0x4495,0xFFFF94CC,0x45F0,0xFFFF95B0,0x4747,0xFFFF9697,0x489C,0xFFFF9783,0x49ED,0xFFFF9873,0x4B3C,0xFFFF9967,0x4C88,0xFFFF9A5F,0x4DD0,0xFFFF9B5B,0x4F16,0xFFFF9C5C,0x5058,0xFFFF9D60,0x5197,0xFFFF9E69,0x52D2,0xFFFF9F75,0x540B,0xFFFFA086,0x553F,0xFFFFA19A,0x5671,0xFFFFA2B2,0x579F,0xFFFFA3CD,0x58C9,0xFFFFA4ED,0x59F0,0xFFFFA610,0x5B13,0xFFFFA737,0x5C33,0xFFFFA861,0x5D4E,0xFFFFA98F,0x5E66,0xFFFFAAC1,0x5F7A,0xFFFFABF5,0x608B,0xFFFFAD2E,0x6197,0xFFFFAE69,0x62A0,0xFFFFAFA8,0x63A4,0xFFFFB0EA,0x64A5,0xFFFFB230,0x65A1,0xFFFFB378,0x6699,0xFFFFB4C4,0x678D,0xFFFFB613,0x687D,0xFFFFB764,0x6969,0xFFFFB8B9,0x6A50,0xFFFFBA10,0x6B34,0xFFFFBB6B,0x6C12,0xFFFFBCC8,0x6CED,0xFFFFBE27,0x6DC3,0xFFFFBF8A,0x6E95,0xFFFFC0EF,0x6F62,0xFFFFC256,0x702A,0xFFFFC3C0,0x70EE,0xFFFFC52D,0x71AE,0xFFFFC69C,0x7269,0xFFFFC80D,0x731F,0xFFFFC981,0x73D1,0xFFFFCAF6,0x747E,0xFFFFCC6E,0x7526,0xFFFFCDE8,0x75CA,0xFFFFCF64,0x7668,0xFFFFD0E2,0x7702,0xFFFFD262,0x7798,0xFFFFD3E3,0x7828,0xFFFFD567,0x78B3,0xFFFFD6EC,0x793A,0xFFFFD873,0x79BC,0xFFFFD9FB,0x7A39,0xFFFFDB85,0x7AB0,0xFFFFDD10,0x7B23,0xFFFFDE9D,0x7B91,0xFFFFE02B,0x7BFA,0xFFFFE1BB,0x7C5E,0xFFFFE34C,0x7CBD,0xFFFFE4DD,0x7D17,0xFFFFE670,0x7D6B,0xFFFFE804,0x7DBB,0xFFFFE999,0x7E06,0xFFFFEB2F,0x7E4B,0xFFFFECC6,0x7E8C,0xFFFFEE5D,0x7EC7,0xFFFFEFF6,0x7EFD,0xFFFFF18E,0x7F2E,0xFFFFF328,0x7F5A,0xFFFFF4C2,0x7F81,0xFFFFF65C,0x7FA2,0xFFFFF7F7,0x7FBF,0xFFFFF992,0x7FD6,0xFFFFFB2D,0x7FE8,0xFFFFFCC9,0x7FF5,0xFFFFFE65,0x7FFD,0x0000,0x8000,0x019B,0x7FFD,0x0337,0x7FF5,0x04D3,0x7FE8,0x066E,0x7FD6,0x0809,0x7FBF,0x09A4,0x7FA2,0x0B3E,0x7F81,0x0CD8,0x7F5A,0x0E72,0x7F2E,0x100A,0x7EFD,0x11A3,0x7EC7,0x133A,0x7E8C,0x14D1,0x7E4B,0x1667,0x7E06,0x17FC,0x7DBB,0x1990,0x7D6B,0x1B23,0x7D17,0x1CB4,0x7CBD,0x1E45,0x7C5E,0x1FD5,0x7BFA,0x2163,0x7B91,0x22F0,0x7B23,0x247B,0x7AB0,0x2605,0x7A38,0x278D,0x79BC,0x2914,0x793A,0x2A99,0x78B3,0x2C1D,0x7828,0x2D9E,0x7798,0x2F1E,0x7702,0x309C,0x7668,0x3218,0x75CA,0x3392,0x7526,0x350A,0x747E,0x367F,0x73D1,0x37F3,0x731F,0x3964,0x7269,0x3AD3,0x71AE,0x3C40,0x70EE,0x3DAA,0x702A,0x3F11,0x6F62,0x4076,0x6E95,0x41D9,0x6DC3,0x4338,0x6CED,0x4495,0x6C12,0x45F0,0x6B34,0x4747,0x6A50,0x489C,0x6969,0x49ED,0x687D,0x4B3C,0x678D,0x4C88,0x6699,0x4DD0,0x65A1,0x4F16,0x64A5,0x5058,0x63A4,0x5197,0x62A0,0x52D2,0x6197,0x540B,0x608B,0x553F,0x5F7B,0x5671,0x5E66,0x579F,0x5D4E,0x58C9,0x5C33,0x59F0,0x5B13,0x5B13,0x59F0,0x5C33,0x58C9,0x5D4E,0x579F,0x5E66,0x5671,0x5F7B,0x553F,0x608B,0x540A,0x6197,0x52D2,0x62A0,0x5197,0x63A4,0x5058,0x64A5,0x4F16,0x65A1,0x4DD0,0x6699,0x4C88,0x678D,0x4B3C,0x687D,0x49ED,0x6969,0x489C,0x6A50,0x4747,0x6B34,0x45F0,0x6C12,0x4495,0x6CED,0x4338,0x6DC3,0x41D9,0x6E95,0x4076,0x6F62,0x3F11,0x702A,0x3DAA,0x70EE,0x3C40,0x71AE,0x3AD3,0x7269,0x3964,0x731F,0x37F3,0x73D1,0x367F,0x747E,0x350A,0x7526,0x3392,0x75CA,0x3218,0x7668,0x309C,0x7702,0x2F1E,0x7798,0x2D9E,0x7828,0x2C1D,0x78B3,0x2A99,0x793A,0x2914,0x79BC,0x278D,0x7A39,0x2605,0x7AB0,0x247B,0x7B23,0x22F0,0x7B91,0x2163,0x7BFA,0x1FD5,0x7C5E,0x1E45,0x7CBD,0x1CB4,0x7D17,0x1B23,0x7D6B,0x1990,0x7DBB,0x17FC,0x7E06,0x1667,0x7E4B,0x14D1,0x7E8C,0x133A,0x7EC7,0x11A3,0x7EFD,0x100A,0x7F2E,0x0E72,0x7F5A,0x0CD8,0x7F81,0x0B3E,0x7FA2,0x09A4,0x7FBF,0x0809,0x7FD6,0x066E,0x7FE8,0x04D3,0x7FF5,0x0337,0x7FFD,0x019B

	.align 4

si5351:	 @0=148999000, 1=149000000,2=24000000
.byte 0x00
.byte 0x0002, 0x13
.byte 0x0003, 0x00
.byte 0x0004, 0x00
.byte 0x0007, 0x00
.byte 0x000F, 0x00
.byte 0x0010, 0x6F
.byte 0x0011, 0x4F
.byte 0x0012, 0x0F
.byte 0x0013, 0x8C
.byte 0x0014, 0x8C
.byte 0x0015, 0x8C
.byte 0x0016, 0x8C
.byte 0x0017, 0x8C
.byte 0x001A, 0x00
.byte 0x001B, 0x19
.byte 0x001C, 0x00
.byte 0x001D, 0x0F
.byte 0x001E, 0xE1
.byte 0x001F, 0x00
.byte 0x0020, 0x00
.byte 0x0021, 0x07
.byte 0x0022, 0x30
.byte 0x0023, 0xD4
.byte 0x0024, 0x00
.byte 0x0025, 0x0F
.byte 0x0026, 0xE1
.byte 0x0027, 0x00
.byte 0x0028, 0x0C
.byte 0x0029, 0x2C
.byte 0x002A, 0x00
.byte 0x002B, 0x01
.byte 0x002C, 0x00
.byte 0x002D, 0x01
.byte 0x002E, 0x00
.byte 0x002F, 0x00
.byte 0x0030, 0x00
.byte 0x0031, 0x00
.byte 0x0032, 0x00
.byte 0x0033, 0x01
.byte 0x0034, 0x00
.byte 0x0035, 0x01
.byte 0x0036, 0x00
.byte 0x0037, 0x00
.byte 0x0038, 0x00
.byte 0x0039, 0x00
.byte 0x003A, 0x00
.byte 0x003B, 0x04
.byte 0x003C, 0x00
.byte 0x003D, 0x10
.byte 0x003E, 0xA0
.byte 0x003F, 0x00
.byte 0x0040, 0x00
.byte 0x0041, 0x00
.byte 0x005A, 0x00
.byte 0x005B, 0x00
.byte 0x0095, 0x00
.byte 0x0096, 0x00
.byte 0x0097, 0x00
.byte 0x0098, 0x00
.byte 0x0099, 0x00
.byte 0x009A, 0x00
.byte 0x009B, 0x00
.byte 0x00A2, 0x00
.byte 0x00A3, 0x00
.byte 0x00A4, 0x00
.byte 0x00A5, 0x00
.byte 0x00A6, 0x00
.byte 0x00A7, 0x00
.byte 0x00B7, 0x92

	
@si5351:	@0=148999000,1=149000000,2=28000000
	.byte 0x00,2,0x13,3,0,4,0,7,0,15,0,16,0x7F,17,0x5F,18,0x1F
	.byte 19,0x8C,20,0x8C,21,0x8C,22,0x8C,23,0x8C,26,0,27,0x19,28,0
	.byte 29,0x0F,30,0xE1,31,0,32,0,33,0x07,34,0x30,35,0xD4,36,0
	.byte 37,0x0F,38,0xE1,39,0,40,0x0C,41,0x2C,42,0,43,0x01,44,0
	.byte 45,0x01,46,0,47,0,48,0,49,0,50,0,51,0x01,52,0
	.byte 53,0x01,54,0,55,0,56,0,57,0,58,0,59,0x0E,60,0
	.byte 61,0x0D,62,0xF6,63,0,64,0,65,0x0C,90,0,91,0,149,0
	.byte 150,0,151,0,152,0,153,0,154,0,155,0,162,0,163,0
	.byte 164,0,165,0,166,0,167,0,183,0x92

	

	.align 4
da_a_labo_hack:			 @16*24
	.byte 0x00, 0x00, 0x00, 0x80, 0xFF, 0x01, 0xF0, 0xFF, 0x0F, 0xF8, 0xFF, 0x1F, 0x7C, 0x00, 0x3E, 0x1E, 0x00, 0x78, 0x0E, 0x00, 0x70, 0x0E, 0x00, 0x70, 0x0E, 0x00, 0x70, 0x0E, 0x00, 0x70, 0x1E, 0x00, 0x78, 0x7C, 0x00, 0x3E, 0xF8, 0xFF, 0x1F, 0xF0, 0xFF, 0x0F, 0x80, 0xFF, 0x01, 0x00, 0x00, 0x00 @ 0
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x70, 0x00, 0x70, 0x70, 0x00, 0x70, 0x70, 0x00, 0x70, 0x78, 0x00, 0x70, 0xFC, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0x00, 0x00, 0x70, 0x00, 0x00, 0x70, 0x00, 0x00, 0x70, 0x00, 0x00, 0x70, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 @ 1
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x78, 0x1C, 0x00, 0x7C, 0x1C, 0x00, 0x7E, 0x0E, 0x00, 0x77, 0x0E, 0x00, 0x77, 0x0E, 0x80, 0x73, 0x0E, 0xC0, 0x71, 0x0E, 0xE0, 0x70, 0x1E, 0x78, 0x70, 0x1E, 0x3C, 0x70, 0xFC, 0x1F, 0x70, 0xF8, 0x07, 0x70, 0xF0, 0x03, 0x70, 0x00, 0x00, 0x70, 0x00, 0x00, 0x00 @ 2
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0x1C, 0x00, 0x38, 0x1C, 0x00, 0x70, 0x0E, 0x00, 0x70, 0x0E, 0x00, 0x70, 0x0E, 0x1C, 0x70, 0x0E, 0x1C, 0x70, 0x0E, 0x1C, 0x70, 0x0E, 0x1C, 0x70, 0x0E, 0x3E, 0x78, 0x1C, 0x37, 0x3C, 0xFC, 0xF3, 0x3F, 0xF8, 0xE3, 0x1F, 0xF0, 0xC0, 0x07, 0x00, 0x00, 0x00 @ 3
	.byte 0x00, 0xE0, 0x01, 0x00, 0xF0, 0x01, 0x00, 0xFC, 0x01, 0x00, 0xFE, 0x01, 0x00, 0xDF, 0x01, 0x80, 0xCF, 0x01, 0xE0, 0xC3, 0x01, 0xF0, 0xC1, 0x01, 0xF8, 0xC0, 0x01, 0x7C, 0xC0, 0x01, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0x00, 0xC0, 0x01, 0x00, 0xC0, 0x01, 0x00, 0xC0, 0x01 @ 4
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x38, 0xFE, 0x1F, 0x38, 0xFE, 0x0F, 0x70, 0xFE, 0x0F, 0x70, 0x0E, 0x0E, 0x70, 0x0E, 0x0E, 0x70, 0x0E, 0x0E, 0x70, 0x0E, 0x0E, 0x70, 0x0E, 0x1E, 0x78, 0x0E, 0x3C, 0x3C, 0x0E, 0xFC, 0x1F, 0x0E, 0xF8, 0x0F, 0x0E, 0xE0, 0x07, 0x00, 0x00, 0x00 @ 5
	.byte 0x00, 0x00, 0x00, 0x00, 0xFE, 0x03, 0xC0, 0xFF, 0x0F, 0xF0, 0xFF, 0x1F, 0xF8, 0x1C, 0x3E, 0x3C, 0x0C, 0x78, 0x1C, 0x0E, 0x70, 0x1E, 0x0E, 0x70, 0x0E, 0x0E, 0x70, 0x0E, 0x0E, 0x70, 0x0E, 0x1E, 0x78, 0x0E, 0x3C, 0x3C, 0x1E, 0xFC, 0x1F, 0x00, 0xF8, 0x0F, 0x00, 0xE0, 0x07, 0x00, 0x00, 0x00 @ 6
	.byte 0x00, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x0E, 0x00, 0x40, 0x0E, 0x00, 0x70, 0x0E, 0x00, 0x7C, 0x0E, 0x00, 0x7F, 0x0E, 0xC0, 0x1F, 0x0E, 0xF0, 0x07, 0x0E, 0xFC, 0x00, 0x0E, 0x3F, 0x00, 0xCE, 0x0F, 0x00, 0xFE, 0x03, 0x00, 0xFE, 0x00, 0x00, 0x3E, 0x00, 0x00, 0x00, 0x00, 0x00 @ 7
	.byte 0x00, 0x00, 0x00, 0x00, 0xC0, 0x07, 0xF0, 0xE1, 0x1F, 0xF8, 0xF3, 0x3F, 0xFC, 0x3F, 0x3C, 0x1E, 0x1F, 0x78, 0x0E, 0x0E, 0x70, 0x0E, 0x0C, 0x70, 0x0E, 0x1C, 0x70, 0x0E, 0x18, 0x70, 0x1E, 0x3C, 0x78, 0xFC, 0x7F, 0x3C, 0xF8, 0xF3, 0x3F, 0xF0, 0xE1, 0x1F, 0x00, 0xC0, 0x07, 0x00, 0x00, 0x00 @ 8
	.byte 0x00, 0x00, 0x00, 0xE0, 0x07, 0x00, 0xF0, 0x1F, 0x00, 0xF8, 0x3F, 0x78, 0x3C, 0x3C, 0x70, 0x1E, 0x78, 0x70, 0x0E, 0x70, 0x70, 0x0E, 0x70, 0x70, 0x0E, 0x70, 0x78, 0x0E, 0x70, 0x38, 0x1E, 0x30, 0x3C, 0x7C, 0x38, 0x1F, 0xF8, 0xFF, 0x0F, 0xF0, 0xFF, 0x03, 0xC0, 0x7F, 0x00, 0x00, 0x00, 0x00 @ 9
	.align 4
ascii_biao:				@6*8
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 @
	@	.byte 0x00, 0x00, 0x00, 0x4F, 0x00, 0x00 @ !	
	.byte 0x3c, 0x3c, 0x3c, 0x3c, 0x3c, 0x3c @ !		@上面是对的
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

danweibiao:			 @15*24
	.byte 0x00, 0x00, 0x00, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0x00, 0xC0, 0x00, 0x00, 0x80, 0x01, 0x00, 0x80, 0x03, 0x00, 0x80, 0x03, 0x00, 0x80, 0x03, 0x00, 0xE0, 0x01, 0xFE, 0x7F, 0x00, 0xFE, 0xFF, 0x01, 0xFE, 0xFF, 0x03, 0x00, 0x80, 0x03, 0x00, 0x80, 0x01 @ µ
	.byte 0x00, 0x7F, 0x70, 0xE0, 0xFF, 0x73, 0xF0, 0xFF, 0x77, 0xF8, 0x00, 0x7F, 0x38, 0x00, 0x7C, 0x3C, 0x00, 0x70, 0x1C, 0x00, 0x60, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0x60, 0x3C, 0x00, 0x70, 0x38, 0x00, 0x7C, 0xF8, 0x00, 0x7F, 0xF0, 0xFF, 0x77, 0xE0, 0xFF, 0x73, 0x00, 0x7F, 0x70 @Ω
	.byte 0x00, 0x00, 0x00, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x1C, 0x00, 0x0E, 0x00, 0x00 @ F
	.byte 0x00, 0xF8, 0x7F, 0x00, 0xFC, 0x7F, 0x00, 0x1E, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x1C, 0x00, 0x00, 0xF8, 0x7F, 0x00, 0xF8, 0x7F, 0x00, 0x1C, 0x00, 0x00, 0x0C, 0x00, 0x00, 0x0E, 0x00, 0x00, 0x1E, 0x00, 0x00, 0xFC, 0x7F, 0x00, 0xF8, 0x7F, 0x00, 0x00, 0x00 @ m
	.byte 0x00, 0x00, 0x00, 0xFC, 0xFF, 0x0F, 0xFC, 0xFF, 0x0F, 0x3C, 0x00, 0x00, 0xF0, 0x01, 0x00, 0x80, 0x0F, 0x00, 0x00, 0x3C, 0x00, 0x00, 0x3C, 0x00, 0x80, 0x0F, 0x00, 0xF0, 0x01, 0x00, 0x3C, 0x00, 0x00, 0xFC, 0xFF, 0x0F, 0xFC, 0xFF, 0x0F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 @ M
	.byte 0x00, 0x00, 0x00, 0x80, 0xFF, 0x7F, 0x80, 0xFF, 0x7F, 0x80, 0xFF, 0x7F, 0x00, 0x07, 0x00, 0x80, 0x03, 0x00, 0xC0, 0x01, 0x00, 0xC0, 0x01, 0x00, 0xC0, 0x01, 0x00, 0xC0, 0x03, 0x00, 0xC0, 0xFF, 0x7F, 0x80, 0xFF, 0x7F, 0x00, 0xFE, 0x7F, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 @ n
	.byte 0x00, 0x00, 0x00, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0x1C, 0xE0, 0x00, 0x0E, 0xC0, 0x00, 0x06, 0x80, 0x01, 0x06, 0x80, 0x01, 0x06, 0x80, 0x01, 0x0E, 0xC0, 0x01, 0x1C, 0xE0, 0x00, 0xFC, 0xFF, 0x00, 0xF8, 0x7F, 0x00, 0xE0, 0x1F, 0x00, 0x00, 0x00, 0x00   @ p
	.byte 0x00, 0x00, 0x00, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0x00, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0x00, 0x1C, 0x00, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F, 0xFE, 0xFF, 0x7F @ H
	.byte 0x00, 0x00, 0x00, 0xFC, 0xFF, 0x7F, 0xFC, 0xFF, 0x7F, 0xFC, 0xFF, 0x7F, 0x00, 0x7C, 0x00, 0x00, 0xFE, 0x00, 0x00, 0xEF, 0x01, 0x80, 0xC7, 0x03, 0xC0, 0x83, 0x07, 0xE0, 0x01, 0x0F, 0xF0, 0x00, 0x1E, 0x78, 0x00, 0x3C, 0x3C, 0x00, 0x78, 0x1C, 0x00, 0x70, 0x0C, 0x00, 0x60	@ K
	.byte 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00	@空
	
