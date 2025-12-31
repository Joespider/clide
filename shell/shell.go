package main

import (
	"fmt"
	"os"
	"runtime"
	"os/exec"
	"bufio"
	"strings"
	)

var Version string = "0.1.6"

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
		fmt.Println("{}<name>:(<type>)<name> var(public/private):<vars> method:<name>-<type> param:<params>,<param>")
		fmt.Println("")
		fmt.Println("{EXAMPLE}")
		Example("{}pizza:(int)one,(bool)two,(float)three var(private):(int)toppings [String-mixture]cheese:(String)kind,(int)amount for: nest-for: [String]topping:(String)name,(int)amount if:good")
	} else if Type == "struct" {
		fmt.Println("(<type>)<name>")
		fmt.Println("")
	} else if Type == "method" {
		fmt.Println("[<data>]<name>:<parameters>")
		fmt.Println("[<data>-<return>]<name>:<parameters>")
		fmt.Println("")
		Example("[String-Type]FoodAndDrink:(String)Food []-if:Food(-ne)\"\" +->if:[IsDrink]:drink(-eq)true +-()Type=\"Drink\" +-el +->>if:[IsNotEmpty]:Food +-[Drink]:Food +-el +->>>if:mood(-ne)\"happy\" +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->>>>if:mood(-eq)\"unhappy\" +-[ChearUp]:mood +-el +-[print]:\"I(-spc)am(-spc)\"+mood +-el <<<<-+-[ImHappy]: <<<<-+-el <<<-+-[Refill]: <<<-+-el <<-+-[Complete]: <<-+-el <<-+-[NewLine]: <<-+-el +->else-if:[IsFood]:Food(-eq)true +-()Type=\"Food\" +-el +->>while:[IsNotEmpty]:Food o-[Eat]:Food o-el o->>if:mood(-ne)\"happy\" +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->>>do-while:mood(-eq)\"unhappy\" o-[ChearUp]:mood o-el o-[print]:\"I(-spc)am(-spc)\"+mood o-el <<<<-+-[print]:\"I(-spc)am(-spc)\"+mood+\"(-spc)now\" <<<<-+-el +->else +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el []-else +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el []-nl []-[print]:\"It(-spc)works!!!\" []-el")
		Example("[]clock []-(int)time:[start]: []-el []-nl []-if:here +-[stop]: +-el []-nl []-[begin]: []-el []-nl []-if: +-[end]: +-el []-else +-[reset]: +-el []-for: o-[count]: o-el")
	} else if Type == "loop" {
		fmt.Println("<loop>:<condition>")
		fmt.Println("")
		fmt.Println("{loop}")
		fmt.Println("for:")
		fmt.Println("do-while:")
		fmt.Println("while:")
		fmt.Println("")
		fmt.Println("{EXAMPLE}")
		fmt.Println("")
		Example("while:Type(-spc)==(-spc)\"String\"")
		Example("do-while:Type(-eq)\"String\" o-[work]: o-el")
		Example("while:true >if:[IsString]:drink(-eq)true [drink]: el >>if:drink(-eq)\"coke\" >>else nl >else-if:[IsInt]:drink(-eq)false nl >else >>if: nl >>else nl")
		Example("while:true >if:[IsString]:drink(-eq)true >>if:drink(-eq)\"coke\" >>else nl >else-if:[IsInt]:drink(-eq)false nl >else >>if: >>nl >>else nl")
		Example("while:Food(-ne)\"\" o->if:[IsDrink]:drink(-eq)true +-()Type=\"Drink\" +-el +->>while:[IsNotEmpty]:Food o-[Drink]:Food o-el o->>>if:mood(-ne)\"happy\" +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->>>>do-while:mood(-eq)\"unhappy\" o-[ChearUp]:mood o-el o-[print]:\"I(-spc)am(-spc)\"+mood o-el <<<<-+-[print]:\"I(-spc)am(-spc)\"+mood+\"(-spc)now\" <<<<-+-el o->else-if:[IsDrink]:drink(-eq)true +-()Type=\"Drink\" +-el +->>while:[IsNotEmpty]:Food o-[Drink]:Food o-el o->>>if:mood(-ne)\"happy\" +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->>>>do-while:mood(-eq)\"unhappy\" o-[ChearUp]:mood o-el o-[print]:\"I(-spc)am(-spc)\"+mood o-el <<<<-+-[print]:\"I(-spc)am(-spc)\"+mood+\"(-spc)now\" <<<<-+-el o->else +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el")
	} else if Type == "logic" {
		fmt.Println("<logic>:<condition>");
		fmt.Println("");
		fmt.Println("{logic}");
		fmt.Println("if:");
		fmt.Println("else-if:");
		fmt.Println("else");
		fmt.Println("");
		fmt.Println("{EXAMPLE}")
		fmt.Println("")
		Example("if:Type(-spc)==(-spc)\"String\"")
		Example("else-if:Type(-eq)\"String\"")
		Example("else")
		Example("if:true (String)drink:[Pop]:one,two el >if:[IsString]:drink(-eq)true [drink]: el >>if:drink(-eq)\"coke\" >>else nl >else-if:[IsInt]:drink(-eq)false nl >else >>if: nl >>else nl")
		Example("if:true (String)drink:[Pop]:one,two el >if:[IsString]:drink(-eq)true >>if:drink(-eq)\"coke\" >>else nl >else-if:[IsInt]:drink(-eq)false nl >else >>if: nl >>else nl")
		Example("if:Food(-ne)\"\" +->if:[IsDrink]:drink(-eq)true +-()Type=\"Drink\" +-el +->>if:[IsNotEmpty]:Food +-[Drink]:Food +-el +->>>if:mood(-ne)\"happy\" +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->>>>if:mood(-eq)\"unhappy\" +-[ChearUp]:mood +-el +-[print]:\"I(-spc)am(-spc)\"+mood +-el <<<<-+-[ImHappy]: <<<<-+-el <<<-+-[Refill]: <<<-+-el <<-+-[Complete]: <<-+-el <<-+-[NewLine]: <<-+-el +->else-if:[IsFood]:Food(-eq)true +-()Type=\"Food\" +-el +->>while:[IsNotEmpty]:Food o-[Eat]:Food o-el o->>if:mood(-ne)\"happy\" +-[print]:\"I(-spc)am(-spc)\"+mood +-el +->>>do-while:mood(-eq)\"unhappy\" o-[ChearUp]:mood o-el o-[print]:\"I(-spc)am(-spc)\"+mood o-el <<<<-+-[print]:\"I(-spc)am(-spc)\"+mood+\"(-spc)now\" <<<<-+-el +->else +-(Type)=\"Not(-spc)Food(-spc)or(-spc)Drink\" +-el")
	} else if Type == "var" {
		Example("(std::string)name=\"\" var:(int)point=0 stmt:endline var:james-std::string=\"James\" stmt:endline var:help-int")
		Example("(std::string)name=\"\" el (int)point=0 el (std::string)james=\"James\" el (int)help el help=0")
		Example("(std::string)name=\"\" el (int)point=0 el (std::string)james=\"James\" el (int)help el help=0")
	} else if Type == "stmt" {
		fmt.Println(Type+":<type>")
		fmt.Println(Type+":method\t\tcall a method")
		fmt.Println(Type+":endline\t\tPlace the \";\" at the end of the statement")
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
		fmt.Println(">\t:\t\"next loop/logic element is nested in previous loop/logic\"")
		fmt.Println("[]-<type>\t:\t\"assigne the next element to method content only\"")
		fmt.Println("+-<type>\t:\t\"assigne the next element to logic content only\"")
		fmt.Println("o-<type>\t:\t\"assigne the next element to loop content only\"")
		fmt.Println("<-<type>\t:\t\"assigne the next element to previous element\"")
		fmt.Println("<<-<type>\t:\t\"assigne the next element to 2 previous element\"")
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

func join(Array []string, ToJoin string) string {
	Joined := strings.Join(Array, ToJoin)
	return Joined
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

func ReplaceTag(Content string, Tag string, All bool) string {
	if IsIn(Content," ") && StartsWith(Content, Tag) {
		var remove bool = true
		var NewContent string = ""
		var Next string = ""
		var all []string = split(Content," ")
		var end int = len(all)
		var lp int = 0
		for lp != end {
			Next = all[lp]
			//element starts with tag
			if StartsWith(Next, Tag) && remove == true {
				//remove tag
				Next = AfterSplit(Next,"-")
				if All {
					remove = false
				}
			}

			if NewContent == "" {
				NewContent = Next
			} else 	{
				NewContent = NewContent+" "+Next
			}
			lp++
		}
		Content = NewContent
	//Parse Content as long as there is a Tag found at the beginning
	} else if !IsIn(Content," ") && StartsWith(Content, Tag) {
		//removing tag
		Content = AfterSplit(Content,"-")
	}
	return Content
}

func banner() {
	var cplV string = getCplV()
	var theOS string = getOS()
	fmt.Println(cplV)
	fmt.Println("[Go " + Version +"] on " + theOS)
	fmt.Println("Type \"help\" for more information.")
}

func VectAndArray(Name string, TheDataType string, VectorOrArray string, Action string, TheValue string) string {
	var TheReturn string = ""
	if VectorOrArray == "vector" {
		if Action == "variable" {
			if TheValue != "" {
				TheReturn = Name+" "+"[]"+TheDataType+" = "+TheValue
			} else {
				TheReturn = Name+" "+"[]"+TheDataType
			}
		} else {
			if !IsIn(Name,"[") && !IsIn(Name,"]") {
				TheReturn = Name+" = append("+TheValue+")"
			}
		}
	} else if VectorOrArray == "array" {
		var plc string = ""

		if Action == "variable" {
			if IsIn(TheDataType,"[") && EndsWith(TheDataType,"]") {
				plc = AfterSplit(TheDataType,"[")
				plc = BeforeSplit(plc,"]")
				TheDataType = BeforeSplit(TheDataType,"[")
			}
			TheDataType = DataType(TheDataType,false)
			if TheValue != "" {
				TheReturn = Name+" ["+plc+"]"+TheDataType+" = "+TheValue
			} else {
				TheReturn = Name+" "+"["+plc+"]"+TheDataType
			}
		} else {
			if IsIn(Name,"[") && EndsWith(Name,"]") {
				plc = AfterSplit(Name,"[")
				plc = BeforeSplit(plc,"]")
				Name = BeforeSplit(Name,"[")
			}

			if TheValue != "" {
				TheReturn = Name+"["+plc+"] = "+TheValue
			} else {
				TheReturn = Name+"["+plc+"]"
			}
		}
	}

	return TheReturn
}

func TranslateTag(Input string) string {
	var TheReturn string = ""
	var Action string = Input
	var Value string = ""
//	var VarName string = ""
	var NewTag string = ""
	var TheDataType string = ""
	var Nest string = ""
	var ContentFor string = ""
	var Parent string = ""
//	var OldDataType string = ""

	//content for parent loops/logic
	if (StartsWith(Action, "<-")) {
		Action = AfterSplit(Action,"-");
		Parent = "parent-";
	//content for future parent loops/logic
	} else if (StartsWith(Action, "<<")) {
		Action = AfterSplit(Action,"<");
		Parent = "parent-";
	//content for logic
	} else if StartsWith(Action, "+-") {
		Action = AfterSplit(Action,"-")
		ContentFor = "logic-"
	} else if StartsWith(Action, "o-") {
		Action = AfterSplit(Action,"-")
		ContentFor = "loop-"
	} else if StartsWith(Action, "[]-") {
		Action = AfterSplit(Action,"-")
		ContentFor = "method-"
	} else if StartsWith(Action, "{}-") {
		Action = AfterSplit(Action,"-")
		ContentFor = "class-"
	}

	// ">" becomes "nest-"
	for StartsWith(Action, ">") {
		Action = AfterSplit(Action,">")
		Nest = "nest-"+Nest
	}

	if StartsWith(Action, "if:") || StartsWith(Action, "else-if:") {
		Value = AfterSplit(Action,":")
		Action = BeforeSplit(Action,":")
		NewTag = "logic:"+Action
		Value = "logic-condition:"+Value
		TheReturn = Parent+ContentFor+Nest+NewTag+" "+Value
	} else if Action == "else" {
		NewTag = "logic:"+Action
		TheReturn = ContentFor+Nest+NewTag
	} else if StartsWith(Action, "while:") || StartsWith(Action, "for:") || StartsWith(Action, "do-while:") {
		Value = AfterSplit(Action,":")
		Action = BeforeSplit(Action,":")
		NewTag = "loop:"+Action
		Value = "loop-condition:"+Value
		TheReturn = Parent+ContentFor+Nest+NewTag+" "+Value
	//class
	} else if StartsWith(Action, "{") && IsIn(Action,"}") {
		TheDataType = BeforeSplit(Action,"}")
		TheDataType = AfterSplit(TheDataType,"{")
		Action = AfterSplit(Action,"}")

		if IsIn(Action,":") {
			Value = AfterSplit(Action,":")
			Action = BeforeSplit(Action,":")
		}

		if Value != "" {
			TheReturn = "class:"+Action+" params:"+Value
		} else {
			TheReturn = "class:"+Action
		}
	//method
	} else if StartsWith(Action, "[") && IsIn(Action,"]") {
		TheDataType = BeforeSplit(Action,"]")
		TheDataType = AfterSplit(TheDataType,"[")
		Action = AfterSplit(Action,"]")
		//calling a function
		if StartsWith(Action, ":") {
			Value = AfterSplit(Action,":")
			Action = TheDataType
			if Value != "" {
//				TheReturn = Parent+ContentFor+Nest+"stmt:method-"+Action+" params:"+Value
				TheReturn = Parent+ContentFor+"stmt:method-"+Action+" params:"+Value
			} else {
//				TheReturn = Parent+ContentFor+Nest+"stmt:method-"+Action
				TheReturn = Parent+ContentFor+"stmt:method-"+Action
			}
		//is a function
		} else {
			TheDataType = DataType(TheDataType,false)
			if IsIn(Action,":") {
				Value = AfterSplit(Action,":")
				Action = BeforeSplit(Action,":")
			}

			if Value != "" {
				TheReturn = Parent+ContentFor+Nest+"method:("+TheDataType+")"+Action+" params:"+Value
			} else {
				TheReturn = Parent+ContentFor+Nest+"method:("+TheDataType+")"+Action
			}
		}
	//variables
	} else if StartsWith(Action,"(") && IsIn(Action,")") {
		TheDataType = BeforeSplit(Action,")")
		TheDataType = AfterSplit(TheDataType,"(")
		Action = AfterSplit(Action,")")

		if StartsWith(Action,"(") {
			Action = TheDataType+Action
			TheDataType = ""
		}

		if IsIn(Action,":") {
			Value = AfterSplit(Action,":")
			Action = BeforeSplit(Action,":")
		}

		if Value != "" {
			if ContentFor == "logic-" {
				Value = "+-"+Nest+Value
			} else if ContentFor == "loop-" {
				Value = "o-"+Nest+Value
			} else if ContentFor == "method-" {
				Value = "[]-"+Nest+Value
			} else if ContentFor == "class-" {
				Value = "{}-"+Nest+Value
			}

			//translate value, if needed
			Value = TranslateTag(Value)
//			Value = GenCode("",Value)
//			TheReturn = Parent+ContentFor+Nest+"var:("+TheDataType+")"+Action+"= "+Value
			TheReturn = Parent+ContentFor+"var:("+TheDataType+")"+Action+"= "+Value
		} else {
//			TheReturn = Parent+ContentFor+Nest+"var:("+TheDataType+")"+Action
			TheReturn = Parent+ContentFor+"var:("+TheDataType+")"+Action
		}
	//This is an example of handling vecotors and arrays
	//	<type>name:value
	//
	//if value is marked a method, this a vector
	//	<int>list:[getInt]:()numbers
	//if value is marked a static, this is an array
	//	<int>list:()one,()two
	//
	//to assign a value
	//	<list[0]>:4
	//to get from value, seeing there is an index
	//	<list[0]>:
	//to append vectors
	//	<list>:4

	//vectors or arrays
	} else if StartsWith(Action, "<") && IsIn(Action,">") {
		var VectorOrArray string = ""
		TheDataType = BeforeSplit(Action,">")
		TheDataType = AfterSplit(TheDataType,"<")
		Action = AfterSplit(Action,">")

		//replacing data type to represent the variable
		if StartsWith(Action,":") {
			Action = TheDataType+Action
			TheDataType = ""
		}

		if IsIn(Action,":") {
			Value = AfterSplit(Action,":")
			Action = BeforeSplit(Action,":")

			if EndsWith(Action,"]") && Value != "" {
				VectorOrArray = "array:"
			}

			if VectorOrArray == "" {
				if StartsWith(Value,"[") {
					VectorOrArray = "vector:"
				} else {
					VectorOrArray = "array:"
				}
			}
		}

		if TheDataType != "" {
			if EndsWith(TheDataType,"]") {
				VectorOrArray = "array:"
			} else {
				VectorOrArray = "vector:"
			}

			if Value != "" {
				TheReturn = "var:<"+VectorOrArray+TheDataType+">"+Action+":"+Value
			} else {
				TheReturn = "var:<"+VectorOrArray+TheDataType+">"+Action
			}
		} else {
			if Value != "" {
				TheReturn = "stmt:<"+VectorOrArray+TheDataType+">"+Action+":"+Value
			} else 	{
				TheReturn = "stmt:<"+VectorOrArray+TheDataType+">"+Action
			}
		}
	} else if Action == "el" {
//		TheReturn = Parent+ContentFor+Nest+"stmt:endline"
		TheReturn = Parent+ContentFor+"stmt:endline"
	} else if Action == "nl" {
//		TheReturn = Parent+ContentFor+Nest+"stmt:newline"
		TheReturn = Parent+ContentFor+"stmt:newline"
	} else if Action == "tab" {
//		TheReturn = Parent+ContentFor+Nest+"stmt:"+Action
		TheReturn = Parent+ContentFor+"stmt:"+Action
	} else {
		if Value != "" {
			TheReturn = Parent+ContentFor+Nest+Action+":"+Value
		} else {
			TheReturn = Parent+ContentFor+Nest+Action
		}
	}

	return TheReturn
}

 func HandleTabs(_CalledBy string, Tabs string, Content string) string {
	var AutoTabs string = ""
	if Content != "stmt:endline" && Content != "stmt:newline" {
		if StartsWith(Content,"stmt:") || StartsWith(Content,"var:") {
			var AllTabs []string = split(Tabs,"\t")
			var lp int = 0
			var end int = len(AllTabs)
			for lp != (end - 1) {
				AutoTabs = AutoTabs +"stmt:tab "
				lp++
			}
		}
	}
	return AutoTabs
}

func DataType(Type string, getNull bool) string {
	//handle strings
	if (Type == "String" || Type == "string" || Type == "std::string") && getNull == false {
		return "string"
        } else if (Type == "String" || Type == "string" || Type == "std::string") && getNull == true {
		return "\"\""
	} else if (Type == "boolean" || Type == "bool") && getNull == false {
		return "bool"
	} else if (Type == "boolean" || Type == "bool") && getNull == true {
		return "false"
	} else if (Type == "i32" || Type == "int") && getNull == false {
		return "int"
	} else if (Type == "i32" || Type == "int") && getNull == true {
		return "0"
	} else if Type == "false" || Type == "False" {
		return "false"
	} else if Type == "true" || Type == "True" {
		return "true"
	} else {
		if getNull == false {
			return Type
		} else {
			return ""
		}
	}
}

//condition:
func Conditions(input string, CalledBy string) string {
	var Condit string = AfterSplit(input,":")

	if IsIn(Condit,"(-eq)") {
		Condit = replaceAll(Condit, "(-eq)"," == ")
	}

	if IsIn(Condit,"(-le)") {
		Condit = replaceAll(Condit, "(-le)"," <= ")
	}

	if IsIn(Condit,"(-lt)") {
		Condit = replaceAll(Condit, "(-lt)"," < ")
	}

	if IsIn(Condit,"(-ne)") {
		Condit = replaceAll(Condit, "(-ne)"," != ")
	}

	if IsIn(Condit,"(-spc)") {
		Condit = replaceAll(Condit, "(-spc)"," ")
	}

	if IsIn(Condit," ") {
		var Conditions []string = split(Condit," ")
                var lp int = 0
                var end int = len(Conditions)
                var Keep string = ""
		for lp != end {
			Conditions[lp] = TranslateTag(Conditions[lp])
			Keep = Conditions[lp]
			Conditions[lp] = GenCode("",Conditions[lp])
			if Conditions[lp] == "" {
				Conditions[lp] = Keep
			}
			lp++
		}
		Condit = join(Conditions, " ")
	} else {
		Condit = DataType(Condit,false)
		var OldCondit string = Condit
		Condit = TranslateTag(Condit)
		Condit = GenCode("",Condit)

		if Condit == "" {
			Condit = OldCondit
		}
	}

	//logic
	if IsIn(Condit,"(-not)") {
		Condit = replaceAll(Condit, "(-not)","!")
	}

	if IsIn(Condit,"(-or)") {
		Condit = replaceAll(Condit, "(-or)"," || ")
	}

        if IsIn(Condit,"(-and)") {
		Condit = replaceAll(Condit, "(-and)"," && ")
	}
/*
	if StartsWith(Condit, "(") {
		Condit = Condit[1:len(Condit)]
	}

	if EndsWith(Condit, ")") {
		Condit = Condit[:len(Condit)-1]
	}

	if CalledBy == "class" {
		fmt.Println("condition: " + CalledBy)
	} else if CalledBy == "method" {
		fmt.Println("condition: " + CalledBy)
	} else if CalledBy == "loop" {
		fmt.Println("condition: " + CalledBy)
	}
*/
	//convert
	return Condit
}

//params:
func Parameters(input string, CalledBy string) string {
	var Params string = AfterSplit(input,":")

	if CalledBy == "class" || CalledBy == "method" || CalledBy == "stmt" {
		//param-type,param-type,param-type
		if StartsWith(Params,"(") && IsIn(Params,")") && IsIn(Params,",") {
			var Name string = BeforeSplit(Params,",")
			var more string = AfterSplit(Params,",")
			var Type string = BeforeSplit(Name,")")

			Name = AfterSplit(Name,")")
			Type = AfterSplit(Type,"(")
			Type = DataType(Type,false)
			more = Parameters("params:"+more,CalledBy)
			if Name == "" {
				Params = Type+", "+more
			} else {
				Params = Type+" "+Name+", "+more
			}
		//param-type
		} else if StartsWith(Params,"(") && IsIn(Params,")") {
			var Name string = AfterSplit(Params,")")
			var Type string = BeforeSplit(Params,")")

			Type = AfterSplit(Type,"(")
			Type = DataType(Type,false)
			Params = Type+" "+Name
			if Name == "" {
				Params = Type
			}
		}
	}

	return Params
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

//method:
func Method(Tabs string, Name string, Content string) string {
	var Last bool = false
        var CanSplit bool = true
        var ReturnVar string = "TheReturn"
        var DefaultValue string = ""
        var Complete string = ""
        Name = AfterSplit(Name,":")
        var TheName string = ""
        var Type string = ""
        var Params string = ""
        var MethodContent string = ""
        var OtherContent string = ""
        var NewContent string = ""
        var Process string = ""
	var AutoTabs string = ""

	//method:(<type>)<name>
	if StartsWith(Name,"(") && IsIn(Name,")") {
		Type = BeforeSplit(Name,")")
		Type = AfterSplit(Type,"(")
		//get method name
		TheName = AfterSplit(Name,")")
		if IsIn(Name,"-") {
			ReturnVar = AfterSplit(Type,"-")
			Type = BeforeSplit(Type,"-")
		}
		DefaultValue = DataType(Type,true)

		//Converting data type to correct C++ type
		Type = DataType(Type,false)
	//method:<name>
	} else {
		//get method name
		TheName = Name
	}

	for Content != "" {

		//params:
		if StartsWith(Content, "params:") && Params == "" {
			if IsIn(Content," ") {
				Process = BeforeSplit(Content," ")
			} else {
				Process = Content
			}
			Params =  Parameters(Process,"method")

		//ignore content if calling a "method" or a "class"
		} else if StartsWith(Content, "method:") || StartsWith(Content, "class:") {
			break
		} else {
			//This is called when a called from the "class" method
			// EX: class:name method:first method:second
			if IsIn(Content," method:") {
				//Only account for the first method content
				var cmds []string = split(Content," method:")
				Content = cmds[0]
			}

			if StartsWith(Content, "method-") && IsIn(Content, " method-l") {
				var all []string = split(Content," method-l")
				var lp int = 0
				var end int = len(all)
				for lp != end {
					if lp == 0 {
						OtherContent = all[lp]
					} else {
						if NewContent == "" {
							NewContent = "method-l"+all[lp]
						} else {
							NewContent = NewContent+" method-l"+all[lp]
						}
					}
					lp++
				}
				CanSplit = false
			} else {
				OtherContent = Content
				CanSplit = true
			}

			var ParseContent string = ""
			var Corrected string = ""
			if IsIn(OtherContent," method-") {
				var cmds []string = split(OtherContent," method-")
				var end int = len(cmds)
				var lp int = 0
				for lp != end {
					Corrected = ReplaceTag(cmds[lp], "method-",false)
					//starts with "logic:" or "loop:"
					if StartsWith(Corrected,"var:") || StartsWith(Corrected,"stmt:") {
						if ParseContent == "" {
							ParseContent = Corrected
						} else {
							ParseContent = ParseContent+" "+Corrected
						}

						if Corrected == "stmt:newline" || Corrected == "stmt:endline" {
							AutoTabs = HandleTabs("method",Tabs+"\t",ParseContent)

							if AutoTabs != "" {
								//Generate the loop content
								MethodContent = MethodContent + GenCode(Tabs+"\t",AutoTabs)
							}
							//process content
							MethodContent = HandleElse(MethodContent, ParseContent)
							MethodContent = MethodContent + GenCode(Tabs+"\t",ParseContent)
							ParseContent = ""
						}
					} else {
						AutoTabs = HandleTabs("method",Tabs+"\t",Corrected)

						if AutoTabs != "" {
							//Generate the loop content
							MethodContent = MethodContent + GenCode(Tabs+"\t",AutoTabs)
						}
						//process content
						MethodContent = HandleElse(MethodContent, Corrected)
						MethodContent = MethodContent + GenCode(Tabs+"\t",Corrected)
					}
					lp++
				}
			} else {
				Corrected = ReplaceTag(OtherContent, "method-",false)
				AutoTabs = HandleTabs("method",Tabs+"\t",Corrected)

				if AutoTabs != "" {
					//Generate the loop content
					MethodContent = MethodContent + GenCode(Tabs+"\t",AutoTabs)
				}

				//Generate the loop content
				MethodContent = HandleElse(MethodContent, Corrected)
				MethodContent = MethodContent + GenCode(Tabs+"\t",Corrected)
			}
			Content = NewContent

			OtherContent = ""
			NewContent = ""
		}

		if Last {
			break
		}

		if IsIn(Content," ") {
			if CanSplit {
				Content = AfterSplit(Content," ")
			}
		} else {
			Content = ""
			Last = true
		}
	}

	//build method based on content
	if Type == "" || Type == "void" {
		Complete = Tabs+"func "+TheName+"("+Params+") {\n"+MethodContent+"\n"+Tabs+"}\n"
	} else {
                if DefaultValue == "" {
			Complete = Tabs+"func "+TheName+"("+Params+") "+Type+" {\n"+Tabs+"\tvar "+ReturnVar+" "+Type+"\n"+MethodContent+"\n"+Tabs+"\treturn "+ReturnVar+"\n"+Tabs+"}\n"
		} else {
			Complete = Tabs+"func "+TheName+"("+Params+") "+Type+" {\n"+Tabs+"\tvar "+ReturnVar+" "+Type+" = "+DefaultValue+"\n"+MethodContent+"\n"+Tabs+"\treturn "+ReturnVar+"\n"+Tabs+"}\n"
		}
	}

	return Complete
}

//loop:
func Loop(Tabs string, TheKindType string, Content string) string {
	var Last bool = false
	var Complete string = ""
	var RootTag string = ""
	var TheCondition string = ""
	var LoopContent string = ""
	var NewContent string = ""
	var OtherContent string = ""
	var ParentContent string = ""
	var AutoTabs string = ""

	//loop:<type>
	if StartsWith(TheKindType, "loop:") {
		//loop
		TheKindType = AfterSplit(TheKindType,":")
	}

	//content for loop
	for Content != "" {
		Content = ReplaceTag(Content, "loop-",false)
//		Content = ReplaceTag(Content, "loop-",true)

		if StartsWith(Content, "condition") {
			if IsIn(Content," ") {
				TheCondition = BeforeSplit(Content," ")
				Content = AfterSplit(Content," ")
				//Content = ReplaceTag(Content, "loop-",false)
			} else {
				TheCondition = Content
			}
			TheCondition = Conditions(TheCondition,TheKindType)
		}

		//nest-<type> <other content>
		//{or}
		//<other content> nest-<type>
		if !StartsWith(Content, "nest-") && IsIn(Content," nest-") {
			//This section is meant to make sure the recursion is handled correctly
			//The nested loops and logic statements are split accordingly

			//split string wherever a " nest-" is located
			//ALL "nest-" are ignored...notice there is no space before the "nest-"
			var all []string = split(Content," nest-")
			var end int = len(all)
			var lp int = 0
			for lp != end {
				//This content will be processed as content for loop
				if lp == 0 {
					//nest-<type>
					//{or}
					//<other content>
					OtherContent = all[lp]
				//The remaining content is for the next loop
				//nest-<type> <other content> nest-<type> <other content>
				} else if lp == 1 {
					NewContent = "nest-"+all[lp]
				} else {
					NewContent = NewContent + " nest-"+all[lp]
				}
				lp++
			}
			AutoTabs = HandleTabs("loop",Tabs+"\t",OtherContent)
			if AutoTabs != "" {
				LoopContent = LoopContent + GenCode(Tabs+"\t",AutoTabs)
//				AutoTabs = ""
			}

			LoopContent = HandleElse(LoopContent, OtherContent)

			//Generate the loop content
			LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent)

			//The remaning content gets processed
			Content = NewContent
			//reset old and new content
			OtherContent = ""
			NewContent = ""
		}

		//stop recursive loop if the next element is a "method" or a "class"
		if StartsWith(Content, "method:") || StartsWith(Content, "class:") {
			break
		//nest-<type>
		} else if StartsWith(Content, "nest-") {
			//"nest-loop" becomes ["nest-", "oop"]
			//{or}
			//"nest-logic" becomes ["nest-", "ogic"]
			RootTag = BeforeSplit(Content,"l")
			//check of " nest-l" is in content
			if IsIn(Content," "+RootTag+"l") {
				//This section is meant to separate the "nest-loop" from the "nest-logic"
				//loops won't process logic and vise versa

				//split string wherever a " nest-l" is located

				//ALL "nest-l" are ignored...notice there is no space before the "nest-l"
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
			//no " nest-l" found
			} else {
				OtherContent = Content
			}

			Content = NewContent

			//"nest-loop" and "nest-nest-loop" becomes "loop"
			for StartsWith(OtherContent, "nest-") {
				OtherContent = AfterSplit(OtherContent,"-")
			}

			//handle the content if the first tag is a stmt: or var:
			if (StartsWith(OtherContent, "stmt:") || StartsWith(OtherContent, "var:")) && IsIn(OtherContent," ") {
				//examine each tag
				var cmds []string = split(OtherContent," ")
				OtherContent = ""
				NewContent = ""
				var end int = len(cmds)
				var lp int = 0
				for lp != end {
					//as long as the beginning of the tag is stmt:, var:, or params: make sure to build the non-loop/logic tags
					if IsIn(cmds[lp],"stmt:") || IsIn(cmds[lp],"var:") || IsIn(cmds[lp],"params:") && NewContent == "" {
						if OtherContent == "" {
							OtherContent = cmds[lp]
						} else {
							OtherContent = OtherContent+" "+cmds[lp]
						}
					//build the rest of the content
					} else {
						if NewContent == "" {
							NewContent = cmds[lp]
						} else {
							NewContent = NewContent+" "+cmds[lp]
						}
					}
					lp++
				}

				AutoTabs = HandleTabs("loop",Tabs+"\t",OtherContent)
				if AutoTabs != "" {
					LoopContent = LoopContent + GenCode(Tabs+"\t",AutoTabs)
//					AutoTabs = ""
				}
				//This is to handle how Go likes to handle if/else statements...yes, even though this is about loop
				LoopContent = HandleElse(LoopContent, OtherContent)
				//processes all the statements before a loop/logic
				LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent)

				//Lets group the nested tages one more time...I am not sure how to avoide this being done again
				if StartsWith(NewContent, "nest-") {
					RootTag = BeforeSplit(NewContent,"l")
					if IsIn(NewContent," "+RootTag+"l") {
						//split up the loops and logic accordingly
						var cmds []string = split(NewContent," "+RootTag+"l")
						NewContent = ""
						var end int = len(cmds)
						var lp int = 0
						for lp != end {
							if lp == 0 {
								OtherContent = cmds[lp]
								//remove all nest-
								for StartsWith(OtherContent, "nest-") {
									OtherContent = AfterSplit(OtherContent,"-")
								}

								AutoTabs = HandleTabs("loop",Tabs+"\t",OtherContent)
								if AutoTabs != "" {
									LoopContent = LoopContent + GenCode(Tabs+"\t",AutoTabs)
									AutoTabs = ""
								}
								//This is to handle how Go likes to handle if/else statements...yes, even though this is about loops

								LoopContent = HandleElse(LoopContent, OtherContent)
								//process loop/logic
								LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent)
							} else {
								if NewContent == "" {
									NewContent = RootTag+"l"+cmds[lp]
								} else {
									NewContent = NewContent+" "+RootTag+"l"+cmds[lp]
								}
							}
							lp++
						}
					}

					for StartsWith(NewContent, "nest-") {
						NewContent = AfterSplit(NewContent,"-")
					}

					AutoTabs = HandleTabs("loop",Tabs+"\t",NewContent)
					if AutoTabs != "" {
						LoopContent = LoopContent + GenCode(Tabs+"\t",AutoTabs)
						AutoTabs = ""
					}

					//This is to handle how Go likes to handle if/else statements...yes, even though this is about loop
					LoopContent = HandleElse(LoopContent, NewContent)
					//process the remaining nest-loop/logic
					LoopContent = LoopContent + GenCode(Tabs+"\t",NewContent)
				}
			//just process as is
			} else {
				if IsIn(OtherContent," parent-") {
					//examine each tag
					var parent []string = split(OtherContent," parent-")
					OtherContent = ""
					var pEnd int = len(parent)
					var pLp int = 0
					for pLp != pEnd {
						if pLp == 0 || StartsWith(parent[pLp],"<-") || StartsWith(parent[pLp],"<<") {
							if OtherContent == "" {
								OtherContent = parent[pLp];
							} else {
								OtherContent = OtherContent + " " + TranslateTag(parent[pLp])
							}
						} else {
							if ParentContent == "" {
								ParentContent = TranslateTag(parent[pLp])
							} else {
								ParentContent = ParentContent + " " + TranslateTag(parent[pLp])
							}
						}
						pLp++
					}
					ParentContent = ReplaceTag(ParentContent, "loop-",false)
				}

				AutoTabs = HandleTabs("loop",Tabs+"\t",OtherContent)
				if AutoTabs != "" {
					LoopContent = LoopContent + GenCode(Tabs+"\t",AutoTabs)
					AutoTabs = ""
				}

				//This is to handle how Go likes to handle if/else statements...yes, even though this is about loops
				LoopContent = HandleElse(LoopContent, OtherContent)
				LoopContent = LoopContent + GenCode(Tabs+"\t",OtherContent)
			}

			//process parent content
			if ParentContent != "" {

				AutoTabs = HandleTabs("loop",Tabs+"\t",ParentContent)
				if AutoTabs != "" {
					LoopContent = LoopContent + GenCode(Tabs+"\t",AutoTabs)
					AutoTabs = ""
				}

				LoopContent = HandleElse(LoopContent, ParentContent)
				LoopContent = LoopContent + GenCode(Tabs+"\t",ParentContent)
				ParentContent = ""
			}

			//clear new content
			NewContent = ""
		} else if StartsWith(Content, "var:") || StartsWith(Content, "stmt:") {

			AutoTabs = HandleTabs("loop",Tabs+"\t",Content)
			if AutoTabs != "" {
				LoopContent = LoopContent + GenCode(Tabs+"\t",AutoTabs)
				AutoTabs = ""
			}
			//This is to handle how Go likes to handle if/else statements...yes, even though this is about loops
			LoopContent = HandleElse(LoopContent, Content)
//			Content = ReplaceTag(Content, "loop-",true)
			LoopContent = LoopContent + GenCode(Tabs+"\t",Content)

			Content = ""
		//no nested content
		} else {
			Content = ""
		}

		//no content left to process
		if Last {
			break
		}

		//one last thing to process
		if !IsIn(Content," ") {
			//kill after one more loop
			Last = true
		}
	}
	//loop:for
	if TheKindType == "for" {
		Complete = Tabs+"for "+TheCondition+" {\n"+LoopContent+Tabs+"}\n"
	//loop:do/while
	} else if TheKindType == "do/while" {
		Complete = Tabs+"for "+TheCondition+" {\n"+LoopContent+Tabs+"}\n"
	//loop:while
	} else {
		Complete = Tabs+"for "+TheCondition+" {\n"+LoopContent+Tabs+"}\n"
	}
	return Complete
}

