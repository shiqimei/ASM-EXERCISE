data segment
    a db 4
    b db 16
    c db ?
    array db 02, 03, 01
data ends

code segment
    assume cs:code, ds:data
start:
    mov ax, data
    mov ds, ax
    mov al, a
    add al, 10 ; ①立即数寻址，运行后 al=0eh
    mov bl, b  ; 运行后 bl=10h
    add bl, al ; ②寄存器寻址,运行后 bl=1eh
    add al, b  ; ③直接寻址,运行后 al=1eh
    lea bx, b  ; 运行后 bx=0001h
    add bl, [bx] ; ④寄存器间址, 运行后 bl=11h
    lea bx, a ; 运行后 bx=0000h
    add al, [bx+1h] ; ⑤相对寻址, 运行后 al=2eh
    mov c, al ; 运行后 (c)=2eh
    inc bx ; 运行后 bx=0001h
    mov si, 01h ; 运行后 si=0001h
    add al, [bx][si] ; ⑥基址变址寻址，运行后 al=5ch
    add al, array[bx][si] ; ⑦相对基址寻址, 运行后 al=5dh
    add al, array[bx] ; ⑤相对寻址, 运行后 al=60h
    mov ah, 4ch
    int 21h
code ends
    end start
