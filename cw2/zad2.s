.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
STDER = 2
EXIT_SUCCESS = 0
BUFLEN = 512


ERR_MSG: .ascii "Wprowadzona liczba jest niepoprawna!\n"
ER_LEN= .- ERR_MSG

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
movq %rax, %r8
inc %rax
movq $0, %rcx
movq $3, %rbp
movq %rax, %rsp
movq $0, %rax
# zamienić wszystkie rejestry które można na jedno bajtowe
# mozliwa zamiana podawania parametrów w funkcjach
dekodowanie_do_liczby_dziesiętnej:
	movb textin(, %rcx, 1), %bl
	cmp $'0', %bl
	jl blad
	cmp $'2', %bl
	jg blad
	sub $'0', %bl
	mul %rbp
	add %bl, %al 
	inc %rcx
	cmp %r8, %rcx
	jl dekodowanie_do_liczby_dziesiętnej
	movq $0, %rcx
	movq $7, %rbp
	jmp dekodowanie_do_liczby_siodemkowej

dekodowanie_do_liczby_siodemkowej:
	cmp $0, %rax
	je koniec
	movq $0, %rdx 
	div %rbp
	movb %dl, %bl
	add $'0', %bl
	movb %bl, textout(, %rcx, 1)
	inc %rcx
	jmp dekodowanie_do_liczby_siodemkowej

blad:
	movq $SYSWRITE, %rax
	movq $STDER, %rdi
	movq $ERR_MSG, %rsi
	movq $ER_LEN, %rdx
	syscall
	jmp zakoncz_program

koniec:
	movb $'\n', textout(, %rcx, 1)
	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $textout, %rsi
	movq $BUFLEN, %rdx
	syscall
	jmp zakoncz_program

zakoncz_program:
	movq $SYSEXIT, %rax
	movq $EXIT_SUCCESS, %rdi
	syscall
