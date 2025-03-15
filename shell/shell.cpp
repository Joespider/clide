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

String Version = "0.0.65";

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
String BeforeSplit(String Str, char splitAt);
String AfterSplit(String Str, char splitAt);
std::vector<String> split(String message, String by, int at);
std::vector<String> split(String message, char by);
String join(std::vector<String> Str, String ToJoin);
String replaceAll(String message, String sBy, String jBy);


String Struct(String TheName, String Content);
String Class(String TheName, String Content);
String Method(String Tabs, String Name, String Content);
String GenCode(String Tabs,String GetMe);
String Variables(String Tabs, String TheKindType, String Content);
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
	Type = AfterSplit(Type,':');
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
		print(Type+":<name>-<type> param:<params>,<param> var:<name>-type stmt:<name>-<type>");
		print(Type+":<name>-<type> param:<params>,<param> method-var:<name>-type method-stmt:<name>-<type>");
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
		print(Type+":name-std::string=\"\" var:point-int=0 stmt:endline var:james-std::string=\"James\" stmt:endline var:help-int");
	}
	else if (Type == "stmt")
	{
		print(Type+":<type>");
		print(Type+":method\t\tcall a method");
		print(Type+":endline\t\tPlace the \";\" at the end of the statement");
		print(Type+":newline\t\tPlace and empty line");
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
		print("method-<type>\t:\t\"assigne the next element to method content only\"");
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

String BeforeSplit(String Str, char splitAt)
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

String AfterSplit(String Str, char splitAt)
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



/*
	----[shell]----
*/


/*
	----[Notes: Start]----
	Ok, here are just some thoughts I have about the direction of shell code in general
	*) classes (class:) should only be able to call variables (var:) and methods (method:) but cannot call anything else
	*) methods (method:) cannot call classes (class:) or methods (method:), but can call everything else
	*) logic and loops are can only call themselves, but no data structures (class: method: struct: etc.).
		--) nested loops and logic are called with "nest-" prepended (nest-logic: or nest-loop:)
	*) variables (var:) and statements (stmt:) can be called by anything
	*) code is generated left to right, where left is the base struture and right is the content. However, while "nest-" tells the code
	to put a logic/loop statement inside a logic/loop statement, it does no account for variables or statements. Alternative, the placement
	of statements/variables, could be identified with a prepended decloration.

EX: method:<name> logic:if logic-var:time-int= logic-stmt:method-start nest-logic:if nest-logic-stmt:method-end nest-logic:else nest-logic-stmt:method-reset nest-loop:for nest-loop-stmt:method-count

	method:<name>
		logic:if
			logic-var:time-int= logic-stmt:method-start
			nest-logic:if nest-logic-stmt:method-end
			nest-logic:else nest-logic-stmt:method-reset
			nest-loop:for nest-loop-stmt:method-count
	{OR}

EX:  method:<name> method-var:length method-stmt:method-help logic:if logic-var:time-int= logic-stmt:method-start nest-logic:if nest-logic-stmt:method-end nest-logic:else nest-logic-stmt:method-reset nest-loop:for nest-loop-stmt:method-count method-stmt:done

	method:<name>
		method-var:length method-stmt:method-help					<<becomes>>	var:length stmt:method-help
		logic:if logic-var:time-int= logic-stmt:method-start				<<becomes>>	logic:if var:time-int= stmt:method-start
			nest-logic:if nest-logic-stmt:method-end				<<becomes>>	logic:if stmt:method-end
			nest-logic:else nest-logic-stmt:method-reset				<<becomes>>	logic:else stmt:method-reset
			nest-loop:for nest-loop-stmt:method-count				<<becomes>>	loop:for stmt:method-count
		method-stmt:done								<<becomes>>	stmt:done
	{And}
	method:<name> method-var:length method-stmt:method-help {Code} method-stmt:done		<<becomes>>	method:<name> var:length stmt:method-help {Code} stmt:done

	*) I need to work on the user experience in order to better code how this tool works. Other than that, I am happy with the direction of this tool
	----[Notes: End]----
*/


String ReplaceTag(String Content, String Tag)
{
	//Parse Content as long as there is a Tag found at the beginning
	if (StartsWith(Content, Tag))
	{
		//removing tag
		Content = AfterSplit(Content,'-');
	}
	return Content;
}

void banner()
{
	String cplV = getCplV();
	String theOS = getOS();
	print(cplV);
	print("[C++ " << Version<< "] on " << theOS);
	print("Type \"help\" for more information.");
}

/*
<<shell>> method:DataType-String logic:if condition:Type|==|"String" var:dtType-std::string stmt:endline stmt:newline
*/

String Struct(String TheName, String Content)
{
	String Complete = "";
	String StructVar = "";
	String Process = "";
	TheName = AfterSplit(TheName,':');
	while (StartsWith(Content, "var"))
	{
		Process = BeforeSplit(Content,' ');
		Content = AfterSplit(Content,' ');
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
		PublicOrPrivate = AfterSplit(TheName,"(");
		PublicOrPrivate = BeforeSplit(PublicOrPrivate,")");
	}
*/
	TheName = AfterSplit(TheName,':');
	String Process = "";
	String Params = "";
	String ClassContent = "";
	while (Content != "")
	{
		if ((StartsWith(Content, "params")) && (Params == ""))
		{
			Process = BeforeSplit(Content,' ');
			Params =  Parameters(Process,"class");
		}
		else if (StartsWith(Content, "method:"))
		{
			ClassContent = ClassContent + GenCode("\t",Content);
		}
		else if (StartsWith(Content, "var"))
		{
			if (StartsWith(Content, "var(public)"))
			{
				Content = AfterSplit(Content,')');
				VarContent = BeforeSplit(Content,' ');
				VarContent = "var"+VarContent;
				PublicVars = PublicVars + GenCode("\t",VarContent);
			}
			else if (StartsWith(Content, "var(private)"))
			{
				Content = AfterSplit(Content,')');
				VarContent = BeforeSplit(Content,' ');
				VarContent = "var"+VarContent;
				PrivateVars = PrivateVars  + GenCode("\t",VarContent);
			}
		}

		if (IsIn(Content," "))
		{
			Content = AfterSplit(Content,' ');
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

//method:
String Method(String Tabs, String Name, String Content)
{
	bool Last = false;
	bool CanSplit = true;
	String Complete = "";
	Name = AfterSplit(Name,':');
	String TheName = "";
	String Type = "";
	String Params = "";
	String MethodContent = "";
	String OtherContent = "";
	String NewContent = "";
	String Process = "";

	//method:<name>-<type>
	if (IsIn(Name,"-"))
	{
		//get method name
		TheName = BeforeSplit(Name,'-');
		Type = AfterSplit(Name,'-');
	}
	//method:<name>
	else
	{
		//get method name
		TheName = Name;
	}

	while (Content != "")
	{
		if ((StartsWith(Content, "params")) && (Params == ""))
		{
			if (IsIn(Content," "))
			{
				Process = BeforeSplit(Content,' ');
			}
			else
			{
				Process = Content;
			}
			Params =  Parameters(Process,"method");
		}
		//ignore content if calling a "method" or a "class"
		else if ((StartsWith(Content, "method:")) || (StartsWith(Content, "class:")))
		{
			break;
		}
		else
		{
			//This is called when a called from the "class" method
			// EX: class:name method:first method:second
			if (IsIn(Content," method:"))
			{
				//Only account for the first method content
				std::vector<String> cmds = split(Content," method:");
				Content = cmds[0];
			}

			if (IsIn(Content," method-"))
			{
				std::vector<String> all = split(Content," method-");
				bool noMore = false;
				int end = len(all);
				int lp = 0;
				while (lp != end)
				{
					if (lp == 0)
					{
						OtherContent = all[lp];
					}
					else if (lp == 1)
					{
						NewContent = all[lp];
					}
					else
					{
						NewContent = NewContent + " "+all[lp];
					}
					lp++;
				}
//				OtherContent = ReplaceTag(OtherContent, "method-");
				CanSplit = false;
			}
			else
			{
				OtherContent = Content;
				CanSplit = true;
			}
			OtherContent = ReplaceTag(OtherContent, "method-");

			MethodContent = MethodContent + GenCode(Tabs+"\t",OtherContent);
			Content = NewContent;

			OtherContent = "";
			NewContent = "";
		}
		if (Last)
		{
			break;
		}

		if (IsIn(Content," "))
		{
			if (CanSplit)
			{
				Content = AfterSplit(Content,' ');
			}
		}
		else
		{
			Content = "";
			Last = true;
		}
	}

	//build method based on content
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

String Conditions(String input,String CalledBy)
{
	String Condit = AfterSplit(input,':');
	Condit = replaceAll(Condit, "|", " ");
	if (CalledBy == "class")
	{
		print(Condit);
	}
	else if (CalledBy == "method")
	{
		print(Condit);
	}
	else if ((CalledBy == "loop") || (CalledBy == "logic"))
	{
		print(Condit);
	}
	return Condit;
}

//params:
String Parameters(String input,String CalledBy)
{
	String Params = AfterSplit(input,':');
	if ((CalledBy == "class") || (CalledBy == "method") || (CalledBy == "stmt"))
	{
		//param-type,param-type,param-type
		if ((IsIn(Params,"-")) && (IsIn(Params,",")))
		{
			//param
			String Name = BeforeSplit(Params,'-');
			//type,param-type,param-type
			String Type = AfterSplit(Params,'-');
			//type
			Type = BeforeSplit(Type,',');
			//param-type,param-type
			String more = AfterSplit(Params,',');

			//recursion to get more parameters
			more = Parameters("params:"+more,CalledBy);
			//type param, type param, type param
			Params = Type+" "+Name+", "+more;
		}
		//param-type
		else if ((IsIn(Params,"-")) && (!IsIn(Params,",")))
		{
			//param
			String Name = BeforeSplit(Params,'-');
			//type
			String Type = AfterSplit(Params,'-');
			//type param
			Params = Type+" "+Name;
		}
	}
	return Params;
}

//loop:
String Loop(String Tabs, String TheKindType, String Content)
{
	bool Last = false;
	String Complete = "";
	String RootTag = "";
	String TheCondition = "";
	String LoopContent = "";
	String NewContent = "";
	String OtherContent = "";

	//loop:<type>
	if (IsIn(TheKindType,":"))
	{
		//loop
		TheKindType = AfterSplit(TheKindType,':');
	}

	//content for loop
	while (Content != "")
	{
		if (StartsWith(Content, "condition"))
		{
			if (IsIn(Content," "))
			{
				TheCondition = BeforeSplit(Content,' ');
				Content = AfterSplit(Content,' ');
			}
			else
			{
				TheCondition = Content;
			}
			TheCondition = Conditions(TheCondition,TheKindType);
		}

		//nest-<type> <other content>
		//{or}
		//<other content> nest-<type>
		if ((!StartsWith(Content, "nest-")) && (IsIn(Content," nest-")))
		{
			//This section is meant to make sure the recursion is handled correctly
			//The nested loops and logic statements are split accordingly

			//split string wherever a " nest-" is located
			//ALL "nest-" are ignored...notice there is no space before the "nest-"
			std::vector<String> all = split(Content," nest-");
			int end = len(all);
			int lp = 0;
			while (lp != end)
			{
				//This content will be processed as content for loop
				if (lp == 0)
				{
					//nest-<type>
					//{or}
					//<other content>
					OtherContent = all[lp];
				}
				//The remaining content is for the next loop
				//nest-<type> <other content> nest-<type> <other content>
				else if (lp == 1)
				{
					NewContent = "nest-"+all[lp];
				}
				else
				{
					NewContent = NewContent + " nest-"+all[lp];
				}
				lp++;
			}
			//Generate the loop content
			LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent);
			//The remaning content gets processed
			Content = NewContent;
			//reset old and new content
			OtherContent = "";
			NewContent = "";
		}

		//stop recursive loop if the next element is a "method" or a "class"
		if ((StartsWith(Content, "method:")) || (StartsWith(Content, "class:")))
		{
			break;
		}
		//nest-<type>
		else if (StartsWith(Content, "nest-"))
		{
			//"nest-loop" becomes ["nest-", "oop"]
			//{or}
			//"nest-logic" becomes ["nest-", "ogic"]
			RootTag = BeforeSplit(Content,'l');
			//check of " nest-l" is in content
			if (IsIn(Content," "+RootTag+"l"))
			{
				//This section is meant to separate the "nest-loop" from the "nest-logic"
				//loops won't process logic and vise versa

				//split string wherever a " nest-l" is located
				//ALL "nest-l" are ignored...notice there is no space before the "nest-l"
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
							NewContent = RootTag+"l"+cmds[lp];
						}
						else
						{
							NewContent = NewContent+" "+RootTag+"l"+cmds[lp];
						}
					}
					lp++;
				}
			}

			//no " nest-l" found
			else
			{
				OtherContent = Content;
			}

			Content = NewContent;

			//"nest-loop" and "nest-nest-loop" becomes "loop"
			while (StartsWith(OtherContent, "nest-"))
			{
				OtherContent = AfterSplit(OtherContent,'-');
			}

			LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent);
			//nest-stmt: or nest-var:
			if (StartsWith(OtherContent, "stmt:") || (StartsWith(OtherContent, "var:")))
			{
				/*
				This code works, however, it does mean that parent recursion
				does not have any content. Only nested statements give content to
				*/
				OtherContent = "";
				Content = "";
			}

			NewContent = "";
		}

		//no nested content
		else
		{
//			LoopContent = LoopContent + GenCode(Tabs+"\t",Content);
			Content = "";
		}

		//no content left to process
		if (Last)
		{
			break;
		}

		//one last thing to process
		if (!IsIn(Content," "))
		{
			//kill after one more loop
			Last = true;
		}
	}

	//loop:for
	if (TheKindType == "for")
	{
		Complete = Tabs+"for ("+TheCondition+")\n"+Tabs+"{\n"+LoopContent+Tabs+"}\n";
	}
	//loop:do/while
	else if (TheKindType == "do/while")
	{
		Complete = Tabs+"do\n"+Tabs+"{\n"+LoopContent+Tabs+"}\n"+Tabs+"while ("+TheCondition+");\n";
	}
	//loop:while
	else
	{
		Complete = Tabs+"while ("+TheCondition+")\n"+Tabs+"{\n"+LoopContent+Tabs+"}\n";
	}
	return Complete;
}

