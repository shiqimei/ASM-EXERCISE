; Written by lolimay <lolimay@lolimay.cn>
; Last updated: 2019.04.30

data segment
    buffer db 5 ; need add an extra byte for tab Enter
    numb   db ?  ; in other words, Enter also takes up one character.
    input  db 4 dup(?)
data ends

code segment
assume cs:code, ds:data

; main function
; I specify it as the program's entrance manually here.
main proc
    mov ax, data
    mov ds, ax
    call read_buffer ; read buffer, wrapper for 0a function of INT 21H.
    call println     ; print '\n'
    mov cx, 4        ; outer-loop
oop:
    mov bx, 4
    sub bx, cx
    mov dl, input[bx]
    cmp dl, 40h
    jc num
    sub dl, 37h ; -41h + 0ah = 37h
    jmp nxt
num:
    sub dl, 30h
nxt:
    call shlfour
    push cx ; inner-loop
    mov cx, 4
iop:
    shl dl, 1
    jc one
    call printzero
    jmp next
one:
    call printone
next:
    loop iop
    pop cx
    loop oop
    call exit ; exit the program.

; read buffer from the standard input stream.
; It's a wrapper for 0a function of INT21H.
; But it can protect ah register's value from overwriting.
read_buffer proc
    push ax
    mov ah, 0ah
    int 21h
    pop ax
    ret
read_buffer endp

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

; shl 5 times
shlfour proc
    push cx
    mov cl, 4
    shl dl, cl
    pop cx
    ret
shlfour endp

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
; In fact, it's a wrapper for 4c function of INT 21H.
; But it can protect ah register's value from overwriting.
exit proc
    push ax
    mov ah, 4ch
    int 21h
    pop ax
    ret
exit endp

code ends
end main

