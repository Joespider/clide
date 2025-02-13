import os
import sys
import platform

Version = "0.0.1"

def getOS():
	platform.system()

def Help(Type):
	if IsIn(Type,":"):
		Type = SplitAfter(Type,":")

	if Type == "class":
		print("{Usage}")
		print(Type+":<name> param:<params>,<param> var(public/private):<vars> method:<name>-<type> param:<params>,<param>")
		print("")
		print("{EXAMPLE}")
		print(Type+":pizza params:one-int,two-bool,three-float var(private):toppings-int method:cheese-std::string params:four-int,five-int loop:for nest-loop:for")
	elif Type == "struct":
		print(Type+":<name>-<type> var:<var> var:<var>")
		print("")
		print("{EXAMPLE}")
		print(Type+":pizza var:topping-std::string var:number-int")
	elif Type == "method":
		print(Type+"(public/private):<name>-<type> param:<params>,<param>")
		print(Type+":<name>-<type> param:<params>,<param>")
	elif Type == "loop":
		print(Type+":<type>")
		print("")
		print("{EXAMPLE}")
		print(Type+":for")
		print(Type+":do/while")
		print(Type+":while")
	elif Type == "logic":
		print(Type+":<type>")
		print("")
		print("{EXAMPLE}")
		print(Type+":if")
		print(Type+":else-if")
		print(Type+":switch")
	elif Type == "var":
		print(Type+"(public/private):<name>-<type>=value\tcreate a new variable")
		print(Type+":<name>-<type>[<num>]=value\tcreate a new variable as an array")
		print(Type+":<name>-<type>(<struct>)=value\tcreate a new variable a data structure")
		print(Type+":<name>=value\tassign a new value to an existing variable")
		print("")
		print("{EXAMPLE}")
		print(Type+":name-std::string[3]")
		print(Type+":name-std::string(vector)")
		print(Type+":name-std::string=\"\" var:point-int=0 stmt:endline var:james-std::string=\"James\" stmt:endline var:help-int")
	elif Type == "stmt":
		print(Type+":<type>")
		print(Type+":endline\t\tPlace the \";\" at the end of the statement")
		print(Type+":newline\t\tPlace and empty line")
		print(Type+":method-<name>\tcall a method and the name of the method")
	else:
		print("Components to Generate")
		print("class\t\t:\t\"Create a class\"")
		print("struct\t\t:\t\"Create a struct\"")
		print("method\t\t:\t\"Create a method\"")
		print("loop\t\t:\t\"Create a loop\"")
		print("logic\t\t:\t\"Create a logic\"")
		print("var\t\t:\t\"Create a variable\"")
		print("stmt\t\t:\t\"Create a statment\"")
		print("nest-<type>\t:\t\"next element is nested in previous element\"")
		print("")
		print("help:<type>")

#User Input
def raw_input(message):
	return input(message)

def clear():
	shellExe("clear")

def Shell(cmd):
	Output = ""
	TheShell = os.popen(cmd)
	Output = TheShell.read()
	TheShell.close()
	return Output

def Exe(cmd):
	os.system(cmd)

def getCplV():
	cplV = Shell("python3 --version")
	return cplV.strip()

#Check if sub-string is in string
def IsIn(Str, Sub):
	if Sub in Str:
		return True
	else:
		return False

#Check if string begins with substring
def StartsWith(Str, Start):
	if Str.startswith(Start):
		return True
	else:
		return False

#Check if string ends with substring
def EndsWith(Str, End):
	if Str.endswith(End):
		return True
	else:
		return False

def SplitBefore(Str, splitAt):
	newString = Str.split(splitAt,1)[0]
	return newString


def SplitAfter(Str, splitAt):
	newString = Str.split(splitAt,1)[1]
	return newString

def split(message, by, at=0):
	vArray = []
	if at == 0:
		vArray = message.split(by)
	else:
		vArray = message.split(by,at)

	return vArray

def Join(SplitMessage, jBy):
	message = jBy.join(SplitMessage)
	return message

def replaceAll(message, sBy, jBy):
	SplitMessage = message.split(sBy)
	message = jBy.join(SplitMessage)
	return message

#	----[shell]----



def banner():
	cplV = getCplV()
	theOS = getOS()
	print(cplV)
	print("[python " + str(Version) + "] on " + str(theOS))
	print("Type \"help\" for more information.")

