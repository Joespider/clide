import os
import sys
import platform

Version = "0.0.94"

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


def ReplaceTag(Content, Tag, All):
	if IsIn(Content," ") and StartsWith(Content, Tag):
		remove = True
		NewContent = ""
		Next = ""
		all = split(Content," ")
		end = len(all)
		lp = 0
		while lp != end:
			Next = all[lp]
			#element starts with tag
			if (StartsWith(Next, Tag)) and (remove == True):
				#remove tag
				Next = AfterSplit(Next,"-")
				if (All):
					remove = False

			if NewContent == "":
				NewContent = Next
			else:
				NewContent = NewContent+" "+Next
			lp += 1
		Content = NewContent

	#Parse Content as long as there is a Tag found at the beginning
	elif not IsIn(Content," ") and StartsWith(Content, Tag):
		#removing tag
		Content = AfterSplit(Content,"-")
	return Content

def banner():
	cplV = getCplV()
	theOS = getOS()
	print(cplV)
	print("[python " + str(Version) + "] on " + str(theOS))
	print("Type \"help\" for more information.")

def TranslateTag(Input):
	TheReturn = ""
	Action = Input
	Value = ""
	VarName = ""
	NewTag = ""
	TheDataType = ""
	Nest = ""
	ContentFor = ""
	OldDataType = ""

	if StartsWith(Action, "+-"):
		Action = AfterSplit(Action,"-")
		ContentFor = "logic-"
	elif StartsWith(Action, "o-"):
		Action = AfterSplit(Action,"-")
		ContentFor = "loop-"
	elif StartsWith(Action, "[]-"):
		Action = AfterSplit(Action,"-")
		ContentFor = "method-"
	elif StartsWith(Action, "{}-"):
		Action = AfterSplit(Action,"-")
		ContentFor = "class-"

	# ">" becomes "nest-"
	while StartsWith(Action, ">"):
		Action = AfterSplit(Action,">")
		Nest = "nest-"+Nest

	if (StartsWith(Action, "if:")) or (StartsWith(Action, "else-if:")):
		Value = AfterSplit(Action,":")
		Action = BeforeSplit(Action,":")
		NewTag = "logic:"+Action
		Value = "logic-condition:"+Value
		TheReturn = ContentFor+Nest+NewTag+" "+Value
	elif Action == "else":
		NewTag = "logic:"+Action
		TheReturn = ContentFor+Nest+NewTag
	elif (StartsWith(Action, "while:")) or (StartsWith(Action, "for:")) or (StartsWith(Action, "do-while:")):
		Value = AfterSplit(Action,":")
		Action = BeforeSplit(Action,":")
		NewTag = "loop:"+Action
		Value = "loop-condition:"+Value
		TheReturn = ContentFor+Nest+NewTag+" "+Value
	elif (StartsWith(Action, "{")) and (IsIn(Action,"}")):
		TheDataType = BeforeSplit(Action,"}")
		TheDataType = AfterSplit(TheDataType,"{")
		Action = AfterSplit(Action,"}")
		if IsIn(Action,":"):
			Value = AfterSplit(Action,":")
			Action = BeforeSplit(Action,":")
		if Value != "":
			TheReturn = "class:"+Action+" params:"+Value
		else:
			TheReturn = "class:"+Action
	elif (StartsWith(Action, "[")) and (IsIn(Action,"]")):
		TheDataType = BeforeSplit(Action,"]")
		TheDataType = AfterSplit(TheDataType,"[")
		Action = AfterSplit(Action,"]")
		#calling a function
		if StartsWith(Action, ":"):
			Value = AfterSplit(Action,":")
			Action = TheDataType
			TheReturn = ContentFor+Nest+"stmt:method-"+Action+" params:"+Value
		#is a function
		else:
			TheDataType = DataType(TheDataType,False)
			if IsIn(Action,":"):
				Value = AfterSplit(Action,":")
				Action = BeforeSplit(Action,":")

			if Value != "":
				TheReturn = ContentFor+Nest+"method:("+TheDataType+")"+Action+" params:"+Value
			else:
				TheReturn = ContentFor+Nest+"method:("+TheDataType+")"+Action
	elif (StartsWith(Action, "(")) and (IsIn(Action,")")):
		TheDataType = BeforeSplit(Action,")")
		TheDataType = AfterSplit(TheDataType,"(")
		Action = AfterSplit(Action,")")

		if IsIn(Action,":"):
			Value = AfterSplit(Action,":")
			Action = BeforeSplit(Action,":")

		if Value != "":
			#translate value, if needed
			Value = TranslateTag(Value)
