.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
LENGTH = 4


.text
.global _start
_start:
nop


movq $0, %r12
cmp $LENGTH, %r12
movq $-1, %r9
je koniec2
inc %r12
cmp $LENGTH, %r12
movq %r9, %r10
movq $2, %r9
je koniec2
movq $3, %rsi
movq $-2, %rdi

call f

koniec2:

movq %r9, %rsi
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $1024, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall

f:
inc %r12
movq %r9, %r13
movq %r10, %rax
mul %rsi
movq $0, %rdx
movq %rax, %r10
movq %r9, %rax
mul %rdi
add %r10, %rax

movq %rax, %r9
movq %r13, %r10
cmp $LENGTH, %r12
je koniec
call f 
koniec:
	ret
