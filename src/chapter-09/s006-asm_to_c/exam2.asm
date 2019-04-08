[bits 32]

segment .data
lucky db "Lucky number is %d", 0x0a, 0

segment .text
[global prt]
[extern print_it]
prt:
    push ebp
    mov ebp, esp

    call print_it
    
    leave
    ret
