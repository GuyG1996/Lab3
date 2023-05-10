Infile equ 0           ; stdin
Outfile equ 1      ; stdout
SYS_WRITE equ 4
SYS_READ equ 3
STDOUT equ 1

section .data
    newline db 10

section .bss
    Buffer resb 1      ; 1-byte buffer for reading from input    

section .text
global _start
global system_call
extern strlen 

exit:
    mov eax, 1                  ; System call number for exit
    mov ebx, 0                  ; Exit status
    int 0x80                    ; Invoke system call to exit the program

_start:

    call _main
    call _encoder    

_encoder: 

    push ebp                    ; Save caller state
    mov ebp, esp                ; Set up base pointer
    
    ; Read one character from stdin
    mov eax, SYS_READ           ; Read system call
    mov ebx, Infile
    mov ecx, Buffer             
    mov edx, 1                  ; Read one byte
    int 0x80

    ; Check if we've reached the end of the input
    cmp eax, 0    
    je exit

    ; Check if the character is in the range 'A' to 'z'
    cmp byte [Buffer], 65       ;"A"
    jl .write_output
    cmp byte [Buffer], 122      ;"z"
    jg .write_output
    add byte [Buffer], 1           ; add 1 to the character value

.write_output:
    
    mov eax, SYS_WRITE          
    mov ebx, Outfile
    mov ecx, Buffer
    mov edx, 1
    int 0x80

    jmp _encoder                 ; Jump back to start of loop
    
_main:
    
    push ebp                    ; Save caller state
    mov ebp, esp                ; Set up base pointer
    mov edi, 1                  ; Counter for command line arguments
    mov esi, [esp+16]           ; Get pointer argv[1]

.loop_args:
    cmp edi, [ebp+8]            ; Compare counter with argc
    je _encoder                 ; Jump to exit if all arguments have been printed
    mov edx, esi                ; Copy pointer to current argument to edx
    push esi                    ; Save the current argument pointer on the stack
    call strlen                 ; Call strlen to get the length of the current argument
    mov edx, eax                ; Move the length to edx register
    mov eax, SYS_WRITE          ; System call number for write
    mov ebx, STDOUT             ; File descriptor for stdout
    mov ecx, esi                ; Pointer to string to print
    int 0x80                    ; Invoke system call to print current argument
    add esp, 4                  ; Restore the stack pointer

    mov eax, SYS_WRITE          ; System call number for write
    mov ebx, STDOUT             ; File descriptor for stdout
    mov ecx, newline            ; Pointer to newline character
    mov edx, 1                  ; Length of newline character
    int 0x80                    ; Invoke system call to print newline character

    mov esi, [ebp + 16 + 4*edi] ; Get pointer to next command line argument
    inc edi                     ; Increment counter
    jmp .loop_args              ; Jump to start of loop


system_call:
    push    ebp                 ; Save caller state
    mov     ebp, esp
    sub     esp, 4              ; Leave space for local var on stack
    pushad                      ; Save some more caller state

    mov     eax, [ebp+8]        ; Copy function args to registers: leftmost...        
    mov     ebx, [ebp+12]       ; Next argument...
    mov     ecx, [ebp+16]       ; Next argument...
    mov     edx, [ebp+20]       ; Next argument...
    int     0x80                ; Transfer control to operating system
    mov     [ebp-4], eax        ; Save returned value...
    popad                       ; Restore caller state (registers)
    mov     eax, [ebp-4]        ; place returned value where caller can see it
    add     esp, 4              ; Restore caller state
    pop     ebp                 ; Restore caller state
    ret                         ; Back to caller
