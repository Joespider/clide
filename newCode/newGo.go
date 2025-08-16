package main

import (
	"fmt"
	"io"
	"os"
	)

func help() {
	var ProgName string = "newGo"
	var Version string = "0.1.38"

	fmt.Println("Author: Joespider")
	fmt.Println("Program: \""+ProgName+"\"")
	fmt.Println("Version: "+Version)
	fmt.Println("Purpose: make new Go programs")
	fmt.Println("Usage: "+ProgName+" <args>")
	fmt.Println("\t--user <username>: get username for help page")
	fmt.Println("\t-n <name> : program name")
	fmt.Println("\t--name <name> : program name")
	fmt.Println("\t--no-save : only show out of code; no file source code is created")
	fmt.Println("\t--cli : enable command line (Main file ONLY)")
	fmt.Println("\t--main : main file")
	fmt.Println("\t--prop : enable custom system property")
	fmt.Println("\t--pipe : enable piping (Main file ONLY)")
	fmt.Println("\t--shell : unix shell")
	fmt.Println("\t--reverse : enable reverse string")
	fmt.Println("\t--split : enable \"split\" function")
	fmt.Println("\t--join : enable \"join\" function")
	fmt.Println("\t--random : enable \"random\" int method")
	fmt.Println("\t--files : enable filesystem Go specific code")
/*
	fmt.Println("\t--check-file : enable \"fexists\" file method")
	fmt.Println("\t--write-file : enable \"write\" file method")
	fmt.Println("\t--read-file : enable \"read\" file method")
	fmt.Println("\t--is-in : enable string contains methods")
*/
	fmt.Println("\t--user-input : enable \"raw_input\" method")
	fmt.Println("\t--thread : enable threading (Main file ONLY)")
	fmt.Println("\t--sleep : enable \"sleep\" method")
	fmt.Println("\t--get-length : enable \"length\" examples (Main file ONLY)")
	fmt.Println("\t--casting : enable data type conversion methods")
	fmt.Println("\t--sub-string : enable sub-string methods")
	fmt.Println("\t--type : enable data type eval")
	fmt.Println("\t--upper : enable uppercase methods")
	fmt.Println("\t--lower : enable lowercase methods")
	fmt.Println("\t--math : enable math functions (Main file ONLY)")
	fmt.Println("\t--date-time : enable date and time")
}

func getHelp(TheName string, TheUser string) string {

	if TheUser == "" {
		TheUser = os.Getenv("USER")
	}
	var HelpMethod = "func help() {\n\tvar ProgName string = \""+TheName+"\"\n\tvar Version string = \"0.0.0\"\n\n\tfmt.Println(\"Author: "+TheUser+"\")\n\tfmt.Println(\"Program: \\\"\"+ProgName+\"\\\"\")\n\tfmt.Println(\"Version: \"+Version)\n\tfmt.Println(\"Purpose: \")\n\tfmt.Println(\"Usage: \"+ProgName+\" <args>\")\n}\n\n\n"
	return HelpMethod
}

func getPackage(ThePackage string) string {
	return "package "+ThePackage+"\n"
}

