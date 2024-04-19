	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s

	IMPORT light_update
	IMPORT keypad_scan
	
		
	AREA    Parse, CODE, READONLY
	EXPORT	parser			; make __main visible to linker
	ENTRY
	
parser PROC
	; Admin Button
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_IDR]
	AND r2, r1, #0x00000020
	CMP r2, #0x00000020
	BNE admin_reset
	BEQ start_parse
admin_reset
	AND r10, #0x00000000
	ORR r10, #0xFFFFFFFF
	BNE Parse_endl
	
start_parse
	; First button
	LDR r0, =GPIOB_BASE
	LDR r1, [r0, #GPIO_IDR]
	AND r2, r1, #0x0000080
	CMP r2, #0x00000080
	BNE parse_1
	BEQ parse_next_1
parse_1
	ORR r10, #0x00000008
	
parse_next_1
	; Second button
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_IDR]
	AND r2, r1, #0x00002000
	CMP r2, #0x00002000
	BNE parse_2
	BEQ parse_next_2
parse_2
	ORR r10, #0x00000004
	
parse_next_2
	; Third button
	LDR r0, =GPIOA_BASE
	LDR r1, [r0, #GPIO_IDR]
	AND r2, r1, #0x00000010
	CMP r2, #0x00000010
	BNE parse_3
	BEQ parse_next_3
parse_3
	ORR r10, #0x00000002

parse_next_3
	; Bottommost button
	LDR r0, =GPIOB_BASE
	LDR r1, [r0, #GPIO_IDR]
	AND r2, r1, #0x00000001
	CMP r2, #0x00000001
	BNE parse_4
	BEQ parse_next_4
parse_4
	ORR r10, #0x00000001
parse_next_4
Parse_endl
	PUSH {LR}
	BL light_update
	POP {LR}
	BX LR
	ENDP
	END