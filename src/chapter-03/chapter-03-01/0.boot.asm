[org 0]
  jmp 0x07c0:start

start:
  mov ax, cs
  mov ds, ax
  mov es, ax

  mov ax, 0xb800
  mov es, ax
  mov di, 0
  mov ax, word [msgBlock]
  mov cx, 0x7ff

paint:
  mov word [es:di], ax
  add di, 2
  dec cx
  jnz paint

read:
  mov ax, 0x1000
  mov es, ax
  mov bx, 0

  mov ah, 2
  mov al, 1
  mov ch, 0
  mov cl, 2
  mov dh, 0
  mov dl, 0
  int 0x13

  jc read

  jmp 0x1000:0000

msgBlock db '.', 0x67

times 510-($-$$) db 0
dw 0aa55h