//create import listing
func getImports(UserInput bool, check bool, write bool, read bool, random bool, cli bool, sleep bool, getPipe bool, getShell bool, getThread bool, getProp bool, getSplit bool, getJoin bool, getConv bool, getUpper bool, getLower bool, getTypes bool, getMath bool, getIsIn bool, getTime bool) string {
	var Imports string = ""
	var standard string = "\"fmt\"\n"
	var readWrite string = ""
	var ForRandom string = ""
	var ForTime string = ""
	var ForCLI string = ""
	var ForUserInput string = ""
	var ForConvert string = ""
	var ForString string = ""
	var ForShell string = ""
	var ForTypes string = ""
	var ForMath string = ""

	if read == true || write == true {
		readWrite = "\t\"io/ioutil\"\n\t\"io\"\n"
	}

	if check == true || read == true || write == true || cli == true || getPipe == true || getProp == true || UserInput == true {
		ForCLI = "\t\"os\"\n"
	}

	if getShell == true {
		ForShell = "\t\"runtime\"\n"
		ForShell = ForShell + "\t\"os/exec\"\n"
	}

	if UserInput == true || getPipe == true {
		ForUserInput = "\t\"bufio\"\n"
	}

	if random == true {
		ForRandom = "\t\"math/rand\"\n"
	}

	if random == true || sleep == true || getThread == true || getTime == true {
		ForTime = "\t\"time\"\n"
	}

	if getConv == true || getTime == true {
		ForConvert = "\t\"strconv\"\n"
	}

	if getPipe == true || getSplit == true || getJoin == true || getUpper == true || getLower == true || getIsIn == true {
		ForString = "\t\"strings\"\n"
	}

	if getTypes == true {
		ForTypes = "\t\"reflect\"\n"
	}

	if getMath == true {
		ForMath = "\t\"math\"\n"
	}

	Imports = standard+readWrite+ForRandom+ForCLI+ForShell+ForUserInput+ForTime+ForString+ForConvert+ForTypes+ForMath
	if Imports == standard {
		Imports = "import "+Imports
	} else {
		Imports = "import (\n\t"+Imports+"\t)\n"
	}

	return Imports
}

