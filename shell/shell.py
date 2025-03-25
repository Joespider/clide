import os
import sys
import platform

Version = "0.0.7"

def getOS():
	platform.system()

def Help(Type):
	if IsIn(Type,":"):
		Type = AfterSplit(Type,":")

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

def BeforeSplit(Str, splitAt):
	if splitAt in Str:
		return Str.split(splitAt,1)[0]
	else:
		return ""

def AfterSplit(Str, splitAt):
	if splitAt in Str:
		return Str.split(splitAt,1)[1]
	else:
		return ""

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


def ReplaceTag(Content, Tag):
	if IsIn(Content," ") and StartsWith(Content, Tag):
		NewContent = "";
		Next = "";
		all = split(Content," ")
		end = len(all)
		lp = 0
		while lp != end:
			Next = all[lp]
			#element starts with tag
			if StartsWith(Next, Tag):
				#remove tag
				Next = AfterSplit(Next,"-")

			if NewContent == "":
				NewContent = Next
			else:
				NewContent = NewContent+" "+Next
			lp += 1
		Content = NewContent

	#Parse Content as long as there is a Tag found at the beginning
	elif StartsWith(Content, Tag):
		#removing tag
		Content = AfterSplit(Content,"-")
	return Content



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
	TheName = AfterSplit(TheName,":")
	while StartsWith(Content, "var"):
		Process = BeforeSplit(Content," ")
		Content = AfterSplit(Content," ")
		StructVar = StructVar + GenCode("\t",Process)
	Complete = "struct {\n"+StructVar+"\n} "+TheName+";\n"
	return Complete

#class:
def Class(TheName, Content):
	Complete = ""
	PrivateVars = ""
	PublicVars = ""
	VarContent = ""

#	String PublicOrPrivate = "";
#	if (StartsWith(TheName,"class("))
#	if (IsIn(TheName,")"))
#	{
#		PublicOrPrivate = AfterSplit(TheName,"(");
#		PublicOrPrivate = BeforeSplit(PublicOrPrivate,")");
#	}

	TheName = AfterSplit(TheName,":")
	Process = ""
	Params = ""
	ClassContent = ""
	while Content != "":
		if StartsWith(Content, "params") and Params == "":
			Process = BeforeSplit(Content," ")
			Params = ", "+Parameters(Process,"class")

		elif StartsWith(Content, "method"):
			ClassContent = ClassContent + GenCode("\t",Content,"Class")

		elif StartsWith(Content, "var"):
			if StartsWith(Content, "var(public)"):
				Content = AfterSplit(Content,")")
				VarContent = BeforeSplit(Content," ")
				VarContent = "var"+VarContent
				PublicVars = PublicVars + GenCode("\t",VarContent)
			elif StartsWith(Content, "var(private)"):
				Content = AfterSplit(Content,")")
				VarContent = BeforeSplit(Content," ")
				VarContent = "var"+VarContent
				PrivateVars = PrivateVars  + GenCode("\t",VarContent)

		if IsIn(Content," "):
			Content = AfterSplit(Content," ")
		else:
			break

#	if PrivateVars != "":
#		PrivateVars = "private:\n\t//private variables\n"+PrivateVars+"\n"
#
#	if PublicVars != "":
#		PublicVars = "\n\t//public variables\n"+PublicVars

	Complete = "class "+TheName+":\n"+PrivateVars+PublicVars+"\n\t#class constructor\n\tdef __init__(self"+Params+")\n\t\tself.x = x\n\t\tself.y = y\n\n"+ClassContent+"\n"
	return Complete

