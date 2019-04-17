; Convert a 16-bit binary number to octal number.
; Must be running in `debug -g` mode for correct results!
; Written by lolimay <lolimay@lolimay.cn>
; Last updated: 2019.03.28

data segment
    buffer db 17 ; need add an extra byte for tab Enter
    numb   db ?  ; in other words, Enter also takes up one character.
    input  db 16 dup(?)
data ends

code segment
assume cs:code, ds:data

; main function
; I specify it as the program's entrance manually here.
main proc
    mov ax, data
    mov ds, ax
    call read_buffer ; read buffer, wrapper for 0a function of INT 21H.
    call store_to_dx ; store the 16-bit binary number in dx register.
    call println     ; print '\n'
    ; handle the highest bit first.
    ; It only works well by using `-g` command in debug mode.
    ; `js` and `jc` not work by running the program directly.
    shl dx, 1   ; shift the highest bit.
    push dx     ; need to protect dx register here.
    jc te
    mov dl, 30h
    jmp con
te: mov dl, 31h
con:
    call printc
    pop dx      ; restore dx register.
    ; solve the left 15 bits with a loop.
    mov cx, 5
lft:
    rol dx, 1
    rol dx, 1
    rol dx, 1
    mov bx, dx
    push dx     ; here we need to pretect dx register.
    and dl, 07h ; clear the high 5 bits.
    add dl, 30h ; convert it to ascii code
    call printc
    pop  dx
    loop lft
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

; store the input 16-bit binary number in dx register with a loop.
store_to_dx proc
    xor dx, dx
    
    mov cx, 15 ; please note that we should only shl 15 times.
sto:           ; so here we set cx to 15.
    mov bx, 15
    sub bx, cx   ; scan the input from left to right.
    mov al, input[bx]
    cmp al, 30h ; see whether it is '0'.
    je ze
    or  dx, 1
    jmp co
ze: and dx, 0fffeh ; if the value '0', set the lowest bit to 0
co: shl dx, 1 ; continue
    loop sto
    ; process the last bit separately.
    inc bx
    mov al, input[bx]
    cmp al, 30h
    je zr
    or  dx, 1
    jmp ex
zr: and dx, 0fffeh
ex: ret
store_to_dx endp

; print a char, which need parameter from *dl* register.
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

