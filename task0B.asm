section .data
  message db "hello world",10

section .text
  global _start

_start:
  ; write message to stdout
  mov eax, 4  ; system call number for write
  mov ebx, 1  ; file descriptor for stdout
  mov ecx, message  ; address of message to print
  mov edx, 12  ; length of message in bytes
  int 0x80    ; call kernel interrupt to perform system call

  ; exit
  mov eax, 1  ; system call number for exit
  xor ebx, ebx  ; exit code 0
  int 0x80    ; call kernel interrupt to perform system call
