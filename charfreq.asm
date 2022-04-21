.model small
.stack 100H

.data

msg1 DB 10,13,'Enter the string: $'
newline DB 10,13,'$'
colon DB ' : $'

str1 DB 50 DUP (?)
arr2 DB 58 DUP (0)   

.code              
.startup

MOV DX,OFFSET msg1
CALL displaymsg     ; Ask for String

MOV SI,OFFSET str1
CALL readstr        ; Accept the string

MOV DX,OFFSET newline
CALL displaymsg     ; Print newline

CALL freqfind       ; Find Freqency
CALL freqdisp       ; Display Freqency

.exit

freqfind PROC NEAR 
   loopmain:
    MOV DI,OFFSET arr2
    MOV SI,OFFSET str1
   loop1:
    MOV BX,[SI]
    MOV BH,0
    INC SI
    
    MOV CL,BL
    SUB BL,65        ;Find index value

    MOV AL,[BX+DI]   ;Go to index according to
    INC AL           ;the way like A=0 ,B=1 etc
    MOV [BX+DI],AL   ;and increment the vale there

    
    CMP CL,'$'
    JNE loop1
    RET
freqfind ENDP

freqdisp PROC NEAR 
    MOV CX,0
    MOV SI,OFFSET arr2
    loopv:   
        MOV AH,0
        MOV AL,[SI]
        CMP AL,0            ;If Char count eql 0
        JE next             ;Dont print

        MOV DX,CX
        ADD DX,65
        PUSH AX
        MOV AH,02H          ;Display the Character
        INT 21H             ;According to index

        MOV DX,OFFSET colon  
        CALL displaymsg     ;Display colon 
        
        POP AX              
        CALL displayAX      ;Display char count

        MOV DX,OFFSET newline
        CALL displaymsg     ;Display newline
    next:
       INC SI
       INC CX
       CMP CX,58
       JNE loopv
    RET
freqdisp ENDP

displaymsg PROC NEAR USES AX;;procedure to display string
    MOV AH,09H
    INT 21H
    RET
displaymsg ENDP

readstr PROC NEAR  USES AX SI;;procedure to read a string from io
    back:
        MOV AH,01H
        INT 21H
        MOV [SI],AL
        INC SI
        CMP AL,0DH
        JNE back
    DEC SI
    MOV AL,'$'
    MOV [SI],AL
    RET
readstr ENDP

displayAX PROC near USES AX BX CX DX
  MOV CX,0      ;count <--0
  MOV BX,10

  Back2:
    MOV DX,0
    DIV BX      ; digit = num%10 
    PUSH DX     ; num=num/10 push digit 
    INC CX      ; count = count+1
    CMP AX,0    ; if num>0 goto back2
    JNE Back2
  Back3:
    POP DX        ;pop digit
    ADD DL,30H    ; convert to ascii
    MOV AH,02H    ; display
    INT 21H
    loop Back3
  RET
displayAX ENDP

end