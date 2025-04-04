#include <iostream>
#include <fstream>
#include <string>

//print Macro for cout
#define print(x); std::cout << x << std::endl
//error Macro for cerr
#define error(x); std::cerr << x << std::endl
//Convert std::string to String
#define String std::string

String ProgName = "";

static void help();
static String getHelp(String TheUser);
static String getMacros(bool* Conv, bool* getLen);
static String getImports(bool* fcheck, bool* write, bool* read, bool* random, bool* pipe, bool* shell, bool* threads, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev, bool* Vect, bool* Math, bool* getFS);
static String getMethodDec(bool* rawinput, bool* rand, bool* fcheck, bool* write, bool* read, bool* isin, bool* shell, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev, bool* Conv, bool* subStr, bool* getLen, bool* getUpper, bool* getLower, bool* getFS);
static String getMethods(bool* rawinput, bool* rand, bool* fcheck, bool* write, bool* read, bool* isin, bool* shell, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev, bool* Conv, bool* subStr, bool* getLen, bool* getUpper, bool* getLower, bool* getFS);
static String getMain(bool* getArgs, bool* getRandom, bool* getPipe, bool* getThreads, bool* getVectors, bool* getMath);
static void CreateNew(String filename, String content, String ext);
bool fexists(String aFile);
bool IsIn(String Str, String Sub);

static void help()
{
	String Version = "0.1.72";
	print("Author: Joespider");
	print("Program: \"" + ProgName + "\"");
	print("Version: " + Version);
	print("Purpose: make new C++ programs");
	print("Usage: " + ProgName + " <args>");
	print("\t--user <username>: get username for help page");
	print("\t-n <name> : program name");
	print("\t--name <name> : program name");
	print("\t--ext <extension> : choose an extension (.cpp is default)");
	print("\t--no-save : only show out of code; no file source code is created");
	print("\t--cli : enable command line (Main file ONLY)");
	print("\t--main : main file");
	print("\t--prop : enable custom system property");
	print("\t--pipe : enable piping (Main file ONLY)");
	print("\t--shell : unix shell");
	print("\t--files : enable filesystem C++ specific code");
	print("\t--reverse : enable \"rev\" function");
	print("\t--split : enable \"split\" function");
	print("\t--join : enable \"join\" function");
	print("\t--random : enable \"random\" int method");
/*
	print("\t--check-file : enable \"fexists\" file method");
	print("\t--write-file : enable \"write\" file method");
	print("\t--read-file : enable \"read\" file method");
	print("\t--is-in : enable string contains methods");
*/
	print("\t--user-input : enable \"raw_input\" method");
	print("\t--vectors : enable vector arrays");
	print("\t--thread : enable threading (Main file ONLY)");
	print("\t--sleep : enable sleep method");
	print("\t--get-length : enable \"length\" examples");
	print("\t--casting : enable data type conversion methods");
	print("\t--sub-string : enable sub-string methods");
	print("\t--upper : enable upper case methods");
	print("\t--lower : enable lower case methods");
	print("\t--math : enable math functions (Main file ONLY)");
	print("\t--date-time : enable date and time");
}

static String getHelp(String TheUser)
{
	if (TheUser == "")
	{
		TheUser = std::getenv("USER");
	}
	String HelpDeclare = "static void help();\n";
	String HelpMethod = "String TheName = \"\";\n";
	HelpMethod = HelpMethod +"static void help()\n{\n\tString Version = \"0.0.0\";\n\tprint(\"Author: "+TheUser+"\");\n\tprint(\"Program: \\\"\" + TheName + \"\\\"\");\n\tprint(\"Version: \" + Version);\n\tprint(\"Purpose: \");\n\tprint(\"Usage: \" + TheName + \" <args>\");\n}\n\n";
	return HelpDeclare+"\n"+HelpMethod;
}

static String getMacros(bool* Conv, bool* getLen)
{
	String Macros = "";
	String MacroPrint = "//print Macro for cout\n#define print(x); std::cout << x << std::endl\n\n";
	String MacroError = "//error Macro for cerr\n#define error(x); std::cerr << x << std::endl\n\n";
	String MacroToStr = "";
	String MacroPressEnter = "#define PressEnter std::cout << \"Press \\\"Enter\\\" to Continue \"; std::cin.get()\n\n";
	String MacroLen = "";
	String MacroString = "//Convert std::string to String\n#define String std::string\n\n";

	if (*Conv == true)
	{
		MacroToStr = "//Str for to_strin()\n#define Str(x) std::to_string(x)\n\n";
	}
	if (*getLen == true)
	{
		MacroLen = "//lenA for array sizze\n#define lenA(x) sizeof(x)/sizeof(x[0])\n\n";
	}
/*
	String MacroLen = "//len Macro for sizeof\n#define len(item) (sizeof(item))\n";
	Macros = MacroPrint+MacroLen+"\n";
*/
	Macros = MacroPressEnter+MacroPrint+MacroError+MacroToStr+MacroString+MacroLen+"\n";
	return Macros;
}

