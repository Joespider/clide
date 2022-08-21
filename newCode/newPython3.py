import os
import sys

ProgramName = sys.argv[0]

if "/" in ProgramName:
	ProgramName = ProgramName.rsplit("/",1)[1]

VersionName = "0.1.21"

def Help():
	print("Author: Joespider")
	print("Program: \""+ProgramName.rsplit(".",1)[0]+"\"")
	print("Version: "+VersionName)
	print("Purpose: make new Python Scripts")
	print("Usage: "+ProgramName+" <args>")
	print("\t--user <username>: get username for help page")
	print("\t-n <name> : program name")
	print("\t--cli : enable command line (Main file ONLY)")
	print("\t--name <name> : program name")
	print("\t--main : main file")
	print("\t--prop : enable custom system property")
	print("\t--pipe : enable piping (Main file ONLY)")
	print("\t--shell : unix shell")
	print("\t--reverse : enable \"reverse\" file method")
	print("\t--split : enable \"split\" file method")
	print("\t--join : enable \"join\" file method")
	print("\t--random : enable \"random\" method")
	print("\t--write-file : enable \"write\" file method")
	print("\t--read-file : enable \"read\" file method")
	print("\t--thread : enable threading")
	print("\t--type : enable data type eval method")
	print("\t--sleep : enable sleep method")

def GetArgs():
	Args = sys.argv
	Args.pop(0)
	now = ""
	next = ""
	Returns = {"name":"",
		   "user":"",
		   "cli":False,
		   "main":False,
		   "write":False,
		   "read":False,
		   "split":False,
		   "join":False,
		   "random":False,
		   "pipe":False,
		   "rev":False,
		   "prop":False,
		   "thread":False,
		   "type":False,
		   "sleep":False,
		   "shell":False}
	#
	lp = 0
	end = len(Args)
	while lp != end:
		#Flag arg
		now = Args[lp]
		#-n <name> or --name <name>
		if now == "-n" or now == "--name":
			if (lp+1) < end:
				#Value arg
				next = Args[lp+1]
				#record program name
				Returns["name"] = next
		#-n <name> or --name <name>
		elif now == "--user":
			if (lp+1) < end:
				#Value arg
				next = Args[lp+1]
				#record program name
				Returns["user"] = next
		#--cli
		elif now == "--cli":
			#enable cli
			Returns["cli"] = True
		elif now == "--main":
			Returns["main"] = True
		elif now == "--read-file":
			Returns["read"] = True
		elif now == "--write-file":
			Returns["write"] = True
		elif now == "--random":
			Returns["random"] = True
		elif now == "--reverse":
			Returns["rev"] = True
		elif now == "--pipe":
			Returns["pipe"] = True
		elif now == "--join":
			Returns["join"] = True
		elif now == "--split":
			Returns["split"] = True
		elif now == "--prop":
			Returns["prop"] = True
		elif now == "--shell":
			Returns["shell"] = True
		elif now == "--thread":
			Returns["thread"] = True
		elif now == "--type":
			Returns["type"] = True
		elif now == "--sleep":
			Returns["sleep"] = True
		lp += 1
	return Returns

def getHelp(TheName, TheUser):
	if TheUser == "":
		TheUser = os.environ["USER"]
	HelpMethod = "TheProgram = \""+TheName+".py\"\nVersionName = \"0.0.0\"\n\ndef Help():\n\tprint(\"Author: "+TheUser+"\")\n\tprint(\"Program: \\\"\"+TheProgram+\"\\\"\")\n\tprint(\"Version: \"+VersionName)\n\tprint(\"Purpose: \")\n\tprint(\"Usage: \"+TheProgram+\" <args>\")\n\n"
	return HelpMethod

#Get Imports
def Imports(getShell, getSys, getRand, getThread, getPipe, getSleep, getProp):
	TheImports = ""
	if getShell == True or getProp:
		TheImports = "import os\n"
	if getSys == True or getPipe == True:
		TheImports = TheImports+"import sys\n"
	if getRand == True:
		TheImports = TheImports+"from random import *\n"
	if getThread == True:
		TheImports = TheImports+"import threading\n"
	if getSleep == True:
		TheImports = TheImports+"import time\n"

	return TheImports

