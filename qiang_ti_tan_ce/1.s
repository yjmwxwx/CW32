	@cw32f030c8t6
	@编译器ARM-NONE-EABI
	@墙体探测仪
	@yjmwxwx-2024-01-01
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
	ldr r1, = 0x7ff2e
	str r1, [r0, # 0x1c]
deng_hse:
	ldr r1, [r0, # 0x1c]
	lsls r1, r1, # 12
	bpl deng_hse
	ldr r1, = 0x5a5a0001
	str r1, [r0]	@HSE作为系统时钟	
	ldr r1, = 0x5a5a0182
	str r1, [r0, # 0x04]	@关HSI
	
__wai_she_shi_zhong:
	ldr r0, = 0x40010000
	@+0x30 0=DMA,1=FLASH,2=CRC,4=PA,5=PB,6=PC,9=PF
	ldr r1, = 0x273
	str r1, [r0, # 0x30]

	@+0X34 2=ADC,4=VC,7=ATIM,8=SPI1,9=UART1,10=GTIM3
	@11=GTIM4,12=BTIM,13=AWT

	ldr r1, = 0xd04
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
	ldr r1, = 0x7fc7
	str r1, [r0]            @0=输出，1=输入
	ldr r1, = 0x7f07
	str r1, [r0, # 0x1c]    @0=数字，1=模拟

	movs r1, # 0xc0
	str r1, [r0, # 0x10]	@上拉

	ldr r1, = 0x20000000
	str r1, [r0, # 0x14]    @复用8-15
	ldr r1, = 0x505000
	str r1, [r0, # 0x18]	@复用0-7

	
__pc_chu_shi_hua:	
	ldr r3, = 0xc000	
	ldr r0, = 0x48000800 @pc
	str r3, [r0, # 0x1c]
	str r3, [r0]


__GTIM3_chu_shi_hua:
	ldr r0, = 0x40014000
	ldr r1, = 239		@31999
	ldr r2, = 0x300
	str r1, [r0, r2]	@ARR
	ldr r2, = 0x320
	ldr r1, = 120		@15999
	str r1, [r0, r2]	@CCR1
	ldr r1, = 0x0e
	ldr r2, = 0x308
	str r1, [r0, r2]	@CCMR
	movs r1, # 0x01
	ldr r2, = 0x310
	str r1, [r0, r2]		@CR0

__GTIM4_chu_shi_hua:
	ldr r0, = 0x40014400
	ldr r1, = 23999           @31999
	ldr r2, = 0x300
	str r1, [r0, r2]        @ARR
	ldr r2, = 0x320
	ldr r1, = 12000           @15999
	str r1, [r0, r2]        @CCR1
	ldr r1, = 0x0e
	ldr r2, = 0x308
	str r1, [r0, r2]        @CCMR
	movs r1, # 0x01
	ldr r2, = 0x310
	str r1, [r0, r2]                @CR0
	

	

__adc_chu_shi_hua:
	ldr r0, = 0x40012400
	movs r1, # 0xc5 	@0xc1	@0xc5
	str r1, [r0]			@开ADC
	@	movs r1, # 0x01
	@	str r1, [r0, # 0x1c]		@ATIM触发ADC
__deng_chu_shi_hua:
	ldr r1, [r0, # 0x3c]
	lsls r1, r1, # 24
	bpl __deng_chu_shi_hua		@等ADC初始化完成
	movs r1, # 0x80
	str r1, [r0, # 0x04]		@开DMA和通道选择
	movs r1, # 0x01
	str r1, [r0, # 0x08]		@开ADC转换

	ldr r4, = 0xe000e010
	ldr r3, = 47999		@239999
	str r3, [r4, # 4]
	str r3, [r4, # 8]
	movs r3, # 0x07
	str r3, [r4]    @systick 开

__DMA_chu_shi_hua:
	ldr r0, = 0x40020000
	ldr r1, = 0x107d0	@0x103e8
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
	ldr r2, =  400
	str r2, [r0]
	movs r2, # 14
	str r2, [r1]

	ldr r0, = cossin
	ldr r1, = cos_sin_biao_100k
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
	
	ldr r0, = ling_min_du
	movs r2, # 100
	str r2, [r0]

	ldr r0, = 0xffffff
__xiangwei_xuanzhuan_yanshi:
	subs r0, r0, # 1
	bne __xiangwei_xuanzhuan_yanshi
	bl __lcd_qingping
	
	
        ldr r0, = shangbi_r
	ldr r1, = shangbi_i
	ldr r0, [r0]
	ldr r1, [r1]
	asrs r0, r0, # 2
	asrs r1, r1, # 2
	bl __atan2_ji_suan
	asrs r0, r0, # 15
	ldr r1, = -9000
	adds r0, r0, r1
	bl __jisuan_cos_sin
	ldr r2, = jiaodu_r
	ldr r3, = jiaodu_i
	str r0, [r2]
	str r1, [r3]
	


	
__anjian0:
	

	b ting
__anjian1:


	ldr r0, = shangbi_r
	ldr r1, = shangbi_i
	ldr r0, [r0]
	ldr r1, [r1]
	asrs r0, r0, # 2
	asrs r1, r1, # 2
	bl __atan2_ji_suan
	asrs r0, r0, # 15
	ldr r1, = -9000
	adds r0, r0, r1
	bl __jisuan_cos_sin
	ldr r2, = jiaodu_r
	ldr r3, = jiaodu_i
	str r0, [r2]
	str r1, [r3]
	bl __xiangwei_xuanzhuan
	
	ldr r2, = qingling_r
	ldr r3, = qingling_i
	str r0, [r2]
	str r1, [r3]
	b __ren_wu_diao_du
	
	ldr r0, = shangbi_r
	ldr r1, = shangbi_i
	ldr r0, [r0]
	ldr r1, [r1]
	ldr r2, = qingling_r
	ldr r3, = qingling_i
	str r0, [r2]
	str r1, [r3]
	b __ren_wu_diao_du
	
__anjian2:
	ldr r2, = qingling_r
	ldr r3, = qingling_i
	movs r0, # 0
	str r0, [r2]
	str r0, [r3]
	
	b __ren_wu_diao_du
__anjian3:
        bl __an_jian
	cmp r0, # 3
	beq __anjian3
	cmp r0, # 0
	bne __anjian3
	
	bl __lcd_qingping
__anjian_0:	
	ldr r0, = lingmindu
	movs r1, # 11           @显示几个字符
	ldr r2, = 0x0000         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	b __ren_wu_diao_du1
__anjian_1:
	bl __lingmin_du_yanshi
	ldr r2, = 50000
	ldr r1, = ling_min_du
	ldr r0, [r1]
	adds r0, r0, # 1
	str r0, [r1]
	cmp r0, r2
	bcc __anjian_1_fanhui
	movs r0, r2
	str r0, [r1]
__anjian_1_fanhui:
	bl __lingmin_du_xianshi
	b __ren_wu_diao_du1
__anjian_2:
	bl __lingmin_du_yanshi
        ldr r2, = 50000
	ldr r1, = ling_min_du
	ldr r0, [r1]
	subs r0, r0, # 1
	str r0, [r1]
	cmp r0, r2
	bcc __anjian_2_fanhui
	movs r0, # 0
	str r0, [r1]
__anjian_2_fanhui:
	bl __lingmin_du_xianshi
	b __ren_wu_diao_du1
	
__anjian_3:
	bl __lcd_qingping
__anjian__3:	
	ldr r0, = she_zhi_wan
	movs r1, # 11           @显示几个字符
	ldr r2, = 0x0000         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	
	bl __an_jian
	cmp r0, # 3
	beq __anjian__3
	cmp r0, # 0
	bne __anjian__3
	bl __lcd_qingping
	bl __lingmin_du_yanshi
	b __ren_wu_diao_du
	
__lingmin_du_yanshi:
	push {r0}
	ldr r0, = 0x3ffff
__lingmin_du_yanshi_xunhuan:
	subs r0, r0, # 1
	bne __lingmin_du_yanshi_xunhuan
	pop {r0}
	bx lr
__lingmin_du_xianshi:
	@入口R0
	push {r1-r3,lr}
	movs r1, # 6
	ldr r2, = asciibiao
	movs r3, # 0xff            @小数点位置
	bl _zhuanascii
	movs r0, # 6            @写几个字
	movs r1, # 48           @字库单字长度
	movs r2, # 3            @宽度
	ldr r3, = 0x1102              @lcd位置
	bl __xie_lcd_ascii
	pop {r1-r3,pc}



	
	
__ren_wu_diao_du:
	bl __an_jian
	lsls r0, r0, # 2
	ldr r1, = an_jian_biao
	ldr r2, [r1, r0]
	mov pc, r2

__ren_wu_diao_du1:
	bl __an_jian
	lsls r0, r0, # 2
	ldr r1, = an_jian_biao1
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
ting:

        ldr r0, = z_r
	ldr r1, = z_i
	ldr r0, [r0]
	ldr r1, [r1]

__zr_shi_bu_shi_fu:	
	movs r2, r0
	bpl __zi_shi_bu_shi_fu
	mvns r2, r2
	adds r2, r2, # 1
__zi_shi_bu_shi_fu:
	movs r3, r1
	bpl __bi_jiao_zr_zi_da_xiao
	mvns r3, r3
	adds r3, r3, # 1
__bi_jiao_zr_zi_da_xiao:	
	cmp r2, r3
        bhi __zr_xian_shi
        mov r0, r1
__zr_xian_shi:
	bl __xianshi_jindu_tiao



	
	bl __xiangwei_xuanzhuan
	ldr r4, = z_r
	ldr r5, = z_i
	ldr r2, = qingling_r
	ldr r3, = qingling_i
	ldr r6, [r2]
	ldr r7, [r3]
	subs r0, r0, r6
	subs r1, r1, r7
	str r0, [r4]
	str r1, [r5]
	
@	asrs r0, r0, # 2
@	asrs r1, r1, # 2
@	bl __atan2_ji_suan
@	asrs r0, r0, # 15
@	ldr r1, = z_jiao_du
@	str r0, [r1]
@	bl __xianshi_jiaodu
	
		
	ldr r0, = z_r
	ldr r4, [r0]
	movs r4, r4
	bpl __xianshi_zr
__z_r_shi_fu:
	mvns r4, r4
	adds r4, r4, # 1
	ldr r0, = _fu
	movs r1, # 1           @显示几个字符
	ldr r2, = 0x0003         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	b __xianshi_z_r
__xianshi_zr:
	ldr r0, = kong
	movs r1, # 1           @显示几个字符
	ldr r2, = 0x0003         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
__xianshi_z_r:
	mov r0, r4
	movs r1, # 6
	ldr r2, = asciibiao
	movs r3, # 0xff            @小数点位置
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
	ldr r0, = _fu
	movs r1, # 1           @显示几个字符
	ldr r2, = 0x0006         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	b __xianshi_z_i
__xianshi_zi:
	ldr r0, = kong
	movs r1, # 1           @显示几个字符
	ldr r2, = 0x0006         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
__xianshi_z_i:
	mov r0, r4
	movs r1, # 6
	ldr r2, = asciibiao
	movs r3, # 0xff            @小数点位置
	bl _zhuanascii
	movs r0, # 6            @写几个字
	movs r1, # 48           @字库单字长度
	movs r2, # 3            @宽度
	ldr r3, = 0x1105              @lcd位置
	bl __xie_lcd_ascii
	

        b __ren_wu_diao_du
	
	.ltorg





__xianshi_jindu_tiao:
	@入口R0 = 0-133
        push {r1-r4,lr}

	ldr r1, = ling_min_du
	ldr r1, [r1]
	asrs r1, r1, # 5
	asrs r0, r0, r1

	adds r0, r0, # 64
	mov r4, r0
	bl __xianshi_fudu
	
        ldr r0, = 0x40013000
        movs r1, # 0x00
        str r1, [r0, # 0x0c]            @A0=0
        ldr r2, = 0xff
        bl __lcd_yanshi
        movs r0, # 0x10
        bl __xie_spi1
        movs r0, # 0
        bl __xie_spi1
        movs r0, # 0xb0
        bl __xie_spi1
        movs r2, # 0xff
        bl __lcd_yanshi

        ldr r0, = 0x40013000
        movs r1, # 0x01
        str r1, [r0, # 0x0c]            @A0=1
        ldr r2, = 0xff
        bl __lcd_yanshi
        movs r1, # 64
@	movs r4, # 30
	cmp r4, r1
	bhi __jindu_tiao_zheng
	movs r1, # 0
__jindu_tiao_fu_heng_sao:
	cmp r1, r4
	bhi __jindu_tiao_liang
	movs r0, # 0
	b __xie_jin_du_tiao
__jindu_tiao_liang:	
	movs r0, # 0xff
__xie_jin_du_tiao:	
        bl __xie_spi1
        adds r1, r1, # 1
	cmp r1, # 64
        bne __jindu_tiao_fu_heng_sao
	
	movs r1, # 64
	movs r2, # 133
__jindu_tiao_zheng_qingling:	
	movs r0, # 0
	bl __xie_spi1
        adds r1, r1, # 1
	cmp r1, r2
        bne __jindu_tiao_zheng_qingling
	pop {r1-r4,pc}

__jindu_tiao_zheng:
        movs r1, # 64
__jindu_tiao_fu_qingling:
        movs r0, # 0
        bl __xie_spi1
	subs r1, r1, # 1
        cmp r1, r2
        bne __jindu_tiao_fu_qingling
	movs r1, # 64
	movs r2, # 133
__jindu_tiao_zheng_heng_sao:
        cmp r1, r4
        bls __jindu_tiao_liang1
        movs r0, # 0
        b __xie_jin_du_tiao1
__jindu_tiao_liang1:
        movs r0, # 0xff
__xie_jin_du_tiao1:
        bl __xie_spi1
        adds r1, r1, # 1
	cmp r1, r2
        bne __jindu_tiao_zheng_heng_sao

	pop {r1-r4,pc}





	

__laba:
	@入口R0
	push {r1-r2}
	ldr r1, = ling_min_du
	ldr r1, [r1]
	movs r0, r0
	bpl __laba_bijiao_daxiao
	mvns r0, r0
	adds r0, r0, # 1
__laba_bijiao_daxiao:
	cmp r0, r1
	bhi __laba_kai
__laba_guan:
	ldr r0, = 0x40014400
	movs r1, # 0    @0x0e
	ldr r2, = 0x308
	str r1, [r0, r2]        @CCMR
	b __laba_fanhui
__laba_kai:
	ldr r0, = 0x40014400
	movs r1, # 0x0e
	ldr r2, = 0x308
	str r1, [r0, r2]        @CCMR
__laba_fanhui:
	pop {r1-r2}
	bx lr
	


__ji_suan_fu_du:				    @ 计算幅度
	@ 入r0= 实部，r1= 虚部
	@ 出r0 = 幅度
	@ Mag ~=Alpha * max(|I|, |Q|) + Beta * min(|I|, |Q|)
	@ Alpha * Max + Beta * Min
	push {r1-r3,lr}
	movs r0, r0
	bpl _shibubushifushu
	mvns r0, r0                             @ 是负数转成正数
	adds r0, r0, # 1
_shibubushifushu:				                               @ 实部不是负数
	movs r1, r1
	bpl _xububushifushu
	mvns r1, r1                             @ 是负数转成正数
	adds r1, r1, # 1
_xububushifushu:				                                @ 虚部不是负数
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




__xianshi_fudu:
        push {r1-r4,lr}
        movs r4, r0
        bmi __fudu_shi_fu
__fudu_bushi_fu:
        ldr r0, = kong
        movs r1, # 1           @显示几个字符
        movs r2, # 0x01         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
        bl __xie_ascii
        b __xianshi_z_fudu
__fudu_shi_fu:
        ldr r0, = _fu
        movs r1, # 1           @显示几个字符
        movs r2, # 0x01         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
        bl __xie_ascii
        mvns r4, r4
        adds r4, r4, # 1
__xianshi_z_fudu:
        mov r0, r4
        movs r1, # 6    @转换几个字符
        ldr r2, = asciibiao
        movs r3, # 3             @小数点位置
        bl __zhuanascii
        ldr r0, = asciibiao
        movs r1, # 6           @显示几个字符
        ldr r2, = 0x1001         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
        bl __xie_ascii
        pop {r1-r4,pc}
        .ltorg


	

__xianshi_jiaodu:
	push {r0-r4,lr}
	ldr r0, = z_jiao_du
	ldr r0, [r0]
	movs r4, r0
	bmi __z_jiaodu_shi_fu
__z_jiaodu_bushi_fu:
	ldr r0, = kong
	movs r1, # 1           @显示几个字符
	movs r2, # 0x00         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	b __xianshi_z_jiaodu
__z_jiaodu_shi_fu:
	ldr r0, = _fu
	movs r1, # 1           @显示几个字符
	movs r2, # 0x00         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	mvns r4, r4
	adds r4, r4, # 1
__xianshi_z_jiaodu:
	mov r0, r4
	movs r1, # 6    @转换几个字符
	ldr r2, = asciibiao
	movs r3, # 3             @小数点位置
	bl __zhuanascii
	ldr r0, = asciibiao
	movs r1, # 6           @显示几个字符
	ldr r2, = 0x1000         @LCD位置lcd位置(高8位0-0x83,低8位0-7)
	bl __xie_ascii
	pop {r0-r4,pc}
	.ltorg
	


__xiangwei_xuanzhuan:
	push {r2-r7,lr}
	ldr r0, = jiaodu_r  @-3697
	ldr r1, = jiaodu_i  @32558
	ldr r0, [r0]
	ldr r1, [r1]
	ldr r2, = shangbi_r
	ldr r3, = shangbi_i
	ldr r4, [r2]
	ldr r5, [r3]
	mov r6, r0
	mov r7, r1
	muls r0, r0, r4 @X*COS
	muls r7, r7, r5 @Y*SIN
	muls r1, r1, r4 @X*SIN
	muls r6, r6, r5 @Y*COS
	adds r0, r0, r7
	subs r1, r6, r1
	asrs r0, r0, # 15
	asrs r1, r1, # 15
@	ldr r2, = z_r
@	ldr r3, = z_i
@	str r0, [r2]
@	str r1, [r3]
	pop {r2-r7,pc}

	
__jisuan_cos_sin:								@jd
	@入口R0=角度 （-18000到+18000）
	@出口R0=COS，R1=SIN
	push {r2-r7,lr}
	ldr r1, = 18000
	cmp r0, r1
	bls __xiaoyu_180
	adds r0, r0, r1
	movs r7, # 1
	b __js_cos_sin
__xiaoyu_180:
	movs r7, # 0
__js_cos_sin:
	ldr r1, = 9000
	ldr r2, = 51471
	movs r0, r0
	bpl __jisuan_jiaodu_bushi0
	mvns r0, r0
	adds r0, r0, # 1
	movs r4, # 1
	b __jiance_chao90
__jisuan_jiaodu_bushi0:
	movs r4, # 0
__jiance_chao90:
	cmp r0, r1
	bls __xiaoyu_90
	ldr r6, = 18000
	subs r0, r6, r0
	movs r6, # 1
	b __suan_cossin
__xiaoyu_90:
	movs r6, # 0
__suan_cossin:
	ldr r5, = 10000
	muls r0, r0, r5
	@bl _chufa
	bl _chufa
	muls r0, r0, r2
	mov r1, r5
	@bl _chufa
	bl _chufa
	cmp r4, # 1
	bne __suan_cos_sin1
	mvns r0, r0
	adds r0, r0, # 1
__suan_cos_sin1:
	bl __cordic_cos_sin
	cmp r6, # 1
	bne __cos_sin_fanhui
	mvns r0, r0
	adds r0, r0, # 1
__cos_sin_fanhui:
	cmp r7, # 1
	bne __cossin_fh
	mvns r0, r0
	mvns r1, r1
	adds r0, r0, # 1
	adds r1, r1, # 1
__cossin_fh:
	pop {r2-r7,pc}
__cordic_cos_sin:
	@入口R0
	@出口R0=COS，R1=SIN
	@ x= 0x4dba
	@ r1=x,r2=y,r0=z,r4=d,r5=k,r6=cordic_mabiao

	push {r2-r7,lr}
	mov r2, r8
	mov r3, r9
	push {r2-r3}
	movs r5, # 0
	mov r2, r5
	mov r4, r5
	ldr r1, = 0x4dba
cordicxunhuan:								 @ 循环
	asrs r4, r0, # 15
	@ x
	mov r7, r2
	asrs r2, r2, r5
	eors r2, r2, r4
	subs r2, r2, r4
	subs r3, r1, r2
	@ y
	mov r6, r1
	asrs r1, r1, r5
	eors r1, r1, r4
	subs r1, r1, r4
	adds r7, r7, r1
	@ z
	ldr r6, = cordic_yong_atan_biao
	lsls r2, r5, # 2
	ldr r1, [r6, r2]
	eors r1, r1, r4
	subs r1, r1, r4
	subs r0, r0, r1
	mov r1, r3
	mov r2, r7
	adds r5, # 1
	cmp r5, # 16
	bne cordicxunhuan
	mov r0, r3
	mov r1, r7
	pop {r2-r3}
	mov r8, r2
	mov r9, r3
	pop {r2-r7,pc}
__atan2_ji_suan:							@jt
	@入口R0=实部，R1=虚部，结果=R0
	push {r2-r7,lr}
	mov r2, r8
	push {r2}
	ldr r3, = cordic_yong_cos_sin
	movs r2, # 10
	muls r0, r0, r2
	muls r1, r1, r2
	movs r2, # 0
	mov r8, r2
	ldr r4, = 9000
	lsls r4, r4, # 15
__cordic_atan2_xun_huan:
__du_cos_sin:
	ldr r5, [r3]	@cos
	adds r3, r3, # 4
	mov r7, r5
	ldr r6, [r3]	@sin
	adds r3, r3, # 4
	mov r2, r6
	muls r5, r5, r0         @x*cos
	muls r2, r2, r0         @x*sin
	muls r6, r6, r1         @y*sin
	muls r7, r7, r1         @y*cos
	movs r1, r1
	bpl __ni_shi_zhen_zhuan
__shun_shi_zhen_zhuan:
	subs r5, r5, r6
	adds r7, r7, r2
	mov r6, r8
	adds r6, r6, r4
	mov r8, r6
	b __xuan_zhuan_wan
__ni_shi_zhen_zhuan:
	adds r5, r5, r6
	subs r7, r7, r2
	mov r6, r8
	subs r6, r6, r4
	mov r8, r6
__xuan_zhuan_wan:
	ldr r6, = cordic_yong_cos_sin
	movs r2, # 32
	lsls r2, r2, # 2
	adds r6, r6, r2
	asrs r5, r5, # 14
	asrs r7, r7, # 14
	mov r0, r5
	mov r1, r7
	lsrs r4, r4, # 1	@旋转
	cmp r3,	r6
	bne __cordic_atan2_xun_huan
	mov r0, r8
	mvns r0, r0
	adds r0, r0, # 1
	@	asrs r0, r0, # 15      @除32768等于角度
	pop {r2}
	mov r8, r2
	pop {r2-r7,pc}
	.ltorg









	
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
	@yjm1
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

	@yjm2
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

	@yjm3

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

	@yjm4
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

	@yjm5
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

	@yjm6
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

	@yjm7
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

	@yjm8
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

	@yjm9
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

	@yjm10
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
	@yjm11
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
	@yjm12
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
	@	bkpt # 4
	mov r0, r11
	movs r1, # 125
	lsls r1, r1, # 6
	subs r0, r0, r1
	mov r11, r0
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

	@yjm13
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

	@yjm14
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

	@yjm15
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

	@yjm16
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
	@yjm17
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

	@yjm18
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

	@yjm19
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
	@yjm20
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

	@yjm21
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

	@yjm22
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

	@yjm23
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

	@yjm24

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










	ldr r0, = 0x200010a0
	cmp r10, r0
	beq __dft_fanhuile
	ldr r0, = __dft_xunhuan
	adds r0, r0, # 1
	mov pc, r0
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








	

	
	
_nmi:
_Hard_Fault:
_svc_handler:
_pendsv_handler:
aaa:
	bx lr
	
_systickzhongduan:
	push {r0-r4,lr}

	ldr r0, = 0x40020000
	ldr r1, = 0x107d0	@ 0x103e8
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


	
__systick_fanhui:
	ldr r0, = z_r
	ldr r1, = z_i
	ldr r0, [r0]
	ldr r1, [r1]
	bl __ji_suan_fu_du
	bl __laba
	
	ldr r0, = 0xe0000d04
	ldr r1, = 0x02000000
	str r1, [r0]                 @ 清除SYSTICK中断
	pop {r0-r4,pc}



	.section .data
	.equ zhanding,			0x200000fc
	.equ dianyabiao,		0x20000100
	.equ lvboqizhizhen,             0x200010b0
	.equ lvboqihuanchong,           0x200010b8
	.equ lvboqizhizhen1,            0x20001800
	.equ lvboqihuanchong1,          0x20001808

	.equ jiaodu_r,			0x20001fa4
	.equ jiaodu_i,			0x20001fa8
	.equ ling_min_du,		0x20001fac
	.equ qingling_r,		0x20001fb0
	.equ qingling_i,		0x20001fb4
	.equ z_r,			0x20001fb8
	.equ z_i,			0x20001fbc
	.equ z_jiao_du,			0x20001fc0
	.equ shangbi_r,			0x20001fc4
	.equ shangbi_i,			0x20001fc8
	.equ shangbi_rr,		0x20001fcc
	.equ shangbi_ii,		0x20001fd0
	.equ lvbo_changdu,		0x20001fd4
	.equ lvbo_youyi,		0x20001fd8
	.equ cossin,			0x20001fdc 
	.equ asciibiao,			0x20001fe0

yjmwxwx:
	.ascii "yjmwxwx 2024 01 01"

she_zhi_wan:
	.ascii "she zhi wan"
lingmindu:
	.ascii "ling min du"
kong:
	.int 0x20202020
_fu:
	.ascii "-"


	.align 4
an_jian_biao:
	.word __anjian0	+1
	.word __anjian1	+1
	.word __anjian2	+1
	.word __anjian3	+1

an_jian_biao1:
	.word __anjian_0 +1
	.word __anjian_1 +1
	.word __anjian_2 +1
	.word __anjian_3 +1
	

	

cordic_yong_atan_biao:				@弧度
	.int 0x00006487,0x00003B58,0x00001F5B,0x00000FEA,0x000007FD,0x000003FF,0x000001FF,0x000000FF,0x0000007F,0x0000003F,0x0000001F,0x0000000F,0x00000007,0x00000003,0x00000001,0x00000000
cordic_yong_cos_sin:
	.int 0x0000,0x4000,0x2D41,0x2D41,0x3B20,0x187D,0x3EC5,0x0C7C,0x3FB1,0x0645,0x3FEC,0x0323,0x3FFB,0x0192,0x3FFE,0x00C9,0x3FFF,0x0064,0x3FFF,0x0032,0x3FFF,0x0019,0x3FFF,0x000C,0x3FFF,0x0006,0x3FFF,0x0003,0x3FFF,0x0001,0x3FFF,0x0000


	
	.align 4
cos_sin_biao_100k:
	.int 0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BB,0x678E,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD872,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0001,0xFFFF9872,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BB,0x678D,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD874,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD872,0x79BC,0x278E,0x79BB,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0001,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BB,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C3,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8645,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BB,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278E,0x79BB,0x678D,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278E,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD872,0x79BC,0x278E,0x79BB,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD874,0x79BC,0x278F,0x79BB,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x278E,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9873,0xFFFFB4C3,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD872,0x79BC,0x278D,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9874,0x4B3D,0xFFFFD874,0x79BC,0x278E,0x79BB,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8645,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3B,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0001,0xFFFF9872,0x4B3C,0xFFFFD872,0x79BC,0x278C,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3B,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278C,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278E,0x79BB,0x678E,0x4B3B,0x8000,0xFFFFFFFF,0x678C,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C3,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x278E,0x79BB,0x678E,0x4B3C,0x8000,0x0000,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0001,0xFFFF9873,0x4B3C,0xFFFFD873,0x79BC,0x278E,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C5,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3D,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0xFFFFFFFF,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD872,0x79BC,0x278E,0x79BB,0x678E,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C5,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9874,0x4B3D,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0xFFFFFFFE,0x678C,0xFFFFB4C2,0x278E,0xFFFF8644,0xFFFFD874,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3B,0xFFFFD874,0x79BC,0x278E,0x79BB,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678E,0xFFFFB4C5,0x278D,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0002,0xFFFF9874,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8645,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0xFFFFFFFF,0xFFFF9873,0x4B3C,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD874,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD874,0x79BC,0x278F,0x79BB,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0002,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C3,0xFFFF8000,0xFFFFFFFF,0xFFFF9873,0x4B3C,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0001,0xFFFF9874,0x4B3E,0xFFFFD874,0x79BC,0x278E,0x79BB,0x678D,0x4B3C,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0000,0xFFFF9872,0x4B3B,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C3,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD873,0x79BC,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9874,0x4B3E,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678F,0x4B3A,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3B,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3D,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD875,0x79BD,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678C,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C3,0xFFFF8000,0x0000,0xFFFF9874,0x4B3E,0xFFFFD874,0x79BC,0x2790,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678E,0xFFFFB4C5,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x278C,0x79BC,0x678E,0x4B3C,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3B,0xFFFFD873,0x79BC,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0xFFFFFFFE,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9874,0x4B3D,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0001,0x678D,0xFFFFB4C4,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0001,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x278C,0x79BC,0x678D,0x4B3C,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278F,0x79BB,0x678F,0x4B3A,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3D,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BB,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0xFFFFFFFF,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278E,0x79BB,0x678F,0x4B3A,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278B,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3D,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278F,0xFFFF8645,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0xFFFFFFFE,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0001,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x278E,0x79BB,0x678F,0x4B3A,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9874,0xFFFFB4C3,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678E,0xFFFFB4C5,0x278D,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9874,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3D,0x8000,0x0000,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD870,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD874,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278F,0x79BB,0x678E,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C5,0x278D,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0002,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678C,0xFFFFB4C3,0x278B,0xFFFF8643,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9874,0x4B3E,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0001,0xFFFF9873,0x4B3C,0xFFFFD874,0x79BC,0x278E,0x79BB,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278B,0xFFFF8643,0xFFFFD871,0xFFFF8645,0xFFFF9873,0xFFFFB4C3,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8645,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0xFFFFFFFF,0xFFFF9874,0x4B3E,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD870,0xFFFF8645,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD875,0x79BC,0x278F,0x79BB,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD871,0x79BB,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C3,0xFFFF8000,0x0000,0xFFFF9874,0x4B3E,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0001,0xFFFF9874,0x4B3E,0xFFFFD874,0x79BC,0x278E,0x79BB,0x678E,0x4B3C,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3B,0xFFFFD873,0x79BC,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C3,0xFFFF8000,0x0000,0xFFFF9874,0x4B3D,0xFFFFD874,0x79BC,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0003,0xFFFF9874,0x4B3E,0xFFFFD872,0x79BC,0x278C,0x79BC,0x678D,0x4B3C,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278E,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278F,0x79BB,0x678E,0x4B3C,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3D,0x8000,0x0001,0x678E,0xFFFFB4C4,0x278E,0xFFFF8645,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C4,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678F,0x4B3A,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9875,0x4B3F,0xFFFFD875,0x79BC,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0xFFFFFFFE,0x678C,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0002,0xFFFF9874,0x4B3D,0xFFFFD876,0x79BD,0x2790,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678C,0xFFFFB4C2,0x278A,0xFFFF8643,0xFFFFD870,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0003,0xFFFF9874,0x4B3E,0xFFFFD872,0x79BC,0x278E,0x79BB,0x678D,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C5,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9874,0xFFFFB4C3,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678E,0xFFFFB4C5,0x278F,0xFFFF8645,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3D,0x8000,0x0000,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x278E,0x79BC,0x678E,0x4B3B,0x8000,0xFFFFFFFF,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD874,0x79BC,0x2790,0x79BB,0x678F,0x4B3A,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278B,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0002,0xFFFF9875,0x4B3F,0xFFFFD875,0x79BD,0x278F,0x79BB,0x678F,0x4B3A,0x8000,0xFFFFFFFE,0x678C,0xFFFFB4C3,0x278E,0xFFFF8645,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C3,0xFFFF8000,0xFFFFFFFF,0xFFFF9871,0x4B3A,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD874,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x278E,0x79BB,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278B,0xFFFF8643,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9874,0x4B3D,0xFFFFD873,0x79BC,0x278E,0x79BC,0x678F,0x4B39,0x8000,0xFFFFFFFE,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD870,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD874,0x79BC,0x2790,0x79BB,0x678F,0x4B3A,0x8000,0xFFFFFFFD,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0003,0xFFFF9874,0x4B3E,0xFFFFD871,0x79BB,0x278D,0x79BC,0x678D,0x4B3D,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9873,0xFFFFB4C3,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD871,0x79BB,0x278D,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0xFFFFFFFF,0xFFFF9874,0x4B3E,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0001,0xFFFF9873,0x4B3C,0xFFFFD874,0x79BC,0x278E,0x79BB,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278B,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0xFFFFFFFE,0x678B,0xFFFFB4C1,0x278B,0xFFFF8643,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0002,0xFFFF9874,0x4B3D,0xFFFFD874,0x79BC,0x278F,0x79BB,0x678F,0x4B39,0x8000,0xFFFFFFFE,0x678C,0xFFFFB4C2,0x278A,0xFFFF8643,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x278C,0x79BC,0x678C,0x4B3E,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278E,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3B,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678E,0x4B3C,0x8000,0x0000,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0002,0xFFFF9874,0x4B3E,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678E,0x4B3B,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C4,0x278A,0xFFFF8643,0xFFFFD870,0xFFFF8645,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0001,0xFFFF9874,0x4B3E,0xFFFFD874,0x79BC,0x278E,0x79BB,0x678E,0x4B3C,0x8000,0xFFFFFFFF,0x678C,0xFFFFB4C2,0x278B,0xFFFF8644,0xFFFFD86F,0xFFFF8645,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD875,0x79BC,0x278D,0x79BC,0x678D,0x4B3D,0x8000,0x0001,0x678E,0xFFFFB4C4,0x278F,0xFFFF8645,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BB,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0001,0x678D,0xFFFFB4C4,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0001,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x278C,0x79BC,0x678F,0x4B3A,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9873,0x4B3D,0xFFFFD875,0x79BC,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0xFFFFFFFE,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0002,0xFFFF9874,0x4B3D,0xFFFFD875,0x79BD,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD870,0xFFFF8645,0xFFFF9871,0xFFFFB4C7,0xFFFF8000,0x0002,0xFFFF9874,0x4B3E,0xFFFFD874,0x79BC,0x2790,0x79BB,0x678E,0x4B3B,0x8000,0xFFFFFFFD,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD876,0xFFFF8643,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3B,0xFFFFD875,0x79BC,0x278F,0x79BB,0x678E,0x4B3C,0x8000,0x0000,0x678E,0xFFFFB4C5,0x278F,0xFFFF8645,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9872,0x4B3B,0xFFFFD871,0x79BB,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278B,0xFFFF8643,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BB,0x278C,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD870,0xFFFF8645,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0001,0xFFFF9873,0x4B3C,0xFFFFD872,0x79BC,0x2790,0x79BB,0x678C,0x4B3D,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD870,0xFFFF8645,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD877,0x79BD,0x278D,0x79BC,0x678F,0x4B3A,0x8000,0xFFFFFFFE,0x678D,0xFFFFB4C3,0x2789,0xFFFF8643,0xFFFFD873,0xFFFF8644,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0002,0xFFFF9874,0x4B3D,0xFFFFD877,0x79BD,0x2791,0x79BA,0x678D,0x4B3D,0x8000,0x0001,0x678F,0xFFFFB4C6,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0xFFFFFFFF,0xFFFF9874,0x4B3E,0xFFFFD870,0x79BB,0x278E,0x79BB,0x678D,0x4B3C,0x8000,0x0000,0x678C,0xFFFFB4C2,0x278F,0xFFFF8645,0xFFFFD872,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3B,0xFFFFD875,0x79BC,0x278F,0x79BB,0x678E,0x4B3C,0x8000,0xFFFFFFFD,0x678E,0xFFFFB4C5,0x278B,0xFFFF8644,0xFFFFD875,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD875,0x79BD,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678B,0xFFFFB4C1,0x278E,0xFFFF8645,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9875,0x4B3F,0xFFFFD872,0x79BB,0x2790,0x79BB,0x678E,0x4B3B,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C4,0x278A,0xFFFF8643,0xFFFFD870,0xFFFF8645,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0001,0xFFFF9873,0x4B3C,0xFFFFD876,0x79BD,0x278C,0x79BC,0x678F,0x4B3A,0x8000,0xFFFFFFFB,0x678D,0xFFFFB4C3,0x2789,0xFFFF8643,0xFFFFD86F,0xFFFF8645,0xFFFF9873,0xFFFFB4C3,0xFFFF8000,0x0001,0xFFFF9871,0x4B3A,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3D,0x8000,0x0001,0x678D,0xFFFFB4C3,0x2791,0xFFFF8645,0xFFFFD873,0xFFFF8644,0xFFFF9871,0xFFFFB4C7,0xFFFF8000,0xFFFFFFFF,0xFFFF9874,0x4B3D,0xFFFFD870,0x79BB,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0001,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0003,0xFFFF9872,0x4B3B,0xFFFFD874,0x79BC,0x2792,0x79BA,0x678D,0x4B3C,0x8000,0xFFFFFFFD,0x678E,0xFFFFB4C5,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9874,0x4B3E,0xFFFFD875,0x79BC,0x278F,0x79BB,0x6790,0x4B38,0x8000,0x0000,0x678B,0xFFFFB4C1,0x278F,0xFFFF8645,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9875,0x4B3F,0xFFFFD875,0x79BD,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0xFFFFFFFC,0x678E,0xFFFFB4C4,0x278A,0xFFFF8643,0xFFFFD870,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0004,0xFFFF9873,0x4B3C,0xFFFFD876,0x79BD,0x2790,0x79BB,0x678C,0x4B3E,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD874,0xFFFF8644,0xFFFF9874,0xFFFFB4C2,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678F,0x4B3A,0x8000,0x0002,0x678D,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD873,0xFFFF8644,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0xFFFFFFFE,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678D,0x4B3D,0x8000,0xFFFFFFFE,0x678C,0xFFFFB4C3,0x278D,0xFFFF8644,0xFFFFD86F,0xFFFF8646,0xFFFF9873,0xFFFFB4C3,0xFFFF8000,0x0002,0xFFFF9871,0x4B3A,0xFFFFD874,0x79BC,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0xFFFFFFFE,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD872,0xFFFF8644,0xFFFF9870,0xFFFFB4C7,0xFFFF8000,0x0000,0xFFFF9874,0x4B3E,0xFFFFD874,0x79BC,0x278E,0x79BB,0x6790,0x4B39,0x8000,0x0000,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0003,0xFFFF9874,0x4B3E,0xFFFFD875,0x79BC,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0xFFFFFFFC,0x678E,0xFFFFB4C5,0x278B,0xFFFF8643,0xFFFFD86D,0xFFFF8646,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD872,0x79BB,0x278F,0x79BB,0x678C,0x4B3E,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8645,0xFFFFD874,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0xFFFFFFFD,0xFFFF9873,0x4B3C,0xFFFFD876,0x79BD,0x278C,0x79BC,0x678E,0x4B3A,0x8000,0x0002,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD874,0xFFFF8644,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x2790,0x79BB,0x678C,0x4B3D,0x8000,0xFFFFFFFF,0x678A,0xFFFFB4C0,0x278D,0xFFFF8644,0xFFFFD86F,0xFFFF8645,0xFFFF9873,0xFFFFB4C3,0xFFFF8000,0x0002,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x278D,0x79BC,0x678F,0x4B3A,0x8000,0xFFFFFFFE,0x678C,0xFFFFB4C3,0x2789,0xFFFF8643,0xFFFFD873,0xFFFF8644,0xFFFF9871,0xFFFFB4C7,0xFFFF8000,0xFFFFFFFF,0xFFFF9874,0x4B3E,0xFFFFD874,0x79BC,0x278E,0x79BC,0x6790,0x4B39,0x8000,0xFFFFFFFE,0x678C,0xFFFFB4C2,0x278C,0xFFFF8644,0xFFFFD86E,0xFFFF8646,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0003,0xFFFF9874,0x4B3E,0xFFFFD874,0x79BC,0x2792,0x79BA,0x678E,0x4B3C,0x8000,0x0000,0x678C,0xFFFFB4C2,0x278F,0xFFFF8645,0xFFFFD871,0xFFFF8645,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3B,0xFFFFD871,0x79BB,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678E,0xFFFFB4C4,0x278B,0xFFFF8643,0xFFFFD875,0xFFFF8644,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9872,0x4B3C,0xFFFFD875,0x79BD,0x278C,0x79BC,0x678E,0x4B3B,0x8000,0x0000,0x678D,0xFFFFB4C4,0x278E,0xFFFF8645,0xFFFFD870,0xFFFF8645,0xFFFF9872,0xFFFFB4C5,0xFFFF8000,0x0000,0xFFFF9875,0x4B3F,0xFFFFD872,0x79BC,0x2790,0x79BB,0x678C,0x4B3E,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C4,0x278E,0xFFFF8644,0xFFFFD870,0xFFFF8645,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0001,0xFFFF9873,0x4B3D,0xFFFFD877,0x79BD,0x278D,0x79BC,0x678F,0x4B3A,0x8000,0xFFFFFFFF,0x678D,0xFFFFB4C3,0x2789,0xFFFF8643,0xFFFFD873,0xFFFF8644,0xFFFF9871,0xFFFFB4C6,0xFFFF8000,0x0002,0xFFFF9873,0x4B3D,0xFFFFD873,0x79BC,0x2791,0x79BB,0x678F,0x4B39,0x8000,0xFFFFFFFE,0x678C,0xFFFFB4C3,0x278C,0xFFFF8644,0xFFFFD86F,0xFFFF8646,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0xFFFFFFFF,0xFFFF9874,0x4B3E,0xFFFFD870,0x79BB,0x278E,0x79BC,0x678D,0x4B3C,0x8000,0x0000,0x678C,0xFFFFB4C2,0x2790,0xFFFF8645,0xFFFFD872,0xFFFF8645,0xFFFF9873,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3B,0xFFFFD874,0x79BC,0x278B,0x79BD,0x678E,0x4B3C,0x8000,0xFFFFFFFD,0x678E,0xFFFFB4C5,0x278B,0xFFFF8644,0xFFFFD875,0xFFFF8643,0xFFFF9872,0xFFFFB4C4,0xFFFF8000,0x0000,0xFFFF9872,0x4B3B,0xFFFFD875,0x79BC,0x278F,0x79BB,0x678E,0x4B3B,0x8000,0x0000,0x678B,0xFFFFB4C1,0x278F,0xFFFF8645,0xFFFFD871,0xFFFF8645,0xFFFF9870,0xFFFFB4C8,0xFFFF8000,0x0000,0xFFFF9875,0x4B3F,0xFFFFD872,0x79BB,0x2790,0x79BB,0x678E,0x4B3B

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
	
