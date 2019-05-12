.data #sekcja inicjalizująca dane
SYSWRITE = 1 # numery funkcji systemowych
SYSEXIT = 60
STDOUT = 1
EXIT_SUCCESS = 0
FIRST = 81 # wartości zmiennych użytych w kodzie
SECOND = 45


.text #sekcja kodu
.global _start # zmienna globalna
_start: # miejsce rozpoczęcia programu
nop


movq $FIRST, %rax # przenosimy zmienne do rejestrów 
movq $SECOND, %rbx # rejestr rax będzie zawierać liczbe dzieloną a rbx dzielnik


euklides: # etykieta kodu euklidesa
movq $0, %rdx 
cmp %rax, %rbx # porównanie rejestru rax i rbx
jne dzielenie # jęsli rejestry nie są równe przeskakujemy do etykiety dzielenie
jmp koniec # jeśli nie przeskoczyliśmy do dzielenia to przeskakujemy do etykiety koniec
dzielenie: # etykieta dzielenia
div %rbx # dzielimy rejestr rbx przez rax
movq %rbx, %rax 
movq %rdx, %rbx
cmp $0, %rbx # sprawdzamy czy reszta jest równa zero
jne euklides # jeśli nie jest równa to powtarzamy działanie wracając do etykiety eukliedes
movq %rax, %rbx
jmp koniec
koniec: # eykieta końca

movq $SYSWRITE, %rax # wypisanie wartości wynikowej poprzez wyprowadzenie zawartości bufora na wyjście  
movq $STDOUT, %rdi
movq %rbx, %rsi
syscall

movq $SYSEXIT, %rax # restart – zakończenie programu
movq $EXIT_SUCCESS, %rdi
syscall

