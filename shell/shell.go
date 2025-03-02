package main

import (
	"fmt"
	"os"
	"runtime"
	"os/exec"
	"bufio"
	"strings"
	)

func getOS() string {
	os := runtime.GOOS
	switch os {
		case "windows":
			return "Windows"
		case "darwin":
			return "MAC"
		case "linux":
			return "Linux"
		default:
			return "Unknown"
	}
}

func help(Type string) {
	Type = AfterSplit(Type,":")
	if Type == "class" {
		fmt.Println("{Usage}")
		fmt.Println(Type+":<name> param:<params>,<param> var(public/private):<vars> method:<name>-<type> param:<params>,<param>")
		fmt.Println("")
		fmt.Println("{EXAMPLE}")
		fmt.Println(Type+":pizza params:one-int,two-bool,three-float var(private):toppings-int method:cheese-std::string params:four-int,five-int loop:for nest-loop:for")
	} else if Type == "struct" {
		fmt.Println(Type+":<name>-<type> var:<var> var:<var>")
		fmt.Println("")
		fmt.Println("{EXAMPLE}")
		fmt.Println(Type+":pizza var:topping-std::string var:number-int")
	} else if Type == "method" {
		fmt.Println(Type+"(public/private):<name>-<type> param:<params>,<param>")
		fmt.Println(Type+":<name>-<type> param:<params>,<param>")
	} else if Type == "loop" {
		fmt.Println(Type+":<type>")
		fmt.Println("")
		fmt.Println("{EXAMPLE}")
		fmt.Println(Type+":for")
		fmt.Println(Type+":do/while")
		fmt.Println(Type+":while")

	} else if Type == "logic" {
		fmt.Println(Type+":<type>")
		fmt.Println("")
		fmt.Println("{EXAMPLE}")
		fmt.Println(Type+":if")
		fmt.Println(Type+":else-if")
		fmt.Println(Type+":switch")
	} else if Type == "var" {
		fmt.Println(Type+"(public/private):<name>-<type>=value\tcreate a new variable")
		fmt.Println(Type+":<name>-<type>[<num>]=value\tcreate a new variable as an array")
		fmt.Println(Type+":<name>-<type>(<struct>)=value\tcreate a new variable a data structure")
		fmt.Println(Type+":<name>=value\tassign a new value to an existing variable")
		fmt.Println("")
		fmt.Println("{EXAMPLE}")
		fmt.Println(Type+":name-std::string[3]")
		fmt.Println(Type+":name-std::string(vector)")
		fmt.Println(Type+":name-std::string=\"\" var:point-int=0 stmt:endline var:james-std::string=\"James\" stmt:endline var:help-int")
	} else if Type == "stmt" {
		fmt.Println(Type+":<type>")
		fmt.Println(Type+":endline\t\tPlace the \"\" at the end of the statement")
		fmt.Println(Type+":newline\t\tPlace and empty line")
		fmt.Println(Type+":method-<name>\tcall a method and the name of the method")
	} else {
		fmt.Println("Components to Generate")
		fmt.Println("class\t\t:\t\"Create a class\"")
		fmt.Println("struct\t\t:\t\"Create a struct\"")
		fmt.Println("method\t\t:\t\"Create a method\"")
		fmt.Println("loop\t\t:\t\"Create a loop\"")
		fmt.Println("logic\t\t:\t\"Create a logic\"")
		fmt.Println("var\t\t:\t\"Create a variable\"")
		fmt.Println("stmt\t\t:\t\"Create a statment\"")
		fmt.Println("nest-<type>\t:\t\"next element is nested in previous element\"")
		fmt.Println("")
		fmt.Println("help:<type>")
	}
}

//User Input
func raw_input(Message string) string {
	var UserIn string
	fmt.Print(Message)
	reader := bufio.NewReader(os.Stdin)
	UserIn, _ = reader.ReadString('\n')
	if UserIn != "" {
		UserIn = UserIn[:len(UserIn)-1]
	}
	return UserIn
}

