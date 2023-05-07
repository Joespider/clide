#include <iostream>
#include <string>
//#include <unistd.h>
//#include <stdexcept>
#include <stdio.h>
//#include <sstream>
#include <vector>

#define PressEnter std::cout << "Press \"Enter\" to Continue "; std::cin.get()

//print Macro for cout
#define print(x); std::cout << x << std::endl

//error Macro for cerr
#define error(x); std::cerr << x << std::endl

//Convert std::string to String
#define String std::string

String Version = "0.0.7";

void Help();
String getOS();
String raw_input(String message);
void clear();
String shell(String command);
void shellExe(String command);
String getCplV();
bool IsIn(String Str, String Sub);
bool StartsWith(String Str, String Start);
bool EndsWith(String Str, String End);
int len(std::vector<String> Vect);
String SplitBefore(String Str, char splitAt);
String SplitAfter(String Str, char splitAt);
/*
std::vector<String> split(String message, char by);
std::vector<String> split(String message, String by);
std::vector<String> split(String message, String by, int at);
std::vector<String> rsplit(String message, String by, int at);
*/
String Struct(String TheName, String Content);
String Class(String TheName, String Content);
String Method(String Tabs, String Name, String Content);
String GenCode(String Tabs,String GetMe);
String Loop(String Tabs, String TheKindType, String Content);
String Logic(String Tabs, String TheKindType, String Content);

void Help()
{
	print("class:<name> param:<params>,<param> method:<name>-<type> param:<params>,<param>");
	print("class:pizza params:one,two,three method:cheese params:four,five loop:for");
	print("struct:<name>-<type>");
	print("method:<name>-<type> param:<params>,<param>");
	print("loop:<type>");
	print("logic:<type>");
}

String getOS()
{
	#ifdef _WIN32
	return "Windows 32-bit";
	#elif _WIN64
	return "Windows 64-bit";
	#elif __APPLE__ || __MACH__
	return "Mac OSX";
	#elif __linux__
	return "Linux";
	#elif __FreeBSD__
	return "FreeBSD";
	#elif __unix || __unix__
	return "Unix";
	#else
	return "Other";
	#endif
}

//User Input
String raw_input(String message)
{
	String UserIn;
	std::cout << message;
	getline (std::cin,UserIn);
	return UserIn;
}

void clear()
{
	shellExe("clear");
}

String shell(String command)
{
	char buffer[128];
	String result = "";

	// Open pipe to file
	FILE* pipe = popen(command.c_str(), "r");
	if (!pipe)
	{
		return "";
	}

	// read till end of process:
	while (!feof(pipe))
	{
		// use buffer to read and add to result
		if (fgets(buffer, 128, pipe) != NULL)
		{
			result += buffer;
		}
	}

	pclose(pipe);
	return result;
}

void shellExe(String command)
{
	system(command.c_str());
}

String getCplV()
{
	String cplV = "";
	cplV = shell("g++ --version 2> /dev/null | head -n 1 | tr -d '\n'");
	if (cplV == "")
	{
		cplV = shell("clang++ --version 2> /dev/null | head -n 1 | tr -d '\n'");
	}
	return cplV;
}

//Check if sub-string is in string
bool IsIn(String Str, String Sub)
{
	bool found = false;
	if (Str.find(Sub) != String::npos)
	{
		found = true;
	}
	return found;
}

//Check if string begins with substring
bool StartsWith(String Str, String Start)
{
	bool ItDoes = false;
	if (Str.rfind(Start, 0) == 0)
	{
		ItDoes = true;
	}
	return ItDoes;
}

//Check if string ends with substring
bool EndsWith(String Str, String End)
{
	bool ItDoes = false;
	if (Str.length() < End.length())
	{
		ItDoes = false;
	}
	else
	{
		ItDoes = std::equal(End.rbegin(), End.rend(), Str.rbegin());
	}
	return ItDoes;
}

