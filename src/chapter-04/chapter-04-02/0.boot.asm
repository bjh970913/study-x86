%include "init.inc"

[org 0]
    jmp 07c0h:start

start:
    mov ax, cs
    mov ds, ax
    mov es, ax

reset_fp_disk:
    mov ax, 0
    mov dl, 0
    int 13h
    jc reset_fp_disk

paint_prepare:
    mov ax, 0xb800
    mov es, ax
    mov di, 0
    mov ax, word [msgBack]
    mov cx, 0x7ff

paint:
    mov word[es:di], ax
    add di, 2
    dec cx
    jnz paint

read:
    mov ax, 0x1000        ; ES:BX = 1000:000
    mov es, ax
    mov bx, 0

    mov ah, 2
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0
    int 13h

    jc read

    mov dx, 0x3F2  ; 플로피 모터 정지
    xor al, al
    out dx, al

    cli


    mov al, 0x11        ; PIC reset
    out 0x20, al        ; master PIC
    dw 0x00eb, 0x00ed   ; jmp $+2 X 2
    out 0xa0, al        ; slave PIC
    dw 0x00eb, 0x00eb

    mov al, 0x20        ; master PIC interrupt start point
    out 0x21, al
    dw 0x00eb, 0x00eb
    mov al, 0x28        ; slave PIC interrupt start point
    out 0xa1, al
    dw 0x00eb, 0x00eb

    mov al, 0x04
    out 0x21, al        ; slave PIC is connected to master PIC IRQ#2
    dw 0x00eb, 0x00eb
    mov al, 0x02
    out 0xa1, al        ; slave PIC is connected to master PIC IRQ#2
    dw 0x00eb, 0x00eb

    mov al, 0x01        ; use 8086 mode
    out 0x21, al
    dw 0x00eb, 0x00eb
    out 0xa1, al
    dw 0x00eb, 0x00eb

    mov al, 0xff
    out 0xa1, al
    dw 0x00eb, 0x00eb

    mov al, 0xfb
    out 0x21, al

    lgdt[gdtr]

    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax

    jmp $+2
    nop
    nop

    mov bx, SysDataSelector
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov gs, bx
    mov ss, bx

    jmp dword SysCodeSelector:0x10000

    msgBack db '.', 0x67

gdtr:
    dw gdt_end - gdt - 1
    dd gdt + 0x7c00

gdt:
    dd 0, 0
    dd 0x0000ffff, 0x00cf9a00
    dd 0x0000ffff, 0x00cf9200
    dd 0x8000ffff, 0x00cf920b
gdt_end:

times 510- ( $ - $$ ) db 0

dw 0aa55h