/*
void clear()
{
	shellExe("clear")
}

func Exe() {
	//execute
	cmd := exec.Command("touch", "me")
	stdout, err := cmd.Output()

	if err != nil {
		fmt.Println(err.Error())
		return
	}

	fmt.Print(string(stdout))
}

void shellExe(String command)
{
	system(command.c_str())
}
*/

func Shell(command string) string {
	if command != "" {
		out, err := exec.Command(command).Output()
		if err != nil {
			return ""
		} else {
			output := string(out[:])
			return output
		}
	} else {
		return ""
	}
}

func getCplV() string {
	var cplV string = Shell("go version")
	return cplV
}

//Check if sub-string is in string
func IsIn(Str string, Sub string) bool {
	return strings.Contains(Str,Sub)
}

//Check if string begins with substring
func StartsWith(Str string, Sub string) bool {
	return strings.HasPrefix(Str,Sub)
}

//Check if string ends with substring
func EndsWith(Str string, Sub string) bool {
	return strings.HasSuffix(Str,Sub)
}

func BeforeSplit(Str string, splitAt string) string {
	if strings.Contains(Str,splitAt) {
		var result []string  = strings.SplitAfterN(Str, splitAt,2)
		var newResult string = result[0]
		newResult = newResult[:len(newResult)-1]
		return newResult
	} else {
		return ""
	}
}

func AfterSplit(Str string, splitAt string) string {
	if strings.Contains(Str,splitAt) {
		var result []string  = strings.SplitAfterN(Str, splitAt,2)
		return result[1]
	} else {
		return ""
	}
}

func split(Str string, sBy string) []string {
	Array := strings.Split(Str, sBy)
	return Array
}

func replaceAll(Str string, sBy string, ToJoin string) string {
	newStr := strings.ReplaceAll(Str, sBy, ToJoin)
	return newStr
}



/*
	----[shell]----
*/


func banner() {
	var cplV string = getCplV()
	var theOS string = getOS()
	var Version string = "0.0.1"
	fmt.Println(cplV)
	fmt.Println("[Go " + Version +"] on " + theOS)
	fmt.Println("Type \"help\" for more information.")
}

func Struct(TheName string, Content string) string {
	var Complete string
	var StructVar string
	var Process string
	TheName = AfterSplit(TheName,":")
	for StartsWith(Content, "var") {
		Process = BeforeSplit(Content," ")
		Content = AfterSplit(Content," ")
		StructVar = StructVar + GenCode("\t",Process)
	}
	Complete = "struct {\n"+StructVar+"\n} "+TheName+";\n"
	return Complete
}

func Class(TheName string, Content string) string {
	var Complete string
	var PrivateVars string
	var PublicVars string
	var VarContent string
/*
	String PublicOrPrivate = ""
	if StartsWith(TheName,"class("))
	if IsIn(TheName,")"))
	{
		PublicOrPrivate = AfterSplit(TheName,"(")
		PublicOrPrivate = BeforeSplit(PublicOrPrivate,")")
	}
*/
	TheName = AfterSplit(TheName,":")
	var Process string
	var Params string
	var ClassContent string
	for Content != "" {
		if StartsWith(Content, "params") && Params == "" {
			Process = BeforeSplit(Content," ")
			Params =  Parameters(Process,"class")
		} else if StartsWith(Content, "method") {
			ClassContent = ClassContent + GenCode("\t",Content)
		} else if StartsWith(Content, "var") {
			if StartsWith(Content, "var(public)") {
				Content = AfterSplit(Content,")")
				VarContent = BeforeSplit(Content," ")
				VarContent = "var"+VarContent
				PublicVars = PublicVars + GenCode("\t",VarContent)
			} else if StartsWith(Content, "var(private)") {
				Content = AfterSplit(Content,")")
				VarContent = BeforeSplit(Content," ")
				VarContent = "var"+VarContent
				PrivateVars = PrivateVars  + GenCode("\t",VarContent)
			}
		}

		if IsIn(Content," ") {
			Content = AfterSplit(Content," ")
		} else {
			break
		}
	}

	if PrivateVars != "" {
		PrivateVars = "private:\n\t//private variables\n"+PrivateVars+"\n"
	}
	if PublicVars != "" {
		PublicVars = "\n\t//public variables\n"+PublicVars
	}

	Complete = "class "+TheName+" {\n\n"+PrivateVars+"public:"+PublicVars+"\n\t//class constructor\n\t"+TheName+"("+Params+")\n\t{\n\t\tthis->x = x;\n\t\tthis->y = y;\n\t}\n\n"+ClassContent+"\n\t//class desctructor\n\t~"+TheName+"()\n\t{\n\t}\n};\n"
	return Complete
}

