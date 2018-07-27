[org 0]
[bits 16]

start:
  mov ax, cs
  mov ds, ax
  xor ax, ax
  mov ss, ax

  cli

  lgdt[gdtr]

  mov eax, cr0
  or eax, 0x00000001
  mov cr0, eax

  jmp $+2
  nop
  nop

  db 0x66
  db 0x67
  db 0xea
  dd PM_Start
  dw SysCodeSelector

[bits 32]

PM_Start:
  mov bx, SysDataSelector
  mov ds, bx
  mov es, bx
  mov gs, bx
  mov ss, bx

  xor eax, eax
  mov ax, VideoSelector
  mov es, ax
  mov edi, 80*2*10 + 2*10
  lea esi, [ds:msgPMode]
  call printf

  jmp $

printf:
  push eax
printf_loop:
  or al, al
  jz printf_end
  mov al, byte [esi]
  mov byte [es:edi], al
  inc edi
  mov byte [es:edi], 0x06
  inc esi
  inc edi
  jmp printf_loop

printf_end:
  pop eax
  ret

msgPMode db "We are in Protected Mode with legacy mode transition", 0

gdtr:
  dw gdt_end - gdt - 1
  dd gdt+0x10000

gdt:
  dw 0
  dw 0
  db 0
  db 0
  db 0
  db 0

SysCodeSelector equ 0x08
  dw 0xffff   
  ; 1111 1111 1111 1111  LIMIT(15~0)
  dw 0x0000   
  ; 0000 0000 0000 0000  BASE 15~0
  db 0x01     
  ; 0000 0001            BASE 23~16
  db 0x9a     
  ; 1001 1010            P(isPresents)=1, DPL(Data Protection Level)=00, S(isSegment)=1, Type[1(Code), 0(None Confirm), 1(Readable), 0(Access)]
  db 0xcf     
  ; 1101 1111            G(unit==>byte of 4KB)=1(4KB), D=1(32bit code), 0, AVL=1, LIMIT(16~19)=1111
  db 0x00     
  ; BASE 31~24

SysDataSelector equ 0x10
  dw 0xffff
  ; 1111 1111 1111 1111 LiMIT
  dw 0x0000
  ; 0000 0000 0000 0000 Base
  db 0x01
  ; 0000 0001           Base
  db 0x92
  ; 1001 0010           P=1, DPL=00, S=1, Type[data, expand up, writable, not accessing]
  db 0xcf
  ; 1101 1111           G=1, D=1, 0, AVL=1, LIMIT=1111
  db 0x00
  ; 0000 0000           Base

VideoSelector equ 0x18
  dw 0xffff
  dw 0x8000
  db 0x0b
  db 0x92
  db 0x40
  db 0x00

gdt_end:

times 1024-($-$$) db 0
