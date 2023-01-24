import java.util.Scanner;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.BufferedWriter;
import java.io.BufferedReader;
import java.io.DataInputStream;

/**
 *
 * @author joe
 */

//class name
public class newJava {
	private static String user = System.getProperty("user.name");
	private static String Class = "";
	private static String Parent = "";
	private static String Package = "";
	private static boolean NameIsNotOk = true;
	private static boolean HasPackage = false;
	private static boolean IsMain = false;
	private static boolean dontSave = false;
	private static boolean getUserIn = false;
	private static boolean getCheckFile = false;
	private static boolean getReadFile = false;
	private static boolean getWriteFile = false;
	private static boolean getShell = false;
	private static boolean getFS = false;
	private static boolean getArrays = false;
	private static boolean getLengths = false;
	private static boolean getThreads = false;
	private static boolean getCliArgs = false;
	private static boolean getConvert = false;
	private static boolean getRev = false;
	private static boolean getSleep = false;
	private static boolean getSubStr = false;
	private static boolean getSplit = false;
	private static boolean getJoin = false;
	private static boolean getPipe = false;
	private static boolean getIsIn = false;
	private static boolean getRandom = false;
	private static boolean getJavaProp = false;
	private static boolean getTypes = false;
	private static boolean getUpper = false;
	private static boolean getLower = false;
	private static boolean getMath = false;
	private static boolean getDateAndTime = false;

	private static void Help()
	{
		String program = "newJava";
		String version = "0.1.44";
		print("Author: Joespider");
		print("Program: \""+program+"\"");
		print("Version: "+version);
		print("Purpose: make new Java programs");
		print("Usage: "+program+" <args>");
		print("\t--user <username>: get username for help page");
		print("\t-n <name> : program name");
		print("\t--name <name> : program name");
		print("\t\tnew libary with inheritance");
		print("\t-p <name> : parent program name");
		print("\t--parent <name> : parent program name");
		print("\t--package <package> : package name");
		print("\t--no-save : only show out of code; no file source code is created");
		print("\t--cli : enable command line (Main file ONLY)");
		print("\t--main : main file");
		print("\t--prop : enable custom system property");
		print("\t--pipe : enable piping (Main file ONLY)");
		print("\t--reverse : enable \"rev\" method");
		print("\t--split : enable split method");
		print("\t--join : enable join method");
		print("\t--random : enable \"random\" int method");
		print("\t--shell : unix shell");
		print("\t--files : enable filesystem Java specific code");
		print("\t--check-file : enable \"fexists\" file method");
		print("\t--write-file : enable \"write\" file method");
		print("\t--is-in : enable string contains methods");
		print("\t--read-file : enable \"read\" file method");
		print("\t--user-input : enable \"raw_input\" method");
		print("\t--append-array : enable \"append\" array methods");
		print("\t--thread : enable threading");
		print("\t--type : enable data type eval method");
		print("\t--sleep : enable sleep method");
		print("\t--get-length : enable \"length\" methods");
		print("\t--casting : enable data type conversion methods");
		print("\t--sub-string : enable sub-string methods");
		print("\t--upper : enable uppercase methods");
		print("\t--lower : enable lowercase methods");
		print("\t--math : enable math functions");
		print("\t--date-time : enable date and time");

	}

	private static String getHelp(String TheName, String TheUser)
	{
		String HelpMethod = "";
		if (getCliArgs == true)
		{
			if (TheUser.equals(""))
			{
				TheUser = System.getProperty("user.name");
			}
			HelpMethod = "\tprivate static void Help()\n\t{\n\t\tString program = \""+TheName+"\";\n\t\tString version = \"0.0.0\";\n\t\tprint(\"Author: "+TheUser+"\");\n\t\tprint(\"Program: \\\"\"+program+\"\\\"\");\n\t\tprint(\"Version: \"+version);\n\t\tprint(\"Purpose: \");\n\t\tprint(\"Usage: \"+program+\" <args>\");\n\t}\n\n";
		}
		return HelpMethod;
	}

	private static void print(Object out)
	{
		System.out.println(out);
	}

	//get array length
	private static int len(Object[] array)
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

	private static boolean fexists(String aFile)
	{
		File file = new File(aFile);
		return file.exists();
	}

	//Write a file
	private static void WriteFile(String FileName, String Content)
	{
		try
		{
			// Create file
			FileWriter fstream = new FileWriter(FileName);
			BufferedWriter out = new BufferedWriter(fstream);
			out.write(Content);
			//Close the output stream
			out.close();
		}
		catch (Exception e)
		{
			//Catch exception if any
			print("Error: " + e.getMessage());
		}
	}

	private static void GetArgs(String[] Args)
	{
		int lp = 0;
		int NextPos = 1;
		int end = 0;
		String now = "";
		String next = "";

		end = len(Args);
		while (lp != end)
		{
			now = Args[lp];
			//Ensure next arg is there
			if (NextPos < end)
			{
				next = Args[NextPos];
			}
			else
			{
				next = "";
			}
			//Get name of class and filename
			if ((now.equals("-n")) || (now.equals("--name")))
			{
				NameIsNotOk = IsIn(next,"--");
				if (NameIsNotOk == false)
				{
					Class = next;
				}
			}
			//is a main class
			else if (now.equals("--main"))
			{
				IsMain = true;
				Parent = "";
			}
			//Is a parent class
			else if ((now.equals("-p")) || (now.equals("--parent")))
			{
				IsMain = false;
				Parent = next;
			}
			//get package
			else if (now.equals("--package"))
			{
				HasPackage = true;
				Package = next;
			}
			//get user
			else if (now.equals("--user"))
			{
				user = next;
			}
			//enable Java Filesystem
			else if (now.equals("--files"))
			{
				getFS = true;
			}
			//enable unix shell
			else if (now.equals("--shell"))
			{
				getShell = true;
			}
			//enable sleep method
			else if (now.equals("--sleep"))
			{
				getSleep = true;
			}
			//enable CLI Args
			else if (now.equals("--is-in"))
			{
				getIsIn = true;
			}
			//enable CLI Args
			else if (now.equals("--cli"))
			{
				getCliArgs = true;
			}
			//Show file without saving
			else if (now.equals("--no-save"))
			{
				dontSave = true;
			}
			//enable reverse
			else if (now.equals("--reverse"))
			{
				getRev = true;
			}
			//enable random
			else if (now.equals("--random"))
			{
				getRandom = true;
			}
			//enable java prop
			else if (now.equals("--prop"))
			{
				getJavaProp = true;
			}
			//enable unix piping
			else if (now.equals("--pipe"))
			{
				getPipe = true;
			}
			//enable data conversion methods
			else if (now.equals("--casting"))
			{
				getConvert = true;
			}
			//enable split method
			else if (now.equals("--split"))
			{
				getSplit = true;
			}
			//enable join method
			else if (now.equals("--join"))
			{
				getJoin = true;
			}
			//enable uppercase method
			else if (now.equals("--upper"))
			{
				getUpper = true;
			}
			//enable lowercase method
			else if (now.equals("--lower"))
			{
				getLower = true;
			}
			//enable math functions
			else if (now.equals("--math"))
			{
				getMath = true;
			}
			//enable date and time
			else if (now.equals("--date-time"))
			{
				getDateAndTime = true;
			}
			//enable sub string methods
			else if (now.equals("--sub-string"))
			{
				getSubStr = true;
			}
			//enable Write file Method
			else if (now.equals("--check-file"))
			{
				getCheckFile = true;
			}
			//enable Write file Method
			else if (now.equals("--write-file"))
			{
				getWriteFile = true;
			}
			//enable Read file method
			else if (now.equals("--read-file"))
			{
				getReadFile = true;
			}
			//enable raw_input method
			else if (now.equals("--user-input"))
			{
				getUserIn = true;
			}
			//enable append method
			else if (now.equals("--append-array"))
			{
				getArrays = true;
			}
			//enable length methods
			else if (now.equals("--get-length"))
			{
				getLengths = true;
			}
			//enable threads
			else if (now.equals("--thread"))
			{
				getThreads = true;
			}
			//enable getTypes method
			else if (now.equals("--type"))
			{
				getTypes = true;
			}

			lp++;
			NextPos++;
		}
	}

	private static String GetCliArgs()
	{
		String HandleArgs = "";
		if (getCliArgs == true)
		{
			HandleArgs = "\n\t\t//Grab CLI arguments\n\t\tint lp = 0;\n\t\tint NextPos = 1;\n\t\tint end = args.length;\n\t\tString now = \"\";\n\t\tString next = \"\";\n\t\tif (end > 0)\n\t\t{\n\t\t\twhile (lp != end)\n\t\t\t{\n\t\t\t\tnow = args[lp];\n\t\t\t\t//Ensure next arg is there\n\t\t\t\tif (NextPos < end)\n\t\t\t\t{\n\t\t\t\t\tnext = args[NextPos];\n\t\t\t\t}\n\t\t\t\telse\n\t\t\t\t{\n\t\t\t\t\tnext = \"\";\n\t\t\t\t}\n\t\t\t\tlp++;\n\t\t\t\tNextPos++;\n\t\t\t}\n\t\t}\n\t\telse\n\t\t{\n\t\t\tHelp();\n\t\t}\n";
		}
		return HandleArgs;
	}

