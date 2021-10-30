import sys

ProgramName = "newPython"
VersionName = "0.1.05"

def Help():
	print "Author: Joespider"
	print "Program: \""+ProgramName+"\""
	print "Version: "+VersionName
	print "Purpose: make new Python Scripts"
	print "Usage: "+ProgramName+".py <args>"
	print "\t-n <name> : program name"
	print "\t--name <name> : program name"
	print "\t--cli : enable command line (Main file ONLY)"
	print "\t--main : main file"
	print "\t--shell : unix shell"
	print "\t--pipe : enable piping"
	print "\t--write-file : enable \"write\" file method"
	print "\t--read-file : enable \"read\" file method"
	print "\t--random : enable \"random\" method"
	print "\t--os : import OS"

def GetArgs():
	Args = sys.argv
	Args.pop(0)
	now = ""
	next = ""
	Returns = {"name":"",
		   "cli":False,
		   "main":False,
		   "write":False,
		   "read":False,
		   "random":False,
		   "pipe":False,
		   "os":False,
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
		elif now == "--pipe":
			Returns["pipe"] = True
		elif now == "--os":
			Returns["os"] = True
		elif now == "--shell":
			Returns["shell"] = True
		lp += 1
	return Returns

#Get Imports
def Imports(getOS, getSys, getRand, getPipe):
	TheImports = ""
	if getOS == True:
		TheImports = "import os\n"
	if getSys == True or getPipe == True:
		TheImports = TheImports+"import sys\n"
	if getRand == True:
		TheImports = TheImports+"from random import *\n"
	return TheImports

#Get Methods
def Methods(getMain, getShell, getCLI, getWrite, getRead, getRandom, getPipe):
	TheMethods = ""
	#{
	OSshellMethod = "def Shell(cmd):\n\tOutput = \"\"\n\tTheShell = os.popen(cmd)\n\tOutput = TheShell.read()\n\tTheShell.close()\n\treturn Output\n"
	CLImethod = "def Args():\n\tTheArgs = sys.argv\n\tTheArgs.pop(0)\n\treturn TheArgs\n"
	WriteMethod = "def Write(FileName,content):\n\tTheFile = open(FileName,\"w\")\n\tTheFile.write(content)\n\tTheFile.close()\n"
	ReadMethod = "def Read(FileName):\n\tOutput = \"\"\n\tTheFile = open(FileName,\"r\")\n\tOutput = TheFile.read()\n\tTheFile.close()\n\treturn Output\n"
	RandomMethod = "def Random(min=0,max=0):\n\tif min == 0 and max == 0:\n\t\treturn random()\n\telse:\n\t\treturn randint(min,max)\n"
	PipeMethod = "def Pipe():\n\tif not sys.stdin.isatty():\n\t\tPipeData = sys.stdin.read().strip()\n\t\treturn PipeData\n\telse:\n\t\treturn \"\"\n"

	if getCLI == True:
		MainMethod = "def Main():\n\t#Get User CLI Input\n\tUserArgs = Args()\n\nif __name__ == '__main__':\n\tMain()"
	else:
		MainMethod = "def Main():\n\tprint \"main\"\n\nif __name__ == '__main__':\n\tMain()"
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
	#Get Pipe Method
	if getPipe == True:
		TheMethods = TheMethods+PipeMethod+"\n"
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
	#Get User CLI Input
	UserArgs = GetArgs()
	#Assign User CLI Input
	#{
	TheName = UserArgs["name"]
	IsCLI = UserArgs["cli"]
	IsMain = UserArgs["main"]
	GetWrite = UserArgs["write"]
	GetRead = UserArgs["read"]
	GetRand = UserArgs["random"]
	GetPipe = UserArgs["pipe"]
	GetOS = UserArgs["os"]
	GetShell = UserArgs["os"]
	#}
	#Ensure Name of program
	if TheName != "":
		#Get Imports
		ProgImports = Imports(GetOS, IsCLI, GetRand, GetPipe)
		#Get Methods
		ProgMethods = Methods(IsMain, GetShell, IsCLI, GetWrite, GetRead, GetRand, GetPipe)
		#Manage Imports
		if ProgImports != "":
			TheNewProgram = ProgImports+"\n"
		#Manage Methods
		if ProgMethods != "":
			TheNewProgram = TheNewProgram+ProgMethods
		if TheExt in TheName:
			Write(TheName,TheNewProgram)
		elif TheExt not in TheName:
			Write(TheName+TheExt,TheNewProgram)

	#Program name not found
	else:
		Help()

if __name__ == '__main__':
	Main()
