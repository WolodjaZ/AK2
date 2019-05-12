.data
SYSREAD = 0
SYSWRITE = 1
SYSEXIT = 60
STDOUT = 1
STDIN = 0
STDER = 2
EXIT_SUCCESS = 0
BUFLEN = 512

ERR_MSG: .ascii "Wprowadzona liczba jest niepoprawna!\n" # error message
ER_LEN= .- ERR_MSG

.bss # sekcja generowanie przestrzeni w pamięci
.comm textin, 512 # generacja przestrzeni dla 
.comm textout, 512

.text
.global _start
_start:
nop

movq $SYSREAD, %rax # wczytanie dany z buffora do zmiennej textin
movq $STDIN, %rdi
movq $textin, %rsi
movq $BUFLEN, %rdx
syscall

dec %rax # dekrementacja rax
movq %rax, %r8 # przechowywanie w rejestrze r8 wartości '\n'
inc %rax 
movq $0, %rcx
movq $3, %rbp
movq %rax, %rsp
movq $0, %rax


dekodowanie_do_liczby_dziesiętnej: #etykieta dekodowanie do liczby dziesiętnej
	movb textin(, %rcx, 1), %bl # pobieramy po koleji bajt z textin do rejestru bl 
	cmp $'0', %bl # sprawdzamy czy wartośc nie wychodzi poza <0,2>
	jl blad # jeśli wychodzi przechodzimy do etykiety blad
	cmp $'2', %bl
	jg blad
	sub $'0', %bl
	mul %rbp # mnożymy rejestr rbp z rax
	add %bl, %al #dodajemy do rejestr al(rax) rejestr bl
	inc %rcx
	cmp %r8, %rcx # sprawdzamy czy wartość którą będziemy teraz sprawdzać nie jest już końcem stringu
	jl dekodowanie_do_liczby_dziesiętnej # jeśli tak nie jest wracamy do dekodowania
	movq $0, %rcx # przygotowujemy wszystko do przedokodowania do systemu siódemkowego
	movq $7, %rbp
	jmp dekodowanie_do_liczby_siodemkowej # przechodzimy do etykiety dekodowania do liczby siódemkowej 

dekodowanie_do_liczby_siodemkowej:
	cmp $0, %rax #sprawdzamy czy liczba która mamy nie wynosi zero 
	je koniec #wtedy kończymy program
	movq $0, %rdx  # czyścimy rdx
	div %rbp # dzielimy rax przez wartość 7
	movb %dl, %bl # przenosimy reszte z dzielenia do rejestru bl 
	add $'0', %bl # zamian liczby na ascii
	movb %bl, textout(, %rcx, 1) # przenosimy reszte do buffora do buffora textout
	inc %rcx
	jmp dekodowanie_do_liczby_siodemkowej # powtarzamy działanie

blad: # etykieta wypisania do buffora wyjściowego wartości ERR_MSG
	movq $SYSWRITE, %rax
	movq $STDER, %rdi
	movq $ERR_MSG, %rsi
	movq $ER_LEN, %rdx
	syscall
	jmp zakoncz_program # przeskoczenie do zakończenia programu

koniec: # etykieta wypisania do buffora wyjściowego liczbę która przekodowaliśmy
	movb $'\n', textout(, %rcx, 1) #zakończenie stringa znakiem końca lini
	movq $SYSWRITE, %rax
	movq $STDOUT, %rdi
	movq $textout, %rsi
	movq $BUFLEN, %rdx
	syscall
	jmp zakoncz_program

zakoncz_program: # restart – zakończenie programu
	movq $SYSEXIT, %rax
	movq $EXIT_SUCCESS, %rdi
	syscall
