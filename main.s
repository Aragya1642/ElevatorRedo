	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s      

	IMPORT 	System_Clock_Init
	IMPORT 	UART2_Init
	IMPORT	USART2_Write
	IMPORT	hex_update
	IMPORT	light_update
	IMPORT	parser
	IMPORT	floors
	IMPORT	motor_up
	IMPORT	motor_down
	IMPORT	keypad_scan

	
	AREA    main, CODE, READONLY
	EXPORT	__main				; make __main visible to linker
	ENTRY			
				
__main	PROC
	
	BL System_Clock_Init
	BL UART2_Init
	
clock_init
	; Set up all GPIO Clocks - ABCD
	LDR r0, =RCC_BASE
	LDR r1, [r0, #RCC_AHB2ENR]
	BIC r1, #0x0000000F
	ORR r1, #0x0000000F
	STR r1, [r0, #RCC_AHB2ENR]
	
	LDR r1, [r0, #RCC_APB2ENR]
	ORR r1, #RCC_APB2ENR_SYSCFGEN
	STR r1, [r0, #RCC_APB2ENR]
	
hex_init	
	; Set pins as output
	LDR r0, =GPIOA_BASE
	LDR r1, [r0, #GPIO_MODER]
	BIC r1, #0x0000000F
	ORR r1, #0x00000005
	STR r1, [r0, #GPIO_MODER]
	
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_MODER]
	BIC r1, #0x00F00000
	ORR r1, #0x00400000
	STR r1, [r0, #GPIO_MODER]
	
	LDR r0, =GPIOD_BASE
	LDR r1, [r0, #GPIO_MODER]
	BIC r1, #0x000000F0
	ORR r1, #0x00000010
	STR r1, [r0, #GPIO_MODER]
	
led_init
	; Set pins as output
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_MODER]
	BIC r1, #0x0000000F
	BIC r1, #0x000000F0
	ORR r1, #0x00000005
	ORR r1, #0x00000050
	STR r1, [r0, #GPIO_MODER]
	
	; Set pins to push pull
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_OTYPER]
	BIC r1, #0xF
	STR r1, [r0, #GPIO_OTYPER]
	
callButton_init
    ; Set pins as input
    LDR r0, =GPIOA_BASE
    LDR r1, [r0, #GPIO_MODER]
    BIC r1, #0x00000300
    STR r1, [r0, #GPIO_MODER]

    LDR r0, =GPIOC_BASE
    LDR r1, [r0, #GPIO_MODER]
    BIC r1, #0x0C000000
    STR r1, [r0, #GPIO_MODER]

    LDR r0, =GPIOB_BASE
    LDR r1, [r0, #GPIO_MODER]
    BIC r1, #0x0000C000
    BIC r1, #0x00000003
    STR r1, [r0, #GPIO_MODER]

    ; Set pins to pull up
    LDR r0, =GPIOC_BASE
    LDR r1, [r0, #GPIO_PUPDR]
    BIC r1, #0x0C000000
    ORR r1, #0x04000000
    STR r1, [r0, #GPIO_PUPDR]

    LDR r0, =GPIOB_BASE
    LDR r1, [r0, #GPIO_PUPDR]
    BIC r1, #0x0000C000
    BIC r1, #0x00000003
    ORR r1, #0x00004000
    ORR r1, #0x00000001
    STR r1, [r0, #GPIO_PUPDR]

    LDR r0, =GPIOA_BASE
    LDR r1, [r0, #GPIO_PUPDR]
    BIC r1, #0x00000300
    ORR r1, #0x00000100
    STR r1, [r0, #GPIO_PUPDR]
	
stepper1_init
	; Set pins as output
	LDR r0, =GPIOA_BASE
	LDR r1, [r0, #GPIO_MODER]
	BIC r1, #0x00003000
	ORR r1, #0x00001000
	STR r1, [r0, #GPIO_MODER]
	
	LDR r0, =GPIOB_BASE
	LDR r1, [r0, #GPIO_MODER]
	BIC r1, #0x000F0000
	ORR r1, #0x00050000
	STR r1, [r0, #GPIO_MODER]
	
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_MODER]
	BIC r1, #0x000C0000
	ORR r1, #0x00040000
	STR r1, [r0, #GPIO_MODER]
	
stepper2_init
	; Set pins as output
	LDR r0, =GPIOA_BASE
	LDR r1, [r0, #GPIO_MODER]
	BIC r1, #0x30000000
	BIC r1, #0x0C000000
	ORR r1, #0x10000000
	ORR r1, #0x04000000
	STR r1, [r0, #GPIO_MODER]
	
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_MODER]
	BIC r1, #0x03000000
	BIC r1, #0x00300000
	ORR r1, #0x01100000
	STR r1, [r0, #GPIO_MODER]

special_button_init
	; Set pins as input
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_MODER]
	BIC r1, #0x00002000
	BIC r1, #0x00000C00
	STR r1, [r0, #GPIO_MODER]
	
	; Set as "no pull up and no pull down"
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_PUPDR]
	BIC r1, #0x00002000
	BIC r1, #0x00000C00
	STR r1, [r0, #GPIO_PUPDR]
	
row_int 
    ;output
    ;R1 C4,R2 B13, R3 B14, R4 B15
    LDR r0, =GPIOB_BASE
    LDR r1, [r0, #GPIO_MODER]
    BIC r1, #0xFC000000
    ORR r1, #0x54000000
    STR r1, [r0, #GPIO_MODER]
    LDR r0, =GPIOC_BASE
    LDR r1, [r0, #GPIO_MODER]
    BIC r1, #0x00000300
    ORR r1, #0x00000100
	STR r1, [r0, #GPIO_MODER]
col_int 
    ;input pull up 
    ;C4 A11, C3 B12, C2 B11, C1 B2
    LDR r0, =GPIOB_BASE
    LDR r1, [r0, #GPIO_MODER]
    BIC r1, #0x03C00000
    BIC r1, #0x00000030
    STR r1, [r0, #GPIO_MODER]

    LDR r1, [r0, #GPIO_PUPDR]
    BIC r1, #0x03C00000
	BIC r1, #0x00000030
    ORR r1, #0x01400000
	ORR r1, #0x00000010
    STR r1, [r0, #GPIO_PUPDR]

    LDR r0, =GPIOA_BASE
    LDR r1, [r0, #GPIO_MODER]
    BIC r1, #0x00C00000
    STR r1, [r0, #GPIO_MODER]

    LDR r1, [r0, #GPIO_PUPDR]
    BIC r1, #0x00C00000
    ORR r1, #0x00400000
    STR r1, [r0, #GPIO_PUPDR]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; --------- Main Program
	MOV r10, #0x00000000
	MOV r9, #0x00000000
	MOV r11, #0x00000001
	BL hex_update

myMain
	CMP r10, #0x00000000
	BNE	floors_function
	BEQ parser_function
	
floors_function
	B floors
	CMP r10, #0xFFFFFFFF
	BEQ stop
	B myMain
parser_function
	
	BL parser
	;BL keypad_scan
	
	;BL light_update
	B myMain

	
;	LDR r0, =str   ; First argument
;	MOV r1, #11    ; Second argument
;	BL USART2_Write
  
stop 	B 		stop     		; dead loop & program hangs here

	ENDP

	ALIGN			

	AREA    myData, DATA, READWRITE
	ALIGN
str	DCB   "ECE202\r\n", 0
	END