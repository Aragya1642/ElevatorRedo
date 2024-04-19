	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s  
		
	IMPORT light_update
		
	AREA    doorOpen, CODE, READONLY
	EXPORT	door_open			; make __main visible to linker
	ENTRY
	
door_open PROC
open_loop
	MOV r7, #0x0    ;resting default values
	MOV r5, #0x0
	MOV r9 , #108
	B open_step 
open_step_loop         
	ADD r5, r5 ,#0x1
	CMP r5,r9
	BNE open_step
	BEQ open_door_endl
open_step
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
	;delay
	MOV r0, #0xFFFF             ; Initial delay value
open_delay1
    SUB r0, r0, #1  ; Subtracting  delay counter
	CMP r0, #0
    BNE open_delay1   
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
	BIC r5, #0x200
	MOV r0, #0xFFFF
open_delay2
    SUB r0, r0, #1  ; Subtracting  delay counter
    CMP r0, #0
    BNE open_delay2
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
open_delay3
    SUB r0, r0, #1  ; Subtracting  delay counter
    CMP r0, #0
    BNE open_delay3
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
	MOV r0, #0xFFFF
open_delay4
    SUB r0, r0, #1  ; Subtracting  delay counter
	CMP r0, #0
    BNE open_delay4
	B open_step_loop
open_door_endl
	BX LR	
	
	ENDP
	END