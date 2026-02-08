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

String Version = "0.1.30";

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
String VectAndArray(String Name, String DataType, String VectorOrArray, String Action, String TheValue);
String AlgoTags(String Algo);
String TranslateTag(String Input);
String HandleTabs(String CalledBy, String Tabs, String Content);
bool IsDataType(String Type);
String DataType(String Type, bool getNull);
String ReplaceTag(String Content, String Tag, bool All);
String Pointers(String Tabs, String Tag, String Content);
String Conditions(String input);
String Parameters(String input,String CalledBy);
String Template(String TheName, String Content);
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
		print("{Purpose}");
		print("This is the generate a class for C++ using nested elements");
		print("");
		print("{Elements}");
		print("{class}<name>:<param>\twhere \"<name>\" is the name of your class and <params> are the parameters for the class constructor");
		print("[]-<elements>\t\twhere, this called right after the class called, populates the class constructor");
		print("{c}-[]<name>:<params>\twhere \"<name>\" is the name of the class, for additional constructors");
		print("{c}-<element>\t\twhere \"<element>\" are to be called from class");
		print("");
		print("{Usage}");
		print("{class}<name> {c}-<element>");
		print("{class}<name>:<params> []-<constructor> {c}-<element>");
		print("");
		Example("{class}clock []-equals(hr):0 []-equals(min):0 []-equals(date):\"00/00/0000\" []-[print]:\"ClockStarted\" []-el {c}-[]clock:(int)one,(int)two,(String)three []-equals(hr):one []-equals(min):two []-equals(date):three []-[print]:\"ClockStarted\" []-el {c}-var(protected):(bool)reset {c}-var(private):(int)hr {c}-var(private):(int)min {c}-var(private):(String)date {c}-nl {c}-[]Hr:(int)number []-equals((int)value):number []-if:number(-lt)25 +-equals(hr):Value {c}-nl {c}-[int-value]Hr: []-(int)value:()hr []-el {c}-nl {c}-[]Min:(int)number []-equals((int)value):number []-if:number(-lt)61 +-equals(min):Value {c}-nl {c}-[int-value]Min: []-equals((int)value):min {c}-nl {c}-[]Date:(String)TheDate []-equals((String)value):TheDate []-if:TheDate(-ne)\"0/0/0000\" +-equals(date):Value {c}-nl {c}-[String-value]Date: []-equals((String)value):date {c}-nl");
	}
	else if (Type == "struct")
	{
		print("{struct}<name> {s}-<element>");
		print("");
		Example("{struct}clock {s}-(int)time {s}-el {s}-(String)date {s}-el");
	}
	else if (Type == "template")
	{
		print("(<type>)<name>");
		print("");
		Example("{template}vals [{t}-time]clock []-({t})time:[start]: []-el []-nl []-if:here +-[stop]: +-el []-nl []-[begin]: []-el []-nl []-if: +-[end]: +-el []-else +-[reset]: +-el []-for: o-[count]: o-el");
		Example("{template}T [{t}-sum]Add:({t})a,({t})b []-()and:()a+b []-el []-()sum:()a+b []-el");
	}
	else if (Type == "method")
	{
		print("[<data>]<name>:<parameters>");
		print("[<data>-<return>]<name>:<parameters>");
		print("");
		Example("[String-Type]FoodAndDrink:(String)Food []-if:Food(-ne)\"\" +->if:[IsDrink]:drink(-eq)true +-()Type=\"Drink\" +-el +->>if:[IsNotEmpty]:Food +-[Drink]:Food +-el +->>>if:mood(-ne)\"happy\" +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->>>>if:mood(-eq)\"unhappy\" +-[ChearUp]:mood +-el +-[print]:\"I(-spc)am(-spc)\"+mood +-el <<<<-+-[ImHappy]: <<<<-+-el <<<-+-[Refill]: <<<-+-el <<-+-[Complete]: <<-+-el <<-+-[NewLine]: <<-+-el +->else-if:[IsFood]:Food(-eq)true +-()Type=\"Food\" +-el +->>while:[IsNotEmpty]:Food o-[Eat]:Food o-el o->>if:mood(-ne)\"happy\" +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->>>do-while:mood(-eq)\"unhappy\" o-[ChearUp]:mood o-el o-[print]:\"I(-spc)am(-spc)\"+mood o-el <<<<-+-[print]:\"I(-spc)am(-spc)\"+mood+\"(-spc)now\" <<<<-+-el +->else +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el []-else +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el []-nl []-[print]:\"It(-spc)works!!!\" []-el");
		Example("[]clock []-(int)time:[start]: []-el []-nl []-if:here +-[stop]: +-el []-nl []-[begin]: []-el []-nl []-if: +-[end]: +-el []-else +-[reset]: +-el []-for: o-[count]: o-el");
	}
	else if (Type == "loop")
	{
		print("<loop>:<condition>");
		print("");
		print("{loop}");
		print("for:");
		print("do-while:");
		print("while:");
		print("");
		print("{EXAMPLE}");
		print("");
		Example("while:Type(-spc)==(-spc)\"String\"");
		Example("do-while:Type(-eq)\"String\" o-[work]: o-el");
		Example("while:true >if:[IsString]:drink(-eq)true [drink]: el >>if:drink(-eq)\"coke\" >>else nl >else-if:[IsInt]:drink(-eq)false nl >else >>if: nl >>else nl");
		Example("while:true >if:[IsString]:drink(-eq)true >>if:drink(-eq)\"coke\" >>else nl >else-if:[IsInt]:drink(-eq)false nl >else >>if: >>nl >>else nl");
		Example("while:Food(-ne)\"\" o->if:[IsDrink]:drink(-eq)true +-()Type=\"Drink\" +-el +->>while:[IsNotEmpty]:Food o-[Drink]:Food o-el o->>>if:mood(-ne)\"happy\" +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->>>>do-while:mood(-eq)\"unhappy\" o-[ChearUp]:mood o-el o-[print]:\"I(-spc)am(-spc)\"+mood o-el <<<<-+-[print]:\"I(-spc)am(-spc)\"+mood+\"(-spc)now\" <<<<-+-el o->else-if:[IsDrink]:drink(-eq)true +-()Type=\"Drink\" +-el +->>while:[IsNotEmpty]:Food o-[Drink]:Food o-el o->>>if:mood(-ne)\"happy\" +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->>>>do-while:mood(-eq)\"unhappy\" o-[ChearUp]:mood o-el o-[print]:\"I(-spc)am(-spc)\"+mood o-el <<<<-+-[print]:\"I(-spc)am(-spc)\"+mood+\"(-spc)now\" <<<<-+-el o->else +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el");
	}
	else if (Type == "logic")
	{
		print("<logic>:<condition>");
		print("");
		print("{logic}");
		print("if:");
		print("else-if:");
		print("else");
		print("");
		print("{EXAMPLE}");
		print("");
		Example("if:Type(-spc)==(-spc)\"String\"");
		Example("else-if:Type(-eq)\"String\"");
		Example("else");
		Example("if:true (String)drink:[Pop]:one,two el >if:[IsString]:drink(-eq)true [drink]: el >>if:drink(-eq)\"coke\" >>else nl >else-if:[IsInt]:drink(-eq)false nl >else >>if: nl >>else nl");
		Example("if:true (String)drink:[Pop]:one,two el >if:[IsString]:drink(-eq)true >>if:drink(-eq)\"coke\" >>else nl >else-if:[IsInt]:drink(-eq)false nl >else >>if: nl >>else nl");
		Example("if:Food(-ne)\"\" +->if:[IsDrink]:drink(-eq)true +-()Type=\"Drink\" +-el +->>if:[IsNotEmpty]:Food +-[Drink]:Food +-el +->>>if:mood(-ne)\"happy\" +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->>>>if:mood(-eq)\"unhappy\" +-[ChearUp]:mood +-el +-[print]:\"I(-spc)am(-spc)\"+mood +-el <<<<-+-[ImHappy]: <<<<-+-el <<<-+-[Refill]: <<<-+-el <<-+-[Complete]: <<-+-el <<-+-[NewLine]: <<-+-el +->else-if:[IsFood]:Food(-eq)true +-()Type=\"Food\" +-el +->>while:[IsNotEmpty]:Food o-[Eat]:Food o-el o->>if:mood(-ne)\"happy\" +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->>>do-while:mood(-eq)\"unhappy\" o-[ChearUp]:mood o-el o-[print]:\"I(-spc)am(-spc)\"+mood o-el <<<<-+-[print]:\"I(-spc)am(-spc)\"+mood+\"(-spc)now\" <<<<-+-el +->else +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el");
	}
	else if (Type == "var")
	{
		Example("(std::string)name:()\"\" el (int)point:()0 el (std::string)james=\"James\" el (int)help el help=0");
		Example("(std::string)name:()\"\" el (int)point:()0 el (std::string)james=\"James\" el (int)help el help=0");
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
		print(">\t:\t\"next loop/logic element is nested in previous loop/logic\"");
		print("[]-<type>\t:\t\"assigne the next element to method content only\"");
		print("+-<type>\t:\t\"assigne the next element to logic content only\"");
		print("o-<type>\t:\t\"assigne the next element to loop content only\"");
		print("<-<type>\t:\t\"assigne the next element to previous element\"");
		print("<<-<type>\t:\t\"assigne the next element to 2 previous element\"");
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

String VectAndArray(String Name, String TheDataType, String VectorOrArray, String Action, String TheValue)
{
	String TheReturn = "";
	if (VectorOrArray == "vector")
	{
		if (Action == "variable")
		{
			if (TheValue != "")
			{
				TheReturn = "std::vector<"+TheDataType+"> "+Name+" = "+TheValue;
			}
			else
			{
				TheReturn = "std::vector<"+TheDataType+"> "+Name;
			}
		}
		else
		{
			if ((!IsIn(Name,"[")) && (!IsIn(Name,"]")))
			{
				TheReturn = Name+".push_back("+TheValue+")";
			}
		}
	}
	else if (VectorOrArray == "array")
	{
		String plc = "";

		if (Action == "variable")
		{
			if (IsIn(TheDataType,"[") && EndsWith(TheDataType,"]"))
			{
				plc = AfterSplit(TheDataType,'[');
				plc = BeforeSplit(plc,']');
				TheDataType = BeforeSplit(TheDataType,'[');
			}
			TheDataType = DataType(TheDataType,false);
			if (TheValue != "")
			{
				TheReturn = TheDataType+" "+Name+"["+plc+"] = "+TheValue;
			}
			else
			{
				TheReturn = TheDataType+" "+Name+"["+plc+"]";
			}
		}
		else
		{
			if (IsIn(Name,"[") && EndsWith(Name,"]"))
			{
				plc = AfterSplit(Name,'[');
				plc = BeforeSplit(plc,']');
				Name = BeforeSplit(Name,'[');
			}

			if (TheValue != "")
			{
				TheReturn = Name+"["+plc+"] = "+TheValue;
			}
			else
			{
				TheReturn = Name+"["+plc+"]";
			}
		}
	}

	return TheReturn;
}

String AlgoTags(String Algo)
{
	bool IsCallMethod = false;
	String NewTags = "";
	String Action = "";
	String Args = "";
	String DataType = "";
	String ReturnKey = "";
	String ReturnValue = "";

	if (IsIn(Algo,":"))
	{
		Action = BeforeSplit(Algo,':');
		Args = AfterSplit(Algo,':');
	}

	if ((StartsWith(Algo,"concat(") && (IsIn(Algo,"):")) && (Args != "")))
	{
		ReturnKey = AfterSplit(Action,'(');
		ReturnKey = BeforeSplit(ReturnKey,')');

		if (IsIn(Args,","))
		{
			ReturnValue = "()"+ReturnKey;
			std::vector<String> AllArgs = split(Args,',');
			ReturnValue = join(AllArgs," ()");
			NewTags = "()"+ReturnKey+":()"+ReturnValue;
		}
	}
	else if ((StartsWith(Algo,"decre(") && (IsIn(Algo,"):")) && (Args == "")))
	{
		ReturnKey = AfterSplit(Action,'(');
		ReturnKey = BeforeSplit(ReturnKey,')');
		ReturnValue = " ()- ()-";
		NewTags = "()"+ReturnKey+ReturnValue;
	}
	else if ((StartsWith(Algo,"decre(") && (IsIn(Algo,"):")) && (Args != "")))
	{
		ReturnKey = AfterSplit(Action,'(');
		ReturnKey = BeforeSplit(ReturnKey,')');
		ReturnValue = "(-spc) ()- (): ()"+Args;
		NewTags = "()"+ReturnKey+ReturnValue;
	}
	else if ((StartsWith(Algo,"incre(") && (IsIn(Algo,"):")) && (Args == "")))
	{
		ReturnKey = AfterSplit(Action,'(');
		ReturnKey = BeforeSplit(ReturnKey,')');
		ReturnValue = " ()+ ()+";
		NewTags = "()"+ReturnKey+ReturnValue;
	}
	else if ((StartsWith(Algo,"incre(") && (IsIn(Algo,"):")) && (Args != "")))
	{
		ReturnKey = AfterSplit(Action,'(');
		ReturnKey = BeforeSplit(ReturnKey,')');
		ReturnValue = " ()+ ()= ()"+Args;
		NewTags = "()"+ReturnKey+ReturnValue;
	}
	else if ((StartsWith(Algo,"equals(") && (IsIn(Algo,"):")) && (Args != "")))
	{
		if (StartsWith(Args,"["))
		{
			IsCallMethod = true;
		}

		ReturnValue = Args;

		if (StartsWith(Action,"equals(("))
		{
			ReturnKey = AfterSplit(Action,'(');
			ReturnKey = AfterSplit(ReturnKey,'(');
			DataType = BeforeSplit(ReturnKey,')');
			ReturnKey = AfterSplit(ReturnKey,')');
			ReturnKey = BeforeSplit(ReturnKey,')');
			if (IsCallMethod == true)
			{
				NewTags = "("+DataType+")"+ReturnKey+":"+ReturnValue;
			}
			else
			{
				NewTags = "("+DataType+")"+ReturnKey+":()"+ReturnValue;
			}
		}
		else
		{
			ReturnKey = AfterSplit(Action,'(');
			ReturnKey = BeforeSplit(ReturnKey,')');
			if (IsCallMethod == true)
			{
				NewTags = "()"+ReturnKey+":"+ReturnValue;
			}
			else
			{
				NewTags = "()"+ReturnKey+":()"+ReturnValue;
			}
		}
	}
	else if ((Algo == "concat():") || (Algo == "decre():") || (Algo == "incre():") || (Algo == "equals():"))
	{
		NewTags = "";
	}
	else
	{
		NewTags = Algo;
	}

	return NewTags;
}

String TranslateTag(String Input)
{
	String TheReturn = "";
	String Action = Input;
	String Value = "";
	String NewTag = "";
	String TheDataType = "";
	String Nest = "";
	String Parent = "";
	String ContentFor = "";
//	String OldDataType = "";

	//content for parent loops/logic
	if (StartsWith(Action, "<-"))
	{
		Action = AfterSplit(Action,'-');
		Parent = "parent-";
	}
	//content for future parent loops/logic
	else if (StartsWith(Action, "<<"))
	{
		Action = AfterSplit(Action,'<');
		Parent = "parent-";
	}
	//content for logic
	else if (StartsWith(Action, "+-"))
	{
		Action = AfterSplit(Action,'-');
		ContentFor = "logic-";
	}
	//content for loops
	else if (StartsWith(Action, "o-"))
	{
		Action = AfterSplit(Action,'-');
		ContentFor = "loop-";
	}
	//content for methods
	else if (StartsWith(Action, "[]-"))
	{
		Action = AfterSplit(Action,'-');
		ContentFor = "method-";
	}
	//content for classes
	else if (StartsWith(Action, "{c}-"))
	{
		Action = AfterSplit(Action,'-');
		ContentFor = "class-";
	}

	//constructor for classes
	else if (StartsWith(Action, "{const}-"))
	{
		Action = AfterSplit(Action,'-');
//		ContentFor = "point:";
	}

	//content for classes
	else if (StartsWith(Action, "{s}-"))
	{
		Action = AfterSplit(Action,'-');
		ContentFor = "struct-";
	}

	// ">" becomes "nest-"
	while (StartsWith(Action, ">"))
	{
		Action = AfterSplit(Action,'>');
		Nest = "nest-"+Nest;
	}

	if (StartsWith(Action,"concat(") || StartsWith(Action,"incre(") || StartsWith(Action,"decre(") || StartsWith(Action,"equals("))
	{
		String Algo = AlgoTags(Action);
		String NewAlgoTag = "";
		if (IsIn(Algo," "))
		{
			std::vector<String> all = split(Algo," ");
			int end = len(all);
			int lp = 0;
			while (lp != end)
			{
				NewAlgoTag = all[lp];
				if (TheReturn == "")
				{
					TheReturn = Parent+ContentFor+Nest+TranslateTag(NewAlgoTag);
				}
				else
				{
					TheReturn = TheReturn +" "+Parent+ContentFor+Nest+TranslateTag(NewAlgoTag);
				}

				if (StartsWith(Action,"equals("))
				{
					TheReturn = TheReturn +" "+Parent+ContentFor+Nest+TranslateTag("el");
				}
				lp++;
			}
		}
		else
		{
			TheReturn = Parent+ContentFor+Nest+TranslateTag(Algo);
			if (StartsWith(Action,"equals("))
			{
				TheReturn = TheReturn +" "+Parent+ContentFor+Nest+TranslateTag("el");
			}
		}

	}
	//convert if, else-if, or switch to the old tags
//	else if ((StartsWith(Action, "if:")) || (StartsWith(Action, "else-if:")) || (StartsWith(Action, "switch:")) || (StartsWith(Action, "switch-case:")))
	else if ((StartsWith(Action, "if:")) || (StartsWith(Action, "else-if:")) || (StartsWith(Action, "switch:")))
	{
		Value = AfterSplit(Action,':');
		Action = BeforeSplit(Action,':');
		NewTag = "logic:"+Action;
		Value = "logic-condition:"+Value;
		TheReturn = Parent+ContentFor+Nest+NewTag+" "+Value;
	}
	else if (StartsWith(Action, "case:"))
	{
		Value = AfterSplit(Action,':');
		Action = BeforeSplit(Action,':');
		Nest = "nest-"+Nest;
		NewTag = "logic:"+Action;
		Value = "logic-condition:"+Value;
		TheReturn = Parent+ContentFor+Nest+NewTag+" "+Value;
	}
	//convert else to the old tags
	else if (Action == "else")
	{
		NewTag = "logic:"+Action;
		TheReturn = Parent+ContentFor+Nest+NewTag;
	}
	//convert while, for, and do-while, to the old tags
	else if ((StartsWith(Action, "while:")) || (StartsWith(Action, "for:")) || (StartsWith(Action, "do-while:")))
	{
		Value = AfterSplit(Action,':');
		Action = BeforeSplit(Action,':');
		NewTag = "loop:"+Action;
		Value = "loop-condition:"+Value;
		TheReturn = Parent+ContentFor+Nest+NewTag+" "+Value;
	}
	//class or struct
	else if ((StartsWith(Action, "{")) && (IsIn(Action,"}")))
	{
		String Parent = "";
		TheDataType = BeforeSplit(Action,'}');
		TheDataType = AfterSplit(TheDataType,'{');
		Action = AfterSplit(Action,'}');

		if (IsIn(TheDataType,"-"))
		{
			Parent = AfterSplit(TheDataType,'-');
			TheDataType = BeforeSplit(TheDataType,'-');
			if (TheDataType != "template")
			{
				Action = Action+"-"+Parent;
			}
		}

		if (IsIn(Action,":"))
		{
			Value = AfterSplit(Action,':');
			Action = BeforeSplit(Action,':');
		}
		if (Value != "")
		{
			TheReturn = TheDataType+":"+Action+" params:"+Value;
		}
		else
		{
			TheReturn = TheDataType+":"+Action;
		}
	}
	//method
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
			if (Value != "")
			{
//				TheReturn = Parent+ContentFor+Nest+"stmt:method-"+Action+" params:"+Value;
				TheReturn = Parent+ContentFor+"stmt:method-"+Action+" params:"+Value;
			}
			else
			{
//				TheReturn = Parent+ContentFor+Nest+"stmt:method-"+Action;
				TheReturn = Parent+ContentFor+"stmt:method-"+Action;
			}
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
				TheReturn = Parent+ContentFor+Nest+"method:("+TheDataType+")"+Action+" params:"+Value;
			}
			else
			{
				TheReturn = Parent+ContentFor+Nest+"method:("+TheDataType+")"+Action;
			}
		}
	}
	//variables
	else if ((StartsWith(Action, "(")) && (IsIn(Action,")")))
	{
		TheDataType = BeforeSplit(Action,')');
		TheDataType = AfterSplit(TheDataType,'(');
		Action = AfterSplit(Action,')');

		//replacing data type to represent the variable
		if (StartsWith(Action,":"))
		{
			Action = TheDataType+Action;
			TheDataType = "";
		}

		if (IsIn(Action,":"))
		{
			Value = AfterSplit(Action,':');
			Action = BeforeSplit(Action,':');
		}

		if (Value != "")
		{
			if (ContentFor == "logic-")
			{
				Value = "+-"+Nest+Value;
			}
			else if (ContentFor == "loop-")
			{
				Value = "o-"+Nest+Value;
			}
			else if (ContentFor == "method-")
			{
				Value = "[]-"+Nest+Value;
			}
			else if (ContentFor == "class-")
			{
				Value = "{}-"+Nest+Value;
			}

			//translate value, if needed
			Value = TranslateTag(Value);
//			Value = GenCode("",Value);
//			TheReturn = Parent+ContentFor+Nest+"var:("+TheDataType+")"+Action+"= "+Value;
			TheReturn = Parent+ContentFor+"var:("+TheDataType+")"+Action+"= "+Value;
		}
		else
		{
//			TheReturn = Parent+ContentFor+Nest+"var:("+TheDataType+")"+Action;
			TheReturn = Parent+ContentFor+"var:("+TheDataType+")"+Action;
		}
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

	//vectors or arrays
	else if ((StartsWith(Action, "<")) && (IsIn(Action,">")) && (!StartsWith(Action, "<<")) && (!StartsWith(Action, "<-")))
	{
		String VectorOrArray = "";
		TheDataType = BeforeSplit(Action,'>');
		TheDataType = AfterSplit(TheDataType,'<');
		Action = AfterSplit(Action,'>');

		//replacing data type to represent the variable
		if (StartsWith(Action,":"))
		{
			Action = TheDataType+Action;
			TheDataType = "";
		}

		if (IsIn(Action,":"))
		{
			Value = AfterSplit(Action,':');
			Action = BeforeSplit(Action,':');

			if ((EndsWith(Action,"]")) && (Value != ""))
			{
				VectorOrArray = "array:";
			}

			if (VectorOrArray == "")
			{
				if (StartsWith(Value,"["))
				{
					VectorOrArray = "vector:";
				}
				else
				{
					VectorOrArray = "array:";
				}
			}
		}

		if (TheDataType != "")
		{
			if (EndsWith(TheDataType,"]"))
			{
				VectorOrArray = "array:";
			}
			else
			{
				VectorOrArray = "vector:";
			}

			if (Value != "")
			{
				TheReturn = Parent+ContentFor+"var:<"+VectorOrArray+TheDataType+">"+Action+":"+Value;
			}
			else
			{
				TheReturn = Parent+ContentFor+"var:<"+VectorOrArray+TheDataType+">"+Action;
			}
		}
		else
		{
			if (Value != "")
			{
				TheReturn = Parent+ContentFor+"stmt:<"+VectorOrArray+TheDataType+">"+Action+":"+Value;
			}
			else
			{
				TheReturn = Parent+ContentFor+"stmt:<"+VectorOrArray+TheDataType+">"+Action;
			}
		}
	}
	else if (Action == "el")
	{
//		TheReturn = Parent+ContentFor+Nest+"stmt:endline";
		TheReturn = Parent+ContentFor+"stmt:endline";
	}
	else if (Action == "nl")
	{
//		TheReturn = Parent+ContentFor+Nest+"stmt:newline";
		TheReturn = Parent+ContentFor+"stmt:newline";
	}
	else if (Action == "tab")
	{
//		TheReturn = Parent+ContentFor+Nest+"stmt:"+Action;
		TheReturn = Parent+ContentFor+"stmt:"+Action;
	}
	else
	{
		if (Value != "")
		{
			TheReturn = Parent+ContentFor+Nest+Action+":"+Value;
		}
		else
		{
			TheReturn = Parent+ContentFor+Nest+Action;
		}
	}

	return TheReturn;
}

