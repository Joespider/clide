import java.util.Scanner;
import java.io.InputStreamReader;
import java.io.InputStream;
import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;

/**
 *
 * @author joespider
 */

//class name
public class shell {
	private static String Version = "0.0.93";
	private static String TheKind = "";
	private static String TheName = "";
	private static String TheKindType = "";
	private static String TheDataType = "";
	private static String TheCondition = "";
	private static String Parameters = "";

	private static void Help(String Type)
	{
		Type = AfterSplit(Type,":");
		if (Type.equals("class"))
		{
			print("{Usage}");
			print("{}<name>:(<type>)<name> var(public/private):<vars> method:<name>-<type> param:<params>,<param>");
			print("");
			print("{EXAMPLE}");
			Example("{}pizza:(int)one,(bool)two,(float)three var(private):(int)toppings [String-mixture]cheese:(String)kind,(int)amount for: nest-for: [String]topping:(String)name,(int)amount if:good");
		}
		else if (Type.equals("struct"))
		{
			print("(<type>)<name>");
			print("");
			print(Type+":<name>-<type> var:<var> var:<var>");
		}
		else if (Type.equals("method"))
		{
			print("[<data>]<name>:<parameters>");
			print("[<data>-<return>]<name>:<parameters>");
			print("");
//			Example("[String]help:(String)one,(int)two");
//			Example("[String-Message]help:(String)one,(int)two");
//			Example("[String-Type]FoodAndDrink:(String)Food if:Food(-ne)\"\" >if:[IsDrink]:drink(-eq)true +->tab +->tab +->tab +->()Type=\"Drink\" +->el +->>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Drink]:Food o->>el +->else-if:[IsFood]:Food(-eq)true +->tab +->tab +->tab +->()Type=\"Food\" +->el >>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Eat]:Food o->>el >else +->tab +->tab +->tab +->()Eat= +->(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el else +-tab +-tab +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el");
//			Example("[String-Type]FoodAndDrink:(String)Food if:Food(-ne)\"\" >if:[IsDrink]:drink(-eq)true +->tab +->tab +->tab +->()Type=\"Drink\" +->el +->>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Drink]:Food o->>el >>if:mood(-ne)\"happy\" >>>do-while:mood(-eq)\"unhappy\" >>>>tab >>>>tab >>>>tab >>>>tab >>>>tab >>>>[ChearUp]:mood >>>>el +->else-if:[IsFood]:Food(-eq)true +->tab +->tab +->tab +->()Type=\"Food\" +->el >>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Eat]:Food o->>el >>if:mood(-ne)\"happy\" >>>do-while:mood(-eq)\"unhappy\" >>>>tab >>>>tab >>>>tab >>>>tab >>>>tab >>>>[ChearUp]:mood >>>>el >else +->tab +->tab +->tab +->(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el else +-tab +-tab +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el");
			Example("[String-Type]FoodAndDrink:(String)Food if:Food(-ne)\"\" >if:[IsDrink]:drink(-eq)true +->tab +->tab +->tab +->()Type=\"Drink\" +->el +->>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Drink]:Food o->>el >>if:mood(-ne)\"happy\" >>>do-while:mood(-eq)\"unhappy\" o->>>>tab o->>>>tab o->>>>tab o->>>>tab o->>>>tab o->>>>[ChearUp]:mood o->>>>el +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->else-if:[IsFood]:Food(-eq)true +->tab +->tab +->tab +->()Type=\"Food\" +->el >>while:[IsNotEmpty]:Food o->>tab o->>tab o->>tab o->>tab o->>[Eat]:Food o->>el >>if:mood(-ne)\"happy\" >>>do-while:mood(-eq)\"unhappy\" >>>>tab >>>>tab >>>>tab >>>>tab >>>>tab >>>>[ChearUp]:mood >>>>el +-[print]:\"I(-spc)am(-spc)\"+mood +-el >else +->tab +->tab +->tab +->(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el else +-tab +-tab +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el");
//			Example("[String-Type]FoodAndDrink:(String)Food if:Food(-ne)\"\" >if:[IsDrink]:drink(-eq)true >>tab >>tab >>tab >>()Type=\"Food\" >>el >>tab >>tab >>tab >>[Drink]:Food >>el >else-if:[IsFood]:Food(-eq)true +->>tab +->>tab +->>tab +->>()Type=\"Drink\" +->>el >>tab >>tab >>tab >>[Eat]:Food >>el >else +->tab +->tab +->tab +->(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +->el else +-tab +-tab +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el");
		}
		else if (Type.equals("loop"))
		{
			print("<type>:<param>");
			print("");
			print("{EXAMPLE}");
			print("for:");
			print("do-while:");
			print("while");
		}
		else if (Type.equals("logic"))
		{
			print("<logic>:<condition>");
			print("");
			Example("if:Type(-spc)==(-spc)\"String\"");
			Example("else-if:Type(-eq)\"String\"");
			Example("else");
			Example("if:true tab (String)drink= [Pop]:one,two el >if:[IsString]:drink(-eq)true >tab >tab >[drink]: >el >>if:drink(-eq)\"coke\" >>else >nl >else-if:[IsInt]:drink(-eq)false >nl >else >>if: >>nl >>else >nl");
			Example("if:true tab (String)drink= [Pop]:one,two el >if:[IsString]:drink(-eq)true >>if:drink(-eq)\"coke\" >>else >nl >else-if:[IsInt]:drink(-eq)false >nl >else >>if: >>nl >>else >nl");
//			print(Type+":switch");
		}
		else if (Type.equals("var"))
		{
			Example("(std::string)name=\"\" var:(int)point=0 stmt:endline var:james-std::string=\"James\" stmt:endline var:help-int");
			Example("(std::string)name=\"\" el (int)point=0 el (std::string)james=\"James\" el (int)help el help=0");
			Example("(std::string)name=\"\" el (int)point=0 el (std::string)james=\"James\" el (int)help el help=0");
		}
		else if (Type.equals("stmt"))
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

	//Get User input
	private static String raw_input(String Message)
	{
		String input = "";
		//User input from terminal
		Scanner UserIn = new Scanner(System.in);
		System.out.print(Message);
		input = UserIn.nextLine();
		return input;
	}

	//Print Output
	private static void print(Object out)
	{
		System.out.println(out);
	}

	private static String BeforeSplit(String Str, String splitAt)
	{
		if (Str.contains(splitAt))
		{
			if (splitAt.equals(")"))
			{
				String[] newString = split(Str, "\\)", 0);
				return newString[0];
			}
			else if (splitAt.equals("("))
			{
				String[] newString = split(Str, "\\(", 0);
				return newString[0];
			}
			else if (splitAt.equals("]"))
			{
				String[] newString = split(Str, "\\]", 0);
				return newString[0];
			}
			else if (splitAt.equals("["))
			{
				String[] newString = split(Str, "\\[", 0);
				return newString[0];
			}
			else
			{
				String[] newString = split(Str, splitAt, 0);
				return newString[0];
			}
		}
		else
		{
			return "";
		}
	}

	private static String AfterSplit(String Str, String splitAt)
	{
		if (Str.contains(splitAt))
		{
			StringBuilder SplitContent = new StringBuilder("");
			String[] newString;

			if (splitAt.equals(")"))
			{
				newString = split(Str, "\\)", 0);
			}
			else if (splitAt.equals("("))
			{
				newString = split(Str, "\\(", 0);
			}
			else if (splitAt.equals("]"))
			{
				newString = split(Str, "\\]", 0);
			}
			else if (splitAt.equals("["))
			{
				newString = split(Str, "\\[", 0);
			}
			else
			{
				newString = split(Str, splitAt, 0);
			}

			for (int lp = 1; lp < len(newString); lp++)
			{
				if (lp != 1)
				{
					SplitContent.append(splitAt);
				}
				SplitContent.append(newString[lp]);
			}
			return SplitContent.toString();
		}
		else
		{
			return "";
		}
	}

	private static String[] split(String message, String by)
	{
		String[] vArray = message.split(by);
		return vArray;
	}

	private static String[] split(String message, String by, int plc)
	{
		String[] vArray = message.split(by,plc);
		return vArray;
	}

	private static String replaceAll(String message, String sBy, String jBy)
	{
		String[] SplitMessage = split(message,sBy);
		String NewMessage = join(SplitMessage,jBy);
		return NewMessage;
	}

	private static String join(String[] Str, String ToJoin)
	{
		String message = String.join(ToJoin, Str);
		return message;
	}
	private static boolean IsIn(String Str, String Sub)
	{
		boolean found = false;
		if (Str.contains(Sub))
		{
			found = true;
		}
		return found;
	}

	//Check if string begins with substring
	private static boolean StartsWith(String Str, String Start)
	{
		boolean ItDoes = Str.startsWith(Start);
		return ItDoes;
	}

	//Check if string ends with substring
	private static boolean EndsWith(String Str, String Start)
	{
		boolean ItDoes = Str.endsWith(Start);
		return ItDoes;
	}

	//get array length
	private static int len(String[] array)
	{
		int length = array.length;
		return length;
	}

	//get string length
	private static int len(String word)
	{
		int length = word.length();
		return length;
	}

	//Append content to array
	private static String[] Append(String[] ArrayName, String content)
	{
		int i = ArrayName.length;
		//growing temp array
		String[] temp = new String[i];
		//copying ArrayName array into temp array.
		System.arraycopy(ArrayName, 0, temp, 0, i);
		//creating a new array
		ArrayName = new String[i+1];
		//copying temp array into ArrayName
		System.arraycopy(temp, 0, ArrayName, 0, i);
		//storing user input in the arrayn
		ArrayName[i] = content;
		return ArrayName;
	}

	private static String Shell(String command)
	{
		String ShellOut = "";
		Runtime r = Runtime.getRuntime();
		try
		{
			Process p = r.exec(command);
			InputStream in = p.getInputStream();
			BufferedInputStream buf = new BufferedInputStream(in);
			InputStreamReader inread = new InputStreamReader(buf);
			BufferedReader bufferedreader = new BufferedReader(inread);
			// Read the ls output
			String line;
			while ((line = bufferedreader.readLine()) != null)
			{
				if (ShellOut.equals(""))
				{
					// Print the content on the console
					ShellOut = line;
				}
				else
				{
					ShellOut = ShellOut+"\n"+line;
				}
			}
			// Check for ls failure
			try
			{
				if (p.waitFor() != 0)
				{
					System.err.println("exit value = " + p.exitValue());
				}
			}
			catch (InterruptedException e)
			{
				System.err.println(e);
			}
			finally
			{
				// Close the InputStream
				bufferedreader.close();
				inread.close();
				buf.close();
				in.close();
			}
		}
		catch (IOException e)
		{
			System.err.println(e.getMessage());
		}
		return ShellOut;
	}



/*
	----[shell]----
*/

	private static String ReplaceTag(String Content, String Tag, boolean All)
	{
		if ((IsIn(Content," ")) && (StartsWith(Content, Tag)))
		{

			boolean remove = true;
			StringBuilder NewContent = new StringBuilder("");
			String Next = "";
			String[] all_items = split(Content," ");
			int end = len(all_items);
			int lp = 0;
			while (lp != end)
			{
				Next = all_items[lp];
				//element starts with tag
				if (StartsWith(Next, Tag) && (remove == true))
				{
					//remove tag
					Next = AfterSplit(Next,"-");
					if (All)
					{
						remove = false;
					}
				}

				if (NewContent.toString().equals(""))
				{
					NewContent.append(Next);
				}
				else
				{
					NewContent.append(" ");
					NewContent.append(Next);
				}
				lp++;
			}
			Content = NewContent.toString();
		}
		//Parse Content as long as there is a Tag found at the beginning
		else if ((!IsIn(Content," ")) && (StartsWith(Content, Tag)))
		{
			//removing tag
			Content = AfterSplit(Content,"-");
		}
		return Content;
	}

	private static String getCpl()
	{
		return Shell("javac --version");
	}

	private static void banner()
	{
		String cplV = getCpl();
		String theOS = System.getProperty("os.name");
		print(cplV);
		print("[Java "+Version+"] on "+ theOS);
		print("Type \"help\" for more information.");
	}


	public static String TranslateTag(String Input)
	{
		StringBuilder TheReturn = new StringBuilder("");
		String Action = Input;
		String Value = "";
		String VarName = "";
		String NewTag = "";
		String TheDataType = "";
		StringBuilder Nest = new StringBuilder("");
		String ContentFor = "";
		String OldDataType = "";

		if (StartsWith(Action, "+-"))
		{
			Action = AfterSplit(Action,"-");
			ContentFor = "logic-";
		}
		else if (StartsWith(Action, "o-"))
		{
			Action = AfterSplit(Action,"-");
			ContentFor = "loop-";
		}
		else if (StartsWith(Action, "[]-"))
		{
			Action = AfterSplit(Action,"-");
			ContentFor = "method-";
		}
		else if (StartsWith(Action, "{}-"))
		{
			Action = AfterSplit(Action,"-");
			ContentFor = "class-";
		}

		// ">" becomes "nest-"
		while (StartsWith(Action, ">"))
		{
			Action = AfterSplit(Action,">");
			Nest.append("nest-");
		}

		if ((StartsWith(Action, "if:")) || (StartsWith(Action, "else-if:")))
		{
			Value = AfterSplit(Action,":");
			Action = BeforeSplit(Action,":");
			NewTag = "logic:"+Action;
			Value = "logic-condition:"+Value;

			TheReturn.append(ContentFor);
			TheReturn.append(Nest.toString());
			TheReturn.append(NewTag);
			TheReturn.append(" ");
			TheReturn.append(Value);
		}
		else if (Action.equals("else"))
		{
			NewTag = "logic:"+Action;
			TheReturn.append(ContentFor);
			TheReturn.append(Nest.toString());
			TheReturn.append(NewTag);
		}
		else if ((StartsWith(Action, "while:")) || (StartsWith(Action, "for:")) || (StartsWith(Action, "do-while:")))
		{
			Value = AfterSplit(Action,":");
			Action = BeforeSplit(Action,":");
			NewTag = "loop:"+Action;
			Value = "loop-condition:"+Value;

			TheReturn.append(ContentFor);
			TheReturn.append(Nest.toString());
			TheReturn.append(NewTag);
			TheReturn.append(" ");
			TheReturn.append(Value);
		}
		else if ((StartsWith(Action, "{")) && (IsIn(Action,"}")))
		{
			TheDataType = BeforeSplit(Action,"}");
			TheDataType = AfterSplit(TheDataType,"{");
			Action = AfterSplit(Action,"}");
			if (IsIn(Action,":"))
			{
				Value = AfterSplit(Action,":");
				Action = BeforeSplit(Action,":");
			}

			if (!(Value.equals("")))
			{
				TheReturn.append("class:");
				TheReturn.append(Action);
				TheReturn.append(" params:");
				TheReturn.append(Value);
			}
			else
			{
				TheReturn.append("class:");
				TheReturn.append(Action);
			}
		}
		else if ((StartsWith(Action, "[")) && (IsIn(Action,"]")))
		{
			TheDataType = BeforeSplit(Action,"]");
			TheDataType = AfterSplit(TheDataType,"[");
			Action = AfterSplit(Action,"]");
			//calling a function
			if (StartsWith(Action, ":"))
			{
				Value = AfterSplit(Action,":");
				Action = TheDataType;

				TheReturn.append(ContentFor);
				TheReturn.append(Nest.toString());
				TheReturn.append("stmt:method-");
				TheReturn.append(Action);
				TheReturn.append(" params:");
				TheReturn.append(Value);
			}
			//is a function
			else
			{
				TheDataType = DataType(TheDataType,false);
				if (IsIn(Action,":"))
				{
					Value = AfterSplit(Action,":");
					Action = BeforeSplit(Action,":");
				}

				if (!(Value.equals("")))
				{
					TheReturn.append(ContentFor);
					TheReturn.append(Nest.toString());
					TheReturn.append("method:(");
					TheReturn.append(TheDataType);
					TheReturn.append(")");
					TheReturn.append(Action);
					TheReturn.append(" params:");
					TheReturn.append(Value);
				}
				else
				{
					TheReturn.append(ContentFor);
					TheReturn.append(Nest.toString());
					TheReturn.append("method:(");
					TheReturn.append(TheDataType);
					TheReturn.append(")");
					TheReturn.append(Action);
				}
			}
		}
		else if ((StartsWith(Action, "(")) && (IsIn(Action,")")))
		{
			TheDataType = BeforeSplit(Action,")");
			TheDataType = AfterSplit(TheDataType,"(");
			Action = AfterSplit(Action,")");

			if (IsIn(Action,":"))
			{
				Value = AfterSplit(Action,":");
				Action = BeforeSplit(Action,":");
			}

			if (!(Value.equals("")))
			{
				//translate value, if needed
				Value = TranslateTag(Value);
//				Value = GenCode("",Value);
				TheReturn.append(ContentFor);
				TheReturn.append(Nest.toString());
				TheReturn.append("var:(");
				TheReturn.append(TheDataType);
				TheReturn.append(")");
				TheReturn.append(Action);
				TheReturn.append("= ");
				TheReturn.append(Value);
			}
			else
			{
				TheReturn.append(ContentFor);
				TheReturn.append(Nest.toString());
				TheReturn.append("var:(");
				TheReturn.append(TheDataType);
				TheReturn.append(")");
				TheReturn.append(Action);
			}
		}
		else if (Action.equals("el"))
		{
			TheReturn.append(ContentFor);
			TheReturn.append(Nest.toString());
			TheReturn.append("stmt:endline");
		}
		else if (Action.equals("nl"))
		{
			TheReturn.append(ContentFor);
			TheReturn.append(Nest.toString());
			TheReturn.append("stmt:newline");
		}
		else if (Action.equals("tab"))
		{
			TheReturn.append(ContentFor);
			TheReturn.append(Nest.toString());
			TheReturn.append("stmt:");
			TheReturn.append(Action);
		}
		else
		{
			if (!(Value.equals("")))
			{
				TheReturn.append(ContentFor);
				TheReturn.append(Nest.toString());
				TheReturn.append(Action);
				TheReturn.append(":");
				TheReturn.append(Value);
			}
			else
			{
				TheReturn.append(ContentFor);
				TheReturn.append(Nest.toString());
				TheReturn.append(Action);
			}
		}

		return TheReturn.toString();
	}

	public static String DataType(String Type, boolean getNull)
	{
		//handle strings
		if (((Type.equals("String")) || (Type.equals("string")) || (Type.equals("std::string"))) && (getNull == false))
		{
			return "String";
		}
		else if (((Type.equals("String")) || (Type.equals("string")) || (Type.equals("std::string"))) && (getNull == true))
		{
			return "\"\"";
		}
		else if (((Type.equals("boolean")) || (Type.equals("bool"))) && (getNull == false))
		{
			return "boolean";
		}
		else if (((Type.equals("boolean")) || (Type.equals("bool"))) && (getNull == true))
		{
			return "false";
		}
		else if ((Type.equals("false")) || (Type.equals("False")))
		{
			return "false";
		}
		else if ((Type.equals("true")) || (Type.equals("True")))
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
	private static String Conditions(String input,String CalledBy)
	{
		String Condit = AfterSplit(input,":");

		if (IsIn(Condit,"(-eq)\""))
		{
			Condit = replaceAll(Condit, "\\(-eq\\)\"",".equals(\"");
		}
		else if (IsIn(Condit,"(-eq)"))
		{
			Condit = replaceAll(Condit, "\\(-eq\\)"," == ");
		}

		if (IsIn(Condit,"(-le)"))
		{
			Condit = replaceAll(Condit, "\\(-le\\)"," <= ");
		}

		if (IsIn(Condit,"(-lt)"))
		{
			Condit = replaceAll(Condit, "\\(-lt\\)"," < ");
		}

		if (IsIn(Condit,"(-ne)"))
		{
			Condit = replaceAll(Condit, "\\(-ne\\)"," != ");
		}

		if (IsIn(Condit,"(-spc)"))
		{
			Condit = replaceAll(Condit, "\\(-spc\\)"," ");
		}

		if (IsIn(Condit," "))
		{
			String[] Conditions = split(Condit," ");
			int lp = 0;
			int end = len(Conditions);
			String Keep = "";
			while (lp != end)
			{
				Conditions[lp] = TranslateTag(Conditions[lp]);
				Keep = Conditions[lp];
				Conditions[lp] = GenCode("",Conditions[lp]);
				if (Conditions[lp].equals(""))
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

			if (Condit.equals(""))
			{
				Condit = OldCondit;
			}
		}

		if (IsIn(Condit,"(-not)"))
		{
			Condit = replaceAll(Condit, "\\(-not\\)","!");
		}

		if (IsIn(Condit,"(-or)"))
		{
			Condit = replaceAll(Condit, "\\(-or\\)",") || (");
			Condit = "("+Condit+")";
		}

		if (IsIn(Condit,"(-and)"))
		{
			Condit = replaceAll(Condit, "\\(-and\\)",") && (");
			Condit = "("+Condit+")";
		}

		//convert
		return Condit;
	}

	//params:
	private static String Parameters(String input,String CalledBy)
	{
		String Params = AfterSplit(input,":");

		if ((CalledBy.equals("class")) || (CalledBy.equals("method")) || (CalledBy.equals("stmt")))
		{
			//param-type,param-type,param-type
			if ((StartsWith(Params,"(")) && (IsIn(Params,")")) && (IsIn(Params,",")))
			{
				String Name = BeforeSplit(Params,",");
				String more = AfterSplit(Params,",");
				String Type = BeforeSplit(Name,")");

				Name = AfterSplit(Name,")");
				Type = AfterSplit(Type,"(");
				Type = DataType(Type,false);
				more = Parameters("params:"+more,CalledBy);
				Params = Type+" "+Name+", "+more;
			}
			//param-type
			else if ((StartsWith(Params,"(")) && (IsIn(Params,")")))
			{
				String Name = AfterSplit(Params,")");
				String Type = BeforeSplit(Params,")");

				Type = AfterSplit(Type,"(");
				Type = DataType(Type,false);
				Params = Type+" "+Name;
			}
		}
		return Params;
	}

	private static String Class(String TheName, String Content)
	{
		StringBuilder Complete = new StringBuilder("");
		String VarCount = "";
		String VarContent = "";
		String Process = "";
		String PublicOrPrivate = "public";
		if ((IsIn(TheName,"class(")) && (IsIn(TheName,"):")))
		{
			PublicOrPrivate = AfterSplit(TheName,"class");
			PublicOrPrivate = BeforeSplit(PublicOrPrivate,":");
			PublicOrPrivate = PublicOrPrivate.substring(1, PublicOrPrivate.length()-1);
		}

		TheName = AfterSplit(TheName,":");
		String Params = "";
		StringBuilder PrivateVars = new StringBuilder("");
		StringBuilder PublicVars = new StringBuilder("");
		StringBuilder ClassContent = new StringBuilder("");
		while (!Content.equals(""))
		{
			if ((StartsWith(Content, "params")) && (Params.equals("")))
			{
				Process = BeforeSplit(Content," ");
				Params =  Parameters(Process,"class");
			}
			else if (StartsWith(Content, "method"))
			{
				ClassContent.append(GenCode("",Content));
			}
			else if (StartsWith(Content, "var"))
			{
				if (StartsWith(Content, "var(public)"))
				{
					Content = AfterSplit(Content,")");
					VarContent = BeforeSplit(Content," ");
					VarContent = "var"+VarContent;
					PublicVars.append(GenCode("\t",VarContent));
				}
				else if (StartsWith(Content, "var(private)"))
				{
					Content = AfterSplit(Content,")");
					VarContent = BeforeSplit(Content," ");
					VarContent = "var"+VarContent;
					PrivateVars.append(GenCode("\t",VarContent));
				}
			}
			if (IsIn(Content," "))
			{
				Content = AfterSplit(Content," ");
			}
			else
			{
				break;
			}
		}

		Complete.append(PublicOrPrivate);
		Complete.append(" class ");
		Complete.append(TheName);
		Complete.append(" {\n");
		Complete.append(PublicVars.toString());
		Complete.append(PrivateVars.toString());
		Complete.append("\n\t//class constructor\n\tpublic ");
		Complete.append(TheName);
		Complete.append("(");
		Complete.append(Params);
		Complete.append(")\n\t{\n\t\tthis.x = x;\n\t\tthis.y = y;\n\t}\n\n");
		Complete.append(ClassContent.toString());
		Complete.append("\n}\n");

		return Complete.toString();
	}

	//method:
	private static String Method(String Tabs, String Name, String Content)
	{
		boolean Last = false;
		boolean CanSplit = true;
		String ReturnVar = "TheReturn";
		String DefaultValue = "";
		StringBuilder Complete = new StringBuilder("");
		Name = AfterSplit(Name,":");

		String PublicOrPrivate = "public";

		if ((IsIn(Name,"method(")) && (IsIn(Name,"):")))
		{
			PublicOrPrivate = AfterSplit(Name,"method");
			PublicOrPrivate = BeforeSplit(PublicOrPrivate,":");
			PublicOrPrivate = PublicOrPrivate.substring(1, PublicOrPrivate.length()-1);
		}

		String TheName = "";
		String Type = "";
		String Params = "";
		StringBuilder MethodContent = new StringBuilder("");
		StringBuilder OtherContent = new StringBuilder("");
		StringBuilder NewContent = new StringBuilder("");
		String Process = "";

		//method:(<type>)<name>
		if ((StartsWith(Name,"(")) && (IsIn(Name,")")))
		{
			Type = BeforeSplit(Name,")");
			Type = AfterSplit(Type,"(");
			//get method name
			TheName = AfterSplit(Name,")");
			if (IsIn(Name,"-"))
			{
				ReturnVar = AfterSplit(Type,"-");
				Type = BeforeSplit(Type,"-");
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

		while (!Content.equals(""))
		{
			//params:
			if ((StartsWith(Content, "params:")) && (Params.equals("")))
			{
				if (IsIn(Content," "))
				{
					Process = BeforeSplit(Content," ");
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
					String[] cmds = split(Content," method:");
					Content = cmds[0];
				}

				if (StartsWith(Content, "method-"))
				{
					String[] all = split(Content," ");
					boolean noMore = false;
					int lp = 0;
					int end = len(all);
					while (lp != end)
					{
						//This processes ONLY method-<content>
						if ((StartsWith(all[lp], "method-")) && (noMore == false))
						{
							if (OtherContent.equals(""))
							{
								OtherContent = new StringBuilder(all[lp]);
							}
							else
							{
								OtherContent.append(" ");
								OtherContent.append(all[lp]);
							}
						}
						else
						{
							if (NewContent.equals(""))
							{
								NewContent = new StringBuilder(all[lp]);
							}
							else
							{
								NewContent.append(" ");
								NewContent.append(all[lp]);
							}
							noMore = true;
						}
						lp++;
					}
					CanSplit = false;
				}
				else
				{
					OtherContent = new StringBuilder(Content);
					CanSplit = true;
				}

//				OtherContent = ReplaceTag(OtherContent, "method-");

				StringBuilder ParseContent = new StringBuilder("");
				String Corrected = "";

				String[] cmds = split(OtherContent.toString()," ");
				int end = len(cmds);
				int lp = 0;
				while (lp != end)
				{
					Corrected = ReplaceTag(cmds[lp], "method-",false);
					//starts with "logic:" or "loop:"
					if ((StartsWith(Corrected,"logic:")) || (StartsWith(Corrected,"loop:")) || (StartsWith(Corrected,"var:")) || (StartsWith(Corrected,"stmt:")))
					{
						//Only process code that starts with "logic:" or "loop:"
						if (!ParseContent.toString().equals(""))
						{
							//process content
							MethodContent.append(GenCode(Tabs+"\t",ParseContent.toString()));
						}
						//Reset content
						ParseContent = new StringBuilder(Corrected);
					}
					//start another line to process
					else
					{
						//append content
						ParseContent.append(" ");
						ParseContent.append(Corrected);
					}
					lp++;
				}

				//process the rest
				if (!ParseContent.toString().equals(""))
				{
					OtherContent = new StringBuilder(ParseContent.toString());
				}

				MethodContent.append(GenCode(Tabs+"\t",OtherContent.toString()));
				Content = NewContent.toString();

				OtherContent = new StringBuilder("");
				NewContent = new StringBuilder("");
			}
			if (Last)
			{
				break;
			}

			if (IsIn(Content," "))
			{
				if (CanSplit)
				{
					Content = AfterSplit(Content," ");
				}
			}
			else
			{
				Content = "";
				Last = true;
			}
		}

		if ((Type.equals("")) || (Type.equals("void")) || (Type.equals(TheName)))
		{
			Complete.append(Tabs);
			Complete.append("\t");
			Complete.append(PublicOrPrivate);
			Complete.append(" static void ");
			Complete.append(TheName);
			Complete.append("(");
			Complete.append(Params);
			Complete.append(")\n");
			Complete.append(Tabs);
			Complete.append("\t{\n");
			Complete.append(MethodContent.toString());
			Complete.append("\n");
			Complete.append(Tabs);
			Complete.append("\t}\n");
		}
		else
		{
			if (DefaultValue.equals(""))
			{
				Complete.append(Tabs);
				Complete.append("\t");
				Complete.append(PublicOrPrivate);
				Complete.append(" static ");
				Complete.append(Type);
				Complete.append(" ");
				Complete.append(TheName);
				Complete.append("(");
				Complete.append(Params);
				Complete.append(")\n");
				Complete.append(Tabs);
				Complete.append("\t{\n");
				Complete.append(Tabs);
				Complete.append("\t\t");
				Complete.append(Type);
				Complete.append(" ");
				Complete.append(ReturnVar);
				Complete.append(";\n");
				Complete.append(MethodContent.toString());
				Complete.append("\n");
				Complete.append(Tabs);
				Complete.append("\t\treturn ");
				Complete.append(ReturnVar);
				Complete.append(";\n");
				Complete.append(Tabs);
				Complete.append("\t}\n");
			}
			else
			{
				Complete.append(Tabs);
				Complete.append("\t");
				Complete.append(PublicOrPrivate);
				Complete.append(" static ");
				Complete.append(Type);
				Complete.append(" ");
				Complete.append(TheName);
				Complete.append("(");
				Complete.append(Params);
				Complete.append(")\n");
				Complete.append(Tabs);
				Complete.append("\t{\n");
				Complete.append(Tabs);
				Complete.append("\t\t");
				Complete.append(Type);
				Complete.append(" ");
				Complete.append(ReturnVar);
				Complete.append(" = ");
				Complete.append(DefaultValue);
				Complete.append(";\n");
				Complete.append(MethodContent.toString());
				Complete.append("\n");
				Complete.append(Tabs);
				Complete.append("\t\treturn ");
				Complete.append(ReturnVar);
				Complete.append(";\n");
				Complete.append(Tabs);
				Complete.append("\t}\n");
			}
		}

		return Complete.toString();
	}

	//loop:
	private static String Loop(String Tabs, String TheKindType, String Content)
	{
/*
		print(TheKindType);
		print(Content);
		print("");
*/
		boolean Last = false;
		StringBuilder Complete = new StringBuilder("");
		String RootTag = "";
		String TheCondition = "";
		StringBuilder LoopContent = new StringBuilder("");
		StringBuilder OtherContent = new StringBuilder("");
		StringBuilder NewContent = new StringBuilder("");

		//loop:<type>
		if (StartsWith(TheKindType, "loop:"))
		{
			//loop
			TheKindType = AfterSplit(TheKindType,":");
		}

		//content for loop
		while (!Content.equals(""))
		{
			Content = ReplaceTag(Content, "loop-",false);
//			Content = ReplaceTag(Content, "loop-",true);

			if (StartsWith(Content, "condition"))
			{
				if (IsIn(Content," "))
				{
					TheCondition = BeforeSplit(Content," ");
					Content = AfterSplit(Content," ");
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
				String[] all = split(Content," nest-");
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
						OtherContent = new StringBuilder(all[lp]);
					}
					//The remaining content is for the next loop
					//nest-<type> <other content> nest-<type> <other content>
					else if (lp == 1)
					{

						NewContent.append("nest-");
						NewContent.append(all[lp]);
					}
					else
					{
						NewContent.append(" nest-");
						NewContent.append(all[lp]);
					}
					lp++;
				}
				//Generate the loop content
				LoopContent.append(GenCode(Tabs+"\t",OtherContent.toString()));
				//The remaning content gets processed
				Content = NewContent.toString();
				//reset old and new content
				OtherContent = new StringBuilder("");
				NewContent = new StringBuilder("");
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
				RootTag = BeforeSplit(Content,"l");
				//check of " nest-l" is in content
				if (IsIn(Content," "+RootTag+"l"))
				{
					//This section is meant to separate the "nest-loop" from the "nest-logic"
					//loops won't process logic and vise versa

					//split string wherever a " nest-l" is located
					//ALL "nest-l" are ignored...notice there is no space before the "nest-l"
					String[] cmds = split(Content," "+RootTag+"l");
					int end = len(cmds);
					int lp = 0;
					while (lp != end)
					{
						if (lp == 0)
						{
							OtherContent = new StringBuilder(cmds[lp]);
						}
						else
						{
							if (NewContent.toString().equals(""))
							{
								NewContent.append(RootTag);
								NewContent.append("l");
								NewContent.append(cmds[lp]);
							}
							else
							{
								NewContent.append(" ");
								NewContent.append(RootTag);
								NewContent.append("l");
								NewContent.append(cmds[lp]);
							}
						}
						lp++;
					}
				}

				//no " nest-l" found
				else
				{
					OtherContent = new StringBuilder(Content);
				}

				Content = NewContent.toString();

				//"nest-loop" and "nest-nest-loop" becomes "loop"
				while (StartsWith(OtherContent.toString(), "nest-"))
				{
					OtherContent = new StringBuilder(AfterSplit(OtherContent.toString(),"-"));
				}

				//handle the content if the first tag is a stmt: or var:
				if (((StartsWith(OtherContent.toString(), "stmt:") || StartsWith(OtherContent.toString(), "var:")) && IsIn(OtherContent.toString()," ")))
				{
					//examine each tag
					String[] cmds = split(OtherContent.toString()," ");
					OtherContent = new StringBuilder("");
					NewContent = new StringBuilder("");
					int end = len(cmds);
					int lp = 0;
					while (lp != end)
					{
						//as long as the beginning of the tag is stmt:, var:, or params: make sure to build the non-loop/logic tags
						if ((IsIn(cmds[lp],"stmt:") || IsIn(cmds[lp],"var:") || IsIn(cmds[lp],"params:")) && (NewContent.toString().equals("")))
						{
							if (OtherContent.toString().equals(""))
							{
								OtherContent.append(cmds[lp]);
							}
							else
							{
								OtherContent.append(" ");
								OtherContent.append(cmds[lp]);
							}
						}
						//build the rest of the content
						else
						{
							if (NewContent.toString().equals(""))
							{
								NewContent.append(cmds[lp]);
							}
							else
							{
								NewContent.append(" ");
								NewContent.append(cmds[lp]);
							}
						}
						lp++;
					}

					//processes all the statements before a loop/logic
					LoopContent.append(GenCode(Tabs+"\t",OtherContent.toString()));

					//Lets group the nested tages one more time...I am not sure how to avoide this being done again
					if (StartsWith(NewContent.toString(), "nest-"))
					{
						RootTag = BeforeSplit(NewContent.toString(),"l");
						if (IsIn(NewContent.toString()," "+RootTag+"l"))
						{
							//split up the loops and logic accordingly
							cmds = split(NewContent.toString()," "+RootTag+"l");
							NewContent = new StringBuilder("");
							end = len(cmds);
							lp = 0;
							while (lp != end)
							{
								if (lp == 0)
								{
									OtherContent = new StringBuilder(cmds[lp]);
									//remove all nest-
									while (StartsWith(OtherContent.toString(), "nest-"))
									{
										OtherContent = new StringBuilder(AfterSplit(OtherContent.toString(),"-"));
									}
									//process loop/logic
									LoopContent.append(GenCode(Tabs+"\t",OtherContent.toString()));
								}
								else
								{
									if (NewContent.toString().equals(""))
									{
										NewContent.append("l");
										NewContent.append(cmds[lp]);
									}
									else
									{
										NewContent.append(" ");
										NewContent.append(RootTag);
										NewContent.append("l");
										NewContent.append(cmds[lp]);
									}
								}
								lp++;
							}
						}

						while (StartsWith(NewContent.toString(), "nest-"))
						{
							NewContent = new StringBuilder(AfterSplit(NewContent.toString(),"-"));
						}
						//process the remaining nest-loop/logic
						LoopContent.append(GenCode(Tabs+"\t",NewContent.toString()));
					}
				}
				//just process as is
				else
				{
					LoopContent.append(GenCode(Tabs+"\t",OtherContent.toString()));
				}
				//clear new content
				NewContent = new StringBuilder("");
			}
			else if ((StartsWith(Content, "var:")) || (StartsWith(Content, "stmt:")))
			{
//				Content = ReplaceTag(Content, "loop-",true);
				LoopContent.append(GenCode(Tabs+"\t",Content));
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
		if (TheKindType.equals("for"))
		{
			Complete.append(Tabs);
			Complete.append("for (");
			Complete.append(TheCondition);
			Complete.append(")\n");
			Complete.append(Tabs);
			Complete.append("{\n");
			Complete.append(LoopContent);
			Complete.append(Tabs);
			Complete.append("}\n");
		}
		//loop:do/while
		else if (TheKindType.equals("do/while"))
		{
			Complete.append(Tabs);
			Complete.append("do\n");
			Complete.append(Tabs);
			Complete.append("{\n");
			Complete.append(LoopContent);
			Complete.append(Tabs);
			Complete.append("}\n");
			Complete.append(Tabs);
			Complete.append("while (");
			Complete.append(TheCondition);
			Complete.append(");\n");
		}
		//loop:while
		else
		{
			Complete.append(Tabs);
			Complete.append("while (");
			Complete.append(TheCondition);
			Complete.append(")\n");
			Complete.append(Tabs);
			Complete.append("{\n");
			Complete.append(LoopContent);
			Complete.append(Tabs);
			Complete.append("}\n");
		}

		return Complete.toString();
	}

	//logic:
	private static String Logic(String Tabs, String TheKindType, String Content)
	{
/*
		print("[T] "+TheKindType);
		print("[C] "+Content);
		print("");
*/
		boolean Last = false;
		StringBuilder Complete = new StringBuilder("");
		String RootTag = "";
		String TheCondition = "";
		StringBuilder LogicContent = new StringBuilder("");
		StringBuilder OtherContent = new StringBuilder("");
		StringBuilder NewContent = new StringBuilder("");

		if (StartsWith(TheKindType, "logic:"))
		{
			TheKindType = AfterSplit(TheKindType,":");
		}

		while (!Content.equals(""))
		{
			Content = ReplaceTag(Content, "logic-",false);
//			Content = ReplaceTag(Content, "logic-",true);

			if (StartsWith(Content, "condition"))
			{
				if (IsIn(Content," "))
				{
					TheCondition = BeforeSplit(Content," ");
					Content = AfterSplit(Content," ");
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
				String[] all = split(Content," nest-");
				int end = len(all);
				int lp = 0;
				while (lp != end)
				{
					if (lp == 0)
					{
						OtherContent.append(all[lp]);
					}
					else if (lp == 1)
					{
						NewContent.append("nest-");
						NewContent.append(all[lp]);
					}
					else
					{
						NewContent.append(" nest-");
						NewContent.append(all[lp]);
					}
					lp++;
				}
				//Process the current content so as to keep from redoing said content
				LogicContent.append(GenCode(Tabs+"\t",OtherContent.toString()));
				Content = NewContent.toString();
				OtherContent = new StringBuilder("");
				NewContent = new StringBuilder("");
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
				RootTag = BeforeSplit(Content,"l");
				if (IsIn(Content," "+RootTag+"l"))
				{
					//split up the loops and logic accordingly
					String[] cmds = split(Content," "+RootTag+"l");
					int end = len(cmds);
					int lp = 0;
					while (lp != end)
					{
						//process now
						if (lp == 0)
						{
							//this tag already contains the nest-logic or nest-loop
							//this will be processed and the following will be ignored for the next recurrsive cycle
							OtherContent = new StringBuilder(cmds[lp]);
						}
						//process later
						else
						{
							//build the next elements
							if (NewContent.equals(""))
							{
								//put back in the nest-l
								NewContent.append(RootTag);
								NewContent.append("l");
								NewContent.append(cmds[lp]);
							}
							else
							{
								//put back in the nest-l and append
								NewContent.append(" ");
								NewContent.append(RootTag);
								NewContent.append("l");
								NewContent.append(cmds[lp]);
							}
						}
						lp++;
					}
				}
				//no need to split nested
				else
				{
					OtherContent = new StringBuilder(Content);
				}

				//the new content will be looped
				Content = NewContent.toString();

				//remove all nest- tags from content
				while (StartsWith(OtherContent.toString(), "nest-"))
				{
					OtherContent = new StringBuilder(AfterSplit(OtherContent.toString(),"-"));
				}

				//handle the content if the first tag is a stmt: or var:
				if (((StartsWith(OtherContent.toString(), "stmt:") || StartsWith(OtherContent.toString(), "var:")) && IsIn(OtherContent.toString()," ")))
				{
					//examine each tag
					String[] cmds = split(OtherContent.toString()," ");
					OtherContent = new StringBuilder("");
					NewContent = new StringBuilder("");
					int end = len(cmds);
					int lp = 0;
					while (lp != end)
					{
						//as long as the beginning of the tag is stmt:, var:, or params: make sure to build the non-loop/logic tags
						if ((IsIn(cmds[lp],"stmt:") || IsIn(cmds[lp],"var:") || IsIn(cmds[lp],"params:")) && (NewContent.toString().equals("")))
						{
							if (OtherContent.toString().equals(""))
							{
								OtherContent = new StringBuilder("");
							}
							else
							{
								OtherContent.append(" ");
								OtherContent.append(cmds[lp]);
							}
						}
						//build the rest of the content
						else
						{
							if (NewContent.toString().equals(""))
							{
								NewContent = new StringBuilder(cmds[lp]);
							}
							else
							{
								NewContent.append(" ");
								NewContent.append(cmds[lp]);
							}
						}
						lp++;
					}

					//processes all the statements before a loop/logic
					LogicContent.append(GenCode(Tabs+"\t",OtherContent.toString()));

					//Lets group the nested tages one more time...I am not sure how to avoide this being done again
					if (StartsWith(NewContent.toString(), "nest-"))
					{
						RootTag = BeforeSplit(NewContent.toString(),"l");
						if (IsIn(NewContent.toString()," "+RootTag+"l"))
						{
							//split up the loops and logic accordingly
							cmds = split(NewContent.toString()," "+RootTag+"l");
							NewContent = new StringBuilder("");
							end = len(cmds);
							lp = 0;
							while (lp != end)
							{
								if (lp == 0)
								{
									OtherContent = new StringBuilder(cmds[lp]);
									//remove all nest-
									while (StartsWith(OtherContent.toString(), "nest-"))
									{
										OtherContent = new StringBuilder(AfterSplit(OtherContent.toString(),"-"));
									}
									//process loop/logic
									LogicContent.append(GenCode(Tabs+"\t",OtherContent.toString()));
								}
								else
								{
									if (NewContent.equals(""))
									{
										NewContent = new StringBuilder(RootTag);
										NewContent.append("l");
										NewContent.append(cmds[lp]);
									}
									else
									{
										NewContent.append(" ");
										NewContent.append(RootTag);
										NewContent.append("l");
										NewContent.append(cmds[lp]);
									}
								}
								lp++;
							}
						}
						//remove all nest-
						while (StartsWith(NewContent.toString(), "nest-"))
						{
							NewContent = new StringBuilder(AfterSplit(NewContent.toString(),"-"));
						}
						//process the remaining nest-loop/logic
						LogicContent.append(GenCode(Tabs+"\t",NewContent.toString()));

					}
				}
				//just process as is
				else
				{
					LogicContent.append(GenCode(Tabs+"\t",OtherContent.toString()));
				}
				//clear new content
				NewContent = new StringBuilder("");
			}
			else if ((StartsWith(Content, "var:")) || (StartsWith(Content, "stmt:")))
			{
//				Content = ReplaceTag(Content, "logic-",false);
				LogicContent.append(GenCode(Tabs+"\t",Content));
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

		if (TheKindType.equals("if"))
		{
			Complete.append(Tabs);
			Complete.append("if (");
			Complete.append(TheCondition);
			Complete.append(")\n");
			Complete.append(Tabs);
			Complete.append("{\n");
			Complete.append(LogicContent.toString());
			Complete.append(Tabs);
			Complete.append("}\n");
		}
		else if (TheKindType.equals("else-if"))
		{
			Complete.append(Tabs);
			Complete.append("else if (");
			Complete.append(TheCondition);
			Complete.append(")\n");
			Complete.append(Tabs);
			Complete.append("{\n");
			Complete.append(LogicContent.toString());
			Complete.append(Tabs);
			Complete.append("}\n");
		}
		else if (TheKindType.equals("else"))
		{
			Complete.append(Tabs);
			Complete.append("else\n");
			Complete.append(Tabs);
			Complete.append("{\n");
			Complete.append(LogicContent.toString());
			Complete.append(Tabs);
			Complete.append("}\n");
		}
		else if (TheKindType.equals("switch-case"))
		{
			Complete.append(Tabs);
			Complete.append("\tcase x:\n");
			Complete.append(Tabs);
			Complete.append("\t\t//code here\n");
			Complete.append(Tabs);
			Complete.append("\t\tbreak;");

		}
		else if (StartsWith(TheKindType, "switch"))
		{
			String CaseContent = TheKindType;
			String CaseVal;

			Complete.append(Tabs);
			Complete.append("switch (");
			Complete.append(TheCondition);
			Complete.append(")\n");
			Complete.append(Tabs);
			Complete.append("{\n\n");
			while (!CaseContent.equals(""))
			{
				CaseVal = BeforeSplit(CaseContent,"-");
				if (CaseVal.equals("switch"))
				{
					Complete.append(Tabs);
					Complete.append("\tcase ");
					Complete.append(CaseVal);
					Complete.append(":\n");
					Complete.append(Tabs);
					Complete.append("\t\t//code here\n");
					Complete.append(Tabs);
					Complete.append("\t\tbreak;\n");
				}

				if (IsIn(CaseContent,"-"))
				{
					CaseContent = AfterSplit(CaseContent,"-");
				}
			}
			Complete.append(Tabs);
			Complete.append("\tdefault:\n");
			Complete.append(Tabs);
			Complete.append("\t\t//code here\n");
			Complete.append(Tabs);
			Complete.append("\t\tbreak;\n");
			Complete.append(Tabs);
			Complete.append("}\n");
		}
		return Complete.toString();
	}


	//stmt:
	private static String Statements(String Tabs, String TheKindType, String Content)
	{
		boolean Last = false;
		StringBuilder Complete = new StringBuilder("");
		StringBuilder StatementContent = new StringBuilder("");
		StringBuilder OtherContent = new StringBuilder("");
		String TheName = "";
		String Name = "";
		String Process = "";
		String Params = "";

		if (StartsWith(TheKindType, "stmt:"))
		{
			TheKindType = AfterSplit(TheKindType,":");
		}

		if (IsIn(TheKindType,"-"))
		{
			TheName = BeforeSplit(TheKindType,"-");
			Name = AfterSplit(TheKindType,"-");
		}
		else
		{
			TheName = TheKindType;
		}

		while (!Content.equals(""))
		{
			//This handles the parameters of the statements
			if ((StartsWith(Content, "params:")) && (Params == ""))
			{
				if (IsIn(Content," "))
				{
					Process = BeforeSplit(Content," ");
				}
				else
				{
					Process = Content;
				}
				Params = Parameters(Process,"stmt");

				if (IsIn(Params,"(-spc)"))
				{
					Params = replaceAll(Params, "\\(-spc\\)"," ");
				}
			}

			if (Last)
			{
				break;
			}

			while (StartsWith(Content, "nest-"))
			{
				Content = AfterSplit(Content,"-");
			}

			if (!IsIn(Content," "))
			{
				StatementContent.append(GenCode(Tabs,Content));
				Last = true;
			}
			else
			{
				OtherContent = new StringBuilder(BeforeSplit(Content," "));
				Content = AfterSplit(Content," ");
				if (StartsWith(Content, "params:"))
				{
					OtherContent.append(" ");
					OtherContent.append(BeforeSplit(Content," "));
					Content = AfterSplit(Content," ");
				}

				if ((StartsWith(OtherContent.toString(),"loop:") && (!Content.equals(""))) || (StartsWith(OtherContent.toString(),"logic:") && (!Content.equals(""))))
				{
					OtherContent.append(" ");
					OtherContent.append(Content);
					Content = "";
				}
				StatementContent.append(GenCode(Tabs,OtherContent.toString()));
			}
		}


		if (TheName.equals("method"))
		{
			Complete.append(Name);
			Complete.append("(");
			Complete.append(Params);
			Complete.append(")");
			Complete.append(StatementContent.toString());
		}
		else if (TheName.equals("comment"))
		{
			Complete.append(StatementContent.toString());
			Complete.append(Tabs);
			Complete.append("#Code goes here\n");
		}
		else if (TheName.equals("endline"))
		{
			Complete.append(StatementContent.toString());
			Complete.append(";\n");
		}
		else if (TheName.equals("newline"))
		{
			Complete.append(StatementContent.toString());
			Complete.append("\n");
		}
		else if (TheName.equals("tab"))
		{
			Complete.append("\t");
			Complete.append(StatementContent.toString());
		}

		return Complete.toString();
	}



	//var:
	private static String Variables(String Tabs, String TheKindType, String Content)
	{
/*
		print(TheKindType);
		print(Content);
		print("");
*/
		boolean Last = false;
		boolean MakeEqual = false;
		StringBuilder NewVar = new StringBuilder("");
		String Name = "";
		String VarType = "";
		String Value = "";
		StringBuilder VariableContent = new StringBuilder("");
		StringBuilder OtherContent = new StringBuilder("");

		if (StartsWith(TheKindType, "var:"))
		{
			TheKindType = AfterSplit(TheKindType,":");
		}

		while (!Content.equals(""))
		{
			//All params are removed

			if (Last)
			{
				break;
			}

			while (StartsWith(Content, "nest-"))
			{
				Content = AfterSplit(Content,"-");
			}

			if (!IsIn(Content," "))
			{
				VariableContent.append(GenCode(Tabs,Content));
				Last = true;
			}
			else
			{
				OtherContent = new StringBuilder(BeforeSplit(Content," "));
				Content = AfterSplit(Content," ");
				if (StartsWith(Content, "params:"))
				{
					OtherContent.append(" ");
					OtherContent.append(BeforeSplit(Content," "));
					Content = AfterSplit(Content," ");
				}

				if ((StartsWith(OtherContent.toString(),"loop:") && (!Content.equals(""))) || (StartsWith(OtherContent.toString(),"logic:") && (!Content.equals(""))))
				{
					OtherContent.append(" ");
					OtherContent.append(Content);
					Content = "";
				}
				VariableContent.append(GenCode(Tabs,OtherContent.toString()));
			}
		}

		//Pull Variable Type
		if ((StartsWith(TheKindType,"(")) && (IsIn(TheKindType,")")))
		{
			VarType = BeforeSplit(TheKindType,")");
			VarType = AfterSplit(VarType,"(");
			VarType = DataType(VarType,false);
			TheKindType = AfterSplit(TheKindType,")");
			Name = TheKindType;
		}

		//Assign Value
		if (IsIn(TheKindType,"="))
		{
			MakeEqual = true;
			Name = BeforeSplit(TheKindType,"=");
			Value = AfterSplit(TheKindType,"=");
		}

		if (!VarType.equals(""))
		{
			NewVar.append(VarType);
			NewVar.append(" ");
		}

		if (MakeEqual == true)
		{
			if (IsIn(Value,"(-spc)"))
			{
				Value = replaceAll(Value, "\\(-spc\\)"," ");
			}

			NewVar.append(Name);
			NewVar.append(" = ");
			NewVar.append(Value);
		}
		else
		{
			NewVar.append(Name);
		}
		NewVar.append(VariableContent.toString());

		return NewVar.toString();
	}

	private static void Example(String tag)
	{
		print("\t{EXAMPLE}");
		print("Command: "+tag);
//		print("\t---or---");
		String Result;
		StringBuilder UserIn = new StringBuilder("");
		if (IsIn(tag," "))
		{
			String[] all = split(tag," ");
			int end = len(all);
			int lp = 0;
			while (lp != end)
			{
				if (UserIn.toString().equals(""))
				{
					UserIn.append(TranslateTag(all[lp]));
				}
				else
				{
					UserIn.append(" ");
					UserIn.append(TranslateTag(all[lp]));
				}
				lp++;
			}
		}
//		print("Command: "+UserIn);
		print("");
		Result = GenCode("",UserIn.toString());
		print("\t{OUTPUT}");
		print(Result);
	}

	private static String GenCode(String Tabs,String GetMe)
	{
		StringBuilder TheCode = new StringBuilder("");
		String[] Args = new String[2];
		if (IsIn(GetMe," "))
		{
			Args[0] = BeforeSplit(GetMe," ");
			Args[1] = AfterSplit(GetMe," ");
		}
		else
		{
			Args[0] = GetMe;
			Args[1] = "";
		}

		if (StartsWith(Args[0], "class:"))
		{
			TheCode.append(Class(Args[0],Args[1]));
		}
		else if (StartsWith(Args[0], "method:"))
		{
			TheCode.append(Method(Tabs,Args[0],Args[1]));
		}
		else if (StartsWith(Args[0], "loop:"))
		{
			TheCode.append(Loop(Tabs,Args[0],Args[1]));
		}
		else if (StartsWith(Args[0], "logic:"))
		{
			TheCode.append(Logic(Tabs, Args[0], Args[1]));
		}
		else if (StartsWith(Args[0], "var:"))
		{
			TheCode.append(Variables(Tabs, Args[0], Args[1]));
		}
		else if (StartsWith(Args[0], "stmt:"))
		{
			TheCode.append(Statements(Tabs, Args[0], Args[1]));
		}
/*
		else if (StartsWith(Args[0], "condition"))
		{
			TheCode.append(Conditions(Args[0]));
		}
		else if (StartsWith(Args[0], "params"))
		{
			TheCode.append(Parameters(Args[0]));
		}
*/
		return TheCode.toString();
	}

	/**
	* @param args the command line arguments
	*/
	public static void main(String[] args)
	{
		int length;
		int numOfArgs = len(args);
		String UserIn = "";
		String Content = "";
		if (len(args) == 0)
		{
			banner();
		}
		else
		{
			StringBuilder ArgUserIn = new StringBuilder("");
			ArgUserIn.append(TranslateTag(args[0]));
			for (int lp = 1; lp < numOfArgs; lp++)
			{
				ArgUserIn.append(" ");
				ArgUserIn.append(TranslateTag(args[lp]));
			}
			UserIn = ArgUserIn.toString();
		}

		while (true)
		{
			if (len(args) == 0)
			{
				UserIn = raw_input(">>> ");
			}

			if (UserIn.equals("exit()"))
			{
				break;
			}
			else if (UserIn.equals("exit"))
			{
				print("Use exit()");
			}
/*
			else if (UserIn.equals("clear"))
			{
				clear();
			}
*/
			else if (((UserIn.equals("-v")) && (len(args) >= 1)) || ((UserIn.equals("--version")) && (len(args) >= 1)) || ((UserIn.equals("version")) && (len(args) == 0)))
			{
				print(Version);
			}
			else if (StartsWith(UserIn, "help"))
			{
				Help(UserIn);
			}
			else
			{
				Content = GenCode("",UserIn);
				if (!Content.equals(""))
				{
					print(Content);
				}
			}

			if (len(args) >= 1)
			{
				break;
			}
		}
	}
}
