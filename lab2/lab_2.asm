.386
.model flat, stdcall
option casemap: none    ;включена чувтсвительность к регистрам

include c:\masm32\include\kernel32.inc
include c:\masm32\include\masm32.inc
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\masm32.lib

.data
string db 82 dup (0)          ; буфер для строки
symbol db 3 dup (0)           ; буфер для подстроки
buf db 82 dup (0)             ; буфер для перевода числа в строку

hmsg db 'Hello!', 13, 10, 0
msg1 db 'Enter the string (up to 40 characters):', 13, 10, 0
msg2 db 'Enter the symbol(only one symbol):', 13, 10, 0
msg3 db 'String doesn`t contain a symbol', 13, 10, 0
msg4 db 'New string: ',13, 10, 0

.code
start:
    invoke StdOut,  addr hmsg           ; вывод приветственной строки
    invoke StdOut,  addr msg1           ; вывод приглашения ввести строку
    invoke StdIn,   addr string, 40     ; ввод строки
    invoke StdOut,  addr msg2           ; вывод приглашения ввести символ
    invoke StdIn,   addr symbol, 3      ; ввод символа
    
    mov esi, offset string              ; копируем адрес начала строки
    mov ah, [symbol]                    ; копируем искомый символ
    mov edi, offset buf                 ; копируем адрес начала буфера

find_symbol:
    mov al, [esi]       ; помещаем в регистр al символ на который указывает esi
    inc esi                     ; 'перемещаем' esi
    cmp al, 0                   ; проверка на конец строки
    je not_found                ; если найден конец строки, то переходим на выход
    cmp al, ah                  ; иначе сравниваем введённый символ и символ из строки
    je copy_end_of_string       ; если равны, то переходим к копированию оставшейся части строки
    mov [edi], al               ; иначе формируем часть строки (символы предшествующие введённому символу)
    inc edi                     ; 'перемещаем' edi
    jmp find_symbol             ; переходим к началу цикла
    
not_found:
    invoke StdOut, addr msg3    ; выводим сообщение о том, что введённый символ не найден
    jmp exit                    ; переходим к выходу из программы

copy_end_of_string:             ; копируем в буфер символы после введённого символа
    mov ebp, esi                ; сохраняем значение из esi в edi
    ccl:
        mov al,  [ebp]  ; в al помещаем символ из строки
        cmp al, 0               ; сравниваем с концом строки
        je string_overwriting   ; если строка кончилась, то переходим к перезаписи исходной строки
        mov  [edi], al  ; иначе в буфер помещаем символ из al
        inc edi                 ; 'перемещаем' edi
        inc ebp                 ; 'перемещаем' edp
        jmp ccl                 ; переходим к началу цикла
        
string_overwriting:             ; перезапись исходной строки
    mov edi, offset buf         ; в edi записываем адрес начала буфера
    shaping:                    ; формируем строку
        mov al, [edi]   ; в al помещаем первый символ из буфера
        cmp al, 0               ; сравниваем с концом строки
        je done                 ; если конец, то переходим к выводу сообщения, о том, что строка сформирована
        mov [esi], al   ; иначе перемещаем в исходную строку символ из буфера
        inc edi                 ; 'перемещаем' edi
        inc esi                 ; 'перемещаем' esi
        jmp shaping             ; переходим к началу цикла формирования строки

done:
    invoke StdOut, addr string  ; выводим изменённую исходную строку
    jmp exit                    ; переходим к выходу из программы

exit:
    invoke StdIn, addr buf, 3   ; задержка консоли
    invoke ExitProcess, 0       ; завершение программы

end start