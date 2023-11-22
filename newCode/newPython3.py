import os
import sys

ProgramName = sys.argv[0]

if "/" in ProgramName:
	ProgramName = ProgramName.rsplit("/",1)[1]

VersionNumver = "0.1.34"

def Help():
	print("Author: Joespider")
	print("Program: \""+ProgramName.rsplit(".",1)[0]+"\"")
	print("Version: "+VersionNumver)
	print("Purpose: make new Python Scripts")
	print("Usage: "+ProgramName+" <args>")
	print("\t--user <username>: get username for help page")
	print("\t-n <name> : program name")
	print("\t--cli : enable command line (Main file ONLY)")
	print("\t--name <name> : program name")
	print("\t--no-save : only show out of code; no file source code is created")
	print("\t--main : main file")
	print("\t--prop : enable custom system property")
	print("\t--pipe : enable piping (Main file ONLY)")
	print("\t--shell : unix shell")
	print("\t--reverse : enable \"reverse\" file method")
	print("\t--split : enable \"split\" file method")
	print("\t--join : enable \"join\" file method")
	print("\t--random : enable \"random\" method")
	print("\t--check-file : enable \"fexists\" file method")
	print("\t--write-file : enable \"write\" file method")
	print("\t--read-file : enable \"read\" file method")
	print("\t--user-input : enable \"raw_input\" method")
	print("\t--thread : enable threading")
	print("\t--type : enable data type eval method")
	print("\t--sleep : enable sleep method")
	print("\t--get-length : enable \"length\" examples (Main file ONLY)")
	print("\t--upper : enable upper method")
	print("\t--lower : enable lower method")
	print("\t--math : enable math functions")
	print("\t--date-time : enable date and time")
	print("\t--web : use web request")
	print("\t--bs4 : use BeautifulSoup")
	print("\t--json : use json")

