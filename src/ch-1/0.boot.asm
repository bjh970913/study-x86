[org 0]
[bits 16]
  jmp 0x07c0:start

start:
  mov ax, cs
  mov ds, ax

  mov ax, 0xb800
  mov es, ax
  mov di, 0
  mov ax, word [msgBack]
  mov cx, 0x7ff

paint:
  mov word [es:di], ax
  add di, 2
  dec cx
  jnz paint

  mov edi, 0
  mov byte [es:edi], 'A'
  inc edi
  mov byte [es:edi], 0X06
  inc edi
  mov byte [es:edi], 'B'
  inc edi
  mov byte [es:edi], 0X06
  inc edi
  mov byte [es:edi], 'C'
  inc edi
  mov byte [es:edi], 0X06
  inc edi
  mov byte [es:edi], '1'
  inc edi
  mov byte [es:edi], 0X06
  inc edi
  mov byte [es:edi], '2'
  inc edi
  mov byte [es:edi], 0X06
  inc edi
  mov byte [es:edi], '3'
  inc edi
  mov byte [es:edi], 0X06
  inc edi
  jmp $

msgBack db '.', 0x67

times 510-($-$$) db 0
dw 0xaa55
