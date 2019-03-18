.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
BUFLEN = 512

.bss
.comm textin, 512
.comm textout, 512

.text
.global _start
_start:
nop

movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall

dec %rax
movq $0, %rdi
zmien_wielkosc_liter:
movb textin(, %rdi, 1), %bh
movb $0x20, %bl
xor %bh, %bl
movb %bl, textout(, %rdi, 1)
inc %rdi
cmp %rax, %rdi
jl zmien_wielkosc_liter

movb $'\n', textout(, %rdi, 1)


movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textout, %rsi
movq $BUFLEN, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