#method:
def Method(Tabs, Name, Content, CalledBy):
	Last = False
	CanSplit = True
	Complete = ""
	Name = AfterSplit(Name,":")
	TheName = ""
	Type = ""
	Params = ""
	MethodContent = ""
	OtherContent = ""
	NewContent = ""
	LastComp = ""
	Process = ""

	#method:<name>-<type>
	if IsIn(Name,"-"):
		TheName = BeforeSplit(Name,"-")
		Type = AfterSplit(Name,"-")
	#method:<name>
	else:
		TheName = Name

	while Content != "":
		if StartsWith(Content, "params") and Params == "":
			if IsIn(Content," "):
				Process = BeforeSplit(Content," ")
			else:
				Process = Content

			Params = Parameters(Process,"method")
		#ignore content if calling a "method" or a "class"
		elif StartsWith(Content, "method:") or StartsWith(Content, "class:"):
			break
		else:
			#This is called when a called from the "class" method
			# EX: class:name method:first method:second
			if IsIn(Content," method:"):
				cmds = split(Content," method:")
				Content = cmds[0]
			if StartsWith(Content, "method-"):
				all = split(Content," ")
				noMore = False
				end = len(all)
				lp = 0
				while lp != end:
					if StartsWith(all[lp], "method-") and noMore == False:
						if OtherContent == "":
							OtherContent = all[lp]
						else:
							OtherContent = OtherContent+" "+all[lp]
					else:
						if NewContent == "":
							NewContent = all[lp]
						else:
							NewContent = NewContent+" "+all[lp]
						noMore = True
					lp += 1
				CanSplit = False
			else:
				OtherContent = Content
				CanSplit = True

			OtherContent = ReplaceTag(OtherContent, "method-")
			MethodContent = MethodContent + GenCode(Tabs+"\t",OtherContent)
			Content = NewContent

			OtherContent = ""
			NewContent = ""
		if Last:
			break

		if IsIn(Content," "):
			if CanSplit:
				Content = AfterSplit(Content," ")
		else:
			Content = ""
			Last = True

	#Handle Parameters from a class
	if CalledBy == "Class" and Params != "":
		Params = "self, "+Params
	elif CalledBy == "Class" and Params == "":
		Params = "self"

	if MethodContent != "":
		Complete = Tabs+"def "+TheName+"("+Params+"):\n"+MethodContent+"\n\treturn TheReturn"
	else:
		Complete = Tabs+"def "+TheName+"("+Params+"):\n"+Tabs+"\t"+GenCode("","stmt:comment")+"\n"+"\n"

	return Complete

def Conditions(input,CalledBy):
	Condit = AfterSplit(input,":")
	Condit = replaceAll(Condit, "|", " ")
	if CalledBy == "class":
		print("condition: "+CalledBy)
	elif CalledBy == "method":
		print("condition: "+CalledBy)
	elif CalledBy == "loop":
		print("condition: "+CalledBy)

	return Condit

#params:
def Parameters(input, CalledBy):
	Params = AfterSplit(input,":")
	if CalledBy == "class" or CalledBy == "method" or CalledBy == "stmt":
		#param-type,param-type,param-type
		if IsIn(Params,"-") and IsIn(Params,","):
			#param
			Name = BeforeSplit(Params,"-")
			#param-type,param-type
			more = AfterSplit(Params,",")
			#recursion to get more parameters
			more = Parameters("params:"+more,CalledBy)
			#param, param, param
			Params = Name+", "+more
		#param-type
		elif IsIn(Params,"-") and not IsIn(Params,","):
			#param
			Params = BeforeSplit(Params,"-")
		#param
		#No code is needed to handle no data type

	return Params

