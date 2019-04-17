; Written by lolimay <lolimay@lolimay.cn>
; Last updated: 2019.04.16

data segment
    origin_buffer db 19 ; need add an extra byte for tab Enter
    origin_length db ? ; in other words, Enter also takes up one character.
    origin_content db 18 dup(?)
    target_buffer db 19
    target_length db ?
    target_content db 18 dup(?)
data ends

code segment
assume cs:code, ds:data, es:data

; main function
; I specify it as the program's entrance manually here.
main proc
    mov ax, data
    mov ds, ax
    mov es, ax ; es=ds

    lea dx, origin_buffer
    call read_buffer
    call println
    lea dx, target_buffer
    call read_buffer
    call println

    lea si, origin_content
    lea di, target_content

    mov cx, 12h ; 18
    cld
    repe cmpsb
    jz eql
    mov dl, 'N'
    call printc
    mov dl, ' '
    call printc
    mov dl, 12h ; 18
    sub dl, cl  ; dl = 19 - (cl + 1) = 18 - cl
    xor bx, bx
    mov bl, dl
    dec bl
    add dl, 30h ; convert it to ascii code
    call printc
    mov dl, ' '
    call printc
    mov dl, origin_content[bx]
    call printc
    mov dl, ' '
    call printc
    mov dl, target_content[bx]
    call printc
    jmp dsp
eql:
    mov dl, 'Y'
    call printc
dsp: ; scan start
    xor bl, bl ; use bx to store times
    call println
    call getc ; store it into al
    call println
    lea di, origin_content
    mov cx, 12h ; 18
    cld
lop:
    repne scasb
    jz yes
    jmp ext
yes:
    inc bl
    jmp lop
ext:
    mov dl, bl
    add dl, 30h
    call printc
    call exit ; exit the program,

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

; get a char, which stores into *al* register.
; actually, it's a wrapper for 01 function of INT 21H.
getc proc
    mov ah, 1
    int 21h
    ret
getc endp


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