//create import listing
static String getImports(bool* fcheck, bool* write, bool* read, bool* random, bool* pipe, bool* shell, bool* threads, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev, bool* Vect, bool* getLen, bool* Math, bool* getFS, bool* dateTime)
{
	String Imports = "";
	String standard = "#include <iostream>\n#include <string>\n";
	String readWrite = "";
	String ForRandom = "";
	String ForPiping = "";
	String ForSysProp = "";
	String ForShell = "";
	String ForThreading = "";
	String ForSleep = "";
	String ForRev = "";
	String ForSplit = "";
	String ForJoin = "";
	String ForMath = "";
	String ForDateAndTime = "";
	String ForFS = "";

	if ((*fcheck == true) || (*read == true) || (*write == true))
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
		ForShell = "#include <unistd.h>\n#include <stdexcept>\n#include <stdio.h>\n";
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
	if ((*Split == true) || (*Join == true) || (*Vect == true) || (*getLen == true))
	{
		ForJoin = "#include <vector>\n";
	}
	if (*Split == true)
	{
		ForSplit = "#include <sstream>\n";
	}
	if (*Math == true)
	{
		ForMath = "#include <cmath>\n";
	}
	if (*getFS == true)
	{
		ForFS = "#include <filesystem>\n";
	}
	if (*dateTime == true)
	{
		ForDateAndTime = "#include <chrono>\n#include <ctime>\n";
	}

	//concat imports
	Imports = standard+readWrite+ForRandom+ForPiping+ForShell+ForThreading+ForSleep+ForSysProp+ForSplit+ForJoin+ForRev+ForMath+ForFS+ForDateAndTime+"\n";

	return Imports;
}

//create base methods
static String getMethodDec(bool* rawinput, bool* rand, bool* fcheck, bool* write, bool* read, bool* isin, bool* shell, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev, bool* Conv, bool* subStr, bool* getLen, bool* getUpper, bool* getLower, bool* getFS, bool* dateTime)
{
	String Declaration = "";

	if (*rawinput == true)
	{
		Declaration = "String raw_input(String message);\n";
	}
	if (*fcheck == true)
	{
		Declaration = Declaration+"bool fexists(String aFile);\n";
	}
	if (*write == true)
	{
		Declaration = Declaration+"static void Write(String filename, String content);\n";
	}
	if (*read == true)
	{
		Declaration = Declaration+"static void Read(String File);\n";
	}
	if (*rand == true)
	{
		Declaration = Declaration+"int random(int min, int max);\n";
		Declaration = Declaration+"int random(int max);\n";
	}
	if (*isin == true)
	{
		Declaration = Declaration+"bool IsIn(String Str, String Sub);\n";
		Declaration = Declaration+"bool StartsWith(String Str, String Start);\n";
		Declaration = Declaration+"bool EndsWith(String Str, String End);\n";
	}
	if (*shell == true)
	{
		Declaration = Declaration+"String shell(String command);\n";
		Declaration = Declaration+"void shellExe(String command);\n";
		Declaration = Declaration+"String getOS();\n";
		Declaration = Declaration+"String getUser();\n";
	}
	if (*sleep == true)
	{
		Declaration = Declaration+"void sleep(int millies);\n";
	}
	if (*prop == true)
	{
		Declaration = Declaration+"String GetSysProp(String PleaseGet);\n";
	}
	if (*Rev == true)
	{
		Declaration = Declaration+"String rev(String Str);\n";
	}
	if (*getLen == true)
	{
		Declaration = Declaration+"int len(String message);\n";
		Declaration = Declaration+"int len(std::vector<String> Vect);\n";
	}
	if (*Conv == true)
	{
		Declaration = Declaration+"double Dbl(int number);\n";
		Declaration = Declaration+"double Dbl(String number);\n";
		Declaration = Declaration+"int Int(double number);\n";
		Declaration = Declaration+"int Int(const char* number);\n";
		Declaration = Declaration+"int Int(String number);\n";
		Declaration = Declaration+"long Long(String number);\n";
	}
	if (*subStr == true)
	{
		Declaration = Declaration+"String removeFirstChars(String value, int length);\n";
		Declaration = Declaration+"String removeLastChars(String value, int length);\n";
		Declaration = Declaration+"String SubString(String TheString, int Pos);\n";
		Declaration = Declaration+"String SubString(String TheString, int Start, int End);\n";
		Declaration = Declaration+"int Index(String TheString, String SubStr);\n";
	}
	if (*Split == true)
	{
		Declaration = Declaration+"String BeforeSplit(String Str, char splitAt);\n";
		Declaration = Declaration+"String AfterSplit(String Str, char splitAt);\n";
		Declaration = Declaration+"std::vector<String> split(String message, char by);\n";
		Declaration = Declaration+"std::vector<String> split(String message, String by, int at);\n";
		Declaration = Declaration+"std::vector<String> rsplit(String message, String by, int at);\n";
	}
	if (*Join == true)
	{
		Declaration = Declaration+"String join(std::vector<String> Str, String ToJoin);\n";
	}
	if ((*Split == true) && (*Join == true))
	{
		Declaration = Declaration+"String replaceAll(String message, String sBy, String jBy);\n";
		Declaration = Declaration+"String replace(String message, String sBy, String jBy, int at);\n";
		Declaration = Declaration+"String replaceFirst(String message, String sBy, String jBy);\n";
		Declaration = Declaration+"String replaceLast(String message, String sBy, String jBy);\n";
	}
	if (*getUpper == true)
	{
		Declaration = Declaration+"String toUpperCase(String Str);\n";
		Declaration = Declaration+"String toUpperCase(String Str, int plc);\n";
	}
	if (*getLower == true)
	{
		Declaration = Declaration+"String toLowerCase(String Str);\n";
		Declaration = Declaration+"String toLowerCase(String Str, int plc);\n";
	}
	if (*getFS == true)
	{
		Declaration = Declaration+"void LS(String Dir);\n";
		Declaration = Declaration+"void CD(String Dir);\n";
	}
	if (*dateTime == true)
	{
		Declaration = Declaration+"String getTime();\n";
		Declaration = Declaration+"String TimeAndDate();\n";
	}

	return Declaration;
}

