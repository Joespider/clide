#include <iostream>
#include <fstream>
#include <string>

//print marco for cout
#define print(x); std::cout << x << std::endl

static void help()
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
static std::string getImports(bool write, bool read, bool random)
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
static std::string getMethods(bool rawinput, bool rand, bool write, bool read, bool isin)
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
		WriteFile = "//Write file\nstatic void Write(std::string filename, std::string content)\n{\n\tstd::ofstream myfile;\n\tmyfile.open(filename.c_str());\n\tmyfile << content;\n\tmyfile.close();\n}\n\n";
	}
	if (read == true)
	{
		ReadFile = "//Read file\nstatic void Read(std::string File)\n{\n\tstd::string line;\n\tstd::ifstream myFile(File.c_str());\n\tif (myFile.is_open())\n\t{\n\t\twhile (getline (myFile,line))\n\t\t{\n\t\t\tstd::cout << line << \"\\n\";\n\t\t}\n\t\tmyFile.close();\n\t}\n\telse\n\t{\n\t\tstd::cout << \"file not found\\n\";\n\t}\n}\n\n";
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
static std::string getMain(bool Args, bool getRandom)
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
static void CreateNew(std::string filename, std::string content)
{
	filename = filename+".cpp";
	std::ofstream myfile;
	myfile.open(filename.c_str());
	myfile << content;
	myfile.close();
}

bool IsIn(std::string Str, std::string Sub)
{
	bool found = false;
	if (Str.find(Sub) != std::string::npos)
	{
		found = true;
	}
	return found;
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
