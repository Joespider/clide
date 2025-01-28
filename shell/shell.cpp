#include <iostream>
#include <string>
//#include <unistd.h>
//#include <stdexcept>
#include <stdio.h>
#include <sstream>
#include <vector>

//#define PressEnter std::cout << "Press \"Enter\" to Continue "; std::cin.get()

//print Macro for cout
#define print(x); std::cout << x << std::endl

//error Macro for cerr
#define error(x); std::cerr << x << std::endl

//Convert std::string to String
#define String std::string

String Version = "0.0.46";

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
std::vector<String> split(String message, String by, int at);
std::vector<String> split(String message, char by);
String join(std::vector<String> Str, String ToJoin);
String replaceAll(String message, String sBy, String jBy);


String Struct(String TheName, String Content);
String Class(String TheName, String Content);
String Method(String Tabs, String Name, String Content);
String GenCode(String Tabs,String GetMe);
String Variables(String Tabs, String Content);
String Conditions(String input,String CalledBy);
String Statements(String Tabs, String TheKindType, String Content);
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
		print(Type+":<name> param:<params>,<param> var(public/private):<vars> method:<name>-<type> param:<params>,<param>");
		print("");
		print("{EXAMPLE}");
		print(Type+":pizza params:one-int,two-bool,three-float var(private):toppings-int method:cheese-std::string params:four-int,five-int loop:for nest-loop:for");
	}
	else if (Type == "struct")
	{
		print(Type+":<name>-<type> var:<var> var:<var>");
		print("");
		print("{EXAMPLE}");
		print(Type+":pizza var:topping-std::string var:number-int");
	}
	else if (Type == "method")
	{
		print(Type+"(public/private):<name>-<type> param:<params>,<param>");
		print(Type+":<name>-<type> param:<params>,<param>");
	}
	else if (Type == "loop")
	{
		print(Type+":<type>");
		print("");
		print("{EXAMPLE}");
		print(Type+":for");
		print(Type+":do/while");
		print(Type+":while");

	}
	else if (Type == "logic")
	{
		print(Type+":<type>");
		print("");
		print("{EXAMPLE}");
		print(Type+":if");
		print(Type+":else-if");
		print(Type+":switch");
	}
	else if (Type == "var")
	{
		print(Type+"(public/private):<name>-<type>=value\tcreate a new variable");
		print(Type+":<name>-<type>[<num>]=value\tcreate a new variable as an array");
		print(Type+":<name>-<type>(<struct>)=value\tcreate a new variable a data structure");
		print(Type+":<name>=value\tassign a new value to an existing variable");
		print("");
		print("{EXAMPLE}");
		print(Type+":name-std::string[3]");
		print(Type+":name-std::string(vector)");
		print(Type+":name-std::string=\"\" var:point-int=0 var:james-std::string=\"James\" var:help-int");
	}
	else if (Type == "stmt")
	{
		print(Type+":<type>");
		print(Type+":endline\t\tPlace the \";\" at the end of the statement");
		print(Type+":method-<name>\tcall a method and the name of the method");
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
		print("stmt\t\t:\t\"Create a statment\"");
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
	if (cplV == "")
	{
		cplV = shell("clang++ --version 2> /dev/null | head -n 1 | tr -d '\n'");
	}
	else
	{
		cplV = shell("g++ --version 2> /dev/null | head -n 1 | tr -d '\n'");
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
	int end = Str.length();
	if (end != 0)
	{
		std::size_t pos = Str.find(splitAt);
		if (pos != String::npos)
		{
			newString = Str.substr(0,pos);
		}
	}
	return newString;
}

String SplitAfter(String Str, char splitAt)
{
	String newString;
	int end = Str.length();
	if (end != 0)
	{
		std::size_t pos = Str.find(splitAt);
		if (pos != String::npos)
		{
			newString = Str.substr(pos + 1);
		}
	}
	return newString;
}

std::vector<String> split(String message, String by, int at=0)
{
	std::vector <String> vArray;
	String sub;
	int offset = by.length();
	std::size_t pos = message.find(by);
	if (at >= 1)
	{
		for (int off = 1; off != at; off++)
		{
			pos = message.find(by,pos+off);
		}
		sub = message.substr(0,pos);
		vArray.push_back(sub);
		sub = message.substr(pos + offset);
		vArray.push_back(sub);
	}
	else
	{
		while (pos != String::npos)
		{
			sub = message.substr(0,pos);
			vArray.push_back(sub);
			message = message.substr(pos+offset);
			pos = message.find(by);
		}
		vArray.push_back(message);
	}
	return vArray;
}

std::vector<String> split(String message, char by)
{
	std::vector<String> vArray;
	std::stringstream ss(message);
	String item;
	while (std::getline(ss,item,by))
	{
		vArray.push_back(item);
	}
	return vArray;
}

String join(std::vector<String> Str, String ToJoin)
{
	String NewString;
	int end;
	end = Str.size();
	NewString = Str[0];

	for (int lp = 1; lp < end; lp++)
	{
		NewString = NewString + ToJoin + Str[lp];
	}
	return NewString;
}

String replaceAll(String message, String sBy, String jBy)
{
	std::vector<String> SplitMessage = split(message,sBy);
	message = join(SplitMessage,jBy);
	return message;
}






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
	String Process = "";
	TheName = SplitAfter(TheName,':');
	while (StartsWith(Content, "var"))
	{
		Process = SplitBefore(Content,' ');
		Content = SplitAfter(Content,' ');
		StructVar = StructVar + GenCode("\t",Process);
	}
	Complete = "struct {\n"+StructVar+"\n} "+TheName+";\n";
	return Complete;
}