String HandleTabs(String CalledBy, String Tabs, String Content)
{
	String AutoTabs = "";
//	if ((CalledBy == "class") || (CalledBy == "method") || (CalledBy == "logic") || (CalledBy == "loop"))
//	{
	if ((Content != "stmt:endline") && (Content != "stmt:newline") && (!StartsWith(Content,"stmt:tab")))
	{
		if (StartsWith(Content,"stmt:") || StartsWith(Content,"var:"))
		{
			std::vector<String> AllTabs = split(Tabs,'\t');
			int lp = 0;
			int end = len(AllTabs);
			while (lp != end)
			{
				AutoTabs = AutoTabs +"stmt:tab ";
				lp++;
			}
		}
	}
//	}

	return AutoTabs;
}

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

String Pointers(String Tabs, String Tag, String Content)
{
	String PointerContent = "";
	Tag = AfterSplit(Tag,':');

	if (EndsWith(Tag,"="))
	{
		Tag = BeforeSplit(Tag,'=');
		PointerContent = GenCode(Tabs,Tag)+"->";
	}
	PointerContent = PointerContent + GenCode(Tabs,Content);
	return PointerContent;
}

//condition:
String Conditions(String input)
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

	if (IsIn(Condit,"(-ge)"))
	{
		Condit = replaceAll(Condit, "(-ge)"," >= ");
	}

	if (IsIn(Condit,"(-gt)"))
	{
		Condit = replaceAll(Condit, "(-gt)"," > ");
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
			if (Conditions[lp] != ">")
			{
				Conditions[lp] = TranslateTag(Conditions[lp]);
				Keep = Conditions[lp];
				Conditions[lp] = GenCode("",Conditions[lp]);
				if (Conditions[lp] == "")
				{
					Conditions[lp] = Keep;
				}
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
		std::vector<String> Conditions = split(Condit,"(-or)");
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
		Condit = join(Conditions, ") || (");

//		Condit = replaceAll(Condit, "(-or)",") || (");
		Condit = "("+Condit+")";
	}

	if (IsIn(Condit,"(-and)"))
	{
		std::vector<String> Conditions = split(Condit,"(-and)");
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
		Condit = join(Conditions, ") && (");
//		Condit = replaceAll(Condit, "(-and)",") && (");
		Condit = "("+Condit+")";
	}

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
			if (Name == "")
			{
				Params = Type+", "+more;
			}
			else
			{
				Params = Type+" "+Name+", "+more;
			}
		}
		//param-type
		else if ((StartsWith(Params,"(")) && (IsIn(Params,")")))
		{
			String Name = AfterSplit(Params,')');
			String Type = BeforeSplit(Params,')');

			Type = AfterSplit(Type,'(');
			Type = DataType(Type,false);
			Params = Type+" "+Name;
			if (Name == "")
			{
				Params = Type;
			}
		}
	}
	return Params;
}