func Method(Tabs string, Name string, Content string) string {
	var Complete string
	Name = AfterSplit(Name,":")
	var TheName string
	var Type string
	var Params string
	var MethodContent string
	var Process string

	if IsIn(Name,"-") {
		TheName = BeforeSplit(Name,"-")
		Type = AfterSplit(Name,"-")
	} else {
		TheName = Name
	}

	for Content != "" {
		if StartsWith(Content, "params") && Params == "" {
			if IsIn(Content," ") {
				Process = BeforeSplit(Content," ")
			} else 	{
				Process = Content
			}
			Params =  Parameters(Process,"method")
		} else if StartsWith(Content, "method") || StartsWith(Content, "class") {
			break
		} else {
			if IsIn(Content," method") {
				var cmds []string = split(Content," method")
				Content = cmds[0]
			}
			MethodContent = MethodContent + GenCode(Tabs+"\t",Content)
		}

		if IsIn(Content," ") {
			Content = AfterSplit(Content," ")
		} else {
			break
		}
	}

	if Type == "" || Type == "void" {
		Complete = Tabs+"void "+TheName + "("+Params+")\n"+Tabs+"{\n"+MethodContent+"\n"+Tabs+"}\n"
	} else {
		Complete = Tabs+Type+" "+TheName+"("+Params+")\n"+Tabs+"{\n"+Tabs+"\t" +Type+" TheReturn;\n"+MethodContent+"\n"+Tabs+"\treturn TheReturn;\n"+Tabs+"}\n"
	}
	return Complete
}

func Conditions(input string, CalledBy string) string {
	var Condit string = AfterSplit(input,":")
	Condit = replaceAll(Condit, "|", " ")
	if CalledBy == "class" {
		fmt.Println("condition: " + CalledBy)
	} else if CalledBy == "method" {
		fmt.Println("condition: " + CalledBy)
	} else if CalledBy == "loop" {
		fmt.Println("condition: " + CalledBy)
	}
	return Condit
}

func Parameters(input string, CalledBy string) string {
	var Params string = AfterSplit(input,":")
	if CalledBy == "class" || CalledBy == "method" || CalledBy == "stmt" {
		if IsIn(Params,"-") && IsIn(Params,",") {
			var Name string = BeforeSplit(Params,"-")
			var Type string = AfterSplit(Params,"-")
			Type = BeforeSplit(Type,",")
			var more string = AfterSplit(Params,",")
			more = Parameters("params:"+more,CalledBy)
			Params = Type+" "+Name+", "+more
		} else if IsIn(Params,"-") && !IsIn(Params,",") {
			var Name string = BeforeSplit(Params,"-")
			var Type string = AfterSplit(Params,"-")
			Params = Type+" "+Name
		}
	}
	return Params
}