//create base methods
static String getMethods(bool* rawinput, bool* rand, bool* fcheck, bool* write, bool* read, bool* isin, bool* shell, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev, bool* Conv, bool* subStr, bool* getLen, bool* getUpper, bool* getLower, bool* getFS, bool* dateTime)
{
	String Methods = "";
	String Random = "";
	String RawInput = "";
	String CheckFile = "";
	String WriteFile = "";
	String ReadFile = "";
	String IsIn = "";
	String TheShell = "";
	String TheSleep = "";
	String ConvData = "";
	String SysProp = "";
	String StrLen = "";
	String StrRev = "";
	String SubStr = "";
	String StrSplit = "";
	String StrJoin = "";
	String StrUpper = "";
	String StrLower = "";
	String StrReplaceAll = "";
	String TheFileSystem = "";
	String TheTimeAndDate = "";

	if (*rawinput == true)
	{
		RawInput = "//User Input\nString raw_input(String message)\n{\n\tString UserIn;\n\tstd::cout << message;\n\tgetline (std::cin,UserIn);\n\treturn UserIn;\n}\n\n";
	}
	if (*fcheck == true)
	{
		CheckFile = "//check if file exists\nbool fexists(String aFile)\n{\n\tbool IsFound = false;\n\tstd::ifstream ifile;\n\tifile.open(aFile);\n\tif (ifile)\n\t{\n\t\tifile.close();\n\t\tIsFound = true;\n\t}\n\treturn IsFound;\n}\n\n";
	}
	if (*write == true)
	{
		WriteFile = "//Write file\nstatic void Write(String filename, String content)\n{\n\tstd::ofstream myfile;\n\tmyfile.open(filename.c_str());\n\tmyfile << content;\n\tmyfile.close();\n}\n\n";
	}
	if (*read == true)
	{
		ReadFile = "//Read file\nstatic void Read(String File)\n{\n\tString line;\n\tstd::ifstream myFile(File.c_str());\n\tif (myFile.is_open())\n\t{\n\t\twhile (getline (myFile,line))\n\t\t{\n\t\t\tstd::cout << line << std::endl;\n\t\t}\n\t\tmyFile.close();\n\t}\n\telse\n\t{\n\t\tstd::cout << \"file not found\" << std::endl;\n\t}\n}\n\n";
	}
	if (*rand == true)
	{
		Random = "//Get Random int\nint random(int min, int max)\n{\n\tint Val;\n\tVal = rand()%max+min;\n\treturn Val;\n}\n\n";
		Random = Random + "//Get Random int\nint random(int max)\n{\n\tint Val;\n\tVal = rand()%max+0;\n\treturn Val;\n}\n\n";
	}
	if (*isin == true)
	{
		IsIn = "//Check if sub-string is in string\nbool IsIn(String Str, String Sub)\n{\n\tbool found = false;\n\tif (Str.find(Sub) != String::npos)\n\t{\n\t\tfound = true;\n\t}\n\treturn found;\n}\n\n";
		IsIn = IsIn+"//Check if string begins with substring\nbool StartsWith(String Str, String Start)\n{\n\tbool ItDoes = false;\n\tif (Str.rfind(Start, 0) == 0)\n\t{\n\t\tItDoes = true;\n\t}\n\treturn ItDoes;\n}\n\n";
		IsIn = IsIn+"//Check if string ends with substring\nbool EndsWith(String Str, String End)\n{\n\tbool ItDoes = false;\n\tif (Str.length() < End.length())\n\t{\n\t\tItDoes = false;\n\t}\n\telse\n\t{\n\t\tItDoes = std::equal(End.rbegin(), End.rend(), Str.rbegin());\n\t}\n\treturn ItDoes;\n}\n\n";
	}
	if (*shell == true)
	{
		TheShell = "String shell(String command)\n{\n\tchar buffer[128];\n\tString result = \"\";\n\n\t// Open pipe to file\n\tFILE* pipe = popen(command.c_str(), \"r\");\n\tif (!pipe)\n\t{\n\t\treturn \"popen failed!\";\n\t}\n\n\t// read till end of process:\n\twhile (!feof(pipe))\n\t{\n\t\t// use buffer to read and add to result\n\t\tif (fgets(buffer, 128, pipe) != NULL)\n\t\t{\n\t\t\tresult += buffer;\n\t\t}\n\t}\n\n\tpclose(pipe);\n\treturn result;\n}\n\n";
		TheShell = TheShell+"void shellExe(String command)\n{\n\tsystem(command.c_str());\n}\n\n";
		TheShell = TheShell+"String getOS()\n{\n\t#ifdef _WIN32\n\treturn \"Windows 32-bit\";\n\t#elif _WIN64\n\treturn \"Windows 64-bit\";\n\t#elif __APPLE__ || __MACH__\n\treturn \"Mac OSX\";\n\t#elif __linux__\n\treturn \"Linux\";\n\t#elif __FreeBSD__\n\treturn \"FreeBSD\";\n\t#elif __unix || __unix__\n\treturn \"Unix\";\n\t#else\n\treturn \"Other\";\n\t#endif\n}\n\n";
		TheShell = TheShell+"String getUser()\n{\n\tString theOS = getOS();\n\tif ((theOS == \"Windows 32-bit\") || (theOS == \"Windows 64-bit\"))\n\t{\n\t\treturn getenv(\"USERNAME\");\n\t}\n\telse if (theOS == \"Linux\")\n\t{\n\t\treturn getenv(\"USER\");\n\t}\n\telse\n\t{\n\t\treturn \"\";\n\t}\n}\n\n";
	}
	if (*sleep == true)
	{
		TheSleep = "void sleep(int millies)\n{\n\tstd::this_thread::sleep_for(std::chrono::milliseconds(millies));\n}\n\n";
	}
	if (*prop == true)
	{
		SysProp = "String GetSysProp(String PleaseGet)\n{\n\t//[NOTE] values don't change after startup\n\n\tString retval = std::getenv(PleaseGet.c_str());\n\treturn retval;\n}\n\n";
	}
	if (*Rev == true)
	{
		StrRev = "//Put String In Reverse\nString rev(String Str)\n{\n\tString RevStr = Str;\n\treverse(RevStr.begin(), RevStr.end());\n\treturn RevStr;\n}\n\n";
	}
	if (*getLen == true)
	{
		StrLen = "int len(String message)\n{\n\tint StrLen = message.length();\n\treturn StrLen;\n}\n\n";
		StrLen = StrLen+"int len(std::vector<String> Vect)\n{\n\tint StrLen = Vect.size();\n\treturn StrLen;\n}\n\n";
	}
	if (*Conv == true)
	{
		ConvData = "//Convert Int to Double\ndouble Dbl(int number)\n{\n\tdouble MyDouble = (double)number;\n\treturn MyDouble;\n}\n\n";
		ConvData = ConvData+"//Convert String to Double\ndouble Dbl(String number)\n{\n\tdouble MyDouble = atof(number.c_str());\n\treturn MyDouble;\n}\n\n";
		ConvData = ConvData+"//Convert Double to Int\nint Int(double number)\n{\n\tint MyInt = (int)number;\n\treturn MyInt;\n}\n\n";
		ConvData = ConvData+"//Convert char to Int\nint Int(const char* number)\n{\n\tint MyInt = atoi(number);\n\treturn MyInt;\n}\n\n";
		ConvData = ConvData+"//Convert String to Int\nint Int(String number)\n{\n\tint MyInt = stoi(number);\n\treturn MyInt;\n}\n\n";
		ConvData = ConvData+"//Convert String to Long\nlong Long(String number)\n{\n\tlong MyLong = stol(number);\n\treturn MyLong;\n}\n\n";
	}
	if (*subStr == true)
	{
		SubStr = "String removeFirstChars(String value, int length)\n{\n\tint last = value.length();\n\treturn value.substr(length,last);\n}\n\n";
		SubStr = SubStr+"String removeLastChars(String value, int length)\n{\n\tint last = value.length();\n\treturn value.substr(0,last-length);\n}\n\n";
		SubStr = SubStr+"String SubString(String TheString, int Pos)\n{\n\tString TheSub = TheString.substr(Pos);\n\treturn TheSub;\n}\n\n";
		SubStr = SubStr+"String SubString(String TheString, int Start, int End)\n{\n\tint Len = Start - End;\n\tif (Len <= -1)\n\t{\n\t\tLen = End;\n\t}\n\tString TheSub = TheString.substr(Start,Len);\n\treturn TheSub;\n}\n\n";
		SubStr = SubStr+"int Index(String TheString, String SubStr)\n{\n\tint place = TheString.find(SubStr);\n\treturn place;\n}\n\n";
	}
	if (*Split == true)
	{
		StrSplit = "String BeforeSplit(String Str, char splitAt)\n{\n\tString newString;\n\tint end = Str.length();\n\tif (end != 0)\n\t{\n\t\tstd::size_t pos = Str.find(splitAt);\n\t\tif (pos != String::npos)\n\t\t{\n\t\t\tnewString = Str.substr(0,pos);\n\t\t}\n\t}\n\treturn newString;\n}\n\n";
		StrSplit = StrSplit+"String AfterSplit(String Str, char splitAt)\n{\n\tString newString;\n\tint end = Str.length();\n\tif (end != 0)\n\t{\n\t\tstd::size_t pos = Str.find(splitAt);\n\t\tif (pos != String::npos)\n\t\t{\n\t\t\tnewString = Str.substr(pos + 1);\n\t\t}\n\t}\n\treturn newString;\n}\n\n";
		StrSplit = StrSplit+"std::vector<String> split(String message, char by)\n{\n\tstd::vector<String> vArray;\n\tstd::stringstream ss(message);\n\tString item;\n\twhile (std::getline(ss,item,by))\n\t{\n\t\tvArray.push_back(item);\n\t}\n\treturn vArray;\n}\n\n";
		StrSplit = StrSplit+"std::vector<String> split(String message, String by, int at=0)\n{\n\tstd::vector <String> vArray;\n\tString sub;\n\tint offset = by.length();\n\tstd::size_t pos = message.find(by);\n\tif (at >= 1)\n\t{\n\t\tfor (int off = 1; off != at; off++)\n\t\t{\n\t\t\tpos = message.find(by,pos+off);\n\t\t}\n\t\tsub = message.substr(0,pos);\n\t\tvArray.push_back(sub);\n\t\tsub = message.substr(pos + offset);\n\t\tvArray.push_back(sub);\n\t}\n\telse\n\t{\n\t\twhile (pos != String::npos)\n\t\t{\n\t\t\tsub = message.substr(0,pos);\n\t\t\tvArray.push_back(sub);\n\t\t\tmessage = message.substr(pos+offset);\n\t\t\tpos = message.find(by);\n\t\t}\n\t\tvArray.push_back(message);\n\t}\n\treturn vArray;\n}\n\n";
		StrSplit = StrSplit+"std::vector<String> rsplit(String message, String by, int at=1)\n{\n\tstd::vector <String> vArray;\n\tString sub;\n\tint offset = by.length();\n\tstd::size_t pos = message.rfind(by);\n\tif (at > 1)\n\t{\n\t\tfor (int off = 1; off != at; off++)\n\t\t{\n\t\t\tpos = message.rfind(by,pos-off);\n\t\t}\n\t}\n\tsub = message.substr(0,pos);\n\tvArray.push_back(sub);\n\tsub = message.substr(pos + offset);\n\tvArray.push_back(sub);\n\treturn vArray;\n}\n\n";
	}
	if (*Join == true)
	{
		StrJoin = "String join(std::vector<String> Str, String ToJoin)\n{\n\tString NewString;\n\tint end;\n\tend = Str.size();\n\tNewString = Str[0];\n\n\tfor (int lp = 1; lp < end; lp++)\n\t{\n\t\tNewString = NewString + ToJoin + Str[lp];\n\t}\n\treturn NewString;\n}\n\n";
	}
	if ((*Split == true) && (*Join == true))
	{
		StrReplaceAll = "String replaceAll(String message, String sBy, String jBy)\n{\n\tstd::vector<String> SplitMessage = split(message,sBy);\n\tmessage = join(SplitMessage,jBy);\n\treturn message;\n}\n\n";
		StrReplaceAll = StrReplaceAll+"String replace(String message, String sBy, String jBy, int at)\n{\n\tstd::vector<String> SplitMessage = split(message,sBy,at);\n\tmessage = join(SplitMessage,jBy);\n\treturn message;\n}\n\n";
		StrReplaceAll = StrReplaceAll+"String replaceFirst(String message, String sBy, String jBy)\n{\n\tstd::vector<String> SplitMessage = split(message,sBy,1);\n\tmessage = join(SplitMessage,jBy);\n\treturn message;\n}\n\n";
		StrReplaceAll = StrReplaceAll+"String replaceLast(String message, String sBy, String jBy)\n{\n\tstd::vector<String> SplitMessage = rsplit(message,sBy,1);\n\tmessage = join(SplitMessage,jBy);\n\treturn message;\n}\n\n";
	}
	if (*getUpper == true)
	{
		StrUpper = "String toUpperCase(String Str)\n{\n\tfor (int lp = 0; lp != Str.length(); lp++)\n\t{\n\t\tStr[lp] = toupper(Str[lp]);\n\t}\n\treturn Str;\n}\n\n";
		StrUpper = StrUpper + "String toUpperCase(String Str, int plc)\n{\n\tint end = Str.length();\n\tif ((plc < end) && (end != 0) && (plc >= 0))\n\t{\n\t\tStr[plc] = toupper(Str[plc]);\n\t}\n\treturn Str;\n}\n\n";
	}
	if (*getLower == true)
	{
		StrLower = "String toLowerCase(String Str)\n{\n\tfor (int lp = 0; lp != Str.length(); lp++)\n\t{\n\t\tStr[lp] = tolower(Str[lp]);\n\t}\n\treturn Str;\n}\n\n";
		StrLower = StrLower + "String toLowerCase(String Str, int plc)\n{\n\tint end = Str.length();\n\tif ((plc < end) && (end != 0) && (plc >= 0))\n\t{\n\t\tStr[plc] = tolower(Str[plc]);\n\t}\n\treturn Str;\n}\n\n";
	}
	if (*getFS == true)
	{
		TheFileSystem = "void LS(String Dir)\n{\n\tif (Dir != \"\")\n\t{\n\t\tfor (const auto & entry : std::filesystem::directory_iterator(Dir))\n\t\t{\n\t\t\tprint(entry.path());\n\t\t}\n\t}\n}\n\n";
		TheFileSystem = TheFileSystem + "void CD(String Dir)\n{\n\tif (Dir != \"\")\n\t{\n\t\tchdir(Dir.c_str());\n\t}\n}\n\n";
	}
	if (*dateTime == true)
	{
		TheTimeAndDate = "String getTime()\n{\n\tstd::time_t curr_time = time(NULL);\n\tstd::tm *tm_local = localtime(&curr_time);\n\tString Hr = std::to_string(tm_local->tm_hour);\n\tString Min = std::to_string(tm_local->tm_min);\n\tString Sec = std::to_string(tm_local->tm_sec);\n\tString Time = Hr+\":\"+Min+\":\"+Sec;\n\treturn Time;\n}\n\n";
		TheTimeAndDate = TheTimeAndDate+"String TimeAndDate()\n{\n\tauto now = std::chrono::system_clock::now();\n\tstd::time_t clock_time = std::chrono::system_clock::to_time_t(now);\n\tString val = std::ctime(&clock_time);\n\treturn val;\n}\n\n";
	}

	//Methods for C++
	Methods = "\n"+RawInput+Random+IsIn+CheckFile+WriteFile+ReadFile+TheShell+TheSleep+SysProp+StrSplit+StrJoin+StrReplaceAll+StrRev+ConvData+SubStr+StrLen+StrUpper+StrLower+TheFileSystem+TheTimeAndDate;

	return Methods;
}