#loop:
def Loop(Tabs, TheKindType, Content):

	Last = False
	Complete = ""
	RootTag = ""
	TheCondition = ""
	LoopContent = ""
	NewContent = ""
	OtherContent = ""

	#loop:<type>
	if IsIn(TheKindType,":"):
		TheKindType = AfterSplit(TheKindType,":")

	if IsIn(TheKindType,"-"):
		TheName = BeforeSplit(TheKindType,"-")
		Type = AfterSplit(TheKindType,"-")

	#content for loop
	while Content != "":
		Content = ReplaceTag(Content, "loop-")

		if StartsWith(Content, "condition:"):
			if IsIn(Content," "):
				TheCondition = BeforeSplit(Content," ");
				Content = AfterSplit(Content," ")
			else:
				TheCondition = Content
			TheCondition = Conditions(TheCondition,TheKindType)

		#nest-<type> <other content>
		#{or}
		#<other content> nest-<type>
		if not StartsWith(Content, "nest-") and IsIn(Content," nest-"):
			#This section is meant to make sure the recursion is handled correctly
			#The nested loops and logic statements are split accordingly

			#split string wherever a " nest-" is located
			#ALL "nest-" are ignored...notice there is no space before the "nest-"
			all = split(Content," nest-")
			end = len(all)
			lp = 0
			while lp != end:
				#This content will be processed as content for loop
				if lp == 0:
					#nest-<type>
					#{or}
					#<other content>
					OtherContent = all[lp]
				#The remaining content is for the next loop
				#nest-<type> <other content> nest-<type> <other content>
				elif lp == 1:
					NewContent = "nest-"+all[lp]
				else:
					NewContent = NewContent + " nest-"+all[lp]
				lp += 1
			#Generate the loop content
			LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent)
			#The remaning content gets processed
			Content = NewContent
			#reset old and new content
			OtherContent = ""
			NewContent = ""

		#stop recursive loop if the next element is a "method" or a "class"
		if StartsWith(Content, "method:") or StartsWith(Content, "class:"):
			break
		#nest-<type>
		elif StartsWith(Content, "nest-"):
			#"nest-loop" becomes ["nest-", "oop"]
			#{or}
			#"nest-logic" becomes ["nest-", "ogic"]
			RootTag = BeforeSplit(Content,'l')
			#check of " nest-l" is in content
			if IsIn(Content," "+RootTag+"l"):
				#This section is meant to separate the "nest-loop" from the "nest-logic"
				#loops won't process logic and vise versa

				#split string wherever a " nest-l" is located
				#ALL "nest-l" are ignored...notice there is no space before the "nest-l"
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

			#no " nest-l" found
			else:
				OtherContent = Content

			Content = NewContent

			#"nest-loop" and "nest-nest-loop" becomes "loop"
			while StartsWith(OtherContent, "nest-"):
				OtherContent = AfterSplit(OtherContent,"-")

			LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent)
			#nest-stmt: or nest-var:
			if StartsWith(OtherContent, "stmt:") or StartsWith(OtherContent, "var:"):
				#This code works, however, it does mean that parent recursion
				#does not have any content. Only nested statements give content to
				OtherContent = ""
				Content = ""

			NewContent = ""

		elif StartsWith(Content, "loop-") or StartsWith(Content, "var:") or StartsWith(Content, "stmt:"):
			Content = ReplaceTag(Content, "loop-")
			LoopContent = LoopContent + GenCode(Tabs+"\t",Content)
			Content = ""

		#no nested content
		else:
			Content = ""

		#no content left to process
		if Last:
			break

		#one last thing to process
		if not IsIn(Content," "):
			#kill after one more loop
			Last = True
	#loop:for
	if TheKindType == "for":
		if LoopContent != "":
			Complete = Tabs+"for "+TheCondition+":\n"+LoopContent
		else:
			Complete = Tabs+"for "+TheCondition+":\n"+Tabs+"\t"+GenCode("","stmt:comment")+"\n"

#	#loop:do/while
#	elif TheKindType == "do/while":
#		Complete = Tabs+"do\n"+Tabs+"{\n"+LoopContent+Tabs+"}\n"+Tabs+"while ("+TheCondition+");\n"

	#loop:while
	else:
		if LoopContent != "":
			Complete = Tabs+"while "+TheCondition+":\n"+LoopContent
		else:
			Complete = Tabs+"while "+TheCondition+":\n"+Tabs+"\t"+GenCode("","stmt:comment")+"\n"

	return Complete