def Struct(TheName, Content):
	Complete = ""
	StructVar = ""
	Process = ""
	TheName = SplitAfter(TheName,":")
	while StartsWith(Content, "var"):
		Process = SplitBefore(Content," ")
		Content = SplitAfter(Content," ")
		StructVar = StructVar + GenCode("\t",Process)
	Complete = "struct {\n"+StructVar+"\n} "+TheName+";\n"
	return Complete

def Class(TheName, Content):
	Complete = ""
	PrivateVars = ""
	PublicVars = ""
	VarContent = ""

#	String PublicOrPrivate = "";
#	if (StartsWith(TheName,"class("))
#	if (IsIn(TheName,")"))
#	{
#		PublicOrPrivate = SplitAfter(TheName,"(");
#		PublicOrPrivate = SplitBefore(PublicOrPrivate,")");
#	}

	TheName = SplitAfter(TheName,":")
	Process = ""
	Params = ""
	ClassContent = ""
	while Content != "":
		if StartsWith(Content, "params") and Params == "":
			Process = SplitBefore(Content," ")
			Params =  Parameters(Process,"class")

		elif StartsWith(Content, "method"):
			ClassContent = ClassContent + GenCode("\t",Content)

		elif StartsWith(Content, "var"):
			if StartsWith(Content, "var(public)"):
				Content = SplitAfter(Content,")")
				VarContent = SplitBefore(Content," ")
				VarContent = "var"+VarContent
				PublicVars = PublicVars + GenCode("\t",VarContent)
			elif StartsWith(Content, "var(private)"):
				Content = SplitAfter(Content,")")
				VarContent = SplitBefore(Content," ")
				VarContent = "var"+VarContent
				PrivateVars = PrivateVars  + GenCode("\t",VarContent)

		if IsIn(Content," "):
			Content = SplitAfter(Content," ")
		else:
			break

	if PrivateVars != "":
		PrivateVars = "private:\n\t//private variables\n"+PrivateVars+"\n"

	if PublicVars != "":
		PublicVars = "\n\t//public variables\n"+PublicVars

	Complete = "class "+TheName+" {\n\n"+PrivateVars+"public:"+PublicVars+"\n\t//class constructor\n\t"+TheName+"("+Params+")\n\t{\n\t\tthis->x = x;\n\t\tthis->y = y;\n\t}\n\n"+ClassContent+"\n\t//class desctructor\n\t~"+TheName+"()\n\t{\n\t}\n};\n"
	return Complete

def Method(Tabs, Name, Content):
	Complete = ""
	Name = SplitAfter(Name,":")
	TheName = ""
	Type = ""
	Params = ""
	MethodContent = ""
	LastComp = ""
	Process = ""

	if IsIn(Name,"-"):
		TheName = SplitBefore(Name,"-")
		Type = SplitAfter(Name,"-")
	else:
		TheName = Name

	while Content != "":
		if StartsWith(Content, "params") and Params == "":
			if IsIn(Content," "):
				Process = SplitBefore(Content," ")
			else:
				Process = Content
			Params =  Parameters(Process,"method")

		elif StartsWith(Content, "method") or StartsWith(Content, "class"):
			break
		else:
			if IsIn(Content," method"):
				cmds = split(Content," method")
				Content = cmds[0]

			MethodContent = MethodContent + GenCode(Tabs+"\t",Content)

		if IsIn(Content," "):
			Content = SplitAfter(Content," ")
		else:
			break

	if Type == "" or Type == "void":
		Complete = Tabs+"void "+TheName + "("+Params+")\n"+Tabs+"{\n"+MethodContent+"\n"+Tabs+"}\n"
	else:
		Complete = Tabs+Type+" "+TheName+"("+Params+")\n"+Tabs+"{\n"+Tabs+"\t" +Type+" TheReturn;\n"+MethodContent+"\n"+Tabs+"\treturn TheReturn;\n"+Tabs+"}\n"

	return Complete

def Conditions(input,CalledBy):
	Condit = SplitAfter(input,":")
	Condit = replaceAll(Condit, "|", " ")
	if CalledBy == "class":
		print("condition: "+CalledBy)
	elif CalledBy == "method":
		print("condition: "+CalledBy)
	elif CalledBy == "loop":
		print("condition: "+CalledBy)

	return Condit