func getMethods(getRawIn bool, getRand bool, getCheck bool, getWrite bool, getRead bool, getIsIn bool, getSleep bool, getShell bool, getThread bool, getProp bool, getSplit bool, getJoin bool, getRev bool, getSubStr bool, getConv bool, getUpper bool, getLower bool, getTime bool) string {
	var TheMethods string = ""
	var CheckFileMethod string = ""
	var ReadMethod string = ""
	var WriteMethod string = ""
	var RandMethod string = ""
	var UserInput string = ""
	var SleepMethod string = ""
	var ShellMethod string = ""
	var SubStrMethod string = ""
	var ConvertMethod string = ""
	var SplitMethod string = ""
	var JoinMethod string = ""
	var replaceAllMethod string = ""
	var SysPropMethod string = ""
	var ThreadMethod string = ""
	var ReverseMethod string = ""
	var UpperMethod string = ""
	var LowerMethod string = ""
	var IsInMethod string = ""
	var DateAndTime string = ""

	if getRawIn == true {
		UserInput = "func raw_input(Message string) string {\n\tvar UserIn string\n\tfmt.Print(Message)\n\treader := bufio.NewReader(os.Stdin)\n\tUserIn, _ = reader.ReadString('\\n')\n\tif UserIn != \"\" {\n\t\tUserIn = UserIn[:len(UserIn)-1]\n\t}\n\treturn UserIn\n}\n\n"
	}

	if getCheck == true {
		CheckFileMethod = "func fexists(aFile string) bool {\n\tif _, err := os.Stat(aFile); err == nil {\n\t\treturn true\n\t} else {\n\t\treturn false\n\t}\n}\n\n"
	}
	if getRead == true {
		ReadMethod = "func ReadFile(filename string) {\n\n\tdata, err := ioutil.ReadFile(filename)\n\tif err != nil {\n\t\tfmt.Println(\"file reading error\", err)\n\t\treturn\n\t}\n\tfmt.Println(\"Contents of file:\", string(data))\n}\n\n"
	}

	if getWrite == true {
		WriteMethod = "func WriteToFile(filename string, content string) error {\n\tfile, err := os.Create(filename)\n\tif err != nil {\n\t\treturn err\n\t}\n\tdefer file.Close()\n\n\t_, err = io.WriteString(file, content)\n\tif err != nil {\n\t\treturn err\n\t}\n\treturn file.Sync()\n}\n\n"
	}

	if getRand == true {
		RandMethod = "func Random(min int, max int) int {\n\treturn rand.Intn(max-min) + min\n}\n\n"
	}

	if getShell == true {
		ShellMethod = "func Shell(command string) string {\n\tif command != \"\" {\n\t\tout, err := exec.Command(command).Output()\n\t\tif err != nil {\n\t\t\treturn \"\"\n\t\t} else {\n\t\t\toutput := string(out[:])\n\t\t\treturn output\n\t\t}\n\t} else {\n\t\treturn \"\"\n\t}\n}\n\n"
		ShellMethod = ShellMethod+"func Exe() {\n\t//execute\n\tcmd := exec.Command(\"touch\", \"me\")\n\tstdout, err := cmd.Output()\n\n\tif err != nil {\n\t\tfmt.Println(err.Error())\n\t\treturn\n\t}\n\n\tfmt.Print(string(stdout))\n}\n\n"
		ShellMethod = ShellMethod+"func getOS() string {\n\tos := runtime.GOOS\n\tswitch os {\n\t\tcase \"windows\":\n\t\t\treturn \"Windows\"\n\t\tcase \"darwin\":\n\t\t\treturn \"MAC\"\n\t\tcase \"linux\":\n\t\t\treturn \"Linux\"\n\t\tdefault:\n\t\t\treturn \"Unknown\"\n\t}\n}\n\n"
	}

	if getSleep == true {
		SleepMethod = "func sleep() {\n\ttime.Sleep(3 * time.Second)\n}\n\n"
	}

	if getThread == true {
		ThreadMethod = "func MyThread() {\n\tfmt.Println(\"{My Thread}\")\n}\n\n"
	}

	if getRev == true {
		ReverseMethod = "func rev(s string) string {\n\trns := []rune(s)\n\tfor i, j := 0, len(rns)-1; i < j; i, j = i+1, j-1 {\n\t\trns[i], rns[j] = rns[j], rns[i]\n\t}\n\n\t// return the reversed string.\n\treturn string(rns)\n}\n\n"
	}

	if getProp == true {
		SysPropMethod = "func GetSysProp(PleaseGet string) string {\n\tif PleaseGet != \"\" {\n\t\treturn os.Getenv(PleaseGet)\n\t} else {\n\t\treturn \"\"\n\t}\n}\n\n"
	}

	if getSubStr == true {
		SubStrMethod = "func removeFirstChars(value string, length int) string {\n\treturn value[length:]\n}\n\n"
		SubStrMethod = SubStrMethod + "func removeLastChars(value string, length int) string {\n\tlast := len(value)\n\treturn value[:last-length]\n}\n\n"
		SubStrMethod = SubStrMethod + "func SubString(TheString string, Start int, End int) string {\n\tLen := Start + End\n\tif Len >= len(TheString) {\n\t\treturn TheString[Start:End]\n\t} else {\n\t\treturn TheString[Start:Len]\n\t}\n}\n\n"
		SubStrMethod = SubStrMethod + "func Index(TheString string, SubStr string) int {\n\treturn strings.Index(TheString, SubStr)\n}\n\n"
	}

	if getConv == true {
		ConvertMethod = "func Str(number int) string {\n\treturn strconv.Itoa(number)\n}\n\n"
	}

	if getSplit == true {
		SplitMethod = "func split(Str string, sBy string) []string {\n\tArray := strings.Split(Str, sBy)\n\treturn Array\n}\n\n"
		SplitMethod = SplitMethod + "func BeforeSplit(Str string, splitAt string) string {\n\tif strings.Contains(Str,splitAt) {\n\t\tvar result []string  = strings.SplitAfterN(Str, splitAt,2)\n\t\tvar newResult string = result[0]\n\t\tnewResult = newResult[:len(newResult)-1]\n\t\treturn newResult\n\t} else {\n\t\treturn \"\"\n\t}\n}\n\n"
		SplitMethod = SplitMethod + "func AfterSplit(Str string, splitAt string) string {\n\tif strings.Contains(Str,splitAt) {\n\t\tvar result []string  = strings.SplitAfterN(Str, splitAt,2)\n\t\treturn result[1]\n\t} else {\n\t\treturn \"\"\n\t}\n}\n\n"
	}

	if getJoin == true {
		JoinMethod = "func join(Array []string, ToJoin string) string {\n\tJoined := strings.Join(Array, ToJoin)\n\treturn Joined\n}\n\n"
	}

	if  getSplit == true && getJoin == true {
		replaceAllMethod = "func replaceAll(Str string, sBy string, ToJoin string) string {\n\tnewStr := strings.ReplaceAll(Str, sBy, ToJoin)\n\treturn newStr\n}\n\n"
	}

	if  getUpper == true {
		UpperMethod = "func toUpperCase(message string) string {\n\tUpper := strings.ToUpper(message)\n\treturn Upper\n}\n\n"
		UpperMethod = UpperMethod + "func toUpperCase_at(message string, plc int) string {\n\tvar newStr string\n\tchars := []rune(message)\n\tfor i := 0; i < len(chars); i++ {\n\t\tif i == plc {\n\t\t\tnewStr = newStr + strings.ToUpper(string(chars[i]))\n\t\t} else {\n\t\t\tnewStr = newStr + string(chars[i])\n\t\t}\n\t}\n\treturn newStr\n}\n\n"
	}

	if  getLower == true {
		LowerMethod = "func toLowerCase(message string) string {\n\tUpper := strings.ToLower(message)\n\treturn Upper\n}\n\n"
		LowerMethod = LowerMethod + "func toLowerCase_at(message string, plc int) string {\n\tvar newStr string\n\tchars := []rune(message)\n\tfor i := 0; i < len(chars); i++ {\n\t\tif i == plc {\n\t\t\tnewStr = newStr + strings.ToLower(string(chars[i]))\n\t\t} else {\n\t\t\tnewStr = newStr + string(chars[i])\n\t\t}\n\t}\n\treturn newStr\n}\n\n"
	}

	if  getIsIn == true {
		IsInMethod = "func IsIn(Str string, Sub string) bool {\n\treturn strings.Contains(Str,Sub)\n}\n\n"
		IsInMethod = IsInMethod+"func StartsWith(Str string, Sub string) bool {\n\treturn strings.HasPrefix(Str,Sub)\n}\n\n"
		IsInMethod = IsInMethod+"func EndsWith(Str string, Sub string) bool {\n\treturn strings.HasSuffix(Str,Sub)\n}\n\n"
	}

	if  getTime == true {
		DateAndTime = "func TimeAndDate() string {\n\tnow := time.Now()\n\tformatted := now.Format(time.ANSIC)\n\treturn formatted\n}\n\n"
		DateAndTime = DateAndTime + "func getTime() string {\n\tnow := time.Now()\n\tHr := strconv.Itoa(now.Hour())\n\tMin := strconv.Itoa(now.Minute())\n\tSec := strconv.Itoa(now.Second())\n\tTime := Hr+\":\"+Min+\":\"+Sec\n\treturn Time\n}\n\n"
	}

	TheMethods = UserInput+CheckFileMethod+WriteMethod+ReadMethod+RandMethod+ShellMethod+SleepMethod+ThreadMethod+ReverseMethod+SysPropMethod+SplitMethod+JoinMethod+replaceAllMethod+SubStrMethod+ConvertMethod+UpperMethod+LowerMethod+IsInMethod+DateAndTime

	return TheMethods
}

