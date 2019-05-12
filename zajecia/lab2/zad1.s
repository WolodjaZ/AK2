.data
SYSREAD = 0
SYSWRITE = 1
SYSOPEN = 2
SYSCLOSE = 3
FREAD = 0
FWRITE = 1
EXIT_SUCCESS = 0
SYSEXIT = 60

file_in: .ascii "in.txt\0"
file_out: .ascii "out.txt\0" 
 


.bss
.comm out_buffer, 1024
.comm in_buffer, 1024

.text
.global _start
_start:

# Otwarcie pliku $file_in do wczytania
mov $SYSOPEN, %rax  
mov $file_in, %rdi 
mov $FREAD, %rsi   
mov $0, %rdx     
syscall      
push %rax
movq %rax, %r8     

mov $SYSREAD, %rax
mov %r8, %rdi       # Zamiast STDOUT, podajemy id otwartego pliku
mov $out_buffer, %rsi
mov $1024, %rdx
syscall

cos:

dec %rax
dec %rax
movq $0, %r12
movq %rax, %rcx
movq $0, %r11
movq $16, %r10
movq $0, %r8

po_dwie_liczby:
	movq $0, %rax
	movq $0, %rdx
	jmp dekodowanie_do_liczby
pierwsz:
	cmp $1, %r11
	je drugi	
	push %rdx
	dec %rcx
	inc %r11
	cmp %rcx, %rsp
	je zapis_1
	jmp dekodowanie_do_liczby
drugi:
	movb %dl, %al
	movq $0, %rdx
	mul %r10
	dec %rcx
	inc %r11
zapis_1:
	movq $0, %r11
	pop %rdx
	add %al, %dl
	movb %dl, in_buffer(, %r8, 1)
	inc %r8
	cmp %r12, %rcx
	jge po_dwie_liczby
	jmp zapis
	
dekodowanie_do_liczby:
	movb out_buffer(, %rcx, 1), %dl
	cmp $'A', %dl
	jge liter
	cmp $'0', %dl
	jge liczba
	
liter:	
	sub $'A', %dl
	add $10, %dl
	jmp pierwsz
liczba:	
	sub $'0', %dl
	jmp pierwsz

zapis:
	# Zamknięcie pliku
	push %r8
	mov $SYSCLOSE, %rax 
	mov %r8, %rdi       
	syscall

	# Otwarcie pliku $file_out do wczytania
	mov $SYSOPEN, %rax  
	mov $file_out, %rdi 
	mov $FWRITE, %rsi   
	mov $0, %rdx     
	syscall         
	mov %rax, %r8

	mov $SYSWRITE, %rax
	mov %r8, %rdi       # Zamiast STDOUT, podajemy id otwartego pliku
	mov $in_buffer, %rsi
	mov $1024, %rdx
	syscall
	
	mov $SYSCLOSE, %rax 
	mov %r8, %rdi       
	syscall

	movq $SYSEXIT, %rax
	movq $EXIT_SUCCESS, %rdi
	syscall
	
	 
