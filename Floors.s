	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s

	IMPORT light_update
	IMPORT floor_4
	IMPORT floor_3
	IMPORT floor_2
	IMPORT floor_1
		
	AREA    Floors, CODE, READONLY
	EXPORT	floors			; make __main visible to linker
	ENTRY
	
floors PROC
	; Admin Reset
	CMP r10, #0xFFFFFFFF
	BEQ floor_1
	
	; Check for floor 4
	CMP r10, #0x00000008
	BEQ floor_4
	
	; Check for floor 3
	CMP r10, #0x00000004
	BEQ floor_3
	
	; Check for floor 2
	CMP r10, #0x00000002
	BEQ floor_2
	
	; Check for floor 1
	CMP r10, #0x00000001
	BEQ floor_1
	
	
	BX LR
	ENDP
	END