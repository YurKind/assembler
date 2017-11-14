.386
.model flat, stdcall
option casemap: none    ;включена чувтсвительность к регистрам

include c:\masm32\include\kernel32.inc
include c:\masm32\include\masm32.inc
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\masm32.lib

.data
string db 81 dup (0)          ; буфер для строки
substring db 81 dup (0)       ; буфер для подстроки
buf db 15 dup (0)             ; буфер для перевода числа в строку

hmsg db 'Hello. It is a searching algorithm!', 13, 10, 0
msg1 db 'Enter the text (up to 80 characters):', 13, 10, 0
msg2 db 'Enter the substring (up to 80 characters):', 13, 10, 0
msg3 db 'Text doesn`t contain substring', 13, 10, 0
msg4 db 'Text contains substring from position ', 0

.code
start:
    invoke StdOut, addr hmsg            ;вывод приветственного сообщения
    
    invoke StdOut, addr msg1            ;приглашение к вводу строки 
    invoke StdIn, addr string, 80       ;ввод с клавиатуры строки
    
    invoke StdOut, addr msg2            ;приглашение к ввводу подстроки
    invoke StdIn, addr substring, 80    ;ввод подстроки
    
    mov ebx, offset string          ;загружаем адрес строки
    mov esi, offset substring       ;загружаем адрес подстроки
    
    call findSbstr                  ;вызываем поиск подстроки
    and eax, eax                    ;проверка на вхождение строки
    jnz print_rslt                  ;если строка найдена, то выводим результат
    invoke StdOut, addr msg3        ;если строка не найдена
    jmp exit
    
print_rslt:
    mov esi, offset buf             ;загружаем адрес буфера
    call intToString                ;вызываем перевод числа в строку
    invoke StdOut, addr msg4
    invoke StdOut, esi

exit:
    invoke StdIn, addr buf, 3
    invoke ExitProcess, 0

findSbstr proc
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    cld
    
    ;вычисляем длину подстроки
    mov edi, esi    ;пересылаем адрес подстроки
    xor al, al      ;ищем "/0"
    mov ecx, 80
    repnz scasb     ;сравниваем al с [edi]
    mov edx, 79     
    sub edx, ecx    ;длина подстроки
    
    ;вычисляем длину строки
    mov edi, ebx    ;пересылаем адрес начала строки
    mov ecx, -1         
    repnz scasb
    not ecx
    dec ecx
    
    
    mov edi, ebx    ;пересылаем адрес начала строки
    mov al, [esi]   ;загружаем первый символ подстроки
    
srch:
    repne scasb     ;поиск символа в строке пока не совпадёт, и ecx>0
    jne not_found   ;переходим, если символ не найден
    push edi        ;сохраняем позицию в строке
    push ecx        ;и длину строки
    inc ecx
    cmp ecx, edx    ;сравниваем длину оставшейся строки и подстроки
    jb not_cmp      ;если строка меньше, то не сравниваем
    dec edi
    
    ;сравниваем строки
    mov ecx, edx    ;загружаем длину подстроки
    push esi        ;сохраняем адрес подстроки
    repe cmpsb      ;пока они равны и ecx > 0
    pop esi         ;восстанавливаем адрес подстроки
    pop ecx         ;восстанавливаем длину строки
    pop edi         ;восстанавливаем адрес позиции в строке
    jne srch        ;переходим, если неравны
    
    mov eax, edi    ;вычисляем поизицию
    sub eax, ebx    ;в строке
    jmp srch_exit   ;заканчиваем поиск
    
not_cmp:
    pop ecx
    pop edi

not_found:
    xor eax, eax
    
srch_exit:
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    
findSbstr endp
        
intToString proc
    push ebx
    push edx
    push eax
    
    add esi, 15         ;устанавливаем на конец буфера
    mov byte ptr[esi], 0;записываем 0 в буфер
    mov ebx, 10         ;делитель

ccl:
    dec esi         ;смещение на предыдущию позицию буфера
    xor edx, edx    
    div ebx
    add dl, '0'
    mov [esi], dl
    and eax, eax
    jnz ccl
    
    pop eax
    pop edx
    pop ebx
    ret
    
intToString endp
        
end start