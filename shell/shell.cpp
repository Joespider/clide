#include <iostream>
#include <string>
//#include <unistd.h>
//#include <stdexcept>
#include <stdio.h>
//#include <sstream>
#include <vector>

//#define PressEnter std::cout << "Press \"Enter\" to Continue "; std::cin.get()

//print Macro for cout
#define print(x); std::cout << x << std::endl

//error Macro for cerr
#define error(x); std::cerr << x << std::endl

//Convert std::string to String
#define String std::string

String Version = "0.0.21";

String getOS();
void Help(String Type);
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
String Variables(String Tabs, String input);
String Conditions(String input,String CalledBy);
String Parameters(String input,String CalledBy);
String Loop(String Tabs, String TheKindType, String Content);
String Logic(String Tabs, String TheKindType, String Content);

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

void Help(String Type)
{
	Type = SplitAfter(Type,':');
	if (Type == "class")
	{
		print("{Usage}");
		print("class:<name> param:<params>,<param> var:<vars> method:<name>-<type> param:<params>,<param>");
		print("");
		print("{EXAMPLE}");
		print("class:pizza params:one,two,three method:cheese params:four,five loop:for");
	}
	else if (Type == "struct")
	{
		print("struct:<name>-<type> var:<var> var:<var>");
		print("");
		print("{EXAMPLE}");
		print("struct:pizza var:topping-String var:number-int");
	}
	else if (Type == "method")
	{
		print("method:<name>-<type> param:<params>,<param>");
	}
	else if (Type == "loop")
	{
		print("loop:<type>");
		print("");
		print("{EXAMPLE}");
		print("loop:for");
		print("loop:do/while");
		print("loop:while");

	}
	else if (Type == "logic")
	{
		print("logic:<type>");
		print("");
		print("{EXAMPLE}");
		print("logic:if");
		print("logic:else-if");
		print("logic:switch");
	}
	else if (Type == "var")
	{
		print("var:<name>-<type>=value\tcreate a new variable");
		print("var:<name>-<type>[<num>]=value\tcreate a new variable as an array");
		print("var:<name>-<type>(<struct>)=value\tcreate a new variable a data structure");
		print("var:<name>=value\tassign a new value to an existing variable");
		print("");
		print("{EXAMPLE}");
		print("var:name-std::string[3]");
		print("var:name-std::string(vector)");
		print("var:name-std::string=\"\" var:point-int=0 var:james-std::string=\"James\" var:help-int");
	}
	else
	{
		print("Components to Generate");
		print("class\t\t:\t\"Create a class\"");
		print("struct\t\t:\t\"Create a struct\"");
		print("method\t\t:\t\"Create a method\"");
		print("loop\t\t:\t\"Create a loop\"");
		print("logic\t\t:\t\"Create a logic\"");
		print("var\t\t:\t\"Create a variable\"");
		print("nest-<type>\t:\t\"next element is nested in previous element\"");
		print("");
		print("help:<type>");
	}
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
	String newString;
	std::size_t pos = Str.find(splitAt);
	newString = Str.substr(0,pos);
	return newString;
}

String SplitAfter(String Str, char splitAt)
{
	String newString;
	std::size_t pos = Str.find(splitAt);
	newString = Str.substr(pos + 1);
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
	String StructVar = "";
	TheName = SplitAfter(TheName,':');
	StructVar = StructVar + GenCode("\t",Content);
	Complete = "struct {\n"+StructVar+"\n} "+TheName+";\n";
	return Complete;
}

String Class(String TheName, String Content)
{
	String Complete = "";
/*
	String PublicOrPrivate = "public";
	if (IsIn(TheName,"class-"))
	{
		PublicOrPrivate = SplitAfter(TheName,"-");
		PublicOrPrivate = SplitBefore(PublicOrPrivate,":");
	}
*/
	TheName = SplitAfter(TheName,':');
	String Params = "";
	String ClassContent = "";
	while (Content != "")
	{
		if (StartsWith(Content, "params"))
		{
			Params =  Parameters(Content,"class");

		}
		else if (StartsWith(Content, "method"))
		{
			ClassContent = ClassContent + GenCode("\t",Content);
		}
		Content = SplitAfter(Content,' ');
	}

	Complete = "class "+TheName+" {\n\nprivate:\n\tprivate variables\n\tint x, y;\npublic:\n\t//class constructor\n\t"+TheName+"("+Params+")\n\t{\n\t\tthis->x = x;\n\t\tthis->y = y;\n\t}\n\n"+ClassContent+"\n\t//class desctructor\n\t~"+TheName+"()\n\t{\n\t}\n};\n";
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
	String LastComp = "";
	while (Content != "")
	{
		if (StartsWith(Content, "params"))
		{
			Params =  Parameters(Content,"method");
		}
//		else if ((!StartsWith(Content, "method")) && (!StartsWith(Content, "class")) && (StartsWith(Content, "nest-")))
		else if ((!StartsWith(Content, "method")) && (!StartsWith(Content, "class")))
		{
			MethodContent = MethodContent + GenCode(Tabs+"\t",Content);
		}
		Content = SplitAfter(Content,' ');
	}

	if ((Type == "") || (Type == "void"))
	{
		Complete = Tabs+"void "+TheName + "("+Params+")\n"+Tabs+"{\n"+MethodContent+"\n"+Tabs+"}\n";
	}
	else
	{
		Complete = Tabs+Type+" "+TheName+"("+Params+")\n"+Tabs+"{\n"+Tabs+"\t" +Type+" TheReturn;\n"+MethodContent+"\n"+Tabs+"\treturn TheReturn;\n"+Tabs+"}\n";
	}
	return Complete;
}