String Class(String TheName, String Content)
{
	String Complete = "";
	String PrivateVars = "";
	String PublicVars = "";
	String VarContent = "";
/*
	String PublicOrPrivate = "";
	if (StartsWith(TheName,"class("))
	if (IsIn(TheName,")"))
	{
		PublicOrPrivate = SplitAfter(TheName,"(");
		PublicOrPrivate = SplitBefore(PublicOrPrivate,")");
	}
*/
	TheName = SplitAfter(TheName,':');
	String Process = "";
	String Params = "";
	String ClassContent = "";
	while (Content != "")
	{
		if ((StartsWith(Content, "params")) && (Params == ""))
		{
			Process = SplitBefore(Content,' ');
//			Params =  Parameters(Content,"class");
			Params =  Parameters(Process,"class");
		}
		else if (StartsWith(Content, "method"))
		{
			ClassContent = ClassContent + GenCode("\t",Content);
		}
		else if (StartsWith(Content, "var"))
		{
			if (StartsWith(Content, "var(public)"))
			{
				Content = SplitAfter(Content,')');
				VarContent = SplitBefore(Content,' ');
				VarContent = "var"+VarContent;
				PublicVars = PublicVars + GenCode("\t",VarContent);
			}
			else if (StartsWith(Content, "var(private)"))
			{
				Content = SplitAfter(Content,')');
				VarContent = SplitBefore(Content,' ');
				VarContent = "var"+VarContent;
				PrivateVars = PrivateVars  + GenCode("\t",VarContent);
			}
		}

		if (IsIn(Content," "))
		{
			Content = SplitAfter(Content,' ');
		}
		else
		{
			break;
		}
	}

	if (PrivateVars != "")
	{
		PrivateVars = "private:\n\t//private variables\n"+PrivateVars+"\n";
	}
	if (PublicVars != "")
	{
		PublicVars = "\n\t//public variables\n"+PublicVars;
	}

	Complete = "class "+TheName+" {\n\n"+PrivateVars+"public:"+PublicVars+"\n\t//class constructor\n\t"+TheName+"("+Params+")\n\t{\n\t\tthis->x = x;\n\t\tthis->y = y;\n\t}\n\n"+ClassContent+"\n\t//class desctructor\n\t~"+TheName+"()\n\t{\n\t}\n};\n";
	return Complete;
}

