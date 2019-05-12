.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0

Tekst: .ascii "Przykładowy tekst \n"
Format: .ascii "%s"
Shift = 2

.global main

.text

main:

push $Tekst
push $Shift
call cesar

push rbp 

mov	$Format, %rdi
mov	%rax, %rsi
mov	$0, %rax
call printf

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall