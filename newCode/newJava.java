import java.util.Scanner;
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
	private static String user = "";
	private static String Class = "";
	private static String Parent = "";
	private static String Package = "";
	private static boolean HasPackage = false;
	private static boolean IsMain = false;
	private static boolean getUserIn = false;
	private static boolean getReadFile = false;
	private static boolean getWriteFile = false;
	private static boolean getShell = false;
	private static boolean getArrays = false;
	private static boolean getPipe = false;

	private static void Help()
	{
		String program = "newJava";
		String version = "0.1.10";
		print("Author: Joespider");
		print("Program: \""+program+"\"");
		print("Version: "+version);
		print("Purpose: make new Java programs");
		print("Usage: "+program+" <args>");
		print("\t--user <username>: get username for comments");
		print("\t-n <name> : program name");
		print("\t--name <name> : program name");
		print("\t\tnew libary with inheritance");
		print("\t-p <name> : parent program name");
		print("\t--parent <name> : parent program name");
		print("\t--package <package> : package name");
		print("\t-m : main file");
		print("\t--main : main file");
		print("\t--pipe : enable piping");
		print("\t--shell : unix shell");
		print("\t--write-file : enable \"write\" file method");
		print("\t--read-file : enable \"read\" file method");
		print("\t--user-input : enable \"raw_input\" method");
		print("\t--append-array : enable \"append\" array method");
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

	private static void ReadFile(String FileName)
	{
		try
		{
			FileInputStream fstream = new FileInputStream(FileName);
			// Get the object of DataInputStream
			DataInputStream in = new DataInputStream(fstream);
			BufferedReader br = new BufferedReader(new InputStreamReader(in));
			String strLine;
			//Read File Line By Line
			while ((strLine = br.readLine()) != null)
			{
				// Print the content on the console
				print(strLine);
			}
			//Close the input stream
			in.close();
		}
		catch (Exception e)
		{
			//Catch exception if any
			print("Error: " + e.getMessage());
		}
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
				Class = next;
			}
			//is a main class
			else if ((now.equals("-m")) || (now.equals("--main")))
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
			//enable unix shell
			else if (now.equals("--shell"))
			{
				getShell = true;
			}
			//enable unix piping
			else if (now.equals("--pipe"))
			{
				getPipe = true;
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

			lp++;
			NextPos++;
		}
	}

	private static String GetImports()
	{
		String TheImports = "";
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

		//Handle the imports by Functions
		//{
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
		//}

		//Get Needed list of imports
		//{
		if (NeedScanner)
		{
			TheImports = "import java.util.Scanner;\n";
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
		//}
		return TheImports;
	}

	private static String GetMethods()
	{
		String TheMethods = "";
		String MethodUserIn = "";
		String MethodPrint = "";
		String MethodLength = "";
		String MethodArrays = "";
		String MethodReadFile = "";
		String MethodWriteFile = "";
		String MethodShell = "";

		//raw_input
		if (getUserIn == true)
		{
			MethodUserIn = "\t//Get User input\n\tprivate static String raw_input(String Message)\n\t{\n\t\tString input = \"\";\n\t\t//User input from terminal\n\t\tScanner UserIn = new Scanner(System.in);\n\t\tSystem.out.print(Message);\n\t\tinput = UserIn.nextLine();\n\t\treturn input;\n\t}\n\n";
		}
		MethodPrint = "\t//Print Output\n\tprivate static void print(Object out)\n\t{\n\t\tSystem.out.println(out);\n\t}\n\n";
		if (getArrays == true)
		{
			MethodLength = "\t//get array length\n\tprivate static int len(Object[] array)\n\t{\n\t\tint length = array.length;\n\t\treturn length;\n\t}\n\n\t//get string length\n\tprivate static int len(String word)\n\t{\n\t\tint length = word.length();\n\t\treturn length;\n\t}\n\n";
			MethodArrays = "\t//Append content to array\n\tprivate static String[] Append(String[] ArrayName, String content)\n\t{\n\t\tint i = ArrayName.length;\n\t\t//growing temp array\n\t\tString[] temp = new String[i];\n\t\t//copying ArrayName array into temp array.\n\t\tSystem.arraycopy(ArrayName, 0, temp, 0, ArrayName.length);\n\t\t//creating a new array\n\t\ti++;\n\t\tArrayName = new String[i];\n\t\t//copying temp array into ArrayName\n\t\tSystem.arraycopy(temp, 0, ArrayName, 0, temp.length);\n\t\t//storing user input in the array\n\t\tArrayName[i-1] = content;\n\t\treturn ArrayName;\n\t}\n\n\t//Append content to array\n\tprivate static int[] Append(int[] ArrayName, int content)\n\t{\n\t\tint i = ArrayName.length;\n\t\t//growing temp array\n\t\tint[] temp = new int[i];\n\t\t//copying ArrayName array into temp array.\n\t\tSystem.arraycopy(ArrayName, 0, temp, 0, ArrayName.length);\n\t\t//creating a new array\n\t\ti++;\n\t\tArrayName = new int[i];\n\t\t//copying temp array into ArrayName\n\t\tSystem.arraycopy(temp, 0, ArrayName, 0, temp.length);\n\t\t//storing user input in the array\n\t\tArrayName[i-1] = content;\n\t\treturn ArrayName;\n\t}\n\n";
		}
		if (getReadFile == true)
		{
			MethodReadFile = "\t//Read a file\n\tprivate static void ReadFile(String FileName)\n\t{\n\t\ttry\n\t\t{\n\t\t\tFileInputStream fstream = new FileInputStream(FileName);\n\t\t\t// Get the object of DataInputStream\n\t\t\tDataInputStream in = new DataInputStream(fstream);\n\t\t\tBufferedReader br = new BufferedReader(new InputStreamReader(in));\n\t\t\tString strLine;\n\t\t\t//Read File Line By Line\n\t\t\twhile ((strLine = br.readLine()) != null)\n\t\t\t{\n\t\t\t\t// Print the content on the console\n\t\t\t\tprint(strLine);\n\t\t\t}\n\t\t\t//Close the input stream\n\t\t\tbr.close();\n\t\t\tin.close();\n\t\t}\n\t\tcatch (Exception e)\n\t\t{\n\t\t\t//Catch exception if any\n\t\t\tprint(\"Error: \" + e.getMessage());\n\t\t}\n\t}\n\n";
		}
		if (getWriteFile == true)
		{
			MethodWriteFile = "\t//Write a file\n\tprivate static void WriteFile(String FileName, String Content)\n\t{\n\t\ttry\n\t\t{\n\t\t\t// Create file\n\t\t\tFileWriter fstream = new FileWriter(FileName);\n\t\t\tBufferedWriter out = new BufferedWriter(fstream);\n\t\t\tout.write(Content);\n\t\t\t//Close the output stream\n\t\t\tfstream.close();\n\t\t\tout.close();\n\t\t}\n\t\tcatch (Exception e)\n\t\t{\n\t\t\t//Catch exception if any\n\t\t\tprint(\"Error: \" + e.getMessage());\n\t\t}\n\t}\n\n";
		}
		if (getShell == true)
		{
			MethodShell = "\tprivate static String Shell(String command)\n\t{\n\t\tString ShellOut = \"\";\n\t\tRuntime r = Runtime.getRuntime();\n\t\ttry\n\t\t{\n\t\t\tProcess p = r.exec(command);\n\t\t\tInputStream in = p.getInputStream();\n\t\t\tBufferedInputStream buf = new BufferedInputStream(in);\n\t\t\tInputStreamReader inread = new InputStreamReader(buf);\n\t\t\tBufferedReader bufferedreader = new BufferedReader(inread);\n\t\t\t// Read the ls output\n\t\t\tString line;\n\t\t\twhile ((line = bufferedreader.readLine()) != null)\n\t\t\t{\n\t\t\t\tif (ShellOut.equals(\"\"))\n\t\t\t\t{\n\t\t\t\t\t// Print the content on the console\n\t\t\t\t\tShellOut = line;\n\t\t\t\t}\n\t\t\t\telse\n\t\t\t\t{\n\t\t\t\t\tShellOut = ShellOut+\"\\n\"+line;\n\t\t\t\t}\n\t\t\t}\n\t\t\t// Check for ls failure\n\t\t\ttry\n\t\t\t{\n\t\t\t\tif (p.waitFor() != 0)\n\t\t\t\t{\n\t\t\t\t\tSystem.err.println(\"exit value = \" + p.exitValue());\n\t\t\t\t}\n\t\t\t}\n\t\t\tcatch (InterruptedException e)\n\t\t\t{\n\t\t\t\tSystem.err.println(e);\n\t\t\t}\n\t\t\tfinally\n\t\t\t{\n\t\t\t\t// Close the InputStream\n\t\t\t\tbufferedreader.close();\n\t\t\t\tinread.close();\n\t\t\t\tbuf.close();\n\t\t\t\tin.close();\n\t\t\t}\n\t\t}\n\t\tcatch (IOException e)\n\t\t{\n\t\t\tSystem.err.println(e.getMessage());\n\t\t}\n\t\treturn ShellOut;\n\t}\n";
		}
		TheMethods = MethodUserIn+MethodPrint+MethodLength+MethodArrays+MethodReadFile+MethodWriteFile+MethodShell;
		return TheMethods;
	}

	/**
	* @param args the command line arguments
	*/
	public static void main(String[] args) {
		String JavaPackage = "";
		String JavaImports;
		String JavaMethods;
		String JavaMain;
		String[] Comments = new String[3];
		String Java;
		//Grab User Args
		GetArgs(args);
		if (!Class.equals(""))
		{
			if (HasPackage == true)
			{
				JavaPackage = "package "+Package+";\n\n";
			}
			JavaImports = GetImports();
			JavaMethods = GetMethods();
			Comments[0] ="/**\n *\n * @author "+user+"\n */";
			Comments[1] ="//class name";
			if (IsMain == true)
			{
				Comments[2] ="/**\n\t* @param args the command line arguments\n\t*/";
				if (getPipe == true)
				{
					JavaMain = "\tpublic static void main(String[] args)\n\t{\n\t\ttry\n\t\t{\n\t\t\tint numBytesWaiting = System.in.available();\n\t\t\tif (numBytesWaiting > 0)\n\t\t\t{\n\t\t\t\tprint(\"[Pipe]\");\n\t\t\t\tprint(\"{\");\n\t\t\t\tScanner pipe = new Scanner(System.in);\n\t\t\t\t// Read and print out each line.\n\t\t\t\twhile (pipe.hasNextLine())\n\t\t\t\t{\n\t\t\t\t\tString lineOfInput = pipe.nextLine();\n\t\t\t\t\tprint(lineOfInput);\n\t\t\t\t}\n\t\t\t\tpipe.close();\n\t\t\t\tprint(\"}\");\n\t\t\t}\n\t\t\telse\n\t\t\t{\n\t\t\t\tprint(\"nothing was piped in\");\n\t\t\t}\n\t\t}\n\t\tcatch (Exception e)\n\t\t{\n\t\t\tSystem.err.println(\"Failed read in\");\n\t\t}\n\t}";
				}
				else
				{
					JavaMain = "\tpublic static void main(String[] args)\n\t{\n\n\t}";
				}
				Java = JavaPackage+JavaImports+"\n\n"+Comments[0]+"\n\n"+Comments[1]+"\npublic class "+Class+" {\n\n"+JavaMethods+"\n\t"+Comments[2]+"\n"+JavaMain+"\n}\n";
			}
			else
			{
				Java = JavaPackage+JavaImports+"\n\n"+Comments[0]+"\n\n"+Comments[1]+"\npublic class "+Class+" {\n\n"+JavaMethods+"\n\n}\n";
			}
			WriteFile(Class+".java",Java);
		}
		else
		{
			//Show Help Page
			Help();
		}
	}
}
