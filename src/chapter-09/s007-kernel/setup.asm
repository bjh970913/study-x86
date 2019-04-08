%include "init.inc"

PAGE_DIR        equ 0x100000
PAGE_TAB_KERNEL equ 0x101000
PAGE_TAB_USER   equ 0x102000
PAGE_TAB_LOW    equ 0x103000

[org 0x90000]
[bits 16]

start:
    cld
    mov ax, cs
    mov ds, ax
    xor ax, ax
    mov ss, ax

    xor eax, eax
    lea eax, [tss]
    add eax, 0x90000
    mov [desciptor4+2], ax
    shr eax, 16
    mov [desciptor4+4], al
    mov [desciptor4+7], ah

    cli
    lgdt[gdtr]

    mov eax, cr0
    or eax, 0x00000001
    mov cr0, eax

    jmp $+2
    nop
    nop
    
    jmp dword SysCodeSelector:PM_Start

[bits 32]
PM_Start:
    mov bx, SysDataSelector
    mov ds, bx
    mov es, bx
    mov fs, bx
    mov gs, bx
    mov ss, bx

    lea esp, [PM_Start]
    mov esi, 0x80000
    mov edi, 0x200000
    mov cx, 512*NumKernelSector

kernel_copy:
    mov al, byte [ds:esi]
    mov byte [es:edi], al
    inc esi
    inc edi
    dec cx
    jnz kernel_copy

    mov edi, PAGE_DIR
    mov eax, 0
    mov ecx, 1024
    cld rep stosd

    mov edi, PAGE_DIR
    mov eax, 0x103000
    or eax, 0x01
    mov [es:edi], eax

    mov edi, PAGE_DIR+0x200*4
    mov eax, 0x102000
    or eax, 0x07
    mov [es:edi], eax

    mov edi, PAGE_DIR+0x300*4
    mov eax, 0x101000
    or eax, 0x01
    mov [es:edi], eax

    mov edi, PAGE_TAB_KERNEL
    mov eax, 0
    mov ecx, 1024
    cld
    rep stosd

    mov edi, PAGE_TAB_KERNEL+0x000*4
    mov eax, 0x200000
    or eax, 1
    mov [es:edi], eax

    mov edi, PAGE_TAB_KERNEL+0x001*4
    mov eax, 0x201000
    or eax, 1
    mov [es:edi], eax

    mov edi, PAGE_TAB_KERNEL+0x002*4
    mov eax, 0x202000
    or eax, 1
    mov [es:edi], eax

    mov edi, PAGE_TAB_USER

    mov eax, 0x00
    mov ecx, 1024
    cld
    rep stosd
    
    mov edi, PAGE_TAB_USER+0x000*4
    mov eax, 0x300000
    or eax, 0x07
    mov [es:edi], eax
    
    mov edi, PAGE_TAB_USER+0x001*4
    mov eax, 0x301000
    or eax, 0x07
    mov [es:edi], eax
    
    mov edi, PAGE_TAB_USER+0x002*4
    mov eax, 0x302000
    or eax, 0x07
    mov [es:edi], eax
    
    mov edi, PAGE_TAB_USER+0x003*4
    mov eax, 0x303000
    or eax, 0x07
    mov [es:edi], eax
    
    mov edi, PAGE_TAB_USER+0x004*4
    mov eax, 0x304000
    or eax, 0x07
    mov [es:edi], eax

    mov edi, PAGE_TAB_LOW
    mov eax, 0x00000
    or eax, 0x01
    mov cx, 512

page_low_loop:
    mov [es:edi], eax
    add eax, 0x1000
    add edi, 4
    dec cx
    jnz page_low_loop

    mov eax, PAGE_DIR
    mov cr3, eax

    mov eax, cr0
    or eax, 0x80000000
    mov cr0, eax

    lea eax, [tss]
    mov [TSS_WHERE], eax
    mov esp, esp, 0xC0001FFF

    jmp 0xC0000000

gdtr:
    dw gdt_end-gdt-1
    dd gdt
gdt:
    dd 0, 0
    dd 0x0000FFFF, 0x00CF9A00
    dd 0x0000FFFF, 0x00CF9200
    dd 0x8000FFFF, 0x0040920B

desciptor4:
    dw 104
    dw 0
    db 0
    db 0x89
    db 0
    db 0

    dd 0x0000FFFF, 0x00FCFA00
    dd 0x0000FFFF, 0x00FCF200
gdt_end:

tss:
    dw 0, 0

tss_esp0:
    dd 0xC0001FFF
    dw SysDataSelector, 0
    dd 0
    dw 0, 0
    dd 0
    dw 0, 0 
    dd 0x100000
tss_eip:
    dd 0, 0
    dd 0, 0, 0, 0
tss_esp:
    dd 0, 0, 0, 0
    dw 0, 0
    dw 0, 0
    dw UserDataSelector, 0
    dw 0, 0
    dw 0, 0
    dw 0, 0
    dw 0, 0
    dw 0, 0

times 1024-($-$$) db 0
