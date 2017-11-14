.386
.model flat, stdcall
option casemap: none    ;�������� ���������������� � ���������

include c:\masm32\include\kernel32.inc
include c:\masm32\include\masm32.inc
includelib c:\masm32\lib\kernel32.lib
includelib c:\masm32\lib\masm32.lib

.data
string db 81 dup (0)          ; ����� ��� ������
substring db 81 dup (0)       ; ����� ��� ���������
buf db 15 dup (0)             ; ����� ��� �������� ����� � ������

hmsg db 'Hello. It is a searching algorithm!', 13, 10, 0
msg1 db 'Enter the text (up to 80 characters):', 13, 10, 0
msg2 db 'Enter the substring (up to 80 characters):', 13, 10, 0
msg3 db 'Text doesn`t contain substring', 13, 10, 0
msg4 db 'Text contains substring from position ', 0

.code
start:
    invoke StdOut, addr hmsg            ;����� ��������������� ���������
    
    invoke StdOut, addr msg1            ;����������� � ����� ������ 
    invoke StdIn, addr string, 80       ;���� � ���������� ������
    
    invoke StdOut, addr msg2            ;����������� � ������ ���������
    invoke StdIn, addr substring, 80    ;���� ���������
    
    mov ebx, offset string          ;��������� ����� ������
    mov esi, offset substring       ;��������� ����� ���������
    
    call findSbstr                  ;�������� ����� ���������
    and eax, eax                    ;�������� �� ��������� ������
    jnz print_rslt                  ;���� ������ �������, �� ������� ���������
    invoke StdOut, addr msg3        ;���� ������ �� �������
    jmp exit
    
print_rslt:
    mov esi, offset buf             ;��������� ����� ������
    call intToString                ;�������� ������� ����� � ������
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
    
    ;��������� ����� ���������
    mov edi, esi    ;���������� ����� ���������
    xor al, al      ;���� "/0"
    mov ecx, 80
    repnz scasb     ;���������� al � [edi]
    mov edx, 79     
    sub edx, ecx    ;����� ���������
    
    ;��������� ����� ������
    mov edi, ebx    ;���������� ����� ������ ������
    mov ecx, -1         
    repnz scasb
    not ecx
    dec ecx
    
    
    mov edi, ebx    ;���������� ����� ������ ������
    mov al, [esi]   ;��������� ������ ������ ���������
    
srch:
    repne scasb     ;����� ������� � ������ ���� �� �������, � ecx>0
    jne not_found   ;���������, ���� ������ �� ������
    push edi        ;��������� ������� � ������
    push ecx        ;� ����� ������
    inc ecx
    cmp ecx, edx    ;���������� ����� ���������� ������ � ���������
    jb not_cmp      ;���� ������ ������, �� �� ����������
    dec edi
    
    ;���������� ������
    mov ecx, edx    ;��������� ����� ���������
    push esi        ;��������� ����� ���������
    repe cmpsb      ;���� ��� ����� � ecx > 0
    pop esi         ;��������������� ����� ���������
    pop ecx         ;��������������� ����� ������
    pop edi         ;��������������� ����� ������� � ������
    jne srch        ;���������, ���� �������
    
    mov eax, edi    ;��������� ��������
    sub eax, ebx    ;� ������
    jmp srch_exit   ;����������� �����
    
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
    
    add esi, 15         ;������������� �� ����� ������
    mov byte ptr[esi], 0;���������� 0 � �����
    mov ebx, 10         ;��������

ccl:
    dec esi         ;�������� �� ���������� ������� ������
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