int len(std::vector<String> Vect)
{
	int StrLen = Vect.size();
	return StrLen;
}

String SplitBefore(String Str, char splitAt)
{
	bool Show = true;
	String newString;
	int end = Str.length();
	if (end != 0)
	{
		for (int lp = 0; lp != end; lp++)
		{
			if (Str[lp] == splitAt)
			{
				break;
			}
			else
			{
				newString = newString+Str[lp];
			}
	}
	}
	return newString;
}

String SplitAfter(String Str, char splitAt)
{
	bool Show = false;
	String newString;
	int end = Str.length();
	if (end != 0)
	{
		for (int lp = 0; lp != end; lp++)
		{
			if (Show == true)
			{
				newString = newString+Str[lp];
			}
			if ((Str[lp] == splitAt) && (Show != true))
			{
				Show = true;
			}
		}
	}
	return newString;
}
/*
std::vector<String> split(String message, char by)
{
	std::vector <String> vArray;
	std::stringstream ss(message);
	String item;
	while (std::getline(ss,item,by))
	{
		vArray.push_back(item);
	}
	return vArray;
}

std::vector<String> split(String message, String by)
{
	std::vector <String> vArray;
	int end = message.length();
	int subLen = by.length();
	String item;
	String Push;
	bool LetsPush = false;
	bool LeftOver = false;
	for (int lp = 0; lp != end; lp++)
	{
		for (int plc = 0; plc != subLen; plc++)
		{
			item = item + message[lp+plc];
		}

		if (item == by)
		{
			LetsPush = true;
			//jump length of sub string
			lp += subLen;
			if (lp >= end)
			{
				LeftOver = true;
				break;
			}
		}

		//push new string to vector
		if (LetsPush == true)
		{
			LetsPush = false;
			vArray.push_back(Push);
			Push = "";
		}

		if (LetsPush == false)
		{
			Push = Push + message[lp];
		}
		item = "";
	}

	if ((LetsPush == true) || (Push != ""))
	{
		LetsPush = false;
		vArray.push_back(Push);
	}

	if (LeftOver == true)
	{
		vArray.push_back("");
	}
	return vArray;
}

std::vector<String> split(String message, String by, int at)
{
	std::vector<String> vArray;
	int end = message.length();
	int subLen = by.length();
	int num = 0;
	String item;
	String Push;
	bool LetsPush = false;
	bool LeftOver = false;
	for (int lp = 0; lp != end; lp++)
	{
		for (int plc = 0; plc != subLen; plc++)
		{
			item = item + message[lp+plc];
		}

		if ((item == by) && (num != at))
		{
			LetsPush = true;
			//jump length of sub string
			lp += subLen;
			if (lp >= end)
			{
				LeftOver = true;
				break;
			}
		}

		//push new string to vector
		if (LetsPush == true)
		{
			LetsPush = false;
			num++;
			vArray.push_back(Push);
			Push = "";
		}

		if (LetsPush == false)
		{
			Push = Push + message[lp];
		}
		item = "";
	}

	if ((LetsPush == true) || (Push != ""))
	{
		LetsPush = false;
		vArray.push_back(Push);
	}

	if (LeftOver == true)
	{
		vArray.push_back("");
	}
	return vArray;
}

std::vector<String> rsplit(String message, String by, int at)
{
	std::vector <String> vArray;
	int end = message.length();
	int subLen = by.length();
	int place = (end - 1);
	int num = 0;
	String Tmp[at+1];
	int tmpSize = sizeof(Tmp)/sizeof(Tmp[0]);
	int tmpPlc = (tmpSize - 1);
	String item;
	String Push;
	bool LetsPush = false;
	bool LeftOver = false;

	for (int lp = 0; lp != end; lp++)
	{
		for (int plc = 0; plc != subLen; plc++)
		{
			item = message[place-plc] + item;
		}

		if ((item == by) && (num != at))
		{
			LetsPush = true;
			num++;
			//jump length of sub string
			place -= subLen;
			lp += subLen;
			if (lp >= end)
			{
				LeftOver = true;
				break;
			}
		}

		//push new string to vector
		if (LetsPush == true)
		{
			LetsPush = false;
			Tmp[tmpPlc] = Push;
			tmpPlc -= 1;
			Push = "";
		}

		if (LetsPush == false)
		{
			Push = message[place] + Push;
		}
		item = "";
		place -= 1;
	}

	if ((LetsPush == true) || (Push != ""))
	{
		LetsPush = false;
		Tmp[tmpPlc] = Push;
		tmpPlc -= 1;
	}

	if (LeftOver == true)
	{
		Tmp[tmpPlc] = "";
		tmpPlc -= 1;
	}

	for (int srch = 0; srch != tmpSize; srch++)
	{
		vArray.push_back(Tmp[srch]);
	}
	return vArray;
}
*/
void banner()
{
	String cplV = getCplV();
	String theOS = getOS();
	print(cplV);
	print("[C++ " << Version<< "] on " << theOS);
	print("Type \"help\" for more information.");
}

