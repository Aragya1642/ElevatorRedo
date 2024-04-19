	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s

	IMPORT hex_update
	IMPORT motor_up
	IMPORT light_update
	IMPORT motor_down
	IMPORT door_open
	IMPORT door_close
	IMPORT keypad_scan
		
	AREA    Floor3, CODE, READONLY
	EXPORT	floor_3			; make __main visible to linker
	ENTRY
	
floor_3 PROC
	CMP r11, #0x00000008
	BEQ floor_3_from_4
	
	CMP r11, #0x00000004
	BEQ floor_3_from_3
	
	CMP r11, #0x00000002
	BEQ floor_3_from_2
	
	CMP r11, #0x00000001
	BEQ floor_3_from_1

floor_3_from_1
	PUSH {LR}
	BL motor_up
	MOV r11, #0x00000002
	BL hex_update
	BL motor_up
	MOV r11, #0x00000004
	BL hex_update
	POP {LR}
	B floor_3_call_endl
floor_3_from_2
	PUSH {LR}
	BL motor_up
	MOV r11, #0x00000004
	BL hex_update
	POP {LR}
	B floor_3_call_endl
floor_3_from_3
	PUSH {LR}
	POP {LR}
	B floor_3_call_endl
floor_3_from_4
	PUSH {LR}
	BL motor_down
	MOV r11, #0x00000004
	BL hex_update
	POP {LR}
	B floor_3_call_endl
floor_3_call_endl
	BIC r10, #0x00000004
	PUSH {LR}
	BL light_update
	BL door_open
	BL keypad_scan
	BL door_close
	POP {LR}
	BX LR	
	ENDP
	END
