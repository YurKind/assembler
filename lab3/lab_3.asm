.386
.model flat, stdcall
option casemap: none    ;�������� ���������������� � ���������

include c:\masm32\include\kernel32.inc
include c:\masm32\include\masm32.inc
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\masm32.lib
include c:\Users\yurok_e\Documents\code\assembly\lab3\lab_m.mac

.data
string db 82 dup (0)          ; ����� ��� ������
symbol db 3 dup (0)           ; ����� ��� ���������
buf db 82 dup (0)             ; ����� ��� ���������� �������� ������

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
    
    ;�������� ������ � ������ � �������� esi � ah ��������������
    copy_sources string, symbol
    ;���� ������ �� ah, � ������ �� edi
    find_symbol
    ;�������� ����� ������ ������������ (ebp) � ����� (edi)
    copy_parts_of_string buf, string
    ;�������������� ������ (esi) �� ������ (edi)
    string_overwritting buf

end start
