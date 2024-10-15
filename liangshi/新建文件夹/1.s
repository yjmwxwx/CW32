	@@ 单片机stm32f030f4p6
	@@ 土壤湿度传感器							
	@作者：yjmwxwx
	@时间：2020-06-21
	@编译器：ARM-NONE-EABI
	.thumb
	.syntax unified
	.section .data
	.align 4
xuanzhuanyinzi:
	.int 0x8000,0x0000,0x7E9D,0xFFFFED38,0x7A7D,0xFFFFDAD8,0x73B5,0xFFFFC946,0x6A6D,0xFFFFB8E4,0x5ED7,0xFFFFAA0B,0x5133,0xFFFF9D0E,0x41CE,0xFFFF9236,0x30FB,0xFFFF89BF,0x1F19,0xFFFF83D7,0x0C8B,0xFFFF809E,0xFFFFF9B9,0xFFFF8028,0xFFFFE708,0xFFFF8276,0xFFFFD4E1,0xFFFF877C,0xFFFFC3AA,0xFFFF8F1E,0xFFFFB3C1,0xFFFF9931,0xFFFFA57E,0xFFFFA57E,0xFFFF9931,0xFFFFB3C1,0xFFFF8F1E,0xFFFFC3AA,0xFFFF877C,0xFFFFD4E1,0xFFFF8276,0xFFFFE708,0xFFFF8028,0xFFFFF9B9,0xFFFF809E,0x0C8B,0xFFFF83D7,0x1F19,0xFFFF89BF,0x30FB,0xFFFF9236,0x41CE,0xFFFF9D0E,0x5133,0xFFFFAA0B,0x5ED7,0xFFFFB8E4,0x6A6D,0xFFFFC946,0x73B5,0xFFFFDAD8,0x7A7D,0xFFFFED38,0x7E9D,0x0000,0x8000,0x12C8,0x7E9D,0x2528,0x7A7D,0x36BA,0x73B5,0x471C,0x6A6D,0x55F5,0x5ED7,0x62F1,0x5133,0x6DCA,0x41CE,0x7641,0x30FB,0x7C29,0x1F1A,0x7F62,0x0C8B,0x7FD8,0xFFFFF9B9,0x7D8A,0xFFFFE708,0x7884,0xFFFFD4E1,0x70E2,0xFFFFC3AA,0x66CF,0xFFFFB3C1,0x5A82,0xFFFFA57E,0x4C3F,0xFFFF9931,0x3C56,0xFFFF8F1E,0x2B1F,0xFFFF877C,0x18F8,0xFFFF8276,0x0647,0xFFFF8028,0xFFFFF375,0xFFFF809E,0xFFFFE0E7,0xFFFF83D7,0xFFFFCF05,0xFFFF89BF,0xFFFFBE32,0xFFFF9236,0xFFFFAECD,0xFFFF9D0E,0xFFFFA129,0xFFFFAA0B,0xFFFF9593,0xFFFFB8E4,0xFFFF8C4B,0xFFFFC946,0xFFFF8583,0xFFFFDAD8,0xFFFF8163,0xFFFFED38,0xFFFF8000,0x0000,0xFFFF8163,0x12C7,0xFFFF8583,0x2527,0xFFFF8C4B,0x36BA,0xFFFF9593,0x471C,0xFFFFA129,0x55F5,0xFFFFAECD,0x62F1,0xFFFFBE32,0x6DCA,0xFFFFCF05,0x7641,0xFFFFE0E6,0x7C29,0xFFFFF375,0x7F62,0x0647,0x7FD8,0x18F8,0x7D8A,0x2B1F,0x7884,0x3C56,0x70E2,0x4C3F,0x66CF,0x5A82,0x5A82,0x66CF,0x4C3F,0x70E2,0x3C56,0x7884,0x2B1F,0x7D8A,0x18F8,0x7FD8,0x0647,0x7F62,0xFFFFF375,0x7C29,0xFFFFE0E7,0x7641,0xFFFFCF05,0x6DCA,0xFFFFBE32,0x62F2,0xFFFFAECD,0x55F5,0xFFFFA129,0x471D,0xFFFF9593,0x36BA,0xFFFF8C4B,0x2528,0xFFFF8584,0x12C8,0xFFFF8163,0x0000,0xFFFF8000,0xFFFFED39,0xFFFF8163,0xFFFFDAD9,0xFFFF8583,0xFFFFC946,0xFFFF8C4B,0xFFFFB8E4,0xFFFF9593,0xFFFFAA0B,0xFFFFA129,0xFFFF9D0F,0xFFFFAECD,0xFFFF9236,0xFFFFBE32,0xFFFF89BF,0xFFFFCF05,0xFFFF83D7,0xFFFFE0E6,0xFFFF809E,0xFFFFF375,0xFFFF8028,0x0647,0xFFFF8276,0x18F8,0xFFFF877C,0x2B1F,0xFFFF8F1E,0x3C56,0xFFFF9931,0x4C3F,0xFFFFA57E,0x5A82,0xFFFFB3C1,0x66CF,0xFFFFC3AA,0x70E2,0xFFFFD4E1,0x7884,0xFFFFE708,0x7D8A,0xFFFFF9B9,0x7FD8,0x0C8B,0x7F62,0x1F19,0x7C2A,0x30FB,0x7641,0x41CE,0x6DCA,0x5133,0x62F2,0x5ED7,0x55F5,0x6A6D,0x471D,0x73B5,0x36BA,0x7A7C,0x2528,0x7E9D,0x12C8
	.align 4
cordic_yong_cos_sin:
	.int 0x0000,0x4000,0x2D41,0x2D41,0x3B20,0x187D,0x3EC5,0x0C7C,0x3FB1,0x0645,0x3FEC,0x0323,0x3FFB,0x0192,0x3FFE,0x00C9,0x3FFF,0x0064,0x3FFF,0x0032,0x3FFF,0x0019,0x3FFF,0x000C,0x3FFF,0x0006,0x3FFF,0x0003,0x3FFF,0x0001,0x3FFF,0x0000
	.align 4
i2c_shuju:
	.byte 0xa0,0x00,0xf1,0xf2,0xf3,0xf4,0xf5,0xf6,0xf7,0xf8,0xf9,0xfa,0xfb,0xfc,0xfd
si5351:	@0=148999000,1=149000000,2=28000000
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
yjmwxwx:
	.ascii "yjmwxwx-20200413"
	.align 4
kong:
	.int 0x20202020
_fu:
	.ascii "-"
ou:
        .int    0xf4
	
	.equ STACKINIT,        	        0x20001000
	.equ asciimabiao,		0x20000000
	.equ fanshe_r,			0x200000dc
	.equ fanshe_i,			0x200000e0
	.equ rushe_r,			0x200000e4
	.equ rushe_i,			0x200000e8
	.equ liangcheng,		0x200000ec
	.equ fuhao,			0x200000f0
	.equ dmawan,			0x200000f4
	.equ jishu2,			0x200000f8
	.equ jishu,			0x200000fc
	.equ dianzu,			0x20000100
	.equ p_shibu,			0x20000104
	.equ swr_shibu,			0x20000108
	.equ bingliandianzu,		0x2000010c
	.equ jiedianchangshushibu,	0x20000110
	.equ diankang,			0x20000114
	.equ p_xubu,			0x20000118
	.equ swr_xubu,			0x2000011c
	.equ bingliandiankang,		0x20000120
	.equ jiedianchangshuxubu,	0x20000124
	.equ fan_she_shi_bu,		0x20000128
	.equ fan_she_xu_bu,		0x20000130
	.equ ru_she_shi_bu,		0x20000138
	.equ ru_she_xu_bu,		0x2000013c
        .equ zukangqiehuan,             0x20000140
        .equ caidan,                    0x20000144
        .equ an_jian_yan_shi,           0x20000148
        .equ tou_fan_qie_huan,          0x2000014c
	.equ dianrongzhi,		0x20000150
	.equ jiaodu,			0x20000154
	.equ anjian,			0x20000158
        .equ dianyabiaozhizhen,         0x200001f8
        .equ dianyabiaoman,             0x200001fc
	.equ dianyabiao,		0x20000200
        .equ lvboqizhizhen,             0x20000a00
        .equ lvboqihuanchong,           0x20000a04
        .equ lvboqizhizhen1,            0x20000b08
        .equ lvboqihuanchong1,          0x20000b0c
        .equ lvboqizhizhen2,             0x20000c20
        .equ lvboqihuanchong2,           0x20000c24
	.equ lvboqizhizhen3,            0x20000d30
        .equ lvboqihuanchong3,          0x20000d34
	.section .text
