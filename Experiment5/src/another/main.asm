; Written by lolimay <lolimay@lolimay.cn>
; Last updated: 2019.04.30

code segment
    assume cs:code
start:
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
    call println
    mov cx, 16
lopout:
    shl bx, 1
    jc one
    call printzero
    jmp next
one:
    call printone
next:
    loop lopout
    mov ah, 4ch
    int 21h

; print a char, which needs parameter from *dl* register.
; actually, it's a wrapper for 02 function of INT 21H.
; But it can protect ah register's value from overwriting.
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

; print '1', which needs parameter from *dl* register
printone proc
    push dx
    mov dl, 31h
    call printc
    pop dx
    ret
printone endp

; print '0', which needs parameter from *dl* register
printzero proc
    push dx
    mov dl, 30h
    call printc
    pop dx
    ret
printzero endp

code ends
end start