#include <iostream>
#include <string>
#include <unistd.h>
#include <stdexcept>
#include <stdio.h>
#include <sstream>
#include <vector>

//print marco for cout
#define print(x); std::cout << x << std::endl

//error marco for cerr
#define error(x); std::cerr << x << std::endl

//Convert std::string to String
#define String std::string

String getOS();
void Help(String Option);
int len(std::vector<String> Vect);
void clear();
String raw_input(String message);
String shell(String command);
void shellExe(String command);
String getCplV();
bool IsIn(String Str, String Sub);
bool StartsWith(String Str, String Start);
std::vector<String> split(String message, char by);
std::vector<String> split(String message, String by, int at);
void banner();
void Class(String Name);
void Array();
void Logic();
void Function();
void Loop();
void HandleCondition(String Value);
void HandleKind(String Value);
void HandleName(String Value);

String Version = "0.0.3";
String TheKind = "";
String TheName = "";
String TheKindType = "";
String TheDataType = "";
String TheCondition = "";
String Parameters = "";

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

void Help(String Option = "")
{
	if (Option == "")
	{
		print("C++ shell");
		print("Generate C++ code");
		print("");
		print("type:<type>=<args>");
		print("type <type> <args>");
		print("{Type options}");
		print("\tloop <args>");
		print("\tlogic <args>");
		print("\tfunction <args>");
		print("");
		print("name:<function/class name>");
		print("name <function/class name>");
		print("");
		print("condition:<condition>");
		print("condition <condition>");
		print("");
		print("gen\t\t:\t\"Generate code\"");
		print("help\t\t:\t\"This Page\"");
		print("help <type>\t:\t\"Get type options\"");
	}
	else if (Option == "condition")
	{
		print("create your conditions");
	}
	else if (Option == "name")
	{
		print("give the name of your function");
	}
	else if (Option == "type")
	{
		print("Provide the type of structure needed");
		print("");
		Help("loop");
		print("");
		Help("logic");
		print("");
		Help("function");
	}
	else if (Option == "loop")
	{
		print("type:loop <args>");
		print("type loop <args>");
		print("\tfor");
		print("\twhile");
		print("\tdo/while");
	}
	else if (Option == "logic")
	{
		print("type:logic <args>");
		print("type logic <args>");
		print("\tif");
		print("\tif/else");
		print("\tif/else");
		print("\tswitch");
	}
	else if (Option == "function")
	{
		print("type:function <data type>");
		print("type function <data type>");
	}
}

int len(std::vector<String> Vect)
{
	int StrLen = Vect.size();
	return StrLen;
}

void clear()
{
	shellExe("clear");
}

