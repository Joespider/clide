#include <iostream>
#include <fstream>
#include <string>

//print marco for cout
#define print(x); std::cout << x << std::endl

static void help();
static std::string getHelp(std::string TheName);
static std::string getMarcos();
static std::string getImports(bool* write, bool* read, bool* random, bool* pipe, bool* shell, bool* threads, bool* sleep, bool* prop);
static std::string getMethodDec(bool* rawinput, bool* rand, bool* write, bool* read, bool* isin, bool* shell, bool* sleep, bool* prop, bool* Split, bool* Join);
static std::string getMethods(bool* rawinput, bool* rand, bool* write, bool* read, bool* isin, bool* shell, bool* sleep, bool* prop);
static std::string getMain(bool* Args, bool* getRandom, bool* pipe, bool* threads);
static void CreateNew(std::string filename, std::string content, std::string ext);
bool IsIn(std::string Str, std::string Sub);

static void help()
{
	std::string ProgName = "newC++";
	std::string Version = "0.1.30";
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
	print("\t--reverse : enable \"rev\" function");
	print("\t--split : enable \"split\" function");
	print("\t--join : enable \"join\" function");
	print("\t--random : enable \"random\" int method");
	print("\t--write-file : enable \"write\" file method");
	print("\t--read-file : enable \"read\" file method");
	print("\t--is-in : enable string contains methods");
	print("\t--user-input : enable \"raw_input\" method");
	print("\t--thread : enable threading");
	print("\t--sleep : enable sleep method");
}

