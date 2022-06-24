#include <iostream>
#include <fstream>
#include <string>

//print marco for cout
#define print(x); std::cout << x << std::endl

static void help();
static std::string getMarcos();
static std::string getImports(bool* write, bool* read, bool* random, bool* pipe, bool* shell, bool* threads, bool* sleep, bool* prop);
static std::string getMethods(bool* rawinput, bool* rand, bool* write, bool* read, bool* isin, bool* shell, bool* sleep, bool* prop);
static std::string getMain(bool* Args, bool* getRandom, bool* pipe, bool* threads);
static void CreateNew(std::string filename, std::string content, std::string ext);
bool IsIn(std::string Str, std::string Sub);

static void help()
{
	std::string ProgName = "newC++";
	std::string Version = "0.1.26";
	print("Author: Joespider");
	print("Program: \"" << ProgName << "\"");
	print("Version: " << Version);
	print("Purpose: make new C++ programs");
	print("Usage: " << ProgName << " <args>");
	print("\t-n <name> : program name");
	print("\t--name <name> : program name");
	print("\t--ext <extension> : choose an extension (.cpp is default)");
	print("\t--cli : enable command line (Main file ONLY)");
	print("\t--main : main file");
	print("\t--prop : enable custom system property");
	print("\t--pipe : enable piping (Main file ONLY)");
	print("\t--shell : unix shell");
	print("\t--split : enable \"split\" function");
	print("\t--join : enable \"join\" function");
	print("\t--random : enable \"random\" int method");
	print("\t--write-file : enable \"write\" file method");
	print("\t--read-file : enable \"read\" file method");
	print("\t--is-in : enable \"IsIn\" file method");
	print("\t--user-input : enable \"raw_input\" method");
	print("\t--thread : enable threading");
	print("\t--sleep : enable sleep method");
}

static std::string getMarcos()
{
	std::string Marcos = "";
	std::string MarcoPrint = "//print marco for cout\n#define print(x); std::cout << x << std::endl\n";
/*
	std::string MarcoLen = "//len marco for sizeof\n#define len(item) (sizeof(item))\n";
	Marcos = MarcoPrint+MarcoLen+"\n";
*/
	Marcos = MarcoPrint+"\n";
	return Marcos;
}

//create import listing
static std::string getImports(bool* write, bool* read, bool* random, bool* pipe, bool* shell, bool* threads, bool* sleep, bool* prop, bool* Split, bool* Join)
{
	std::string Imports = "";
	std::string standard = "#include <iostream>\n#include <string>\n";
	std::string readWrite = "";
	std::string ForRandom = "";
	std::string ForPiping = "";
	std::string ForSysProp = "";
	std::string ForShell = "";
	std::string ForThreading = "";
	std::string ForSleep = "";
	std::string ForSplit = "";
	std::string ForJoin = "";

	if ((*read == true) || (*write == true))
	{
		readWrite = "#include <fstream>\n";
	}
	if (*random == true)
	{
		ForRandom = "#include <stdlib.h>\n#include <time.h>\n";
	}
	if (*pipe == true)
	{
		ForPiping = "#include <unistd.h>\n";
	}
	if (*shell == true)
	{
		ForShell = "#include <stdexcept>\n#include <stdio.h>\n";
	}
	if ((*threads == true) || (*sleep == true))
	{
		ForThreading = "#include <thread>\n";
	}
	if (*sleep == true)
	{
		ForSleep = "#include <chrono>\n";
	}
	if (*prop == true)
	{
		ForSysProp = "#include <cstdlib>\n";
	}
	if ((*Split == true) || (*Join == true))
	{
		ForJoin = "#include <vector>\n";
	}
	if (*Split == true)
	{
		ForSplit = "#include <sstream>\n";
	}

	//concat imports
	Imports = standard+readWrite+ForRandom+ForPiping+ForShell+ForThreading+ForSleep+ForSysProp+ForSplit+ForJoin+"\n";

	return Imports;
}

