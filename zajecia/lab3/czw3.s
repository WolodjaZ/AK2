.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
first = 81
second = 6

.text
.global _start
_start:
nop


movq $first, %r9
movq $second, %r10
movq $0, %r11

NWD:
movq $0, %rdx
movq %r10, %rsi
movq %r9, %rax
div %rsi
movq %rdx , %r10
movq %rsi, %r9
cmp %r11, %r10
jz koniec
jmp NWD

koniec:
movq $0, %rdx
movq $first, %rax
movq $second, %rsi
div %r9
mul %rsi
movq %rax, %rsi

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $1024, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
 