//logic:
String Logic(String Tabs, String TheKindType, String Content)
{
	bool Last = false;
//	bool CanSplit = true;
	String Complete = "";
	String RootTag = "";
	String TheCondition = "";
	String LogicContent = "";
	String NewContent = "";
	String OtherContent = "";

	if (IsIn(TheKindType,":"))
	{
		TheKindType = AfterSplit(TheKindType,':');
	}
	while (Content != "")
	{
		if (StartsWith(Content, "condition"))
		{
			if (IsIn(Content," "))
			{
				TheCondition = BeforeSplit(Content,' ');
				Content = AfterSplit(Content,' ');
			}
			else
			{
				TheCondition = Content;
			}
			TheCondition = Conditions(TheCondition,TheKindType);
		}

		//This part of the code is meant to separate the nested content with the current content
		if ((!StartsWith(Content, "nest-")) && (IsIn(Content," nest-")))
		{
			std::vector<String> all = split(Content," nest-");
			int end = len(all);
			int lp = 0;
			while (lp != end)
			{
				if (lp == 0)
				{
					OtherContent = all[lp];
				}
				else if (lp == 1)
				{
					NewContent = "nest-"+all[lp];
				}
				else
				{
					NewContent = NewContent + " nest-"+all[lp];
				}
				lp++;
			}
			//Process the current content so as to keep from redoing said content
			LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent);
			Content = NewContent;
			OtherContent = "";
			NewContent = "";
		}

		if ((StartsWith(Content, "method:")) || (StartsWith(Content, "class:")))
		{
			break;
		}
		//This is to handle nested loops and logic
		else if (StartsWith(Content, "nest-"))
		{
			RootTag = BeforeSplit(Content,'l');
			if (IsIn(Content," "+RootTag+"l"))
			{
				//split up the loops and logic accordingly
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
							NewContent = RootTag+"l"+cmds[lp];
						}
						else
						{
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

			while (StartsWith(OtherContent, "nest-"))
			{
				OtherContent = AfterSplit(OtherContent,'-');
			}

			LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent);
			//nest-stmt: or nest-var:
			if (StartsWith(OtherContent, "stmt:") || (StartsWith(OtherContent, "var:")))
			{
				/*
				This code works, however, it does mean that parent recursion
				does not have any content. Only nested statements give content to
				*/
				OtherContent = "";
				Content = "";
			}

			NewContent = "";
		}
		else
		{
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
		Complete = Tabs+"if ("+TheCondition+")\n"+Tabs+"{\n"+LogicContent+Tabs+"}\n";
	}
	else if (TheKindType == "else-if")
	{
		Complete = Tabs+"else if ("+TheCondition+")\n"+Tabs+"{\n"+LogicContent+Tabs+"}\n";
	}
	else if (TheKindType == "else")
	{
		Complete = Tabs+"else\n"+Tabs+"{\n"+LogicContent+Tabs+"}\n";

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
			CaseVal = BeforeSplit(CaseContent,'-');
			if (CaseVal != "switch")
			{
				Complete = Complete+Tabs+"\tcase "+CaseVal+":\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n";
			}

			if (IsIn(CaseContent,"-"))
			{
				CaseContent = AfterSplit(CaseContent,'-');
			}
		}
		Complete = Complete+Tabs+"\tdefault:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n"+Tabs+"}\n";
	}
	return Complete;
}