//build main function
static String getMain(bool* getArgs, bool* getRandom, bool* getPipe, bool* getThreads, bool* getVectors, bool* getMath)
{
	String Main = "";
	String StartRandom = "";
	String UsePipe = "";
	String UseThreads = "";
	String UseVectors = "";
	String UseMath = "";

	if (*getRandom == true)
	{
		StartRandom = "\t//Enable Random\n\tsrand(time(NULL));\n\n";
	}

	if (*getPipe == true)
	{
		UsePipe = "\t//C++ Unix Piping\n\tif(!isatty(fileno(stdin)))\n\t{\n\t\tprint(\"[Pipe]\");\n\t\tprint(\"{\");\n\t\tfor (String line; std::getline(std::cin, line);)\n\t\t{\n\t\t\tprint(line);\n\t\t}\n\t\tprint(\"}\");\n\t}\n\telse\n\t{\n\t\tprint(\"nothing was piped in\");\n\t}\n\n";
	}

	if (*getThreads == true)
	{
		UseThreads = "/*\n\t//spawn new thread\n\tstd::thread ThreadName(function,params);\n\t//synchronize threads\n\tThreadName.join();\n*/\n\n";
	}

	if (*getVectors == true)
	{
		UseVectors = "/*\n\t//string vectors\n\tstd::vector<String> TheStrVect;\n\t//append string\n\tTheStrVect.push_back(\"one\");\n\n\tstd::vector<std::thread> TheThreadVect;\n\t//append Thread\n\tTheThreadVect.push_back(std::move(ThreadName));\n\n\t//int vectors\n\tstd::vector<int> TheIntVect;\n\t//append int\n\tTheIntVect.push_back(1);\n\t//int vectors\n\n\t//double vectors\n\tstd::vector<double> TheDblVect;\n\t//append double\n\tTheDblVect.push_back(1.0);\n\n\t//Vector length\n\tint TheStrVectLen = TheStrVect.size();\n\tint TheThreadVectLen = TheThreadVect.size();\n\tint TheIntVectLen = TheIntVect.size();\n\tint TheDblVectLen = TheDblVect.size();\n*/\n\n";
	}

	if (*getMath == true)
	{
		UseMath = "/*\n\tprint(\"max(5,10) = \" << std::max(5,10));\n\tprint(\"min(5,10) = \" << std::min(5,10));\n\tprint(\"abs(-10) = \" << abs(-10));\n\tprint(\"pow(4,3) = \" << pow(4, 3));\n\tprint(\"acos(7) = \" << acos(7));\n\tprint(\"asin(7) = \" << asin(7));\n\tprint(\"atan(7) = \" << atan(7));\n\tprint(\"cbrt(7) = \" << cbrt(7));\n\tprint(\"cos(7) = \" << cos(7));\n\tprint(\"cosh(7) = \" << cosh(7));\n\tprint(\"fabs(7) = \" << fabs(7));\n\tprint(\"fdim(7, 8) = \" << fdim(7, 8));\n\tprint(\"hypot(7, 8) = \" << hypot(7, 8));\n\tprint(\"fma(7, 8, 9) = \" << fma(7, 8, 9));\n\tprint(\"fmax(7, 8) = \" << fmax(7, 8));\n\tprint(\"fmin(7, 8) = \" << fmin(7, 8));\n\tprint(\"fmod(7, 8) = \" << fmod(7, 8));\n\tprint(\"sin(7) = \" << sin(7));\n\tprint(\"sinh(7) = \" << sinh(7));\n\tprint(\"tan(7) = \" << tan(7));\n\tprint(\"tanh(7) = \" << tanh(7));\n\tprint(\"sqrt(64) = \" << sqrt(64));\n\tprint(\"exp(2.6) = \" << exp(2.6));\n\tprint(\"expm1(2.6) = \" << expm1(2.6));\n\tprint(\"ceil(2.6) = \" << ceil(2.6));\n\tprint(\"floor(2.6) = \" << floor(2.6));\n\tprint(\"round(2.6) = \" << round(2.6));\n\tprint(\"log(2) = \" << log(2));\n*/\n\n";
	}

	if (*getArgs == true)
	{
		Main = "//C++ Main...with cli arguments\nint main(int argc, char** argv)\n{\n"+StartRandom+"\tString out = String(argv[0]);\n\n\t//Parsing program name\n\tstd::size_t pos = out.rfind('/');\n\tTheName = out.substr(pos + 1);\n\tout = \"\";\n\n\t//Args were given\n\tif (argc > 1)\n\t{\n\t\t//Loop through Args\n\t\tfor (int i = 1; i < argc; i++)\n\t\t{\n\t\t\tout = String(argv[i]);\n\t\t\tif (out == \"find\")\n\t\t\t{\n\t\t\t\tprint(\"Found\");\n\t\t\t\tbreak;\n\t\t\t}\n\t\t}\n\t}\n\telse\n\t{\n\t\thelp();\n\t}\n\n"+UsePipe+UseThreads+UseVectors+UseMath+"\treturn 0;\n}\n";
	}
	else
	{
		Main = "//C++ Main\nint main()\n{\n"+StartRandom+UsePipe+UseThreads+UseVectors+UseMath+"\n\treturn 0;\n}\n";
	}
	return Main;
}