def GetArgs():
	Args = sys.argv
	Args.pop(0)
	now = ""
	next = ""
	Returns = {"name":"",
		   "user":"",
		   "cli":False,
		   "noSave":False,
		   "main":False,
		   "check":False,
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
		   "input":False,
		   "upper":False,
		   "lower":False,
		   "math":False,
		   "time":False,
		   "length":False,
		   "web":False,
		   "webSoup":False,
		   "json":False,
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
		elif now == "--no-save":
			Returns["noSave"] = True
		elif now == "--main":
			Returns["main"] = True
		elif now == "--check-file":
			Returns["check"] = True
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
		elif now == "--user-input":
			Returns["input"] = True
		elif now == "--upper":
			Returns["upper"] = True
		elif now == "--lower":
			Returns["lower"] = True
		elif now == "--math":
			Returns["math"] = True
		elif now == "--date-time":
			Returns["time"] = True
		elif now == "--get-length":
			Returns["length"] = True
		elif now == "--web":
			Returns["web"] = True
		elif now == "--bs4":
			Returns["webSoup"] = True
		elif now == "--json":
			Returns["json"] = True
		lp += 1
	return Returns

def getHelp(TheName, TheUser):
	if TheUser == "":
		TheUser = os.environ["USER"]
	HelpMethod = "TheProgram = \""+TheName+".py\"\nVersionNumver = \"0.0.0\"\n\ndef Help():\n\tprint(\"Author: "+TheUser+"\")\n\tprint(\"Program: \\\"\"+TheProgram+\"\\\"\")\n\tprint(\"Version: \"+VersionNumver)\n\tprint(\"Purpose: \")\n\tprint(\"Usage: \"+TheProgram+\" <args>\")\n\n"
	return HelpMethod

#Get Imports
def Imports(getShell, getSys, getRand, getThread, getPipe, getSleep, getTime, getProp, getMath, getCheckFile, getWeb, getWebSoup, getJson):
	TheImports = ""
	if getShell == True or getProp == True or getCheckFile == True:
		TheImports = "import os\n"
	if getSys == True or getPipe == True:
		TheImports = TheImports+"import sys\n"
	if getRand == True:
		TheImports = TheImports+"from random import *\n"
	if getThread == True:
		TheImports = TheImports+"import threading\n"
	if getSleep == True or getTime == True:
		TheImports = TheImports+"import time\n"
	if getMath == True:
		TheImports = TheImports+"import math\n"
	if getWeb == True:
		TheImports = TheImports+"#https://www.geeksforgeeks.org/python-requests-tutorial/\n"
		TheImports = TheImports+"import requests\n"
	if getWebSoup == True:
		TheImports = TheImports+"#https://realpython.com/beautiful-soup-web-scraper-python/\n"
		TheImports = TheImports+"from bs4 import BeautifulSoup\n"
	if getJson == True:
		TheImports = TheImports+"import json\n"

	return TheImports

#Get Methods
def Methods(getMain, getRawInput, getShell, getCLI, getCheckFile, getWrite, getRead, getRandom, getThread, getPipe, getSleep, getTime, getProp, getSplit, getJoin, getRev, getTypes, getUpper, getLower, getMath, getLength, getWeb, getWebSoup, getJson):
	TheMethods = ""
	#{
	OSshellMethod = "def Shell(cmd):\n\tOutput = \"\"\n\tTheShell = os.popen(cmd)\n\tOutput = TheShell.read()\n\tTheShell.close()\n\treturn Output\n\ndef Exe(cmd):\n\tos.system(cmd)\n"
	RawInputMethod = "def raw_input(message):\n\treturn input(message)\n"
	CLImethod = "def Args():\n\tTheArgs = sys.argv\n\tTheArgs.pop(0)\n\treturn TheArgs\n"
	CheckFileMethod = "def fexists(aFile):\n\treturn os.path.exists(aFile)\n"
	WriteMethod = "def Write(FileName,content):\n\tTheFile = open(FileName,\"w\")\n\tTheFile.write(content)\n\tTheFile.close()\n"
	ReadMethod = "def Read(FileName):\n\tOutput = \"\"\n\tTheFile = open(FileName,\"r\")\n\tOutput = TheFile.read()\n\tTheFile.close()\n\treturn Output\n"
	RandomMethod = "def Random(min=0,max=0):\n\tif min == 0 and max == 0:\n\t\treturn random()\n\telse:\n\t\treturn randint(min,max)\n"
	PipeMethod = "def Pipe():\n\tif not sys.stdin.isatty():\n\t\tPipeData = sys.stdin.read().strip()\n\t\treturn PipeData\n\telse:\n\t\treturn \"\"\n"
	SysPropMethod = "def GetSysProp(PleaseGet):\n\tif PleaseGet != \"\":\n\t\treturn os.environ[PleaseGet]\n\telse:\n\t\treturn \"\"\n"
	SplitMethod = "def Split(message, sBy):\n\tSplitMessage = message.split(sBy)\n\treturn SplitMessage\n"
	JoinMethod = "def Join(SplitMessage, jBy):\n\tmessage = jBy.join(SplitMessage)\n\treturn message\n"
	replaceAllMethod = "def replaceAll(message, sBy, jBy):\n\tSplitMessage = message.split(sBy)\n\tmessage = jBy.join(SplitMessage)\n\treturn message\n\n"
	replaceAllMethod = replaceAllMethod + "def replaceFirst(message, sBy, jBy):\n\tSplitMessage = message.split(sBy,1)\n\tmessage = jBy.join(SplitMessage)\n\treturn message\n\n"
	replaceAllMethod = replaceAllMethod + "def replaceLast(message, sBy, jBy):\n\tSplitMessage = message.rsplit(sBy,1)\n\tmessage = jBy.join(SplitMessage)\n\treturn message\n"
	ThreadMethod = ""
	TypeMethod = "def Type(Data):\n\tTheType = type(Data)\n\tif TheType == int:\n\t\treturn \"int\"\n\telif TheType == float:\n\t\treturn \"float\"\n\telif TheType == str:\n\t\treturn \"string\"\n\telif TheType == bool:\n\t\treturn \"bool\"\n\telif TheType == list:\n\t\treturn \"list\"\n\telif TheType == dict:\n\t\treturn \"dict\"\n\telif TheType == tuple:\n\t\treturn \"tuple\"\n\telse:\n\t\treturn TheType\n"
	ReverseMethod = "def rev(Str):\n\treturn Str[::-1]\n"
	SleepMethod = "def sleep(sec):\n\ttime.sleep(sec)\n"
	UpperMethod = "def toUpperCase(Str,plc=-1):\n\tif plc != -1 and plc == 0:\n\t\tplc += 1\n\t\treturn Str[:plc].upper()+Str[plc:]\n\tif plc != -1 and plc > 0:\n\t\tFirst = Str[:plc]\n\t\tplc += 1\n\t\treturn First+Str[plc-1:plc:].upper()+Str[plc:]\n\telse:\n\t\treturn Str.upper()\n"
	LowerMethod = "def toLowerCase(Str,plc=-1):\n\tif plc != -1:\n\t\tplc += 1\n\t\treturn Str[:plc].lower()+Str[plc:]\n\telse:\n\t\treturn Str.lower()\n"
	MathMethod = "def sqrt(number):\n\treturn math.sqrt(number)\n\n"
	MathMethod = MathMethod + "def log(number):\n\treturn math.log(number)\n\n"
	MathMethod = MathMethod + "def ceil(number):\n\treturn math.ceil(number)\n\n"
	MathMethod = MathMethod + "def floor(number):\n\treturn math.floor(number)\n\n"
	MathMethod = MathMethod + "def exp(number):\n\treturn math.exp(number)\n\n"
	MathMethod = MathMethod + "def expm1(number):\n\treturn math.expm1(number)\n\n"
	MathMethod = MathMethod + "def acos(number):\n\treturn math.acosh(number)\n\n"
	MathMethod = MathMethod + "def asin(number):\n\treturn math.asinh(number)\n\n"
	MathMethod = MathMethod + "def atan(number):\n\treturn math.atan(number)\n\n"
	MathMethod = MathMethod + "def cos(number):\n\treturn math.cos(number)\n\n"
	MathMethod = MathMethod + "def cosh(number):\n\treturn math.cosh(number)\n\n"
	MathMethod = MathMethod + "def fabs(number):\n\treturn math.fabs(number)\n\n"
	MathMethod = MathMethod + "def hypot(x, y):\n\treturn math.hypot(x, y)\n\n"
	MathMethod = MathMethod + "def fmod(x, y):\n\treturn math.fmod(x, y)\n\n"
	MathMethod = MathMethod + "def sin(number):\n\treturn math.sin(number)\n\n"
	MathMethod = MathMethod + "def sinh(number):\n\treturn math.sinh(number)\n\n"
	MathMethod = MathMethod + "def tan(number):\n\treturn math.tan(number)\n\n"
	MathMethod = MathMethod + "def tanh(number):\n\treturn math.tanh(number)\n"
	TimeMethod = "def getTime():\n\tnow = time.localtime()\n\treturn time.strftime(\"%H:%M:%S\",now)\n\n"
	TimeMethod = TimeMethod+"def TimeAndDate():\n\treturn time.asctime(time.localtime(time.time()))\n\n"
	WebRequestMethod = "def GetWebPage(site):\n\treturn requests.get(site)\n\n"
	WebRequestMethod = WebRequestMethod+"def GetWebStatus(response):\n\treturn response.status_code\n\n"
	WebRequestMethod = WebRequestMethod+"def GetWebContent(response):\n\treturn response.text\n\n"
	WebSoupMethod = "def CleanPage(Content):\n\tsoup = BeautifulSoup(Content, 'html.parser')\n\treturn soup.prettify()\n\ndef PageHead(Content,GetContent=False):\n\tsoup = BeautifulSoup(Content, 'html.parser')\n\tif GetContent == True:\n\t\treturn soup.head.contents\n\telse:\n\t\treturn soup.head\n\ndef PageTitle(Content,GetContent=False):\n\tsoup = BeautifulSoup(Content, 'html.parser')\n\tif GetContent == True:\n\t\treturn soup.title.contents\n\telse:\n\t\treturn soup.title\n\ndef PageBody(Content,GetContent=False):\n\tsoup = BeautifulSoup(Content, 'html.parser')\n\tif GetContent == True:\n\t\treturn soup.body.contents\n\telse:\n\t\treturn soup.body\n\ndef GetContent(Content,Type,Id=\"\",Val=\"\",Num=None):\n\tAllContent = []\n\tsoup = BeautifulSoup(Content, 'html.parser')\n\tif Id == \"\" and Val == \"\":\n\t\tAllContent = soup.find_all(Type)\n\telse:\n\t\tAllContent = soup.find_all(Type, {Id: Val})\n\tif Num != None:\n\t\tif len(AllContent) != 0:\n\t\t\treturn AllContent[Num]\n\t\telse:\n\t\t\treturn AllContent\n\telse:\n\t\treturn AllContent\n\n"
	JsonMethod = "def LoadJson(Data):\n\tJsonData = json.loads(Data)\n\treturn JsonData\n\n"
	LengthExample = ""

	if getThread == True:
		ThreadMethod = "\t#TheThread = threading.Thread(target=<method>, args=(<arg>,<arg>,))\n\t#TheThread.start()\n\t#TheThread.join()\n"
	if getLength == True:
		LengthExample = "#\tmessage = \"this is a message\"\n#\titems = [\"one\",\"two\",\"three\"]\n#\tStrLen = len(message)\n#\tAryLen = len(items)\n\n"

	if getCLI == True:
		MainMethod = "def Main():\n\t#Get User CLI Input\n\tUserArgs = Args()\n\tif UserArgs != []:\n\t\tprint(\"You have entered cli arguments\")\n\telse:\n\t\tHelp()\n"+ThreadMethod+LengthExample+"\nif __name__ == '__main__':\n\tMain()"
	else:
		MainMethod = "def Main():\n\tprint(\"main\")\n"+ThreadMethod+LengthExample+"\nif __name__ == '__main__':\n\tMain()"
	#}
	#Get Write Method
	if getWrite == True:
		TheMethods = WriteMethod+"\n"
	#Get raw_input Method
	if getRawInput == True:
		TheMethods = TheMethods+RawInputMethod+"\n"
	#Get Check File Method
	if getCheckFile == True:
		TheMethods = TheMethods+CheckFileMethod+"\n"
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
	#Get Time Methods
	if getTime == True:
		TheMethods = TheMethods+TimeMethod+"\n"
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
	#Get uppercase Method
	if getUpper == True:
		TheMethods = TheMethods+UpperMethod+"\n"
	#Get lowercase Method
	if getLower == True:
		TheMethods = TheMethods+LowerMethod+"\n"
	#Get Math functions
	if getMath == True:
		TheMethods = TheMethods+MathMethod+"\n"
	#Get Split and Join Method
	if getSplit == True and getJoin == True:
		TheMethods = TheMethods+replaceAllMethod+"\n"
	#Get Type Method
	if getTypes == True:
		TheMethods = TheMethods+TypeMethod+"\n"
	#Get Web Method
	if getWeb == True:
		TheMethods = TheMethods+WebRequestMethod+"\n"
	#Get Web Beautiful Soup Method
	if getWebSoup == True:
		TheMethods = TheMethods+WebSoupMethod+"\n"
	#Get Json Method
	if getJson == True:
		TheMethods = TheMethods+JsonMethod+"\n"
	#Get CLI Method
	if getCLI == True:
		TheMethods = TheMethods+CLImethod+"\n"
	#Get Main Method
	if getMain == True:
		TheMethods = TheMethods+MainMethod+"\n"

	#Return Methods
	return TheMethods

def fexists(aFile):
	return os.path.exists(aFile)

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
	noSave = UserArgs["noSave"]
	IsMain = UserArgs["main"]
	GetRawInput = UserArgs["input"]
	GetCheckFile = UserArgs["check"]
	GetRead = UserArgs["read"]
	GetWrite = UserArgs["write"]
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
	GetTime = UserArgs["time"]
	GetUpper = UserArgs["upper"]
	GetLower = UserArgs["lower"]
	GetMath = UserArgs["math"]
	GetLength = UserArgs["length"]
	GetWeb = UserArgs["web"]
	GetWebSoup = UserArgs["webSoup"]
	GetJson = UserArgs["json"]
	#}
	#Ensure Name of program
	if TheName != "" or noSave == True:
		FileExists = False
		if TheExt in TheName and noSave == False:
			FileExists = fexists(TheName)
		elif TheExt not in TheName and noSave == False:
			FileExists = fexists(TheName+TheExt)

		if FileExists == False or noSave == True:
			#Get Imports
			ProgImports = Imports(GetShell, IsCLI, GetRand, GetThreads, GetPipe, GetSleep, GetTime, GetProp, GetMath, GetCheckFile, GetWeb, GetWebSoup, GetJson)
			#Get Methods
			ProgMethods = Methods(IsMain, GetRawInput, GetShell, IsCLI, GetCheckFile, GetWrite, GetRead, GetRand, GetThreads, GetPipe, GetSleep, GetTime, GetProp, GetSplit, GetJoin, GetRev, GetTypes, GetUpper, GetLower, GetMath, GetLength, GetWeb, GetWebSoup, GetJson)
			if IsCLI == True:
				TheHelpMethod = getHelp(TheName,TheUser)
			#Manage Imports
			if ProgImports != "":
				TheNewProgram = ProgImports+"\n"
			#Manage Methods
			if ProgMethods != "":
				TheNewProgram = TheNewProgram+TheHelpMethod+ProgMethods
			if TheExt in TheName and noSave == False:
				Write(TheName,TheNewProgram)
			elif TheExt not in TheName and noSave == False:
				Write(TheName+TheExt,TheNewProgram)
			else:
				print(TheNewProgram)
		else:
			if TheExt in TheName:
				print("\""+TheName+"\" already exists")
			elif TheExt not in TheName:
				print("\""+TheName+TheExt+"\" already exists")

	#Program name not found
	else:
		Help()

if __name__ == '__main__':
	Main()