func HandleElse(LogicContent string, Content string) string {
	//This is to handle how Go likes to handle if/else statements

	//Example:
	//if {
	//} else {
	//}

	//if the next element is "logic:else" or "logic:else-if"
	if StartsWith(Content, "logic:else") {
		//remove the line break from the last "if"
		LogicContent = LogicContent[:len(LogicContent)-1]
	}

	return LogicContent
}

//logic:
func Logic(Tabs string, TheKindType string, Content string) string {
	var Last bool = false
        var Complete string = ""
        var RootTag string = ""
        var TheCondition string = ""
        var LogicContent string = ""
        var NewContent string = ""
        var OtherContent string = ""
	var ParentContent string = ""
	var AutoTabs string = ""

        if StartsWith(TheKindType, "logic:") {
		TheKindType = AfterSplit(TheKindType,":")
        }

        for Content != "" {
		Content = ReplaceTag(Content, "logic-",false)
//		Content = ReplaceTag(Content, "logic-",true)

		if StartsWith(Content, "condition") {
			if IsIn(Content," ") {
				TheCondition = BeforeSplit(Content," ")
				Content = AfterSplit(Content," ")
				//Content = ReplaceTag(Content, "logic-",false)
			} else {
                                TheCondition = Content
                        }
                        TheCondition = Conditions(TheCondition,TheKindType)
		}

                //This part of the code is meant to separate the nested content with the current content
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

			AutoTabs = HandleTabs("logic",Tabs+"\t",OtherContent)
			if AutoTabs != "" {
				LogicContent = LogicContent + GenCode(Tabs+"\t",AutoTabs)
				AutoTabs = ""
			}

			LogicContent = HandleElse(LogicContent, OtherContent)
			//Process the current content so as to keep from redoing said content
			LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent)

			Content = NewContent
			OtherContent = ""
			NewContent = ""
		}

		if StartsWith(Content, "method:") || StartsWith(Content, "class:") {
			break
		//This is to handle nested loops and logic
		} else if StartsWith(Content, "nest-") {
			//nest-logic
			// or
			//nest-loop
			RootTag = BeforeSplit(Content,"l")
			if IsIn(Content," "+RootTag+"l") {
				//split up the loops and logic accordingly
				var cmds []string = split(Content," "+RootTag+"l")
				var end int = len(cmds)
				var lp int = 0
				for lp != end {
					//process now
					if lp == 0 {
						//this tag already contains the nest-logic or nest-loop
						//this will be processed and the following will be ignored for the next recurrsive cycle
						OtherContent = cmds[lp]
					//process later
					} else {
						//build the next elements
						if NewContent == "" {
							//put back in the nest-l
							NewContent = RootTag+"l"+cmds[lp]
						} else {
							//put back in the nest-l and append
							NewContent = NewContent+" "+RootTag+"l"+cmds[lp]
						}
					}
					lp++
				}
			//no need to split nested
			} else {
				OtherContent = Content
			}

			//the new content will be looped
			Content = NewContent

			//remove all nest- tags from content
			for StartsWith(OtherContent, "nest-") {
				OtherContent = AfterSplit(OtherContent,"-")
			}

			//handle the content if the first tag is a stmt: or var:
			if (StartsWith(OtherContent, "stmt:") || StartsWith(OtherContent, "var:")) && IsIn(OtherContent," ") {
				//examine each tag
				var cmds []string = split(OtherContent," ")
				OtherContent = ""
				NewContent = ""
				var end int = len(cmds)
				var lp int = 0
				for lp != end {
					//as long as the beginning of the tag is stmt:, var:, or params: make sure to build the non-loop/logic tags
					if (IsIn(cmds[lp],"stmt:") || IsIn(cmds[lp],"var:") || IsIn(cmds[lp],"params:")) && NewContent == "" {
						if OtherContent == "" {
							OtherContent = cmds[lp]
                                                } else {
							OtherContent = OtherContent+" "+cmds[lp]
						}
					//build the rest of the content
					} else {
						if NewContent == "" {
                                                        NewContent = cmds[lp]
                                                } else {
							NewContent = NewContent+" "+cmds[lp]
						}
					}
					lp++
				}

				AutoTabs = HandleTabs("logic",Tabs+"\t",OtherContent)
				if AutoTabs != "" {
					LogicContent = LogicContent + GenCode(Tabs+"\t",AutoTabs)
					AutoTabs = ""
				}

				LogicContent = HandleElse(LogicContent, OtherContent)

				//processes all the statements before a loop/logic
				LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent)

				//Lets group the nested tages one more time...I am not sure how to avoide this being done again
				if StartsWith(NewContent, "nest-") {
					RootTag = BeforeSplit(NewContent,"l")
					if IsIn(NewContent," "+RootTag+"l") {
						//split up the loops and logic accordingly
						var cmds []string = split(NewContent," "+RootTag+"l")
						NewContent = ""
						var end int = len(cmds)
						var lp int = 0
						for lp != end {
							if lp == 0 {
								OtherContent = cmds[lp]
								//remove all nest-
								for StartsWith(OtherContent, "nest-") {
									OtherContent = AfterSplit(OtherContent,"-")
								}

								LogicContent = HandleElse(LogicContent, OtherContent)
								//process loop/logic
								LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent)
							} else {
								if NewContent == "" {
									NewContent = RootTag+"l"+cmds[lp]
								} else {
									NewContent = NewContent+" "+RootTag+"l"+cmds[lp]
								}
							}
							lp++
						}
					}
					//remove all nest-
					for StartsWith(NewContent, "nest-") {
						NewContent = AfterSplit(NewContent,"-")
					}

					AutoTabs = HandleTabs("logic",Tabs+"\t",NewContent)
					if AutoTabs != "" {
						LogicContent = LogicContent + GenCode(Tabs+"\t",AutoTabs)
						AutoTabs = ""
					}

					LogicContent = HandleElse(LogicContent, NewContent)

					//process the remaining nest-loop/logic
					LogicContent = LogicContent + GenCode(Tabs+"\t",NewContent)

				}
			//just process as is
			} else {
				if IsIn(OtherContent," parent-") {
                                        //examine each tag
					var parent []string = split(OtherContent," parent-")
                                        OtherContent = ""
                                        var pEnd int = len(parent)
                                        var pLp int = 0
                                        for pLp != pEnd {
                                                if ((pLp == 0) || (StartsWith(parent[pLp],"<-")) || (StartsWith(parent[pLp],"<<"))) {
                                                        if (OtherContent == "") {
								OtherContent = parent[pLp]
							} else {
								OtherContent = OtherContent + " " + TranslateTag(parent[pLp])
							}
						} else {
                                                        if ParentContent == "" {
                                                                ParentContent = TranslateTag(parent[pLp])
                                                        } else {
                                                                ParentContent = ParentContent + " " + TranslateTag(parent[pLp])
                                                        }
                                                }
                                                pLp++
                                        }
                                        ParentContent = ReplaceTag(ParentContent, "logic-",false)
                                }

				AutoTabs = HandleTabs("logic",Tabs+"\t",OtherContent)
				if AutoTabs != "" {
					LogicContent = LogicContent + GenCode(Tabs+"\t",AutoTabs)
					AutoTabs = ""
				}

				LogicContent = HandleElse(LogicContent, OtherContent)
				//This is to handle how Go likes to handle if/else statements
				LogicContent = LogicContent + GenCode(Tabs+"\t",OtherContent)
			}

			//process parent content
			if ParentContent != "" {
				AutoTabs = HandleTabs("logic",Tabs+"\t",ParentContent)
				if AutoTabs != "" {
					LogicContent = LogicContent + GenCode(Tabs+"\t",AutoTabs)
					AutoTabs = ""
				}

				LogicContent = HandleElse(LogicContent, ParentContent)
                                LogicContent = LogicContent + GenCode(Tabs+"\t",ParentContent)
                                ParentContent = ""
                        }


			//clear new content
			NewContent = ""
		} else if StartsWith(Content, "var:") || StartsWith(Content, "stmt:") {

			AutoTabs = HandleTabs("logic",Tabs+"\t",Content)
			if AutoTabs != "" {
				LogicContent = LogicContent + GenCode(Tabs+"\t",AutoTabs)
				AutoTabs = ""
			}

			LogicContent = HandleElse(LogicContent, Content)

//			Content = ReplaceTag(Content, "logic-",false)
			LogicContent = LogicContent + GenCode(Tabs+"\t",Content)
			Content = ""
		} else {
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
		Complete = Tabs+"if "+TheCondition+" {\n"+LogicContent+Tabs+"}\n"
	} else if TheKindType == "else-if" {
		Complete = " else if "+TheCondition+" {\n"+LogicContent+Tabs+"}\n"
	} else if TheKindType == "else" {
		Complete = " else {\n"+LogicContent+Tabs+"}\n"
	} else if TheKindType == "switch-case" {
		Complete = Tabs+"\tcase x:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak"
	} else if StartsWith(TheKindType, "switch") {
		var CaseContent string = TheKindType
		var CaseVal string

		Complete = Tabs+"switch ("+TheCondition+")\n"+Tabs+"{\n\n"
		for CaseContent != "" {
			CaseVal = BeforeSplit(CaseContent,"-")
			if CaseVal != "switch" {
				Complete = Complete+Tabs+"\tcase "+CaseVal+":\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak\n"
			}

			if IsIn(CaseContent,"-") {
				CaseContent = AfterSplit(CaseContent,"-")
			}
		}
		Complete = Complete+Tabs+"\tdefault:\n"+Tabs+"\t\t//code here\n"+Tabs+"\t\tbreak\n"+Tabs+"}\n"
	}

	return Complete
}

