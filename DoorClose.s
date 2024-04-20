	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s  
		
	IMPORT light_update
		
	AREA    doorClose, CODE, READONLY
	EXPORT	door_close			; make __main visible to linker
	ENTRY
	
door_close PROC
close_loop
	MOV r7, #0x0    ;resting default values
	MOV r5, #0x0
	MOV r9 , #200
	B close_step 
close_step_loop         
    ADD r7, r7 ,#0x1
    CMP r7,r9
	BNE close_step
	BEQ close_door_endl
close_step
	LDR r2, =GPIOA_BASE
    LDR r3, [r2, #GPIO_ODR]
	LDR r2, =GPIOB_BASE
	LDR r4, [r2, #GPIO_ODR]
	LDR r2, =GPIOC_BASE
	LDR r5, [r2, #GPIO_ODR]
	; Clear pins A6, B9, B8, and C9
	BIC r3, r3, #0x40
	BIC r4, r4, #0x300
	BIC r5, r5, #0x200 
    ORR r3, #0x000 ;first step
    ;B
	ORR r4, #0x100
	;C
	ORR r5, #0x200
    LDR r2, =GPIOA_BASE
	STR r3, [r2, #GPIO_ODR]            ; Updating the output pins
	LDR r2, =GPIOB_BASE
	STR r4, [r2, #GPIO_ODR]
	LDR r2, =GPIOC_BASE
	STR r5, [r2, #GPIO_ODR]
	BIC r3, r3, #0x40
	BIC r4, r4, #0x300
	BIC r5, r5, #0x200
	;delay
	MOV r0, #0xFFFF           ; Initial delay value
close_delay1
    SUB r0, r0, #1  ; Subtracting  delay counter
	CMP r0, #0
    BNE close_delay1                      
	ORR r3, #0x000 ;first step
	;B
	ORR r4, #0x300
	;C
	ORR r5, #0x000
	LDR r2, =GPIOA_BASE
	STR r3, [r2, #GPIO_ODR]            ; Updating the output pins
	LDR r2, =GPIOB_BASE
	STR r4, [r2, #GPIO_ODR]
	LDR r2, =GPIOC_BASE
	STR r5, [r2, #GPIO_ODR]
	BIC r3, r3, #0x40
	BIC r4, r4, #0x300
	BIC r5, r5, #0x200
	MOV r0, #0xFFFF
close_delay2
    SUB r0, r0, #1  ; Subtracting  delay counter
	CMP r0, #0
    BNE close_delay2
	ORR r3, #0x40 ;first step
	;B
	ORR r4, #0x200
	;C
	ORR r5, #0x000
	LDR r2, =GPIOA_BASE
	STR r3, [r2, #GPIO_ODR]            ; Updating the output pins
	LDR r2, =GPIOB_BASE
	STR r4, [r2, #GPIO_ODR]
	LDR r2, =GPIOC_BASE
	STR r5, [r2, #GPIO_ODR]
	BIC r3, r3, #0x40
	BIC r4, r4, #0x300
	BIC r5, r5, #0x200
	MOV r0, #0xFFFF
close_delay3
    SUB r0, r0, #1  ; Subtracting  delay counter
	CMP r0, #0
    BNE close_delay3
	; A
	ORR r3, #0x40 ;first step
	;B
	ORR r4, #0x000
	;C
	ORR r5, #0x200
	LDR r2, =GPIOA_BASE
	STR r3, [r2, #GPIO_ODR]            ; Updating the output pins
	LDR r2, =GPIOB_BASE
	STR r4, [r2, #GPIO_ODR]
	LDR r2, =GPIOC_BASE
	STR r5, [r2, #GPIO_ODR]
	BIC r3, r3, #0x40
	BIC r4, r4, #0x300
	BIC r5, r5, #0x200
	MOV r0, #0xFFFF
close_delay4
    SUB r0, r0, #1  ; Subtracting  delay counter
	CMP r0, #0
    BNE close_delay4
	B close_step_loop
close_door_endl
	BX LR
		
	ENDP
	END