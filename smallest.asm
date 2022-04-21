;PROGRAM TO FIND SMALLEST OF N NUMBERS
;================================

.model small
.stack 100H

.data

msg1 db 'enter the number of numbers : $'
msg2 db 'enter the numbers : ',10,13,'$'
msg3 db 'Smallest is  : $'
newline db 10,13, '$'
limit dw ?
small dw ?

.code
.startup   

	MOV DX,offset newline 
	CALL printmsg 
    
    MOV DX,offset msg1
	CALL printmsg       ; Ask for limit

	CALL readnum        ; Read limit
	MOV limit,AX

	MOV DX,offset newline 
	CALL printmsg 

	MOV DX,offset msg2  ; Ask for numbers
	CALL printmsg
	CALL readnum
    
    lsmall:
    	MOV small,AX        ;compare current value with 'small'
    	DEC limit
    	CMP limit,0
    	JE ending

    loop1:
        CALL readnum        

    	CMP AX,small
    	JL lsmall
    

    	DEC limit
    	CMP limit,0
    	JNE loop1

    
    ending:
    	MOV DX,offset msg3
    	CALL printmsg
    	MOV AX,small
    	CALL displayAX    ; display Smallest num

        MOV DX,offset newline 
    	CALL printmsg
.exit

;this will display a message pointed by DX register
printmsg PROC near
    PUSH AX
    MOV AH,09H
    INT 21H
    POP AX
    RET
printmsg ENDP

;Procedure to read a decimal number from the keyboard
;Value is returned through AX


readnum PROC near
	PUSH BX
	PUSH CX         ; Save registers
	MOV BX,0        ; NUM <--0
	MOV CX,10

	Back1:
		MOV AH,01H  ; read a single character
		INT 21H
		CMP AL,'0'
		JB last1
		CMP AL,'9'
		JA last1
		SUB AL,30H   ; convert to digit
		PUSH AX       
		MOV AX,BX
		MUL CX       
		MOV BX,AX    ; NUM <-- NUM x 10
		POP AX
		MOV AH,0
		ADD BX,AX    ; NUM <-- NUM + digit
		JMP Back1

	last1:
		MOV AX,BX
		POP CX      ; Restore registers
		POP BX
		RET
readnum ENDP



;Procedure to display AX in decimal
displayAX PROC near
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX        ; Save registers

	MOV CX,0	   ;count <--0
	MOV BX,10

	Back2:
		MOV DX,0
		DIV BX      ; digit = num%10 
		PUSH DX	  ; num=num/10 push digit 
		INC CX    ; count = count+1
		CMP AX,0  ; if num>0 goto back2
		JNE Back2
	Back3:
		POP DX		;pop digit
		ADD DL,30H    ; convert to ascii
		MOV AH,02H    ; display
		INT 21H
		loop Back3


		POP DX  ; Restore registers
		POP CX
		POP BX
		POP AX
	RET
displayAX ENDP


END