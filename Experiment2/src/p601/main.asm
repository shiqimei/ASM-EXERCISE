data segment
data ends

code segment
    assume cs:code, ds:data
start:
    mov ax, data
    mov ds, ax
    mov ax, 0038h
    mov bx, 0010h
    sub ax, bx
    mov ds:[0016h], ax
code ends
    end start
