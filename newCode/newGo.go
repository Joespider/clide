package main

import (
	"bufio"
	"fmt"
//	"io/ioutil"
	"os"
	"strings"
)

func print(Output string) {
	fmt.Println(Output)
}

func help() {
	var ProgName string = "newGo"
	var Version string = "0.1.0"
	print("Author: Dan (DJ) Coffman")
	print("Program: \""+ProgName+"\"")
	print("Version: "+Version)
	print("Purpose: make new Go programs")
	print("Usage: "+ProgName+" <args>")
	print("\t-n <name> : program name")
	print("\t--name <name> : program name")
	print("\t--cli : enable command line (Main file ONLY)")
	print("\t--main : main file")
	print("\t--write-file : enable \"write\" file method")
	print("\t--read-file : enable \"read\" file method")
}

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func CreateNew(TheFile, Content string) {
	if (strings.HasSuffix(TheFile, ".go") != true) {
		TheFile = TheFile+".go"
	}
	f, err := os.Create(TheFile)
	w := bufio.NewWriter(f)
	w.WriteString(Content)
	check(err)
	w.Flush()
}

//create import listing
func getImports(cli, write, read bool) string {
	var useOS = ""
	var Imports string = ""
	var readWrite string = ""
	if ((read == true) || (write == true)) {
		readWrite = "\t\"bufio\"\n\t\"io/ioutil\"\n"
		cli = true
	}
	if (cli == true) {
		useOS = "\t\"os\"\n"
	}
	Imports = "import (\n\t\"fmt\"\n"+useOS+readWrite+"\n)\n\n"

	return Imports
}

//create base methods
func getMethods(write, read bool) string {
	var Methods string = ""
	var RawInput string = ""
	var WriteFile string = ""
	var ReadFile string = ""

	PrintMethod := "func print(Output string) {\n\tfmt.Println(Output)\n}\n\n"
	ErrorMethod := "func check(e error) {\n\tif e != nil {\n\t\tpanic(e)\n\t}\n}\n\n"

	if (write == true) {
		WriteFile = "//Write file\nfunc Write(TheFile, Content string) {\n\tf, err := os.Create(TheFile)\n\tw := bufio.NewWriter(f)\n\tw.WriteString(Content)\n\tcheck(err)\n\tw.Flush()\n}\n\n"
	}
	if (read == true) {
		ReadFile = "//Read File\nfunc Read(TheFile string) {\n\tdat, err := ioutil.ReadFile(TheFile)\n\tcheck(err)\n\tfmt.Println(string(dat))\n}\n\n"
	}

	//Methods for Go
	Methods = PrintMethod+ErrorMethod+RawInput+WriteFile+ReadFile

	return Methods
}

//build main function
func getMain(getArgs bool) string {
	var Main string = ""

	if (getArgs == true) {
		Main = "//main\nfunc main(){\n\targs := os.Args[1:]\n\tfor arg := range args {\n\t\tprint(args[arg])\n\t}\n}"
	} else {
		Main = "//main\nfunc main(){\n\tprint(\"hellow world\")\n}"
	}
	return Main
}

//Go main
func main() {
  	var getName bool = false
	var getArgs bool = false
	var getWrite bool = false
	var getRead bool = false
	var IsMain bool = false
	var CName string = ""
	var TheImports string = ""
	var TheMethods string = ""
	var TheContent string = ""
	var TheMain string = ""
	var UserIn string = ""

	//Get User CLI Args
	args := os.Args[1:]

	for arg := range args {
		//Save output to UserIn
		UserIn = args[arg]
		//Get name of program
		if ((UserIn == "-n") || (UserIn == "--name")) {
			getName = true
		//Get cli arg in main method
		} else if (UserIn == "--cli") {
			getName = false
			getArgs = true
		//Is a main
		} else if (UserIn == "--main") {
			getName = false
			IsMain = true
		//Get Write file method
		} else if (UserIn == "--write-file") {
			getName = false
			getWrite = true
		//Get Read file method
		} else if (UserIn == "--read-file") {
			getName = false
			getRead = true
		//capture new Go program name
		} else if (getName == true) {
			CName = UserIn
			getName = false
		}
	}
	//Ensure program name is given
	if (CName != "") {
		TheImports = getImports(getArgs,getWrite,getRead)
		TheMethods =  getMethods(getWrite,getRead)
		if (IsMain == true) {
			TheMain = getMain(getArgs)
		} else 	{
			TheMain = ""
		}
		TheContent = "package main\n\n"+TheImports+TheMethods+TheMain
		CreateNew(CName,TheContent)
	//No Program name...show help page
	} else {
		help()
	}
}