//stmt:
String Statements(String Tabs, String TheKindType, String Content)
{
	bool Last = false;
	String Complete = "";
	String StatementContent = "";
	String OtherContent = "";
	String TheName = "";
	String Name = "";
	String Process = "";
	String Params = "";

	if (IsIn(TheKindType,":"))
	{
		TheKindType = AfterSplit(TheKindType,':');
	}
	if (IsIn(TheKindType,"-"))
	{
		TheName = BeforeSplit(TheKindType,'-');
		Name = AfterSplit(TheKindType,'-');
	}
	else
	{
		TheName = TheKindType;
	}

	while (Content != "")
	{
		//This handles the parameters of the statements
		if ((StartsWith(Content, "params")) && (Params == ""))
		{
			if (IsIn(Content," "))
			{
				Process = BeforeSplit(Content,' ');
			}
			else
			{
				Process = Content;
			}
			Params =  Parameters(Process,"stmt");
		}

		if (Last)
		{
			break;
		}

		while (StartsWith(Content, "nest-"))
		{
			Content = AfterSplit(Content,'-');
		}

		if (!IsIn(Content," "))
		{
			StatementContent = StatementContent + GenCode(Tabs,Content);
			Last = true;
		}
		else
		{
			OtherContent = BeforeSplit(Content,' ');
			StatementContent = StatementContent + GenCode(Tabs,OtherContent);
			Content = AfterSplit(Content,' ');
		}
	}

	if (TheName == "method")
	{
		Complete = Name+"("+Params+")"+StatementContent;
	}
	else if (TheName == "comment")
	{
		Complete = StatementContent+Tabs+"#Code goes here\n";
	}
	else if (TheName == "endline")
	{
		Complete = StatementContent+";\n";
	}
	else if (TheName == "newline")
	{
		Complete = StatementContent+"\n";
	}

	return Complete;
}