//loop:
func Loop(Tabs string, TheKindType string, Content string) string {
	var Last bool = false
	var Complete string
	var RootTag string
	var TheCondition string
	var LoopContent string
	var NewContent string
	var OtherContent string

	if IsIn(TheKindType,":") {
		TheKindType = AfterSplit(TheKindType,":")
	}

	for Content != "" {
		if !StartsWith(Content, "nest-") && IsIn(Content," nest-") {
			var all []string = split(Content," nest-")
			var end int = len(all)
			var lp int = 0
			for lp != end {
				if lp == 0 {
					OtherContent = all[lp]
				} else if lp == 1 {
					NewContent = "nest-"+all[lp]
				} else {
					NewContent = NewContent + " nest-"+all[lp]
				}
				lp++
			}
			LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent)
			Content = NewContent
			OtherContent = ""
			NewContent = ""
		}

		if StartsWith(Content, "condition") {
			TheCondition = Conditions(Content,TheKindType)
		} else if StartsWith(Content, "method") || StartsWith(Content, "class") {
			break
		//nest-loop:
		} else if StartsWith(Content, "nest-") 	{
			RootTag = BeforeSplit(Content,"l")
			if IsIn(Content," "+RootTag+"l") {
				var cmds []string = split(Content," "+RootTag+"l")
				var end int = len(cmds)
				var lp int = 0
				for lp != end {
					if lp == 0 {
						OtherContent = cmds[lp]
					} else {
						if NewContent == "" {
							NewContent = RootTag+"l"+cmds[lp]
						} else {
							NewContent = NewContent+" "+RootTag+"l"+cmds[lp]
						}
					}
					lp++
				}
			} else {
				OtherContent = Content
			}

			Content = NewContent
			NewContent = ""

			for StartsWith(OtherContent, "nest-") {
				OtherContent = AfterSplit(OtherContent,"-")
			}
			LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent)
		} else {
			LoopContent = LoopContent + GenCode(Tabs+"\t",Content)
			Content = ""
		}

		if Last {
			break
		}

		if !IsIn(Content," ") {
			Last = true
		}
	}
	//loop:for
	if TheKindType == "for" {
		Complete = Tabs+"for ("+TheCondition+")\n"+Tabs+"{\n"+LoopContent+Tabs+"}\n"
	//loop:do/while
	} else if TheKindType == "do/while" {
		Complete = Tabs+"do\n"+Tabs+"{\n"+LoopContent+Tabs+"}\n"+Tabs+"while ("+TheCondition+");\n"
	//loop:while
	} else {
		Complete = Tabs+"while ("+TheCondition+")\n"+Tabs+"{\n"+LoopContent+Tabs+"}\n"
	}
	return Complete
}

//logic:
func Logic(Tabs string, TheKindType string, Content string) string {
	var Last bool = false
//	var NestTabs string
	var Complete string
//	var TheName string
//	var Type string
	var RootTag string
	var TheCondition string
	var LogicContent string
	var NewContent string
	var OtherContent string

	if IsIn(TheKindType,":") {
		TheKindType = AfterSplit(TheKindType,":")
	}
/*
	if IsIn(TheKindType,"-"))
	{
		TheName = BeforeSplit(TheKindType,"-")
		Type = AfterSplit(TheKindType,"-")
	}
*/


	for Content != "" {
		if !StartsWith(Content, "nest-") && IsIn(Content," nest-") {
			var all []string = split(Content," nest-")
			var end int = len(all)
			var lp int = 0
			for lp != end {
				if lp == 0 {
					OtherContent = all[lp]
				} else if lp == 1 {
					NewContent = "nest-"+all[lp]
				} else {
					NewContent = NewContent + " nest-"+all[lp]
				}
				lp++
			}
			LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent)
			Content = NewContent
			OtherContent = ""
			NewContent = ""
		}

		if StartsWith(Content, "condition") {
			if IsIn(Content," ") {
				TheCondition = BeforeSplit(Content," ")
				Content = AfterSplit(Content," ")
			} else {
				TheCondition = Content
			}
			TheCondition = Conditions(TheCondition,TheKindType)
		} else if StartsWith(Content, "method") || StartsWith(Content, "class") {
			break
		} else if StartsWith(Content, "nest-") {
			RootTag = BeforeSplit(Content,"l")
			if IsIn(Content," "+RootTag+"l") {
				var cmds []string = split(Content," "+RootTag+"l")
				var end int = len(cmds)
				var lp int = 0
				for lp != end {
					if lp == 0 {
						OtherContent = cmds[lp]
					} else {
						if NewContent == "" {
							NewContent = RootTag+"l"+cmds[lp]
						} else {
							NewContent = NewContent+" "+RootTag+"l"+cmds[lp]
						}
					}
					lp++
				}
			} else {
				OtherContent = Content
			}

			Content = NewContent
			NewContent = ""

			for StartsWith(OtherContent, "nest-") {
				OtherContent = AfterSplit(OtherContent,"-")
			}
			LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent)
		} else {
			LogicContent = LogicContent + GenCode(Tabs+"\t",Content)
			Content = ""
		}

		if Last {
			break
		}

		if !IsIn(Content," ") {
			Last = true
		}
	}

	if TheKindType == "if" {
		Complete = Tabs+"if ("+TheCondition+")\n"+Tabs+"{\n"+LogicContent+Tabs+"}\n"
	} else if TheKindType == "else-if" {
		Complete = Tabs+"else if ("+TheCondition+")\n"+Tabs+"{\n"+LogicContent+Tabs+"}\n"
	} else if TheKindType == "else" {
		Complete = Tabs+"else\n"+Tabs+"{\n"+LogicContent+Tabs+"}\n"
	} else if TheKindType == "switch-case" {
		Complete = Tabs+"\tcase x:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;"
	} else if StartsWith(TheKindType, "switch") {
		var CaseContent string = TheKindType
		var CaseVal string

		Complete = Tabs+"switch ("+TheCondition+")\n"+Tabs+"{\n\n"
		for CaseContent != "" {
			CaseVal = BeforeSplit(CaseContent,"-")
			if CaseVal != "switch" {
				Complete = Complete+Tabs+"\tcase "+CaseVal+":\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n"
			}

			if IsIn(CaseContent,"-") {
				CaseContent = AfterSplit(CaseContent,"-")
			}
		}
		Complete = Complete+Tabs+"\tdefault:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak;\n"+Tabs+"}\n"
	}
	return Complete
}