//build main function
func getMain(Args bool, getRandom bool, getPipe bool, getThread bool, getTypes bool, getMath bool, getLen bool) string {
	var Main string = ""
	var RandStart string = ""
	var PipeCode string = ""
	var UseThread string = ""
	var ShowDataTypes string = ""
	var ShowLength string = ""
	var ShowMath string = ""

	if getRandom == true {
		RandStart = "\trand.Seed(time.Now().UnixNano())\n"
	}

	if getPipe == true {
		PipeCode = "\tfi, err := os.Stdin.Stat()\n\tif err != nil {\n\t\tpanic(err)\n\t}\n\tif fi.Mode() & os.ModeNamedPipe == 0 {\n\t\tfmt.Println(\"nothing was piped in\")\n\t} else {\n\t\tfmt.Println(\"[Pipe]\")\n\t\tfmt.Println(\"{\")\n\t\tvar reader = bufio.NewReader(os.Stdin)\n\t\tfor true {\n\t\t\tmessage, err := reader.ReadString('\\n')\n\t\t\tif err != nil {\n\t\t\t\t\t//Account for EOF\n\t\t\t\t\tbreak\n\t\t\t\t}\n\t\t\tmessage = strings.Replace(message, \"\\n\", \"\", -1)\n\t\t\tfmt.Println(message)\n\t\t\t}\n\t\tfmt.Println(\"}\")\n\t}\n"
	}

	if getThread == true {
		UseThread = "\t//This is a go thread\n\tgo MyThread()\n\t//wait for thread to start\n\ttime.Sleep(1 * time.Second)\n"
	}

	if getTypes == true {
		ShowDataTypes = "/*\n\tvar str string\n\tvar number int\n\tvar intArray [5]int\n\n\tif reflect.ValueOf(str).Kind() == reflect.String {\n\t\tfmt.Println(\"This is a string\")\n\t}\n\n\tif reflect.ValueOf(number).Kind() == reflect.Int {\n\t\tfmt.Println(\"This is an Int\")\n\t}\n\n\tif reflect.ValueOf(intArray).Kind() == reflect.Array {\n\t\tfmt.Println(\"This is an Array\")\n\t}\n*/\n"
	}

	if getLen == true {
		ShowLength = "/*\tvar StrLen int\n\tvar NamLen int\n\tvar Message string\n\tvar Names [3]string\n\tNames[0] = \"one\"\n\tNames[1] = \"two\"\n\tNames[2] = \"three\"\n\tMessage = \"This is a message\"\n\tStrLen = len(Message)\n\tNamLen = len(Names)\n*/\n"
	}

	if getMath == true {
		ShowMath = "/*\n\tfmt.Println(math.Abs(-12.3))\n\tfmt.Println(math.Sin(43))\n\tfmt.Println(math.Cos(57))\n\tfmt.Println(math.Log(89))\n\tfmt.Println(math.Log10(90))\n\tfmt.Println(math.Mod(14, 5))\n\tfmt.Println(math.Ceil(12.5))\n\tfmt.Println(math.Floor(23.7))\n\tfmt.Println(math.Min(23, 45))\n\tfmt.Println(math.Max(23, 45))\n\tfmt.Println(math.Pow(2, 16))\n\tfmt.Println(math.IsNaN(35))\n*/\n"
	}

	if Args == true {
		Main = "//main\nfunc main() {\n"+RandStart+"\targs := os.Args[1:]\n\tif len(args) > 0 {\n\t\tfor arg := range args {\n\t\t\tfmt.Println(args[arg])\n\t\t}\n\t} else {\n\t\thelp()\n\t}\n"+PipeCode+UseThread+ShowDataTypes+ShowMath+ShowLength+"}"
	} else {
		Main = "//main\nfunc main() {\n"+RandStart+"\tfmt.Println(\"hellow world\")\n"+PipeCode+UseThread+ShowDataTypes+ShowMath+ShowLength+"}"
	}
	return Main
}

