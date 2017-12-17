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
	;ввод строки
	call setString
	mov esi, eax
	;ввод подстроки
	call setSubstring
	mov edi, eax

	;вызов поиска подстроки в строке
	push edi
	push esi
	call bmSearch
	pop esi
	pop edi

	retn

search endp
end