//var:
String Variables(String Tabs, String TheKindType, String Content)
{
	bool Last = false;
	String NewVar = "";
	String Type = "";
	String Name = "";
	String VarType = "";
	String Value = "";
	String VariableContent = "";
	String OtherContent = "";

	while (Content != "")
	{
		if (StartsWith(Content, "params"))
		{
			OtherContent = OtherContent+" "+BeforeSplit(Content,' ');
			Content = AfterSplit(Content,' ');
		}

		if (Last)
		{
			break;
		}

		while (StartsWith(Content, "nest-"))
		{
			Content = AfterSplit(Content,'-');
		}

//		print(OtherContent);
		if (!IsIn(Content," "))
		{
			VariableContent = VariableContent + GenCode(Tabs,Content);
			Last = true;
		}
		else
		{
			OtherContent = BeforeSplit(Content,' ');
			VariableContent = VariableContent + GenCode(Tabs,OtherContent);
			Content = AfterSplit(Content,' ');
		}
	}
	//var:name-dataType=Value
	if ((IsIn(TheKindType,":")) && (IsIn(TheKindType,"-")) && (IsIn(TheKindType,"=")) && (!EndsWith(TheKindType, "=")))
	{
		Type = AfterSplit(TheKindType,':');
		Name = BeforeSplit(Type,'-');
		VarType = AfterSplit(Type,'-');
		Value = AfterSplit(VarType,'=');
		VarType = BeforeSplit(VarType,'=');
		NewVar = Tabs+VarType+" "+Name+" = "+Value;
		NewVar = NewVar+VariableContent;
	}
	//var:name=Value
	else if ((IsIn(TheKindType,":")) && (!IsIn(TheKindType,"-")) && (IsIn(TheKindType,"=")) && (!EndsWith(TheKindType, "=")))
	{
		Type = AfterSplit(TheKindType,':');
		Name = BeforeSplit(Type,'=');
		Value = AfterSplit(Type,'=');
		NewVar = Tabs+Name+" = "+Value;
		NewVar = NewVar+VariableContent;
	}
	//var:name-dataType=
	else if ((IsIn(TheKindType,":")) && (IsIn(TheKindType,"-")) && (EndsWith(TheKindType, "=")))
	{
		Type = AfterSplit(TheKindType,':');
		Name = BeforeSplit(Type,'-');
		VarType = AfterSplit(Type,'-');
		VarType = BeforeSplit(VarType,'=');
		NewVar = Tabs+VarType+" "+Name+" = ";
		NewVar = NewVar+VariableContent;
	}
	//var:name=
	else if ((IsIn(TheKindType,":")) && (!IsIn(TheKindType,"-")) && (EndsWith(TheKindType, "=")))
	{
		Type = AfterSplit(TheKindType,':');
		Name = BeforeSplit(Type,'=');
		Value = AfterSplit(Type,'=');
		NewVar = Tabs+Name+" = ";
		NewVar = NewVar+VariableContent;
	}
	//var:name-dataType
	else if ((IsIn(TheKindType,":")) && (IsIn(TheKindType,"-")) && (!IsIn(TheKindType,"=")))
	{
		Type = AfterSplit(TheKindType,':');
		Name = BeforeSplit(Type,'-');
		VarType = AfterSplit(Type,'-');
		NewVar = Tabs+VarType+" "+Name;
		NewVar = NewVar+VariableContent;
	}
	return NewVar;
}