//User Input
String raw_input(String message)
{
	String UserIn;
	std::cout << message;
	getline (std::cin,UserIn);
	return UserIn;
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

std::vector<String> split(String message, String by, int at)
{
	std::vector <String> vArray;
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

void banner()
{
	String cplV = getCplV();
	String theOS = getOS();
	print(cplV);
	print("[C++ " << Version<< "] on " << theOS);
	print("Type \"help\" for more information.");
}

void Class()
{
	print("class " << TheName << " {");
	print("");
	print("private:");
	print("\t//private variables");
	print("\tint x, y;");
	print("public:");
	print("\t//class constructor");
	print("\t" << TheName << "(int x, int y)");
	print("\t{");
	print("\t\t// this-> points to the class's x, y; not param x, y vars");
	print("\t\tthis->x = x;");
	print("\t\tthis->y = y;");
	print("\t}");
	print("");
	print("\t//class desctructor");
	print("\t~" << TheName << "()");
	print("\t{");
	print("\t\t//NO code");
	print("\t}");
	print("\t/*");
	print("\t\tfunctions go here");
	print("\t*/");
	print("};");
}

void Array()
{
	print("work on arrays");
}

void Logic()
{
	if (TheKindType == "if")
	{
		print("if (" << TheCondition << ")");
		print("{");
		print("\t//do something here");
		print("}");
	}
	else if (TheKindType == "if/else")
	{
		print("if (" << TheCondition << ")");
		print("{");
		print("\t//do something here");
		print("}");
		print("else if (" << TheCondition << ")");
		print("{");
		print("\t//do something here");
		print("}");
		print("else");
		print("{");
		print("\t//do something here");
		print("}");
	}
	else if (TheKindType == "switch")
	{
		print("switch (" << TheCondition << ")");
		print("{");
		print("\tcase x:");
		print("\t\t//code here");
		print("\t\tbreak;");
		print("\tcase y:");
		print("\t\t//code here");
		print("\t\tbreak;");
		print("\tdefault:");
		print("\t\t//code here");
		print("}");
	}
}

void Function()
{
	if (TheKindType == "void")
	{
		print("void " << TheName << "()");
		print("{");
		print("\t//do something here");
		print("}");
	}
	else
	{
		print(TheKindType<<" "<< TheName <<"()");
		print("{");
		print("\t" << TheKindType << " TheReturn;");
		print("\t//do something here");
		print("\treturn TheReturn;");
		print("}");
	}
}

void Loop()
{
	if (TheKindType == "for")
	{
		print("for (" << TheCondition << ")");
		print("{");
		print("\t//do something here");
		print("}");
	}
	else if (TheKindType == "do/while")
	{
		print("do");
		print("{");
		print("\t//do something here");
		print("}");
		print("while (" << TheCondition << ");");
	}
	else
	{
		print("while (" << TheCondition << ")");
		print("{");
		print("\t//do something here");
		print("}");
	}
}

void HandleName(String Value)
{
	TheName = Value;
}

void HandleCondition(String Value)
{
	TheCondition = Value;
}

void HandleKind(String Value)
{
	int length;
	if (IsIn(Value,"="))
	{
		std::vector<String> UserArgs = split(Value,'=');
		length = len(UserArgs);
		if (length == 2)
		{
			HandleKind(UserArgs[0]);
			TheKindType = UserArgs[1];
		}
	}
	else if (IsIn(Value," "))
	{
		std::vector<String> UserArgs = split(Value,' ');
		length = len(UserArgs);
		if (length == 2)
		{
			HandleKind(UserArgs[0]);
			TheKindType = UserArgs[1];
		}
	}
	else
	{
		if ((Value == "loop") || (Value == "logic") || (Value == "function") || (Value == "array") || (Value == "class"))
		{
			TheKind = Value;
//			TheKindType = "";
		}
		else
		{
			print("Error: not a valid type");
		}
	}
}

//C++ Main
int main()
{
	int length;
	String UserIn = "";
	banner();
	while (true)
	{
		UserIn = raw_input(">>> ");
		if (UserIn != "")
		{
			if (UserIn == "exit")
			{
				print("User exit() to exit");
			}
			else if (UserIn == "exit()")
			{
				break;
			}
			else if (UserIn == "help")
			{
				Help();
			}
			else if (StartsWith(UserIn,"help "))
			{
				std::vector<String> UserArgs = split(UserIn,' ');
				length = len(UserArgs);
				if (length == 2)
				{
					Help(UserArgs[1]);
				}
				else
				{
					Help();
				}
			}
			else if (UserIn == "gen")
			{
				if (TheKind == "loop")
				{
					Loop();
				}
				else if (TheKind == "array")
				{
					Array();
				}
				else if (TheKind == "class")
				{
					Class();
				}
				else if (TheKind == "logic")
				{
					Logic();
				}
/*
				else if (TheKind == "condition")
				{
					Conditions();
				}
*/
				else if (TheKind == "function")
				{
					Function();
				}
			}
			else if (UserIn == "clear")
			{
				clear();
			}
			else if (StartsWith(UserIn,"condition"))
			{
				if (StartsWith(UserIn,"condition:"))
				{
					std::vector<String> UserArgs = split(UserIn,":",1);
					HandleCondition(UserArgs[1]);
				}
				else if (StartsWith(UserIn,"condition "))
				{
					std::vector<String> UserArgs = split(UserIn," ",1);
					HandleCondition(UserArgs[1]);
				}
				//no arguments given...call help
				else
				{
					Help("condition");
				}
			}
			else if (StartsWith(UserIn,"name"))
			{
				if (StartsWith(UserIn,"name:"))
				{
					std::vector<String> UserArgs = split(UserIn,":",1);
					HandleName(UserArgs[1]);
				}
				else if (StartsWith(UserIn,"name "))
				{
					std::vector<String> UserArgs = split(UserIn," ",1);
					HandleName(UserArgs[1]);
				}
				//no arguments given...call help
				else
				{
					Help("name");
				}
			}
			else if (StartsWith(UserIn,"type"))
			{
				if (StartsWith(UserIn,"type:"))
				{
					std::vector<String> UserArgs = split(UserIn,":",1);
					HandleKind(UserArgs[1]);
				}
				else if (StartsWith(UserIn,"type "))
				{
					std::vector<String> UserArgs = split(UserIn," ",1);
					HandleKind(UserArgs[1]);
				}
				//no arguments given...call help
				else
				{
					Help("type");
				}
			}
		}
	}
	return 0;
}
