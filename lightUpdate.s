	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s  
		
	AREA    lightUpdate, CODE, READONLY
	EXPORT	light_update			; make __main visible to linker
	ENTRY
	
light_update PROC
	; Get the base address
	LDR r0, =GPIOC_BASE
	LDR r1, [r0, #GPIO_ODR]
	
	; Admin reset
	CMP r10, #0xFFFFFFFF
	BEQ admin_lights
	BNE light_compare
admin_lights
	BIC r1, #0xF
	ORR r1, #0x00000002
	B light_endl
	
light_compare
	; Compare
	CMP r10, #0x00000000
	BICEQ r1, #0xF
	
	AND r3, r10, #0x00000001
	CMP r3, #0x00000001
	BEQ L1
	BNE next_L1
L1
	ORR r1, #0x00000002

next_L1
	AND r3, r10, #0x00000002
	CMP r3, #0x00000002
	BEQ L2
	BNE next_L2
L2
	ORR r1, #0x00000001

next_L2
	AND r3, r10, #0x00000004
	CMP r3, #0x00000004
	BEQ L3
	BNE next_L3
L3
	ORR r1, #0x00000008

next_L3
	AND r3, r10, #0x00000008
	CMP r3, #0x00000008
	BEQ L4
	BNE next_L4
L4
	ORR r1, #0x00000004
next_L4
light_endl
	STR r1, [r0, #GPIO_ODR]
	
	BX LR
	
	ENDP
	END