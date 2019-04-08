segment .text

[global _FloppyMotorOn]
[global _FloppyMotorOff]
[global _initializeDMA]
[global _FloppyCode]
[global _ResultPhase]
[global _inb]

_FloppyMotorOn:
    push edx
    push eax
    
    mov al, 0x1c
    mov dx, 0x3f2
    out dx, al
    
    pop eax
    pop edx
    ret

_FloppyMotorOff:
    push edx
    push eax
    
    xor al, al
    mov dx, 0x3f2
    out dx, al
    
    pop eax
    pop edx
    ret

_initializeDMA:
    push ebp
    mov ebp, esp

    push eax

    mov al, 0x14
    out 0x08, al

    mov al, 1
    out 0x0c, al

    mov al, 0x56
    out 0b, al
    
    mov al, 1
    out 0x0c, al

    mov eax, dword [ebp+0x0c]
    out 0x04, al
    mov al, ah
    out 0x04, al

    mov eax, dword [ebp+0x08]
    out 0x81, al

    mov al, 1
    out 0x0c, al

    mov al, 0xff
    out 0x05, al

    mov al, 1
    out 0x05, al

    mov al, 0x02
    out 0x0a, al

    out al, 10
    out 0x08, al

    pop eax

    mov esp, ebp
    pop ebp
    ret

_inb:
    push ebp
    mov ebp, esp

    push edx

    xor eax, eax
    mov edx, dwrod [ebp+0x08]
    in al, dx

    pop edx

    mov esp, ebp
    pop ebp
    ret

_outb:
    push ebp
    mov ebp, esp

    push eax
    push edx

    xor eax, eax
    mov eax, dword [ebp+0x0c]
    mov edx, dword [ebp+0x08]
    out dx, al

    pop edx
    pop eax

    mov esp, ebp
    pop ebp
    ret

_ResultPhase:
    push edx

    mov dx, 0x3f5
    in al, dx
    pop edx
    ret
