#include <iostream>
#include <fstream>
#include <string>

//print marco for cout
#define print(x); std::cout << x << std::endl
//Convert std::string to String
#define String std::string

static void help();
static String getHelp(String TheName, String TheUser);
static String getMarcos(bool* Conv, bool* getLen);
static String getImports(bool* write, bool* read, bool* random, bool* pipe, bool* shell, bool* threads, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev, bool* Vect);
static String getMethodDec(bool* rawinput, bool* rand, bool* write, bool* read, bool* isin, bool* shell, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev, bool* Conv, bool* subStr, bool* getLen);
static String getMethods(bool* rawinput, bool* rand, bool* write, bool* read, bool* isin, bool* shell, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev, bool* Conv, bool* subStr, bool* getLen);
static String getMain(bool* getArgs, bool* getRandom, bool* getPipe, bool* getThreads, bool* getVectors);
static void CreateNew(String filename, String content, String ext);
bool IsIn(String Str, String Sub);

static void help()
{
	String ProgName = "newC++";
	String Version = "0.1.45";
	print("Author: Joespider");
	print("Program: \"" << ProgName << "\"");
	print("Version: " << Version);
	print("Purpose: make new C++ programs");
	print("Usage: " << ProgName << " <args>");
	print("\t--user <username>: get username for help page");
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
	print("\t--vectors : enable vector arrays");
	print("\t--thread : enable threading");
	print("\t--sleep : enable sleep method");
	print("\t--get-length : enable \"length\" examples");
	print("\t--casting : enable data type conversion methods");
	print("\t--sub-string : enable sub-string methods");
	print("\t--upper : enable upper case methods");
	print("\t--lower : enable lower case methods");
}

static String getHelp(String TheName, String TheUser)
{
	if (TheUser == "")
	{
		TheUser = std::getenv("USER");
	}
	String HelpDeclare = "static void help();\n";
	String HelpMethod = "static void help()\n{\n\tString TheName = \""+TheName+"\";\n\tString Version = \"0.0.0\";\n\tprint(\"Author: "+TheUser+"\");\n\tprint(\"Program: \\\"\" << TheName << \"\\\"\");\n\tprint(\"Version: \" << Version);\n\tprint(\"Purpose: \");\n\tprint(\"Usage: \" << TheName << \" <args>\");\n}\n\n";
	return HelpDeclare+"\n"+HelpMethod;
}

static String getMarcos(bool* Conv, bool* getLen)
{
	String Marcos = "";
	String MarcoPrint = "//print marco for cout\n#define print(x); std::cout << x << std::endl\n\n";
	String MarcoToStr = "";
	String MarcoLen = "";
	String MarcoString = "//Convert std::string to String\n#define String std::string\n\n";

	if (*Conv == true)
	{
		MarcoToStr = "//Str for to_strin()\n#define Str(x) std::to_string(x)\n\n";
	}
	if (*getLen == true)
	{
		MarcoLen = "//lenA for array sizze\n#define lenA(x) sizeof(x)/sizeof(x[0])\n\n";
	}
/*
	String MarcoLen = "//len marco for sizeof\n#define len(item) (sizeof(item))\n";
	Marcos = MarcoPrint+MarcoLen+"\n";
*/
	Marcos = MarcoPrint+MarcoToStr+MarcoString+MarcoLen+"\n";
	return Marcos;
}