String Template(String Type, String Content)
{
	String TemplateContent = "";
	String TheName = "";
	String Params = "";
	String DataType = "";
	String CallContent = "";

	TheName = AfterSplit(Content,':');
	DataType = AfterSplit(Type,':');

	Content = replaceAll(Content, "{t}",DataType);

	TemplateContent = "template <typename "+DataType+">\n";
	TemplateContent = TemplateContent + GenCode("",Content);

	return TemplateContent;
}

String Struct(String TheName, String Content)
{
	String Complete = "";
	String StructVar = "";
	String Process = "";
	String AutoTabs = "";

	TheName = AfterSplit(TheName,':');
	while ((StartsWith(Content, "struct-var")) || (StartsWith(Content, "struct-stmt")) || (StartsWith(Content, "var")) || (StartsWith(Content, "stmt")))
	{
		Content = ReplaceTag(Content, "struct-",true);

		if (IsIn(Content," "))
		{
			Process = BeforeSplit(Content,' ');
			Content = AfterSplit(Content,' ');
		}
		else
		{
			Process = Content;
			Content = "";
		}

		AutoTabs = HandleTabs("struct","\t",Process);
		if (AutoTabs != "")
		{
			StructVar = StructVar + GenCode("\t",AutoTabs);
			AutoTabs = "";
		}
		StructVar = StructVar + GenCode("\t",Process);
	}
	Complete = "struct {\n"+StructVar+"\n} "+TheName+";\n";
	return Complete;
}

