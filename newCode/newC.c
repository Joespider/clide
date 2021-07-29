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

void print(char Out[])
{
	printf("%s\n",Out);
}

void help()
{
	print("Author: Joespider");
	print("Program: \"newC\"");
	print("Version: 0.0.05");
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

	char UserIn[] = "";
	char CName[] = "";
	char Imports[] = "";
	char MarcoPrint[] = "";
	char MarcoLen[] = "";
	char Marcos[] = "";
	char Methods[] = "";
	char Main[] = "";
	char Content[] = "";
	if (argc > 1)
	{
		//loop through args
		for (int i = 1; i < argc; i++)
		{
			//Get name of program
			if ((strcmp(argv[i],"-n") == 0) || (strcmp(argv[i],"--name") == 0))
			{
				getName = 0;
			}
			//Get cli arg in main method
			else if (strcmp(argv[i],"--cli") == 0)
			{
				getName = 1;
				getArgs = 0;
			}
			//Is a main
			else if (strcmp(argv[i],"--main") == 0)
			{
				getName = 1;
				IsMain = 0;
			}
			//Get Random method
			else if (strcmp(argv[i],"--random") == 0)
			{
				getName = 1;
				getRand = 0;
			}
			//Get Write file method
			else if(strcmp(argv[i],"--write-file") == 0)
			{
				getName = 1;
				getWrite = 0;
			}
			//Get Read file method
			else if (strcmp(argv[i],"--read-file") == 0)
			{
				getName = 1;
				getRead = 0;
			}
			//Get IsIn method
			else if (strcmp(argv[i],"--is-in") == 0)
			{
				getName = 1;
				getIsIn = 0;
			}
			//Get raw_input method
			else if (strcmp(argv[i],"--user-input") == 0)
			{
				getName = 1;
				getRawIn = 0;
			}
			//capture new C++ program name
			else if (getName == 0)
			{
				NameIsNotOk = IsIn(argv[i],"--");
				if (NameIsNotOk == 1)
				{
					//strcpy(CName,argv[i]);
					//print(CName);
					print(argv[i]);
				}
				getName = 1;
			}
		}
		//Ensure program name is given
		if (strcmp(CName,"") != 0)
		{
			print("WE Have lift-off");
/*
			Imports = getImports(getWrite,getRead,getRand);
			MarcoPrint = "//print marco for cout\n#define print(x); std::cout << x << std::endl\n";
			MarcoLen = "//len marco for sizeof\n#define len(item) (sizeof(item))\n";
			Marcos = MarcoPrint+MarcoLen+"\n";
			Methods =  getMethods(getRawIn,getRand,getWrite,getRead,getIsIn);
			if (IsMain == true)
			{
				Main = getMain(getArgs,getRand);
			}
			else
			{
				Main = "";
			}
			Content = Imports+Marcos+Methods+Main;
			CreateNew(CName,Content);
*/
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















//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------













/*

#include <iostream>
#include <fstream>
#include <string>

//print marco for cout
#define print(x); std::cout << x << std::endl

void help()
{
	std::string ProgName = "newC++";
	std::string Version = "0.1.08";
	print("Author: Joespider");
	print("Program: \"" << ProgName << "\"");
	print("Version: " << Version);
	print("Purpose: make new C++ programs");
	print("Usage: " << ProgName << " <args>");
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

//create import listing
char* getImports(bool write, bool read, bool random)
{
	std::string Imports = "";
	std::string standard = "#include <iostream>\n#include <string>\n";
	std::string readWrite = "";
	std::string ForRandom = "";
	if ((read == true) || (write == true))
	{
		readWrite = "#include <fstream>\n";
	}
	if (random == true)
	{
		ForRandom = "#include <stdlib.h>\n#include <time.h>\n";
	}

	Imports = standard+readWrite+ForRandom+"\n";

	return Imports;
}

//create base methods
char* getMethods(bool rawinput, bool rand, bool write, bool read, bool isin)
{
	std::string Methods = "";
	std::string Random = "";
	std::string RawInput = "";
	std::string WriteFile = "";
	std::string ReadFile = "";
	std::string IsIn = "";

	if (rawinput == true)
	{
		RawInput = "//User Input\nstd::string raw_input(std::string message)\n{\n\tstd::string UserIn;\n\tstd::cout << message;\n\tgetline (std::cin,UserIn);\n\treturn UserIn;\n}\n\n";
	}
	if (write == true)
	{
		WriteFile = "//Write file\nvoid Write(std::string filename, std::string content)\n{\n\tstd::ofstream myfile;\n\tmyfile.open(filename.c_str());\n\tmyfile << content;\n\tmyfile.close();\n}\n\n";
	}
	if (read == true)
	{
		ReadFile = "//Read file\nvoid Read(std::string File)\n{\n\tstd::string line;\n\tstd::ifstream myFile(File.c_str());\n\tif (myFile.is_open())\n\t{\n\t\twhile (getline (myFile,line))\n\t\t{\n\t\t\tstd::cout << line << \"\\n\";\n\t\t}\n\t\tmyFile.close();\n\t}\n\telse\n\t{\n\t\tstd::cout << \"file not found\\n\";\n\t}\n}\n\n";
	}
	if (rand == true)
	{
		Random = "//Get Random int\nint random(int min, int max)\n{\n\tint Val;\n\tVal = rand()%max+min;\n\treturn Val;\n}\n\n";
	}
	if (isin == true)
	{
		IsIn = "//Check if sub-string is in string\nbool IsIn(std::string Str, std::string Sub)\n{\n\tbool found = false;\n\tif (Str.find(Sub) != std::string::npos)\n\t{\n\t\tfound = true;\n\t}\n\treturn found;\n}\n\n";
	}
	//Methods for C++
	Methods = RawInput+Random+IsIn+WriteFile+ReadFile;

	return Methods;
}

//build main function
std::string getMain(bool Args, bool getRandom)
{
	std::string Main = "";
	std::string StartRandom = "";

	if (getRandom == true)
	{
		StartRandom = "\t//Enable Random\n\tsrand(time(NULL));\n";
	}

	if (Args == true)
	{
		Main = "//C++ Main...with cli arguments\nint main(int argc, char** argv)\n{\n"+StartRandom+"\tstd::string out = \"\";\n\t//Args were given\n\tif (argc > 1)\n\t{\n\t\t//Loop through Args\n\t\tfor (int i = 1; i < argc; i++)\n\t\t{\n\t\t\tout = std::string(argv[i]);\n\t\t\tif (out == \"find\")\n\t\t\t{\n\t\t\t\tprint(\"Found\");\n\t\t\t\tbreak;\n\t\t\t}\n\t\t}\n\t}\n\n\treturn 0;\n}\n";
	}
	else
	{
		Main = "//C++ Main\nint main()\n{\n"+StartRandom+"\n\treturn 0;\n}\n";
	}
	return Main;
}

//create new c++ program
void CreateNew(std::string filename, std::string content)
{
	filename = filename+".cpp";
	std::ofstream myfile;
	myfile.open(filename.c_str());
	myfile << content;
	myfile.close();
}

//C++ main
int main(int argc, char** argv)
{
	bool NameIsNotOk = true;
	bool getName = false;
	bool getArgs = false;
	bool getRand = false;
	bool getWrite = false;
	bool getRead = false;
	bool getIsIn = false;
	bool getRawIn = false;
	bool IsMain = false;
	std::string UserIn = "";
	std::string CName = "";
	std::string Imports = "";
	std::string MarcoPrint = "";
	std::string MarcoLen = "";
	std::string Marcos = "";
	std::string Methods = "";
	std::string Main = "";
	std::string Content = "";
	if (argc > 1)
	{
		//loop through args
		for (int i = 1; i < argc; i++)
		{
			//Save output to UserIn
			UserIn = std::string(argv[i]);
			//Get name of program
			if ((UserIn == "-n") || (UserIn == "--name"))
			{
				getName = true;
			}
			//Get cli arg in main method
			else if (UserIn == "--cli")
			{
				getName = false;
				getArgs = true;
			}
			//Is a main
			else if (UserIn == "--main")
			{
				getName = false;
				IsMain = true;
			}
			//Get Random method
			else if (UserIn == "--random")
			{
				getName = false;
				getRand = true;
			}
			//Get Write file method
			else if (UserIn == "--write-file")
			{
				getName = false;
				getWrite = true;
			}
			//Get Read file method
			else if (UserIn == "--read-file")
			{
				getName = false;
				getRead = true;
			}
			//Get IsIn method
			else if (UserIn == "--is-in")
			{
				getName = false;
				getIsIn = true;
			}
			//Get raw_input method
			else if (UserIn == "--user-input")
			{
				getName = false;
				getRawIn = true;
			}
			//capture new C++ program name
			else if (getName == true)
			{
				NameIsNotOk = IsIn(UserIn,"--");
				if (NameIsNotOk == false)
				{
					CName = UserIn;
				}
				getName = false;
			}
		}
		//Ensure program name is given
		if (CName != "")
		{
			Imports = getImports(getWrite,getRead,getRand);
			MarcoPrint = "//print marco for cout\n#define print(x); std::cout << x << std::endl\n";
			MarcoLen = "//len marco for sizeof\n#define len(item) (sizeof(item))\n";
			Marcos = MarcoPrint+MarcoLen+"\n";
			Methods =  getMethods(getRawIn,getRand,getWrite,getRead,getIsIn);
			if (IsMain == true)
			{
				Main = getMain(getArgs,getRand);
			}
			else
			{
				Main = "";
			}
			Content = Imports+Marcos+Methods+Main;
			CreateNew(CName,Content);
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
*/
