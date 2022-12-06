package main

import (
	"fmt"
	"io/ioutil"
	"io"
	"math/rand"
	"os"
	"os/exec"
	"bufio"
	"time"
	"strings"
	"strconv"
	"reflect"
	"math"
	)

func help() {
	var ProgName string = "shell"
	var Version string = "0.0.0"

	fmt.Println("Author: joespider")
	fmt.Println("Program: \""+ProgName+"\"")
	fmt.Println("Version: "+Version)
	fmt.Println("Purpose: ")
	fmt.Println("Usage: "+ProgName+" <args>")
}


func raw_input(Message string) string {
	var UserIn string
	fmt.Print(Message)
	reader := bufio.NewReader(os.Stdin)
	UserIn, _ = reader.ReadString('\n')
	return UserIn
}

func fexists(aFile string) bool {
	if _, err := os.Stat(aFile); err == nil {
		return true
	} else {
		return false
	}
}

func WriteToFile(filename string, content string) error {
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

func ReadFile(filename string) {

	data, err := ioutil.ReadFile(filename)
	if err != nil {
		fmt.Println("file reading error", err)
		return
	}
	fmt.Println("Contents of file:", string(data))
}

func Random(min int, max int) int {
	return rand.Intn(max-min) + min
}

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

func sleep() {
	time.Sleep(3 * time.Second)
}

func MyThread() {
	fmt.Println("{My Thread}")
}

func rev(s string) string {
	rns := []rune(s)
	for i, j := 0, len(rns)-1; i < j; i, j = i+1, j-1 {
		rns[i], rns[j] = rns[j], rns[i]
	}

	// return the reversed string.
	return string(rns)
}

func GetSysProp(PleaseGet string) string {
	if PleaseGet != "" {
		return os.Getenv(PleaseGet)
	} else {
		return ""
	}
}

func split(Str string, sBy string) []string {
	Array := strings.Split(Str, sBy)
	return Array
}

func join(Array []string, ToJoin string) string {
	Joined := strings.Join(Array, ToJoin)
	return Joined
}

func replaceAll(Str string, sBy string, ToJoin string) string {
	newStr := strings.ReplaceAll(Str, sBy, ToJoin)
	return newStr
}

func SubString(TheString string, Start int, End int) string {
	Len := Start + End
	if Len >= len(TheString) {
		return TheString[Start:End]
	} else {
		return TheString[Start:Len]
	}
}

func Index(TheString string, SubStr string) int {
	return strings.Index(TheString, SubStr)
}

func Str(number int) string {
	return strconv.Itoa(number)
}

func toUpperCase(message string) string {
	Upper := strings.ToUpper(message)
	return Upper
}

func toUpperCase_at(message string, plc int) string {
	var newStr string
	chars := []rune(message)
	for i := 0; i < len(chars); i++ {
		if i == plc {
			newStr = newStr + strings.ToUpper(string(chars[i]))
		} else {
			newStr = newStr + string(chars[i])
		}
	}
	return newStr
}

func toLowerCase(message string) string {
	Upper := strings.ToLower(message)
	return Upper
}

func toLowerCase_at(message string, plc int) string {
	var newStr string
	chars := []rune(message)
	for i := 0; i < len(chars); i++ {
		if i == plc {
			newStr = newStr + strings.ToLower(string(chars[i]))
		} else {
			newStr = newStr + string(chars[i])
		}
	}
	return newStr
}

func IsIn(Str string, Sub string) bool {
	return strings.Contains(Str,Sub)
}


//main
func main() {
	rand.Seed(time.Now().UnixNano())
	args := os.Args[1:]
	if len(args) > 0 {
		for arg := range args {
			fmt.Println(args[arg])
		}
	} else {
		help()
	}
	fi, err := os.Stdin.Stat()
	if err != nil {
		panic(err)
	}
	if fi.Mode() & os.ModeNamedPipe == 0 {
		fmt.Println("nothing was piped in")
	} else {
		fmt.Println("[Pipe]")
		fmt.Println("{")
		var reader = bufio.NewReader(os.Stdin)
		for true {
			message, err := reader.ReadString('\n')
			if err != nil {
					//Account for EOF
					break
				}
			message = strings.Replace(message, "\n", "", -1)
			fmt.Println(message)
			}
		fmt.Println("}")
	}
	//This is a go thread
	go MyThread()
	//wait for thread to start
	time.Sleep(1 * time.Second)
/*
	var str string
	var number int
	var intArray [5]int

	if reflect.ValueOf(str).Kind() == reflect.String {
		fmt.Println("This is a string")
	}

	if reflect.ValueOf(number).Kind() == reflect.Int {
		fmt.Println("This is an Int")
	}

	if reflect.ValueOf(intArray).Kind() == reflect.Array {
		fmt.Println("This is an Array")
	}
*/
/*
	fmt.Println(math.Abs(-12.3))
	fmt.Println(math.Sin(43))
	fmt.Println(math.Cos(57))
	fmt.Println(math.Log(89))
	fmt.Println(math.Log10(90))
	fmt.Println(math.Mod(14, 5))
	fmt.Println(math.Ceil(12.5))
	fmt.Println(math.Floor(23.7))
	fmt.Println(math.Min(23, 45))
	fmt.Println(math.Max(23, 45))
	fmt.Println(math.Pow(2, 16))
	fmt.Println(math.IsNaN(35))
*/
/*	var StrLen int
	var NamLen int
	var Message string
	var Names [3]string
	Names[0] = "one"
	Names[1] = "two"
	Names[2] = "three"
	Message = "This is a message"
	StrLen = len(Message)
	NamLen = len(Names)
*/
}