String Class(String TheName, String Content)
{
	String Complete = "";
	String ProtectedVars = "";
	String PrivateVars = "";
	String PublicVars = "";
	String VarContent = "";
	String Constructor = "";
	String ConstContent = "";
	String Destructor = "";
	String Inheritance = "";
	String ParentClass = "";
	String Process = "";
	String Params = "";
	String ClassContent = "";

	TheName = AfterSplit(TheName,':');

	if (IsIn(TheName,"-"))
	{
		ParentClass = AfterSplit(TheName,'-');
		TheName = BeforeSplit(TheName,'-');
	}

	if ((StartsWith(Content, "params:")) && (Params == ""))
	{
		if (IsIn(Content," "))
		{
			Process = BeforeSplit(Content,' ');
			Content = AfterSplit(Content,' ');
		}
		else
		{
			Process = Content;
			Content = "";
		}
//		Params = Parameters(Process,"class");
		Params = Process;
	}
	//handle constructor content
	if (StartsWith(Content,"method-"))
	{
		while ((!StartsWith(Content,"class-")) && (Content != ""))
		{
			String Item = "";
			if (IsIn(Content," "))
			{
				Item = BeforeSplit(Content,' ');
				Content = AfterSplit(Content,' ');
			}
			else
			{
				Item = Content;
				Content = "";
			}
			ConstContent = ConstContent+" "+Item;
		}
	}

	//class constructor
	if (Params != "")
	{
		Constructor = GenCode("\t","method:({})"+TheName+" "+Params+ConstContent);
	}
	else
	{
		Constructor = GenCode("\t","method:({})"+TheName+ConstContent);
	}

	if (IsIn(Content," class-"))
	{
		std::vector<String> cmds = split(Content," class-");
		int end = len(cmds);
		int lp = 0;
		while (lp != end)
		{
			Content = cmds[lp];
			Content = ReplaceTag(Content, "class-",false);

			if (StartsWith(Content,"method:()"+TheName+" "))
			{
				Content = AfterSplit(Content,' ');
				Content = "method:({})"+TheName+" "+Content;
			}
			else if (Content == "method:()"+TheName)
			{
				Content = "method:({})"+TheName;
			}

			if (StartsWith(Content, "method:"))
			{
				ClassContent = ClassContent + GenCode("\t",Content);
			}
			else if (StartsWith(Content, "var"))
			{
				if (StartsWith(Content, "var(public)"))
				{
					VarContent = AfterSplit(Content,':');
					VarContent = "stmt:tab var:"+VarContent+" stmt:endline";
					PublicVars = PublicVars + GenCode("\t",VarContent);
				}
				else if (StartsWith(Content, "var(private)"))
				{
					VarContent = AfterSplit(Content,':');
					VarContent = "stmt:tab var:"+VarContent+" stmt:endline";
					PrivateVars = PrivateVars + GenCode("\t",VarContent);
				}
				else if (StartsWith(Content, "var(protected)"))
				{
					VarContent = AfterSplit(Content,':');
					VarContent = "stmt:tab var:"+VarContent+" stmt:endline";
					ProtectedVars = ProtectedVars + GenCode("\t",VarContent);
				}
				else
				{
					ClassContent = ClassContent + GenCode("\t",Content);
				}
			}
			else
			{
				ClassContent = ClassContent + GenCode("\t",Content);
			}

			lp++;
		}
	}
	else if (IsIn(Content," method:"))
	{
		std::vector<String> cmds = split(Content," method:");
		int end = len(cmds);
		int lp = 0;
		while (lp != end)
		{
			if (StartsWith(cmds[lp], "method:"))
			{
				ClassContent = ClassContent + GenCode("\t",cmds[lp]);
			}
			else
			{
				ClassContent = ClassContent + GenCode("\t","method:"+cmds[lp]);
			}
			lp++;
		}
	}
	else
	{
		Content = ReplaceTag(Content, "class-",false);
		if (StartsWith(Content,"method:()"+TheName))
		{
			Content = AfterSplit(Content,')');
			Content = "method:({})"+Content;
		}
		ClassContent = GenCode("\t",Content);
	}

	if (ProtectedVars != "")
	{
		ProtectedVars = "protected:\n\t//protected variables\n"+ProtectedVars+"\n";
	}

	if (PrivateVars != "")
	{
		PrivateVars = "private:\n\t//private variables\n"+PrivateVars+"\n";
	}

	if (PublicVars != "")
	{
		PublicVars = "\n\t//public variables\n"+PublicVars+"\n";
	}

//	Complete = "class "+TheName+" {\n\n"+PrivateVars+"public:"+PublicVars+"\n\t//class constructor\n\t"+TheName+"("+Params+")\n\t{\n\t\tthis->x = x;\n\t\tthis->y = y;\n\t}\n\n"+ClassContent+"\n\t//class desctructor\n\t~"+TheName+"()\n\t{\n\t}\n};\n";

	//class desctructor
	Destructor = GenCode("\t","method:(~)"+TheName);

	//handle parent class
	if (ParentClass != "")
	{
		Inheritance = ": public "+ParentClass;
	}

	Complete = "class "+TheName+Inheritance+" {\n\n"+ProtectedVars+PrivateVars+"public:"+PublicVars+"\n\t//class constructor\n"+Constructor+"\n"+ClassContent+"\n\t//class desctructor\n"+Destructor+"\n};\n";
	return Complete;
}

