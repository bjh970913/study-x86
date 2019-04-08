[bits 32]

segment .data
lucky db "Luck number is %d", 0

segment .text
[global print_it]
[extern printf]
print_it:
    push ebp
    mov ebp, esp

    push dword 7
    push lucky
    call printf
    
    leave
    ret
