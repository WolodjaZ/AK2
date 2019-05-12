.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
EXIT_SUCCESS = 0
BUFLEN = 512

.bss
.comm textin1, 512
.comm textin2, 512
.comm textout1, 512
.comm textout2, 512
.comm textout, 512
.comm textin, 512

.text
.global _start
_start:
nop

movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $textin1, %rsi
movq $BUFLEN, %rdx
syscall

push %rax
dec %rax
dec %rax
movq %rax, %rsi
inc %rax
movq $0, %rdi
reverse1:
	cmp %rax, %rdi
	je koniec1
	movb textin1(,%rdi,1), %bl
	movb %bl, textout1(, %rsi, 1)
	dec %rsi
	inc %rdi
	jmp reverse1

koniec1:
movb $'\n', textout1(, %rdi, 1)

movq $SYSREAD, %rax
movq $STDIN, %rdi
movq $textin2, %rsi
movq $BUFLEN, %rdx
syscall

push %rax
dec %rax
dec %rax
movq %rax, %rsi
inc %rax
movq $0, %rdi
reverse2:
	cmp %rax, %rdi
	jge koniec2
	movb textin2(,%rdi,1), %bl
	movb %bl, textout2(, %rsi, 1)
	dec %rsi
	inc %rdi
	jmp reverse2

koniec2:
movb $'\n', textout2(, %rdi, 1)


pop %rdx
pop %rax
dec %rax
dec %rdx
cmp %rax, %rdx
jl first
	
movq %rdx, %r8
dec %rdx
movq %rdx, %r9
inc %rdx
movq %rax, %r10
jmp dalej

first:
	movq %rax, %r8
	dec %rax
	movq %rax, %r9
	inc %rax
	movq %rdx, %r10


dalej:
	movq $0, %rdi
	movb $10, %dl
	clc
	pushf

odejmowanie:
	movb textout1(, %rdi,1), %bl
	movb textout2(, %rdi,1), %cl
	sub $'0', %bl
	sub $'0', %cl
	popf
	adc %cl, %bl
	clc
	cmp %dl, %bl
	jge ustawianie
	powrot:
	pushf
	add $'0', %bl
	movb %bl, textin(, %r9,1)
	inc %rdi
	dec %r9
	cmp %r10, %rdi
	jl odejmowanie
	jmp przejscie

ustawianie:
	sub %dl, %bl
	stc
	jmp powrot

przejscie:
	cmp %r10, %r8
	je koniec
	movq $0, %r11
	cmp %rax, %r8
	je pierwsze
	jmp drugie

pierwsze:
	movb textout1(, %rdi,1), %bl
	adc %r11b, %bl
	clc
	movb %bl,textin(, %r9,1)
	inc %rdi
	dec %r9
	cmp %r8, %rdi
	jl pierwsze
	jmp koniec

drugie:
	movb textout2(, %rdi,1), %cl
	adc %r11b, %cl
	clc
	movb %cl, textin(, %r9,1)
	inc %rdi
	dec %r9
	cmp %r8, %rdi
	jl drugie
	jmp koniec

koniec:
	movb $'\n', textin(, %rdi, 1)

movq $SYSWRITE, %rax
movq $STDOUT, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall

movq $SYSEXIT, %rax
movq $EXIT_SUCCESS, %rdi
syscall