func fexists(aFile string) bool {
	if _, err := os.Stat(aFile); err == nil {
		return true
	} else {
		return false
	}
}

//create new Go program
func CreateNew(filename string, content string) error {
	filename = filename+".go"
	file, err := os.Create(filename)
	if err != nil {
		return err
	}
	defer file.Close()

	_, err = io.WriteString(file, content)
	if err != nil {
		return err
	}
	return file.Sync()
}

//Go main
func main() {
	var noSave bool = false
	var getUser bool = false
	var getName bool = false
	var getArgs bool = false
	var getCheck bool = false
	var getWrite bool = false
	var getRead bool = false
	var getIsIn bool = false
	var getRawIn bool = false
	var getRand bool = false
	var getSleep bool = false
	var getPipe bool = false
	var getProp bool = false
	var getRev bool = false
	var getShell bool = false
	var getConv bool = false
	var getSplit bool = false
	var getJoin bool = false
	var getSubStr bool = false
	var getThread bool = false
	var getTypes bool = false
	var getUpper bool = false
	var getLower bool = false
	var getMath bool = false
	var getTime bool = false
	var getLen bool = false
	var FileExists = false
	var IsMain bool = false
	var UserIn string = ""
	var ThePackage string = ""
	var CName string = ""
	var TheAuthor string = ""
	var Imports string = ""
	var Methods string = ""
	var TheHelpContent string = ""
	var Main string = ""
	var Content string = ""

	//Get User CLI Args
	args := os.Args[1:]

	for arg := range args {
		//Save output to UserIn
		UserIn = args[arg]
		//Get name of program
		if UserIn == "-n" || UserIn == "--name" {
			getName = true
		//Get Author
		} else if UserIn == "--user" {
			getName = false
			getUser = true
		//Only show; don't save
		} else if UserIn == "--no-save" {
			getName = false
			noSave = true
		//Get cli arg in main method
		} else if UserIn == "--cli" {
			getName = false
			getArgs = true
		//Is a main
		} else if UserIn == "--main" {
			getName = false
			IsMain = true
		//Get Random method
		} else if UserIn == "--random" {
			getName = false
			getRand = true
		//Get Write file method
		} else if UserIn == "--files" {
			getName = false
			getWrite = true
			getRead = true
			getCheck = true
/*
		//Get Write file method
		} else if UserIn == "--write-file" {
			getName = false
			getWrite = true
		//Get Read file method
		} else if UserIn == "--read-file" {
			getName = false
			getRead = true
		//Get Check file method
		} else if UserIn == "--check-file" {
			getName = false
			getCheck = true
		//Get IsIn method
		} else if UserIn == "--is-in" {
			getName = false
			getIsIn = true
*/
		//Get raw_input method
		} else if UserIn == "--user-input" {
			getName = false
			getRawIn = true
		//Get convert methods
		} else if UserIn == "--casting" {
			getName = false
			getConv = true
		//Get sleep
		} else if UserIn == "--sleep" {
			getName = false
			getSleep = true
		//Get pipe
		} else if UserIn == "--pipe" {
			getName = false
			getPipe = true
		//Get threading
		} else if UserIn == "--thread" {
			getName = false
			getThread = true
		//Get reverse
		} else if UserIn == "--reverse" {
			getName = false
			getRev = true
		//Get prop
		} else if UserIn == "--prop" {
			getName = false
			getProp = true
		//Get Shell
		} else if UserIn == "--shell" {
			getName = false
			getShell = true
		//Get Split
		} else if UserIn == "--split" {
			getName = false
			getSplit = true
		//Get Sub Str
		} else if UserIn == "--sub-string" {
			getName = false
			getSubStr = true
			getIsIn = true
		//Get Join
		} else if UserIn == "--join" {
			getName = false
			getJoin = true
		//Get Upper
		} else if UserIn == "--upper" {
			getName = false
			getUpper = true
		//Get Lower
		} else if UserIn == "--lower" {
			getName = false
			getLower = true
		//Get data types
		} else if UserIn == "--type" {
			getName = false
			getTypes = true
		//Get Math
		} else if UserIn == "--math" {
			getName = false
			getMath = true
		//Get Math
		} else if UserIn == "--date-time" {
			getName = false
			getTime = true
		//Get Length examples
		} else if UserIn == "--get-length" {
			getName = false
			getLen = true
		//Get Name of program
		} else if getName == true {
			CName = UserIn
			getName = false
		//Get Author of program
		} else if getUser == true {
			TheAuthor = UserIn
			getUser = false
		}
	}
	//Ensure program name is given
	if CName != "" || noSave == true {
		if noSave == false {
			FileExists = fexists(CName+".go")
		}
		if FileExists == false || noSave == true {
			ThePackage = getPackage("main")
			Imports = getImports(getRawIn, getCheck, getWrite, getRead, getRand, getArgs, getSleep, getPipe, getShell, getThread, getProp, getSplit, getJoin, getConv, getUpper, getLower, getTypes, getMath, getIsIn, getTime)
			Methods = getMethods(getRawIn, getRand, getCheck, getWrite, getRead, getIsIn, getSleep, getShell, getThread, getProp, getSplit, getJoin, getRev, getSubStr, getConv, getUpper, getLower, getTime)
			if IsMain == true {
				if getArgs == true {
					TheHelpContent = getHelp(CName,TheAuthor)
				}
				Main = getMain(getArgs,getRand,getPipe,getThread,getTypes, getMath, getLen)
			} else {
				Main = ""
			}
			Content = ThePackage+"\n"+Imports+"\n"+TheHelpContent+Methods+"\n"+Main
			if noSave == false {
				CreateNew(CName,Content)
			} else {
				fmt.Println(Content)
			}
		} else {
			fmt.Println("\""+CName+".go\" already exists")
		}
	} else {
		help()
	}
}
