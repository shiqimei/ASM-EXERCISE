; Written by lolimay <lolimay@lolimay.cn>
; Last updated: 2019.03.28

code segment
assume cs:code

; main function
; I specify it as program's entrance manually here.
main proc
    mov cx, 6   ; set out-loop times
ot:             ; outer-loop
    ; here we can still use loop keyword for inner-loop
    ; with the help of push and pop stack to protect cx variable.
    push cx
    mov bx, 7
    sub bx, cx
    xchg bx, cx     ; inner-loop times is dynamic
    mov dl, '*'
    ir:             ; inner-loop
        call printc ; print char from dl register
        loop ir
    pop cx
    call println
    loop ot
    call exit ; exit the program.

; print a char, which need parameter from dl register.
; actually, it's a wrapper for 02 function of INT 21H.
; But it can protect ah register's value from overwriting.
printc proc
    push ax
    mov ah, 02h
    int 21h
    pop ax
    ret
printc endp

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

code ends
end main


