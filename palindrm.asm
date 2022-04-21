.model small

.stack 100h

.data ;;data segment
msg1 DB ' Enter the string : $'
msg2 DB ' String is palindrome$'
msg3 DB ' String is not a palindrome$'

str1 DB 50 DUP (?) ;;Array without initialization

.code ;;code segment
.startup

MOV DX,OFFSET msg1
CALL displaymsg ;; Ask for String

MOV SI,OFFSET str1
CALL readstr    ;; Accept the string

CALL palindrome ;; Call palindrome procedure 
.exit

displaymsg PROC NEAR ;;procedure to display string
    PUSH AX
    MOV AH,09H
    INT 21H
    POP AX
    RET
displaymsg ENDP


readstr PROC NEAR ;;procedure to read a string from io
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






palindrome PROC NEAR ;;check palindrome
    MOV SI,OFFSET str1
    loop1:
        MOV AX,[SI]
        CMP AL,'$'  ;;move source index to the last position of the given string
        JE l1
        INC SI
        JMP loop1
    l1:
        MOV DI,OFFSET str1 ;;move the offset address of string to destination index register
        DEC SI             ;;point to the ending of string rather than $
        loop2:
            CMP SI,DI   ;;compare SI and DI values
            JL output1  ;;if they are equal then they are pointing to the same location so it is palindrome (same both sides)
            MOV AX,[SI]
            MOV BX,[DI] ;;copy charater from beginig and ending of the string in SI and DI to AX and BX
            CMP AL,BL   ;;compare their values
            JNE output2 ;;if character tn both side of equal potion is not equal string is not palindrome
        DEC SI  ;;point to previous character
        INC DI  ;;point to next character
        JMP loop2   ;;loop

        output1:
            MOV DX,OFFSET msg2 ;;print string is palindrome
            CALL displaymsg
        RET
        output2:
            MOV DX,OFFSET msg3 ;;print string is not palindrome
            CALL displaymsg
            RET
palindrome ENDP ;;end of palindrome procedure




end ;;end of program
