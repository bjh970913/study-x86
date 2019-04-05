[org 0x80000000]
[bits 32]

user_process:
    mov eax, 80*2*2+2*5
    lea ebx, [msg_process_1]
    int 0x80
    mov eax, 80*2*3+2*5
    lea ebx, [msg_process_2]
    int 0x80
    inc byte [msg_process_2]
    jmp user_process

msg_process_1 db "User Process 1", 0
msg_process_2 db ". I'm running now", 0

times 512-($-$$) db 0
