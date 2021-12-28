#include <stdio.h>
#include <string.h>
#include <stdlib.h>

/*
Method	Description
strcat()	It is used to concatenate(combine) two strings
strlen()	It is used to show the length of a string
strrev()	It is used to show the reverse of a string
strcpy()	Copies one string into another
strcmp()	It is used to compare two string

Note that strstr returns a pointer to the start of the word in sent if the word word is found.
if(strstr(sent, word) != NULL) {

}
*/

void print(char *Out)
{
	printf("%s\n",Out);
}

void help()
{
	print("Author: Joespider");
	print("Program: \"newC\"");
	print("Version: 0.0.10");
	print("Purpose: make new C programs");
	print("Usage: newC <args>");
	print("\t-n <name> : program name");
	print("\t--name <name> : program name");
	print("\t--cli : enable command line (Main file ONLY)");
	print("\t--main : main file");
	print("\t--random : enable \"random\" int method");
	print("\t--write-file : enable \"write\" file method");
	print("\t--read-file : enable \"read\" file method");
	print("\t--is-in : enable \"IsIn\" file method");
	print("\t--user-input : enable \"Raw_Input\" file method");
}

//void getImports(int getWrite, int getRead ,int getRand)
//void getImports(char *ReturnImports, int getWrite, int getRead ,int getRand)
//void getImports(char *ReturnImports[])
void getImports(FILE *file)
{
	fputs("#include <stdio.h>\n#include <string.h>\n#include <stdlib.h>\n\n", file);
}

void getMethods(FILE *file, int getRawIn, int getRand, int getWrite, int getRead, int getIsIn)
{
	fputs("void print(char *Out)\n{\n\tprintf(\"%s\\n\",Out);\n}\n\n",file);
	if (getIsIn == 0)
	{
		fputs("int IsIn(char Str[], char Sub[])\n{\n\tint found = 1;\n\tif (strstr(Str,Sub) != NULL)\n\t{\n\t\tfound = 0;\n\t}\n\treturn found;\n}\n", file);
	}
	fputs("\n", file);
}

void getMain(FILE *file, int getArgs, int getRand)
{
	if (getArgs == 0)
	{
		fputs("//C Main\nint main(int argc, char *argv[])\n{\n\n\tif (argc > 1)\n\t{\n\t\t//loop through args\n\t\tfor (int i = 1; i < argc; i++)\n\t\t{\n\t\t\tprint(argv[i]);\n\t\t}\n\t}\n\n\treturn 0;\n}\n", file);
	}
	else
	{
		fputs("//C Main\nint main()\n{\n\n\treturn 0;\n}\n", file);
	}
}

int IsIn(char Str[], char Sub[])
{
	int found = 1;
	if (strstr(Str,Sub) != NULL)
	{
		found = 0;
	}
	return found;
}

//C Main
int main(int argc, char *argv[])
{
	int NameIsNotOk = 1;
	int getName = 1;
	int getArgs = 1;
	int getRand = 1;
	int getWrite = 1;
	int getRead = 1;
	int getIsIn = 1;
	int getRawIn = 1;
	int IsMain = 1;

	char *CName;

	if (argc > 1)
	{
		//loop through args
		for (int i = 1; i < argc; i++)
		{
			//capture new C++ program name
			if (getName == 0)
			{
				NameIsNotOk = IsIn(argv[i],"--");
				if (NameIsNotOk == 1)
				{
//					strcat(argv[i],".c");
					CName = argv[i];
				}
				getName = 1;
			}
			//Get name of program
			else if ((strcmp(argv[i],"-n") == 0) || (strcmp(argv[i],"--name") == 0))
			{
				getName = 0;
			}
			else if (strcmp(argv[i],"--cli") == 0)
			{
				getArgs = 0;
			}
			else if (strcmp(argv[i],"--main") == 0)
			{
				IsMain = 0;
			}
			else if (strcmp(argv[i],"--is-in") == 0)
			{
				getIsIn = 0;
			}
			else if (strcmp(argv[i],"--random") == 0)
			{
				getRand = 0;
			}
			else if (strcmp(argv[i],"--write-file") == 0)
			{
				getWrite = 0;
			}
			else if (strcmp(argv[i],"--read-file") == 0)
			{
				getRead = 0;
			}
			else if (strcmp(argv[i],"--user-input") == 0)
			{
				getRawIn = 0;
			}
		}

		//Ensure program name is given
		if (strcmp(CName,"") != 0)
		{
			FILE * fp;
			fp = fopen(CName, "w");
			getImports(fp);
			getMethods(fp, getRawIn, getRand, getWrite, getRead, getIsIn);
			if (IsMain == 0)
			{
				getMain(fp, getArgs, getRand);
			}
			fclose(fp);
		}
		//No Program name...show help page
		else
		{
			help();
		}
	}
	else
	{
		help();
	}
	return 0;
}