String Method(String Tabs, String Name, String Content)
{
	String Complete = "";
	Name = SplitAfter(Name,':');
	String TheName = "";
	String Type = "";
	String Params = "";
	String MethodContent = "";
	String LastComp = "";
	String Process = "";

	if (IsIn(Name,"-"))
	{
		TheName = SplitBefore(Name,'-');
		Type = SplitAfter(Name,'-');
	}
	else
	{
		TheName = Name;
	}

	while (Content != "")
	{
		if ((StartsWith(Content, "params")) && (Params == ""))
		{
			if (IsIn(Content," "))
			{
				Process = SplitBefore(Content,' ');
			}
			else
			{
				Process = Content;
			}
//			Params =  Parameters(Content,"method");
			Params =  Parameters(Process,"method");
		}
		else if ((StartsWith(Content, "method")) || (StartsWith(Content, "class")))
		{
			break;
		}
		else
		{
			if (IsIn(Content," method"))
			{
				std::vector<String> cmds = split(Content," method");
				Content = cmds[0];
			}
			MethodContent = MethodContent + GenCode(Tabs+"\t",Content);
		}

		if (IsIn(Content," "))
		{
			Content = SplitAfter(Content,' ');
		}
		else
		{
			break;
		}
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

String Variables(String Tabs, String Content)
{
	String NewVar = "";
	String Type = "";
	String Name = "";
	String VarType = "";
	String Value = "";
/*
	String VariableContent = "";

	while (Content != "")
	{
		print(Content);
*/
		if ((IsIn(Content,":")) && (IsIn(Content,"-")) && (IsIn(Content,"=")) && (!EndsWith(Content, "=")))
		{
			print("Nothing");
			Type = SplitAfter(Content,':');
			Name = SplitBefore(Type,'-');
			VarType = SplitAfter(Type,'-');
			Value = SplitAfter(VarType,'=');
			VarType = SplitBefore(VarType,'=');
		}
		else if ((IsIn(Content,":")) && (IsIn(Content,"-")) && (IsIn(Content,"=")) && (EndsWith(Content, "=")))
		{
			Type = SplitAfter(Content,':');
			Name = SplitBefore(Type,'-');
			VarType = SplitAfter(Type,'-');
			VarType = SplitBefore(VarType,'=');
			NewVar = Tabs+VarType+" "+Name+" = ";
		}
		else if ((IsIn(Content,":")) && (!IsIn(Content,"-")) && (IsIn(Content,"=")))
		{
			print("Nothing");
			Type = SplitAfter(Content,':');
			Name = SplitBefore(Type,'=');
			Value = SplitAfter(Type,'=');
		}
		else if ((IsIn(Content,":")) && (IsIn(Content,"-")) && (!IsIn(Content,"=")))
		{
			Type = SplitAfter(Content,':');
			Name = SplitBefore(Type,'-');
			VarType = SplitAfter(Type,'-');
			NewVar = Tabs+VarType+" "+Name;
		}
/*
		if (IsIn(Content," "))
		{
			Content = SplitAfter(Content,' ');
		}
		else
		{
			break;
		}
		VariableContent = VariableContent + GenCode(Tabs,Content);
	}
*/
	return NewVar;
}

String Statements(String Tabs, String TheKindType, String Content)
{
	bool Last = false;
	String Complete = "";
	String StatementContent = "";
	String TheName = "";
	String Name = "";
	String Process = "";
	String Params = "";

	if (IsIn(TheKindType,":"))
	{
		TheKindType = SplitAfter(TheKindType,':');
	}
	if (IsIn(TheKindType,"-"))
	{
		TheName = SplitBefore(TheKindType,'-');
		Name = SplitAfter(TheKindType,'-');
	}
	else
	{
		TheName = TheKindType;
	}

	while (Content != "")
	{
		if ((StartsWith(Content, "params")) && (Params == ""))
		{
			if (IsIn(Content," "))
			{
				Process = SplitBefore(Content,' ');
			}
			else
			{
				Process = Content;
			}
//			Params =  Parameters(Content,"method");
			Params =  Parameters(Process,"method");
		}

		if (IsIn(Content," "))
		{
			Content = SplitAfter(Content,' ');
		}
		else
		{
			break;
		}
		StatementContent = StatementContent + GenCode(Tabs,Content);
	}

	if (TheName == "method")
	{
		Complete = Name+"("+Params+")"+StatementContent;
	}
	else if (TheName == "newline")
	{
		Complete = StatementContent+";\n";
	}

	return Complete;
}

String Conditions(String input,String CalledBy)
{
	String Condit = SplitAfter(input,':');
	Condit = replaceAll(Condit, "|", " ");
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

//loop:
String Loop(String Tabs, String TheKindType, String Content)
{
	bool Last = false;
//	String NestTabs = "";
	String Complete = "";
	String TheName = "";
	String RootTag = "";
	String Type = "";
	String TheCondition = "";
	String LoopContent = "";
	String NewContent = "";
	String OtherContent = "";

	if (IsIn(TheKindType,":"))
	{
		TheKindType = SplitAfter(TheKindType,':');
	}

	if (IsIn(TheKindType,"-"))
	{
		TheName = SplitBefore(TheKindType,'-');
		Type = SplitAfter(TheKindType,'-');
	}

	while (Content != "")
	{
//		print(Content);
//		NestTabs = "";
		if (StartsWith(Content, "condition"))
		{
			TheCondition = Conditions(Content,TheKindType);
		}
		else if ((StartsWith(Content, "method")) || (StartsWith(Content, "class")))
		{
			break;
		}
		//nest-loop:
		else if (StartsWith(Content, "nest-"))
		{
//	Keep these comments
//			RootTag = SplitBefore(Content,':');
			RootTag = SplitBefore(Content,'l');
//	Keep these comments
//			if (IsIn(Content," "+RootTag+":"))
			if (IsIn(Content," "+RootTag+"l"))
			{
//	Keep these comments
//				std::vector<String> cmds = split(Content," "+RootTag+":");
				std::vector<String> cmds = split(Content," "+RootTag+"l");
				int end = len(cmds);
				int lp = 0;
				while (lp != end)
				{
					if (lp == 0)
					{
						OtherContent = cmds[lp];
					}
					else
					{
						if (NewContent == "")
						{
//	Keep these comments
//							NewContent = RootTag+":"+cmds[lp];
							NewContent = RootTag+"l"+cmds[lp];
						}
						else
						{
//	Keep these comments
//							NewContent = NewContent+" "+RootTag+":"+cmds[lp];
							NewContent = NewContent+" "+RootTag+"l"+cmds[lp];
						}
					}
					lp++;
				}
			}
			else
			{
				OtherContent = Content;
			}

			Content = NewContent;
			NewContent = "";

			while (StartsWith(OtherContent, "nest-"))
			{
//				NestTabs = NestTabs+"\t";
				OtherContent = SplitAfter(OtherContent,'-');
			}
//			LoopContent = LoopContent + GenCode(NestTabs,OtherContent);
			LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent);
		}
		else
		{
			LoopContent = LoopContent + GenCode(Tabs+"\t",Content);
//			Content = SplitAfter(Content,' ');
			Content = "";
		}

		if (Last)
		{
			break;
		}

		if (!IsIn(Content," "))
		{
			Last = true;
		}
	}
	//loop:for
	if (TheKindType == "for")
	{
		Complete = Tabs+"for ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t\n"+LoopContent+"\n"+Tabs+"}\n";
	}
	//loop:do/while
	else if (TheKindType == "do/while")
	{
		Complete = Tabs+"do\n"+Tabs+"{\n"+Tabs+"\t\n"+LoopContent+Tabs+"}\n"+Tabs+"while ("+TheCondition+");\n";
	}
	//loop:while
	else
	{
		Complete = Tabs+"while ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t\n"+LoopContent+Tabs+"}\n";
	}
	return Complete;
}

//logic:
String Logic(String Tabs, String TheKindType, String Content)
{
	bool Last = false;
//	String NestTabs = "";
	String Complete = "";
	String TheName = "";
	String Type = "";
	String RootTag = "";
	String TheCondition = "";
	String LogicContent = "";
	String NewContent = "";
	String OtherContent = "";

	if (IsIn(TheKindType,":"))
	{
		TheKindType = SplitAfter(TheKindType,':');
	}

	if (IsIn(TheKindType,"-"))
	{
		TheName = SplitBefore(TheKindType,'-');
		Type = SplitAfter(TheKindType,'-');
	}

	while (Content != "")
	{
//		NestTabs = "";
		if (StartsWith(Content, "condition"))
		{
			if (IsIn(Content," "))
			{
				TheCondition = SplitBefore(Content,' ');
				Content = SplitAfter(Content,' ');
			}
			else
			{
				TheCondition = Content;
			}
			TheCondition = Conditions(TheCondition,TheKindType);
		}
		else if ((StartsWith(Content, "method")) || (StartsWith(Content, "class")))
		{
			break;
		}
		else if (StartsWith(Content, "nest-"))
		{
//	Keep these comments
//			RootTag = SplitBefore(Content,':');
			RootTag = SplitBefore(Content,'l');
//	Keep these comments
//			if (IsIn(Content," "+RootTag+":"))
			if (IsIn(Content," "+RootTag+"l"))
			{
//	Keep these comments
//				std::vector<String> cmds = split(Content," "+RootTag+":");
				std::vector<String> cmds = split(Content," "+RootTag+"l");
				int end = len(cmds);
				int lp = 0;
				while (lp != end)
				{
					if (lp == 0)
					{
						OtherContent = cmds[lp];
					}
					else
					{
						if (NewContent == "")
						{
//	Keep these comments
//							NewContent = RootTag+":"+cmds[lp];
							NewContent = RootTag+"l"+cmds[lp];
						}
						else
						{
//	Keep these comments
//							NewContent = NewContent+" "+RootTag+":"+cmds[lp];
							NewContent = NewContent+" "+RootTag+"l"+cmds[lp];
						}
					}
					lp++;
				}
			}
			else
			{
				OtherContent = Content;
			}

			Content = NewContent;
			NewContent = "";

			while (StartsWith(OtherContent, "nest-"))
			{
//				NestTabs = NestTabs+"\t";
				OtherContent = SplitAfter(OtherContent,'-');
			}
//			LogicContent = LogicContent + GenCode(NestTabs,OtherContent);
			LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent);
		}
		else
		{
			LogicContent = LogicContent + GenCode(Tabs+"\t",Content);
//			Content = SplitAfter(Content,' ');
			Content = "";
		}

		if (Last)
		{
			break;
		}

		if (!IsIn(Content," "))
		{
			Last = true;
		}
	}

	if (TheKindType == "if")
	{
		Complete = Tabs+"if ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t\n"+LogicContent+Tabs+"}\n";
	}
	else if (TheKindType == "else-if")
	{
		Complete = Tabs+"else if ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t\n"+LogicContent+Tabs+"}\n";
	}
	else if (TheKindType == "else")
	{
		Complete = Tabs+"else\n"+Tabs+"{\n"+Tabs+"\t\n"+LogicContent+Tabs+"}\n";

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

			if (IsIn(CaseContent,"-"))
			{
				CaseContent = SplitAfter(CaseContent,'-');
			}
		}
		Complete = Complete+Tabs+"\tdefault:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n"+Tabs+"}\n";
	}
	return Complete;
}

String GenCode(String Tabs,String GetMe)
{
	String TheCode = "";
	String Args[2];

	if (IsIn(GetMe," "))
	{
		Args[0] = SplitBefore(GetMe,' ');
		Args[1] = SplitAfter(GetMe,' ');
	}
	else
	{
		Args[0] = GetMe;
		Args[1] = "";
	}

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
	else if (StartsWith(Args[0], "stmt"))
	{
		TheCode = Statements(Tabs, Args[0], Args[1]);
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

//C++ Main...with cli arguments
int main(int argc, char** argv)
{
	//Args were NOT given
	if (argc == 1)
	{
		banner();
	}
	String UserIn = "";
	String Content = "";
	while (true)
	{
		//Args were given
		if (argc > 1)
		{
			UserIn = String(argv[1]);
			for (int lp = 2; lp < argc; lp++)
			{
				UserIn = UserIn + " " + String(argv[lp]);
			}
		}
		else
		{
			UserIn = raw_input(">>> ");
		}

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

		//Args were given
		if (argc > 1)
		{
			break;
		}
	}
	return 0;
}
