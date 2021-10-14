package main

import (
	"fmt"
	"io"
	"os"
	)

func help() {
	var ProgName string
	ProgName = "newGo"

	var Version string
	Version = "0.1.0"

	fmt.Println("Author: Joespider")
	fmt.Println("Program: \""+ProgName+"\"")
	fmt.Println("Version: "+Version)
	fmt.Println("Purpose: make new Go programs")
	fmt.Println("Usage: "+ProgName+" <args>")
	fmt.Println("\t-n <name> : program name")
	fmt.Println("\t--name <name> : program name")
	fmt.Println("\t--cli : enable command line (Main file ONLY)")
	fmt.Println("\t--main : main file")
	fmt.Println("\t--random : enable \"random\" int method")
	fmt.Println("\t--write-file : enable \"write\" file method")
	fmt.Println("\t--read-file : enable \"read\" file method")
	fmt.Println("\t--is-in : enable \"IsIn\" file method")
	fmt.Println("\t--user-input : enable \"Raw_Input\" file method")
}

func getPackage(ThePackage string) string {
	return "package "+ThePackage+"\n"
}

//create import listing
func getImports(UserInput bool, write bool, read bool, random bool, cli bool) string {
	var Imports string
	Imports = ""

	var standard string
	standard = "\"fmt\"\n"

	var readWrite string
	readWrite = ""

	var ForRandom string
	ForRandom = ""

	var ForCLI string
	ForCLI = ""

	var ForUserInput string
	ForUserInput = ""

	if read == true || write == true {
		readWrite = "\t\"io/ioutil\"\n\t\"io\"\n"
	}

	if read == true || write == true || cli == true {
		ForCLI = "\t\"os\"\n"
	}

	if UserInput == true {
		ForUserInput = "\t\"bufio\"\n"
	}

	if random == true {
		ForRandom = "\t\"math/rand\"\n\t\"time\"\n"
	}

	Imports = standard+readWrite+ForRandom+ForCLI+ForUserInput
	if Imports == standard {
		Imports = "import "+Imports
	} else {
		Imports = "import (\n\t"+Imports+"\t)\n"
	}

	return Imports
}

func getMethods(getRawIn bool, getRand bool, getWrite bool, getRead bool, getIsIn bool) string {
	var TheMethods string
	TheMethods = ""

	var ReadMethod string
	ReadMethod = ""

	var WriteMethod string
	WriteMethod = ""

	var RandMethod string
	RandMethod = ""

	var UserInput string
	UserInput = ""

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

	TheMethods = UserInput+WriteMethod+ReadMethod+RandMethod
	return TheMethods
}

//build main function
func getMain(Args bool, getRandom bool) string {
	var Main string
	Main = ""

	var RandStart string
	RandStart = ""


	if getRandom == true {
		RandStart = "\trand.Seed(time.Now().UnixNano())\n"
	}

	if Args == true {
		Main = "//main\nfunc main() {\n"+RandStart+"\targs := os.Args[1:]\n\tfor arg := range args {\n\t\tfmt.Println(args[arg])\n\t}\n}"
	} else {
		Main = "//main\nfunc main() {\n"+RandStart+"\tfmt.Printf(\"hellow world\")\n}"
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
	var getName bool
	getName = false

	var getArgs bool
	getArgs = false

	var getWrite bool
	getWrite = false

	var getRead bool
	getRead = false

	var getIsIn bool
	getIsIn = false

	var getRawIn bool
	getRawIn = false

	var getRand bool
	getRand = false

	var IsMain bool
	IsMain = false

	var UserIn string
	UserIn = ""

	var ThePackage string
	ThePackage = ""

	var CName string
	CName = ""

	var Imports string
	Imports = ""

	var Methods string
	Methods = ""

	var Main string
	Main = ""

	var Content string
	Content = ""

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
		//Get Name of program
		} else if getName == true {
			CName = UserIn
			getName = false
		}
	}
	//Ensure program name is given
	if CName != "" {
		ThePackage = getPackage("main")
		Imports = getImports(getRawIn,getWrite,getRead,getRand,getArgs)
		Methods = getMethods(getRawIn,getRand,getWrite,getRead,getIsIn)
		if IsMain == true {
			Main = getMain(getArgs,getRand)
		} else {
			Main = ""
		}
		Content = ThePackage+"\n"+Imports+"\n"+Methods+"\n"+Main
		CreateNew(CName,Content)
	} else {
		help()
	}
}