//method:
String Method(String Tabs, String Name, String Content)
{
	bool Last = false;
	bool CanSplit = true;
	bool AssignDefault = false;
	String ReturnVar = "TheReturn";
	String DefaultValue = "";
	String Complete = "";
	Name = AfterSplit(Name,':');
	String TheName = "";
	String OldType = "";
	String Type = "";
	String Params = "";
	String MethodContent = "";
	String OtherContent = "";
	String NewContent = "";
	String Process = "";
	String AutoTabs = "";

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

		OldType = Type;

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
			//handle default return value
			if (StartsWith(Content,"method-var:("))
			{
				String ProcessType = AfterSplit(Content,'(');
				ProcessType = BeforeSplit(ProcessType,')');

				if (StartsWith(Content,"method-var:()"+ReturnVar+"="))
				{
					String OldTag = BeforeSplit(Content,')');
					String OldValue = AfterSplit(Content,')');
					Content = OldTag+Type+")"+OldValue;
					AssignDefault = true;
				}
				else if ((StartsWith(Content,"method-var:("+OldType+")"+ReturnVar+"=")) || (StartsWith(Content,"method-var:("+Type+")"+ReturnVar+"=")) || (StartsWith(Content,"method-var:("+ProcessType+")"+ReturnVar+"=")))
				{
					AssignDefault = true;
				}
			}

			//This is called when a called from the "class" method
			// EX: class:name method:first method:second
			if (IsIn(Content," method:"))
			{
				//Only account for the first method content
				std::vector<String> cmds = split(Content," method:");
				Content = cmds[0];
			}

			if ((StartsWith(Content, "method-")) && (IsIn(Content, " method-l")))
			{

				std::vector<String> all = split(Content," method-l");
				int lp = 0;
				int end = len(all);
				while (lp != end)
				{
					if (lp == 0)
					{
						OtherContent = all[lp];
					}
					else
					{
						if (NewContent == "")
						{
							NewContent = "method-l"+all[lp];
						}
						else
						{
							NewContent = NewContent+" method-l"+all[lp];
						}
					}
					lp++;
				}
				CanSplit = false;
			}
			else
			{
				OtherContent = Content;
				CanSplit = true;
			}

//			OtherContent = ReplaceTag(OtherContent, "method-");

			String ParseContent = "";
			String Corrected = "";
			if (IsIn(OtherContent," method-"))
			{
				std::vector<String> cmds = split(OtherContent," method-");
				int end = len(cmds);
				int lp = 0;
				while (lp != end)
				{
					Corrected = ReplaceTag(cmds[lp], "method-",false);

					if (StartsWith(Corrected,"var:") || StartsWith(Corrected,"stmt:"))
					{
						if (ParseContent == "")
						{
							ParseContent = Corrected;
						}
						else
						{
							ParseContent = ParseContent+" "+Corrected;
						}

						if ((Corrected == "stmt:newline") || (Corrected == "stmt:endline"))
						{
							AutoTabs = HandleTabs("method",Tabs+"\t",ParseContent);

							if (AutoTabs != "")
							{
								//Generate the loop content
								MethodContent = MethodContent + GenCode(Tabs+"\t",AutoTabs);
							}
							//process content
							MethodContent = MethodContent + GenCode(Tabs+"\t",ParseContent);
							ParseContent = "";
						}
					}
					else
					{
						AutoTabs = HandleTabs("method",Tabs+"\t",Corrected);

						if (AutoTabs != "")
						{
							//Generate the loop content
							MethodContent = MethodContent + GenCode(Tabs+"\t",AutoTabs);
						}
						//process content
						MethodContent = MethodContent + GenCode(Tabs+"\t",Corrected);
					}
					lp++;
				}
			}
			else
			{
				Corrected = ReplaceTag(OtherContent, "method-",false);
				AutoTabs = HandleTabs("method",Tabs+"\t",Corrected);

				if (AutoTabs != "")
				{
					//Generate the loop content
					MethodContent = MethodContent + GenCode(Tabs+"\t",AutoTabs);
				}

				//Generate the loop content
				MethodContent = MethodContent + GenCode(Tabs+"\t",Corrected);
			}
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
//			Content = "";
			Last = true;
		}
	}

	//build method based on content
	if ((Type == "") || (Type == "void"))
	{
		if (EndsWith(MethodContent,"\n"))
		{
			Complete = Tabs+"void "+TheName+"("+Params+")\n"+Tabs+"{\n"+MethodContent+Tabs+"}\n";
		}
		else
		{
			Complete = Tabs+"void "+TheName+"("+Params+")\n"+Tabs+"{\n"+MethodContent+"\n"+Tabs+"}\n";
		}
	}
	//class constructor
	else if (Type == "{}")
	{
		if (EndsWith(MethodContent,"\n"))
		{
			Complete = Tabs+TheName+"("+Params+")\n"+Tabs+"{\n"+MethodContent+Tabs+"}\n";
		}
		else
		{
			Complete = Tabs+TheName+"("+Params+")\n"+Tabs+"{\n"+MethodContent+"\n"+Tabs+"}\n";
		}
	}
	//class desctructor
	else if (Type == "~")
	{
		Complete = Tabs+"~"+TheName+"()\n"+Tabs+"{\n"+Tabs+"}\n";
	}
	else
	{
		if (DefaultValue == "")
		{
			if (AssignDefault == true)
			{
				Complete = Tabs+Type+" "+TheName+"("+Params+")\n"+Tabs+"{\n"+MethodContent+"\n"+Tabs+"\treturn "+ReturnVar+";\n"+Tabs+"}\n";
			}
			else
			{
				Complete = Tabs+Type+" "+TheName+"("+Params+")\n"+Tabs+"{\n"+Tabs+"\t"+Type+" "+ReturnVar+";\n"+MethodContent+"\n"+Tabs+"\treturn "+ReturnVar+";\n"+Tabs+"}\n";
			}
		}
		else
		{
			if (AssignDefault == true)
			{
				Complete = Tabs+Type+" "+TheName+"("+Params+")\n"+Tabs+"{\n"+MethodContent+"\n"+Tabs+"\treturn "+ReturnVar+";\n"+Tabs+"}\n";
			}
			else
			{
				Complete = Tabs+Type+" "+TheName+"("+Params+")\n"+Tabs+"{\n"+Tabs+"\t"+Type+" "+ReturnVar+" = "+DefaultValue+";\n"+MethodContent+"\n"+Tabs+"\treturn "+ReturnVar+";\n"+Tabs+"}\n";
			}
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
	String AutoTabs = "";
	String Complete = "";
	String RootTag = "";
	String TheCondition = "";
	String LoopContent = "";
	String NewContent = "";
	String OtherContent = "";
	String ParentContent = "";

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
			TheCondition = Conditions(TheCondition);
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
			AutoTabs = HandleTabs("loop",Tabs+"\t",OtherContent);
			if (AutoTabs != "")
			{
				LoopContent = LoopContent + GenCode(Tabs+"\t",AutoTabs);
				AutoTabs = "";
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

				AutoTabs = HandleTabs("loop",Tabs+"\t",OtherContent);
				if (AutoTabs != "")
				{
					LoopContent = LoopContent + GenCode(Tabs+"\t",AutoTabs);
					AutoTabs = "";
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
								AutoTabs = HandleTabs("loop",Tabs+"\t",OtherContent);
								if (AutoTabs != "")
								{
									LoopContent = LoopContent + GenCode(Tabs+"\t",AutoTabs);
									AutoTabs = "";
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

					AutoTabs = HandleTabs("loop",Tabs+"\t",NewContent);
					if (AutoTabs != "")
					{
						LoopContent = LoopContent + GenCode(Tabs+"\t",AutoTabs);
						AutoTabs = "";
					}

					//process the remaining nest-loop/logic
					LoopContent = LoopContent + GenCode(Tabs+"\t",NewContent);
				}
			}
			//just process as is
			else
			{
				if (IsIn(OtherContent," parent-"))
				{
					//examine each tag
					std::vector<String> parent = split(OtherContent," parent-");
					OtherContent = "";
					int pEnd = len(parent);
					int pLp = 0;
					while (pLp != pEnd)
					{
						if ((pLp == 0) || (StartsWith(parent[pLp],"<-")) || (StartsWith(parent[pLp],"<<")))
						{
							if (OtherContent == "")
							{
								OtherContent = parent[pLp];
							}
							else
							{
								OtherContent = OtherContent + " " + TranslateTag(parent[pLp]);
							}
						}
						else
						{
							if (ParentContent == "")
							{
								ParentContent = TranslateTag(parent[pLp]);
							}
							else
							{
								ParentContent = ParentContent + " " + TranslateTag(parent[pLp]);
							}
						}
						pLp++;
					}
					ParentContent = ReplaceTag(ParentContent, "loop-",false);
				}

				//process the remaining nest-loop/logic
				AutoTabs = HandleTabs("loop",Tabs+"\t",OtherContent);
				if (AutoTabs != "")
				{
					LoopContent = LoopContent + GenCode(Tabs+"\t",AutoTabs);
					AutoTabs = "";
				}

				LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent);
			}

			//process parent content
			if (ParentContent != "")
			{
				//process the remaining nest-loop/logic
				AutoTabs = HandleTabs("loop",Tabs+"\t",ParentContent);
				if (AutoTabs != "")
				{
					LoopContent = LoopContent + GenCode(Tabs+"\t",AutoTabs);
					AutoTabs = "";
				}

				LoopContent = LoopContent + GenCode(Tabs+"\t",ParentContent);
				ParentContent = "";
			}

			//clear new content
			NewContent = "";
		}
		else if ((StartsWith(Content, "var:")) || (StartsWith(Content, "stmt:")))
		{
//			Content = ReplaceTag(Content, "loop-",true);
			AutoTabs = HandleTabs("loop",Tabs+"\t",Content);
			if (AutoTabs != "")
			{
				LoopContent = LoopContent + GenCode(Tabs+"\t",AutoTabs);
				AutoTabs = "";
			}

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
	String ParentContent = "";
	String AutoTabs = "";


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
			TheCondition = Conditions(TheCondition);
		}

		//This part of the code is meant to separate the nested content with the current content
		//stmt: var: nest-logic nest-loop
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

			AutoTabs = HandleTabs("logic",Tabs+"\t",OtherContent);
			if (AutoTabs != "")
			{
				LogicContent = LogicContent + GenCode(Tabs+"\t",AutoTabs);
				AutoTabs = "";
			}

			//Process the current content so as to keep from redoing said content
			//stmt: var:
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
		//nest-loop:
		//nest-logic:
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
						//nest-loop:
						//nest-logic:
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
				AutoTabs = HandleTabs("logic",Tabs+"\t",OtherContent);

				if (AutoTabs != "")
				{
					LogicContent = LogicContent + GenCode(Tabs+"\t",AutoTabs);
					AutoTabs = "";
				}
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
					AutoTabs = HandleTabs("logic",Tabs+"\t",NewContent);
					if (AutoTabs != "")
					{
						LogicContent = LogicContent + GenCode(Tabs+"\t",AutoTabs);
						AutoTabs = "";
					}

					LogicContent = LogicContent + GenCode(Tabs+"\t",NewContent);
				}
			}
			//just process as is
			else
			{
				if (IsIn(OtherContent," parent-"))
				{
					//examine each tag
					std::vector<String> parent = split(OtherContent," parent-");
					OtherContent = "";
					int pEnd = len(parent);
					int pLp = 0;
					while (pLp != pEnd)
					{
						if ((pLp == 0) || (StartsWith(parent[pLp],"<-")) || (StartsWith(parent[pLp],"<<")))
						{
							if (OtherContent == "")
							{
								OtherContent = parent[pLp];
							}
							else
							{
								OtherContent = OtherContent + " " + TranslateTag(parent[pLp]);
							}
						}
						else
						{
							if (ParentContent == "")
							{
								ParentContent = TranslateTag(parent[pLp]);
							}
							else
							{
								ParentContent = ParentContent + " " + TranslateTag(parent[pLp]);
							}
						}
						pLp++;
					}
					ParentContent = ReplaceTag(ParentContent, "logic-",false);
				}
				//process the remaining nest-loop/logic
				AutoTabs = HandleTabs("logic",Tabs+"\t",OtherContent);
				if (AutoTabs != "")
				{
					LogicContent = LogicContent + GenCode(Tabs+"\t",AutoTabs);
					AutoTabs = "";
				}

				LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent);
			}

			//process parent content
			if (ParentContent != "")
			{
				//process the remaining nest-loop/logic
				AutoTabs = HandleTabs("logic",Tabs+"\t",ParentContent);
				if (AutoTabs != "")
				{
					LogicContent = LogicContent + GenCode(Tabs+"\t",AutoTabs);
					AutoTabs = "";
				}

				LogicContent = LogicContent + GenCode(Tabs+"\t",ParentContent);
				ParentContent = "";
			}

			//clear new content
			NewContent = "";
		}
		else if ((StartsWith(Content, "var:")) || (StartsWith(Content, "stmt:")))
		{
			//process the remaining nest-loop/logic
			AutoTabs = HandleTabs("logic",Tabs+"\t",Content);
			if (AutoTabs != "")
			{
				LogicContent = LogicContent + GenCode(Tabs+"\t",AutoTabs);
				AutoTabs = "";
			}

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
	else if (TheKindType == "case")
//	else if (TheKindType == "switch-case")
	{
		Complete = Tabs+"case "+TheCondition+":\n"+Tabs+"\t//code here\n"+Tabs+"\tbreak;\n";
	}
	else if (TheKindType == "switch")
//	else if (StartsWith(TheKindType, "switch"))
	{
//		String CaseContent = TheKindType;
//		String CaseVal;

		Complete = Tabs+"switch ("+TheCondition+")\n"+Tabs+"{\n";
/*
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
*/
		Complete = Complete+LogicContent+Tabs+"\tdefault:\n"+Tabs+"\t\t//code here\n"+Tabs+"}\n";
	}
	return Complete;
}