#Get Methods
def Methods(getMain, getShell, getCLI, getWrite, getRead, getRandom, getThread, getPipe, getSleep, getProp, getSplit, getJoin, getRev, getTypes):
	TheMethods = ""
	#{
	OSshellMethod = "def Shell(cmd):\n\tOutput = \"\"\n\tTheShell = os.popen(cmd)\n\tOutput = TheShell.read()\n\tTheShell.close()\n\treturn Output\n\ndef Exe(cmd):\n\tos.system(cmd)\n"
	CLImethod = "def Args():\n\tTheArgs = sys.argv\n\tTheArgs.pop(0)\n\treturn TheArgs\n"
	WriteMethod = "def Write(FileName,content):\n\tTheFile = open(FileName,\"w\")\n\tTheFile.write(content)\n\tTheFile.close()\n"
	ReadMethod = "def Read(FileName):\n\tOutput = \"\"\n\tTheFile = open(FileName,\"r\")\n\tOutput = TheFile.read()\n\tTheFile.close()\n\treturn Output\n"
	RandomMethod = "def Random(min=0,max=0):\n\tif min == 0 and max == 0:\n\t\treturn random()\n\telse:\n\t\treturn randint(min,max)\n"
	PipeMethod = "def Pipe():\n\tif not sys.stdin.isatty():\n\t\tPipeData = sys.stdin.read().strip()\n\t\treturn PipeData\n\telse:\n\t\treturn \"\"\n"
	SysPropMethod = "def GetSysProp(PleaseGet):\n\tif PleaseGet != \"\":\n\t\treturn os.environ[PleaseGet]\n\telse:\n\t\treturn \"\"\n"
	SplitMethod = "def Split(message, sBy):\n\tSplitMessage = message.split(sBy)\n\treturn SplitMessage\n"
	JoinMethod = "def Join(SplitMessage, jBy):\n\tmessage = jBy.join(SplitMessage)\n\treturn message\n"
	replaceAllMethod = "def replaceAll(message, sBy, jBy):\n\tSplitMessage = message.split(sBy)\n\tmessage = jBy.join(SplitMessage)\n\treturn message\n"
	replaceAllMethod = replaceAllMethod + "def replaceFirst(message, sBy, jBy):\n\tSplitMessage = message.split(sBy,1)\n\tmessage = jBy.join(SplitMessage)\n\treturn message\n"
	replaceAllMethod = replaceAllMethod + "def replaceLast(message, sBy, jBy):\n\tSplitMessage = message.rsplit(sBy,1)\n\tmessage = jBy.join(SplitMessage)\n\treturn message\n"
	ThreadMethod = ""
	TypeMethod = "def Type(Data):\n\tTheType = type(Data)\n\tif TheType == int:\n\t\treturn \"int\"\n\telif TheType == float:\n\t\treturn \"float\"\n\telif TheType == str:\n\t\treturn \"string\"\n\telif TheType == bool:\n\t\treturn \"bool\"\n\telif TheType == list:\n\t\treturn \"list\"\n\telif TheType == dict:\n\t\treturn \"dict\"\n\telif TheType == tuple:\n\t\treturn \"tuple\"\n\telse:\n\t\treturn TheType\n"
	ReverseMethod = "def rev(Str):\n\treturn Str[::-1]\n"
	SleepMethod = "def sleep(sec):\n\ttime.sleep(sec)\n"

	if getThread == True:
		ThreadMethod = "\t#TheThread = threading.Thread(target=<method>, args=(<arg>,<arg>,))\n\t#TheThread.start()\n\t#TheThread.join()\n"

	if getCLI == True:
		MainMethod = "def Main():\n\t#Get User CLI Input\n\tUserArgs = Args()\n\tif UserArgs != []:\n\t\tprint(\"You have entered cli arguments\")\n\telse:\n\t\tHelp()\n"+ThreadMethod+"\nif __name__ == '__main__':\n\tMain()"
	else:
		MainMethod = "def Main():\n\tprint(\"main\")\n"+ThreadMethod+"\nif __name__ == '__main__':\n\tMain()"
	#}
	#Get Write Method
	if getWrite == True:
		TheMethods = WriteMethod+"\n"
	#Get Read Method
	if getRead == True:
		TheMethods = TheMethods+ReadMethod+"\n"
	#Get Random Method
	if getRandom == True:
		TheMethods = TheMethods+RandomMethod+"\n"
	#Get Unix Shell
	if getShell == True:
		TheMethods = TheMethods+OSshellMethod+"\n"
	#Get Sleep Method
	if getSleep == True:
		TheMethods = TheMethods+SleepMethod+"\n"
	#Get Reverse Method
	if getRev == True:
		TheMethods = TheMethods+ReverseMethod+"\n"
	#Get Pipe Method
	if getPipe == True:
		TheMethods = TheMethods+PipeMethod+"\n"
	#Get Sys Prop Method
	if getProp == True:
		TheMethods = TheMethods+SysPropMethod+"\n"
	#Get Split Method
	if getSplit == True:
		TheMethods = TheMethods+SplitMethod+"\n"
	#Get Join Method
	if getJoin == True:
		TheMethods = TheMethods+JoinMethod+"\n"
	#Get Split and Join Method
	if getSplit == True and getJoin == True:
		TheMethods = TheMethods+replaceAllMethod+"\n"
	#Get Type Method
	if getTypes == True:
		TheMethods = TheMethods+TypeMethod+"\n"
	#Get CLI Method
	if getCLI == True:
		TheMethods = TheMethods+CLImethod+"\n"
	#Get Main Method
	if getMain == True:
		TheMethods = TheMethods+MainMethod+"\n"

	#Return Methods
	return TheMethods

