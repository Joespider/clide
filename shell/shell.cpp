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

String Version = "0.0.94";

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

void banner();
String TranslateTag(String Input);
bool IsDataType(String Type);
String DataType(String Type, bool getNull);
String ReplaceTag(String Content, String Tag, bool All);
String Conditions(String input,String CalledBy);
String Parameters(String input,String CalledBy);
String Struct(String TheName, String Content);
String Class(String TheName, String Content);
String Method(String Tabs, String Name, String Content);
String GenCode(String Tabs,String GetMe);
String Variables(String Tabs, String TheKindType, String Content);
String Statements(String Tabs, String TheKindType, String Content);
String Loop(String Tabs, String TheKindType, String Content);
String Logic(String Tabs, String TheKindType, String Content);
void Example(String tag);

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
	//note to self, need to re-write help page
	Type = AfterSplit(Type,':');
	if (Type == "class")
	{
		print("{Usage}");
		print("{}<name>:(<type>)<name> var(public/private):<vars> method:<name>-<type> param:<params>,<param>");
		print("");
		print("{EXAMPLE}");
		Example("{}pizza:(int)one,(bool)two,(float)three var(private):(int)toppings [String-mixture]cheese:(String)kind,(int)amount for: nest-for: [String]topping:(String)name,(int)amount if:good");
	}
	else if (Type == "struct")
	{
		print("(<type>)<name>");
		print("");
	}
	else if (Type == "method")
	{
		print("[<data>]<name>:<parameters>");
		print("[<data>-<return>]<name>:<parameters>");
		print("");
//		Example("[String]help:(String)one,(int)two");
//		Example("[String-Message]help:(String)one,(int)two");
//		Example("[String-Type]FoodAndDrink:(String)Food if:Food(-ne)\"\" >if:[IsDrink]:drink(-eq)true +->tab +->tab +->tab +->()Type=\"Drink\" +->el +->>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Drink]:Food o->>el +->else-if:[IsFood]:Food(-eq)true +->tab +->tab +->tab +->()Type=\"Food\" +->el >>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Eat]:Food o->>el >else +->tab +->tab +->tab +->()Eat= +->(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el else +-tab +-tab +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el");
//		Example("[String-Type]FoodAndDrink:(String)Food if:Food(-ne)\"\" >if:[IsDrink]:drink(-eq)true +->tab +->tab +->tab +->()Type=\"Drink\" +->el +->>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Drink]:Food o->>el >>if:mood(-ne)\"happy\" >>>do-while:mood(-eq)\"unhappy\" >>>>tab >>>>tab >>>>tab >>>>tab >>>>tab >>>>[ChearUp]:mood >>>>el +->else-if:[IsFood]:Food(-eq)true +->tab +->tab +->tab +->()Type=\"Food\" +->el >>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Eat]:Food o->>el >>if:mood(-ne)\"happy\" >>>do-while:mood(-eq)\"unhappy\" >>>>tab >>>>tab >>>>tab >>>>tab >>>>tab >>>>[ChearUp]:mood >>>>el >else +->tab +->tab +->tab +->(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el else +-tab +-tab +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el");
		Example("[String-Type]FoodAndDrink:(String)Food if:Food(-ne)\"\" >if:[IsDrink]:drink(-eq)true +->tab +->tab +->tab +->()Type=\"Drink\" +->el +->>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Drink]:Food o->>el >>if:mood(-ne)\"happy\" >>>do-while:mood(-eq)\"unhappy\" o->>>>tab o->>>>tab o->>>>tab o->>>>tab o->>>>tab o->>>>[ChearUp]:mood o->>>>el +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->else-if:[IsFood]:Food(-eq)true +->tab +->tab +->tab +->()Type=\"Food\" +->el >>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Eat]:Food o->>el >>if:mood(-ne)\"happy\" >>>do-while:mood(-eq)\"unhappy\" >>>>tab >>>>tab >>>>tab >>>>tab >>>>tab >>>>[ChearUp]:mood >>>>el +-[print]:\"I(-spc)am(-spc)\"+mood +-el >else +->tab +->tab +->tab +->(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el else +-tab +-tab +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el");
//		Example("[String-Type]FoodAndDrink:(String)Food if:Food(-ne)\"\" >if:[IsDrink]:drink(-eq)true >>tab >>tab >>tab >>()Type=\"Food\" >>el >>tab >>tab >>tab >>[Drink]:Food >>el >else-if:[IsFood]:Food(-eq)true +->>tab +->>tab +->>tab +->>()Type=\"Drink\" +->>el >>tab >>tab >>tab >>[Eat]:Food >>el >else +->tab +->tab +->tab +->(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +->el else +-tab +-tab +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el");
	}
	else if (Type == "loop")
	{
		print("<type>:<param>");
		print("");
		print("{EXAMPLE}");
		print("for:");
		print("do-while:");
		print("while");
	}
	else if (Type == "logic")
	{
		print("<logic>:<condition>");
		print("");
		Example("if:Type(-spc)==(-spc)\"String\"");
		Example("else-if:Type(-eq)\"String\"");
		Example("else");
		Example("if:true tab (String)drink= [Pop]:one,two el >if:[IsString]:drink(-eq)true >tab >tab >[drink]: >el >>if:drink(-eq)\"coke\" >>else >nl >else-if:[IsInt]:drink(-eq)false >nl >else >>if: >>nl >>else >nl");
		Example("if:true tab (String)drink= [Pop]:one,two el >if:[IsString]:drink(-eq)true >>if:drink(-eq)\"coke\" >>else >nl >else-if:[IsInt]:drink(-eq)false >nl >else >>if: >>nl >>else >nl");
//		print(Type+":switch");
	}
	else if (Type == "var")
	{
		Example("(std::string)name=\"\" var:(int)point=0 stmt:endline var:james-std::string=\"James\" stmt:endline var:help-int");
		Example("(std::string)name=\"\" el (int)point=0 el (std::string)james=\"James\" el (int)help el help=0");
		Example("(std::string)name=\"\" el (int)point=0 el (std::string)james=\"James\" el (int)help el help=0");
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


String ReplaceTag(String Content, String Tag, bool All)
{
	if ((IsIn(Content," ")) && (StartsWith(Content, Tag)))
	{
		bool remove = true;
		String NewContent = "";
		String Next = "";
		std::vector<String> all = split(Content," ");
		int end = len(all);
		int lp = 0;
		while (lp != end)
		{
			Next = all[lp];
			//element starts with tag
			if (StartsWith(Next, Tag) && (remove == true))
			{
				//remove tag
				Next = AfterSplit(Next,'-');
				if (All)
				{
					remove = false;
				}
			}

			if (NewContent == "")
			{
				NewContent = Next;
			}
			else
			{
				NewContent = NewContent+" "+Next;
			}
			lp++;
		}
		Content = NewContent;
	}
	//Parse Content as long as there is a Tag found at the beginning
	else if ((!IsIn(Content," ")) && (StartsWith(Content, Tag)))
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

//This is an example of handling vecotors and arrays
//	<type>name:value
//
//if value is marked a method, this a vector
//	<int>list:[getInt]:()numbers
//if value is marked a static, this is an array
//	<int>list:()one,()two
//
//to assign a value
//	<list[0]>:4
//to get from value, seeing there is an index
//	<list[0]>:
//to append vectors
//	<list>:4

String TranslateTag(String Input)
{
	String TheReturn = "";
	String Action = Input;
	String Value = "";
	String VarName = "";
	String NewTag = "";
	String TheDataType = "";
	String Nest = "";
	String ContentFor = "";
	String OldDataType = "";

	if (StartsWith(Action, "+-"))
	{
		Action = AfterSplit(Action,'-');
		ContentFor = "logic-";
	}
	else if (StartsWith(Action, "o-"))
	{
		Action = AfterSplit(Action,'-');
		ContentFor = "loop-";
	}
	else if (StartsWith(Action, "[]-"))
	{
		Action = AfterSplit(Action,'-');
		ContentFor = "method-";
	}
	else if (StartsWith(Action, "{}-"))
	{
		Action = AfterSplit(Action,'-');
		ContentFor = "class-";
	}

	// ">" becomes "nest-"
	while (StartsWith(Action, ">"))
	{
		Action = AfterSplit(Action,'>');
		Nest = "nest-"+Nest;
	}

	if ((StartsWith(Action, "if:")) || (StartsWith(Action, "else-if:")))
	{
		Value = AfterSplit(Action,':');
		Action = BeforeSplit(Action,':');
		NewTag = "logic:"+Action;
		Value = "logic-condition:"+Value;
		TheReturn = ContentFor+Nest+NewTag+" "+Value;
	}
	else if (Action == "else")
	{
		NewTag = "logic:"+Action;
		TheReturn = ContentFor+Nest+NewTag;
	}
	else if ((StartsWith(Action, "while:")) || (StartsWith(Action, "for:")) || (StartsWith(Action, "do-while:")))
	{
		Value = AfterSplit(Action,':');
		Action = BeforeSplit(Action,':');
		NewTag = "loop:"+Action;
		Value = "loop-condition:"+Value;
		TheReturn = ContentFor+Nest+NewTag+" "+Value;
	}
	else if ((StartsWith(Action, "{")) && (IsIn(Action,"}")))
	{
		TheDataType = BeforeSplit(Action,'}');
		TheDataType = AfterSplit(TheDataType,'{');
		Action = AfterSplit(Action,'}');
		if (IsIn(Action,":"))
		{
			Value = AfterSplit(Action,':');
			Action = BeforeSplit(Action,':');
		}
		if (Value != "")
		{
			TheReturn = "class:"+Action+" params:"+Value;
		}
		else
		{
			TheReturn = "class:"+Action;
		}
	}
	else if ((StartsWith(Action, "[")) && (IsIn(Action,"]")))
	{
		TheDataType = BeforeSplit(Action,']');
		TheDataType = AfterSplit(TheDataType,'[');
		Action = AfterSplit(Action,']');
		//calling a function
		if (StartsWith(Action, ":"))
		{
			Value = AfterSplit(Action,':');
			Action = TheDataType;
			TheReturn = ContentFor+Nest+"stmt:method-"+Action+" params:"+Value;
		}
		//is a function
		else
		{
			TheDataType = DataType(TheDataType,false);
			if (IsIn(Action,":"))
			{
				Value = AfterSplit(Action,':');
				Action = BeforeSplit(Action,':');
			}

			if (Value != "")
			{
				TheReturn = ContentFor+Nest+"method:("+TheDataType+")"+Action+" params:"+Value;
			}
			else
			{
				TheReturn = ContentFor+Nest+"method:("+TheDataType+")"+Action;
			}
		}
	}
	else if ((StartsWith(Action, "(")) && (IsIn(Action,")")))
	{
		TheDataType = BeforeSplit(Action,')');
		TheDataType = AfterSplit(TheDataType,'(');
		Action = AfterSplit(Action,')');

		if (IsIn(Action,":"))
		{
			Value = AfterSplit(Action,':');
			Action = BeforeSplit(Action,':');
		}

		if (Value != "")
		{
			//translate value, if needed
			Value = TranslateTag(Value);
//			Value = GenCode("",Value);
			TheReturn = ContentFor+Nest+"var:("+TheDataType+")"+Action+"= "+Value;
		}
		else
		{
			TheReturn = ContentFor+Nest+"var:("+TheDataType+")"+Action;
		}
	}
	else if (Action == "el")
	{
		TheReturn = ContentFor+Nest+"stmt:endline";
	}
	else if (Action == "nl")
	{
		TheReturn = ContentFor+Nest+"stmt:newline";
	}
	else if (Action == "tab")
	{
		TheReturn = ContentFor+Nest+"stmt:"+Action;
	}
	else
	{
		if (Value != "")
		{
			TheReturn = ContentFor+Nest+Action+":"+Value;
		}
		else
		{
			TheReturn = ContentFor+Nest+Action;
		}
	}

	return TheReturn;
}

/*
//<<shell>> method:DataType-String params:Type-String if:Type(-eq)"String"(-or)Type(-eq)"string" +-var:TheReturn="std::string" +-stmt:endline else-if:Type(-eq)"boolean" +-var:Type="bool" +-stmt:endline else +-var:TheReturn=Type +-stmt:endline
*/

String DataType(String Type, bool getNull)
{
	//handle strings
	if (((Type == "String") || (Type == "string") || (Type == "std::string")) && (getNull == false))
	{
		return "std::string";
	}
	else if (((Type == "String") || (Type == "string") || (Type == "std::string")) && (getNull == true))
	{
		return "\"\"";
	}
	else if (((Type == "i32") || (Type == "int")) && (getNull == false))
	{
		return "int";
	}
	else if (((Type == "i32") || (Type == "int")) && (getNull == true))
	{
		return "0";
	}
	else if (((Type == "boolean") || (Type == "bool")) && (getNull == false))
	{
		return "bool";
	}
	else if (((Type == "boolean") || (Type == "bool")) && (getNull == true))
	{
		return "false";
	}
	else if ((Type == "false") || (Type == "False"))
	{
		return "false";
	}
	else if ((Type == "true") || (Type == "True"))
	{
		return "true";
	}
	else
	{
		if (getNull == false)
		{
			return Type;
		}
		else
		{
			return "";
		}
	}
}

//condition:
String Conditions(String input,String CalledBy)
{
	String Condit = AfterSplit(input,':');

	if (IsIn(Condit,"(-eq)"))
	{
		Condit = replaceAll(Condit, "(-eq)"," == ");
	}

	if (IsIn(Condit,"(-le)"))
	{
		Condit = replaceAll(Condit, "(-le)"," <= ");
	}

	if (IsIn(Condit,"(-lt)"))
	{
		Condit = replaceAll(Condit, "(-lt)"," < ");
	}

	if (IsIn(Condit,"(-ne)"))
	{
		Condit = replaceAll(Condit, "(-ne)"," != ");
	}

	if (IsIn(Condit,"(-spc)"))
	{
		Condit = replaceAll(Condit, "(-spc)"," ");
	}

	if (IsIn(Condit," "))
	{
		std::vector<String> Conditions = split(Condit,' ');
		int lp = 0;
		int end = len(Conditions);
		String Keep = "";
		while (lp != end)
		{
			Conditions[lp] = TranslateTag(Conditions[lp]);
			Keep = Conditions[lp];
			Conditions[lp] = GenCode("",Conditions[lp]);
			if (Conditions[lp] == "")
			{
				Conditions[lp] = Keep;
			}
			lp++;
		}
		Condit = join(Conditions, " ");
	}
	else
	{
		Condit = DataType(Condit,false);
		String OldCondit = Condit;
		Condit = TranslateTag(Condit);
		Condit = GenCode("",Condit);

		if (Condit == "")
		{
			Condit = OldCondit;
		}
	}

	//logic
	if (IsIn(Condit,"(-not)"))
	{
		Condit = replaceAll(Condit, "(-not)","!");
	}

	if (IsIn(Condit,"(-or)"))
	{
		Condit = replaceAll(Condit, "(-or)",") || (");
		Condit = "("+Condit+")";
	}

	if (IsIn(Condit,"(-and)"))
	{
		Condit = replaceAll(Condit, "(-and)",") && (");
		Condit = "("+Condit+")";
	}

/*
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
*/
	//convert
	return Condit;
}

//params:
String Parameters(String input,String CalledBy)
{
	String Params = AfterSplit(input,':');

	if ((CalledBy == "class") || (CalledBy == "method") || (CalledBy == "stmt"))
	{
		//param-type,param-type,param-type
		if ((StartsWith(Params,"(")) && (IsIn(Params,")")) && (IsIn(Params,",")))
		{
			String Name = BeforeSplit(Params,',');
			String more = AfterSplit(Params,',');
			String Type = BeforeSplit(Name,')');

			Name = AfterSplit(Name,')');
			Type = AfterSplit(Type,'(');
			Type = DataType(Type,false);
			more = Parameters("params:"+more,CalledBy);
			Params = Type+" "+Name+", "+more;
		}
		//param-type
		else if ((StartsWith(Params,"(")) && (IsIn(Params,")")))
		{
			String Name = AfterSplit(Params,')');
			String Type = BeforeSplit(Params,')');

			Type = AfterSplit(Type,'(');
			Type = DataType(Type,false);
			Params = Type+" "+Name;
		}
	}
	return Params;
}

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
		if ((StartsWith(Content, "params:")) && (Params == ""))
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
	String ReturnVar = "TheReturn";
	String DefaultValue = "";
	String Complete = "";
	Name = AfterSplit(Name,':');
	String TheName = "";
	String Type = "";
	String Params = "";
	String MethodContent = "";
	String OtherContent = "";
	String NewContent = "";
	String Process = "";

	//method:(<type>)<name>
	if ((StartsWith(Name,"(")) && (IsIn(Name,")")))
	{
		Type = BeforeSplit(Name,')');
		Type = AfterSplit(Type,'(');
		//get method name
		TheName = AfterSplit(Name,')');
		if (IsIn(Name,"-"))
		{
			ReturnVar = AfterSplit(Type,'-');
			Type = BeforeSplit(Type,'-');
		}
		DefaultValue = DataType(Type,true);

		//Converting data type to correct C++ type
		Type = DataType(Type,false);
	}
	//method:<name>
	else
	{
		//get method name
		TheName = Name;
	}

	while (Content != "")
	{
		//params:
		if ((StartsWith(Content, "params:")) && (Params == ""))
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

			if (StartsWith(Content, "method-"))
			{
				std::vector<String> all = split(Content," ");
				bool noMore = false;
				int lp = 0;
				int end = len(all);
				while (lp != end)
				{
					//This processes ONLY method-<content>
					if ((StartsWith(all[lp], "method-")) && (noMore == false))
					{
						if (OtherContent == "")
						{
							OtherContent = all[lp];
						}
						else
						{
							OtherContent = OtherContent+" "+all[lp];
						}
					}
					else
					{
						if (NewContent == "")
						{
							NewContent = all[lp];
						}
						else
						{
							NewContent = NewContent+" "+all[lp];
						}
						noMore = true;
					}
					lp++;
				}
				CanSplit = false;
			}
/*
			else if ((!StartsWith(Content, "method-")) && (IsIn(Content, "method-")))
			{
				std::vector<String> cmds = split(Content," method-");
				int lp = 0;
				int end = len(cmds);
				while (lp != end)
				{
					print(cmds[lp]);
					lp++;
				}
				OtherContent = Content;
				CanSplit = true;
			}
*/
			else
			{
				OtherContent = Content;
				CanSplit = true;
			}

//			OtherContent = ReplaceTag(OtherContent, "method-");

			String ParseContent = "";
			String Corrected = "";

			std::vector<String> cmds = split(OtherContent," ");
			int end = len(cmds);
			int lp = 0;
			while (lp != end)
			{
				Corrected = ReplaceTag(cmds[lp], "method-",false);
				//starts with "logic:" or "loop:"
				if ((StartsWith(Corrected,"logic:")) || (StartsWith(Corrected,"loop:")) || (StartsWith(Corrected,"var:")) || (StartsWith(Corrected,"stmt:")))
				{
					//Only process code that starts with "logic:" or "loop:"
					if (ParseContent != "")
					{
						//process content
						MethodContent = MethodContent + GenCode(Tabs+"\t",ParseContent);
					}
					//Reset content
					ParseContent = Corrected;
				}
				//start another line to process
				else
				{
					//append content
					ParseContent = ParseContent +" "+ Corrected;
				}
				lp++;
			}

			//process the rest
			if (ParseContent != "")
			{
				OtherContent = ParseContent;
			}

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
		Complete = Tabs+"void "+TheName+"("+Params+")\n"+Tabs+"{\n"+MethodContent+"\n"+Tabs+"}\n";
	}
	else
	{
		if (DefaultValue == "")
		{
			Complete = Tabs+Type+" "+TheName+"("+Params+")\n"+Tabs+"{\n"+Tabs+"\t"+Type+" "+ReturnVar+";\n"+MethodContent+"\n"+Tabs+"\treturn "+ReturnVar+";\n"+Tabs+"}\n";
		}
		else
		{
			Complete = Tabs+Type+" "+TheName+"("+Params+")\n"+Tabs+"{\n"+Tabs+"\t"+Type+" "+ReturnVar+" = "+DefaultValue+";\n"+MethodContent+"\n"+Tabs+"\treturn "+ReturnVar+";\n"+Tabs+"}\n";
		}
	}
	return Complete;
}

//loop:
String Loop(String Tabs, String TheKindType, String Content)
{
/*
	print(TheKindType);
	print(Content);
	print("");
*/
	bool Last = false;
	String Complete = "";
	String RootTag = "";
	String TheCondition = "";
	String LoopContent = "";
	String NewContent = "";
	String OtherContent = "";

	//loop:<type>
	if (StartsWith(TheKindType, "loop:"))
	{
		//loop
		TheKindType = AfterSplit(TheKindType,':');
	}

	//content for loop
	while (Content != "")
	{
		Content = ReplaceTag(Content, "loop-",false);
//		Content = ReplaceTag(Content, "loop-",true);

		if (StartsWith(Content, "condition"))
		{
			if (IsIn(Content," "))
			{
				TheCondition = BeforeSplit(Content,' ');
				Content = AfterSplit(Content,' ');
				//Content = ReplaceTag(Content, "loop-",false);
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

			//handle the content if the first tag is a stmt: or var:
			if (((StartsWith(OtherContent, "stmt:") || StartsWith(OtherContent, "var:")) && IsIn(OtherContent," ")))
			{
				//examine each tag
				std::vector<String> cmds = split(OtherContent," ");
				OtherContent = "";
				NewContent = "";
				int end = len(cmds);
				int lp = 0;
				while (lp != end)
				{
					//as long as the beginning of the tag is stmt:, var:, or params: make sure to build the non-loop/logic tags
					if ((IsIn(cmds[lp],"stmt:") || IsIn(cmds[lp],"var:") || IsIn(cmds[lp],"params:")) && (NewContent == ""))
					{
						if (OtherContent == "")
						{
							OtherContent = cmds[lp];
						}
						else
						{
							OtherContent = OtherContent+" "+cmds[lp];
						}
					}
					//build the rest of the content
					else
					{
						if (NewContent == "")
						{
							NewContent = cmds[lp];
						}
						else
						{
							NewContent = NewContent+" "+cmds[lp];
						}
					}
					lp++;
				}

				//processes all the statements before a loop/logic
				LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent);

				//Lets group the nested tages one more time...I am not sure how to avoide this being done again
				if (StartsWith(NewContent, "nest-"))
				{
					RootTag = BeforeSplit(NewContent,'l');
					if (IsIn(NewContent," "+RootTag+"l"))
					{
						//split up the loops and logic accordingly
						std::vector<String> cmds = split(NewContent," "+RootTag+"l");
						NewContent = "";
						int end = len(cmds);
						int lp = 0;
						while (lp != end)
						{
							if (lp == 0)
							{
								OtherContent = cmds[lp];
								//remove all nest-
								while (StartsWith(OtherContent, "nest-"))
								{
									OtherContent = AfterSplit(OtherContent,'-');
								}
								//process loop/logic
								LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent);
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

					while (StartsWith(NewContent, "nest-"))
					{
						NewContent = AfterSplit(NewContent,'-');
					}
					//process the remaining nest-loop/logic
					LoopContent = LoopContent + GenCode(Tabs+"\t",NewContent);
				}
			}
			//just process as is
			else
			{
				LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent);
			}
			//clear new content
			NewContent = "";
		}
		else if ((StartsWith(Content, "var:")) || (StartsWith(Content, "stmt:")))
		{
//			Content = ReplaceTag(Content, "loop-",true);
			LoopContent = LoopContent + GenCode(Tabs+"\t",Content);
			Content = "";
		}

		//no nested content
		else
		{
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
	//loop:do-while
	else if (TheKindType == "do-while")
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
/*
	print("[T] "+TheKindType);
	print("[C] "+Content);
	print("");
*/
	bool Last = false;
	String Complete = "";
	String RootTag = "";
	String TheCondition = "";
	String LogicContent = "";
	String NewContent = "";
	String OtherContent = "";

	if (StartsWith(TheKindType, "logic:"))
	{
		TheKindType = AfterSplit(TheKindType,':');
	}

	while (Content != "")
	{
		Content = ReplaceTag(Content, "logic-",false);
//		Content = ReplaceTag(Content, "logic-",true);

		if (StartsWith(Content, "condition"))
		{
			if (IsIn(Content," "))
			{
				TheCondition = BeforeSplit(Content,' ');
				Content = AfterSplit(Content,' ');
				//Content = ReplaceTag(Content, "logic-",false);
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
			//nest-logic
			// or
			//nest-loop
			RootTag = BeforeSplit(Content,'l');
			if (IsIn(Content," "+RootTag+"l"))
			{
				//split up the loops and logic accordingly
				std::vector<String> cmds = split(Content," "+RootTag+"l");
				int end = len(cmds);
				int lp = 0;
				while (lp != end)
				{
					//process now
					if (lp == 0)
					{
						//this tag already contains the nest-logic or nest-loop
						//this will be processed and the following will be ignored for the next recurrsive cycle
						OtherContent = cmds[lp];
					}
					//process later
					else
					{
						//build the next elements
						if (NewContent == "")
						{
							//put back in the nest-l
							NewContent = RootTag+"l"+cmds[lp];
						}
						else
						{
							//put back in the nest-l and append
							NewContent = NewContent+" "+RootTag+"l"+cmds[lp];
						}
					}
					lp++;
				}
			}
			//no need to split nested
			else
			{
				OtherContent = Content;
			}

			//the new content will be looped
			Content = NewContent;

			//remove all nest- tags from content
			while (StartsWith(OtherContent, "nest-"))
			{
				OtherContent = AfterSplit(OtherContent,'-');
			}

			//handle the content if the first tag is a stmt: or var:
			if (((StartsWith(OtherContent, "stmt:") || StartsWith(OtherContent, "var:")) && IsIn(OtherContent," ")))
			{
				//examine each tag
				std::vector<String> cmds = split(OtherContent," ");
				OtherContent = "";
				NewContent = "";
				int end = len(cmds);
				int lp = 0;
				while (lp != end)
				{
					//as long as the beginning of the tag is stmt:, var:, or params: make sure to build the non-loop/logic tags
					if ((IsIn(cmds[lp],"stmt:") || IsIn(cmds[lp],"var:") || IsIn(cmds[lp],"params:")) && (NewContent == ""))
					{
						if (OtherContent == "")
						{
							OtherContent = cmds[lp];
						}
						else
						{
							OtherContent = OtherContent+" "+cmds[lp];
						}
					}
					//build the rest of the content
					else
					{
						if (NewContent == "")
						{
							NewContent = cmds[lp];
						}
						else
						{
							NewContent = NewContent+" "+cmds[lp];
						}
					}
					lp++;
				}

				//processes all the statements before a loop/logic
				LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent);

				//Lets group the nested tages one more time...I am not sure how to avoide this being done again
				if (StartsWith(NewContent, "nest-"))
				{
					RootTag = BeforeSplit(NewContent,'l');
					if (IsIn(NewContent," "+RootTag+"l"))
					{
						//split up the loops and logic accordingly
						std::vector<String> cmds = split(NewContent," "+RootTag+"l");
						NewContent = "";
						int end = len(cmds);
						int lp = 0;
						while (lp != end)
						{
							if (lp == 0)
							{
								OtherContent = cmds[lp];
								//remove all nest-
								while (StartsWith(OtherContent, "nest-"))
								{
									OtherContent = AfterSplit(OtherContent,'-');
								}
								//process loop/logic
								LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent);
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
					//remove all nest-
					while (StartsWith(NewContent, "nest-"))
					{
						NewContent = AfterSplit(NewContent,'-');
					}
					//process the remaining nest-loop/logic
					LogicContent = LogicContent + GenCode(Tabs+"\t",NewContent);

				}
			}
			//just process as is
			else
			{
				LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent);
			}
			//clear new content
			NewContent = "";
		}
		else if ((StartsWith(Content, "var:")) || (StartsWith(Content, "stmt:")))
		{
//			Content = ReplaceTag(Content, "logic-",false);
			LogicContent = LogicContent + GenCode(Tabs+"\t",Content);
			Content = "";
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

	if (StartsWith(TheKindType, "stmt:"))
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
		if ((StartsWith(Content, "params:")) && (Params == ""))
		{
			if (IsIn(Content," "))
			{
				Process = BeforeSplit(Content,' ');
			}
			else
			{
				Process = Content;
			}
			Params = Parameters(Process,"stmt");

			if (IsIn(Params,"(-spc)"))
			{
				Params = replaceAll(Params, "(-spc)"," ");
			}
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
			Content = AfterSplit(Content,' ');
			if (StartsWith(Content, "params:"))
			{
				OtherContent = OtherContent+" "+BeforeSplit(Content,' ');
				Content = AfterSplit(Content,' ');
			}

			if ((StartsWith(OtherContent,"loop:") && (Content != "")) || (StartsWith(OtherContent,"logic:") && (Content != "")))
			{
				OtherContent = OtherContent+" "+Content;
				Content = "";
			}
			StatementContent = StatementContent + GenCode(Tabs,OtherContent);
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
	else if (TheName == "tab")
	{
		Complete = "\t"+StatementContent;
	}

	return Complete;
}

//var:
String Variables(String Tabs, String TheKindType, String Content)
{
/*
	print(TheKindType);
	print(Content);
	print("");
*/
	bool Last = false;
	bool MakeEqual = false;
	String NewVar = "";
	String Name = "";
	String VarType = "";
	String Value = "";
	String VariableContent = "";
	String OtherContent = "";

	if (StartsWith(TheKindType, "var:"))
	{
		TheKindType = AfterSplit(TheKindType,':');
	}

	while (Content != "")
	{
		//All params are removed

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
			VariableContent = VariableContent + GenCode(Tabs,Content);
			Last = true;
		}
		else
		{
			OtherContent = BeforeSplit(Content,' ');
			Content = AfterSplit(Content,' ');
			if (StartsWith(Content, "params:"))
			{
				OtherContent = OtherContent+" "+BeforeSplit(Content,' ');
				Content = AfterSplit(Content,' ');
			}

			if ((StartsWith(OtherContent,"loop:") && (Content != "")) || (StartsWith(OtherContent,"logic:") && (Content != "")))
			{
				OtherContent = OtherContent+" "+Content;
				Content = "";
			}
			VariableContent = VariableContent + GenCode(Tabs,OtherContent);
		}
	}

	//Pull Variable Type
	if ((StartsWith(TheKindType,"(")) && (IsIn(TheKindType,")")))
	{
		VarType = BeforeSplit(TheKindType,')');
		VarType = AfterSplit(VarType,'(');
		VarType = DataType(VarType,false);
		TheKindType = AfterSplit(TheKindType,')');
		Name = TheKindType;
	}

	//Assign Value
	if (IsIn(TheKindType,"="))
	{
		MakeEqual = true;
		Name = BeforeSplit(TheKindType,'=');
		Value = AfterSplit(TheKindType,'=');
	}

	if (VarType != "")
	{
		NewVar = VarType+" ";
	}

	if (MakeEqual == true)
	{
		if (IsIn(Value,"(-spc)"))
		{
			Value = replaceAll(Value, "(-spc)"," ");
		}

		NewVar = NewVar+Name+" = "+Value;
	}
	else
	{
		NewVar = NewVar+Name;
	}
	NewVar = NewVar+VariableContent;

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
		TheCode = Parameters(Args[0],"stmt");
	}
*/
	return TheCode;
}

void Example(String tag)
{
	String UserIn = "";
	print("\t{EXAMPLE}");
	print("Command: "+tag);
//	print("\t---or---");
	if (IsIn(tag," "))
	{
		std::vector<String> all = split(tag," ");
		int end = len(all);
		int lp = 0;
		while (lp != end)
		{
			if (UserIn == "")
			{
				UserIn = TranslateTag(all[lp]);
			}
			else
			{
				UserIn = UserIn + " " + TranslateTag(all[lp]);
			}
			lp++;
		}
	}
	else
	{
		UserIn = TranslateTag(tag);
	}
//	print("Command: "+UserIn);
	print("");
	UserIn = GenCode("",UserIn);
	print("\t{OUTPUT}");
	print(UserIn);
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
//			UserIn = String(argv[1]);
			UserIn = TranslateTag(String(argv[1]));
			for (int lp = 2; lp < argc; lp++)
			{
//				UserIn = UserIn + " " + String(argv[lp]);
				UserIn = UserIn + " " + TranslateTag(String(argv[lp]));
			}
/*
			print(UserIn);
			print("");
*/
		}
		else
		{
			UserIn = raw_input(">>> ");
			UserIn = TranslateTag(UserIn);
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
		else if (((UserIn == "-v") && (argc == 2)) || ((UserIn == "--version") && (argc == 2)) || ((UserIn == "version") && (argc == 1)))
		{
			print(Version);
		}
		else if (StartsWith(UserIn, "help"))
		{
			Help(UserIn);
		}
		else
		{
//			print(UserIn);
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
