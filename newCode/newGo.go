package main

import (
	"bufio"
	"fmt"
	"io/ioutil"
	"os"
)

func help() {
	var ProgName string
	ProgName = "newGo"

	var Version string
	Version = "0.0.1"
	fmt.Println("Author: Dan (DJ) Coffman")
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

func Print(content string) {
	fmt.Printf(content)
}

//create import listing
func getImports(write bool, read bool, random bool) {
	var Imports string
	Imports = ""

	var standard string
	standard = "#include <iostream>\n#include <string>\n"

	var readWrite string
	readWrite = ""

	var ForRandom string
	ForRandom = ""

	if read == true || write == true {
		readWrite = "#include <fstream>\n"
	}
	if random == true {
		ForRandom = "#include <stdlib.h>\n#include <time.h>\n"
	}

	Imports = standard+readWrite+ForRandom+"\n"

	return Imports
}

//build main function
func getMain(Args, getRandom bool) {
	var Main string
	Main = ""

	var StartRandom string
	StartRandom = ""

	if getRandom == true {
		StartRandom = ""
	}

	if Args == true {
		Main = "//main\nfunc main(){\n\targs := os.Args[1:]\n\tfor arg := range args {\n\t\tfmt.Println(args[arg])\n}"
	} else {
		Main = "//main\nfunc main(){\n\tfmt.Printf(\"hellow world\")\n}"
	}
	return Main
}

//create new Go program
func CreateNew(filename string, content string) {
	filename = filename+".go"
	Print(content)
/*
	std::ofstream myfile
	myfile.open(filename.c_str())
	myfile << content
	myfile.close()
*/
}

//Go main
func main() {
	var NameIsNotOk bool
	NameIsNotOk = true

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
		}
		if NameIsNotOk == false {
			CName = UserIn
		}
		getName = false
	}
	//Ensure program name is given
	if CName != "" {
		Imports = getImports(getWrite,getRead,getRand)
		Methods =  getMethods(getRawIn,getRand,getWrite,getRead,getIsIn)
		if IsMain == true {
			Main = getMain(getArgs,getRand)
		} else {
			Main = ""
		}
		Content = Imports+Marcos+Methods+Main
		CreateNew(CName,Content)
	} else {
		help()
	}
}
