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
	private static String Version = "0.0.2";
	private static String TheKind = "";
	private static String TheName = "";
	private static String TheKindType = "";
	private static String TheDataType = "";
	private static String TheCondition = "";
	private static String Parameters = "";

	private static void Help(String Option)
	{
		if (Option == "")
		{
			print("Java shell");
			print("Generate Java code");
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
	/**
	* @param args the command line arguments
	*/
	public static void main(String[] args)
	{
		int length;
		String UserIn = "";
		banner();
		while (true)
		{
			UserIn = raw_input(">>> ");
			if (!UserIn.equals(""))
			{
				if (UserIn.equals("exit"))
				{
					print("User exit() to exit");
				}
				else if (UserIn.equals("exit()"))
				{
					break;
				}
				else if (UserIn.equals("help"))
				{
					Help("");
				}
				else if (StartsWith(UserIn,"help "))
				{
					String[] UserArgs = split(UserIn," ");
					length = len(UserArgs);
					if (length == 2)
					{
						Help(UserArgs[1]);
					}
					else
					{
						Help("");
					}
				}
				else if (UserIn.equals("gen"))
				{
					if (TheKind.equals("loop"))
					{
						//Loop();
						print("Loop");
					}
					else if (TheKind.equals("array"))
					{
						//Array();
						print("Array");
					}
					else if (TheKind.equals("class"))
					{
						//Class();
						print("Class");
					}
					else if (TheKind.equals("logic"))
					{
						//Logic();
						print("Logic");
					}
	/*
					else if (TheKind == "condition")
					{
						Conditions();
					}
	*/
					else if (TheKind.equals("function"))
					{
						//Function();
						print("Function");
					}
				}
				else if (UserIn.equals("clear"))
				{
					//clear();
					print("clear");
				}
				else if (StartsWith(UserIn,"condition:"))
				{
					String[] UserArgs = split(UserIn,":",1);
					//HandleCondition(UserArgs[1]);
					print(UserArgs[1]);
				}
				else if (StartsWith(UserIn,"condition "))
				{
					String[] UserArgs = split(UserIn," ",1);
					//HandleCondition(UserArgs[1]);
					print(UserArgs[1]);
				}
				else if (StartsWith(UserIn,"name:"))
				{
					String[] UserArgs = split(UserIn,":",1);
					//HandleName(UserArgs[1]);
					print(UserArgs[1]);
				}
				else if (StartsWith(UserIn,"name "))
				{
					String[] UserArgs = split(UserIn," ",1);
					//HandleName(UserArgs[1]);
					print(UserArgs[1]);
				}
				else if (StartsWith(UserIn,"type:"))
				{
					String[] UserArgs = split(UserIn,":",1);
					//HandleKind(UserArgs[1]);
					print(UserArgs[1]);
				}
				else if (StartsWith(UserIn,"type "))
				{
					String[] UserArgs = split(UserIn," ",1);
					//HandleKind(UserArgs[1]);
					print(UserArgs[1]);
				}
			}
		}
	}
}
