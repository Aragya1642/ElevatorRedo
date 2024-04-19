	INCLUDE core_cm4_constants.s		; Load Constant Definitions
	INCLUDE stm32l476xx_constants.s

	IMPORT hex_update
	IMPORT motor_up
	IMPORT light_update
	IMPORT motor_down
	IMPORT door_open
	IMPORT door_close
		
	AREA    Floor1, CODE, READONLY
	EXPORT	floor_1			; make __main visible to linker
	ENTRY
	
floor_1 PROC
	CMP r11, #0x00000008
	BEQ floor_1_from_4
	
	CMP r11, #0x00000004
	BEQ floor_1_from_3
	
	CMP r11, #0x00000002
	BEQ floor_1_from_2
	
	CMP r11, #0x00000001
	BEQ floor_1_from_1

floor_1_from_1
	PUSH {LR}
;	BL door_open
;	BL door_close
	POP {LR}
	B floor_1_call_endl
floor_1_from_2
	PUSH {LR}
	BL motor_down
	MOV r11, #0x00000001
	BL hex_update
;	BL door_open
;	BL door_close
	POP {LR}
	B floor_1_call_endl
floor_1_from_3
	PUSH {LR}
	BL motor_down
	MOV r11, #0x00000002
	BL hex_update
	BL motor_down
	MOV r11, #0x00000001
	BL hex_update
;	BL door_open
;	BL door_close
	POP {LR}
	B floor_1_call_endl
floor_1_from_4
	PUSH {LR}
	BL motor_down
	MOV r11, #0x00000004
	BL hex_update
	BL motor_down
	MOV r11, #0x00000002
	BL hex_update
	BL motor_down
	MOV r11, #0x00000001
	BL hex_update
;	BL door_open
;	BL door_close
	POP {LR}
	B floor_1_call_endl
floor_1_call_endl
	BIC r10, #0x00000001
	PUSH {LR}
	;call keypad function
	BL light_update
	BL door_open
	BL door_close
	POP {LR}
	BX LR	
	ENDP
	END