#			Value = GenCode("",Value)
			TheReturn = ContentFor+Nest+"var:("+TheDataType+")"+Action+"= "+Value
		else:
			TheReturn = ContentFor+Nest+"var:("+TheDataType+")"+Action
	elif Action == "el":
		TheReturn = ContentFor+Nest+"stmt:endline"
	elif Action == "nl":
		TheReturn = ContentFor+Nest+"stmt:newline"
	elif Action == "tab":
		TheReturn = ContentFor+Nest+"stmt:"+Action
	else:
		if Value != "":
			TheReturn = ContentFor+Nest+Action+":"+Value
		else:
			TheReturn = ContentFor+Nest+Action
	return TheReturn

def DataType(Type, getNull):
	#handle strings
	if (((Type == "String") or (Type == "string") or (Type == "std::string")) and (getNull == False)):
		return ""
	elif (((Type == "String") or (Type == "string") or (Type == "std::string")) and (getNull == True)):
		return "\"\""
	elif (((Type == "boolean") or (Type == "bool")) and (getNull == False)):
		return ""
	elif ((Type == "boolean") or (Type == "bool")) and (getNull == True):
		return "False"
	elif (Type == "false") or (Type == "False"):
		return "False"
	elif (Type == "true") or (Type == "True"):
		return "True"
	else:
		if getNull == False:
			return Type
		else:
			return ""

#condition:
def Conditions(input,CalledBy):
	Condit = AfterSplit(input,":")

	if IsIn(Condit,"(-eq)"):
		Condit = replaceAll(Condit, "(-eq)"," == ")

	if IsIn(Condit,"(-le)"):
		Condit = replaceAll(Condit, "(-le)"," <= ")

	if IsIn(Condit,"(-lt)"):
		Condit = replaceAll(Condit, "(-lt)"," < ")

	if IsIn(Condit,"(-ne)"):
		Condit = replaceAll(Condit, "(-ne)"," != ")

	if IsIn(Condit,"(-spc)"):
		Condit = replaceAll(Condit, "(-spc)"," ")

	if IsIn(Condit," "):
		Conditions = split(Condit," ")
		lp = 0
		end = len(Conditions)
		Keep = ""
		while lp != end:
			Conditions[lp] = TranslateTag(Conditions[lp])
			Keep = Conditions[lp]
			Conditions[lp] = GenCode("",Conditions[lp])
			if Conditions[lp] == "":
				Conditions[lp] = Keep
			lp = lp+1
		Condit = Join(Conditions, " ")
	else:
		Condit = DataType(Condit,False)
		OldCondit = Condit
		Condit = TranslateTag(Condit)
		Condit = GenCode("",Condit)

		if Condit == "":
			Condit = OldCondit

	#logic
	if IsIn(Condit,"(-not)"):
		Condit = replaceAll(Condit, "(-not)","not ")

	if IsIn(Condit,"(-or)"):
		Condit = replaceAll(Condit, "(-or)",") or (")
		Condit = "("+Condit+")"

	if IsIn(Condit,"(-and)"):
		Condit = replaceAll(Condit, "(-and)",") and (")
		Condit = "("+Condit+")"

	#convert
	return Condit

#params:
def Parameters(input,CalledBy):
	Params = AfterSplit(input,":")

	if CalledBy == "class" or CalledBy == "method" or CalledBy == "stmt":
		#param-type,param-type,param-type
		if StartsWith(Params,"(") and IsIn(Params,")") and IsIn(Params,","):
			Name = BeforeSplit(Params,",")
			more = AfterSplit(Params,",")
			Type = BeforeSplit(Name,")")

			Name = AfterSplit(Name,")")
			Type = AfterSplit(Type,"(")
			Type = DataType(Type,False)
			more = Parameters("params:"+more,CalledBy)
			Params = Name+", "+more
		#param-type
		elif StartsWith(Params,"(") and IsIn(Params,")"):
			Name = AfterSplit(Params,")")
			Type = BeforeSplit(Params,")")

			Type = AfterSplit(Type,"(")
			Type = DataType(Type,False)
			Params = Name
	return Params

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
			ClassContent = ClassContent + GenCode("\t",Content)

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
def Method(Tabs, Name, Content):
	Last = False
	CanSplit = True
	ReturnVar = "TheReturn"
	DefaultValue = ""
	Complete = ""
	Name = AfterSplit(Name,":")
	TheName = ""
	Type = ""
	Params = ""
	MethodContent = ""
	OtherContent = ""
	NewContent = ""
	Process = ""

	#method:(<type>)<name>
	if StartsWith(Name,"(") and IsIn(Name,")"):
		Type = BeforeSplit(Name,")")
		Type = AfterSplit(Type,"(")
		#get method name
		TheName = AfterSplit(Name,")")
		if IsIn(Name,"-"):
			ReturnVar = AfterSplit(Type,"-")
			Type = BeforeSplit(Type,"-")

		DefaultValue = DataType(Type,True)

		#Converting data type to correct C++ type
