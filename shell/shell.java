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
	private static String Version = "0.0.38";
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
			print(Type+":<name> param:<params>,<param> var(public/private):<vars> method:<name>-<type> param:<params>,<param>");
			print("");
			print("{EXAMPLE}");
			print(Type+":pizza params:one-int,two-bool,three-float var(private):toppings-int method:cheese-std::string params:four-int,five-int loop:for nest-loop:for");
		}
		else if (Type.equals("struct"))
		{
			print(Type+":<name>-<type> var:<var> var:<var>");
			print("");
			print("{EXAMPLE}");
			print(Type+":pizza var:topping-std::string var:number-int");
		}
		else if (Type.equals("method"))
		{
			print(Type+"(public/private):<name>-<type> param:<params>,<param>");
			print(Type+":<name>-<type> param:<params>,<param>");
		}
		else if (Type.equals("loop"))
		{
			print(Type+":<type>");
			print("");
			print("{EXAMPLE}");
			print(Type+":for");
			print(Type+":do/while");
			print(Type+":while");
		}
		else if (Type.equals("logic"))
		{
			print(Type+":<type>");
			print("");
			print("{EXAMPLE}");
			print(Type+":if");
			print(Type+":else-if");
			print(Type+":switch");
		}
		else if (Type.equals("var"))
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
		else if (Type.equals("stmt"))
		{
			print(Type+":<type>");
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
			else
			{
				newString = split(Str, splitAt, 0);
			}

			for (int lp = 1; lp != len(newString); lp++)
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


	private static String ReplaceTag(String Content, String Tag)
	{
		if ((IsIn(Content," ")) && (StartsWith(Content, Tag)))
		{
			StringBuilder NewContent = new StringBuilder("");
			String Next = "";
			String[] all = split(Content," ");
			int end = len(all);
			int lp = 0;
			while (lp != end)
			{
				Next = all[lp];
				//element starts with tag
				if (StartsWith(Next, Tag))
				{
					//remove tag
					Next = AfterSplit(Next,"-");
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
/*
<<shell>> method:(string)TranslateTag params:(String)Input method-stmt:tab method-var:(string)Action=Input method-stmt:endline method-stmt:tab method-var:(string)Value="" method-stmt:endline method-stmt:tab method-var:(string)VarName="" method-stmt:endline method-stmt:tab method-var:(String)NewTag="" method-stmt:endline method-stmt:tab method-var:(string)TheDataType="" method-stmt:endline method-stmt:tab method-var:(String)Nest="" method-stmt:endline method-stmt:tab method-var:(String)ContentFor="" method-stmt:endline method-stmt:newline logic:if logic-condition:StartsWith(Action,"+-") logic-stmt:tab logic-stmt:tab logic-var:Action= logic-stmt:method-AfterSplit logic-params:Action,'-' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:ContentFor="logic-" logic-stmt:endline method-stmt:newline logic:else-if logic-condition:StartsWith(Action,"o-") logic-stmt:tab logic-stmt:tab logic-var:Action= logic-stmt:method-AfterSplit logic-params:Action,'-' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:ContentFor="loop-" logic-stmt:endline method-stmt:newline logic:else-if logic-condition:StartsWith(Action,"[]-") logic-stmt:tab logic-stmt:tab logic-var:Action= logic-stmt:method-AfterSplit logic-params:Action,'-' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:ContentFor="method-" logic-stmt:endline method-stmt:newline loop:while loop-condition:StartsWith(Action,">") loop-stmt:tab loop-stmt:tab loop-var:Action= loop-stmt:method-AfterSplit loop-params:Action,'>' loop-stmt:endline loop-stmt:tab loop-stmt:tab loop-var:Nest="nest-"+Nest loop-stmt:endline logic:if logic-condition:StartsWith(Action,"if")(-or)StartsWith(Action,"else-if") logic-stmt:tab logic-stmt:tab logic-var:Value= logic-stmt:method-AfterSplit logic-params:Action,':' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:Action= logic-stmt:method-BeforeSplit logic-params:Action,':' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:Nest="logic:"+Nest logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:Value="logic-condition:"+Value logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:TheReturn=ContentFor+Nest+NewTag+"(-spc)"+Value logic-stmt:endline logic:else-if logic-condition:Action(-eq)"else" logic-stmt:tab logic-stmt:tab logic-var:NewTag="logic:"+Action logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:TheReturng=ContentFor+Nest+NewTag logic-stmt:endline logic:else-if logic-condition:StartsWith(Action,"while:")(-or)StartsWith(Action,"for:"(-or)StartsWith(Action,"do/while:") logic-stmt:tab logic-stmt:tab logic-var:Value= logic-stmt:method-AfterSplit logic-params:Action,':' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:Action= logic-stmt:method-BeforeSplit logic-params:Action,':' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:Nest="loop:"+Nest logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:Value="loop-condition:"+Value logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:TheReturn=ContentFor+Nest+NewTag+"(-spc)"+Value logic-stmt:endline logic:else-if logic-condition:StartsWith(Action,"{")(-and)IsIn(Action,"}") logic-stmt:tab logic-stmt:tab logic-var:TheDataType= logic-stmt:method-BeforeSplit logic-params:Action,'}' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:TheDataType= logic-stmt:method-AfterSplit logic-params:Action,'{' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:Action= logic-stmt:method-AfterSplit logic-params:Action,'{' logic-stmt:endline logic-nest-logic:if logic-condition:IsIn(Action,":") logic-stmt:tab logic-stmt:tab logic-stmt:tab logic-var:Value= logic-stmt:method-AfterSplit logic-params:Action,':' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-stmt:tab logic-var:Action= logic-stmt:method-BeforeSplit logic-params:Action,':' logic-stmt:endline logic-nest-logic:if logic-condition:Value(-ne)"" logic-stmt:tab logic-stmt:tab logic-stmt:tab logic-var:TheReturn="class:("+TheDataType+")"+Action+"(-spc)params:"+Value logic-stmt:endline logic-nest-logic:else logic-stmt:tab logic-stmt:tab logic-stmt:tab logic-var:TheReturn="class:("+TheDataType+")"+Action logic-stmt:endline logic:else-if logic-condition:StartsWith(Action,"[")(-and)IsIn(Action,"]") logic-stmt:tab logic-stmt:tab logic-var:TheDataType= logic-stmt:method-BeforeSplit logic-params:Action,']' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:TheDataType= logic-stmt:method-AfterSplit logic-params:TheDataType,'[' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:Action= logic-stmt:method-AfterSplit logic-params:Action,']' logic-stmt:endline logic-nest-logic:if logic-condition:IsIn(Action,":") logic-stmt:tab logic-stmt:tab logic-stmt:tab logic-var:Value= logic-stmt:method-AfterSplit+-params:Action,':' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-stmt:tab logic-var:Action= logic-stmt:method-BeforeSplit logic-params:Action,':' logic-stmt:endline logic-nest-logic:if logic-condition:Value(-ne)"" logic-stmt:tab logic-stmt:tab logic-stmt:tab logic-var:TheReturn=ContentFor+"method:("+TheDataType+")"+Action+"="+Value logic-stmt:endline logic-nest-logic:else logic-stmt:tab logic-stmt:tab logic-stmt:tab logic-var:TheReturn=ContentFor+"method:("+TheDataType+")"+Action logic-stmt:endline logic:else-if logic-condition:StartsWith(Action,"(")(-and)IsIn(Action,")") logic-stmt:tab logic-stmt:tab logic-var:TheDataType= logic-stmt:method-BeforeSplit logic-params:Action,')' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:TheDataType= logic-stmt:method-AfterSplit logic-params:TheDataType,'(' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-var:Action= logic-stmt:method-AfterSplit logic-params:Action,')' logic-stmt:endline logic-nest-logic:if logic-condition:IsIn(Action,":") logic-stmt:tab logic-stmt:tab logic-stmt:tab logic-var:Value= logic-stmt:method-AfterSplit logic-params:Action,':' logic-stmt:endline logic-stmt:tab logic-stmt:tab logic-stmt:tab logic-var:Action= logic-stmt:method-BeforeSplit logic-params:Action,':' logic-stmt:endline logic-nest-logic:if logic-condition:Value(-ne)"" logic-stmt:tab logic-stmt:tab logic-stmt:tab logic-var:TheReturn=ContentFor+"var:("+TheDataType+")"+Action+"="+Value logic-stmt:endline logic-nest-logic:else logic-stmt:tab logic-stmt:tab logic-stmt:tab logic-var:TheReturn=ContentFor+"var:("+TheDataType+")"+Action logic-stmt:endline logic:else-if logic-condition:Action(-eq)"el") logic-stmt:tab logic-stmt:tab logic-var:TheReturn=ContentFor+"stmt:endline" logic-stmt:endline logic:else-if logic-condition:Action(-eq)"nl") logic-stmt:tab logic-stmt:tab logic-var:TheReturn=ContentFor+"stmt:newline" logic-stmt:endline logic:else-if logic-condition:Action(-eq)"tab") logic-stmt:tab logic-stmt:tab logic-var:TheReturn=ContentFor+"stmt:"+Action logic-stmt:endline logic:else logic-nest-logic:if logic-condition:Value(-ne)"" logic-stmt:tab logic-stmt:tab logic-stmt:tab logic-var:TheReturn=ContentFor+Nest+Action+":"+Value logic-stmt:endline logic-nest-logic:else logic-stmt:tab logic-stmt:tab logic-stmt:tab logic-var:TheReturn=ContentFor+Nest+Action logic-stmt:endline
*/
	public static String TranslateTag(String Input)
	{
		StringBuilder TheReturn = new StringBuilder("");
		String Action = "";
		String Value = "";
		String NewTag = "";
		String TheDataType = "";
		StringBuilder Nest = new StringBuilder("");
		String ContentFor = "";

		if (IsIn(Input,":"))
		{
			Action = BeforeSplit(Input,":");
			Value = AfterSplit(Input,":");
		}
		else
		{
			Action = Input;
		}

		if (StartsWith(Action,"lg-"))
		{
			Action = AfterSplit(Action,"-");
			ContentFor = "logic-";
		}
		else if (StartsWith(Action,"lp-"))
		{
			Action = AfterSplit(Action,"-");
			ContentFor = "loop-";
		}
		else if (StartsWith(Action,"m-"))
		{
			Action = AfterSplit(Action,"-");
			ContentFor = "method-";
		}

		while (StartsWith(Action,">"))
		{
			Action = AfterSplit(Action,">");
			Nest.append("nest-");
		}

		if ((Action.equals("if")) || (Action.equals("else-if")))
		{
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
		else if ((Action.equals("while")) || (Action.equals("for") || Action.equals("do/while")))
		{
			NewTag = "loop:"+Action;
			Value = "loop-condition:"+Value;
			TheReturn.append(ContentFor);
			TheReturn.append(Nest.toString());
			TheReturn.append(NewTag);
			TheReturn.append(" ");
			TheReturn.append(Value);
		}
		else
		{
			if (!Value.equals(""))
			{
				TheReturn.append(ContentFor);
				TheReturn.append(Nest);
				TheReturn.append(Action);
				TheReturn.append(":");
				TheReturn.append(Value);
			}
			else
			{
				TheReturn.append(ContentFor);
				TheReturn.append(Nest.toString());
				TheReturn.append(Input);
			}
		}

		return TheReturn.toString();
	}

/*
//<<shell>> method:DataType-string params:Type-string logic:if condition:Type(-eq)"string"(-or)Type(-eq)"std::string" logic-var:TheReturn="String" logic-stmt:endline logic:else-if condition:Type(-eq)"bool" logic-var:TheReturn="boolean" logic-stmt:endline logic:else logic-var:TheReturn=Type logic-stmt:endline
*/
	public static String DataType(String Type)
	{
		String TheReturn;
		if ((Type.equals("string")) || (Type.equals("std::string")))
		{
			TheReturn = "String";
		}
		else if (Type.equals("bool"))
		{
			TheReturn = "boolean";
		}
		else
		{
			TheReturn = Type;
		}

		return TheReturn;
	}

	private static String Conditions(String input,String CalledBy)
	{
		String Condit = "";
		if (IsIn(input,":"))
		{
			Condit = AfterSplit(input,":");

			if (IsIn(Condit,"(-eq)\""))
			{
				Condit = replaceAll(Condit, "\\(-eq\\)\"",".equals(\"");
			}
			else if (IsIn(Condit,"(-eq)"))
			{
				Condit = replaceAll(Condit, "\\(-eq\\)"," == ");
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

			if (IsIn(Condit,"(-not)"))
			{
				Condit = replaceAll(Condit, "\\(-not\\)","!");
			}

			if (IsIn(Condit,"(-ge)"))
			{
				Condit = replaceAll(Condit, "\\(-ge\\)"," >= ");
			}

			if (IsIn(Condit,"(-gt)"))
			{
				Condit = replaceAll(Condit, "\\(-gt\\)"," > ");
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
/*
			if (IsIn(Condit,"\")"))
			{
				print(Condit);
				Condit = replaceAll(Condit, "\"\\)","\"))");
				print(Condit);
			}
*/
		}

		if (CalledBy.equals("class"))
		{
			print("parameters: "+CalledBy);
		}
		else if (CalledBy.equals("method"))
		{
			print("parameters: "+CalledBy);
		}
		else if (CalledBy.equals("loop"))
		{
			print("parameters: "+CalledBy);
		}
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
				//param
				String Name = AfterSplit(Params,")");
				//type,param-type,param-type
				String Type = BeforeSplit(Params,")");
				Type = AfterSplit(Type,"(");

				Name = BeforeSplit(Name,",");
				//param-type,param-type
				String more = AfterSplit(Name,",");

				//recursion to get more parameters
				more = Parameters("params:"+more,CalledBy);
				//Converting data type to correct C++ type
				Type = DataType(Type);
				//type param, type param, type param
				Params = Type+" "+Name+", "+more;
			}
			//param-type
			else if ((StartsWith(Params,"(")) && (IsIn(Params,")")))
			{
				//param
				String Name = AfterSplit(Params,")");
				 //type
				String Type = BeforeSplit(Params,")");
				Type = AfterSplit(Type,"(");
				//Converting data type to correct C++ type
				Type = DataType(Type);
				//type param
				Params = Type+" "+Name;
			}
		}

		return Params;
	}

	private static String Class(String TheName, String Content)
	{
		String Complete = "";
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
					VarContent = BeforeSplit(Content," ");
					PublicVars.append(GenCode("\t",VarContent));
				}
				else if (StartsWith(Content, "var(private)"))
				{
					VarContent = BeforeSplit(Content," ");
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

		Complete = PublicOrPrivate+" class "+TheName+" {\n"+PublicVars.toString()+PrivateVars.toString()+"\n\t//class constructor\n\tpublic "+TheName+"("+Params+")\n\t{\n\t\tthis.x = x;\n\t\tthis.y = y;\n\t}\n\n"+ClassContent.toString()+"\n}\n";
		return Complete;
	}

	private static String Method(String Tabs, String Name, String Content)
	{
		boolean Last = false;
		boolean CanSplit = true;
		String Complete = "";

		String PublicOrPrivate = "public";

		if ((IsIn(Name,"method(")) && (IsIn(Name,"):")))
		{
			PublicOrPrivate = AfterSplit(Name,"method");
			PublicOrPrivate = BeforeSplit(PublicOrPrivate,":");
			PublicOrPrivate = PublicOrPrivate.substring(1, PublicOrPrivate.length()-1);
		}

		Name = AfterSplit(Name,":");
		String TheName = "";
		String Type = "";
		String Params = "";
		String Process = "";
		StringBuilder MethodContent = new StringBuilder("");
		StringBuilder OtherContent = new StringBuilder("");
		StringBuilder NewContent = new StringBuilder("");
		String LastComp = "";

		//method:(<type>)<name>
		if ((StartsWith(Name,"(")) && (IsIn(Name,")")))
		{
			Type = BeforeSplit(Name,")");
			Type = AfterSplit(Type,"(");
			//get method name
			TheName = AfterSplit(Name,")");
			//Converting data type to correct C++ type
			Type = DataType(Type);
		}
		//method:<name>
		else
		{
			//get method name
			TheName = Name;
		}

		while (!Content.equals(""))
		{
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
					String[] cmds = split(Content," methid:");
					Content = cmds[0];
				}

				if (StartsWith(Content, "method-"))
				{
					String[] all = split(Content," ");
					boolean noMore = false;
					int end = len(all);
					int lp = 0;
					while (lp != end)
					{
						if ((StartsWith(all[lp], "method-")) && (noMore == false))
						{
							if (OtherContent.toString().equals(""))
							{
								OtherContent.append(all[lp]);
							}
							else
							{
								OtherContent.append(" ");
								OtherContent.append(all[lp]);
							}
						}
						else
						{
							if (NewContent.toString().equals(""))
							{
								NewContent.append(all[lp]);
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
				OtherContent = new StringBuilder(ReplaceTag(OtherContent.toString(), "method-"));

				StringBuilder ParseContent = new StringBuilder("");
				String Corrected = "";

				String[] cmds = split(OtherContent.toString()," ");
				int end = len(cmds);
				int lp = 0;
				while (lp != end)
				{
					Corrected = ReplaceTag(cmds[lp], "method-");
					//starts with "logic:" or "loop:"
					if ((StartsWith(Corrected,"logic:")) || (StartsWith(Corrected,"loop:")) || (StartsWith(Corrected,"var:")) || (StartsWith(Corrected,"stmt:")))
					{
						//Only process code that starts with "logic:" or "loop:"
						if (ParseContent.toString() != "")
						{
							//process content
							MethodContent.append(GenCode(Tabs+"\t\t",ParseContent.toString()));
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
				if (ParseContent.toString() != "")
				{
					OtherContent = new StringBuilder(ParseContent.toString());
				}

				MethodContent.append(GenCode(Tabs+"\t\t",OtherContent.toString()));
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
			Complete = Tabs+"\t"+PublicOrPrivate+" static void "+TheName + "("+Params+")\n"+Tabs+"\t{\n"+MethodContent.toString()+"\n"+Tabs+"\t}\n";
		}
		else
		{
			Complete = Tabs+"\t"+PublicOrPrivate+" static "+Type+" "+TheName+"("+Params+")\n"+Tabs+"\t{\n"+Tabs+"\t\t"+Type+" TheReturn;\n"+MethodContent.toString()+"\n"+Tabs+"\t\treturn TheReturn;\n"+Tabs+"\t}\n";
		}
		return Complete;
	}

	//loop:
	private static String Loop(String Tabs, String TheKindType, String Content)
	{
		boolean Last = false;
		StringBuilder Complete = new StringBuilder("");
		String TheName = "";
		String RootTag = "";
		String Type = "";
		String TheCondition = "";
		StringBuilder LoopContent = new StringBuilder("");
		StringBuilder NewContent = new StringBuilder("");
		String OtherContent = "";

		//loop:<type>
		if (StartsWith(TheKindType,"loop:"))
		{
			//loop
			TheKindType = AfterSplit(TheKindType,":");
		}

		if (IsIn(TheKindType,"-"))
		{
			TheName = BeforeSplit(TheKindType,"-");
			Type = AfterSplit(TheKindType,"-");
		}

		//content for loop
		while (!Content.equals(""))
		{
			Content = ReplaceTag(Content,"loop-");

			if (StartsWith(Content, "condition"))
			{
				if (IsIn(Content," "))
				{
					TheCondition = BeforeSplit(Content," ");
					Content = AfterSplit(Content," ");
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
						OtherContent = all[lp];
					}
					//The remaining content is for the next loop
					//nest-<type> <other content> nest-<type> <other content>
					else if (lp == 1)
					{
						NewContent.append("nest-"+all[lp]);
					}
					else
					{
						NewContent.append(" nest-"+all[lp]);
					}
					lp++;
				}
				//Generate the loop content
				LoopContent.append(GenCode(Tabs+"\t",OtherContent));
				//The remaning content gets processed
				Content = NewContent.toString();
				//reset old and new content
				OtherContent = "";
				NewContent = new StringBuilder("");
			}


			//stop recursive loop if the next element is a "method" or a "class"
			if ((StartsWith(Content, "method:")) || (StartsWith(Content, "class:")))
			{
				break;
			}
			//nest-<type>
			else if (StartsWith(Content,"nest-"))
			{
				RootTag = BeforeSplit(Content,"l");
				//check of " nest-l" is in content
				if (IsIn(Content," "+RootTag+"l"))
				{
					//This section is meant to make sure the recursion is handled correctly
					//The nested loops and logic statements are split accordingly

					//split string wherever a " nest-" is located
					//ALL "nest-" are ignored...notice there is no space before the "nest-"
					String[] all = split(Content," "+RootTag+"l");
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
						else
						{
							if (NewContent.equals(""))
							{
								NewContent.append(RootTag);
								NewContent.append("l");
								NewContent.append(all[lp]);
							}
							else
							{
								NewContent.append(" ");
								NewContent.append(RootTag);
								NewContent.append("l");
								NewContent.append(all[lp]);
							}
						}
						lp++;
					}
				}
				else
				{
					OtherContent = Content;
				}

				Content = NewContent.toString();

				//"nest-loop" and "nest-nest-loop" becomes "loop"
				while (StartsWith(OtherContent.toString(), "nest-"))
				{
					OtherContent = AfterSplit(OtherContent,"-");
				}
				//Generate the loop content
				LoopContent.append(GenCode(Tabs+"\t",OtherContent.toString()));

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

				NewContent = new StringBuilder("");
			}

			else if ((StartsWith(Content, "loop-")) || (StartsWith(Content, "var:")) || (StartsWith(Content, "stmt:")))
			{
				Content = ReplaceTag(Content, "loop-");
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
			Complete.append(Tabs+"for ("+TheCondition+")\n"+Tabs+"{\n"+LoopContent+Tabs+"}\n");
		}
		//loop:do/while
		else if (TheKindType.equals("do/while"))
		{
			Complete.append(Tabs+"do\n"+Tabs+"{\n"+LoopContent+Tabs+"}\n"+Tabs+"while ("+TheCondition+");\n");
		}
		//loop:while
		else
		{
			Complete.append(Tabs+"while ("+TheCondition+")\n"+Tabs+"{\n"+LoopContent+Tabs+"}\n");
		}
		return Complete.toString();
	}

	//logic:
	private static String Logic(String Tabs, String TheKindType, String Content)
	{
		boolean Last = false;
		StringBuilder Complete = new StringBuilder("");
		String TheName = "";
		String Type = "";
		String RootTag = "";
		String TheCondition = "";
		StringBuilder LogicContent = new StringBuilder("");
		StringBuilder NewContent = new StringBuilder("");
		String OtherContent = "";

		if (StartsWith(TheKindType,"logic:"))
		{
			TheKindType = AfterSplit(TheKindType,":");
		}

		while (!Content.equals(""))
		{
			Content = ReplaceTag(Content, "logic-");


			if (StartsWith(Content, "condition"))
			{
				if (IsIn(Content," "))
				{
					TheCondition = BeforeSplit(Content," ");
					Content = AfterSplit(Content," ");
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
						OtherContent = all[lp];
					}
					//The remaining content is for the next loop
					//nest-<type> <other content> nest-<type> <other content>
					else if (lp == 1)
					{
						NewContent.append("nest-"+all[lp]);
					}
					else
					{
						NewContent.append(" nest-"+all[lp]);
					}
					lp++;
				}
				//Generate the logic content
				LogicContent.append(GenCode(Tabs+"\t",OtherContent));
				//The remaning content gets processed
				Content = NewContent.toString();
				//reset old and new content
				OtherContent = "";
				NewContent = new StringBuilder("");
			}

			//stop recursive loop if the next element is a "method" or a "class"
			if ((StartsWith(Content, "method:")) || (StartsWith(Content, "class:")))
			{
				break;
			}
			//nest-loop:
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
							OtherContent = cmds[lp];
						}
						else
						{
							if (NewContent.equals(""))
							{
								NewContent.append(RootTag+"l"+cmds[lp]);
							}
							else
							{
								NewContent.append(" "+RootTag+"l"+cmds[lp]);
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

				Content = NewContent.toString();
				//"nest-logic" and "nest-nest-logic" becomes "logic"
				while (StartsWith(OtherContent, "nest-"))
				{
					OtherContent = AfterSplit(OtherContent,"-");
				}

				LogicContent.append(GenCode(Tabs+"\t",OtherContent));

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

				NewContent = new StringBuilder("");
			}

			else if ((StartsWith(Content, "var:")) || (StartsWith(Content, "stmt:")))
//			else if ((StartsWith(Content, "logic-")) || (StartsWith(Content, "var:")) || (StartsWith(Content, "stmt:")))
			{
//				Content = ReplaceTag(Content, "logic-");
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
			Complete.append(Tabs+"if ("+TheCondition+")\n"+Tabs+"{\n"+LogicContent.toString()+Tabs+"}\n");
		}
		else if (TheKindType.equals("else-if"))
		{
			Complete.append(Tabs+"else if ("+TheCondition+")\n"+Tabs+"{\n"+LogicContent.toString()+Tabs+"}\n");
		}
		else if (TheKindType.equals("else"))
		{
			Complete.append(Tabs+"else\n"+Tabs+"{\n"+LogicContent.toString()+Tabs+"}\n");
		}
		else if (TheKindType.equals("switch-case"))
		{
			Complete.append(Tabs+"\tcase x:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;");

		}
		else if (StartsWith(TheKindType, "switch"))
		{
			String CaseContent = TheKindType;
			String CaseVal;

			Complete.append(Tabs+"switch ("+TheCondition+")\n"+Tabs+"{\n\n");
			while (!CaseContent.equals(""))
			{
				CaseVal = BeforeSplit(CaseContent,"-");
				if (CaseVal != "switch")
				{
					Complete.append(Tabs+"\tcase "+CaseVal+":\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n");
				}

				if (IsIn(CaseContent,"-"))
				{
					CaseContent = AfterSplit(CaseContent,"-");
				}
			}
			Complete.append(Tabs+"\tdefault:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n"+Tabs+"}\n");
		}
		return Complete.toString();
	}

	//stmt:
	private static String Statements(String Tabs, String TheKindType, String Content)
	{
		boolean Last = false;
		String Complete = "";
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
				Params =  Parameters(Process,"stmt");
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
					StatementContent.append(GenCode(Tabs,OtherContent.toString()));

					Content = AfterSplit(Content," ");
				}
				StatementContent.append(GenCode(Tabs,OtherContent.toString()));
			}
		}

		if (TheName.equals("method"))
		{
			Complete = Name+"("+Params+")"+StatementContent.toString();
		}
		else if (TheName.equals("comment"))
		{
			Complete = StatementContent.toString()+Tabs+"#Code goes here\n";
		}
		else if (TheName.equals("endline"))
		{
			Complete = StatementContent.toString()+";\n";
		}
		else if (TheName.equals("newline"))
		{
			Complete = StatementContent.toString()+"\n";
		}
		else if (TheName.equals("tab"))
		{
			Complete = "\t"+StatementContent.toString();
		}

		return Complete;
	}

	//var:
	private static String Variables(String Tabs, String TheKindType, String Content)
	{
		boolean Last = false;
		boolean MakeEqual = false;
		StringBuilder NewVar = new StringBuilder("");
		String Type = "";
		String Name = "";
		String VarType = "";
		String Value = "";
		String NewContent = "";
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
				VariableContent.append(GenCode(Tabs,OtherContent.toString()));
			}
		}

		//Pull Variable Type
		if ((StartsWith(TheKindType,"(")) && (IsIn(TheKindType,")")))
		{
			VarType = BeforeSplit(TheKindType,")");
			VarType = AfterSplit(VarType,"(");
			VarType = DataType(VarType);
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

		if (VarType != "")
		{
			NewVar.append(VarType);
			NewVar.append(" ");
		}

		if (MakeEqual == true)
		{
			NewVar.append(Name);
			NewVar.append(" = ");
			NewVar.append(Value);
		}
		else
		{
			NewVar.append(Name);
		}
		NewVar.append(VariableContent);

		return NewVar.toString();
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
