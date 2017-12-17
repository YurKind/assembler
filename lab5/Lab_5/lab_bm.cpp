#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <iostream>


extern "C"
{
	void search();
}

void main()
{
	printf("Hello, it is Boyer-Moore's searching algorithm!\n");
	search();
	while (getchar() != '\n');
}

extern "C" void* setString()
{
	printf("Enter the string (up to 80 characters):\n");

	char* str = new char[100];
	std::cin.getline(str, 82, '\n');

	if (strlen(str) > 80)
	{
		printf("Your string contains to many symbols\n");
		system("pause");
		exit(1);
	}

	return str;
}

extern "C" void* setSubstring()
{
	printf("Enter the substring (up to 80 characters):\n");

	char* substr = new char[100];
	std::cin.getline(substr, 82, '\n');
	
	if (strlen(substr) > 80)
	{
		printf("Your substring contains to many symbols\n");
		system("pause");
		exit(1);
	}
	
	return substr;
}

extern "C" void bmSearch(char* str, char* substr)
{
	int result = 0;
	int j, i, k;

	int substr_table[256];
	int strLength = strlen(str);
	int substrLength = strlen(substr);

	if (strLength > substrLength)
	{
		for (i = 0; i < 256; i++)
		{
			substr_table[i] = substrLength;
		}

		for (i = 0; i < substrLength - 1; i++) {
			substr_table[substr[i]] = substrLength - i;
		}

		i = substrLength - 1;
		j = i;

		while ((j >= 0) && (i <= strLength - 1))
		{
			j = substrLength - 1;
			k = i;

			while ((j >= 0) && (str[k] == substr[j]))
			{
				k--;
				j--;
			}

			i += substr_table[str[i]];
		}

		if (k >= strLength - substrLength)
		{
			printf("String doesn`t contains substring\n");
		}
		else
		{
			result = k + 2;
			std::cout << "String enters substring from " << result << " character" << std::endl;
		}
	}
	else
	{
		printf("String is shorter than substring\n");
	}

}