	private static String GetImports()
	{
		String TheImports = "";
		boolean NeedIOFile = false;
		boolean NeedScanner = false;
		boolean NeedInputStreamReader = false;
		boolean NeedInputStream = false;
		boolean NeedBufferedInputStream = false;
		boolean NeedBufferedWriter = false;
		boolean NeedBufferedReader = false;
		boolean NeedFileInputStream = false;
		boolean NeedFileWriter = false;
		boolean NeedIOException = false;
		boolean NeedDataInputStream = false;
		boolean NeedJavaLangMath = false;
		boolean NeedJavaTime = false;

		//Handle the imports by Functions
		//{
		if ((getCheckFile == true) || (getFS == true))
		{
			NeedIOFile = true;
		}
		if (getShell == true)
		{
			NeedInputStream = true;
			//import java.io.InputStream;
			NeedBufferedInputStream = true;
			//import java.io.BufferedInputStream;
			NeedInputStreamReader = true;
			//import java.io.InputStreamReader;
			NeedBufferedReader = true;
			//import java.io.BufferedReader;
			NeedIOException = true;
			//import java.io.IOException;
		}
		if ((getUserIn == true) || (getPipe == true))
		{
			NeedScanner = true;
			//import java.util.Scanner;;
		}
		if ((getReadFile == true) || (getWriteFile == true))
		{
			NeedFileInputStream = true;
			//import java.io.FileInputStream;
			NeedFileWriter = true;
			//import java.io.FileWriter;
			NeedIOException = true;
			//import java.io.IOException;
			NeedInputStreamReader = true;
			//import java.io.InputStreamReader;
			NeedBufferedWriter = true;
			//import java.io.BufferedWriter;
			NeedBufferedReader = true;
			//import java.io.BufferedReader;
			NeedDataInputStream = true;
			//import java.io.DataInputStream;
		}
		if (getMath == true)
		{
			//import java.lang.Math;
			NeedJavaLangMath = true;
		}
		if (getDateAndTime == true)
		{
			//import java.lang.Math;
			NeedJavaTime = true;
		}

		//}

		//Get Needed list of imports
		//{
		if (NeedIOFile)
		{
			TheImports = "import java.io.File;\n";
		}
		if (NeedScanner)
		{
			TheImports = TheImports+"import java.util.Scanner;\n";
		}
		if (NeedInputStreamReader)
		{
			TheImports = TheImports+"import java.io.InputStreamReader;\n";
		}
		if (NeedInputStream)
		{
			TheImports = TheImports+"import java.io.InputStream;\n";
		}
		if (NeedBufferedInputStream)
		{
			TheImports = TheImports+"import java.io.BufferedInputStream;\n";
		}
		if (NeedBufferedWriter)
		{
			TheImports = TheImports+"import java.io.BufferedWriter;\n";
		}
		if (NeedBufferedReader)
		{
			TheImports = TheImports+"import java.io.BufferedReader;\n";
		}
		if (NeedFileInputStream)
		{
			TheImports = TheImports+"import java.io.FileInputStream;\n";
		}
		if (NeedFileWriter)
		{
			TheImports = TheImports+"import java.io.FileWriter;\n";
		}
		if (NeedIOException)
		{
			TheImports = TheImports+"import java.io.IOException;\n";
		}
		if (NeedDataInputStream)
		{
			TheImports = TheImports+"import java.io.DataInputStream;\n";
		}
		if (NeedJavaLangMath)
		{
			TheImports = TheImports+"import java.lang.Math;\n";
		}
		if (NeedJavaTime)
		{
			TheImports = TheImports+"import java.time.LocalDate;\n";
			TheImports = TheImports+"import java.time.LocalTime;\n";
			TheImports = TheImports+"import java.time.LocalDateTime;\n";
			TheImports = TheImports+"import java.time.format.DateTimeFormatter;\n";
		}

		//}
		return TheImports;
	}

