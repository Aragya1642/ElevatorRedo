	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s  
		
	IMPORT light_update
		
	AREA    motorUp, CODE, READONLY
	EXPORT	motor_up			; make __main visible to linker
	ENTRY
	
motor_up PROC
up_loop
	MOV r7, #0x0 	;resting default values
	MOV r5, #0x0
	MOV r1 , #108
	B up_step	
up_step_loop	
	ADD r5, r5 ,#0x1
	CMP r5,r1
	BNE up_step
	BEQ motor_up_endl
up_step
	LDR r2, =GPIOA_BASE
    LDR r3, [r2, #GPIO_ODR]
	LDR r2, =GPIOC_BASE
	LDR r4, [r2, #GPIO_ODR]
    ; Clear pins A13, A14, C12, and C10
    BIC r3, #0x6000
	BIC r4,#0x1000
	BIC r4,#0x0400
	;A
	ORR r3, #0x2000 ;first step
	;C
	ORR r4, #0x0400

	LDR r2, =GPIOA_BASE
	STR r3, [r2, #GPIO_ODR]  	; Updating the output pins
	LDR r2, =GPIOC_BASE
	STR r4, [r2, #GPIO_ODR]
	BIC r3, #0x6000
	BIC r4,#0x1000
	BIC r4,#0x0400

	;delay
	MOV r0, #0xFFFF	; Initial delay value
up_delay1
    SUB r0, r0, #1  ; Subtracting  delay counter
	CMP r0, #0 
    BNE up_delay1 
	ORR r3, #0x6000 ;first step
	ORR r4, #0x0000
	LDR r2, =GPIOA_BASE
	STR r3, [r2, #GPIO_ODR]  	; Updating the output pins
	LDR r2, =GPIOC_BASE
	STR r4, [r2, #GPIO_ODR]
	BIC r3, #0x6000
	BIC r4,#0x1000
	BIC r4,#0x0400
	MOV r0, #0xFFFF 
up_delay2
    SUB r0, r0, #1  ; Subtracting  delay counter
	CMP r0, #0 
    BNE up_delay2 
	ORR r3, #0x4000 ;first step
	ORR r4, #0x1000
	LDR r2, =GPIOA_BASE
	STR r3, [r2, #GPIO_ODR]  	; Updating the output pins
	LDR r2, =GPIOC_BASE
	STR r4, [r2, #GPIO_ODR]
	BIC r3, #0x6000
	BIC r4,#0x1000
	BIC r4,#0x0400
	MOV r0, #0xFFFF
up_delay3
    SUB r0, r0, #1  ; Subtracting  delay counter
	CMP r0, #0 
    BNE up_delay3 
	ORR r3, #0x0000 ;first step
	ORR r4, #0x1400
	LDR r2, =GPIOA_BASE
	STR r3, [r2, #GPIO_ODR]  	; Updating the output pins
	LDR r2, =GPIOC_BASE
	STR r4, [r2, #GPIO_ODR]
	BIC r3, #0x6000
	BIC r4,#0x1000
	BIC r4,#0x0400
	MOV r0, #0xFFFF 
up_delay4
    SUB r0, r0, #1  ; Subtracting  delay counter
	CMP r0, #0 
    BNE up_delay4
	B up_step_loop	
motor_up_endl
	BX LR
	ENDP
	END