import sys

ProgramName = "newPython"
VersionName = "0.1.03"

def Help():
	print "Author: Dan (DJ) Coffman"
	print "Program: \""+ProgramName+"\""
	print "Version: "+VersionName
	print "Purpose: make new Python Scripts"
	print "Usage: "+ProgramName+".py <args>"
	print "\t-n <name> : program name"
	print "\t--name <name> : program name"
	print "\t--cli : enable command line (Main file ONLY)"
	print "\t--main : main file"
	print "\t--shell : unix shell"
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
		elif now == "--os":
			Returns["os"] = True
		elif now == "--shell":
			Returns["shell"] = True
		lp += 1
	return Returns

#Get Imports
def Imports(getOS, getSys, getRand):
	TheImports = ""
	if getOS == True:
		TheImports = "import os\n"
	if getSys == True:
		TheImports = TheImports+"import sys\n"
	if getRand == True:
		TheImports = TheImports+"from random import *\n"
	return TheImports

#Get Methods
def Methods(getMain,getShell,getCLI,getWrite,getRead,getRandom):
	TheMethods = ""
	#{
	OSshellMethod = "def shell(cmd):\n\tOutput = \"\"\n\tTheShell = os.popen(cmd)\n\tOutput = TheShell.read()\n\tTheShell.close()\n\treturn Output\n"
	CLImethod = "def GetArgs():\n\tArgs = sys.argv\n\tArgs.pop(0)\n\tnow = \"\"\n\tnext = \"\"\n\t#\n\tlp = 0\n\tend = len(Args)\n\twhile lp != end:\n\t\t#Flag arg\n\t\tnow = Args[lp]\n\t\tlp += 1\n"
	WriteMethod = "def Write(FileName,content):\n\tTheFile = open(FileName,\"w\")\n\tTheFile.write(content)\n\tTheFile.close()\n"
	ReadMethod = "def Read(FileName):\n\tOutput = \"\"\n\tTheFile = open(FileName,\"r\")\n\tOutput = TheFile.read()\n\tTheFile.close()\n\treturn Output\n"
	RandomMethod = "def Random(min=0,max=0):\n\tif min == 0 and max == 0:\n\t\treturn random()\n\telse:\n\t\treturn randint(min,max)\n"
	if getCLI == True:
		MainMethod = "def main():\n\t#Get User CLI Input\n\tUserArgs = GetArgs()\n\nmain()"
	else:
		MainMethod = "def main():\n\tprint \"main\"\n\nmain()"
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

def main():
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
	GetOS = UserArgs["os"]
	GetShell = UserArgs["os"]
	#}
	#Ensure Name of program
	if TheName != "":
		#Get Imports
		ProgImports = Imports(GetOS, IsCLI, GetRand)
		#Get Methods
		ProgMethods = Methods(IsMain, GetShell, IsCLI, GetWrite, GetRead, GetRand)
		#Manage Imports
		if ProgImports != "":
			TheNewProgram = ProgImports+"\n"
		#Manage Methods
		if ProgMethods != "":
			TheNewProgram = TheNewProgram+ProgMethods
		if ".py" in TheName:
			Write(TheName,TheNewProgram)
		elif ".py" not in TheName:
			Write(TheName+".py",TheNewProgram)

	#Program name not found
	else:
		Help()

main()