static std::string getHelp(std::string TheName)
{
	std::string TheUser = std::getenv("USER");
	std::string HelpDeclare = "static void help();\n";
	std::string HelpMethod = "static void help()\n{\n\tstd::string TheName = \""+TheName+"\";\n\tstd::string Version = \"0.0.0\";\n\tprint(\"Author: "+TheUser+"\");\n\tprint(\"Program: \\\"\" << TheName << \"\\\"\");\n\tprint(\"Version: \" << Version);\n\tprint(\"Purpose: \");\n\tprint(\"Usage: \" << TheName << \" <args>\");\n}\n\n";
	return HelpDeclare+"\n"+HelpMethod;
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
static std::string getImports(bool* write, bool* read, bool* random, bool* pipe, bool* shell, bool* threads, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev)
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
	std::string ForRev = "";
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
	if (*Rev == true)
	{
		ForRev = "#include <algorithm>\n";
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
	Imports = standard+readWrite+ForRandom+ForPiping+ForShell+ForThreading+ForSleep+ForSysProp+ForSplit+ForJoin+ForRev+"\n";

	return Imports;
}

//create base methods
static std::string getMethodDec(bool* rawinput, bool* rand, bool* write, bool* read, bool* isin, bool* shell, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev)
{
	std::string Declaration = "";

	if (*rawinput == true)
	{
		Declaration = "std::string raw_input(std::string message);\n";
	}
	if (*write == true)
	{
		Declaration = Declaration+"static void Write(std::string filename, std::string content);\n";
	}
	if (*read == true)
	{
		Declaration = Declaration+"static void Read(std::string File);\n";
	}
	if (*rand == true)
	{
		Declaration = Declaration+"int random(int min, int max);\n";
	}
	if (*isin == true)
	{
		Declaration = Declaration+"bool IsIn(std::string Str, std::string Sub);\n";
		Declaration = Declaration+"bool StartsWith(std::string Str, std::string Start);\n";
		Declaration = Declaration+"bool StartsWith(std::string Str, std::string Start);\n";
		Declaration = Declaration+"bool EndsWith(std::string Str, std::string End);\n";
	}
	if (*shell == true)
	{
		Declaration = Declaration+"std::string shell(std::string command);\n";
		Declaration = Declaration+"void shellExe(std::string command);\n";
	}
	if (*sleep == true)
	{
		Declaration = Declaration+"void sleep(int millies);\n";
	}
	if (*prop == true)
	{
		Declaration = Declaration+"std::string GetSysProp( std::string const & PleaseGet );\n";
	}
	if (*Rev == true)
	{
		Declaration = Declaration+"std::string rev(std::string Str);\n";
	}
	if (*Split == true)
	{
		Declaration = Declaration+"std::vector<std::string> split(std::string message, char by);\n";
	}
	if (*Join == true)
	{
		Declaration = Declaration+"std::string join(std::vector<std::string> Str, std::string ToJoin);\n";
	}
	if ((*Split == true) && (*Join == true))
	{
		Declaration = Declaration+"std::string SplitAndJoin(std::string message, char sBy, std::string jBy);\n";
	}

	return Declaration;
}

//create base methods
static std::string getMethods(bool* rawinput, bool* rand, bool* write, bool* read, bool* isin, bool* shell, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev)
{
	std::string Methods = "";
	std::string Random = "";
	std::string RawInput = "";
	std::string WriteFile = "";
	std::string ReadFile = "";
	std::string IsIn = "";
	std::string TheShell = "";
	std::string TheSleep = "";
	std::string SysProp = "";
	std::string StrRev = "";
	std::string StrSplit = "";
	std::string StrJoin = "";
	std::string StrSplitAndJoin = "";

	if (*rawinput == true)
	{
		RawInput = "//User Input\nstd::string raw_input(std::string message)\n{\n\tstd::string UserIn;\n\tstd::cout << message;\n\tgetline (std::cin,UserIn);\n\treturn UserIn;\n}\n\n";
	}
	if (*write == true)
	{
		WriteFile = "//Write file\nstatic void Write(std::string filename, std::string content)\n{\n\tstd::ofstream myfile;\n\tmyfile.open(filename.c_str());\n\tmyfile << content;\n\tmyfile.close();\n}\n\n";
	}
	if (*read == true)
	{
		ReadFile = "//Read file\nstatic void Read(std::string File)\n{\n\tstd::string line;\n\tstd::ifstream myFile(File.c_str());\n\tif (myFile.is_open())\n\t{\n\t\twhile (getline (myFile,line))\n\t\t{\n\t\t\tstd::cout << line << std::endl;\n\t\t}\n\t\tmyFile.close();\n\t}\n\telse\n\t{\n\t\tstd::cout << \"file not found\" << std::endl;\n\t}\n}\n\n";
	}
	if (*rand == true)
	{
		Random = "//Get Random int\nint random(int min, int max)\n{\n\tint Val;\n\tVal = rand()%max+min;\n\treturn Val;\n}\n\n";
	}
	if (*isin == true)
	{
		IsIn = "//Check if sub-string is in string\nbool IsIn(std::string Str, std::string Sub)\n{\n\tbool found = false;\n\tif (Str.find(Sub) != std::string::npos)\n\t{\n\t\tfound = true;\n\t}\n\treturn found;\n}\n\n";
		IsIn = IsIn+"//Check if string begins with substring\nbool StartsWith(std::string Str, std::string Start)\n{\n\tbool ItDoes = false;\n\tif (Str.rfind(Start, 0) == 0)\n\t{\n\t\tItDoes = true;\n\t}\n\treturn ItDoes;\n}\n\n";
		IsIn = IsIn+"//Check if string ends with substring\nbool EndsWith(std::string Str, std::string End)\n{\n\tbool ItDoes = false;\n\tif (Str.length() < End.length())\n\t{\n\t\tItDoes = false;\n\t}\n\telse\n\t{\n\t\tItDoes = std::equal(End.rbegin(), End.rend(), Str.rbegin());\n\t}\n\treturn ItDoes;\n}\n\n";
	}
	if (*shell == true)
	{
		TheShell = "std::string shell(std::string command)\n{\n\tchar buffer[128];\n\tstd::string result = \"\";\n\n\t// Open pipe to file\n\tFILE* pipe = popen(command.c_str(), \"r\");\n\tif (!pipe)\n\t{\n\t\treturn \"popen failed!\";\n\t}\n\n\t// read till end of process:\n\twhile (!feof(pipe))\n\t{\n\t\t// use buffer to read and add to result\n\t\tif (fgets(buffer, 128, pipe) != NULL)\n\t\t{\n\t\t\tresult += buffer;\n\t\t}\n\t}\n\n\tpclose(pipe);\n\treturn result;\n}\n\n";
		TheShell = TheShell+"void shellExe(std::string command)\n{\n\tsystem(command.c_str());\n}\n\n";
	}
	if (*sleep == true)
	{
		TheSleep = "void sleep(int millies)\n{\n\tstd::this_thread::sleep_for(std::chrono::milliseconds(millies));\n}\n\n";
	}
	if (*prop == true)
	{
		SysProp = "std::string GetSysProp( std::string const & PleaseGet )\n{\n\tchar * val = std::getenv( PleaseGet.c_str() );\n\tstd::string retval = \"\";\n\tif (val != NULL)\n\t{\n\t\tretval = val;\n\t}\n\treturn retval;\n}\n\n";
	}
	if (*Rev == true)
	{
		StrRev = "//Put String In Reverse\nstd::string rev(std::string Str)\n{\n\tstd::string RevStr = Str;\n\treverse(RevStr.begin(), RevStr.end());\n\treturn RevStr;\n}\n\n";
	}
	if (*Split == true)
	{
		StrSplit = "std::vector<std::string> split(std::string message, char by)\n{\n\tstd::vector <std::string> vArray;\n\tstd::stringstream ss(message);\n\tstd::string item;\n\twhile (std::getline(ss,item,by))\n\t{\n\t\tvArray.push_back(item);\n\t}\n\treturn vArray;\n}\n\n";
	}
	if (*Join == true)
	{
		StrJoin = "std::string join(std::vector<std::string> Str, std::string ToJoin)\n{\n\tstd::string NewString;\n\tint end;\n\tend = Str.size();\n\tNewString = Str[0];\n\n\tfor (int lp = 1; lp < end; lp++)\n\t{\n\t\tNewString = NewString + ToJoin + Str[lp];\n\t}\n\treturn NewString;\n}\n\n";
	}
	if ((*Split == true) && (*Join == true))
	{
		StrSplitAndJoin = "std::string SplitAndJoin(std::string message, char sBy, std::string jBy)\n{\n\tstd::vector<std::string> SplitMessage = split(message,sBy);\n\tmessage = join(SplitMessage,jBy);\n\treturn message;\n}\n\n";
	}

	//Methods for C++
	Methods = "\n"+RawInput+Random+IsIn+WriteFile+ReadFile+TheShell+TheSleep+SysProp+StrSplit+StrJoin+StrSplitAndJoin+StrRev;

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
		Main = "//C++ Main...with cli arguments\nint main(int argc, char** argv)\n{\n"+StartRandom+"\tstd::string out = \"\";\n\t//Args were given\n\tif (argc > 1)\n\t{\n\t\t//Loop through Args\n\t\tfor (int i = 1; i < argc; i++)\n\t\t{\n\t\t\tout = std::string(argv[i]);\n\t\t\tif (out == \"find\")\n\t\t\t{\n\t\t\t\tprint(\"Found\");\n\t\t\t\tbreak;\n\t\t\t}\n\t\t}\n\t}\n\telse\n\t{\n\t\thelp();\n\t}\n\n"+UsePipe+UseThreads+"\treturn 0;\n}\n";
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
	bool getRev = false;
	bool getJoin = false;
	bool getThreads = false;
	bool getSleep = false;
	bool IsMain = false;
	std::string theDeclaration = "";
	std::string theHelpMethod = "";
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
			//Is a main
			else if (UserIn == "--reverse")
			{
				getName = false;
				getRev = true;
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
			Imports = getImports(&getWrite, &getRead, &getRand, &getPipe, &getShell, &getThreads, &getSleep, &getProp, &getSplit, &getJoin, &getRev);
			Marcos = getMarcos();
			theDeclaration = getMethodDec(&getRawIn, &getRand, &getWrite, &getRead, &getIsIn, &getShell, &getSleep, &getProp, &getSplit, &getJoin, &getRev);
			Methods =  getMethods(&getRawIn, &getRand, &getWrite, &getRead, &getIsIn, &getShell, &getSleep, &getProp, &getSplit, &getJoin, &getRev);
			if (IsMain == true)
			{
				if (getArgs == true)
				{
					theHelpMethod = getHelp(CName);
				}
				Main = getMain(&getArgs, &getRand, &getPipe, &getThreads);
			}
			else
			{
				Main = "";
			}
			Content = Imports+Marcos+theDeclaration+theHelpMethod+Methods+Main;
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