#		Type = DataType(Type,False)
	#method:<name>
	else:
		#get method name
		TheName = Name

	while Content != "":
		#params:
		if StartsWith(Content, "params:") and Params == "":
			if IsIn(Content," "):
				Process = BeforeSplit(Content," ")
			else:
				Process = Content

			Params =  Parameters(Process,"method")

		#ignore content if calling a "method" or a "class"
		elif StartsWith(Content, "method:") or StartsWith(Content, "class:"):
			break
		else:
			# This is called when a called from the "class" method
			# EX: class:name method:first method:second
			if IsIn(Content," method:"):
				#Only account for the first method content
				cmds = split(Content," method:")
				Content = cmds[0]

			if StartsWith(Content, "method-"):
				all = split(Content," ")
				noMore = False
				lp = 0
				end = len(all)
				while lp != end:
					#This processes ONLY method-<content>
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
					lp = lp + 1
				CanSplit = False
			else:
				OtherContent = Content
				CanSplit = True

#			OtherContent = ReplaceTag(OtherContent, "method-")

			ParseContent = ""
			Corrected = ""

			cmds = split(OtherContent," ")
			end = len(cmds)
			lp = 0
			while lp != end:
				Corrected = ReplaceTag(cmds[lp], "method-",False)
				#starts with "logic:" or "loop:"
				if StartsWith(Corrected,"logic:") or StartsWith(Corrected,"loop:") or StartsWith(Corrected,"var:") or StartsWith(Corrected,"stmt:"):
					#Only process code that starts with "logic:" or "loop:"
					if ParseContent != "":
						#process content
						MethodContent = MethodContent + GenCode(Tabs+"\t",ParseContent)
					#Reset content
					ParseContent = Corrected
				#start another line to process
				else:
					#append content
					ParseContent = ParseContent +" "+ Corrected
				lp = lp + 1;

			#process the rest
			if ParseContent != "":
				OtherContent = ParseContent

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

	#build method based on content
	if Type == "" or Type == "void":
		Complete = Tabs+"def "+TheName+"("+Params+"):\n"+MethodContent+"\n"
	else:
		if DefaultValue == "":
			Complete = Tabs+"def "+TheName+"("+Params+"):\n"+Tabs+"\t"+ReturnVar+" = "+DefaultValue+"\n"+MethodContent+"\n"+Tabs+"\treturn "+ReturnVar+"\n"
		else:
			Complete = Tabs+"def "+TheName+"("+Params+"):\n"+Tabs+"\t"+ReturnVar+" = "+DefaultValue+"\n"+MethodContent+"\n"+Tabs+"\treturn "+ReturnVar+"\n"
	return Complete

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
	if StartsWith(TheKindType, "loop:"):
		#loop
		TheKindType = AfterSplit(TheKindType,":")

	#content for loop
	while Content != "":
		Content = ReplaceTag(Content, "loop-",False)