vectors:
	.word STACKINIT
	.word _start + 1
	.word _nmi_handler + 1
	.word _hard_fault  + 1
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
	.word _systickzhongduan +1           @ 15
	.word aaa +1     @ _wwdg +1          @ 0
	.word aaa +1     @_pvd +1            @ 1
	.word aaa +1     @_rtc +1            @ 2
	.word aaa +1     @_flash +1          @ 3
	.word aaa +1	@ _rcc + 1           @ 4
	.word aaa +1      @_exti0_1  +1      @ 5
	.word aaa +1      @ _exti2_3 +1      @ 6
	.word aaa +1       @_exti4_15 +1     @ 7
	.word aaa +1                         @ 8
	.word __dma_wan  +1		     @ 9
	.word aaa +1    @_dma1_2_3 +1        @ 10
	.word aaa +1       @_dma1_4_5 +1     @ 11
	.word aaa +1	 @_adc1 +1           @ 12
	.word aaa +1       @_tim1_brk_up +1  @ 13
	.word aaa +1        @ _tim1_cc +1    @ 14
	.word aaa +1         @_tim2 +1       @ 15
	.word aaa +1          @_tim3 +1      @ 16
	.word aaa +1                         @ 17
	.word aaa +1		             @ 18
	.word aaa +1	@_tim14 +1           @ 19
	.word aaa +1                         @ 20
	.word aaa +1         @_tim16 +1      @ 21
	.word aaa +1         @_tim17 +1      @ 22
	.word aaa +1          @_i2c   +1     @ 23
	.word aaa +1                         @ 24
	.word aaa +1           @_spi   +1    @ 25
	.word aaa +1                         @ 26
	.word aaa +1         @_usart1 +1     @ 27
	.align 2
_start:
shizhong:
        ldr r2, = 0x40022000   @FLASH访问控制
        movs r1, # 0x32
        str r1, [r2]           @FLASH缓冲 缓冲开启
        ldr r0, = 0x40021000 @ rcc
	ldr r1, = 0x50001
        str r1, [r0]