def Parameters(input, CalledBy):
	Params = SplitAfter(input,":")
	if CalledBy == "class" or CalledBy == "method" or CalledBy == "stmt":
		if IsIn(Params,"-") and IsIn(Params,","):
			Name = SplitBefore(Params,"-")
			Type = SplitAfter(Params,"-")
			Type = SplitBefore(Type,",")
			more = SplitAfter(Params,",")
			more = Parameters("params:"+more,CalledBy)
			Params = Type+" "+Name+", "+more
		elif IsIn(Params,"-") and not IsIn(Params,","):
			Name = SplitBefore(Params,"-")
			Type = SplitAfter(Params,"-")
			Params = Type+" "+Name
	return Params

#loop:
def Loop(Tabs, TheKindType, Content):
	Last = False
	Complete = ""
	TheName = ""
	RootTag = ""
	Type = ""
	TheCondition = ""
	LoopContent = ""
	NewContent = ""
	OtherContent = ""

	if IsIn(TheKindType,":"):
		TheKindType = SplitAfter(TheKindType,":")

	if IsIn(TheKindType,"-"):
		TheName = SplitBefore(TheKindType,"-")
		Type = SplitAfter(TheKindType,"-")

	while Content != "":
		if not StartsWith(Content, "nest-") and IsIn(Content," nest-"):
			all = split(Content," nest-")
			end = len(all)
			lp = 0
			while lp != end:
				if lp == 0:
					OtherContent = all[lp]
				elif lp == 1:
					NewContent = "nest-"+all[lp]
				else:
					NewContent = NewContent + " nest-"+all[lp]
				lp += 1

			LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent)
			Content = NewContent
			OtherContent = ""
			NewContent = ""

		if StartsWith(Content, "condition"):
			TheCondition = Conditions(Content,TheKindType)

		elif StartsWith(Content, "method") or StartsWith(Content, "class"):
			break

		#nest-loop:
		elif StartsWith(Content, "nest-"):
			RootTag = SplitBefore(Content,'l')

			if IsIn(Content," "+RootTag+"l"):
				cmds = split(Content," "+RootTag+"l")
				end = len(cmds)
				lp = 0
				while lp != end:
					if lp == 0:
						OtherContent = cmds[lp]
					else:
						if NewContent == "":
							NewContent = RootTag+"l"+cmds[lp]
						else:
							NewContent = NewContent+" "+RootTag+"l"+cmds[lp]
					lp += 1
			else:
				OtherContent = Content

			Content = NewContent
			NewContent = ""

			while StartsWith(OtherContent, "nest-"):
				OtherContent = SplitAfter(OtherContent,"-")

			LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent)
		else:
			LoopContent = LoopContent + GenCode(Tabs+"\t",Content)
			Content = ""

		if Last:
			break

		if not IsIn(Content," "):
			Last = True

	#loop:for
	if TheKindType == "for":
		Complete = Tabs+"for ("+TheCondition+")\n"+Tabs+"{\n"+LoopContent+Tabs+"}\n"

	#loop:do/while
	elif TheKindType == "do/while":
		Complete = Tabs+"do\n"+Tabs+"{\n"+LoopContent+Tabs+"}\n"+Tabs+"while ("+TheCondition+");\n"

	#loop:while
	else:
		Complete = Tabs+"while ("+TheCondition+")\n"+Tabs+"{\n"+LoopContent+Tabs+"}\n"

	return Complete

