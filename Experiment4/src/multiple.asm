; Written by lolimay <lolimay@lolimay.cn>
; Last updated: 2019.04.23

code segment
    assume cs:code
start:
    mov al, 63h ; X=0.1100011
    mov ah, 1Bh ; Y=0.0011011
    add al, ah  ; X+Y=0.1111110 (B) stores in al register. 7E
    mov bl, 93h ; Z=1.0010011   (C) stores low 7 bits. stotes in bl register.
   
    xor bh, bh  ; A=00.0000000 whose length equals B. stores high 7 bits. (A)

    ; determine the sign first
    push ax
    push bx
    and al, 80h  ; xor same => PH|js; different => NG|jns
    and bl, 80h
    xor al, bl
    jns next
    mov dx, 0ffffh
next:
    pop bx
    pop ax
    and al, 7fh
    and bl, 7fh ; set sign bit to 0
    mov cx, 7   ; loop times: 7
lop:
    test bl, 01h
    jz skip
    add bh, al
skip:
    shr bx, 1
    loop lop
    test dl, 01h
    jz ski
    or bh, 80h
ski:
    ; (X+Y)*Z=1. 0010010 10110100 ; 92B4h
    mov ah, 4ch
    int 21h
code ends
end start