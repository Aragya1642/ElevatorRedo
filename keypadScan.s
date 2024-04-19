	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s

	IMPORT light_update
		
	AREA    keypadScan, CODE, READONLY
	EXPORT	keypad_scan			; make __main visible to linker
	ENTRY
	
keypad_scan PROC
	MOV r9, #0x00000FF0
loop
	; Set all row outputs to 0
	LDR r0, =GPIOB_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0xE000
	STR r1, [r0, #GPIO_ODR]
	
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x10
	STR r1, [r0, #GPIO_ODR]
	
	SUB r9, #1
	CMP r9,#0
	BEQ return_keypad
	BNE keep_going
return_keypad
	BX LR
keep_going	
	MOV r0, #9999
delay1
	SUB r0, r0, #1              
	CMP r0, #0 
    BNE delay1
	
	; Check if all column inputs are 1
	LDR r2, =GPIOB_BASE
	MOV r0, #0x1804
	LDR r3, [r2, #GPIO_IDR]
	AND r3, r0
	LDR r2, =GPIOA_BASE
	LDR r4, [r2, #GPIO_IDR]
	AND r4, #0x800
	ADD r5, r4,r3
	MOV r0, #0x2004
	CMP r5, r0
	BEQ loop ; no keys are pressed 
	BNE testRow1
	
testRow1
	; Set the first row to 0
	LDR r0, =GPIOB_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0xE000
	ORR r1, #0xE000
	STR r1, [r0, #GPIO_ODR]
	
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x10
	ORR r1, #0x00
	STR r1, [r0, #GPIO_ODR]
	
	;software debouncing
	MOV r0, #9999
delay2
	SUB r0, r0, #1              
	CMP r0, #0 
    BNE delay2
	; reading col values
	LDR r2, =GPIOB_BASE
	MOV r0, #0x1804
	LDR r3, [r2, #GPIO_IDR]
	AND r3, r0
	LDR r2, =GPIOA_BASE
	LDR r4, [r2, #GPIO_IDR]
	AND r4, #0x800
	ADD r5, r4,r3
	MOV r0, #0x2004
	CMP r5, r0
	
	MOV r6, #0x00
	; if value is equal that means nothing is being presssed down in row 1 
	BEQ testRow2
	; somthing is being presed in row 1, must check what col it is
	BNE testCols

testRow2
	; Set the second row to 0
	LDR r0, =GPIOB_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0xE000
	ORR r1, #0xC000
	STR r1, [r0, #GPIO_ODR]
	
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x10
	ORR r1, #0x10
	STR r1, [r0, #GPIO_ODR]
	
	MOV r0, #9999
delay3
	SUB r0, r0, #1              
	CMP r0, #0 
    BNE delay3
	
	LDR r2, =GPIOB_BASE
	MOV r0, #0x1804
	LDR r3, [r2, #GPIO_IDR]
	AND r3, r0
	LDR r2, =GPIOA_BASE
	LDR r4, [r2, #GPIO_IDR]
	AND r4, #0x800
	ADD r5, r4,r3
	MOV r0, #0x2004
	CMP r5, r0
	
	MOV r6, #0x10

	BEQ testRow3
	BNE testCols
	
testRow3
	; Set the third row to 0
	LDR r0, =GPIOB_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0xE000
	ORR r1, #0xA000
	STR r1, [r0, #GPIO_ODR]
	
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x10
	ORR r1, #0x10
	STR r1, [r0, #GPIO_ODR]
	
	MOV r4, #9999
delay4
	SUB r4, r4, #1              
	CMP r4, #0 
    BNE delay4
	
	LDR r2, =GPIOB_BASE
	MOV r0, #0x1804
	LDR r3, [r2, #GPIO_IDR]
	AND r3, r0
	LDR r2, =GPIOA_BASE
	LDR r4, [r2, #GPIO_IDR]
	AND r4, #0x800
	ADD r5, r4,r3
	MOV r0, #0x2004
	CMP r5, r0
	
	MOV r6, #0x20
	BEQ testRow4
	BNE testCols
	
testRow4
	; Set the third row to 0
	LDR r0, =GPIOB_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0xE000
	ORR r1, #0x6000
	STR r1, [r0, #GPIO_ODR]
	
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_ODR]
	BIC r1, #0x10
	ORR r1, #0x10
	STR r1, [r0, #GPIO_ODR]
	
	MOV r4, #9999
delay5
	SUB r4, r4, #1              
	CMP r4, #0 
    BNE delay5
	
	LDR r2, =GPIOB_BASE
	MOV r0, #0x1804
	LDR r3, [r2, #GPIO_IDR]
	AND r3, r0
	LDR r2, =GPIOA_BASE
	LDR r4, [r2, #GPIO_IDR]
	AND r4, #0x800
	ADD r5, r4,r3
	MOV r0, #0x2004
	CMP r5, r0
	MOV r6, #0x30
	BEQ loop
	BNE testCols

testCols 
testCol1
	LDR r2, =GPIOB_BASE
	LDR r3, [r2, #GPIO_IDR]
	AND r3, #0x4
	CMP r3, #0x0 
	MOV r7, #0x00 ; setting col val for later
	BEQ keyPressed ; if CMP is true a col 1 key is pressed 
	BNE testCol2
	
	; same logic is used just differnt masks 
testCol2
	LDR r2, =GPIOB_BASE
	LDR r3, [r2, #GPIO_IDR]
	AND r3, #0x800
	CMP r3, #0x000 
	MOV r7, #0x01
	BEQ keyPressed
	BNE testCol3
	
testCol3
	LDR r2, =GPIOB_BASE
	LDR r3, [r2, #GPIO_IDR]
	AND r3, #0x1000
	CMP r3, #0x0000
	MOV r7, #0x02
	BEQ keyPressed
	BNE testCol4

testCol4
	LDR r2, =GPIOA_BASE
	LDR r3, [r2, #GPIO_IDR]
	AND r3, #0x800
	CMP r3, #0x000
	MOV r7, #0x03
	BEQ keyPressed
	BNE loop

keyPressed

	; row and col left bit is row and right bit is col
	ADD r8,r6,r7

	CMP r8,#0x00
	BEQ B1
	CMP r8,#0x01
	BEQ B2
	CMP r8,#0x02
	BEQ B3
	CMP r8,#0x03
	BEQ BA

	CMP r8,#0x10
	BEQ B4
	CMP r8,#0x11
	BEQ B5
	CMP r8,#0x12
	BEQ B6
	CMP r8,#0x13
	BEQ BB

	CMP r8,#0x20
	BEQ B7
	CMP r8,#0x21
	BEQ B8
	CMP r8,#0x22
	BEQ B9
	CMP r8,#0x23
	BEQ BC

	CMP r8,#0x30
	BEQ Bstar
	CMP r8,#0x31
	BEQ B0
	CMP r8,#0x32
	BEQ Bhash
	CMP r8,#0x33
	BEQ BD

; ASCII 
B1
	ORR r10, #0x00000001
	B BD
B2
	ORR r10, #0x00000002
	B BD
B3
	ORR r10, #0x00000004
	B BD
B4
	ORR r10, #0x00000008
	B BD
BA
B5
B6
BB
B7
B8
B9
BC
Bstar
B0
Bhash
BD
	BX LR
	ENDP
	END