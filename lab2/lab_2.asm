.386
.model flat, stdcall
option casemap: none    ;�������� ���������������� � ���������

include c:\masm32\include\kernel32.inc
include c:\masm32\include\masm32.inc
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\masm32.lib

.data
string db 82 dup (0)          ; ����� ��� ������
symbol db 3 dup (0)           ; ����� ��� ���������
buf db 82 dup (0)             ; ����� ��� �������� ����� � ������

hmsg db 'Hello!', 13, 10, 0
msg1 db 'Enter the string (up to 40 characters):', 13, 10, 0
msg2 db 'Enter the symbol(only one symbol):', 13, 10, 0
msg3 db 'String doesn`t contain a symbol', 13, 10, 0
msg4 db 'New string: ',13, 10, 0

.code
start:
    invoke StdOut,  addr hmsg           ; ����� �������������� ������
    invoke StdOut,  addr msg1           ; ����� ����������� ������ ������
    invoke StdIn,   addr string, 40     ; ���� ������
    invoke StdOut,  addr msg2           ; ����� ����������� ������ ������
    invoke StdIn,   addr symbol, 3      ; ���� �������
    
    mov esi, offset string              ; �������� ����� ������ ������
    mov ah, [symbol]                    ; �������� ������� ������
    mov edi, offset buf                 ; �������� ����� ������ ������

find_symbol:
    mov al, [esi]       ; �������� � ������� al ������ �� ������� ��������� esi
    inc esi                     ; '����������' esi
    cmp al, 0                   ; �������� �� ����� ������
    je not_found                ; ���� ������ ����� ������, �� ��������� �� �����
    cmp al, ah                  ; ����� ���������� �������� ������ � ������ �� ������
    je copy_end_of_string       ; ���� �����, �� ��������� � ����������� ���������� ����� ������
    mov [edi], al               ; ����� ��������� ����� ������ (������� �������������� ��������� �������)
    inc edi                     ; '����������' edi
    jmp find_symbol             ; ��������� � ������ �����
    
not_found:
    invoke StdOut, addr msg3    ; ������� ��������� � ���, ��� �������� ������ �� ������
    jmp exit                    ; ��������� � ������ �� ���������

copy_end_of_string:             ; �������� � ����� ������� ����� ��������� �������
    mov ebp, esi                ; ��������� �������� �� esi � edi
    ccl:
        mov al,  [ebp]  ; � al �������� ������ �� ������
        cmp al, 0               ; ���������� � ������ ������
        je string_overwriting   ; ���� ������ ���������, �� ��������� � ���������� �������� ������
        mov  [edi], al  ; ����� � ����� �������� ������ �� al
        inc edi                 ; '����������' edi
        inc ebp                 ; '����������' edp
        jmp ccl                 ; ��������� � ������ �����
        
string_overwriting:             ; ���������� �������� ������
    mov edi, offset buf         ; � edi ���������� ����� ������ ������
    shaping:                    ; ��������� ������
        mov al, [edi]   ; � al �������� ������ ������ �� ������
        cmp al, 0               ; ���������� � ������ ������
        je done                 ; ���� �����, �� ��������� � ������ ���������, � ���, ��� ������ ������������
        mov [esi], al   ; ����� ���������� � �������� ������ ������ �� ������
        inc edi                 ; '����������' edi
        inc esi                 ; '����������' esi
        jmp shaping             ; ��������� � ������ ����� ������������ ������

done:
    invoke StdOut, addr string  ; ������� ��������� �������� ������
    jmp exit                    ; ��������� � ������ �� ���������

exit:
    invoke StdIn, addr buf, 3   ; �������� �������
    invoke ExitProcess, 0       ; ���������� ���������

end start