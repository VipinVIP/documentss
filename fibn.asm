.model small
.stack 100h

.data 
msg1 db 'enter the number of numbers : $'
newline db 10,13, '$'
space db ' $'

limit dw ?

.code
.startup
	CALL prtnewln
    MOV DX,offset msg1  
    CALL displaymsg

    CALL readnum		;Accept the limit
    MOV limit,AX
	
	CALL prtnewln
    call fibn


.exit

fibn PROC NEAR 
    MOV AX,0
    MOV BX,1
    MOV CX,0
    mainloop:
        CALL displayAX
        MOV DX,offset space
        CALL displaymsg
        DEC limit
        MOV CX,BX 
        ADD BX,AX
        MOV AX,CX
        CMP limit,0
        JNE mainloop
fibn ENDP

prtnewln PROC NEAR 
    MOV DX,offset newline 
    CALL displaymsg
prtnewln ENDP

displaymsg PROC near USES AX
	MOV AH,09H
	INT 21H
	RET
displaymsg ENDP

readnum PROC NEAR USES BX CX
	MOV BX,0        
	MOV CX,10
	loop1:
		MOV AH,01H  
		INT 21H
		CMP AL,'0'
		JB last1
		CMP AL,'9'
		JA last1
		SUB AL,30H   
		PUSH AX       
		MOV AX,BX
		MUL CX       
		MOV BX,AX    
		POP AX
		MOV AH,0
		ADD BX,AX    
		JMP loop1
	last1:
		MOV AX,BX
		RET
readnum ENDP

displayAX PROC near USES AX BX CX DX
	MOV CX,0	   ;count <--0
	MOV BX,10
	loop2:
		MOV DX,0
		DIV BX      ; digit = num%10 
		PUSH DX	    ; num=num/10 push digit 
		INC CX      ; count = count+1
		CMP AX,0    ; if num>0 goto loop2
		JNE loop2
	loop3:
		POP DX		  ;pop digit
		ADD DL,30H    ; convert to ascii
		MOV AH,02H    ; display
		INT 21H
		loop loop3
	RET
displayAX ENDP

end