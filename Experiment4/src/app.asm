; Written by lolimay <lolimay@lolimay.cn>
; Last updated: 2019.04.23

data segment
    ORG 0
    ARRAY LABEL BYTE
    DA1 DW  2, 9, 14, 3, 315H, -6
    DA2 DB  7, 'ABCDEDFG'
    LEN  = $-DA2
    ORG 100H
    DA3 DW DA4
    DA4 DB 4 DUP (2 DUP(1,2,3),4)
data ends

code segment
    assume cs:code, ds:data
start:
    mov ax, data
    mov ds, ax
    MOV AL, ARRAY+2
    ADD AL, DA2+1
    MOV AX, DA2-DA1
    MOV BL, LEN
    MOV AX, DA3
    MOV BX, TYPE DA4
    MOV BX, OFFSET DA4
    MOV CX, SIZE DA4
    MOV DX, LENGTH DA4
    MOV BX, WORD PTR DA4
    MOV BL, LEN AND 0FH
    MOV BL, LEN GT 5
    MOV AX,LEN MOD 5
    mov ah, 4ch
    int 21h
code ends
end start