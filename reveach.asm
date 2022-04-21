;; author : sankarvinayak 

.model small
.stack 100h


.data
msg1 DB 'Enter the string$'
msg2 DB 'String with each word reversed:$'
str1 DB 50 DUP (?)
newline DB 10,13,'$'


.code
.startup

MOV DX,offset msg1
CALL display
MOV DX,offset newline	;;ask for string
call display

MOV SI,offset str1		;; read string
call readstr

MOV SI,offset str1
MOV DI,SI
call traverse				

MOV DX,offset newline
call display
MOV DX,offset str1		;;display string
call display
.exit

traverse PROC near 
	MOV CX,1
	l3:
		MOV AL,[DI]
		CMP AL,' '
		JE l7
		CMP AL,'$'
		JE l8
		INC DI
		JMP l3
	l8:	MOV CX,0		;;indicates end of string
	l7:
		CALL revword	;;will reverse word
		INC DI
		MOV SI,DI
		CMP CX,0
		JNE l3
		
	RET 
traverse ENDP


revword PROC near uses AX BX DI SI 		;;reverse word by swapping
	l4:									;;first and last letter ,
		DEC DI							;;second and second-last ,
		CMP SI,DI						;;and so on
		JNL l5
		MOV AL,[SI]
		MOV BL,[DI]
		MOV [SI],BL
		MOV [DI],AL
		INC SI
		JMP l4
	l5:
		RET
revword ENDP
	

readstr PROC near uses AX SI
	l1:
		MOV AH,01H
		INT 21H
		MOV [SI],AL
		CMP AL,0DH
		JE l2
		INC SI
		JMP l1
	l2:
		MOV AL,'$'
		MOV [SI],AL
	RET
readstr ENDP

display PROC near uses AX
	MOV AH,09H
	INT 21H
	RET
display ENDP

END