#		Content = ReplaceTag(Content, "loop-",True)

		if StartsWith(Content, "condition"):
			if IsIn(Content," "):
				TheCondition = BeforeSplit(Content," ")
				Content = AfterSplit(Content," ")
				#Content = ReplaceTag(Content, "loop-",False)
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
				lp = lp + 1;
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
			RootTag = BeforeSplit(Content,"l")
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
					lp = lp + 1

			#no " nest-l" found
			else:
				OtherContent = Content

			Content = NewContent

			#"nest-loop" and "nest-nest-loop" becomes "loop"
			while StartsWith(OtherContent, "nest-"):
				OtherContent = AfterSplit(OtherContent,"-")

			#handle the content if the first tag is a stmt: or var:
			if StartsWith(OtherContent, "stmt:") or StartsWith(OtherContent, "var:") and IsIn(OtherContent," "):
				#examine each tag
				cmds = split(OtherContent," ")
				OtherContent = ""
				NewContent = ""
				end = len(cmds)
				lp = 0
				while lp != end:
					#as long as the beginning of the tag is stmt:, var:, or params: make sure to build the non-loop/logic tags
					if IsIn(cmds[lp],"stmt:") or IsIn(cmds[lp],"var:") or IsIn(cmds[lp],"params:") and NewContent == "":
						if OtherContent == "":
							OtherContent = cmds[lp]
						else:
							OtherContent = OtherContent+" "+cmds[lp]
					#build the rest of the content
					else:
						if NewContent == "":
							NewContent = cmds[lp]
						else:
							NewContent = NewContent+" "+cmds[lp]
					lp = lp + 1

				#processes all the statements before a loop/logic
				LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent)

				#Lets group the nested tages one more time...I am not sure how to avoide this being done again
				if StartsWith(NewContent, "nest-"):
					RootTag = BeforeSplit(NewContent,"l")
					if IsIn(NewContent," "+RootTag+"l"):
						#split up the loops and logic accordingly
						cmds = split(NewContent," "+RootTag+"l")
						NewContent = ""
						end = len(cmds)
						lp = 0
						while lp != end:
							if lp == 0:
								OtherContent = cmds[lp]
								#remove all nest-
								while StartsWith(OtherContent, "nest-"):
									OtherContent = AfterSplit(OtherContent,"-")
								#process loop/logic
								LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent)
							else:
								if NewContent == "":
									NewContent = RootTag+"l"+cmds[lp]
								else:
									NewContent = NewContent+" "+RootTag+"l"+cmds[lp]
							lp = lp + 1

					while StartsWith(NewContent, "nest-"):
						NewContent = AfterSplit(NewContent,"-")
					#process the remaining nest-loop/logic
					LoopContent = LoopContent + GenCode(Tabs+"\t",NewContent)
			#just process as is
			else:
				LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent)
			#clear new content
			NewContent = ""

		elif StartsWith(Content, "var:") or StartsWith(Content, "stmt:"):
#			Content = ReplaceTag(Content, "loop-",True)
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
		Complete = Tabs+"for "+TheCondition+":\n"+LoopContent

#	#loop:do-while
#	elif TheKindType == "do-while":
#		Complete = Tabs+"do\n"+Tabs+"{\n"+LoopContent+Tabs+"}\n"+Tabs+"while ("+TheCondition+");\n"
	#loop:while
	else:
		Complete = Tabs+"while "+TheCondition+":\n"+LoopContent
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

	if StartsWith(TheKindType, "logic:"):
		TheKindType = AfterSplit(TheKindType,":")

	while Content != "":
		Content = ReplaceTag(Content, "logic-",False)
