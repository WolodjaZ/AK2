data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
STDER = 2
EXIT_SUCCESS = 0
BUFLEN = 512
OPEN = 5 # (opcje otwarcia: /usr/include/asm/fcntl.h)
CLOSE = 6
CR_WRONLY_TR = 03101 # flaga: tylko zapis (notacja ósemkowa!)
RDONLY = 0 

File_in: .ascii "Wczyaj"
File_out: .ascii "Wypisz"
ERR_MSG: .ascii "Wprowadzona liczba jest niepoprawna!\n"
ER_LEN= .- ERR_MSG

.bss
.comm textin, 512
.comm textout, 512

.text
.global _start
_start:
nop


movq $OPEN, %rax
movq $File_in, %rdi
movq $RDONLY, %rsi
movq $0, %rdx
syscall

push %rax
movq %rax, %rdi
movq $STDIN, %rax
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall

movq $CLOSE, %rax
pull %rdi
syscall

