data segment
    array db 2 dup(?), 12h
data ends

code segment
    assume cs:code, ds:data
start:
    mov ax, data
    mov ds, ax
    mov ax, 1234h
    add ds:[0002h], ax
    mov bl, [0003h]
    mov ah, 4ch
    int 21h
code ends
    end start
