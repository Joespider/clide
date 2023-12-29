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
	private static String Version = "0.0.13";
	private static String TheKind = "";
	private static String TheName = "";
	private static String TheKindType = "";
	private static String TheDataType = "";
	private static String TheCondition = "";
	private static String Parameters = "";


	private static void Help(String Type)
	{
		Type = SplitAfter(Type,":");
		if (Type.equals("class"))
		{
			print("{Usage}");
			print("class(public):<name> param:<params>,<param> var:<vars> method:<name>-<type> param:<params>,<param>");
			print("class(private):<name> param:<params>,<param> var:<vars> method:<name>-<type> param:<params>,<param>");
			print("class:<name> param:<params>,<param> var:<vars> method:<name>-<type> param:<params>,<param>");
			print("");
			print("{EXAMPLE}");
			print("class(public):pizza params:one,two,three method:cheese params:four,five loop:for");
			print("class:pizza params:one,two,three method:cheese params:four,five loop:for");
		}
		else if (Type.equals("method"))
		{
			print("method(public):<name>-<type> param:<params>,<param>");
			print("method(private):<name>-<type> param:<params>,<param>");
			print("method:<name>-<type> param:<params>,<param>");
		}
		else if (Type.equals("loop"))
		{
			print("loop:<type>");
			print("");
			print("{EXAMPLE}");
			print("loop:for");
			print("loop:do/while");
			print("loop:while");
		}
		else if (Type.equals("logic"))
		{
			print("logic:<type>");
			print("");
			print("{EXAMPLE}");
			print("logic:if");
			print("logic:else-if");
			print("logic:switch");
		}
		else if (Type.equals("var"))
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
			print("method\t\t:\t\"Create a method\"");
			print("loop\t\t:\t\"Create a loop\"");
			print("logic\t\t:\t\"Create a logic\"");
			print("var\t\t:\t\"Create a variable\"");
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

	private static String SplitBefore(String Str, String splitAt)
	{
		if (Str.contains(splitAt))
		{
			String[] newString = split(Str, splitAt, 0);
			return newString[0];
		}
		else
		{
			return Str;
		}
	}

	private static String SplitAfter(String Str, String splitAt)
	{
		if (Str.contains(splitAt))
		{
			String[] newString = split(Str, splitAt, 0);
			return newString[1];
		}
		else
		{
			return Str;
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

	private static String Class(String TheName, String Content)
	{
		String Complete = "";
		String PublicOrPrivate = "public";
		if ((IsIn(TheName,"class(")) && (IsIn(TheName,"):")))
		{
			PublicOrPrivate = SplitAfter(TheName,"class");
			PublicOrPrivate = SplitBefore(PublicOrPrivate,":");
			PublicOrPrivate = PublicOrPrivate.substring(1, PublicOrPrivate.length()-1);
		}

		TheName = SplitAfter(TheName,":");
		String Params = "";
		StringBuilder ClassContent = new StringBuilder("");
		while (!Content.equals(""))
		{
			if ((StartsWith(Content, "params")) && (Params.equals("")))
			{
				Params =  Parameters(Content,"class");
			}
			else if (StartsWith(Content, "method"))
			{
				ClassContent.append(GenCode("\t",Content));
			}

			if (IsIn(Content," "))
			{
				Content = SplitAfter(Content," ");
			}
			else
			{
				break;
			}
		}
		Complete = PublicOrPrivate+" class "+TheName+" {\n\n\tprivate static int x;\n\tprivate static int y;\n\n\t//class constructor\n\tpublic "+TheName+"("+Params+")\n\t{\n\t\tthis.x = x;\n\t\tthis.y = y;\n\t}\n\n"+ClassContent.toString()+"\n}\n";
		return Complete;
	}

	private static String Method(String Tabs, String Name, String Content)
	{
		String Complete = "";

		String PublicOrPrivate = "public";
		if ((IsIn(Name,"method(")) && (IsIn(Name,"):")))
		{
			PublicOrPrivate = SplitAfter(Name,"method");
			PublicOrPrivate = SplitBefore(PublicOrPrivate,":");
			PublicOrPrivate = PublicOrPrivate.substring(1, PublicOrPrivate.length()-1);
		}

		Name = SplitAfter(Name,":");
		String TheName = "";
		String Type = "";
		String Params = "";
//		String Process = "";
		StringBuilder MethodContent = new StringBuilder("");
		String LastComp = "";


		if (IsIn(Content,"-"))
		{
			TheName = SplitBefore(Name,"-");
			Type = SplitAfter(Name,"-");
		}
		else
		{
			TheName = Name;
		}

		while (!Content.equals(""))
		{
			if ((StartsWith(Content, "params")) && (Params.equals("")))
			{
//				Process = SplitBefore(Content," ");
				Params =  Parameters(Content,"method");
			}
			else if ((StartsWith(Content, "method")) && (StartsWith(Content, "class")))
			{
				break;
			}
			else
			{
				MethodContent.append(GenCode(Tabs+"\t",Content));
			}

			if (IsIn(Content," "))
			{
				Content = SplitAfter(Content," ");
			}
			else
			{
				break;
			}
		}

		if ((Type.equals("")) || (Type.equals("void")))
		{
			Complete = Tabs+"\t"+PublicOrPrivate+" static void "+TheName + "("+Params+")\n"+Tabs+"\t{\n"+MethodContent.toString()+"\n"+Tabs+"\t}\n";
		}
		else
		{
			Complete = Tabs+"\t"+PublicOrPrivate+" static "+Type+" "+TheName+"("+Params+")\n"+Tabs+"\t{\n"+Tabs+"\t\t"+Type+" TheReturn;\n"+MethodContent.toString()+"\n"+Tabs+"\t\treturn TheReturn;\n"+Tabs+"\t}\n";
		}
		return Complete;
	}

	private static String Variables(String Tabs, String input)
	{
		String Type = "";
		String Name = "";
		String VarType = "";
		String Value = "";

		if (IsIn(input,":") && IsIn(input,"-") && IsIn(input,"="))
		{
			Type = SplitAfter(input,":");
			Name = SplitBefore(Type,"-");
			VarType = SplitAfter(Type,"-");
			Value = SplitAfter(VarType,"=");
			VarType = SplitBefore(VarType,"=");
		}
		else if (IsIn(input,":") && IsIn(input,"="))
		{
			Type = SplitAfter(input,":");
			Name = SplitBefore(Type,"=");
			Value = SplitAfter(Type,"=");
		}
		else if (IsIn(input,":") && IsIn(input,"-"))
		{
			Type = SplitAfter(input,":");
			Name = SplitBefore(Type,"-");
			VarType= SplitAfter(Type,"-");
		}

		String NewVar = "";
		if (Value.equals(""))
		{
			NewVar = Tabs+VarType+" "+Name+";\n";
		}
		else if (VarType.equals(""))
		{
			NewVar = Tabs+Name+" = "+Value+";\n";
		}
		else
		{
			NewVar = Tabs+VarType+" "+Name+" = "+Value+";\n";
		}

		return NewVar;
	}

	private static String Conditions(String input,String CalledBy)
	{
		String Params = SplitAfter(input,":");
		if (IsIn(Params,"-"))
		{
			Params = SplitAfter(input,":");
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
		return Params;
	}

	private static String Parameters(String input,String CalledBy)
	{
		String Params = SplitAfter(input,":");
		if ((CalledBy.equals("class")) || (CalledBy.equals("method")))
		{
			if ((IsIn(Params,"-")) && (IsIn(Params,",")))
			{
				String Name = SplitBefore(Params,"-");
				String Type = SplitAfter(Params,"-");
				Type = SplitBefore(Type,",");
				String more = Parameters("params:"+SplitAfter(Params,","),CalledBy);
				Params = Type+" "+Name+", "+more;
			}
			else if ((IsIn(Params,"-")) && (!IsIn(Params,",")))
			{
				String Name = SplitBefore(Params,"-");
				String Type = SplitAfter(Params,"-");
				Params = Type+" "+Name;
			}
		}

		return Params;
	}

	private static String Loop(String Tabs, String TheKindType, String Content)
	{
		String Complete = "";
		TheKindType = SplitAfter(TheKindType,":");
		String TheName = "";
		String Type = "";
		String TheCondition = "";
		StringBuilder LoopContent = new StringBuilder("");

		if (IsIn(Content,"-"))
		{
			TheName = SplitBefore(TheKindType,"-");
			Type = SplitAfter(TheKindType,"-");
		}
		else
		{
			TheName = TheKindType;
		}

		if (IsIn(TheKindType,"-"))
		{
			TheName = SplitBefore(TheKindType,"-");
			Type = SplitAfter(TheKindType,"-");
		}

		while (!Content.equals(""))
		{
			if (StartsWith(Content, "condition"))
			{
				TheCondition = Conditions(Content,TheKindType);

			}
			else if ((StartsWith(Content, "method")) || (StartsWith(Content, "class")))
			{
				break;
			}
			else if (StartsWith(Content, "nest-"))
			{
				Content = SplitAfter(Content,"-");
				LoopContent.append(GenCode(Tabs+"\t",Content));
			}

			if (IsIn(Content," "))
			{
				Content = SplitAfter(Content," ");
			}
			else
			{
				break;
			}
		}

		if (TheKindType.equals("for"))
		{
			Complete = Tabs+"for ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+LoopContent+"\n"+Tabs+"}\n";
		}
		else if (TheKindType.equals("do/while"))
		{
			Complete = Tabs+"do\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+LoopContent.toString()+Tabs+"}\n"+Tabs+"while ("+TheCondition+");\n";
		}
		else
		{
			Complete = Tabs+"while ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+LoopContent+Tabs+"}\n";
		}
		return Complete;
	}

	private static String Logic(String Tabs, String TheKindType, String Content)
	{
		StringBuilder Complete = new StringBuilder("");
		TheKindType = SplitAfter(TheKindType,":");
		String TheName = "";
		String Type = "";
		String TheCondition = "";
		StringBuilder LogicContent = new StringBuilder("");

		if (IsIn(Content,"-"))
		{
			TheName = SplitBefore(TheKindType,"-");
			Type = SplitAfter(TheKindType,"-");
		}
		else
		{
			TheName = TheKindType;
		}

		while (!Content.equals(""))
		{
			if (StartsWith(Content, "condition"))
			{
				TheCondition = Conditions(Content,TheKindType);
			}
			else if ((StartsWith(Content, "method")) || (StartsWith(Content, "class")))
			{
				break;
			}
			else if (StartsWith(Content, "nest-"))
			{
				Content = SplitAfter(Content,"-");
				LogicContent.append(GenCode(Tabs+"\t",Content));
			}

			if (IsIn(Content," "))
			{
				Content = SplitAfter(Content," ");
			}
			else
			{
				break;
			}
		}

		if (TheKindType.equals("if"))
		{
			Complete.append(Tabs+"if ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+LogicContent.toString()+Tabs+"}\n");
		}
		else if (TheKindType.equals("else-if"))
		{
			Complete.append(Tabs+"else if ("+TheCondition+")\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+LogicContent.toString()+Tabs+"}\n");
		}
		else if (TheKindType.equals("else"))
		{
			Complete.append(Tabs+"else\n"+Tabs+"{\n"+Tabs+"\t//do something here\n"+LogicContent.toString()+Tabs+"}\n");
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
				CaseVal = SplitBefore(CaseContent,"-");
				if (CaseVal != "switch")
				{
					Complete.append(Tabs+"\tcase "+CaseVal+":\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n");
				}

				if (IsIn(CaseContent,"-"))
				{
					CaseContent = SplitAfter(CaseContent,"-");
				}
				else
				{
					break;
				}
			}
			Complete.append(Tabs+"\tdefault:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n"+Tabs+"}\n");
		}
		return Complete.toString();
	}

	private static String GenCode(String Tabs,String GetMe)
	{
		StringBuilder TheCode = new StringBuilder("");
		String[] Args = new String[2];
		Args[0] = SplitBefore(GetMe," ");
		Args[1] = SplitAfter(GetMe," ");
		if (StartsWith(Args[0], "class"))
		{
			TheCode.append(Class(Args[0],Args[1]));
		}
		else if (StartsWith(Args[0], "method"))
		{
			TheCode.append(Method(Tabs,Args[0],Args[1]));
		}
		else if (StartsWith(Args[0], "loop"))
		{
			TheCode.append(Loop(Tabs,Args[0],Args[1]));
		}
		else if (StartsWith(Args[0], "logic"))
		{
			TheCode.append(Logic(Tabs,Args[0],Args[1]));
		}
		else if (StartsWith(Args[0], "var"))
		{
			TheCode.append(Variables(Tabs,Args[0]));
			TheCode.append(GenCode(Tabs,Args[1]));
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
			ArgUserIn.append(args[0]);
			for (int lp = 1; lp < numOfArgs; lp++)
			{
				ArgUserIn.append(" ");
				ArgUserIn.append(args[lp]);
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