#		Content = ReplaceTag(Content, "logic-",True)

		if StartsWith(Content, "condition"):
			if IsIn(Content," "):
				TheCondition = BeforeSplit(Content," ")
				Content = AfterSplit(Content," ")
				#Content = ReplaceTag(Content, "logic-",False)
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
				lp = lp + 1
			#Process the current content so as to keep from redoing said content
			LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent)
			Content = NewContent
			OtherContent = ""
			NewContent = ""

		if StartsWith(Content, "method:") or StartsWith(Content, "class:"):
			break

		#This is to handle nested loops and logic
		elif StartsWith(Content, "nest-"):
			#nest-logic
			# or
			#nest-loop
			RootTag = BeforeSplit(Content,"l")
			if IsIn(Content," "+RootTag+"l"):
				#split up the loops and logic accordingly
				cmds = split(Content," "+RootTag+"l")
				end = len(cmds)
				lp = 0
				while lp != end:
					#process now
					if lp == 0:
						#this tag already contains the nest-logic or nest-loop
						#this will be processed and the following will be ignored for the next recurrsive cycle
						OtherContent = cmds[lp]
					#process later
					else:
						#build the next elements
						if NewContent == "":
							#put back in the nest-l
							NewContent = RootTag+"l"+cmds[lp]
						else:
							#put back in the nest-l and append
							NewContent = NewContent+" "+RootTag+"l"+cmds[lp]
					lp = lp + 1
			#no need to split nested
			else:
				OtherContent = Content

			#the new content will be looped
			Content = NewContent

			#remove all nest- tags from content
			while StartsWith(OtherContent, "nest-"):
				OtherContent = AfterSplit(OtherContent,"-")

			#handle the content if the first tag is a stmt: or var:
			if (StartsWith(OtherContent, "stmt:") or StartsWith(OtherContent, "var:") and IsIn(OtherContent," ")):
				#examine each tag
				cmds = split(OtherContent," ")
				OtherContent = ""
				NewContent = ""
				end = len(cmds)
				lp = 0
				while lp != end:
					#as long as the beginning of the tag is stmt:, var:, or params: make sure to build the non-loop/logic tags
					if (IsIn(cmds[lp],"stmt:") or IsIn(cmds[lp],"var:") or IsIn(cmds[lp],"params:")) and NewContent == "":
						if OtherContent == "":
							OtherContent = cmds[lp]
						else:
							OtherContent = OtherContent+" "+cmds[lp]
					#build the rest of the content
					else:
						if NewContent == "":
							NewContent = cmds[lp]
						else:
							NewContent = NewContent+" "+cmds[lp]
					lp = lp + 1

				#processes all the statements before a loop/logic
				LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent)

				#Lets group the nested tages one more time...I am not sure how to avoide this being done again
				if StartsWith(NewContent, "nest-"):
					RootTag = BeforeSplit(NewContent,"l")
					if IsIn(NewContent," "+RootTag+"l"):
						#split up the loops and logic accordingly
						cmds = split(NewContent," "+RootTag+"l")
						NewContent = ""
						end = len(cmds)
						lp = 0
						while lp != end:
							if lp == 0:
								OtherContent = cmds[lp]
								#remove all nest-
								while StartsWith(OtherContent, "nest-"):
									OtherContent = AfterSplit(OtherContent,"-")
								#process loop/logic
								LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent)
							else:
								if NewContent == "":
									NewContent = RootTag+"l"+cmds[lp]
								else:
									NewContent = NewContent+" "+RootTag+"l"+cmds[lp]
							lp = lp + 1
					#remove all nest-
					while StartsWith(NewContent, "nest-"):
						NewContent = AfterSplit(NewContent,"-")

					#process the remaining nest-loop/logic
					LogicContent = LogicContent + GenCode(Tabs+"\t",NewContent)

			#just process as is
			else:
				LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent)

			#clear new content
			NewContent = ""
		elif StartsWith(Content, "var:") or StartsWith(Content, "stmt:"):
#			Content = ReplaceTag(Content, "logic-",False)
			LogicContent = LogicContent + GenCode(Tabs+"\t",Content)
			Content = ""
		else:
			Content = ""

		if Last:
			break

		if not IsIn(Content," "):
			Last = True

	if TheKindType == "if":
		Complete = Tabs+"if "+TheCondition+":\n"+LogicContent
	elif TheKindType == "else-if":
		Complete = Tabs+"elif "+TheCondition+":\n"+LogicContent
	elif TheKindType == "else":
		Complete = Tabs+"else:\n"+LogicContent
	elif TheKindType == "switch-case":
		Complete = Tabs+"\tcase x:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;"
	elif StartsWith(TheKindType, "switch"):
		CaseContent = TheKindType
		CaseVal

		Complete = Tabs+"switch ("+TheCondition+")\n"+Tabs+"{\n\n"
		while CaseContent != "":
			CaseVal = BeforeSplit(CaseContent,"-")
			if CaseVal != "switch":
				Complete = Complete+Tabs+"\tcase "+CaseVal+":\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n"

			if IsIn(CaseContent,"-"):
				CaseContent = AfterSplit(CaseContent,"-")
		Complete = Complete+Tabs+"\tdefault:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n"+Tabs+"}\n"
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

	if StartsWith(TheKindType, "stmt:"):
		TheKindType = AfterSplit(TheKindType,":")

	if IsIn(TheKindType,"-"):
		TheName = BeforeSplit(TheKindType,"-")
		Name = AfterSplit(TheKindType,"-")
	else:
		TheName = TheKindType

	while Content != "":
		#This handles the parameters of the statements
		if StartsWith(Content, "params:") and Params == "":
			if IsIn(Content," "):
				Process = BeforeSplit(Content," ")
			else:
				Process = Content

			Params = Parameters(Process,"stmt")

			if IsIn(Params,"(-spc)"):
				Params = replaceAll(Params, "(-spc)"," ")

		if Last:
			break

		while StartsWith(Content, "nest-"):
			Content = AfterSplit(Content,"-")

		if not IsIn(Content," "):
			StatementContent = StatementContent + GenCode(Tabs,Content)
			Last = True
		else:
			OtherContent = BeforeSplit(Content," ")
			Content = AfterSplit(Content," ")
			if StartsWith(Content, "params:"):
				OtherContent = OtherContent+" "+BeforeSplit(Content," ")
				Content = AfterSplit(Content," ")

			if StartsWith(OtherContent,"loop:") and Content != "" or StartsWith(OtherContent,"logic:") and Content != "":
				OtherContent = OtherContent+" "+Content
				Content = ""
			StatementContent = StatementContent + GenCode(Tabs,OtherContent)

	if TheName == "method":
		Complete = Name+"("+Params+")"+StatementContent
	elif TheName == "comment":
		Complete = StatementContent+Tabs+"#Code goes here\n"
	elif TheName == "endline":
		Complete = StatementContent+"\n"
	elif TheName == "newline":
		Complete = StatementContent+"\n"
	elif TheName == "tab":
		Complete = "\t"+StatementContent

	return Complete

