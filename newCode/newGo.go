package main

import (
	"fmt"
	"io"
	"os"
	)

func help() {
	var ProgName string = "newGo"
	var Version string = "0.1.06"

	fmt.Println("Author: Joespider")
	fmt.Println("Program: \""+ProgName+"\"")
	fmt.Println("Version: "+Version)
	fmt.Println("Purpose: make new Go programs")
	fmt.Println("Usage: "+ProgName+" <args>")
	fmt.Println("\t-n <name> : program name")
	fmt.Println("\t--name <name> : program name")
	fmt.Println("\t--main : main file")
	fmt.Println("\t--cli : enable command line (Main file ONLY)")
	fmt.Println("\t--prop : enable custom system property")
	fmt.Println("\t--pipe : enable piping (Main file ONLY)")
	fmt.Println("\t--shell : unix shell")
	fmt.Println("\t--random : enable \"random\" int method")
	fmt.Println("\t--write-file : enable \"write\" file method")
	fmt.Println("\t--read-file : enable \"read\" file method")
	fmt.Println("\t--is-in : enable \"IsIn\" method")
	fmt.Println("\t--user-input : enable \"raw_input\" method")
	fmt.Println("\t--sleep : enable \"sleep\" method")
	fmt.Println("\t--thread : enable threading")
}

func getPackage(ThePackage string) string {
	return "package "+ThePackage+"\n"
}

//create import listing
func getImports(UserInput bool, write bool, read bool, random bool, cli bool, sleep bool, getPipe bool, getShell bool, getThread bool, getProp bool) string {
	var Imports string = ""
	var standard string = "\"fmt\"\n"
	var readWrite string = ""
	var ForRandom string = ""
	var ForTime string = ""
	var ForCLI string = ""
	var ForUserInput string = ""
	var ForString string = ""
	var ForShell string = ""

	if read == true || write == true {
		readWrite = "\t\"io/ioutil\"\n\t\"io\"\n"
	}

	if read == true || write == true || cli == true || getPipe == true || getProp == true {
		ForCLI = "\t\"os\"\n"
	}

	if getShell == true {
		ForShell = "\t\"os/exec\"\n"
	}

	if UserInput == true || getPipe == true {
		ForUserInput = "\t\"bufio\"\n"
	}

	if random == true {
		ForRandom = "\t\"math/rand\"\n"
	}

	if random == true || sleep == true || getThread == true {
		ForTime = "\t\"time\"\n"
	}

	if getPipe == true {
		ForString = "\t\"strings\"\n"
	}

	Imports = standard+readWrite+ForRandom+ForCLI+ForShell+ForUserInput+ForTime+ForString
	if Imports == standard {
		Imports = "import "+Imports
	} else {
		Imports = "import (\n\t"+Imports+"\t)\n"
	}

	return Imports
}

func getMethods(getRawIn bool, getRand bool, getWrite bool, getRead bool, getIsIn bool, getSleep bool, getShell bool, getThread bool, getProp bool) string {
	var TheMethods string = ""
	var ReadMethod string = ""
	var WriteMethod string = ""
	var RandMethod string = ""
	var UserInput string = ""
	var SleepMethod string = ""
	var ShellMethod string = ""
	var SysPropMethod string = ""
	var ThreadMethod string = ""

	if getRawIn == true {
		UserInput = "func raw_input(Message string) string {\n\tvar UserIn string\n\tfmt.Print(Message)\n\treader := bufio.NewReader(os.Stdin)\n\tUserIn, _ = reader.ReadString('\\n')\n\treturn UserIn\n}\n\n"
	}

	if getRead == true {
		ReadMethod = "func ReadFile(filename string) {\n\n\tdata, err := ioutil.ReadFile(filename)\n\tif err != nil {\n\t\tfmt.Println(\"file reading error\", err)\n\t\treturn\n\t}\n\tfmt.Println(\"Contents of file:\", string(data))\n}\n\n"
	}

	if getWrite == true {
		WriteMethod = "func WriteToFile(filename string, content string) error {\n\tfile, err := os.Create(filename)\n\tif err != nil {\n\t\treturn err\n\t}\n\tdefer file.Close()\n\n\t_, err = io.WriteString(file, content)\n\tif err != nil {\n\t\treturn err\n\t}\n\treturn file.Sync()\n}\n\n"
	}

	if getRand == true {
		RandMethod = "func Random(min int, max int) {\n\treturn rand.Intn(max-min) + min\n}\n\n"
	}

	if getShell == true {
		ShellMethod = "func Shell(command string) string {\n\tif command != \"\" {\n\t\tout, err := exec.Command(command).Output()\n\t\tif err != nil {\n\t\t\treturn \"\"\n\t\t} else {\n\t\t\toutput := string(out[:])\n\t\t\treturn output\n\t\t}\n\t} else {\n\t\treturn \"\"\n\t}\n}\n\n"
	}

	if getSleep == true {
		SleepMethod = "func sleep() {\n\ttime.Sleep(3 * time.Second)\n}\n\n"
	}

	if getThread == true {
		ThreadMethod = "func MyThread() {\n\tfmt.Println(\"{My Thread}\")\n}\n\n"
	}

	if getProp == true {
		SysPropMethod = "func GetSysProp(PleaseGet string) string {\n\tif PleaseGet != \"\" {\n\t\treturn os.Getenv(PleaseGet)\n\t} else {\n\t\treturn \"\"\n\t}\n}\n\n"
	}

	TheMethods = UserInput+WriteMethod+ReadMethod+RandMethod+ShellMethod+SleepMethod+ThreadMethod+SysPropMethod
	return TheMethods
}