//create base methods
static std::string getMethods(bool* rawinput, bool* rand, bool* write, bool* read, bool* isin, bool* shell, bool* sleep, bool* prop, bool* Split, bool* Join)
{
	std::string Declaration = "";
	std::string Methods = "";
	std::string Random = "";
	std::string RawInput = "";
	std::string WriteFile = "";
	std::string ReadFile = "";
	std::string IsIn = "";
	std::string TheShell = "";
	std::string TheSleep = "";
	std::string SysProp = "";
	std::string StrSplit = "";
	std::string StrJoin = "";

	if (*rawinput == true)
	{
		Declaration = "std::string raw_input(std::string message);\n";
		RawInput = "//User Input\nstd::string raw_input(std::string message)\n{\n\tstd::string UserIn;\n\tstd::cout << message;\n\tgetline (std::cin,UserIn);\n\treturn UserIn;\n}\n\n";
	}
	if (*write == true)
	{
		Declaration = Declaration+"static void Write(std::string filename, std::string content);\n";
		WriteFile = "//Write file\nstatic void Write(std::string filename, std::string content)\n{\n\tstd::ofstream myfile;\n\tmyfile.open(filename.c_str());\n\tmyfile << content;\n\tmyfile.close();\n}\n\n";
	}
	if (*read == true)
	{
		Declaration = Declaration+"static void Read(std::string File);\n";
		ReadFile = "//Read file\nstatic void Read(std::string File)\n{\n\tstd::string line;\n\tstd::ifstream myFile(File.c_str());\n\tif (myFile.is_open())\n\t{\n\t\twhile (getline (myFile,line))\n\t\t{\n\t\t\tstd::cout << line << std::endl;\n\t\t}\n\t\tmyFile.close();\n\t}\n\telse\n\t{\n\t\tstd::cout << \"file not found\" << std::endl;\n\t}\n}\n\n";
	}
	if (*rand == true)
	{
		Declaration = Declaration+"int random(int min, int max);\n";
		Random = "//Get Random int\nint random(int min, int max)\n{\n\tint Val;\n\tVal = rand()%max+min;\n\treturn Val;\n}\n\n";
	}
	if (*isin == true)
	{
		Declaration = Declaration+"bool IsIn(std::string Str, std::string Sub);\n";
		IsIn = "//Check if sub-string is in string\nbool IsIn(std::string Str, std::string Sub)\n{\n\tbool found = false;\n\tif (Str.find(Sub) != std::string::npos)\n\t{\n\t\tfound = true;\n\t}\n\treturn found;\n}\n\n";
	}
	if (*shell == true)
	{
		Declaration = Declaration+"std::string shell(std::string command);\n";
		TheShell = "std::string shell(std::string command)\n{\n\tchar buffer[128];\n\tstd::string result = \"\";\n\n\t// Open pipe to file\n\tFILE* pipe = popen(command.c_str(), \"r\");\n\tif (!pipe)\n\t{\n\t\treturn \"popen failed!\";\n\t}\n\n\t// read till end of process:\n\twhile (!feof(pipe))\n\t{\n\t\t// use buffer to read and add to result\n\t\tif (fgets(buffer, 128, pipe) != NULL)\n\t\t{\n\t\t\tresult += buffer;\n\t\t}\n\t}\n\n\tpclose(pipe);\n\treturn result;\n}\n\n";
	}
	if (*sleep == true)
	{
		Declaration = Declaration+"void sleep(int millies);\n";
		TheSleep = "void sleep(int millies)\n{\n\tstd::this_thread::sleep_for(std::chrono::milliseconds(millies));\n}\n\n";
	}
	if (*prop == true)
	{
		Declaration = Declaration+"std::string GetSysProp( std::string const & PleaseGet );\n";
		SysProp = "std::string GetSysProp( std::string const & PleaseGet )\n{\n\tchar * val = std::getenv( PleaseGet.c_str() );\n\tstd::string retval = \"\";\n\tif (val != NULL)\n\t{\n\t\tretval = val;\n\t}\n\treturn retval;\n}\n\n";
	}
	if (*Split == true)
	{
		Declaration = Declaration+"std::vector<std::string> split(std::string message, char by);\n";
		StrSplit = "std::vector<std::string> split(std::string message, char by)\n{\n\tstd::vector <std::string> vArray;\n\tstd::stringstream ss(message);\n\tstd::string item;\n\twhile (std::getline(ss,item,by))\n\t{\n\t\tvArray.push_back(item);\n\t}\n\treturn vArray;\n}\n\n";
	}
	if (*Join == true)
	{
		Declaration = Declaration+"std::string join(std::vector<std::string> Str, std::string ToJoin);\n";
		StrJoin = "std::string join(std::vector<std::string> Str, std::string ToJoin)\n{\n\tstd::string NewString;\n\tint end;\n\tend = Str.size();\n\tNewString = Str[0];\n\n\tfor (int lp = 1; lp < end; lp++)\n\t{\n\t\tNewString = NewString + ToJoin + Str[lp];\n\t}\n\treturn NewString;\n}\n\n";
	}
	if ((*Split == true) && (*Join == true))
	{
		Declaration = Declaration+"std::string SplitAndJoin(std::string message, char sBy, std::string jBy);\n";
		StrSplit = "std::string SplitAndJoin(std::string message, char sBy, std::string jBy)\n{\n\tstd::vector<std::string> SplitMessage = split(message,sBy);\n\tmessage = join(SplitMessage,jBy);\n\treturn message;\n}\n\n";
	}

	//Methods for C++
	Methods = "//Method Declaration\n"+Declaration+"\n\n"+RawInput+Random+IsIn+WriteFile+ReadFile+TheShell+TheSleep+SysProp+StrSplit+StrJoin;

	return Methods;
}