dengpllguan:
        ldr r1, [r0]
	lsls r1, r1, # 6
	bmi dengpllguan
	ldr r1, = 0x300002
	mov r0, r0
	str r1, [r0, # 0x04]
	mov r0, r0
	ldr r1, = 0x1050001
	mov r0, r0
	str r1, [r0]

dengpll:
        ldr r1, [r0]
	lsls r1, # 6
	bpl dengpll


	ldr r1, = 100
	str r1, [r0, # 0x30]
_waisheshizhong:                         @ 外设时钟
        @+0x14=RCC_AHBENR
	@ 0=DMA @ 2=SRAM @ 4=FLITF@ 6=CRC @ 17=PA @ 18=PB @ 19=PC @ 20=PD @ 22=PF
	ldr r0, = 0x40021000
	ldr r1, = 0x60001
        str r1, [r0, # 0x14]

        @+0x18外设时钟使能寄存器 (RCC_APB2ENR)
        @0=SYSCFG @5=USART6EN @9=ADC @11=TIM1 @12=SPI1 @14=USART1 @16=TIM15 @17=TIM16 @18=TIM17 @22=DBGMCU
        ldr r1, = 0xa00
	str r1, [r0, # 0x18]
	@+0X1C=RCC_APB1ENR
	@ 1=TIM3 @ 4=TIM6 @ 5=TIM7 @ 8=TIM14 @ 11=WWDG @ 14=SPI @ 17=USRT2 @ 18=USART3 @ 20=USART5 @ 21=I2C1
	@ 22=I2C2 @ 23=USB @ 28=PWR
        ldr r2, = 0x902
        str r2, [r0, # 0x1c]

_neicunqingling:
	ldr r0, = 0x20000000
	movs r1, # 0
	ldr r3, = 0x1000
_neicunqinglingxunhuan:
	subs r3, # 4
	str r1, [r0, r3]
	bne _neicunqinglingxunhuan
_waishezhongduan:				@外设中断
	@0xE000E100    0-31  写1开，写0没效
	@0XE000E180    0-31 写1关，写0没效
	@0XE000E200    0-31 挂起，写0没效
	@0XE000E280    0-31 清除， 写0没效
	ldr r0, =  0xe000e100
	ldr r1, = 0x200 @0x10200  @ 0x10000
	str r1, [r0]
@_kanmengou:
@	ldr r0, = 0x40003000
@	ldr r1, = 0x5555
@	str r1, [r0]
@	movs r1, # 7
@	str r1, [r0, # 4]
@	ldr r1, = 0xfff
@	str r1, [r0, # 8]
@	ldr r1, = 0xaaaa
@	str r1, [r0]
@	ldr r1, = 0xcccc
@	str r1, [r0]


@_systick:				@ systick定时器初始化
@
@	ldr r0, = 0xe000e010
@	ldr r1, = 0xffffff
@	str r1, [r0, # 4]
@	str r1, [r0, # 8]	
@	movs r1, # 0x07
@	str r1, [r0]
	
io_she_zhi:
	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	@a(0x48000000)b(0x48000400)c(0x48000800)d(0x48000c00)f(0x48001400)
	@ 输入（00），通用输出（01），复用功能（10），模拟（11）
	@偏移0x4 = 端口输出类型 @ （0 推挽），（ 1 开漏）
	@偏移0x8 = 输出速度  00低速， 01中速， 11高速
	@偏移0xC = 上拉下拉 (00无上下拉，  01 上拉， 10下拉)
	@偏移0x10 = 输入数据寄存器
	@偏移0x14 = 输出数据寄存器
	@偏移0x18 = 端口开  0-15置位
	@偏移0x28 = 端口关
	@0X20 = 复用低
	@GPIO口0（0-3位）每个IO口占用4位
	@ AF0 = 0X0000, AF1 = 0X0001, AF2 = 0X0010 AF3 = 0X0011, AF4 = 0X0100
	@ AF5 = 0X0101, AF6 = 0X0111, AF7 = 0X1000
	@0x24 = 复用高
	@GPIO口8 （0-3位）每个IO口占用4位
	@ AF0 = 0X0000, AF1 = 0X0001, AF2 = 0X0010 AF3 = 0X0011, AF4 = 0X0100
	@ AF5 = 0X0101, AF6 = 0X0111, AF7 = 0X1000
	@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	ldr r0, = 0x48000000
	ldr r1, = 0x281454ff
	str r1, [r0]
	ldr r1, = 0x610
	str r1, [r0, # 0x04]
	ldr r1, = 0x100
	str r1, [r0, # 0x0c]

	ldr r0, = 0x48000400
	movs r1, # 0x02
	str r1, [r0, # 0x04]
	movs r1, # 0x04
	str r1, [r0, # 0x0c]
_lcdchushihua:
	movs r0, # 0x33
	movs r1, # 0
	bl _xielcd
	bl _lcdyanshi

	movs r0, # 0x32
	movs r1, # 0
	bl _xielcd
	bl _lcdyanshi
	movs r0, # 0x28
	movs r1, # 0
	bl _xielcd
	bl _lcdyanshi
	movs r0, # 0x0c
	movs r1, # 0
	bl _xielcd
	bl _lcdyanshi
	movs r0, # 0x01
	movs r1, # 0
	bl _xielcd
	bl _lcdyanshi
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
__qie_huan_shi_zhong:
        ldr r0, = 0x40021000 @ rcc
	movs r1, # 0
	str r1, [r0, 0x04]
        ldr r1, = 0x50001
	str r1, [r0]
__denghse:
        ldr r1, [r0]
        lsls r1, r1, # 14
        bpl __denghse
__dengpllguan:
	ldr r1, [r0]
        lsls r1, r1, # 6
        bmi __dengpllguan
        ldr r1, = 0x10002
        mov r0, r0
        str r1, [r0, # 0x04]
        mov r0, r0
        ldr r1, = 0x1050001
        mov r0, r0
	str r1, [r0]
__dengpll:
        ldr r1, [r0]
        lsls r1, # 6
        bpl __dengpll
_adcchushihua:
        ldr r0, = 0x40012400  @ adc基地址
        ldr r1, = 0x80000000
        str r1, [r0, # 0x08]  @ ADC 控制寄存器 (ADC_CR)  @adc校准
_dengadcjiaozhun:
        ldr r1, [r0, # 0x08]
        movs r1, r1
        bmi _dengadcjiaozhun   @ 等ADC校准
	movs r1, # 1
	str r1, [r0]
_kaiadc:
        ldr r1, [r0, # 0x08]
        movs r2, # 0x01
        orrs r1, r1, r2
        str r1, [r0, # 0x08]
_deng_adc_wen_ding:
        ldr r1, [r0]
        lsls r1, r1, # 31
        bpl _deng_adc_wen_ding @ 等ADC稳定
_tongdaoxuanze:
        ldr r1, = 0x80000000
        str r1, [r0, # 0x10]
        ldr r1, = 0x0f
        str r1, [r0, # 0x28]    @ 通道选择寄存器 (ADC_CHSELR)
        ldr r1, = 0x8c3 @0x2003 @0x8c3
        str r1, [r0, # 0x0c]    @ 配置寄存器 1 (ADC_CFGR1)
        movs r1, # 0
	str r1, [r0, # 0x14]    @ ADC 采样时间寄存器 (ADC_SMPR)
        ldr r1, [r0, # 0x08]
        ldr r2, = 0x04         @ 开始转换
	orrs r1, r1, r2
        str r1, [r0, # 0x08]    @ 控制寄存器 (ADC_CR)
dmachushihua:
        @+0=LSR,+4=IFCR,
        @+8=CCR1,+c=CNDTR1,+10=CPAR1+14=CMAR1,
        @+1c=CCR2,+20=CNDTR2,+24=CPAR2,+28=CMAR2
        @+30=CCR3,+34=CNDTR3,+38=CPAR2,+3c=CMAR3
        @+44=CCR4,+48=CNDTR4,+4c=CPAR4,+50=CMAR4
        @+58=CCR5,+5c=CNDTR5,+60=CPAR5,+64=CMAR5
        @+6C=CCR6,+70=CNDTR6,+74=CPAR6,+78=CMAR6
        @+80=CCR7,+84=CNDTR7,+88=CPAR7,+8c=CMAR7

	@ adc dma
	ldr r0, = 0x40020000
	ldr r1, = 0x40012440
	str r1, [r0, # 0x10]
	ldr r1, = dianyabiao
	str r1, [r0, # 0x14]
	ldr r1, = 912
	str r1, [r0, # 0x0c]
	ldr r1, = 0x583 @  0x583 	@ 5a1
	str r1, [r0, # 0x08]
tim3chushihua:				
	ldr r0, = 0x40000400 @ tim3_cr1
	ldr r1, = 0
	str r1, [r0, # 0x28] @ psc
	ldr r1, = 349	@699 40k @11199 2.5k		@2799 10Khz
	str r1, [r0, # 0x2c] @ ARR
	ldr r1, =  0x3800 @ 0x3800
	str r1, [r0, # 0x1c] @ ccmr2
	ldr r1, =  0x1000
	str r1, [r0, # 0x20] @ ccer
	ldr r1, = 349  @ 2799
	str r1, [r0, # 0x40] @ ccr4
	movs r1, # 0x70
	str r1, [r0, # 0x04]
	@movs r1, # 0x01
	@str r1, [r0, # 0x0c]
	movs r1, # 0xe1
	str r1, [r0]

ting:
@__wei_gou:
@	ldr r0, = 0x40003000
@        ldr r1, = 0xaaaa
@        str r1, [r0]
	bl __an_jian
	ldr r0, = jishu
	ldr r1, = 10
	ldr r2, [r0]
	adds r2, r2, # 1
	str r2, [r0]
	cmp r2, r1
	bne __xianshi
	movs r2, # 0
	str r2, [r0]
	bl __kai_dma
__xianshi:
	@	bl __xian_shi_ru_she_fan_she
        movs r0, # 0x8c
	ldr r1, = ou
        movs r2, # 1
        bl _lcdxianshi

	ldr r0, = dianzu	@dianzu
	ldr r1, [r0]
       movs r4, r1
	bpl __dian_zu_bu_shi_zheng
	movs r0, # 0x80
        ldr r1, = _fu
        movs r2, # 1
        bl _lcdxianshi
        mvns r4, r4
        adds r4, r4, # 1
        b __xian_shi_dian_zu
__dian_zu_bu_shi_zheng:
	movs r0, # 0x80
	ldr r1, = kong
	movs r2, # 1
        bl _lcdxianshi
__xian_shi_dian_zu:
        mov r0, r4
        movs r1, # 5
        ldr r2, = asciimabiao
        movs r3, # 3
        bl _zhuanascii
        movs r0, # 0x81
        ldr r1, = asciimabiao
        movs r2, # 5
        bl _lcdxianshi

        ldr r0, = diankang	@diankang
        ldr r1, [r0]
       movs r4, r1
        bpl __dian_kang_bu_shi_zheng
        movs r0, # 0x86
        ldr r1, = _fu
        movs r2, # 1
        bl _lcdxianshi
        mvns r4, r4
        adds r4, r4, # 1
        b __xian_shi_dian_kang
__dian_kang_bu_shi_zheng:
        movs r0, # 0x86
        ldr r1, = kong
        movs r2, # 1
        bl _lcdxianshi
__xian_shi_dian_kang:
        mov r0, r4
        movs r1, # 5
        ldr r2, = asciimabiao
        movs r3, # 3
        bl _zhuanascii
        movs r0, # 0x87
        ldr r1, = asciimabiao
        movs r2, # 5
        bl _lcdxianshi

__xian_shi_fan_she_xi_shu:
        ldr r0, = p_shibu       
        ldr r1, [r0]
       movs r4, r1
        bpl __p_shibu_bu_shi_zheng
        movs r0, # 0xc0
        ldr r1, = _fu
        movs r2, # 1
        bl _lcdxianshi
        mvns r4, r4
        adds r4, r4, # 1
        b __xian_shi_p_shibu
__p_shibu_bu_shi_zheng:
        movs r0, # 0xc0
        ldr r1, = kong
	movs r2, # 1
        bl _lcdxianshi
__xian_shi_p_shibu:
        mov r0, r4
        movs r1, # 5
        ldr r2, = asciimabiao
        movs r3, # 1
	bl _zhuanascii
	movs r0, # 0xc1
        ldr r1, = asciimabiao
        movs r2, # 5
        bl _lcdxianshi

        ldr r0, = p_xubu
        ldr r1, [r0]
       movs r4, r1
        bpl __p_xubu_bu_shi_zheng
        movs r0, # 0xc6
        ldr r1, = _fu
        movs r2, # 1
        bl _lcdxianshi
        mvns r4, r4
        adds r4, r4, # 1
        b __xian_shi_p_xubu
__p_xubu_bu_shi_zheng:
        movs r0, # 0xc6
        ldr r1, = kong
	movs r2, # 1
        bl _lcdxianshi
__xian_shi_p_xubu:
        mov r0, r4
        movs r1, # 5
        ldr r2, = asciimabiao
        movs r3, # 1
	bl _zhuanascii
	movs r0, # 0xc7
        ldr r1, = asciimabiao
        movs r2, # 5
        bl _lcdxianshi


	b ting
__xian_shi_jiao_du:	
       ldr r0, = jiaodu
        ldr r1, [r0]
       movs r4, r1
        bpl __jiaodu_bu_shi_zheng
        movs r0, # 0x87
        ldr r1, = _fu
        movs r2, # 1
        bl _lcdxianshi
        mvns r4, r4
        adds r4, r4, # 1
        b __xian_shi_jiaodu
__jiaodu_bu_shi_zheng:
        movs r0, # 0x87
        ldr r1, = kong
        movs r2, # 1
        bl _lcdxianshi
__xian_shi_jiaodu:
        mov r0, r4
        movs r1, # 5
        ldr r2, = asciimabiao
        movs r3, # 0xff
        bl _zhuanascii
        movs r0, # 0x88
        ldr r1, = asciimabiao
        movs r2, # 5
        bl _lcdxianshi

	b ting
	.ltorg

__osm_jiao_zhun:
	push {r0,r3-r7,lr}
	ldr r0, = p_shibu
	ldr r1, = p_xubu
	ldr r0, [r0]
	ldr r1, [r1]
@	ldr r0, = -188
@	ldr r1, = 247
	mov r4, r0	@a
	mov r5, r1	@b
	ldr r2, = -41 	@开路R
	movs r3, # 17  @开路I
	ldr r6, = -173	@c	@短路R
	movs r7, # 116   @247	@152	@d	@短路I
	subs r0, r0, r2
	subs r1, r1, r3
	mov r2, r4	@a
	mov r3, r5	@b
	muls r4, r4, r6	@a*c
	muls r5, r5, r7	@b*d
	subs r4, r4, r5	@ac-bd
	muls r2, r2, r7	@a*d
	muls r3, r3, r6	@b*c
	adds r2, r2, r3	@ad+bc
	mov r7, r0
	mov r3, r1
	mov r0, r4
	ldr r1, = 1000
	bl __chu_fa
	mov r4, r0
	mov r0, r2
	ldr r1, = 1000
	bl __chu_fa
	mov r2, r0
	ldr r5, = -395		@50欧姆R
	ldr r6, = -902		@50欧姆I
	subs r4, r4, r5
	subs r2, r2, r6
	mov r0, r7
	mov r1, r3
	mov r3, r2
	mov r2, r4
	bl __fu_shu_chu_fa
	pop {r0,r3-r7,pc}
	.ltorg
	
	
__an_jian:
	push {r0-r3,lr}
	ldr r0, = 0x48000010
	ldr r1, = 0x48000410
	ldr r2, [r0]	@pa4
	ldr r3, [r1]	@pb1
	lsls r2, r2, # 27
	lsrs r2, r2, # 31
	lsls r3, r3, # 30
	lsrs r3, r3, # 30
	ldr r0, = anjian
	orrs r3, r3, r2
	str r3, [r0]	
	pop {r0-r3,pc}
__atan2_ji_suan:
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
	asrs r0, r0, # 15
	mov r2, r8
	pop {r2}
	pop {r2-r7,pc}
	.ltorg
__xie_i2c_8_wei:
	push {r3-r7,lr}
	@r0=从地址，r1=数据地址，r2=数据
	ldr r7, = 0x48000000
	ldr r3, = 0x200 	@pa9=SDA
	ldr r4, = 0x400		@pa10=SCL
__i2c_qi_8:	
	str r3, [r7, # 0x18]	@ SDA=1
	str r4, [r7, # 0x18]	@ SCL=1
	bl __i2c_yan_shi
	str r3, [r7, # 0x28]	@ SDA=0
	bl __i2c_yan_shi
	str r4, [r7, # 0x28]	@ SCL=0
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
	str r3, [r7, # 0x18]	@SDA=1
	b __SCL_8_gao
__SDA_8_deng_yu_0:
	str r3, [r7, # 0x28]	@SDA=0
__SCL_8_gao:	
	str r4, [r7, # 0x18]	@SCL=1
	bl __i2c_yan_shi
	str r4, [r7, # 0x28]	@SCL=0
	bl __i2c_yan_shi
	subs r5, r5, # 1
	bne __xie_shu_ju_8
	str r3, [r7, # 0x18]	@SDA=1
	bl __i2c_yan_shi
	str r4, [r7, # 0x18]	@SCL=1
	bl __i2c_yan_shi
__du_apk_8:
	ldr r5, [r7, # 0x10]	@读APK
	lsls r5, r5, # 22
	bpl __apk_di_8
__apk_gao_8:
	movs r1, # 0xf0
	b __i2c_ting_8
__apk_di_8:
	str r4, [r7, # 0x28]	@SCL=0
	bl __i2c_yan_shi
	adds r6, r6, # 1
	cmp r6, # 1
	beq __xie_cong_ji_di_zhi
	cmp r6, # 2
	beq __xie_cong_ji_shu_ju
__i2c_ting_8:
	str r3, [r7, # 0x28]	@SDA=0
	bl __i2c_yan_shi
	str r4, [r7, # 0x18]	@SCL=1
	bl __i2c_yan_shi
	str r3, [r7, # 0x18]	@SDA=1
	pop {r3-r7,pc}
__xie_i2c:
	push {r2-r7,lr}
	adds r1, r1, # 2
	ldr r2, = 0x48000000
	ldr r3, = 0x200 	@pa9=SDA
	ldr r4, = 0x400		@pa10=SCL
__i2c_qi:	
	str r3, [r2, # 0x18]	@ SDA=1
	str r4, [r2, # 0x18]	@ SCL=1
	bl __i2c_yan_shi
	str r3, [r2, # 0x28]	@ SDA=0
	bl __i2c_yan_shi
	str r4, [r2, # 0x28]	@ SCL=0
	bl __i2c_yan_shi
	movs r7, # 0
__xie_shu_ju_xun_huan:
	movs r5, # 8
	ldrb r6, [r0, r7]
	lsls r6, r6, # 23
__xie_shu_ju:
	lsls r6, r6, # 1
	bpl __SDA_deng_yu_0
	str r3, [r2, # 0x18]	@SDA=1
	b __SCL_gao
__SDA_deng_yu_0:
	str r3, [r2, # 0x28]	@SDA=0
__SCL_gao:	
	str r4, [r2, # 0x18]	@SCL=1
	bl __i2c_yan_shi
	str r4, [r2, # 0x28]	@SCL=0
	bl __i2c_yan_shi
	subs r5, r5, # 1
	bne __xie_shu_ju
	str r3, [r2, # 0x18]	@SDA=1
	bl __i2c_yan_shi
	str r4, [r2, # 0x18]	@SCL=1
	bl __i2c_yan_shi
__du_apk:
	ldr r5, [r2, # 0x10]	@读APK
	lsls r5, r5, # 22
	bpl __apk_di
__apk_gao:
	b __apk_gao
__apk_di:
	str r4, [r2, # 0x28]	@SCL=0
	bl __i2c_yan_shi
	adds r7, r7, # 1
	subs r1, r1, # 1
	bne __xie_shu_ju_xun_huan
__i2c_ting:
	str r3, [r2, # 0x28]	@SDA=0
	bl __i2c_yan_shi
	str r4, [r2, # 0x18]	@SCL=1
	bl __i2c_yan_shi
	str r3, [r2, # 0x18]	@SDA=1
	pop {r2-r7,pc}
__du_i2c:
	push {r2-r7,lr}
	mov r8, r1
	movs r1, # 0
	ldr r2, = 0x48000000
	ldr r3, = 0x200 	@pa9=SDA
	ldr r4, = 0x400		@pa10=SCL
__i2c_qi1:	
	str r3, [r2, # 0x18]	@ SDA=1
	str r4, [r2, # 0x18]	@ SCL=1
	bl __i2c_yan_shi
	str r3, [r2, # 0x28]	@ SDA=0
	bl __i2c_yan_shi
	str r4, [r2, # 0x28]	@ SCL=0
	bl __i2c_yan_shi
	movs r5, # 8
	movs r7, # 2
	movs r6, # 0xc0
	lsls r6, r6, # 23
	b __xie_shu_ju1
__yao_du_de_di_zhi:
	movs r6, # 0xb7
	lsls r6, r6, # 23
	movs r5, # 8
__xie_shu_ju1:
	lsls r6, r6, # 1
	bpl __SDA_deng_yu0_1
	str r3, [r2, # 0x18]	@SDA=1
	b __SCL_gao1
__SDA_deng_yu0_1:	
	str r3, [r2, # 0x28]	@SDA=0
__SCL_gao1:	
	str r4, [r2, # 0x18]	@SCL=1
	bl __i2c_yan_shi
	str r4, [r2, # 0x28]	@SCL=0
	bl __i2c_yan_shi
	subs r5, r5, # 1
	bne __xie_shu_ju1
	str r3, [r2, # 0x18]	@SDA=1
	bl __i2c_yan_shi
	str r4, [r2, # 0x18]	@SCL=1
	bl __i2c_yan_shi
__du_apk1:
	ldr r5, [r2, # 0x10]	@读APK
	lsls r5, r5, # 22
	bpl __apk_di1
__apk_gao1:
	b __apk_gao1
__apk_di1:
	str r4, [r2, # 0x28]	@SCL=0
	bl __i2c_yan_shi
	cmp r7, # 0xff
	beq __du_shu_ju
	subs r7, r7, # 1
	bne __yao_du_de_di_zhi
__i2c_qi2:
        str r3, [r2, # 0x18]    @ SDA=1
        str r4, [r2, # 0x18]    @ SCL=1
        bl __i2c_yan_shi
        str r3, [r2, # 0x28]    @ SDA=0
        bl __i2c_yan_shi
        str r4, [r2, # 0x28]    @ SCL=0
        bl __i2c_yan_shi
	movs r6, # 0xc1		@读
        lsls r6, r6, # 23
	movs r5, # 8
	movs r7, # 0xff
	b __xie_shu_ju1
__du_shu_ju:
	movs r5, # 8
	movs r7, # 0
	str r3, [r2, # 0x18]	@ SDA=1
__du_shu_ju_xun_huan:	
	bl __i2c_yan_shi
	str r4, [r2, # 0x28]	@SCL=0
	bl __i2c_yan_shi
	str r4, [r2, # 0x18]	@SCL=1
	bl __i2c_yan_shi
	ldr r6, [r2, # 0x10]	@读SDA
	lsls r6, r6, # 22
	lsrs r6, r6, # 31
	lsls r7, r7, # 1
	orrs r7, r7, r6
	subs r5, r5, # 1
	bne __du_shu_ju_xun_huan
	str r4, [r2, # 0x28]	@SCL=0
	bl __i2c_yan_shi
	strb r7, [r0, r1]
	adds r1, r1, # 1
	cmp r1, r8
	bne __ying_da
__fei_ying_da:
	str r3, [r2, # 0x18]	@SDA=0
	bl __i2c_yan_shi
        str r4, [r2, # 0x18]    @SCL=1
	bl __i2c_yan_shi
        str r4, [r2, # 0x28]    @SCL=0
        bl __i2c_yan_shi
	b __i2c_ting1
__ying_da:	
	str r3, [r2, # 0x28]	@SDA=0
        bl __i2c_yan_shi
	str r4, [r2, # 0x18]	@SCL=1
	bl __i2c_yan_shi
	str r4, [r2, # 0x28]	@SCL=0
	bl __i2c_yan_shi
	b  __du_shu_ju
__i2c_ting1:
	str r3, [r2, # 0x28]	@SDA=0
	bl __i2c_yan_shi
	str r4, [r2, # 0x18]	@SCL=1
	bl __i2c_yan_shi
	str r3, [r2, # 0x18]	@SDA=1
	pop {r2-r7,pc}
	
__i2c_yan_shi:
	push {r3, lr}
	ldr r3, = 0x5000
__i2c_yan_shi_xun_huan:
	subs r3, r3, # 1
	bne __i2c_yan_shi_xun_huan
	pop {r3, pc}
__kai_dma:
	push {r0-r2,lr}
	ldr r2, = 0x40012400
	movs r1, # 0x11
	str r1, [r2, # 0x08]
__deng_adc_wan:
	ldr r1, [r2, # 0x08]
	cmp r1, # 1
	bne __deng_adc_wan
	ldr r0, = 0x40020000
	movs r1, # 0
	str r1, [r0, # 0x08]
	ldr r1, = 912
	str r1, [r0, # 0x0c]
	ldr r1, = 0x583
	str r1, [r0, # 0x08]
	movs r1, # 0x05
	str r1, [r2, # 0x08]
	pop {r0-r2,pc}
__xian_shi_ru_she_fan_she:
@入口 R0= 下臂实部，R1=上臂实部，R2=下臂虚部，R3=上臂虚部
	push {r0-r7,lr}
	mov r0, r8
        mov r1, r9
        mov r2, r10
	mov r3, r11
	mov r4, r12
        push {r0-r4}
	ldr r0, = fanshe_r
	ldr r2, [r0, # 0x08]
	ldr r1, [r0, # 0x04]
	ldr r3, [r0, # 0x0c]
	ldr r0, [r0]
	mov r8, r0
	mov r9, r1
	mov r10, r2
	mov r11, r3
@显示上臂实部
	movs r4, r2
	bpl __ru_she_shi_bu_zheng
        movs r0, # 0x86
        ldr r1, = _fu
        movs r2, # 1
        bl _lcdxianshi
	mvns r4, r4
	adds r4, r4, # 1
	b __xian_shi_ru_she_shi_bu
__ru_she_shi_bu_zheng:	
        movs r0, # 0x86
	ldr r1, = kong
        movs r2, # 1
        bl _lcdxianshi
__xian_shi_ru_she_shi_bu:
	mov r0, r4
	movs r1, # 4
	ldr r2, = asciimabiao
	movs r3, # 0xff
	bl _zhuanascii
	movs r0, # 0x87
	ldr r1, = asciimabiao
	movs r2, # 4
	bl _lcdxianshi
@显示上臂虚部
        mov r4, r11
	movs r4, r4
        bpl __ru_she_xu_bu_zheng
        movs r0, # 0x8b
        ldr r1, = _fu
        movs r2, # 1
        bl _lcdxianshi
        mvns r4, r4
        adds r4, r4, # 1
        b __xian_shi_ru_she_xu_bu
__ru_she_xu_bu_zheng:
        movs r0, # 0x8b
	ldr r1, = kong
        movs r2, # 1
        bl _lcdxianshi
__xian_shi_ru_she_xu_bu:
        mov r0, r4
        movs r1, # 4
        ldr r2, = asciimabiao
        movs r3, # 0xff
	bl _zhuanascii
	movs r0, # 0x8c
        ldr r1, = asciimabiao
        movs r2, # 4
	bl _lcdxianshi
@显示下臂实部：
        mov r4, r8
	movs r4, r4
        bpl __fan_she_shi_bu_zheng
        movs r0, # 0xc6
        ldr r1, = _fu
        movs r2, # 1
        bl _lcdxianshi
        mvns r4, r4
	adds r4, r4, # 1
	b __xian_shi_fan_she_shi_bu
__fan_she_shi_bu_zheng:
        movs r0, # 0xc6
        ldr r1, = kong
        movs r2, # 1
	bl _lcdxianshi
__xian_shi_fan_she_shi_bu:
	mov r0, r4
	movs r1, # 4
	ldr r2, = asciimabiao
	movs r3, # 0xff
	bl _zhuanascii
        movs r0, # 0xc7
        ldr r1, = asciimabiao
        movs r2, # 4
        bl _lcdxianshi

@显示下臂虚部
	mov r4, r9
	movs r4, r4
        bpl __fan_she_xu_bu_zheng
        movs r0, # 0xcb
        ldr r1, = _fu
        movs r2, # 1
        bl _lcdxianshi
        mvns r4, r4
        adds r4, r4, # 1
        b __xian_shi_fan_she_xu_bu
__fan_she_xu_bu_zheng:
        movs r0, # 0xcb
        ldr r1, = kong
        movs r2, # 1
        bl _lcdxianshi
__xian_shi_fan_she_xu_bu:
        mov r0, r4
        movs r1, # 4
        ldr r2, = asciimabiao
        movs r3, # 0xff
        bl _zhuanascii
        movs r0, # 0xcc
        ldr r1, = asciimabiao
        movs r2, # 4
        bl _lcdxianshi
        pop {r0-r4}
        mov r8, r0
        mov r9, r1
        mov r10, r2
        mov r11, r3
        mov r12, r4
	pop {r0-r7,pc}

__fu_jie_dian_chang_shu:	@复介电常数
	@阻抗计算介电常数
	@r=串联电阻
	@x=串联电抗
	@jx=并联电抗
	@rp=并联电阻
	@cp=并联电容
	@a=电容面积
	@t=电容板距离
	@eo=自由空间的介电常数
	@er1=介电常数虚部
	@er=介电常数实部

	@r=880
	@x=-700
	@jx=(r^2*x)/(r^2+x^2)
	@w=1.7592918860102842*10^8
	@cp=1/(w*jx)
	@rp=(r*x^2)/(r^2+x^2)
	@a=1
	@t=1
	@eo=8.85*10^-12
	@er=t/(w*rp*a*eo)
	@er1=(t*cp)/(a*eo)
	push {r0-r5,lr}
	ldr r0, = bingliandianzu
	ldr r1, = bingliandiankang
	ldr r3, [r0]
	ldr r4, [r1]
	ldr r0, = 5242880	@q19 1*100
	ldr r1, = 816		@q19 w*eo
	muls r1, r1, r3
	ldr r2, = jiedianchangshushibu
	bl _chufa		@er=t/(w*rp*eo)
	str r0, [r2]
	ldr r2, = 1759291
	muls r2, r2, r4
	ldr r0, = 0x918
	ldr r1, = 0x4e72a000	@1
	bl __chufa64		@cp=1/(w*jx)
	ldr r0, = dianrongzhi
	str r1, [r0]
	mov r0, r1
	ldr r1, = 885		@eo
	bl _chufa		@er1=(t*cp)/(a*eo)
	ldr r1, = jiedianchangshuxubu
	str r0, [r1]
	pop {r0-r5,pc}

__chuan_lian_zhuan_bing_lian:   @串联转并联
        push {r0-r5,lr}
        ldr r0, = dianzu
        ldr r1, = diankang
        ldr r0, [r0]            @r
	ldr r1, [r1]            @i=x
	mov r4, r0
	muls r0, r0, r0		@r^2
	mov r5, r0
	mvns r1, r1
	adds r1, r1, # 1
	muls r0, r0, r1		@r^2*x
	muls r1, r1, r1		@x^2
	mov r3, r1
	add r1, r1, r5
	ldr r2, = bingliandiankang
	bl _chufa		@jx=(r^2*x)/(r^2+x^2)
	str r0, [r2]
	mov r0, r4
	muls r0, r0, r3		@r*x^2
	ldr r2, = bingliandianzu
	bl _chufa
	str r0, [r2]
        pop {r0-r5,pc}
	.ltorg
_lvboqi:
			@滤波器
			@R0=地址，R1=长度,r2=表指针地址,r3=ADC数值
			@出R0=结果
	push {r1-r7,lr}	
	ldr r5, [r2]		@读出表指针
	lsls r6, r1, # 2	
	str r3, [r0, r5]	@数值写到滤波器缓冲区
	adds r5, r5, # 4
	cmp r5, r6
	bne _lvboqimeidaohuanchongquding
	movs r5, # 0
_lvboqimeidaohuanchongquding:
	str r5, [r2]
	movs r7, # 0
_lvboqixunhuan:
	cmp r5, r6
	bne _lvbozonghe
	movs r5, # 0
_lvbozonghe:
	ldr r4, [r0, r5]
	adds r5, r5, # 4
	adds r7, r7, r4
	subs r1, r1, # 1
	bne _lvboqixunhuan
	asrs r0, r7, # 3	@修改
	pop {r1-r7,pc}
_lcdxianshi:	  		@r0=LCD位置，r1=数据地址，r2=长度
	push {r0-r4,lr}
	mov r4, r1

	movs r1, # 0
	bl _xielcd

	movs r1, # 1
	movs r3, # 0
_lcdxianshixunhuan:
	ldrb r0, [r4,r3]
	bl _xielcd
	adds r3, r3, # 1
	cmp r3, r2
	bne _lcdxianshixunhuan
	pop {r0-r4,pc}

_lcdyanshi:
	push {r5,lr}
	ldr r5, = 0x1000
_lcdyanshixunhuan:
	subs r5, r5, # 1
	bne _lcdyanshixunhuan
	pop {r5,pc}

_xielcd:			@入R0=8位,r1=0命令,r1=1数据
	push {r0-r5,lr}
	ldr r4, = liangcheng  @ 量程开关 (第6位和第7位)
	mov r2, r0
	ldr r5, [r4]
	lsrs r2, r2, # 4
	lsls r2, r2, # 2	@ 高四位
	lsls r0, r0, # 28
	lsrs r0, r0, # 26	@ 低四位
	lsls r1, r1, # 31
	bpl __lcd_ming_ling
__lcd_shu_ju:
	movs r3, # 0x03		@ RS = 1 E = 1
	b __xie_lcd_shu_ju
__lcd_ming_ling:
	movs r3, # 0x02		@ RS = 0 E = 1
__xie_lcd_shu_ju:
	adds r3, r3, r5
	mov r1, r0
	adds r2, r2, r3
	movs r0, r2
	bl __74hc595
	subs r0, r0, # 0x02
	bl __74hc595
	mov r0, r1
	adds r0, r0, r3
	bl __74hc595
	subs r0, r0, # 0x02
	bl __74hc595
	pop {r0-r5,pc}
	
__74hc595:			@ 入R0=8位
	push {r0-r7,lr}
	ldr r6, = 0x48000000
	movs r5, # 0x20		@ SRCLK
	movs r2, # 0x40		@ RCLK
	movs r3, # 0x80		@ SER
	movs r4, # 24
__595_yiweixunhuan:
	str r2, [r6, # 0x18]	@ rclk=0
	str r5, [r6, # 0x18]	@ srclk=0
	@ovs r7, # 0xff
	ldr r7, = 0x1ff
__595_yanshi:
	subs r7, r7, # 1
	bne __595_yanshi
	mov r1, r0
	lsls r1, r1, r4
	bpl __ser_0
__ser_1:
	str r3, [r6, # 0x28]	@ ser=1
	b __595_yiwei
__ser_0:
	str r3, [r6, # 0x18]	@ ser=0
__595_yiwei:
	str r5, [r6, # 0x28]
	@movs r7, # 0xff
	ldr r7, = 0x1ff
__595_yanshi1:
	subs r7, r7, # 1
	bne __595_yanshi1
	adds r4, r4, # 1
	cmp r4, # 32
	bne __595_yiweixunhuan
	str r2, [r6, # 0x28]	@ rclk=1
	@movs r7, # 0xff
	ldr r7, = 0x1ff
__595_yanshi2:
	subs r7, r7, # 1
	bne __595_yanshi2
	str r2, [r6, # 0x18]	@ rclk = 0
	pop {r0-r7,pc}



_zhuanascii:					@ 16进制转ASCII
		@ R0要转的数据， R1长度，R2结果表首地址, r3=小数点位置
	push {r0-r7,lr}
	mov r7, r3
	mov r5, r0
	mov r6, r1
	movs r1, # 10
_xunhuanqiuma:
	bl _chufa
	mov r4, r0
	muls r4, r1
	subs r3, r5, r4
	adds r3, r3, # 0x30
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
	pop {r0-r7,pc}
_qiumafanhui:
	strb r3, [r2, r6]
	pop {r0-r7,pc}
__ji_suan_fu_du:    @ 计算幅度
                @ 入r0= 实部，r1= 虚部
                @ 出r0 = 幅度
                @ Mag ~=Alpha * max(|I|, |Q|) + Beta * min(|I|, |Q|)
                @ Alpha * Max + Beta * Min
        push {r1-r3,lr}
        movs r0, r0
        bpl _shibubushifushu
        mvns r0, r0                             @ 是负数转成正数
        adds r0, r0, # 1
_shibubushifushu:                               @ 实部不是负数
        movs r1, r1
        bpl _xububushifushu
        mvns r1, r1                             @ 是负数转成正数
        adds r1, r1, # 1
_xububushifushu:                                @ 虚部不是负数
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
__dft:
	push {r0-r7,lr}
	mov r0, r8
	mov r1, r9
	mov r2, r10
	mov r3, r11
	mov r4, r12
	push {r0-r4}
        ldr r0, = dianyabiao
        subs r0, r0, # 0x08
__zhao_shang_sheng2:
        adds r0, r0, # 0x08
        ldrh r2, [r0, # 0x04]
	ldrh r3, [r0, # 0x06]
	subs r3, r3, r2
        bmi __zhao_shang_sheng2
        ldrh r2, [r0, # 0x0c]
	ldrh r3, [r0, # 0x0e]
        subs r3, r3, r2
	bpl __zhao_shang_sheng2
	ldr r1, = xuanzhuanyinzi
	movs r2, # 1
	lsls r2, r2, # 10
	mov r8, r2
	movs r3, # 0
	mov r11, r3	
	mov r12, r3
	mov r10, r3
	mov r9, r3
__dft_xun_huan:
	ldr r4, [r0, r3]
	ldr r2, [r1, r3]	@r
	push {r2}
	adds r3, r3, # 4
	ldr r5, [r0, r3]
	ldr r2, [r1, r3]	@i
	adds r3, r3, # 4
	mov r6, r4
	mov r7, r5
	lsls r4, r4, # 16
	lsrs r4, r4, # 16
	lsrs r6, r6, # 16
	lsls r5, r5, # 16
	lsrs r5, r5, # 16
	lsrs r7, r7, # 16

	push {r3}
	ldr r3, = 33860
	subs r4, r4, r6
	muls r4, r4, r3
	asrs r4, r4, # 15
	pop {r3}
	subs r5, r5, r7
	mov r6, r4
	mov r7, r5
	muls r4, r4, r2		@i
	muls r5, r5, r2		@i
	asrs r4, r4, # 15
	asrs r5, r5, # 15
	mov r2, r9
	adds r2, r2, r4
	mov r9, r2
	mov r2, r10
	adds r2, r2, r5
	mov r10, r2
	pop {r2}
	muls r6, r6, r2		@r
	muls r7, r7, r2		@r
	asrs r6, r6, # 15
	asrs r7, r7, # 15
	mov r2, r11		@r
	adds r2, r2, r6
	mov r11, r2
	mov r2, r12
	adds r2, r2, r7
	mov r12, r2
	cmp r3, r8
	bne __dft_xun_huan
	ldr r0, = fan_she_shi_bu
	ldr r1, = fan_she_xu_bu
	mov r2, r9
	mov r3, r10
	mov r4, r11
	mov r5, r12
	asrs r2, r2, # 6
	asrs r3, r3, # 6
	asrs r4, r4, # 6
	asrs r5, r5, # 6
	ldr r0, = fan_she_shi_bu
	ldr r1, = ru_she_shi_bu
	ldr r6, = fan_she_xu_bu
	ldr r7, = ru_she_xu_bu
	str r2, [r6]		@r
	str r3, [r7]	@r
	str r4, [r0]		@i
	str r5, [r1]	@i
__dft_fan_hui:	
	pop {r0-r4}
	mov r8, r0
	mov r9, r1
	mov r10, r2
	mov r11, r3
	mov r12, r4
	pop {r0-r7,pc}
	.ltorg
__fu_shu_chu_fa:
	push {r4-r7,lr}
	@入口R0=a R1=b,R2=c R3=d
	@出口R1=虚部 R2=实部
	mov r4, r8
	push {r4}
__ji_suan_chu_fa:
	@ Z=50*[(a+bi)/(c+di)]=50*[(ac+bd)/(c*c+d*d)+(bc-ad)/(c*c+d*d)]
	mov r4, r0
	mov r5, r1
	mov r6, r2
	@mov r7, r3
	mov r8, r3
	movs r7,  # 0
        movs r0, r0
        bpl b1
        mvns r0, r0
        adds r0, r0, # 1
        adds r7, r7, # 1

b1:
        movs r2, r2
        bpl b2
	mvns r2, r2
        adds r2, r2, # 1
        adds r7, r7, # 1
b2:
	muls r0, r0, r2
        cmp r7, # 1
        bne b3
        mvns r0, r0
        adds r0, r0, # 1
b3:
	@muls r0, r0, r2		@ac
        movs r7,  # 0
        movs r1, r1
        bpl b4
        mvns r1, r1
        adds r1, r1, # 1
        adds r7, r7, # 1

b4:
        movs r3, r3
        bpl b5
        mvns r3, r3
        adds r3, r3, # 1
        adds r7, r7, # 1
b5:
        muls r1, r1, r3
        cmp r7, # 1
        bne b6
        mvns r1, r1
        adds r1, r1, # 1
b6:

@	muls r1, r1, r3		@bd
	adds r0, r0, r1		@ac+bd
	movs r2, r2
	bpl b7
	mvns r2, r2
	adds r2, r2, # 1
	muls r2, r2, r2
	mvns r2, r2
	adds r2, r2, # 1
	b b8
b7:	
        muls r2, r2, r2         @c*c
b8:
	movs r3, r3
	bpl b9
	mvns r3, r3
	adds r3, r3, # 1
	muls r3, r3, r3
	mvns r3, r3
	adds r3, r3, # 1
	b b10
b9:	
	muls r3, r3, r3		@d*d
b10:	
	adds r2, r2, r3		@c*c+d*d
	ldr r1, = 1000
	movs r3, # 0
	movs r0, r0
	bpl a1
	mvns r0, r0
	adds r0, r0, # 1
	adds r3, r3, # 1
a1:
	movs r2, r2
	bpl a2
	mvns r2, r2
	adds r2, r2, # 1
	adds r3, r3, # 1
a2:
	bl __chengfa
	bl __chufa64		@(ac+bd)/(c*c+d*d)
	cmp r3, # 1
	bne a3
	mvns r1, r1
	adds r1, r1, # 1
a3:	
	push {r1}
	mov r7, r8
	muls r5, r5, r6		@ bc
	muls r4, r4, r7		@ ad
	subs r5, r5, r4		@ bc-ad
	ldr r1, = 1000
	movs r3, # 0
	movs r0, r5
	bpl a4
	mvns r0, r0
	adds r0, r0, # 1
	adds r3, r3, # 1
a4:
	movs r2, r2
	bpl a5
	mvns r2, r2
	adds r2, r2, # 1
	adds r3, r3, # 1
a5:
	bl __chengfa
	bl __chufa64
	cmp r3, # 1
	bne __a6
	mvns r1, r1
	adds r1, r1, # 1	@虚部
__a6:	
	pop {r2}		@实
	pop {r4}
	mov r8, r4
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
__di_yi_wei:            @低32位移位
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
        @4        F F F E 0 0 0 1
        @3                F F F E 0 0 0 1
        @2                F F F E 0 0 0 1
        @1                        F F F E 0 0 0 1
        @         F F F F F F F E 0 0 0 0 0 0 0 1
	push {r2-r7,lr}
        cmp r0, # 0
        beq __cheng_fa_fan_hui
        cmp r1, # 0
        beq __cheng_fa_fan_hui
__ji_suan_cheng_fa:	
	mov r2, r0
	mov r3, r1
	lsrs r0, r0, # 16	@高16
	lsls r2, r2, # 16	@ 低16
	lsrs r2, r2, # 16
        lsrs r1, r1, # 16	@高16
	lsls r3, r3, # 16	@低16
	lsrs r3, r3, # 16
	mov r4, r2		
	mov r5, r0		
	muls r2, r2, r3		@1
	muls r0, r0, r3		@2
	muls r4, r4, r1		@3
	muls r5, r5, r1		@4
	mov r6, r0		@2
	mov r7, r4		@3
	lsls r0, r0, # 16	@2低
	lsls r4, r4, # 16	@3低
	lsrs r6, r6, # 16	@2高
	lsrs r7, r7, # 16	@3高
	adds r2, r2, r0
	adcs r2, r2, r4
	adcs r5, r5, r6
	adcs r5, r5, r7
	mov r0, r5
	mov r1, r2
	pop {r2-r7,pc}
__cheng_fa_fan_hui:
	movs r0, # 0
	movs r1, # 0
	pop {r2-r7,pc}
__dai_yu_shu_chufa:                         @软件除法
        @ r0 除以 r1 等于 商(r0)余R1
        push {r2-r4,lr}
        cmp r0, # 0
        beq __dai_yu_shu_chufafanhui
        cmp r1, # 0
        beq __dai_yu_shu_chufafanhui
        mov r2, r0
        movs r3, # 1
        lsls r3, r3, # 31
        movs r0, # 0
        mov r4, r0
__dai_yu_shu_chufaxunhuan:
        lsls r2, r2, # 1
        adcs r4, r4, r4
        cmp r4, r1
        bcc __dai_yu_shu_chufaweishubudao0
	adds r0, r0, r3
        subs r4, r4, r1
__dai_yu_shu_chufaweishubudao0:
        lsrs r3, r3, # 1
        bne __dai_yu_shu_chufaxunhuan
__dai_yu_shu_chufafanhui:
        pop {r2-r4,pc}

_chufa:				@软件除法
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
__he_cheng_dian_ya_biao:
	push {r0-r5,lr}
        ldr r0, = dianyabiao
	subs r0, r0, # 0x08
__zhao_shang_sheng:
        adds r0, r0, # 0x08
        ldrh r2, [r0, # 0x04]
        ldrh r3, [r0, # 0x06]
        subs r3, r3, r2
        bmi __zhao_shang_sheng
        ldrh r2, [r0, # 0x0c]
        ldrh r3, [r0, # 0x0e]
        subs r3, r3, r2
	bpl __zhao_shang_sheng
	ldr r1, = dianyabiaozhizhen
	str r0, [r1]
        ldr r1, = 256
        lsls r1, r1, # 2
        movs r2, # 0
__fu_zhi_xun_huan:
        ldr r3, [r0, r2]
        mov r4, r3
        lsls r3, r3, # 16
        lsrs r3, r3, # 16
        lsrs r4, r4, # 16
	subs r3, r3, r4
        bpl __bao_cun
        mvns r3, r3
        adds r3, r3, # 1
        bl __zhuan_bcd
        ldr r4, = 0x80000000
        orrs r3, r3, r4
        b __fu_shu_bao_cun
__bao_cun:
	bl __zhuan_bcd
__fu_shu_bao_cun:
        str r3, [r0, r2]
	adds r2, r2, # 4
	cmp r2, r1
        bne __fu_zhi_xun_huan
	pop {r0-r5,pc}
__jian_bo:
       push {r0-r5,lr}
        ldr r0, = dianyabiao
	subs r0, r0, # 0x08
__zhao_shang_sheng1:
        adds r0, r0, # 0x08
        ldrh r2, [r0, # 0x04]
        ldrh r3, [r0, # 0x06]
        subs r3, r3, r2
	bmi __zhao_shang_sheng1
        ldrh r2, [r0, # 0x0c]
        ldrh r3, [r0, # 0x0e]
        subs r3, r3, r2
        bpl __zhao_shang_sheng1
        ldr r1, = dianyabiaozhizhen
        str r0, [r1]
        ldr r1, = 256
        lsls r1, r1, # 2
        movs r2, # 0
__fu_zhi_xun_huan1:
        ldr r3, [r0, r2]
        mov r4, r3
        lsls r3, r3, # 16
        lsrs r3, r3, # 16
        lsrs r4, r4, # 16
        subs r3, r3, r4
        str r3, [r0, r2]
	adds r2, r2, # 4
	cmp r2, r1
        bne __fu_zhi_xun_huan1
	pop {r0-r5,pc}

__zhuan_bcd:
	push {r0-r2,r4-r7,lr}
	movs r1, # 10
	mov r0, r3
	mov r5, r3
	movs r6, # 8
__bcd_xun_huan:
	bl _chufa
	mov r4, r0
	muls r4, r4, r1
	subs r5, r5, r4
	push {r5}
	mov r5, r0
	subs r6, r6, # 1
	bne __bcd_xun_huan
	pop {r0-r7}
	lsls r6, r6, # 4
	lsls r5, r5, # 8
	lsls r4, r4, # 12
	lsls r3, r3, # 16
	lsls r2, r2, # 20
	lsls r1, r1, # 24
	lsls r0, r0, # 28
	orrs r3, r3, r0
	orrs r3, r3, r1
	orrs r3, r3, r2
	orrs r3, r3, r4
	orrs r3, r3, r5
	orrs r3, r3, r6
	orrs r3, r3, r7
	pop {r0-r2,r4-r7,pc}
	.ltorg
_nmi_handler:
	bx lr
_hard_fault:
	bx lr
_svc_handler:
	bx lr
_pendsv_handler:
	bx lr
_systickzhongduan:
aaa:
	bx lr
__dma_wan:
@	bl __he_cheng_dian_ya_biao
@	bkpt # 22
	push {r0-r7,lr}
	bl __dft
	ldr r0, = fan_she_shi_bu
	ldr r3, [r0]
        ldr r0, = lvboqihuanchong
        ldr r1, = 8
        ldr r2, = lvboqizhizhen
        bl _lvboqi
	ldr r1, = fanshe_r
	str r0, [r1]
	
	ldr r1, = fan_she_xu_bu
	ldr r3, [r1]
        ldr r0, = lvboqihuanchong1
        ldr r1, = 8
        ldr r2, = lvboqizhizhen1
        bl _lvboqi
	ldr r2, = fanshe_r
	ldr r1, = fanshe_i
	ldr r3, [r2]
	str r0, [r1]
b zz
	ldr r2, = fanshe_r
	ldr r1, = fanshe_i
	ldr r3, [r2]
	ldr r0, [r1]
	ldr r4, = 32204		@cos
	ldr r5, = 6049	 	@sin
	mov r6, r4
	mov r7, r5
	muls r4, r4, r3		@x*cos
	muls r6, r6, r0		@y*cos
	muls r5, r5, r3		@x*sin
	muls r7, r7, r0		@y*sin
	asrs r4, r4, # 15
	asrs r5, r5, # 15
	asrs r6, r6, # 15
	asrs r7, r7, # 15

	adds r4, r4, r7		@x
	subs r6, r6, r5		@y
	str r6, [r1]		@i
	str r4, [r2]		@r
zz:	
	ldr r2, = ru_she_shi_bu
	ldr r3, [r2]
        ldr r0, = lvboqihuanchong2
        ldr r1, = 8
        ldr r2, = lvboqizhizhen2
        bl _lvboqi
	ldr r1, = rushe_r
	str r0, [r1]
	mov r6, r0
	ldr r3, = ru_she_xu_bu
       ldr r3, [r3]
        ldr r0, = lvboqihuanchong3
        ldr r1, = 8
        ldr r2, = lvboqizhizhen3
        bl _lvboqi
	ldr r1, = rushe_i
	str r0, [r1]

	ldr r0, = fanshe_r
	ldr r1, = fanshe_i
	ldr r2, = rushe_r
	ldr r3, = rushe_i
	ldr r0, [r0]
	ldr r1, [r1]
	ldr r2, [r2]
	ldr r3, [r3]
	bl __fu_shu_chu_fa
	ldr r0, = p_shibu
	ldr r3, = p_xubu
	str r2, [r0]
	str r1, [r3]

@	b dfdf
	bl __osm_jiao_zhun
	ldr r0, = p_shibu
	ldr r3, = p_xubu
	str r2, [r0]
	str r1, [r3]
dfdf:	
	movs r4, r2
	movs r5, r1
	ldr r0, = 1000
	movs r1, # 0
	mov r2, r0
	movs r3, # 0
	adds r0, r0, r4
	adds r1, r1, r5
	subs r2, r2, r4
	subs r3, r3, r5
	bl __fu_shu_chu_fa
	ldr r6, = swr_shibu
	ldr r5, = swr_xubu
	str r2, [r6]
	str r1, [r5]
	ldr r3, = 0x4000	@Q15 0.5
	muls r1, r1, r3
	muls r3, r3, r2
	asrs r1, r1, # 15
	asrs r3, r3, # 15
	ldr r2, = dianzu
        str r3, [r2]
        ldr r2, = diankang
        str r1, [r2]
@	mov r0, r3
@	bl __atan2_ji_suan
@	ldr r1, = jiaodu
@	str r0, [r1]
@	bl __chuan_lian_zhuan_bing_lian
@	bl __fu_jie_dian_chang_shu
__dma_fan_hui:	
	ldr r0, = 0x40020000
        movs r2, # 2
	str r2, [r0, # 0x04]
	ldr r0, = dianyabiaoman
	movs r1, # 1
	str r1, [r0]
	pop {r0-r7,pc}
	.ltorg
	.end