//stmt:
func Statements(Tabs string, TheKindType string, Content string) string {
	var Last bool = false
	var Complete string
	var StatementContent string
	var OtherContent string
	var TheName string
	var Name string
	var Process string
	var Params string

	if IsIn(TheKindType,":") {
		TheKindType = AfterSplit(TheKindType,":")
	}

	if IsIn(TheKindType,"-") {
		TheName = BeforeSplit(TheKindType,"-")
		Name = AfterSplit(TheKindType,"-")
	} else {
		TheName = TheKindType
	}

	for Content != "" {
		if StartsWith(Content, "params") && Params == "" {
			if IsIn(Content," ") {
				Process = BeforeSplit(Content," ")
			} else {
				Process = Content
			}
			Params =  Parameters(Process,"stmt")
		} else {
			OtherContent = BeforeSplit(Content," ")
			StatementContent = StatementContent + GenCode(Tabs,OtherContent)
			Content = AfterSplit(Content," ")
		}

		if Last {
			break
		}

		if !IsIn(Content," ") {
			StatementContent = StatementContent + GenCode(Tabs,Content)
			Last = true
		}
	}
	if TheName == "method" {
		Complete = Name+"("+Params+")"+StatementContent
	} else if TheName == "comment" {
		Complete = StatementContent+Tabs+"#Code goes here\n"
	} else if TheName == "endline" {
		Complete = StatementContent+";\n"
	} else if TheName == "newline" {
		Complete = StatementContent+"\n"
	}

	return Complete
}