String Struct(String TheName, String Content)
{
	String Complete = "";
	TheName = SplitAfter(TheName,':');
	Complete = "struct {\n"+Content+"\tstring brand;\n\tstring model;\n\tint year;\n} "+TheName+";\n";
	return Complete;
}

String Class(String TheName, String Content)
{
	String Complete = "";
	TheName = SplitAfter(TheName,':');
	String Params = "";
	String ClassContent = "";
	while (Content != "")
	{
		if (StartsWith(Content, "params"))
		{
			Params = GenCode("",Content);
		}
		else if (StartsWith(Content, "method"))
//		else
		{
			ClassContent = ClassContent + GenCode("\t",Content);
		}
		Content = SplitAfter(Content,' ');
	}

	Complete = "class "+TheName+" {\n\nprivate:\n\t//private variables\n\tint x, y;\npublic:\n\t//class constructor\n\t"+TheName+"(int x, int y)\n\t{\n\t\tthis->x = x;\n\t\tthis->y = y;\n\t}\n\n\t//class desctructor\n\t~"+TheName+"()\n\t{\n\t}\n"+ClassContent+"\n};\n";
	return Complete;
}

String Method(String Tabs, String Name, String Content)
{
	String Complete = "";
	Name = SplitAfter(Name,':');
	String TheName = SplitBefore(Name,'-');
	String Type = SplitAfter(Name,'-');
	String Params = "";
	String MethodContent = "";
	while (Content != "")
	{
		if (StartsWith(Content, "params"))
		{
			Params = GenCode("",Content);
		}
		else if ((!StartsWith(Content, "method")) && (!StartsWith(Content, "class")))
		{
			MethodContent = MethodContent + GenCode(Tabs+"\t",Content);
		}
		Content = SplitAfter(Content,' ');
	}

	if ((Type == "") || (Type == "void"))
	{
		Complete = Tabs+"void " + TheName + "("+Params+")\n"+Tabs+"{\n"+MethodContent+"\n"+Tabs+"}\n";
	}
	else
	{
		Complete = Tabs+Type+" "+TheName+"("+Params+")\n"+Tabs+"{\n"+Tabs+"\t" +Type+" TheReturn;\n"+MethodContent+"\n"+Tabs+"\treturn TheReturn;\n"+Tabs+"}\n";
	}
	return Complete;
}

String Conditions(String input)
{
	String Type = SplitAfter(input,':');
	return Type;
}

String Parameters(String input)
{
	String Type = SplitAfter(input,':');
	return Type;
}