String Variables(String Tabs, String input)
{
	String Type = "";
	String Name = "";
	String VarType = "";
	String Value = "";

	if (IsIn(input,":") && IsIn(input,"-") && IsIn(input,"="))
	{
		Type = SplitAfter(input,':');
		Name = SplitBefore(Type,'-');
		VarType = SplitAfter(Type,'-');
		Value = SplitAfter(VarType,'=');
		VarType = SplitBefore(VarType,'=');
	}
	else if (IsIn(input,":") && IsIn(input,"="))
	{
		Type = SplitAfter(input,':');
		Name = SplitBefore(Type,'=');
		Value = SplitAfter(Type,'=');
	}
	else if (IsIn(input,":") && IsIn(input,"-"))
	{
		Type = SplitAfter(input,':');
		Name = SplitBefore(Type,'-');
		VarType= SplitAfter(Type,'-');
	}

	String NewVar = "";
/*
	//consider adapting variable type to be an array, vetctor, etc.
	switch (VarType) {
		case "one":
			break;
		case "two":
			break;
		case "three":
			break;
		case "four":
			break;
		default:
			break;
	}
*/
	if (Value == "")
	{
		NewVar = Tabs+VarType+" "+Name+";\n";
	}
	else if (VarType == "")
	{
		NewVar = Tabs+Name+" = "+Value+";\n";
	}
	else
	{
		NewVar = Tabs+VarType+" "+Name+" = "+Value+";\n";
	}

	return NewVar;
}

String Conditions(String input,String CalledBy)
{
	String Condit = SplitAfter(input,':');
	if (CalledBy == "class")
	{
		print("condition: " <<CalledBy);
	}
	else if (CalledBy == "method")
	{
		print("condition: " <<CalledBy);
	}
	else if (CalledBy == "loop")
	{
		print("condition: " <<CalledBy);
	}
	return Condit;
}

String Parameters(String input,String CalledBy)
{
	String Params = SplitAfter(input,':');
	if ((CalledBy == "class") || (CalledBy == "method"))
	{
		if ((IsIn(Params,"-")) && (IsIn(Params,",")))
		{
			String Name = SplitBefore(Params,'-');
			String Type = SplitAfter(Params,'-');
			Type = SplitBefore(Type,',');
			String more = SplitAfter(Params,',');
			more = Parameters("params:"+more,CalledBy);
			Params = Type+" "+Name+", "+more;
		}
		else if ((IsIn(Params,"-")) && (!IsIn(Params,",")))
		{
			String Name = SplitBefore(Params,'-');
			String Type = SplitAfter(Params,'-');
			Params = Type+" "+Name;
		}
	}
	return Params;
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
			TheCondition = Conditions(Content,TheKindType);

		}
		else if ((!StartsWith(Content, "method")) && (!StartsWith(Content, "class")) && (StartsWith(Content, "nest-")))
		{
			Content = SplitAfter(Content,'-');
			LoopContent = LoopContent + GenCode(Tabs+"\t",Content);
		}
		Content = SplitAfter(Content,' ');
	}

	if (TheKindType == "for")
	{
		Complete = Tabs+"for ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+LoopContent+"\n"+Tabs+"}\n";
	}
	else if (TheKindType == "do/while")
	{
		Complete = Tabs+"do\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+LoopContent+Tabs+"}\n"+Tabs+"while ("+TheCondition+");\n";
	}
	else
	{
		Complete = Tabs+"while ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+LoopContent+Tabs+"}\n";
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
			TheCondition = Conditions(Content,TheKindType);
		}
		else if ((!StartsWith(Content, "method")) && (!StartsWith(Content, "class")) && (StartsWith(Content, "nest-")))
		{
			Content = SplitAfter(Content,'-');
			LogicContent = LogicContent + GenCode(Tabs+"\t",Content);
		}
		Content = SplitAfter(Content,' ');
	}

	if (TheKindType == "if")
	{
		Complete = Tabs+"if ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+LogicContent+Tabs+"}\n";
	}
	else if (TheKindType == "else-if")
	{
		Complete = Tabs+"else if ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+LogicContent+Tabs+"}\n";
	}
	else if (TheKindType == "else")
	{
		Complete = Tabs+"else\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+LogicContent+Tabs+"}\n";

	}
	else if (TheKindType == "switch-case")
	{
		Complete = Tabs+"\tcase x:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;";

	}
	else if (StartsWith(TheKindType, "switch"))
	{
		String CaseContent = TheKindType;
		String CaseVal;

		Complete = Tabs+"switch ("+TheCondition+")\n"+Tabs+"{\n\n";
		while (CaseContent != "")
		{
			CaseVal = SplitBefore(CaseContent,'-');
			if (CaseVal != "switch")
			{
				Complete = Complete+Tabs+"\tcase "+CaseVal+":\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n";
			}
			CaseContent = SplitAfter(CaseContent,'-');
		}
		Complete = Complete+Tabs+"\tdefault:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n"+Tabs+"}\n";
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
	else if (StartsWith(Args[0], "var"))
	{
		TheCode = Variables(Tabs,Args[0]);
		TheCode = TheCode + GenCode(Tabs,Args[1]);
	}
/*
	else if (StartsWith(Args[0], "condition"))
	{
		TheCode = Conditions(Args[0]);
	}
	else if (StartsWith(Args[0], "params"))
	{
		TheCode = Parameters(Args[0]);
	}
*/
	return TheCode;
}

//C++ Main
int main()
{
	banner();
	String UserIn = "";
	String Content = "";
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
		else if (StartsWith(UserIn, "help"))
		{
			Help(UserIn);
		}
		else
		{
			Content = GenCode("",UserIn);
			if (Content != "")
			{
				print(Content);
			}
		}
	}
	return 0;
}
