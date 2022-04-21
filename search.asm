.model small

.stack 100h

.data ;;data segment
    msg1 DB 'Enter the string:$'
    msg2 DB 'Enter the character:$'
    msg3 DB 'Given character is in the string$'
    msg4 DB 'Given character is not in the string'
    newline DB 10,13,'$'

    str1 DB 50 DUP (?)
    char DB ?

.code ;;code segment
    .startup

        MOV DX,OFFSET msg1
        CALL displaymsg     ;;ask for string

        MOV SI,OFFSET str1  ;;read string 
        CALL readstr

        MOV DX,OFFSET msg2
        CALL displaymsg     ;;ask for character 

        MOV SI,OFFSET char  ;;read character
        CALL readchar

        MOV DX,OFFSET newline
        CALL displaymsg     

        MOV SI,OFFSET str1  ;;copy offset address of string to si
        MOV DI,OFFSET char  ;;copy offset address of character to si
        MOV BX,[DI]         ;;copy character to register
        CALL isin           ;;procedure call
    .exit

    displaymsg PROC NEAR ;;procedure to display string
        PUSH AX
        MOV AH,09H
        INT 21H
        POP AX
        RET
    displaymsg ENDP

    readchar PROC NEAR  ;;procedure to read character
        PUSH AX
        PUSH SI
        MOV AH,01H
        INT 21H
        MOV [SI],AL
        POP SI
        POP AX
        RET
    readchar ENDP

    readstr PROC NEAR ;;procedure to read  string 
        PUSH AX
        PUSH SI
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
        POP SI
        POP AX
        RET
    readstr ENDP

    isin PROC NEAR ;;check whether the character is in the 
        loop1:          ;;loop
            MOV AX,[SI]
            CMP AL,BL   ;;check if the given location of string contain the character
            JE output1
            CMP AL,'$'  ;;check for end of the string
            JE output2
            INC SI      ;;point to next character
            JMP loop1
        output1:
            MOV DX,OFFSET msg3
            CALL displaymsg     ;;print character found
            RET
        output2:
            MOV DX,OFFSET msg4
            CALL displaymsg     ;;print character not found
            RET
    isin ENDP

end ;;end of program