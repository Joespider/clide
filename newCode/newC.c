#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define bool int
#define false 1
#define true 0

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
	print("Version: 0.0.13");
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

void getMarcos(FILE *file)
{
	fputs("#define bool int\n#define false 1\n#define true 0\n\n", file);
}

void getMethods(FILE *file, bool getRawIn, bool getRand, bool getWrite, bool getRead, bool getIsIn)
{
	fputs("void print(char *Out)\n{\n\tprintf(\"%s\\n\",Out);\n}\n\n",file);
	if (getIsIn == true)
	{
		fputs("int IsIn(char Str[], char Sub[])\n{\n\tint found = 1;\n\tif (strstr(Str,Sub) != NULL)\n\t{\n\t\tfound = 0;\n\t}\n\treturn found;\n}\n", file);
	}
	fputs("\n", file);
}

void getMain(FILE *file, bool getArgs, int getRand)
{
	if (getArgs == true)
	{
		fputs("//C Main\nint main(int argc, char *argv[])\n{\n\n\tif (argc > 1)\n\t{\n\t\t//loop through args\n\t\tfor (int i = 1; i < argc; i++)\n\t\t{\n\t\t\tprint(argv[i]);\n\t\t}\n\t}\n\n\treturn 0;\n}\n", file);
	}
	else
	{
		fputs("//C Main\nint main()\n{\n\n\treturn 0;\n}\n", file);
	}
}

bool IsIn(char Str[], char Sub[])
{
	bool found = false;
	if (strstr(Str,Sub) != NULL)
	{
		found = true;
	}
	return found;
}

//C Main
int main(int argc, char *argv[])
{
	bool NameIsNotOk = false;
	bool getName = false;
	bool getArgs = false;
	bool getRand = false;
	bool getWrite = false;
	bool getRead = false;
	bool getIsIn = false;
	bool getRawIn = false;
	bool IsMain = false;
	int LenOfName = 0;
	char TheExt[2];

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
					LenOfName = strlen(argv[i]);
					CName = argv[i];
				}
				getName = 1;
			}
			//Get name of program
			else if ((strcmp(argv[i],"-n") == true) || (strcmp(argv[i],"--name") == true))
			{
				getName = true;
			}
			else if (strcmp(argv[i],"--cli") == true)
			{
				getArgs = true;
			}
			else if (strcmp(argv[i],"--main") == true)
			{
				IsMain = true;
			}
			else if (strcmp(argv[i],"--is-in") == true)
			{
				getIsIn = true;
			}
			else if (strcmp(argv[i],"--random") == true)
			{
				getRand = true;
			}
			else if (strcmp(argv[i],"--write-file") == true)
			{
				getWrite = true;
			}
			else if (strcmp(argv[i],"--read-file") == true)
			{
				getRead = true;
			}
			else if (strcmp(argv[i],"--user-input") == true)
			{
				getRawIn = true;
			}
		}

		//Ensure program name is given
		if (strcmp(CName,"") != true)
		{
			FILE * fp;
			if (LenOfName >= 3)
			{
				strncpy(TheExt,&CName[LenOfName-2], 2);
				if (strcmp(TheExt,".c") == 0)
				{
					fp = fopen(CName, "w");
				}
				else
				{
					fp = fopen(strcat(CName,".c"), "w");
				}
			}
			else
			{
				fp = fopen(strcat(CName,".c"), "w");
			}
			getImports(fp);
			getMarcos(fp);
			getMethods(fp, getRawIn, getRand, getWrite, getRead, getIsIn);
			if (IsMain == true)
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
