.686
.MODEL FLAT, C
.STACK
.DATA
str_message db 'Enter the string', 13, 10, 0
sub_message db 'Enter the substring', 13, 10, 0

EXTRN printf: proc
EXTRN setString: proc
EXTRN setSubstring: proc
EXTRN bmSearch: proc

.CODE


search PROC
	;���� ������
	call setString
	mov esi, eax
	;���� ���������
	call setSubstring
	mov edi, eax

	;����� ������ ��������� � ������
	push edi
	push esi
	call bmSearch
	pop esi
	pop edi

	retn

search endp
end