//create import listing
static String getImports(bool* write, bool* read, bool* random, bool* pipe, bool* shell, bool* threads, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev, bool* Vect)
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
	if ((*Split == true) || (*Join == true) || (*Vect == true))
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
static String getMethodDec(bool* rawinput, bool* rand, bool* write, bool* read, bool* isin, bool* shell, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev, bool* Conv, bool* subStr, bool* getLen, bool* getUpper, bool* getLower)
{
	String Declaration = "";

	if (*rawinput == true)
	{
		Declaration = "String raw_input(String message);\n";
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
		Declaration = Declaration+"void CD(String command);\n";
	}
	if (*sleep == true)
	{
		Declaration = Declaration+"void sleep(int millies);\n";
	}
	if (*prop == true)
	{
		Declaration = Declaration+"String GetSysProp( String const & PleaseGet );\n";
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
		Declaration = Declaration+"int Int(String number);\n";
	}
	if (*subStr == true)
	{
		Declaration = Declaration+"String SubString(String TheString, int Pos);\n";
		Declaration = Declaration+"String SubString(String TheString, int Start, int End);\n";
		Declaration = Declaration+"int Index(String TheString, String SubStr);\n";
	}
	if (*Split == true)
	{
		Declaration = Declaration+"std::vector<String> split(String message, char by);\n";
		Declaration = Declaration+"std::vector<String> split(String message, String by);\n";
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
	return Declaration;
}

//create base methods
static String getMethods(bool* rawinput, bool* rand, bool* write, bool* read, bool* isin, bool* shell, bool* sleep, bool* prop, bool* Split, bool* Join, bool* Rev, bool* Conv, bool* subStr, bool* getLen, bool* getUpper, bool* getLower)
{
	String Methods = "";
	String Random = "";
	String RawInput = "";
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

	if (*rawinput == true)
	{
		RawInput = "//User Input\nString raw_input(String message)\n{\n\tString UserIn;\n\tstd::cout << message;\n\tgetline (std::cin,UserIn);\n\treturn UserIn;\n}\n\n";
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
		TheShell = TheShell+"void CD(String Dir)\n{\n\tchdir(Dir.c_str());\n}\n\n";
	}
	if (*sleep == true)
	{
		TheSleep = "void sleep(int millies)\n{\n\tstd::this_thread::sleep_for(std::chrono::milliseconds(millies));\n}\n\n";
	}
	if (*prop == true)
	{
		SysProp = "String GetSysProp( String const & PleaseGet )\n{\n\tchar * val = std::getenv( PleaseGet.c_str() );\n\tString retval = \"\";\n\tif (val != NULL)\n\t{\n\t\tretval = val;\n\t}\n\treturn retval;\n}\n\n";
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
		ConvData = ConvData+"//Convert String to Int\nint Int(String number)\n{\n\tint MyInt = stoi(number);\n\treturn MyInt;\n}\n\n";
	}
	if (*subStr == true)
	{
		SubStr = "String SubString(String TheString, int Pos)\n{\n\tString TheSub = TheString.substr(Pos);\n\treturn TheSub;\n}\n\n";
		SubStr = SubStr+"String SubString(String TheString, int Start, int End)\n{\n\tint Len = Start - End;\n\tif (Len <= -1)\n\t{\n\t\tLen = End;\n\t}\n\tString TheSub = TheString.substr(Start,Len);\n\treturn TheSub;\n}\n\n";
		SubStr = SubStr+"int Index(String TheString, String SubStr)\n{\n\tint place = TheString.find(SubStr);\n\treturn place;\n}\n\n";
	}
	if (*Split == true)
	{
		StrSplit = "std::vector<String> split(String message, char by)\n{\n\tstd::vector <String> vArray;\n\tstd::stringstream ss(message);\n\tString item;\n\twhile (std::getline(ss,item,by))\n\t{\n\t\tvArray.push_back(item);\n\t}\n\treturn vArray;\n}\n\n";
		StrSplit = StrSplit+"std::vector<String> split(String message, String by)\n{\n\tstd::vector <String> vArray;\n\tint end = message.length();\n\tint subLen = by.length();\n\tString item;\n\tString Push;\n\tbool LetsPush = false;\n\tbool LeftOver = false;\n\tfor (int lp = 0; lp != end; lp++)\n\t{\n\t\tfor (int plc = 0; plc != subLen; plc++)\n\t\t{\n\t\t\titem = item + message[lp+plc];\n\t\t}\n\n\t\tif (item == by)\n\t\t{\n\t\t\tLetsPush = true;\n\t\t\t//jump length of sub string\n\t\t\tlp += subLen;\n\t\t\tif (lp >= end)\n\t\t\t{\n\t\t\t\tLeftOver = true;\n\t\t\t\tbreak;\n\t\t\t}\n\t\t}\n\n\t\t//push new string to vector\n\t\tif (LetsPush == true)\n\t\t{\n\t\t\tLetsPush = false;\n\t\t\tvArray.push_back(Push);\n\t\t\tPush = \"\";\n\t\t}\n\n\t\tif (LetsPush == false)\n\t\t{\n\t\t\tPush = Push + message[lp];\n\t\t}\n\t\titem = \"\";\n\t}\n\n\tif ((LetsPush == true) || (Push != \"\"))\n\t{\n\t\tLetsPush = false;\n\t\tvArray.push_back(Push);\n\t}\n\n\tif (LeftOver == true)\n\t{\n\t\tvArray.push_back(\"\");\n\t}\n\treturn vArray;\n}\n\n";
		StrSplit = StrSplit+"std::vector<String> split(String message, String by, int at)\n{\n\tstd::vector <String> vArray;\n\tint end = message.length();\n\tint subLen = by.length();\n\tint num = 0;\n\tString item;\n\tString Push;\n\tbool LetsPush = false;\n\tbool LeftOver = false;\n\tfor (int lp = 0; lp != end; lp++)\n\t{\n\t\tfor (int plc = 0; plc != subLen; plc++)\n\t\t{\n\t\t\titem = item + message[lp+plc];\n\t\t}\n\n\t\tif ((item == by) && (num != at))\n\t\t{\n\t\t\tLetsPush = true;\n\t\t\t//jump length of sub string\n\t\t\tlp += subLen;\n\t\t\tif (lp >= end)\n\t\t\t{\n\t\t\t\tLeftOver = true;\n\t\t\t\tbreak;\n\t\t\t}\n\t\t}\n\n\t\t//push new string to vector\n\t\tif (LetsPush == true)\n\t\t{\n\t\t\tLetsPush = false;\n\t\t\tnum++;\n\t\t\tvArray.push_back(Push);\n\t\t\tPush = \"\";\n\t\t}\n\n\t\tif (LetsPush == false)\n\t\t{\n\t\t\tPush = Push + message[lp];\n\t\t}\n\t\titem = \"\";\n\t}\n\n\tif ((LetsPush == true) || (Push != \"\"))\n\t{\n\t\tLetsPush = false;\n\t\tvArray.push_back(Push);\n\t}\n\n\tif (LeftOver == true)\n\t{\n\t\tvArray.push_back(\"\");\n\t}\n\treturn vArray;\n}\n\n";
		StrSplit = StrSplit+"std::vector<String> rsplit(String message, String by, int at)\n{\n\tstd::vector <String> vArray;\n\tint end = message.length();\n\tint subLen = by.length();\n\tint place = (end - 1);\n\tint num = 0;\n\tString Tmp[at+1];\n\tint tmpSize = sizeof(Tmp)/sizeof(Tmp[0]);\n\tint tmpPlc = (tmpSize - 1);\n\tString item;\n\tString Push;\n\tbool LetsPush = false;\n\tbool LeftOver = false;\n\n\tfor (int lp = 0; lp != end; lp++)\n\t{\n\t\tfor (int plc = 0; plc != subLen; plc++)\n\t\t{\n\t\t\titem = message[place-plc] + item;\n\t\t}\n\n\t\tif ((item == by) && (num != at))\n\t\t{\n\t\t\tLetsPush = true;\n\t\t\tnum++;\n\t\t\t//jump length of sub string\n\t\t\tplace -= subLen;\n\t\t\tlp += subLen;\n\t\t\tif (lp >= end)\n\t\t\t{\n\t\t\t\tLeftOver = true;\n\t\t\t\tbreak;\n\t\t\t}\n\t\t}\n\n\t\t//push new string to vector\n\t\tif (LetsPush == true)\n\t\t{\n\t\t\tLetsPush = false;\n\t\t\tTmp[tmpPlc] = Push;\n\t\t\ttmpPlc -= 1;\n\t\t\tPush = \"\";\n\t\t}\n\n\t\tif (LetsPush == false)\n\t\t{\n\t\t\tPush = message[place] + Push;\n\t\t}\n\t\titem = \"\";\n\t\tplace -= 1;\n\t}\n\n\tif ((LetsPush == true) || (Push != \"\"))\n\t{\n\t\tLetsPush = false;\n\t\tTmp[tmpPlc] = Push;\n\t\ttmpPlc -= 1;\n\t}\n\n\tif (LeftOver == true)\n\t{\n\t\tTmp[tmpPlc] = \"\";\n\t\ttmpPlc -= 1;\n\t}\n\n\tfor (int srch = 0; srch != tmpSize; srch++)\n\t{\n\t\tvArray.push_back(Tmp[srch]);\n\t}\n\treturn vArray;\n}\n\n";
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

	//Methods for C++
	Methods = "\n"+RawInput+Random+IsIn+WriteFile+ReadFile+TheShell+TheSleep+SysProp+StrSplit+StrJoin+StrReplaceAll+StrRev+ConvData+SubStr+StrLen+StrUpper+StrLower;

	return Methods;
}

//build main function
static String getMain(bool* getArgs, bool* getRandom, bool* getPipe, bool* getThreads, bool* getVectors)
{
	String Main = "";
	String StartRandom = "";
	String UsePipe = "";
	String UseThreads = "";
	String UseVectors = "";

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
		UseVectors = "/*\n\t//string vectors\n\tstd::vector<String> TheStrVect;\n\t//append string\n\tTheStrVect.push_back(\"one\");\n\t//int vectors\n\n\tstd::vector<int> TheIntVect;\n\t//append int\n\tTheIntVect.push_back(1);\n\t//int vectors\n\n\tstd::vector<double> TheDblVect;\n\t//append double\n\tTheDblVect.push_back(1.0);\n\n\t//Vector length\n\tint TheStrVectLen = TheStrVect.size();\n\tint TheIntVectLen = TheIntVect.size();\n\tint TheDblVectLen = TheDblVect.size();\n*/\n\n\n";
	}

	if (*getArgs == true)
	{
		Main = "//C++ Main...with cli arguments\nint main(int argc, char** argv)\n{\n"+StartRandom+"\tString out = \"\";\n\t//Args were given\n\tif (argc > 1)\n\t{\n\t\t//Loop through Args\n\t\tfor (int i = 1; i < argc; i++)\n\t\t{\n\t\t\tout = String(argv[i]);\n\t\t\tif (out == \"find\")\n\t\t\t{\n\t\t\t\tprint(\"Found\");\n\t\t\t\tbreak;\n\t\t\t}\n\t\t}\n\t}\n\telse\n\t{\n\t\thelp();\n\t}\n\n"+UsePipe+UseThreads+UseVectors+"\treturn 0;\n}\n";
	}
	else
	{
		Main = "//C++ Main\nint main()\n{\n"+StartRandom+UsePipe+UseThreads+UseVectors+"\n\treturn 0;\n}\n";
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
	bool IsMain = false;
	bool getTheUser = false;
	String theUser = "";
	String theDeclaration = "";
	String theHelpMethod = "";
	String UserIn = "";
	String TheExt = ".cpp";
	String CName = "";
	String Imports = "";
	String Marcos = "";
	String Methods = "";
	String Main = "";
	String Content = "";
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
			else if (UserIn == "--user")
			{
				getTheUser = true;
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
			//Enable uppercase
			else if (UserIn == "--upper")
			{
				getUpper = true;
			}
			//Enable lowercase
			else if (UserIn == "--lower")
			{
				getLower = true;
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
		if (CName != "")
		{
			Imports = getImports(&getWrite, &getRead, &getRand, &getPipe, &getShell, &getThreads, &getSleep, &getProp, &getSplit, &getJoin, &getRev, &getVect);
			Marcos = getMarcos(&getConvert, &getLength);
			theDeclaration = getMethodDec(&getRawIn, &getRand, &getWrite, &getRead, &getIsIn, &getShell, &getSleep, &getProp, &getSplit, &getJoin, &getRev, &getConvert, &getSubStr, &getLength, &getUpper, &getLower);
			Methods = getMethods(&getRawIn, &getRand, &getWrite, &getRead, &getIsIn, &getShell, &getSleep, &getProp, &getSplit, &getJoin, &getRev, &getConvert, &getSubStr, &getLength, &getUpper, &getLower);
			if (IsMain == true)
			{
				if (getArgs == true)
				{
					theHelpMethod = getHelp(CName,theUser);
				}
				Main = getMain(&getArgs, &getRand, &getPipe, &getThreads, &getVect);
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