//create new c++ program
static void CreateNew(String filename, String content, String ext)
{
	filename = filename+ext;
	std::ofstream myfile;
	myfile.open(filename.c_str());
	myfile << content;
	myfile.close();
}

//check if source code exists
bool fexists(String aFile)
{
	bool IsFound = false;
	std::ifstream ifile;
	ifile.open(aFile);
	if (ifile)
	{
		ifile.close();
		IsFound = true;
	}
	return IsFound;
}


bool IsIn(String Str, String Sub)
{
	bool found = false;
	if (Str.find(Sub) != String::npos)
	{
		found = true;
	}
	return found;
}

//C++ main
int main(int argc, char** argv)
{
	bool NameIsNotOk = true;
	bool FileExists = false;
	bool getName = false;
	bool dontSave = false;
	bool getExt = false;
	bool getArgs = false;
	bool getRand = false;
	bool getFS = false;
	bool getFCheck = false;
	bool getWrite = false;
	bool getRead = false;
	bool getIsIn = false;
	bool getRawIn = false;
	bool getPipe = false;
	bool getProp = false;
	bool getShell = false;
	bool getSplit = false;
	bool getVect = false;
	bool getRev = false;
	bool getJoin = false;
	bool getSubStr = false;
	bool getThreads = false;
	bool getSleep = false;
	bool getConvert = false;
	bool getLength = false;
	bool getUpper = false;
	bool getLower = false;
	bool getMath = false;
	bool getDateAndTime = false;
	bool IsMain = false;
	bool getTheUser = false;
	String theUser = "";
	String theDeclaration = "";
	String theHelpMethod = "";
	//Getting program path
	String UserIn = String(argv[0]);
	String TheExt = ".cpp";
	String CName = "";
	String Imports = "";
	String Macros = "";
	String Methods = "";
	String Main = "";
	String Content = "";

	//Parsing program name
	std::size_t pos = UserIn.rfind('/');
	ProgName = UserIn.substr(pos + 1);
	UserIn = "";

	if (argc > 1)
	{
		//loop through args
		for (int i = 1; i < argc; i++)
		{
			//Save output to UserIn
			UserIn = String(argv[i]);
			//Get name of program
			if ((UserIn == "-n") || (UserIn == "--name"))
			{
				getName = true;
			}
			//Get name of program author
			else if (UserIn == "--no-save")
			{
				getName = false;
				dontSave = true;
			}
			//Get name of program author
			else if (UserIn == "--user")
			{
				getName = false;
				getTheUser = true;
			}
			//Get source code extension
			else if (UserIn == "--ext")
			{
				getName = false;
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
			//Convert data methods
			else if (UserIn == "--casting")
			{
				getName = false;
				getConvert = true;
			}
			//Get Random method
			else if (UserIn == "--random")
			{
				getName = false;
				getRand = true;
			}
			//Enamble Vectors
			else if (UserIn == "--vectors")
			{
				getName = false;
				getVect = true;
			}
			//Enamble Length
			else if (UserIn == "--get-length")
			{
				getName = false;
				getLength = true;
			}
			//Enamble Sub String
			else if (UserIn == "--sub-string")
			{
				getName = false;
				getSubStr = true;
				getIsIn = true;
			}
/*
			//Get Check file method
			else if (UserIn == "--check-file")
			{
				getName = false;
				getFCheck = true;
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
*/
			//Get raw_input method
			else if (UserIn == "--user-input")
			{
				getName = false;
				getRawIn = true;
			}
			//Get shell method
			else if (UserIn == "--shell")
			{
				getName = false;
				getShell = true;
			}
			//Get shell method
			else if (UserIn == "--files")
			{
				getName = false;
				getFS = true;
				getFCheck = true;
				getWrite = true;
				getRead = true;
			}
			//Enable Piping
			else if (UserIn == "--pipe")
			{
				getName = false;
				getPipe = true;
			}
			//Enable Threads
			else if (UserIn == "--thread")
			{
				getName = false;
				getThreads = true;
			}
			//Enable sleep
			else if (UserIn == "--sleep")
			{
				getName = false;
				getSleep = true;
			}
			//Enable split
			else if (UserIn == "--split")
			{
				getName = false;
				getSplit = true;
			}
			//Enable join
			else if (UserIn == "--join")
			{
				getName = false;
				getJoin = true;
			}
			//Enable uppercase
			else if (UserIn == "--upper")
			{
				getName = false;
				getUpper = true;
			}
			//Enable lowercase
			else if (UserIn == "--lower")
			{
				getName = false;
				getLower = true;
			}
			//Enable math
			else if (UserIn == "--math")
			{
				getName = false;
				getMath = true;
			}
			//Enable date and time
			else if (UserIn == "--date-time")
			{
				getName = false;
				getDateAndTime = true;
			}
			//Enable system property
			else if (UserIn == "--prop")
			{
				getName = false;
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
			//capture new C++ program name
			else if (getTheUser == true)
			{
				NameIsNotOk = IsIn(UserIn,"--");
				if (NameIsNotOk == false)
				{
					theUser = UserIn;
				}
				NameIsNotOk = true;
				getTheUser = false;
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
		if ((CName != "") || (dontSave == true))
		{
			if (dontSave == false)
			{
				//check if source code file exists
				FileExists = fexists(CName+TheExt);
			}

			// generate code to show or create source code
			if ((FileExists == false) || (dontSave == true))
			{
				//generate imports
				Imports = getImports(&getFCheck, &getWrite, &getRead, &getRand, &getPipe, &getShell, &getThreads, &getSleep, &getProp, &getSplit, &getJoin, &getRev, &getVect, &getLength, &getMath, &getFS, &getDateAndTime);
				//genarate macros
				Macros = getMacros(&getConvert, &getLength);
				//make declorations
				theDeclaration = getMethodDec(&getRawIn, &getRand, &getFCheck, &getWrite, &getRead, &getIsIn, &getShell, &getSleep, &getProp, &getSplit, &getJoin, &getRev, &getConvert, &getSubStr, &getLength, &getUpper, &getLower, &getFS, &getDateAndTime);
				//create methods
				Methods = getMethods(&getRawIn, &getRand, &getFCheck, &getWrite, &getRead, &getIsIn, &getShell, &getSleep, &getProp, &getSplit, &getJoin, &getRev, &getConvert, &getSubStr, &getLength, &getUpper, &getLower, &getFS, &getDateAndTime);
				//source code is a main file
				if (IsMain == true)
				{
					//create help page
					if (getArgs == true)
					{
						theHelpMethod = getHelp(theUser);
					}
					//generate main file
					Main = getMain(&getArgs, &getRand, &getPipe, &getThreads, &getVect, &getMath);
				}
				//This is not a main file
				else
				{
					Main = "";
				}
				//put together the soure file
				Content = Imports+Macros+theDeclaration+theHelpMethod+Methods+Main;

				//Save content to a source code file
				if (dontSave == false)
				{
					//create source code file
					CreateNew(CName,Content,TheExt);
				}
				//Dont Save file; only show output
				else
				{
					//Show source code
					print(Content);
				}
			}
			//Source code already exists
			else
			{
				error("\""+CName+TheExt+"\" already exists");
			}
		}
		//No Program name...show help page
		else
		{
			help();
		}
	}
	//No program argumnets given
	else
	{
		help();
	}

	return 0;
}
