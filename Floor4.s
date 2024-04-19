	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s

	IMPORT hex_update
	IMPORT motor_up
	IMPORT light_update
	IMPORT door_open
	IMPORT door_close
		
	AREA    Floor4, CODE, READONLY
	EXPORT	floor_4			; make __main visible to linker
	ENTRY
	
floor_4 PROC
	CMP r11, #0x00000008
	BEQ floor_4_from_4
	
	CMP r11, #0x00000004
	BEQ floor_4_from_3
	
	CMP r11, #0x00000002
	BEQ floor_4_from_2
	
	CMP r11, #0x00000001
	BEQ floor_4_from_1
	
floor_4_from_4
	PUSH {LR}
	;BL door_open
	;BL door_close
	POP {LR}
	B floor_4_call_endl
floor_4_from_3
	PUSH {LR}
	BL motor_up
	MOV r11, #0x00000008
	BL hex_update
;	BL door_open
;	BL door_close
	POP {LR}
	B floor_4_call_endl
floor_4_from_2
	PUSH {LR}
	BL motor_up
	MOV r11, #0x00000004
	BL hex_update
	BL motor_up
	MOV r11, #0x00000008
	BL hex_update
;	BL door_open
;	BL door_close
	POP {LR}
	B floor_4_call_endl
floor_4_from_1
	PUSH {LR}
	BL motor_up
	MOV r11, #0x00000002
	BL hex_update
	BL motor_up
	MOV r11, #0x00000004
	BL hex_update
	BL motor_up
	MOV r11, #0x00000008
	BL hex_update
;	BL door_open
;	BL door_close
	POP {LR}
	B floor_4_call_endl
floor_4_call_endl
	BIC r10, #0x00000008
	PUSH {LR}
	BL light_update
	POP {LR}
	BX LR
	ENDP
	END