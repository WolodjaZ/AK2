.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
LENGTH = 100


.text
.global _start
_start:
nop


movq $0, %r12
cmp $LENGTH, %r12
push $-1
je koniec2
inc %r12
cmp $LENGTH, %r12
push $2
je koniec2
movq $3, %rsi
movq $-2, %rdi

call f

koniec2:

push %rsi
movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $1024, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall


f:
movq $0, %rdx
inc %r12
pop %r11
pop %r9
pop %r10
push %r11
push %r9
movq %r10, %rax
mul %rsi
movq $0, %rdx
movq %rax, %r10
movq %r9, %rax
mul %rdi
add %r10, %rax
push %r9
push %rax
cmp $LENGTH, %r12
je koniec
push %rax
call f 
koniec:
	ret


