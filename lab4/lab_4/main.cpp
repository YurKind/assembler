#include <iostream>
#include <string>
#include <stdio.h>

using namespace std;

extern "C" void sayFault() 
{
	cout << "String doesn`t contain a symbol\n";

	system("pause");
}

void findAndRewrite(char* u_string, char u_symbol, char* buf)
{
	__asm
	{
		mov esi, u_string
		mov edi, buf
		mov ah, byte ptr[u_symbol]

		find_symbol:
			mov al, byte ptr[esi]
			inc esi
			cmp al, 0
			je not_found
			cmp al, ah
			je copy_parts_of_string
			jmp find_symbol

		copy_parts_of_string:
			mov ebx, u_string
			beginning_of_string_copy:
				mov al, byte ptr[ebx]
				inc ebx
				cmp al, ah
				je end_of_string_copy
				mov[edi], al
				inc edi
				jmp beginning_of_string_copy
			end_of_string_copy:
				mov al, byte ptr[ebx]
				inc ebx
				cmp al, 0
				je string_overwritting
				mov[edi], al
				inc edi
				jmp end_of_string_copy

			not_found:
				call sayFault
				jmp exit

			string_overwritting:
				mov [edi], 0
				mov edi, buf
				shaping:
					mov al, byte ptr[edi]
					cmp al, 0
					je done
					mov[esi], al
					inc edi
					inc esi
					jmp shaping

			done:
				mov [esi], 0
	}

	cout << u_string << endl;
}

int main()
{
	char* user_string = new char[160];
	char symbol;
	char* buffer = new char[160];
	
	cout << "Hello!\n" << "Enter the string (up to 80 characters):\n";
	cin.getline(user_string, 82, '\n');

	if (strlen(user_string) > 80)
	{
		cout << "Your string contains to many symbols" << endl;
		
		system("pause");
		return 1;
	}

	cout << "Enter the symbol(only one symbol):\n";
	cin.get(symbol);

	findAndRewrite(user_string, symbol, buffer);

	system("pause");
	return 0;
}	