String Loop(String Tabs, String TheKindType, String Content)
{
	String Complete = "";
	TheKindType = SplitAfter(TheKindType,':');
	String TheName = SplitBefore(TheKindType,'-');
	String Type = SplitAfter(TheKindType,'-');
	String TheCondition = "";
	String LoopContent = "";
	while (Content != "")
	{
		if (StartsWith(Content, "condition"))
		{
			TheCondition = GenCode("",Content);
		}
		else if ((!StartsWith(Content, "method")) && (!StartsWith(Content, "class")))
		{
			LoopContent = LoopContent + GenCode(Tabs+"\t",Content);
		}
		Content = SplitAfter(Content,' ');
	}

	if (TheKindType == "for")
	{
		Complete = Tabs+"for ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+Tabs+"}\n";
	}
	else if (TheKindType == "do/while")
	{
		Complete = Tabs+"do\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+Tabs+"}\n"+Tabs+"while ("+TheCondition+");\n";
	}
	else
	{
		Complete = Tabs+"while ("+TheCondition+")\n{\n\t//do something here\n}\n";
	}
	return Complete;
}

String Logic(String Tabs, String TheKindType, String Content)
{
	String Complete = "";
	TheKindType = SplitAfter(TheKindType,':');
	String TheName = SplitBefore(TheKindType,'-');
	String Type = SplitAfter(TheKindType,'-');
	String TheCondition = "";
	String LogicContent = "";
	while (Content != "")
	{
		if (StartsWith(Content, "condition"))
		{
			TheCondition = GenCode("",Content);
		}
		else if ((!StartsWith(Content, "method")) && (!StartsWith(Content, "class")))
//		else
		{
			LogicContent = LogicContent + GenCode(Tabs+"\t",Content);
		}
		Content = SplitAfter(Content,' ');
	}

	if (TheKindType == "if")
	{
		Complete = "if ("+TheCondition+")\n{\n\t//do something here\n}\n";
	}
	else if (TheKindType == "if/else")
	{
		Complete = Tabs+"if ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+Tabs+"}\n"+Tabs+"else if ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+Tabs+"}\n"+Tabs+"else\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+Tabs+"\t}\n";
	}
	else if (TheKindType == "switch")
	{
		Complete = Tabs+"switch ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\tcase x:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n"+Tabs+"\tcase y:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n"+Tabs+"\tdefault:\n"+Tabs+"\t\t//code here\n"+Tabs+"}\n";
	}
	return Complete;
}

String GenCode(String Tabs,String GetMe)
{
	String TheCode = "";
	String Args[2];
	Args[0] = SplitBefore(GetMe,' ');
	Args[1] = SplitAfter(GetMe,' ');
	if (StartsWith(Args[0], "class"))
	{
		TheCode = Class(Args[0],Args[1]);
	}
	else if (StartsWith(Args[0], "struct"))
	{
		TheCode = Struct(Args[0],Args[1]);
	}
	else if (StartsWith(Args[0], "method"))
	{
		TheCode = Method(Tabs,Args[0],Args[1]);
	}
	else if (StartsWith(Args[0], "loop"))
	{
		TheCode = Loop(Tabs,Args[0],Args[1]);
	}
	else if (StartsWith(Args[0], "logic"))
	{
		TheCode = Logic(Tabs,Args[0],Args[1]);
	}
	else if (StartsWith(Args[0], "condition"))
	{
		TheCode = Conditions(Args[0]);
	}
	else if (StartsWith(Args[0], "params"))
	{
		TheCode = Parameters(Args[0]);
	}

	return TheCode;
}

//C++ Main
int main()
{
	banner();
	String UserIn = "";
	while (true)
	{
		UserIn = raw_input(">>> ");
		if (UserIn == "exit()")
		{
			break;
		}
		else if (UserIn == "exit")
		{
			print("Use exit()");
		}
		else if (UserIn == "clear")
		{
			clear();
		}
		else if (UserIn == "help")
		{
			Help();
		}
		else
		{
			print(GenCode("",UserIn));
		}
	}
	return 0;
}
