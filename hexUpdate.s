	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s  
	
	IMPORT USART2_Write
	
	AREA    hexUpdate, CODE, READONLY
	EXPORT	hex_update			; make __main visible to linker
	ENTRY
	
hex_update PROC
	CMP r11, #0x1
	BEQ hex_1
	CMP r11, #0x2
	BEQ hex_2
	CMP r11, #0x4
	BEQ hex_3
	CMP r11, #0x8
	BEQ hex_4
	
hex_1
	LDR r0, =GPIOA_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x3
	ORR r1, #0x2
	STR r1, [r0, #GPIO_ODR]
	
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x800
	STR r1, [r0, #GPIO_ODR]
	
	LDR r0, =GPIOD_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x4
	STR r1, [r0, #GPIO_ODR]
	
	
	B hex_endl
hex_2
	LDR r0, =GPIOA_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x3
	STR r1, [r0, #GPIO_ODR]
	
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x800
	ORR r1, #0x800
	STR r1, [r0, #GPIO_ODR]
	
	LDR r0, =GPIOD_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x4
	STR r1, [r0, #GPIO_ODR]
	B hex_endl
hex_3
	LDR r0, =GPIOA_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x3
	ORR r1, #0x2
	STR r1, [r0, #GPIO_ODR]
	
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x800
	ORR r1, #0x800
	STR r1, [r0, #GPIO_ODR]
	
	LDR r0, =GPIOD_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x4
	STR r1, [r0, #GPIO_ODR]
	B hex_endl
hex_4
	LDR r0, =GPIOA_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x3
	STR r1, [r0, #GPIO_ODR]
	
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x800
	STR r1, [r0, #GPIO_ODR]
	
	LDR r0, =GPIOD_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x4
	ORR r1, #0x4
	STR r1, [r0, #GPIO_ODR]
	B hex_endl
hex_endl
	
	
	BX LR
	
	ENDP
	END