//build main function
func getMain(Args bool, getRandom bool, getPipe bool, getThread bool) string {
	var Main string = ""
	var RandStart string = ""
	var PipeCode string = ""
	var UseThread string = ""

	if getRandom == true {
		RandStart = "\trand.Seed(time.Now().UnixNano())\n"
	}

	if getPipe == true {
		PipeCode = "\tfi, err := os.Stdin.Stat()\n\tif err != nil {\n\t\tpanic(err)\n\t}\n\tif fi.Mode() & os.ModeNamedPipe == 0 {\n\t\tfmt.Println(\"nothing was piped in\")\n\t} else {\n\t\tfmt.Println(\"[Pipe]\")\n\t\tfmt.Println(\"{\")\n\t\tvar reader = bufio.NewReader(os.Stdin)\n\t\tfor true {\n\t\t\tmessage, err := reader.ReadString('\\n')\n\t\t\tif err != nil {\n\t\t\t\t\t//Account for EOF\n\t\t\t\t\tbreak\n\t\t\t\t}\n\t\t\tmessage = strings.Replace(message, \"\\n\", \"\", -1)\n\t\t\tfmt.Println(message)\n\t\t\t}\n\t\tfmt.Println(\"}\")\n\t}\n"
	}

	if getThread == true {
		UseThread = "\t//This is a go thread\n\tgo MyThread()\n\t//wait for thread to start\n\ttime.Sleep(1 * time.Second)\n"
	}

	if Args == true {
		Main = "//main\nfunc main() {\n"+RandStart+"\targs := os.Args[1:]\n\tfor arg := range args {\n\t\tfmt.Println(args[arg])\n\t}\n"+PipeCode+UseThread+"}"
	} else {
		Main = "//main\nfunc main() {\n"+RandStart+"\tfmt.Printf(\"hellow world\")\n"+PipeCode+UseThread+"}"
	}
	return Main
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
	var getName bool = false
	var getArgs bool = false
	var getWrite bool = false
	var getRead bool = false
	var getIsIn bool = false
	var getRawIn bool = false
	var getRand bool = false
	var getSleep bool = false
	var getPipe bool = false
	var getProp bool = false
	var getShell bool = false
	var getThread bool = false
	var IsMain bool = false
	var UserIn string = ""
	var ThePackage string = ""
	var CName string = ""
	var Imports string = ""
	var Methods string = ""
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
		} else if UserIn == "--write-file" {
			getName = false
			getWrite = true
		//Get Read file method
		} else if UserIn == "--read-file" {
			getName = false
			getRead = true
		//Get IsIn method
		} else if UserIn == "--is-in" {
			getName = false
			getIsIn = true
		//Get raw_input method
		} else if UserIn == "--user-input" {
			getName = false
			getRawIn = true
		//Get sleep
		} else if UserIn == "--sleep" {
			getName = false
			getSleep = true
		//Get pipe
		} else if UserIn == "--pipe" {
			getName = false
			getPipe = true
		//Get prop
		} else if UserIn == "--prop" {
			getName = false
			getProp = true
		//Get Shell
		} else if UserIn == "--shell" {
			getName = false
			getShell = true

		//Get Shell
		} else if UserIn == "--shell" {
			getName = false
			getThread = true

		//Get Name of program
		} else if getName == true {
			CName = UserIn
			getName = false
		}

	}
	//Ensure program name is given
	if CName != "" {
		ThePackage = getPackage("main")
		Imports = getImports(getRawIn, getWrite, getRead, getRand, getArgs, getSleep, getPipe, getShell, getThread, getProp)
		Methods = getMethods(getRawIn, getRand, getWrite, getRead, getIsIn, getSleep, getShell, getThread, getProp)
		if IsMain == true {
			Main = getMain(getArgs,getRand,getPipe,getThread)
		} else {
			Main = ""
		}
		Content = ThePackage+"\n"+Imports+"\n"+Methods+"\n"+Main
		CreateNew(CName,Content)
	} else {
		help()
	}
}