def Write(FileName,content):
	TheFile = open(FileName,"w")
	TheFile.write(content)
	TheFile.close()

def Main():
	TheExt = ".py"
	TheNewProgram = ""
	TheHelpMethod = ""
	#Get User CLI Input
	UserArgs = GetArgs()
	#Assign User CLI Input
	#{
	TheName = UserArgs["name"]
	TheUser = UserArgs["user"]
	IsCLI = UserArgs["cli"]
	IsMain = UserArgs["main"]
	GetWrite = UserArgs["write"]
	GetRead = UserArgs["read"]
	GetRand = UserArgs["random"]
	GetPipe = UserArgs["pipe"]
	GetSplit = UserArgs["split"]
	GetJoin = UserArgs["join"]
	GetProp = UserArgs["prop"]
	GetRev = UserArgs["rev"]
	GetShell = UserArgs["shell"]
	GetThreads = UserArgs["thread"]
	GetTypes = UserArgs["type"]
	GetSleep = UserArgs["sleep"]
	#}
	#Ensure Name of program
	if TheName != "":
		#Get Imports
		ProgImports = Imports(GetShell, IsCLI, GetRand, GetThreads, GetPipe, GetSleep, GetProp)
		#Get Methods
		ProgMethods = Methods(IsMain, GetShell, IsCLI, GetWrite, GetRead, GetRand, GetThreads, GetPipe, GetSleep, GetProp, GetSplit, GetJoin, GetRev, GetTypes)
		if IsCLI == True:
			TheHelpMethod = getHelp(TheName,TheUser)
		#Manage Imports
		if ProgImports != "":
			TheNewProgram = ProgImports+"\n"
		#Manage Methods
		if ProgMethods != "":
			TheNewProgram = TheNewProgram+TheHelpMethod+ProgMethods
		if TheExt in TheName:
			Write(TheName,TheNewProgram)
		elif TheExt not in TheName:
			Write(TheName+TheExt,TheNewProgram)

	#Program name not found
	else:
		Help()

if __name__ == '__main__':
	Main()