String GenCode(String Tabs,String GetMe)
{
	String TheCode = "";
	String Args[2];

	if (IsIn(GetMe," "))
	{
		Args[0] = BeforeSplit(GetMe,' ');
		Args[1] = AfterSplit(GetMe,' ');
	}
	else
	{
		Args[0] = GetMe;
		Args[1] = "";
	}

	if (StartsWith(Args[0], "class:"))
	{
		TheCode = Class(Args[0],Args[1]);
	}
	else if (StartsWith(Args[0], "struct:"))
	{
		TheCode = Struct(Args[0],Args[1]);
	}
	else if (StartsWith(Args[0], "method:"))
	{
		TheCode = Method(Tabs,Args[0],Args[1]);
	}
	else if (StartsWith(Args[0], "loop:"))
	{
		TheCode = Loop(Tabs,Args[0],Args[1]);
	}
	else if (StartsWith(Args[0], "logic:"))
	{
		TheCode = Logic(Tabs,Args[0],Args[1]);
	}
	else if (StartsWith(Args[0], "var:"))
	{
		TheCode = Variables(Tabs, Args[0], Args[1]);
	}
	else if (StartsWith(Args[0], "stmt:"))
	{
		TheCode = Statements(Tabs, Args[0], Args[1]);
	}
/*
	else if (StartsWith(Args[0], "condition"))
	{
		TheCode = Conditions(Args[0], Args[1]);
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