//var:
func Variables(Tabs string, TheKindType string, Content string) string {
	var Last bool = false
	var NewVar string
	var Type string
	var Name string
	var VarType string
	var Value string
	var VariableContent string
	var OtherContent string

	for Content != "" {
		OtherContent = BeforeSplit(Content," ")
		Content = AfterSplit(Content," ")
		if StartsWith(Content, "params") {
			OtherContent = OtherContent+" "+BeforeSplit(Content," ")
			Content = AfterSplit(Content," ")
		}
		VariableContent = VariableContent + GenCode(Tabs,OtherContent)

		if Last {
			break
		}

		if !IsIn(Content," ") {
			VariableContent = VariableContent + GenCode(Tabs,Content)
			Last = true
		}
	}
	//var:name-dataType=Value
	if IsIn(TheKindType,":") && IsIn(TheKindType,"-") && IsIn(TheKindType,"=") && !EndsWith(TheKindType, "=") {
		Type = AfterSplit(TheKindType,":")
		Name = BeforeSplit(Type,"-")
		VarType = AfterSplit(Type,"-")
		Value = AfterSplit(VarType,"=")
		VarType = BeforeSplit(VarType,"=")
		NewVar = Tabs+VarType+" "+Name+" = "+Value
		NewVar = NewVar+VariableContent
	//var:name=Value
	} else if IsIn(TheKindType,":") && !IsIn(TheKindType,"-") && IsIn(TheKindType,"=") && !EndsWith(TheKindType, "=") {
		Type = AfterSplit(TheKindType,":")
		Name = BeforeSplit(Type,"=")
		Value = AfterSplit(Type,"=")
		NewVar = Tabs+Name+" = "+Value
		NewVar = NewVar+VariableContent
	//var:name-dataType=
	} else if IsIn(TheKindType,":") && IsIn(TheKindType,"-") && EndsWith(TheKindType, "=") {
		Type = AfterSplit(TheKindType,":")
		Name = BeforeSplit(Type,"-")
		VarType = AfterSplit(Type,"-")
		VarType = BeforeSplit(VarType,"=")
		NewVar = Tabs+VarType+" "+Name+" = "
		NewVar = NewVar+VariableContent
	//var:name=
	} else if IsIn(TheKindType,":") && !IsIn(TheKindType,"-") && EndsWith(TheKindType, "=") {
		Type = AfterSplit(TheKindType,":")
		Name = BeforeSplit(Type,"=")
		Value = AfterSplit(Type,"=")
		NewVar = Tabs+Name+" = "
		NewVar = NewVar+VariableContent
	//var:name-dataType
	} else if IsIn(TheKindType,":") && IsIn(TheKindType,"-") && !IsIn(TheKindType,"=") {
		Type = AfterSplit(TheKindType,":")
		Name = BeforeSplit(Type,"-")
		VarType = AfterSplit(Type,"-")
		NewVar = Tabs+VarType+" "+Name
		NewVar = NewVar+VariableContent
	}
	return NewVar
}

func GenCode(Tabs string, GetMe string) string {
	var TheCode string
	var Args = [2]string{"", ""}

	if IsIn(GetMe," ") {
		Args[0] = BeforeSplit(GetMe," ")
		Args[1] = AfterSplit(GetMe," ")

	} else {
		Args[0] = GetMe
		Args[1] = ""
	}

	if StartsWith(Args[0], "class") {
		TheCode = Class(Args[0],Args[1])

	} else if StartsWith(Args[0], "struct") {
		TheCode = Struct(Args[0],Args[1])

	} else if StartsWith(Args[0], "method") {
		TheCode = Method(Tabs,Args[0],Args[1])

	} else if StartsWith(Args[0], "loop") {
		TheCode = Loop(Tabs,Args[0],Args[1])

	} else if StartsWith(Args[0], "logic") {
		TheCode = Logic(Tabs,Args[0],Args[1])

	} else if StartsWith(Args[0], "var") {
		TheCode = Variables(Tabs, Args[0], Args[1])

	} else if StartsWith(Args[0], "stmt") {
		TheCode = Statements(Tabs, Args[0], Args[1])
	}
/*
	else if StartsWith(Args[0], "condition"))
	{
		TheCode = Conditions(Args[0])
	}
	else if StartsWith(Args[0], "params"))
	{
		TheCode = Parameters(Args[0])
	}
*/
	return TheCode
}

//main
func main() {
	var UserIn string = ""
	var Content string

	args := os.Args[1:]

	//Args were NOT given
	if len(args) == 0 {
		banner()
	}

	for {
		//Args were given
		if len(args) >= 1 {
			for arg := range args {
				if UserIn == "" {
					UserIn = args[arg]
				} else {
					UserIn = UserIn + " " + args[arg]
				}
			}
		} else 	{
			UserIn = raw_input(">>> ")
		}

		if UserIn == "exit()" {
			break
		} else if UserIn == "exit" {
			fmt.Println("Use exit()")
/*
		} else if UserIn == "clear" {
			clear()
*/
		} else if StartsWith(UserIn, "help") {
			help(UserIn)
		} else {
			Content = GenCode("",UserIn)
			if Content != "" {
				fmt.Println(Content)
			}
		}

		//Args were given
		if len(args) >= 1 {
			break
		}
	}
}