#logic:
def Logic(Tabs, TheKindType, Content):
	Last = False
	Complete = ""
	TheName = ""
	Type = ""
	RootTag = ""
	TheCondition = ""
	LogicContent = ""
	NewContent = ""
	OtherContent = ""

	if IsIn(TheKindType,":"):
		TheKindType = SplitAfter(TheKindType,":")

	if IsIn(TheKindType,"-"):
		TheName = SplitBefore(TheKindType,"-")
		Type = SplitAfter(TheKindType,"-")

	while Content != "":
		if not StartsWith(Content, "nest-") and IsIn(Content," nest-"):
			all = split(Content," nest-")
			end = len(all)
			lp = 0
			while lp != end:
				if lp == 0:
					OtherContent = all[lp]

				elif lp == 1:
					NewContent = "nest-"+all[lp]

				else:
					NewContent = NewContent + " nest-"+all[lp]
				lp += 1
			LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent)
			Content = NewContent
			OtherContent = ""
			NewContent = ""

		if StartsWith(Content, "condition"):
			if IsIn(Content," "):
				TheCondition = SplitBefore(Content," ")
				Content = SplitAfter(Content," ")
			else:
				TheCondition = Content

			TheCondition = Conditions(TheCondition,TheKindType)

		elif StartsWith(Content, "method") or StartsWith(Content, "class"):
			break

		elif StartsWith(Content, "nest-"):
			RootTag = SplitBefore(Content,'l')
			if IsIn(Content," "+RootTag+"l"):
				cmds = split(Content," "+RootTag+"l")
				end = len(cmds)
				lp = 0
				while lp != end:
					if lp == 0:
						OtherContent = cmds[lp]
					else:
						if NewContent == "":
							NewContent = RootTag+"l"+cmds[lp]
						else:
							NewContent = NewContent+" "+RootTag+"l"+cmds[lp]
					lp += 1
			else:
				OtherContent = Content

			Content = NewContent
			NewContent = ""

			while StartsWith(OtherContent, "nest-"):
				OtherContent = SplitAfter(OtherContent,"-")

			LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent)
		else:
			LogicContent = LogicContent + GenCode(Tabs+"\t",Content)
			Content = ""

		if Last:
			break

		if not IsIn(Content," "):
			Last = True

	if TheKindType == "if":
		Complete = Tabs+"if ("+TheCondition+")\n"+Tabs+"{\n"+LogicContent+Tabs+"}\n"

	elif TheKindType == "else-if":
		Complete = Tabs+"elif ("+TheCondition+")\n"+Tabs+"{\n"+LogicContent+Tabs+"}\n"

	elif TheKindType == "else":
		Complete = Tabs+"else\n"+Tabs+"{\n"+LogicContent+Tabs+"}\n"

	elif TheKindType == "switch-case":
		Complete = Tabs+"\tcase x:\n"+Tabs+"\t\t#code here\n"+Tabs+"\t\tbreak;"

	elif StartsWith(TheKindType, "switch"):
		CaseContent = TheKindType
		CaseVal = ""

		Complete = Tabs+"switch ("+TheCondition+")\n"+Tabs+"{\n\n"
		while CaseContent != "":
			CaseVal = SplitBefore(CaseContent,"-")
			if CaseVal != "switch":
				Complete = Complete+Tabs+"\tcase "+CaseVal+":\n"+Tabs+"\t\t#code here\n"+Tabs+"\t\tbreak;\n"

			if IsIn(CaseContent,"-"):
				CaseContent = SplitAfter(CaseContent,"-")

		Complete = Complete+Tabs+"\tdefault:\n"+Tabs+"\t\t#code here\n"+Tabs+"\t\tbreak;\n"+Tabs+"}\n"

	return Complete

#stmt:
def Statements(Tabs, TheKindType, Content):
	Last = False
	Complete = ""
	StatementContent = ""
	OtherContent = ""
	TheName = ""
	Name = ""
	Process = ""
	Params = ""

	if IsIn(TheKindType,":"):
		TheKindType = SplitAfter(TheKindType,":")

	if IsIn(TheKindType,"-"):
		TheName = SplitBefore(TheKindType,"-")
		Name = SplitAfter(TheKindType,"-")

	else:
		TheName = TheKindType

	while Content != "":
		if StartsWith(Content, "params") and Params == "":
			if IsIn(Content," "):
				Process = SplitBefore(Content," ")
			else:
				Process = Content

			Params =  Parameters(Process,"stmt")
		else:
			OtherContent = SplitBefore(Content," ")
			StatementContent = StatementContent + GenCode(Tabs,OtherContent)
			Content = SplitAfter(Content," ")

		if Last:
			break

		if not IsIn(Content," "):
			StatementContent = StatementContent + GenCode(Tabs,Content)
			Last = True

	if TheName == "method":
		Complete = Name+"("+Params+")"+StatementContent;

	elif TheName == "endline":
		Complete = StatementContent+";\n"

	elif TheName == "newline":
		Complete = StatementContent+"\n"

	return Complete;

#var:
def Variables(Tabs, TheKindType, Content):
	Last = False
	NewVar = ""
	Type = ""
	Name = ""
	VarType = ""
	Value = ""
	NewContent = ""
	VariableContent = ""
	OtherContent = ""

#	print(TheKindType+" "+Content);

	while Content != "":
