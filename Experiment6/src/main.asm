; Written by lolimay <lolimay@lolimay.cn>
; Last updated: 2019.05.07

data segment
    array dw 0h, 1h, 0ah, 64h, 3e8h, 2710h
data ends

code segment
    assume cs:code, ds:data
start:
    mov ax, data
    mov ds, ax
    call storeIntoBx
    call println
    call printBx
    call exit

; Store stdin into bx register
storeIntoBx proc
    xor bx, bx
    mov cx, 4
lopin:
    mov ah, 01h
    int 21h
    cmp al, 40h
    jc num
    sub al, 37h
    jmp nxt
num:
    sub al, 30h
nxt:
    xor ah, ah
    or bl, al
    cmp cx, 02h ; jump out in the last time
    jc ot
    push cx
    mov cl, 4
    shl bx, cl
    pop cx
    loop lopin
ot:
    ret
storeIntoBx endp

; print bx register's content with decimal
printBx proc
    mov cx, 5
lopout:
    xor dx, dx
    mov ax, bx ; ax <- (dx,ax)/src
    call loadDataToBx
    div bx

    push dx
    mov dl, al
    add dl, 30h
    call printc
    pop dx

    mov bx, dx
    loop lopout
    ret
printBx endp


; load data to bx from array by cx
loadDataToBx proc
    mov bx, cx
    push ax
    xor ax, ax
    mov al , 02h
    mul bx          ; bx = bx * 2
    mov bx, ax
    pop ax
    mov bx, array[bx]
    ret
loadDataToBx endp

; print a char
printc proc
    push ax
    mov ah, 2
    int 21h
    pop ax
    ret
printc endp

; print '\n' (aka. CRLF)
println proc
    push dx
    mov dl, 0dh ; CR
    call printc ; because printc protects ax register aready
    mov dl, 0ah ; So here we don't to protect it again.
    call printc ; LF
    pop dx
    ret
println endp

; exit program
exit proc
    push ax
    mov ah, 4ch
    int 21h
    pop ax
    ret
exit endp

code ends
end start