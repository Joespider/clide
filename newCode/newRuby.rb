#!/usr/bin/ruby
#
#Program Details
User = "Joespider"
ProgramName = "newRuby"
VersionName = "0.1.02"
Purpose = "Purpose: make new Ruby Scripts"

#Help Page
def help
	puts ("Author: "+User)
	puts ("Program: "+ProgramName)
	puts ("Version: "+VersionName)
	puts ("Purpose: "+Purpose)
	puts ("Usage: "+ProgramName+".rb <args>")
	puts "\t-n <name> : program name"
	puts "\t--name <name> : program name"
	puts "\t--cli : enable command line (Main file ONLY)"
	puts "\t--main : main file"
	puts "\t-w : enable \"write\" file method"
	puts "\t-r : enable \"read\" file method"
	puts "\t-u : enable \"raw_input\" method"
end

#Get the User info for new program
def getDetails(theProgram,theAuthor)
	return "#Program Details\nUser = \""+theAuthor+"\"\nProgramName = \""+theProgram+"\"\nVersionName = \"0.0.0\"\nPurpose = \"\"\n"
end

#Get CLI arguments
def getArgs
	getName = false
	getUser = false
	#User Dictionary
	userArgs = {
		"theName" => "",
		"theUser" => "",
		"isCli" => false,
		"isMain" => false,
		"readFile" => false,
		"writeFile" => false,
		"raw_input" => false
	}
	#User CLI
	ARGV.each do|arg|
		theArg = arg.to_s
		if theArg == "-n" or theArg == "--name"
			getName = true
		elsif getName
			userArgs["theName"] = theArg
			getName = false
		elsif theArg == "--user"
			getUser = true
		elsif getUser
			userArgs["theUser"] = theArg
			getUser = false
		elsif theArg == "--cli"
			userArgs["isCli"] = true
		elsif theArg == "--main"
			userArgs["isMain"] = true
		elsif theArg == "-w"
			userArgs["writeFile"] = true
		elsif theArg == "-r"
			userArgs["readFile"] = true
		elsif theArg == "-u"
			userArgs["raw_input"] = true
		end
	end
	return userArgs
end

#Write new Ruby src file
def writeFile(fileName,content)
	theFileName = fileName.to_s
	theContent = content.to_s
	open(theFileName,"w") do |f|
		f.puts theContent
	end
end

#Handle Ruby inports
def getImports
	return "\n"
end

#Handle Ruby Methods
def getMethods(getHelp,getRead,getWrite,getRawInput,getCLI)
	theMethods = ""
	if getHelp
		theMethods = theMethods+"#Help Page\ndef help\n\tputs (\"Author: \"+User)\n\tputs (\"Program: \"+ProgramName)\n\tputs (\"Version: \"+VersionName)\n\tputs (\"Purpose: \"+Purpose)\n\tputs (\"Usage: \"+ProgramName+\".rb\")\nend\n\n"
	end
	if getRead
		theMethods = theMethods+"#Read from file\ndef readFile(fileName)\n\ttheFileName = fileName.to_s\n\ttheFile = File(theFileName)\n\tfile_data = theFile.read\n\treturn file_data\nend\n\n"
	end
	if getWrite
		theMethods = theMethods+"#Write to file\ndef writeFile(fileName,content)\n\ttheFileName = fileName.to_s\n\ttheContent = content.to_s\n\topen(theFileName,\"w\") do |f|\n\t\tf.puts theContent\n\tend\nend\n\n"
	end
	if getRawInput
		theMethods = theMethods+"#User Input\ndef raw_input(message)\n\tprint message\n\treturn gets.chomp()\nend\n\n"
	end
	if getCLI
		theMethods = theMethods+"#Get CLI arguments\ndef getArgs\n\tgetName = false\n\t#User Dictionary\n\tuserArgs = {\n\t\t\"keyOne\" => \"\",\n\t\t\"keyTwo\" => false\n\t}\n\t#User CLI\n\tARGV.each do|arg|\n\t\ttheArg = arg.to_s\n\t\tif theArg == \"-1\" or theArg == \"--one\"\n\t\t\tgetName = true\n\t\telsif getName\n\t\t\tuserArgs[\"keyOne\"] = theArg\n\t\t\tgetName = false\n\t\telsif theArg == \"-2\" or theArg == \"--two\"\n\t\t\tuserArgs[\"keyTwo\"] = true\n\t\tend\n\tend\n\treturn userArgs\nend\n\n"
	end
	return theMethods
end

#Handle Ruby Main
def getMain(yes,cli)
	theMain = ""
	if yes
		if cli
			theMain = "#Main\n# {\nUserInput = getArgs\n# }"
		else
			theMain = "#Main\n# {\n\n# }"
		end
	end
	return theMain	
end

#Main
# {
UserInput = getArgs
if UserInput["theName"] != ""
	#Get program name
	TheName = UserInput["theName"]
	#Get author of program
	TheAuthor = UserInput["theUser"]
	#Get the program details
	TheDetails = getDetails(TheName,TheAuthor)
	#Pull the imports for program
	TheImports = getImports
	#Pull the Main function
	TheMain = getMain(UserInput["isMain"],UserInput["isCli"])
	#Pull the Methods for the program
	TheMethods = getMethods(UserInput["isMain"],UserInput["readFile"],UserInput["writeFile"],UserInput["raw_input"],UserInput["isCli"])
	#Organize Program content
	TheContent = TheDetails+TheImports+TheMethods+TheMain
	#Create new ruby src file
	writeFile(TheName+".rb",TheContent)
else
	help
end
# }