//stmt:
String Statements(String Tabs, String TheKindType, String Content)
{
	bool Last = false;
	String AutoTabs = "";
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

			if (OtherContent == "stmt:endline")
			{
				AutoTabs = HandleTabs("statements",Tabs,Content);
				if (AutoTabs != "")
				{
					StatementContent = StatementContent + GenCode(Tabs,AutoTabs);
					AutoTabs = "";
				}
			}
		}
	}

	//Pull Vector or Array Type
	if ((StartsWith(TheKindType,"<")) && (IsIn(TheKindType,">")))
	{
		String VorA = "";
		String VarType = "";
		String TheValue = "";

		//grab data type
		VarType = BeforeSplit(TheKindType,'>');
		VarType = AfterSplit(VarType,'<');
		VarType = AfterSplit(VarType,':');
		VarType = DataType(VarType,false);

		//vector or array
		VorA = BeforeSplit(TheKindType,':');
		VorA = AfterSplit(VorA,'<');

		TheName = VorA;

		//name of array
		Name = AfterSplit(TheKindType,'>');

		if (IsIn(Name,":"))
		{
			TheValue = AfterSplit(Name,':');
			Name = BeforeSplit(Name,':');
			Complete = VectAndArray(Name, VarType, VorA, "statement",GenCode("",TranslateTag(TheValue)))+StatementContent;
		}
		else
		{
			Complete = VectAndArray(Name, VarType, VorA, "statement","")+StatementContent;
		}
		//pull value
		TheKindType = "";
		TheName = "";
		Name = "";
		VarType = "";
	}
	else if (TheName == "method")
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
	print("[T] "+TheKindType);
	print("[C] "+Content);
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
	String AutoTabs = "";

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

			if (OtherContent == "stmt:endline")
			{
				AutoTabs = HandleTabs("variables",Tabs,Content);
				if (AutoTabs != "")
				{
					VariableContent = VariableContent + GenCode(Tabs,AutoTabs);
					AutoTabs = "";
				}
			}
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
	//Pull Vector or Array Type
	else if ((StartsWith(TheKindType,"<")) && (IsIn(TheKindType,">")))
	{
		String TheValue = "";
		String VorA = "";
		//grab data type
		VarType = BeforeSplit(TheKindType,'>');
		VarType = AfterSplit(VarType,'<');
		VarType = AfterSplit(VarType,':');
		VarType = DataType(VarType,false);

		//vector or array
		VorA = BeforeSplit(TheKindType,':');
		VorA = AfterSplit(VorA,'<');

		//name of array
		Name = AfterSplit(TheKindType,'>');

		if (IsIn(Name,":"))
		{
			TheValue = AfterSplit(Name,':');
			Name = BeforeSplit(Name,':');
			NewVar = VectAndArray(Name, VarType, VorA, "variable",GenCode("",TranslateTag(TheValue)));
		}
		else
		{
			NewVar = VectAndArray(Name, VarType, VorA, "variable","");
		}

		TheKindType = "";
		Name = "";
		VarType = "";
	}

	//Assign Value
	if ((IsIn(TheKindType,"=")) && (TheKindType != "="))
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
	else if (StartsWith(Args[0], "template:"))
	{
		TheCode = Template(Args[0],Args[1]);
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
	else if (StartsWith(Args[0], "point:"))
	{
		TheCode = Pointers(Tabs, Args[0], Args[1]);
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
//			UserIn = TranslateTag(UserIn);
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
			UserIn = raw_input("<<shell>> ");
			UserIn = TranslateTag(UserIn);
		}

		if (UserIn == "exit")
		{
			break;
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