#var:
def Variables(Tabs, TheKindType, Content):
	Last = False
	MakeEqual = False
	NewVar = ""
	Name = ""
	VarType = ""
	Value = ""
	VariableContent = ""
	OtherContent = ""

	if StartsWith(TheKindType, "var:"):
		TheKindType = AfterSplit(TheKindType,":")

	while Content != "":
		#All params are removed

		if Last:
			break

		while StartsWith(Content, "nest-"):
			Content = AfterSplit(Content,"-")

		if not IsIn(Content," "):
			VariableContent = VariableContent + GenCode(Tabs,Content)
			Last = True
		else:
			OtherContent = BeforeSplit(Content," ")
			Content = AfterSplit(Content," ")
			if StartsWith(Content, "params:"):
				OtherContent = OtherContent+" "+BeforeSplit(Content," ")
				Content = AfterSplit(Content," ")

			if StartsWith(OtherContent,"loop:") and Content != "" or StartsWith(OtherContent,"logic:") and Content != "":
				OtherContent = OtherContent+" "+Content
				Content = ""
			VariableContent = VariableContent + GenCode(Tabs,OtherContent)

	#Pull Variable Type
	if StartsWith(TheKindType,"(") and IsIn(TheKindType,")"):
		VarType = BeforeSplit(TheKindType,")")
		VarType = AfterSplit(VarType,"(")
		VarType = DataType(VarType,False)
		TheKindType = AfterSplit(TheKindType,")")
		Name = TheKindType

	#Assign Value
	if IsIn(TheKindType,"="):
		MakeEqual = True
		Name = BeforeSplit(TheKindType,"=")
		Value = AfterSplit(TheKindType,"=")

#	if VarType != "":
#		NewVar = VarType+" "

	if MakeEqual == True:
		if IsIn(Value,"(-spc)"):
			Value = replaceAll(Value, "(-spc)"," ")

		NewVar = NewVar+Name+" = "+Value
	else:
		NewVar = NewVar+Name
	NewVar = NewVar+VariableContent

	return NewVar

def GenCode(Tabs, GetMe):
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
		TheCode = Method(Tabs,Args[0],Args[1])
	elif StartsWith(Args[0], "loop:"):
		TheCode = Loop(Tabs,Args[0],Args[1])
	elif StartsWith(Args[0], "logic:"):
		TheCode = Logic(Tabs,Args[0],Args[1])
	elif StartsWith(Args[0], "var:"):
		TheCode = Variables(Tabs, Args[0], Args[1])
	elif StartsWith(Args[0], "stmt:"):
		TheCode = Statements(Tabs, Args[0], Args[1])
	return TheCode

def Example(tag):
	UserIn = ""
	print("\t{EXAMPLE}")
	print("Command: "+tag)
#	print("\t---or---")
	if IsIn(tag," "):
		all = split(tag," ")
		end = len(all)
		lp = 0
		while lp != end:
			if UserIn == "":
				UserIn = TranslateTag(all[lp])
			else:
				UserIn = UserIn + " " + TranslateTag(all[lp])
			lp = lp + 1
	else:
		UserIn = TranslateTag(tag)

#	print("Command: "+UserIn)
	print("");
	UserIn = GenCode("",UserIn)
	print("\t{OUTPUT}")
	print(UserIn)

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
			UserIn = TranslateTag(UserArgs[0])
			lp = 1
			while lp < argc:
				UserIn = UserIn + " " + TranslateTag(UserArgs[lp])
				lp += 1
		else:
			UserIn = raw_input(">>> ")

		if UserIn == "exit()":
			break
		elif UserIn == "exit":
			print("Use exit()")
		elif UserIn == "clear":
			clear()
		elif UserIn == "-v" and argc == 1 or UserIn == "--version" and argc == 1:
			print(Version)
			break
		elif UserIn == "version" and argc == 0:
			print(Version)
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