	private static String GetMethods()
	{
		String TheMethods = "";
		String MethodUserIn = "";
		String MethodPrint = "\t//Print Output\n\tprivate static void print(Object out)\n\t{\n\t\tSystem.out.println(out);\n\t}\n\n";
		String MethodLength = "";
		String MethodArrays = "";
		String MethodProp = "";
		String MethodCheckFile = "";
		String MethodReadFile = "";
		String MethodWriteFile = "";
		String MethodShell = "";
		String MethodSplit = "";
		String MethodJoin = "";
		String MethodreplaceAll = "";
		String MethodIsIn = "";
		String MethodRev = "";
		String MethodRand = "";
		String MethodSubStr = "";
		String MethodConv = "";
		String MethodSleep = "";
		String MethodUpper = "";
		String MethodLower = "";
		String MethodGetTypes = "";
		String MethodFS = "";
		String MethodMath = "";
		String MethodDateAndTime = "";

		//raw_input
		if (getUserIn == true)
		{
			MethodUserIn = "\t//Get User input\n\tprivate static String raw_input(String Message)\n\t{\n\t\tString input = \"\";\n\t\t//User input from terminal\n\t\tScanner UserIn = new Scanner(System.in);\n\t\tSystem.out.print(Message);\n\t\tinput = UserIn.nextLine();\n\t\treturn input;\n\t}\n\n";
		}
		if (getArrays == true)
		{
			MethodArrays = "\t//Append content to array\n\tprivate static String[] Append(String[] ArrayName, String content)\n\t{\n\t\tint i = ArrayName.length;\n\t\t//growing temp array\n\t\tString[] temp = new String[i];\n\t\t//copying ArrayName array into temp array.\n\t\tSystem.arraycopy(ArrayName, 0, temp, 0, i);\n\t\t//creating a new array\n\t\tArrayName = new String[i+1];\n\t\t//copying temp array into ArrayName\n\t\tSystem.arraycopy(temp, 0, ArrayName, 0, i);\n\t\t//storing user input in the arrayn\n\t\tArrayName[i] = content;\n\t\treturn ArrayName;\n\t}\n\n\t//Append content to array\n\tprivate static int[] Append(int[] ArrayName, int content)\n\t{\n\t\tint i = ArrayName.length;\n\t\t//growing temp array\n\t\tint[] temp = new int[i];\n\t\t//copying ArrayName array into temp array.\n\t\tSystem.arraycopy(ArrayName, 0, temp, 0, i);\n\t\t//creating a new array\n\t\tArrayName = new int[i+1];\n\t\t//copying temp array into ArrayName\n\t\tSystem.arraycopy(temp, 0, ArrayName, 0, i);\n\t\t//storing user input in the arrayn\n\t\tArrayName[i] = content;\n\t\treturn ArrayName;\n\t}\n\n\t//Append content to array\n\tprivate static float[] Append(float[] ArrayName, float content)\n\t{\n\t\tint i = ArrayName.length;\n\t\t//growing temp array\n\t\tfloat[] temp = new float[i];\n\t\t//copying ArrayName array into temp array.\n\t\tSystem.arraycopy(ArrayName, 0, temp, 0, i);\n\t\t//creating a new array\n\t\tArrayName = new float[i+1];\n\t\t//copying temp array into ArrayName\n\t\tSystem.arraycopy(temp, 0, ArrayName, 0, i);\n\t\t//storing user input in the array\n\t\tArrayName[i] = content;\n\t\treturn ArrayName;\n\t}\n\n\t//Append content to array\n\tprivate static double[] Append(double[] ArrayName, double content)\n\t{\n\t\tint i = ArrayName.length;\n\t\t//growing temp array\n\t\tdouble[] temp = new double[i];\n\t\t//copying ArrayName array into temp array.\n\t\tSystem.arraycopy(ArrayName, 0, temp, 0, i);\n\t\t//creating a new array\n\t\tArrayName = new double[i+1];\n\t\t//copying temp array into ArrayName\n\t\tSystem.arraycopy(temp, 0, ArrayName, 0, i);\n\t\t//storing user input in the arrayn\n\t\tArrayName[i] = content;\n\t\treturn ArrayName;\n\t}\n\n";
		}
		if (getLengths == true)
		{
			MethodLength = "\t//get array length\n\tprivate static int len(String[] array)\n\t{\n\t\tint length = array.length;\n\t\treturn length;\n\t}\n\n\t//get array length\n\tprivate static int len(int[] array)\n\t{\n\t\tint length = array.length;\n\t\treturn length;\n\t}\n\n\t//get array length\n\tprivate static int len(float[] array)\n\t{\n\t\tint length = array.length;\n\t\treturn length;\n\t}\n\n\t//get array length\n\tprivate static int len(double[] array)\n\t{\n\t\tint length = array.length;\n\t\treturn length;\n\t}\n\n\t//get string length\n\tprivate static int len(String word)\n\t{\n\t\tint length = word.length();\n\t\treturn length;\n\t}\n\n";
		}
		if (getJavaProp == true)
		{
			MethodProp = "\tprivate static String GetSysProp(String PleaseGet)\n\t{\n\t\tString PropVal = \"\";\n\t\tif (PleaseGet.equals(\"\"))\n\t\t{\n\t\t\tPropVal = \"\";\n\t\t}\n\t\telse if (PleaseGet.equals(\"pwd\"))\n\t\t{\n\t\t\tPropVal = System.getProperty(\"user.dir\");\n\t\t}\n\t\telse if (PleaseGet.equals(\"user\"))\n\t\t{\n\t\t\tPropVal = System.getProperty(\"user.name\");\n\t\t}\n\t\telse if (PleaseGet.equals(\"home\"))\n\t\t{\n\t\t\tPropVal = System.getProperty(\"user.home\");\n\t\t}\n\t\telse if (PleaseGet.equals(\"jhome\"))\n\t\t{\n\t\t\tPropVal = System.getProperty(\"java.home\");\n\t\t}\n\t\telse if (PleaseGet.equals(\"os\"))\n\t\t{\n\t\t\tPropVal = System.getProperty(\"os.name\");\n\t\t}\n\t\telse if (PleaseGet.equals(\"fileSep\"))\n\t\t{\n\t\t\tPropVal = System.getProperty(\"file.separator\");\n\t\t}\n\t\telse if (PleaseGet.equals(\"sysPathSep\"))\n\t\t{\n\t\t\tPropVal = System.getProperty(\"path.separator\");\n\t\t}\n\t\telse if (PleaseGet.equals(\"kernel\"))\n\t\t{\n\t\t\tPropVal = System.getProperty(\"os.version\");\n\t\t}\n\t\telse if (PleaseGet.equals(\"osname\"))\n\t\t{\n\t\t\tPropVal = System.getProperty(\"java.vendor\");\n\t\t}\n\t\telse if (PleaseGet.equals(\"version\"))\n\t\t{\n\t\t\tPropVal = System.getProperty(\"java.version\");\n\t\t}\n\t\telse if (PleaseGet.equals(\"ossite\"))\n\t\t{\n\t\t\tPropVal = System.getProperty(\"java.vendor.url\");\n\t\t}\n\t\telse if (PleaseGet.equals(\"cpu\"))\n\t\t{\n\t\t\tPropVal = System.getProperty(\"os.arch\");\n\t\t}\n\t\telse if (PleaseGet.equals(\"bin\"))\n\t\t{\n\t\t\tPropVal = System.getProperty(\"java.class.path\");\n\t\t}\n\t\telse if (PleaseGet.equals(\"newline\"))\n\t\t{\n\t\t\tPropVal = System.getProperty(\"line.separator\");\n\t\t}\n\t\telse\n\t\t{\n\t\t\ttry\n\t\t\t{\n\t\t\t\tPropVal = System.getProperty(PleaseGet);\n\t\t\t\tif (PropVal == null)\n\t\t\t\t{\n\t\t\t\t\tPropVal = System.getenv(PleaseGet);\n\t\t\t\t}\n\t\t\t}\n\t\t\tcatch (NullPointerException e)\n\t\t\t{\n\t\t\t\tPropVal = \"\";\n\t\t\t}\n\t\t}\n\t\treturn PropVal;\n\t}\n\n";
		}
		if (getReadFile == true)
		{
			MethodReadFile = "\t//Read a file\n\tprivate static void ReadFile(String FileName)\n\t{\n\t\ttry\n\t\t{\n\t\t\tFileInputStream fstream = new FileInputStream(FileName);\n\t\t\t// Get the object of DataInputStream\n\t\t\tDataInputStream in = new DataInputStream(fstream);\n\t\t\tBufferedReader br = new BufferedReader(new InputStreamReader(in));\n\t\t\tString strLine;\n\t\t\t//Read File Line By Line\n\t\t\twhile ((strLine = br.readLine()) != null)\n\t\t\t{\n\t\t\t\t// Print the content on the console\n\t\t\t\tprint(strLine);\n\t\t\t}\n\t\t\t//Close the input stream\n\t\t\tbr.close();\n\t\t\tin.close();\n\t\t}\n\t\tcatch (Exception e)\n\t\t{\n\t\t\t//Catch exception if any\n\t\t\tprint(\"Error: \" + e.getMessage());\n\t\t}\n\t}\n\n";
		}
		if (getCheckFile == true)
		{
			MethodCheckFile = "\tprivate static boolean fexists(String aFile)\n\t{\n\t\tFile file = new File(aFile);\n\t\treturn file.exists();\n\t}\n\n";
		}
		if (getWriteFile == true)
		{
			MethodWriteFile = "\t//Write a file\n\tprivate static void WriteFile(String FileName, String Content)\n\t{\n\t\ttry\n\t\t{\n\t\t\t// Create file\n\t\t\tFileWriter fstream = new FileWriter(FileName);\n\t\t\tBufferedWriter out = new BufferedWriter(fstream);\n\t\t\tout.write(Content);\n\t\t\t//Close the output stream\n\t\t\tfstream.close();\n\t\t\tout.close();\n\t\t}\n\t\tcatch (Exception e)\n\t\t{\n\t\t\t//Catch exception if any\n\t\t\tprint(\"Error: \" + e.getMessage());\n\t\t}\n\t}\n\n";
		}
		if (getRev == true)
		{
			MethodRev = "\tprivate static String rev(String Str)\n\t{\n\t\tString RevStr = \"\";\n\t\tchar ch;\n\t\tfor (int i=0; i < Str.length(); i++)\n\t\t{\n\t\t\tch = Str.charAt(i);\n\t\t\tRevStr = ch+RevStr;\n\t\t}\n\t\treturn RevStr;\n\t}\n\n";
		}
		if (getShell == true)
		{
			MethodShell = "\tprivate static String Shell(String command)\n\t{\n\t\tString ShellOut = \"\";\n\t\tRuntime r = Runtime.getRuntime();\n\t\ttry\n\t\t{\n\t\t\tProcess p = r.exec(command);\n\t\t\tInputStream in = p.getInputStream();\n\t\t\tBufferedInputStream buf = new BufferedInputStream(in);\n\t\t\tInputStreamReader inread = new InputStreamReader(buf);\n\t\t\tBufferedReader bufferedreader = new BufferedReader(inread);\n\t\t\t// Read the ls output\n\t\t\tString line;\n\t\t\twhile ((line = bufferedreader.readLine()) != null)\n\t\t\t{\n\t\t\t\tif (ShellOut.equals(\"\"))\n\t\t\t\t{\n\t\t\t\t\t// Print the content on the console\n\t\t\t\t\tShellOut = line;\n\t\t\t\t}\n\t\t\t\telse\n\t\t\t\t{\n\t\t\t\t\tShellOut = ShellOut+\"\\n\"+line;\n\t\t\t\t}\n\t\t\t}\n\t\t\t// Check for ls failure\n\t\t\ttry\n\t\t\t{\n\t\t\t\tif (p.waitFor() != 0)\n\t\t\t\t{\n\t\t\t\t\tSystem.err.println(\"exit value = \" + p.exitValue());\n\t\t\t\t}\n\t\t\t}\n\t\t\tcatch (InterruptedException e)\n\t\t\t{\n\t\t\t\tSystem.err.println(e);\n\t\t\t}\n\t\t\tfinally\n\t\t\t{\n\t\t\t\t// Close the InputStream\n\t\t\t\tbufferedreader.close();\n\t\t\t\tinread.close();\n\t\t\t\tbuf.close();\n\t\t\t\tin.close();\n\t\t\t}\n\t\t}\n\t\tcatch (IOException e)\n\t\t{\n\t\t\tSystem.err.println(e.getMessage());\n\t\t}\n\t\treturn ShellOut;\n\t}\n\n";
		}
		if (getSleep == true)
		{
			MethodSleep = "\tprivate static void sleep(long millies)\n\t{\n\t\ttry\n\t\t{\n\t\t\tThread.sleep(millies);\n\t\t}\n\t\tcatch (InterruptedException e)\n\t\t{\n\t\t\tThread.currentThread().interrupt();\n\t\t}\n\t}\n\n";
		}
		if (getSplit == true)
		{
			MethodSplit = "\tprivate static String[] split(String message, String by)\n\t{\n\t\tString[] vArray = message.split(by);\n\t\treturn vArray;\n\t}\n\n";
			MethodSplit = MethodSplit+"\tprivate static String[] split(String message, String by, int plc)\n\t{\n\t\tString[] vArray = message.split(by,plc);\n\t\treturn vArray;\n\t}\n\n";
		}
		if (getConvert == true)
		{
			MethodConv = "\tprivate static double Dbl(int number)\n\t{\n\t\tdouble MyDouble = Double.valueOf(number);\n\t\treturn MyDouble;\n\t}\n\n";
			MethodConv = MethodConv+"\tprivate static double Dbl(String number)\n\t{\n\t\tdouble MyDouble = 0.0;\n\t\ttry\n\t\t{\n\t\t\tMyDouble = Double.parseDouble(number);\n\t\t}\n\t\tcatch (NumberFormatException ex)\n\t\t{\n\t\t\tex.printStackTrace();\n\t\t}\n\t\treturn MyDouble;\n\t}\n\n";
			MethodConv = MethodConv+"\tprivate static int Int(double number)\n\t{\n\t\tint MyInt = (int)number;\n\t\treturn MyInt;\n\t}\n\n";
			MethodConv = MethodConv+"\tprivate static int Int(String number)\n\t{\n\t\tint MyInt = 0;\n\t\ttry\n\t\t{\n\t\t\tMyInt = Integer.parseInt(number);\n\t\t}\n\t\tcatch (NumberFormatException ex)\n\t\t{\n\t\t\tex.printStackTrace();\n\t\t}\n\t\treturn MyInt;\n\t}\n\n";
			MethodConv = MethodConv+"\tprivate static String Str(Object Item)\n\t{\n\t\tString MyString = String.valueOf(Item);\n\t\treturn MyString;\n\t}\n\n";
		}
		if (getSubStr == true)
		{
			MethodSubStr = "\tprivate static String SubString(String TheString, int Pos)\n\t{\n\t\tString TheSub = TheString.substring(Pos);\n\t\treturn TheSub;\n\t}\n\n";
			MethodSubStr = MethodSubStr+"\tprivate static String SubString(String TheString, int Start, int End)\n\t{\n\t\tString TheSub = TheString.substring(Start,End);\n\t\treturn TheSub;\n\t}\n\n";
			MethodSubStr = MethodSubStr+"\tprivate static int Index(String TheString, String SubStr)\n\t{\n\t\tint place = TheString.indexOf(SubStr);\n\t\treturn place;\n\t}\n\n";
		}
		if (getIsIn == true)
		{
			MethodIsIn = "\tprivate static boolean IsIn(String Str, String Sub)\n\t{\n\t\tboolean found = false;\n\t\tif (Str.contains(Sub))\n\t\t{\n\t\t\tfound = true;\n\t\t}\n\t\treturn found;\n\t}\n\n";
			MethodIsIn = MethodIsIn+"\t//Check if string begins with substring\n\tprivate static boolean StartsWith(String Str, String Start)\n\t{\n\t\tboolean ItDoes = Str.startsWith(Start);\n\t\treturn ItDoes;\n\t}\n\n";
			MethodIsIn = MethodIsIn+"\t//Check if string ends with substring\n\tprivate static boolean EndsWith(String Str, String Start)\n\t{\n\t\tboolean ItDoes = Str.endsWith(Start);\n\t\treturn ItDoes;\n\t}\n\n";
		}
		if (getJoin == true)
		{
			MethodJoin = "\tprivate static String join(String[] Str, String ToJoin)\n\t{\n\t\tString message = String.join(ToJoin, Str);\n\t\treturn message;\n\t}\n\n";
		}
		if ((getSplit == true) && (getJoin == true))
		{
			MethodreplaceAll = "\tprivate static String replaceAll(String message, String sBy, String jBy)\n\t{\n\t\tString NewMessage = message.replaceAll(sBy,jBy);\n\t\treturn NewMessage;\n\t}\n\n";
			MethodreplaceAll = MethodreplaceAll + "\tprivate static String replaceFirst(String message, String sBy, String jBy)\n\t{\n\t\tString NewMessage = message.replaceFirst(sBy,jBy);\n\t\treturn NewMessage;\n\t}\n\n";
			MethodreplaceAll = MethodreplaceAll + "\tprivate static String replaceLast(String message, String sBy, String jBy)\n\t{\n\t\tString NewMessage = message;\n\t\tint lastIndex = message.lastIndexOf(sBy);\n\t\tif (lastIndex != -1)\n\t\t{\n\t\t\tString beginString = message.substring(0, lastIndex);\n\t\t\tString endString = message.substring(lastIndex + sBy.length());\n\t\t\tNewMessage = beginString + jBy + endString;\n\t\t}\n\t\treturn NewMessage;\n\t}\n\n";
		}
		if (getRandom == true)
		{
			MethodRand = "\tprivate static int random(int min, int max)\n\t{\n\t\treturn (int)(Math.random() * (max - min) + min);\n\t}\n\n";
			MethodRand = MethodRand + "\tprivate static int random(int max)\n\t{\n\t\treturn (int)(Math.random() * max);\n\t}\n\n";
		}
		if (getUpper == true)
		{

			MethodUpper = "\tprivate static String toUpperCase(String TheStr)\n\t{\n\t\tTheStr = TheStr.toUpperCase();\n\t\treturn TheStr;\n\t}\n\n";
			MethodUpper = MethodUpper + "\tprivate static String toUpperCase(String TheStr, int plc)\n\t{\n\t\tString newStr = TheStr;\n\t\tint end = TheStr.length();\n\t\tchar[] Upper = TheStr.toCharArray();\n\t\tif ((plc < end) && (end != 0) && (plc >= 0))\n\t\t{\n\t\t\tUpper[plc] = Character.toUpperCase(Upper[plc]);\n\t\t\tnewStr = String.valueOf(Upper);\n\t\t}\n\t\treturn newStr;\n\t}\n\n";
		}
		if (getLower == true)
		{
			MethodLower = "\tprivate static String toLowerCase(String TheStr)\n\t{\n\t\tTheStr = TheStr.toLowerCase();\n\t\treturn TheStr;\n\t}\n\n";
			MethodLower = MethodLower + "\tprivate static String toLowerCase(String TheStr, int plc)\n\t{\n\t\tString newStr = TheStr;\n\t\tint end = TheStr.length();\n\t\tchar[] Lower = TheStr.toCharArray();\n\t\tif ((plc < end) && (end != 0) && (plc >= 0))\n\t\t{\n\t\t\tLower[plc] = Character.toLowerCase(Lower[plc]);\n\t\t\tnewStr = String.valueOf(Lower);\n\t\t}\n\t\treturn newStr;\n\t}\n\n";
		}

		if (getTypes == true)
		{
			MethodGetTypes = "\tprivate static String Type(Object Data)\n\t{\n\t\tString TheType = \"\";\n\t\tif (Data instanceof Integer)\n\t\t{\n\t\t\tTheType = \"int\";\n\t\t}\n\t\telse if (Data instanceof Double)\n\t\t{\n\t\t\tTheType = \"double\";\n\t\t}\n\t\telse if (Data instanceof String)\n\t\t{\n\t\t\tTheType = \"String\";\n\t\t}\n\t\telse if (Data instanceof Object[])\n\t\t{\n\t\t\tTheType = \"Array\";\n\t\t}\n\t\telse\n\t\t{\n\t\t\tTheType = \"unknown\";\n\t\t}\n\t\treturn TheType;\n\t}\n\n";
		}

		if (getFS == true)
		{
			MethodFS = "\tprivate static String LS(String dir)\n\t{\n\t\tString Line = \"\";\n\t\tString Output = \"\";\n\t\tFile directoryPath;\n\t\tif (dir.equals(\"\"))\n\t\t{\n\t\t\tdirectoryPath = new File(System.getProperty(\"user.dir\"));\n\t\t}\n\t\telse\n\t\t{\n\t\t\tdirectoryPath = new File(dir);\n\t\t}\n\n\t\t//List of all files and directories\n\t\tFile filesList[] = directoryPath.listFiles();\n\t\tif (filesList != null)\n\t\t\n\t\t\tfor(File file : filesList)\n\t\t\t{\n\t\t\t\tLine = file.getName();\n\t\t\t\tif (!Line.startsWith(\".\"))\n\t\t\t\t{\n\t\t\t\t\tOutput = Output+Line+\"\\n\";\n\t\t\t\t}\n\t\t\t}\n\t\t}\n\t\treturn Output;\n\t}\n\n";
			MethodFS = MethodFS+"\tprivate static void CD(String dir)\n\t{\n\t\tif (!dir.equals(\"\"))\n\t\t{\n\t\t\tSystem.setProperty(\"user.dir\",dir);\n\t\t}\n\t}\n\n";
		}

		if (getMath == true)
		{
			MethodMath = "\tprivate static double max(double a, double b)\n\t{\n\t\treturn Math.max(a,b);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static float max(float a, float b)\n\t{\n\t\treturn Math.max(a,b);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static long max(long a, long b)\n\t{\n\t\treturn Math.max(a,b);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static int max(int a, int b)\n\t{\n\t\treturn Math.max(a,b);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double min(double a, double b)\n\t{\n\t\treturn Math.min(a,b);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static float min(float a, float b)\n\t{\n\t\treturn Math.min(a,b);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static long min(long a, long b)\n\t{\n\t\treturn Math.min(a,b);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static int min(int a, int b)\n\t{\n\t\treturn Math.min(a,b);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double abs(double a)\n\t{\n\t\treturn Math.abs(a);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static float abs(float a)\n\t{\n\t\treturn Math.abs(a);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static int abs(int a)\n\t{\n\t\treturn Math.abs(a);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static long abs(long a)\n\t{\n\t\treturn Math.abs(a);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double acos(double a)\n\t{\n\t\treturn Math.acos(a);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double asin(double a)\n\t{\n\t\treturn Math.asin(a);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double atan(double a)\n\t{\n\t\treturn Math.atan(a);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double cbrt(double a)\n\t{\n\t\treturn Math.cbrt(a);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double ceil(double a)\n\t{\n\t\treturn Math.ceil(a);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double cos(double a)\n\t{\n\t\treturn Math.cos(a);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double cosh(double x)\n\t{\n\t\treturn Math.cosh(x);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double exp(double a)\n\t{\n\t\treturn Math.exp(a);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double expm1(double x)\n\t{\n\t\treturn Math.expm1(x);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double floor(double a)\n\t{\n\t\treturn Math.floor(a);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static int fmod(int x, int y)\n\t{\n\t\treturn Math.floorMod(x, y);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static long fmod(long x, long y)\n\t{\n\t\treturn Math.floorMod(x, y);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double hypot(double x, double y)\n\t{\n\t\treturn Math.hypot(x, y);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double pow(double a, double b)\n\t{\n\t\treturn Math.pow(a, b);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double sin(double a)\n\t{\n\t\treturn Math.sin(a);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double sinh(double x)\n\t{\n\t\treturn Math.sinh(x);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double tan(double a)\n\t{\n\t\treturn Math.tan(a);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double tanh(double x)\n\t{\n\t\treturn Math.tanh(x);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double sqrt(double Number)\n\t{\n\t\treturn Math.sqrt(Number);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static int round(float Number)\n\t{\n\t\treturn Math.round(Number);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static long round(double Number)\n\t{\n\t\treturn Math.round(Number);\n\t}\n\n";
			MethodMath = MethodMath + "\tprivate static double log(double Number)\n\t{\n\t\treturn Math.log(Number);\n\t}\n\n";
		}
		if (getDateAndTime == true)
		{
			MethodDateAndTime = "\tprivate static String getTime()\n\t{\n\t\tLocalTime time = LocalTime.now();\n\t\tDateTimeFormatter JustTime = DateTimeFormatter.ofPattern(\"HH:mm:ss\");\n\t\tString theTime = JustTime.format(time);\n\t\treturn theTime;\n\t}\n\n";
			MethodDateAndTime = MethodDateAndTime + "\tprivate static String TimeAndDate()\n\t{\n\t\tLocalDateTime dt = LocalDateTime.now();\n\t\tDateTimeFormatter dtf = DateTimeFormatter.ofPattern(\"E MMM dd HH:mm:ss yyyy\");\n\t\tString formatted = dtf.format(dt);\n\t\treturn formatted;\n\t}\n\n";
		}
		TheMethods = MethodProp+MethodUserIn+MethodPrint+MethodLength+MethodArrays+MethodCheckFile+MethodReadFile+MethodWriteFile+MethodShell+MethodSleep+MethodIsIn+MethodRev+MethodSplit+MethodJoin+MethodreplaceAll+MethodConv+MethodSubStr+MethodRand+MethodUpper+MethodLower+MethodGetTypes+MethodFS+MethodMath+MethodDateAndTime;
		return TheMethods;
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

	/**
	* @param args the command line arguments
	*/
	public static void main(String[] args) {
		boolean FileExists = false;
		String JavaPackage = "";
		String JavaThreads = "extends Thread";
		String JavaThreadStart = "";
		String JavaThreadCall = "";
		String TheClass = "";
		String JavaImports;
		String JavaMethods;
		String JavaCLI;
		String JavaHelp;
		String JavaMain;
		String[] Comments = new String[3];
		String Java;
		//Grab User Args
		GetArgs(args);
		if ((!Class.equals("")) || (dontSave == true))
		{
			if (dontSave == false)
			{
				FileExists = fexists(Class+".java");
			}

			if ((FileExists == false) || (dontSave == true))
			{
				if (HasPackage == true)
				{
					JavaPackage = "package "+Package+";\n\n";
				}
				if (getThreads == true)
				{
					TheClass = Class+" "+JavaThreads;
					JavaThreadStart = "\tpublic void run()\n\t{\n\t\tSystem.out.println(\"{My Thread}\");\n\t}\n\n";
					JavaThreadCall = "\t\t//Instance of a threaded class\n\t\t//"+Class+" TheThread = new "+Class+"();\n\t\t//Starting Thread\n\t\t//TheThread.start();\n\n";
				}
				else if (getThreads == false)
				{
					TheClass = Class;
				}
				JavaImports = GetImports();
				JavaMethods = GetMethods();
				JavaCLI = GetCliArgs();
				Comments[0] ="/**\n *\n * @author "+user+"\n */";
				Comments[1] ="//class name";
				if (IsMain == true)
				{
					JavaHelp = getHelp(Class,user);
					Comments[2] ="/**\n\t* @param args the command line arguments\n\t*/";
					if (getPipe == true)
					{
						JavaMain = "\tpublic static void main(String[] args)\n\t{\n"+JavaThreadCall+JavaCLI+"\n\t\ttry\n\t\t{\n\t\t\tint numBytesWaiting = System.in.available();\n\t\t\tif (numBytesWaiting > 0)\n\t\t\t{\n\t\t\t\tprint(\"[Pipe]\");\n\t\t\t\tprint(\"{\");\n\t\t\t\tScanner pipe = new Scanner(System.in);\n\t\t\t\t// Read and print out each line.\n\t\t\t\twhile (pipe.hasNextLine())\n\t\t\t\t{\n\t\t\t\t\tString lineOfInput = pipe.nextLine();\n\t\t\t\t\tprint(lineOfInput);\n\t\t\t\t}\n\t\t\t\tpipe.close();\n\t\t\t\tprint(\"}\");\n\t\t\t}\n\t\t\telse\n\t\t\t{\n\t\t\t\tprint(\"nothing was piped in\");\n\t\t\t}\n\t\t}\n\t\tcatch (Exception e)\n\t\t{\n\t\t\tSystem.err.println(\"Failed read in\");\n\t\t}\n\t}";
					}
					else
					{
						JavaMain = "\tpublic static void main(String[] args)\n\t{\n"+JavaThreadCall+"\n"+JavaCLI+"\n\t}";
					}
					Java = JavaPackage+JavaImports+"\n\n"+Comments[0]+"\n\n"+Comments[1]+"\npublic class "+TheClass+" {\n\n"+JavaHelp+JavaThreadStart+JavaMethods+"\n\t"+Comments[2]+"\n"+JavaMain+"\n}\n";
				}
				else
				{
					Java = JavaPackage+JavaImports+"\n\n"+Comments[0]+"\n\n"+Comments[1]+"\npublic class "+TheClass+" {\n\n"+JavaThreadStart+JavaMethods+"\n\n}\n"+JavaThreadCall;
				}
				if (dontSave == false)
				{
					WriteFile(Class+".java",Java);
				}
				else
				{
					print(Java);
				}
			}
			else
			{
				print("\""+Class+".java\" already exists");

			}
		}
		else
		{
			//Show Help Page
			Help();
		}
	}
}