#logic:
def Logic(Tabs, TheKindType, Content):
	Last = False
	Complete = ""
	RootTag = ""
	TheCondition = ""
	LogicContent = ""
	NewContent = ""
	OtherContent = ""

	if IsIn(TheKindType,":"):
		TheKindType = AfterSplit(TheKindType,":")

	while Content != "":
		Content = ReplaceTag(Content, "logic-")

		if StartsWith(Content, "condition:"):
			if IsIn(Content," "):
				TheCondition = BeforeSplit(Content," ")
				Content = AfterSplit(Content," ")
			else:
				TheCondition = Content
			TheCondition = Conditions(TheCondition,TheKindType)

		#This part of the code is meant to separate the nested content with the current content
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
			#Process the current content so as to keep from redoing said content
			LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent)
			Content = NewContent
			OtherContent = ""
			NewContent = ""

		if StartsWith(Content, "method:") or StartsWith(Content, "class:"):
			break
		#This is to handle nested loops and logic
		elif StartsWith(Content, "nest-"):
			RootTag = BeforeSplit(Content,"l")
			if IsIn(Content," "+RootTag+"l"):
				#split up the loops and logic accordingly
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

			while StartsWith(OtherContent, "nest-"):
				OtherContent = AfterSplit(OtherContent,"-")

			LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent)
			#nest-stmt: or nest-var:
			if StartsWith(OtherContent, "stmt:") or StartsWith(OtherContent, "var:"):
				#This code works, however, it does mean that parent recursion
				#does not have any content. Only nested statements give content to

				OtherContent = ""
				Content = ""
			NewContent = ""

		elif StartsWith(Content, "logic-") or StartsWith(Content, "var:") or StartsWith(Content, "stmt:"):
			Content = ReplaceTag(Content, "logic-")
			LogicContent = LogicContent + GenCode(Tabs+"\t",Content)
			Content = ""
		else:
			Content = ""

		if Last:
			break

		if not IsIn(Content," "):
			Last = True

	if TheKindType == "if":
		if LogicContent != "":
			Complete = Tabs+"if "+TheCondition+":\n"+LogicContent
		else:
			Complete = Tabs+"if "+TheCondition+":\n"+Tabs+"\t"+GenCode("","stmt:comment")+"\n"

	elif TheKindType == "else-if":
		if LogicContent != "":
			Complete = Tabs+"elif "+TheCondition+":\n"+LogicContent
		else:
			Complete = Tabs+"elif "+TheCondition+"\n"+Tabs+"\t"+GenCode("","stmt:comment")+"\n"

	elif TheKindType == "else":
		if LogicContent != "":
			Complete = Tabs+"else:\n"+LogicContent
		else:
			Complete = Tabs+"else:\n"+Tabs+"\t"+GenCode("","stmt:comment")+"\n"

	elif TheKindType == "switch-case":
		Complete = Tabs+"\tcase x:\n"+Tabs+GenCode("","stmt:comment")+"\t\tbreak;"

	elif StartsWith(TheKindType, "switch"):
		CaseContent = TheKindType
		CaseVal = ""

		Complete = Tabs+"switch ("+TheCondition+")\n"+Tabs+"{\n\n"
		while CaseContent != "":
			CaseVal = BeforeSplit(CaseContent,"-")
			if CaseVal != "switch":
				Complete = Complete+Tabs+"\tcase "+CaseVal+":\n"+Tabs+"\t\t#code here\n"+Tabs+"\t\tbreak;\n"

			if IsIn(CaseContent,"-"):
				CaseContent = AfterSplit(CaseContent,"-")

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
		TheKindType = AfterSplit(TheKindType,":")

	if IsIn(TheKindType,"-"):
		TheName = BeforeSplit(TheKindType,"-")
		Name = AfterSplit(TheKindType,"-")

	else:
		TheName = TheKindType

	while Content != "":
		#This handles the parameters of the statements
		if StartsWith(Content, "params") and Params == "":
			if IsIn(Content," "):
				Process = BeforeSplit(Content," ")
			else:
				Process = Content
			Params =  Parameters(Process,"stmt")

		if Last:
			break

		while StartsWith(Content, "nest-"):
			Content = AfterSplit(Content,"-")

		if not IsIn(Content," "):
			StatementContent = StatementContent + GenCode(Tabs,Content)
			Last = True
		else:
			OtherContent = BeforeSplit(Content," ")
			StatementContent = StatementContent + GenCode(Tabs,OtherContent)
			Content = AfterSplit(Content," ")

	if TheName == "method":
		Complete = Name+"("+Params+")"+StatementContent

	elif TheName == "comment":
		Complete = StatementContent+"#Code goes here"

	elif TheName == "endline":
		Complete = StatementContent+"\n"

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
	VariableContent = ""
	OtherContent = ""

	while Content != "":
		if StartsWith(Content, "params"):
			OtherContent = OtherContent+" "+BeforeSplit(Content," ")
			Content = AfterSplit(Content," ")

		if Last:
			break

		while StartsWith(Content, "nest-"):
			Content = AfterSplit(Content,"-")

		if not IsIn(Content," "):
			VariableContent = VariableContent + GenCode(Tabs,Content)
			Last = True
		else:
			OtherContent = BeforeSplit(Content," ")
			VariableContent = VariableContent + GenCode(Tabs,OtherContent)
			Content = AfterSplit(Content," ")
	#var:name-dataType=Value
	if IsIn(TheKindType,":") and IsIn(TheKindType,"-") and IsIn(TheKindType,"=") and not EndsWith(TheKindType, "="):
		Type = AfterSplit(TheKindType,":")
		Name = BeforeSplit(Type,"-")
		VarType = AfterSplit(Type,"-")
		Value = AfterSplit(VarType,"=")
		VarType = BeforeSplit(VarType,"=")
		NewVar = Tabs+Name+" = "+Value
		NewVar = NewVar+VariableContent

	#var:name=Value
	elif IsIn(TheKindType,":") and (not IsIn(TheKindType,"-")) and IsIn(TheKindType,"=") and not EndsWith(TheKindType, "="):
		Type = AfterSplit(TheKindType,":")
		Name = BeforeSplit(Type,"=")
		Value = AfterSplit(Type,"=")
		NewVar = Tabs+Name+" = "+Value
		NewVar = NewVar+VariableContent
		print(NewVar)

	#var:name-dataType=
	elif IsIn(TheKindType,":") and IsIn(TheKindType,"-") and EndsWith(TheKindType, "="):
		Type = AfterSplit(TheKindType,":")
		Name = BeforeSplit(Type,"-")
		VarType = AfterSplit(Type,"-")
		VarType = BeforeSplit(VarType,"=")
		NewVar = Tabs+Name+" = "
		NewVar = NewVar+VariableContent

	#var:name=
	elif IsIn(TheKindType,":") and not IsIn(TheKindType,"-") and EndsWith(TheKindType, "="):
		Type = AfterSplit(TheKindType,":")
		Name = BeforeSplit(Type,"=")
		Value = AfterSplit(Type,"=")
		NewVar = Tabs+Name+" = "
		NewVar = NewVar+VariableContent

	#var:name-dataType
	elif IsIn(TheKindType,":") and IsIn(TheKindType,"-") and IsIn(TheKindType,"="):
		Type = AfterSplit(TheKindType,":")
		Name = BeforeSplit(Type,"-")
		VarType = AfterSplit(Type,"-")
		NewVar = Tabs+Name
		NewVar = NewVar+VariableContent

	return NewVar

def GenCode(Tabs,GetMe,CalledBy=""):
	TheCode = ""
	Args = ["",""]

	if IsIn(GetMe," "):
		Args[0] = BeforeSplit(GetMe," ")
		Args[1] = AfterSplit(GetMe," ")
	else:
		Args[0] = GetMe
		Args[1] = ""

	if StartsWith(Args[0], "class:"):
		TheCode = Class(Args[0],Args[1])

	elif StartsWith(Args[0], "struct:"):
		TheCode = Struct(Args[0],Args[1])

	elif StartsWith(Args[0], "method:"):
		TheCode = Method(Tabs,Args[0],Args[1],CalledBy)

	elif StartsWith(Args[0], "loop:"):
		TheCode = Loop(Tabs,Args[0],Args[1])

	elif StartsWith(Args[0], "logic:"):
		TheCode = Logic(Tabs,Args[0],Args[1])

	elif StartsWith(Args[0], "var:"):
		TheCode = Variables(Tabs, Args[0], Args[1])

	elif StartsWith(Args[0], "stmt:"):
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