//build main function
static std::string getMain(bool* Args, bool* getRandom, bool* pipe, bool* threads)
{
	std::string Main = "";
	std::string StartRandom = "";
	std::string UsePipe = "";
	std::string UseThreads = "";

	if (*getRandom == true)
	{
		StartRandom = "\t//Enable Random\n\tsrand(time(NULL));\n\n";
	}

	if (*pipe == true)
	{
		UsePipe = "\t//C++ Unix Piping\n\tif(!isatty(fileno(stdin)))\n\t{\n\t\tprint(\"[Pipe]\");\n\t\tprint(\"{\");\n\t\tfor (std::string line; std::getline(std::cin, line);)\n\t\t{\n\t\t\tprint(line);\n\t\t}\n\t\tprint(\"}\");\n\t}\n\telse\n\t{\n\t\tprint(\"nothing was piped in\");\n\t}\n\n";
	}

	if (*threads == true)
	{
		UseThreads = "\t//spawn new thread\n\t//std::thread ThreadName(function,params);\n\t//synchronize threads\n\t//ThreadName.join();\n\n";
	}

	if (*Args == true)
	{
		Main = "//C++ Main...with cli arguments\nint main(int argc, char** argv)\n{\n"+StartRandom+"\tstd::string out = \"\";\n\t//Args were given\n\tif (argc > 1)\n\t{\n\t\t//Loop through Args\n\t\tfor (int i = 1; i < argc; i++)\n\t\t{\n\t\t\tout = std::string(argv[i]);\n\t\t\tif (out == \"find\")\n\t\t\t{\n\t\t\t\tprint(\"Found\");\n\t\t\t\tbreak;\n\t\t\t}\n\t\t}\n\t}\n\telse\n\t{\n\t\tprint(\"Give me some cli arguments\");\n\t}\n\n"+UsePipe+UseThreads+"\treturn 0;\n}\n";
	}
	else
	{
		Main = "//C++ Main\nint main()\n{\n"+StartRandom+UsePipe+UseThreads+"\n\treturn 0;\n}\n";
	}
	return Main;
}

//create new c++ program
static void CreateNew(std::string filename, std::string content, std::string ext)
{
	filename = filename+ext;
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
	bool getExt = false;
	bool getArgs = false;
	bool getRand = false;
	bool getWrite = false;
	bool getRead = false;
	bool getIsIn = false;
	bool getRawIn = false;
	bool getPipe = false;
	bool getProp = false;
	bool getShell = false;
	bool getSplit = false;
	bool getJoin = false;
	bool getThreads = false;
	bool getSleep = false;
	bool IsMain = false;
	std::string UserIn = "";
	std::string TheExt = ".cpp";
	std::string CName = "";
	std::string Imports = "";
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
			//Get source code extension
			else if (UserIn == "--ext")
			{
				getExt = true;
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
			//Get shell method
			else if (UserIn == "--shell")
			{
				getShell = true;
			}
			//Enable Piping
			else if (UserIn == "--pipe")
			{
				getPipe = true;
			}
			//Enable Threads
			else if (UserIn == "--thread")
			{
				getThreads = true;
			}
			//Enable sleep
			else if (UserIn == "--sleep")
			{
				getSleep = true;
			}
			//Enable split
			else if (UserIn == "--split")
			{
				getSplit = true;
			}
			//Enable join
			else if (UserIn == "--join")
			{
				getJoin = true;
			}
			//Enable system property
			else if (UserIn == "--prop")
			{
				getProp = true;
			}

			//capture new C++ program name
			else if (getName == true)
			{
				NameIsNotOk = IsIn(UserIn,"--");
				if (NameIsNotOk == false)
				{
					CName = UserIn;
				}
				NameIsNotOk = true;
				getName = false;
			}
			//capture source code extension
			else if (getExt == true)
			{
				NameIsNotOk = IsIn(UserIn,"--");
				if (NameIsNotOk == false)
				{
					TheExt = UserIn;
				}
				NameIsNotOk = true;
				getExt = false;
			}
		}
		//Ensure program name is given
		if (CName != "")
		{
			Imports = getImports(&getWrite, &getRead, &getRand, &getPipe, &getShell, &getThreads, &getSleep, &getProp, &getSplit, &getJoin);
			Marcos = getMarcos();
			Methods =  getMethods(&getRawIn, &getRand, &getWrite, &getRead, &getIsIn, &getShell, &getSleep, &getProp, &getSplit, &getJoin);
			if (IsMain == true)
			{
				Main = getMain(&getArgs, &getRand, &getPipe, &getThreads);
			}
			else
			{
				Main = "";
			}
			Content = Imports+Marcos+Methods+Main;
			CreateNew(CName,Content,TheExt);
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