//stmt:
func Statements(Tabs string, TheKindType string, Content string) string {
	var Last bool = false
	var Complete string = ""
	var StatementContent string = ""
	var OtherContent string = ""
	var TheName string = ""
	var Name string = ""
	var Process string = ""
	var Params string = ""
	var AutoTabs string = ""

	if StartsWith(TheKindType, "stmt:") {
		TheKindType = AfterSplit(TheKindType,":")
	}

        if IsIn(TheKindType,"-") {
		TheName = BeforeSplit(TheKindType,"-")
		Name = AfterSplit(TheKindType,"-")
	} else {
		TheName = TheKindType
	}

	for Content != "" {
		//This handles the parameters of the statements
		if StartsWith(Content, "params:") && Params == "" {
                        if IsIn(Content," ") {
				Process = BeforeSplit(Content," ")
                        } else {
				Process = Content
			}
			Params = Parameters(Process,"stmt")

			if IsIn(Params,"(-spc)") {
				Params = replaceAll(Params, "(-spc)"," ")
			}
		}

		if Last {
			break
		}

                for StartsWith(Content, "nest-") {
			Content = AfterSplit(Content,"-")
		}

		if !IsIn(Content," ") {
			StatementContent = StatementContent + GenCode(Tabs,Content)
			Last = true
                } else {
			OtherContent = BeforeSplit(Content," ")
			Content = AfterSplit(Content," ")
			if StartsWith(Content, "params:") {
				OtherContent = OtherContent+" "+BeforeSplit(Content," ")
				Content = AfterSplit(Content," ")
			}

			if StartsWith(OtherContent,"loop:") && Content != "" {
				OtherContent = OtherContent+" "+Content
				Content = ""
			} else if StartsWith(OtherContent,"logic:") && Content != "" {
				OtherContent = OtherContent+" "+Content
				Content = ""
			}
			StatementContent = StatementContent + GenCode(Tabs,OtherContent)

			if OtherContent == "stmt:endline" {
				AutoTabs = HandleTabs("statements",Tabs,Content)
				if AutoTabs != "" {
					StatementContent = StatementContent + GenCode(Tabs,AutoTabs)
					AutoTabs = ""
				}
			}
		}
	}

	//Pull Vector or Array Type
	if StartsWith(TheKindType,"<") && IsIn(TheKindType,">") {
		var VorA string = ""
		var VarType string = ""
		var TheValue string = ""

		//grab data type
		VarType = BeforeSplit(TheKindType,">")
		VarType = AfterSplit(VarType,"<")
		VarType = AfterSplit(VarType,":")
		VarType = DataType(VarType,false)

		//vector or array
		VorA = BeforeSplit(TheKindType,":")
		VorA = AfterSplit(VorA,"<")

		TheName = VorA

		//name of array
		Name = AfterSplit(TheKindType,">")

		if IsIn(Name,":") {
			TheValue = AfterSplit(Name,":")
			Name = BeforeSplit(Name,":")
			Complete = VectAndArray(Name, VarType, VorA, "statement",GenCode("",TranslateTag(TheValue)))+StatementContent
		} else {
			Complete = VectAndArray(Name, VarType, VorA, "statement","")+StatementContent
		}
		//pull value
		TheKindType = ""
		TheName = ""
		Name = ""
		VarType = ""
	} else if TheName == "method" {
		Complete = Name+"("+Params+")"+StatementContent
	} else if TheName == "comment" {
		Complete = StatementContent+Tabs+"#Code goes here\n"
	} else if TheName == "endline" || TheName == "newline" {
		Complete = StatementContent+"\n"
	} else if TheName == "tab" {
		Complete = "\t"+StatementContent
	}

	return Complete
}

