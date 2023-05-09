section .data
    newline db 10
    newline_len equ $-newline

section .text
    global main
    extern strlen

main:                       ; print all command line arguments to stdout
    mov esi, [esp+4]        ; get pointer to first argument
    mov ebx, 1              ; file descriptor for stdout
.loop_args:
    cmp dword [esi], 0      ; check for end of arguments, if zero or not
    je .exit                ; exit if end of arguments(if it is zero)
    push esi                ; save the current argument pointer
    call strlen             ; get the length of the argument using strlen from util.c
    mov ecx, eax            ; store the length in ecx
    pop esi                 ; restore the current argument pointer
    mov edx, ecx            ; length of string to print
    mov eax, 4              ; system call number for write
    mov ebx, 1              ; file descriptor for stdout
    mov ecx, esi            ; pointer to string to print
    int 0x80                ; invoke system call
    mov eax, 4              ; system call number for write
    mov ebx, 1              ; file descriptor for stdout
    mov ecx, newline        ; pointer to newline character
    mov edx, newline_len    ; length of newline character
    int 0x80                ; invoke system call
    add esi, ecx            ; increment pointer to next argument
    cmp dword [esi], 0      ; check for end of arguments
    jne .next_arg           ; jump to next argument if not end
.exit:
    mov eax, 1              ; system call number for exit
    xor ebx, ebx            ; exit status
    int 0x80                ; invoke system call
.next_arg:
    add esi, 1              ; increment pointer to skip null terminator
    jmp .loop_args          ; jump to next argument