#		VariableContent = VariableContent + GenCode(Tabs,Content)
#		Content = SplitAfter(Content," ")

		OtherContent = SplitBefore(Content," ")
		Content = SplitAfter(Content," ")
		if StartsWith(Content, "params"):
			OtherContent = OtherContent+" "+SplitBefore(Content," ")
			Content = SplitAfter(Content," ")

		VariableContent = VariableContent + GenCode(Tabs,OtherContent)

		if Last:
			break

		if not IsIn(Content," "):
			VariableContent = VariableContent + GenCode(Tabs,Content)
			Last = True

	#var:name-dataType=Value
	if IsIn(TheKindType,":") and IsIn(TheKindType,"-") and IsIn(TheKindType,"=") and not EndsWith(TheKindType, "="):
		Type = SplitAfter(TheKindType,":")
		Name = SplitBefore(Type,"-")
		VarType = SplitAfter(Type,"-")
		Value = SplitAfter(VarType,'=')
		VarType = SplitBefore(VarType,'=')
		NewVar = Tabs+VarType+" "+Name+" = "+Value
		NewVar = NewVar+VariableContent

	#var:name=Value
	if IsIn(TheKindType,":") and not IsIn(TheKindType,"-") and IsIn(TheKindType,"=") and not EndsWith(TheKindType, "="):
		Type = SplitAfter(TheKindType,":")
		Name = SplitBefore(Type,'=')
		Value = SplitAfter(Type,'=')
		NewVar = Tabs+Name+" = "+Value
		NewVar = NewVar+VariableContent

	#var:name-dataType=
	elif IsIn(TheKindType,":") and IsIn(TheKindType,"-") and EndsWith(TheKindType, "="):
		Type = SplitAfter(TheKindType,":")
		Name = SplitBefore(Type,"-")
		VarType = SplitAfter(Type,"-")
		VarType = SplitBefore(VarType,'=')
		NewVar = Tabs+VarType+" "+Name+" = "
		NewVar = NewVar+VariableContent

	#var:name=
	elif IsIn(TheKindType,":") and not IsIn(TheKindType,"-") and EndsWith(TheKindType, "="):
		Type = SplitAfter(TheKindType,":")
		Name = SplitBefore(Type,'=')
		Value = SplitAfter(Type,'=')
		NewVar = Tabs+Name+" = "
		NewVar = NewVar+VariableContent

	#var:name-dataType
	elif IsIn(TheKindType,":") and IsIn(TheKindType,"-") and IsIn(TheKindType,"="):
		Type = SplitAfter(TheKindType,":")
		Name = SplitBefore(Type,"-")
		VarType = SplitAfter(Type,"-")
		NewVar = Tabs+VarType+" "+Name
		NewVar = NewVar+VariableContent

	return NewVar

def GenCode(Tabs,GetMe):
	TheCode = ""
	Args = ["",""]

	if IsIn(GetMe," "):
		Args[0] = SplitBefore(GetMe," ")
		Args[1] = SplitAfter(GetMe," ")
	else:
		Args[0] = GetMe
		Args[1] = ""

	if StartsWith(Args[0], "class"):
		TheCode = Class(Args[0],Args[1])

	elif StartsWith(Args[0], "struct"):
		TheCode = Struct(Args[0],Args[1])

	elif StartsWith(Args[0], "method"):
		TheCode = Method(Tabs,Args[0],Args[1])

	elif StartsWith(Args[0], "loop"):
		TheCode = Loop(Tabs,Args[0],Args[1])

	elif StartsWith(Args[0], "logic"):
		TheCode = Logic(Tabs,Args[0],Args[1])

	elif StartsWith(Args[0], "var"):
		TheCode = Variables(Tabs, Args[0], Args[1])

	elif StartsWith(Args[0], "stmt"):
		TheCode = Statements(Tabs, Args[0], Args[1])

#	elif StartsWith(Args[0], "condition"):
#		TheCode = Conditions(Args[0])
#
#	elif StartsWith(Args[0], "params"):
#		TheCode = Parameters(Args[0])

	return TheCode

def Args():
	TheArgs = sys.argv
	TheArgs.pop(0)
	return TheArgs

#python Main...with cli arguments
def Main():
	#Get User CLI Input
	UserArgs = Args()

	argc = len(UserArgs)

	#Args were NOT given
	if argc == 0:
		banner()

	UserIn = ""
	Content = ""
	while True:
		#Args were given
		if argc >= 1:
			UserIn = UserArgs[0]
			lp = 1
			while lp < argc:
				UserIn = UserIn + " " + UserArgs[lp]
				lp += 1
		else:
			UserIn = raw_input(">>> ")

		if UserIn == "exit()":
			break

		elif UserIn == "exit":
			print("Use exit()")

		elif UserIn == "clear":
			clear()

		elif StartsWith(UserIn, "help"):
			Help(UserIn)

		else:
			Content = GenCode("",UserIn)
			if Content != "":
				print(Content)

		#Args were given
		if argc >= 1:
			break

if __name__ == '__main__':
	Main()