//var:
func Variables(Tabs string, TheKindType string, Content string) string {
	var Last bool = false
	var MakeEqual bool = false
	var NewVar string = ""
	var Name string = ""
	var VarType string = ""
	var Value string = ""
	var VariableContent string = ""
	var OtherContent string = ""
	var AutoTabs string = ""

	if StartsWith(TheKindType, "var:") {
		TheKindType = AfterSplit(TheKindType,":")
	}

        for Content != "" {
		//All params are removed
		if Last {
			break
		}

                for StartsWith(Content, "nest-") {
			Content = AfterSplit(Content,"-")
		}

		if !IsIn(Content," ") {
			VariableContent = VariableContent + GenCode(Tabs,Content)
			Last = true
		} else {
			OtherContent = BeforeSplit(Content," ")
			Content = AfterSplit(Content," ")
			if StartsWith(Content, "params:") {
				OtherContent = OtherContent+" "+BeforeSplit(Content," ")
				Content = AfterSplit(Content," ")
			}

			if (StartsWith(OtherContent,"loop:") && Content != "") || (StartsWith(OtherContent,"logic:") && Content != "") {
				OtherContent = OtherContent+" "+Content
				Content = ""
			}
			VariableContent = VariableContent + GenCode(Tabs,OtherContent)
			if OtherContent == "stmt:endline" {
				AutoTabs = HandleTabs("variables",Tabs,Content)
				if AutoTabs != "" {
					VariableContent = VariableContent + GenCode(Tabs,AutoTabs)
					AutoTabs = ""
				}
			}
		}
	}

	//Pull Variable Type
	if StartsWith(TheKindType,"(") && IsIn(TheKindType,")") {
		VarType = BeforeSplit(TheKindType,")")
		VarType = AfterSplit(VarType,"(")
		VarType = DataType(VarType,false)
		TheKindType = AfterSplit(TheKindType,")")
		if TheKindType == "" {
			Name = VarType
			VarType = ""
		} else if TheKindType == "=" {
			Name = VarType
//			VarType = ""
		} else {
			Name = TheKindType
		}
	//Pull Vector or Array Type
	} else if StartsWith(TheKindType,"<") && IsIn(TheKindType,">") {
		var TheValue string = ""
		var VorA string = ""
		//grab data type
		VarType = BeforeSplit(TheKindType,">")
		VarType = AfterSplit(VarType,"<")
		VarType = AfterSplit(VarType,":")
		VarType = DataType(VarType,false)

		//vector or array
		VorA = BeforeSplit(TheKindType,":")
		VorA = AfterSplit(VorA,"<")

		//name of array
		Name = AfterSplit(TheKindType,">")

		if IsIn(Name,":") {
			TheValue = AfterSplit(Name,":")
			Name = BeforeSplit(Name,":")
			NewVar = VectAndArray(Name, VarType, VorA, "variable",GenCode("",TranslateTag(TheValue)))
		} else {
			NewVar = VectAndArray(Name, VarType, VorA, "variable","")
		}

		TheKindType = ""
		Name = ""
		VarType = ""
	}

	//Assign Value
	if IsIn(TheKindType,"=") {
		MakeEqual = true
		Name = BeforeSplit(TheKindType,"=")
		Value = AfterSplit(TheKindType,"=")
	}

	if VarType != "" && Name != ""{
		NewVar = " "+VarType
	} else if VarType != "" && Name == ""{
		Name = VarType
		VarType = ""
		NewVar = ""
	}

	if MakeEqual == true {
		if IsIn(Value,"(-spc)") {
			Value = replaceAll(Value, "(-spc)"," ")
		}

		if VarType != "" {
			NewVar = "var "+Name+NewVar+" = "+Value
		} else {
			NewVar = Name+NewVar+" = "+Value
		}
	} else {
		NewVar = "var "+Name+NewVar
	}
	NewVar = NewVar+VariableContent

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

	if StartsWith(Args[0], "class:") {
		TheCode = Class(Args[0],Args[1])

	} else if StartsWith(Args[0], "struct:") {
		TheCode = Struct(Args[0],Args[1])

	} else if StartsWith(Args[0], "method:") {
		TheCode = Method(Tabs,Args[0],Args[1])

	} else if StartsWith(Args[0], "loop:") {
		TheCode = Loop(Tabs,Args[0],Args[1])

	} else if StartsWith(Args[0], "logic:") {
		TheCode = Logic(Tabs,Args[0],Args[1])

	} else if StartsWith(Args[0], "var:") {
		TheCode = Variables(Tabs, Args[0], Args[1])

	} else if StartsWith(Args[0], "stmt:") {
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

func Example(tag string) {
	var UserIn string = ""
	if IsIn(tag," ") {
		var all []string = split(tag," ")
		var end int = len(all)
		var lp int = 0
		for lp != end {
			if UserIn == "" {
				UserIn = TranslateTag(all[lp])
			} else {
				UserIn = UserIn + " " +TranslateTag(all[lp])
			}
			lp++
		}
	}
	fmt.Println(UserIn)
	UserIn = GenCode("",UserIn)

	fmt.Println(UserIn)
}

//main
func main() {
	var UserIn string = ""
	var Content string

	args := os.Args[1:]
	var argc int = len(args)

	//Args were NOT given
	if argc == 0 {
		banner()
	}

	for {
		//Args were given
		if argc >= 1 {
			for arg := range args {
				if UserIn == "" {
					UserIn = TranslateTag(args[arg])
				} else {
					UserIn = UserIn + " " + TranslateTag(args[arg])
				}
			}
		} else 	{
			UserIn = raw_input(">>> ")
		}

		if UserIn == "exit" {
			break
/*
		} else if UserIn == "clear" {
			clear()
*/
		} else if UserIn == "version" && argc == 0 {
			fmt.Println(Version)
		} else if UserIn == "--version" && argc == 1 {
			fmt.Println(Version)
			break
		} else if UserIn == "-v" && argc == 1 {
			fmt.Println(Version)
			break
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
