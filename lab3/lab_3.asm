.386
.model flat, stdcall
option casemap: none    ;включена чувтсвительность к регистрам

include c:\masm32\include\kernel32.inc
include c:\masm32\include\masm32.inc
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\masm32.lib
include c:\Users\yurok_e\Documents\code\assembly\lab3\lab_m.mac

.data
string db 82 dup (0)          ; буфер для строки
symbol db 3 dup (0)           ; буфер для подстроки
buf db 82 dup (0)             ; буфер для временного хранения строки

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
    
    ;копирует строку и символ в регистры esi и ah соответственно
    copy_sources string, symbol
    ;ищет символ из ah, в строке из edi
    find_symbol
    ;копирует части строки пользователя (ebp) в буфер (edi)
    copy_parts_of_string buf, string
    ;перезаписывает строку (esi) из буфера (edi)
    string_overwritting buf

end start
