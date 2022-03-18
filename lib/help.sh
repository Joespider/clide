#!/usr/bin/env bash

#Start="\e[1;45m"
Start="\e[1;35m"
End="\e[0m"

Head=$1
LangsDir=$2
project=${CodeProject}
shift
shift

#Select Languge
ManageLangs()
{
	local TheLang=$1
	local Langs=${LangsDir}/Lang.${TheLang^}
	#Make first letter uppercase
	shift
	local Manage=$@
	if [ -f ${Langs} ]; then
		${Langs} ${Manage[@]}
	fi
}

#Clide menu help page
MenuHelp()
{
	local Lang=$1
	local Choice=$2
	case ${Lang} in
		no-lang)
			echo ""
			echo "----------------[(${Lang}) Menu]----------------"
			echo -e "read config\t\t\t: \"read ${Head} config\""
			echo -e "edit config\t\t\t: \"edit ${Head} config\""
			echo -e "version\t\t\t\t: \"Get ${Head} Version\""
			echo -e "cv, code-version\t\t: \"Get compile/interpreter version of supported languages\""
			echo -e "dv, debug-version\t\t: \"Get debugger version of supported languages\""
			echo -e "sv, support-version\t\t: \"Get compile/interpreter version of supported languages\""
			echo -e "tv, temp-version\t\t: \"Get version of templates\""
			echo -e "rv, repo-version\t\t: \"Get version control version\""
			echo -e "use <language> <code>\t\t: \"choose language\""
			echo -e "<language> <code>\t\t: \"choose language\""
			echo "------------------------------------------------"
			echo ""
			;;
		*)
			case ${Choice,,} in
				ls)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: lists the source code for a given language and/or project"
					echo ""
					echo -e "${Choice,,} <args>\t\t: \"list the files you have\""
					echo "------------------------------------------------"
					echo ""
					;;
				lscpl)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: lists the code compiled, set to run, and build code"
					echo "------------------------------------------------"
					echo ""
					;;
				type)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Get the type of programming language"

					echo ""
					echo -e "${Choice,,} <type>"
					echo -e "\tclassified\t\t: \"Get the type of Language\""
					echo -e "\texecutable\t\t: \"Get the executable of Language\""
					echo -e "\truntime\t\t\t: \"Get how the code is run\""
					echo "------------------------------------------------"
					echo ""
					;;
				using)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Sometimes the selected language is not shown, '${Choice,,}' displays the active language"
					echo "------------------------------------------------"
					echo ""
					;;
				unset)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: unselecting source code can help edit/compile source code"
					echo ""
					echo -e "${Choice,,} <src>\t\t\t\"deselect source code\""
					echo -e "${Choice,,}\t\t\t\t\"deselect ALL source code\""
					echo "------------------------------------------------"
					echo ""
					;;
				use)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: selecting a different langauge while in a clide session"
					echo ""
					echo -e "<lang> <src>\t\t\t\"Choose a langauge and preselect code\""
					echo -e "${Choice,,} <lang> <src>\t\t\"Choose a langauge and preselect code\""
					echo -e "${Choice,,}\t\t\t\t\"list supported lanugages\""
					echo "------------------------------------------------"
					echo ""
					;;
				cpl|compile)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Compile the selected code"
					echo ""
					echo -e "${Choice,,}\t\t\t\t\"compile with default settings\""
					echo -e "${Choice,,} -a <args>\t\t\t\"compile with the given argumentss\""
					echo -e "${Choice,,} --args <args>\t\t\"compile with the given arguments\""
					echo -e "${Choice,,} --get-args\t\t\t\"get the compile arguments\""
					echo -e "${Choice,,} --type <args>\t\t\"pre-set compile type\""
					echo -e "\t\t--help\t\t\"get the language specific compile type(s)\""
					echo -e "\t\t--reset\t\t\"reset compile type\""
					echo -e "\t\treset\t\t\"reset compile type\""
					echo -e "${Choice,,} --<type>\t\t\t\"pre-set compile type\""
					echo "------------------------------------------------"
					echo ""
					;;
				car)
					case ${Choice,,} in
						car)
							echo ""
							echo "----------------[(${Choice,,}) Menu]----------------"
							echo -e "Purpose: Compile and run code"
							echo ""
							echo -e "${Choice,,}\t\t\t\t\t\"compile and run\""
							echo -e "${Choice,,} -a <cpl>\t\t\t\t\"compile with compile args and run\""
							echo -e "${Choice,,} --args <cpls>\t\t\t\"compile with compile args and run\""
							echo -e "${Choice,,} --args <cpl> --run <run>\t\t\"compile and run with args\""
							echo -e "${Choice,,} --run <runs>\t\t\t\"compile and run wwith runtime args\""
							echo "------------------------------------------------"
							echo ""
							;;
						*)
							;;
					esac
					;;
				rm|remove|delete)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Deleting binary and source code files"
					echo ""
					echo -e "${Choice,,} <src>\t\t\t\t\"delete source code with extentions, and binary\""
					echo -e "${Choice,,} -f <src>\t\t\t\t\"forcably delete source code with extentions, and binary\""
					echo -e "${Choice,,} --src <src>\t\t\t\"forcably delete source code with extentions\""
					echo -e "${Choice,,} --src -f <src>\t\t\t\"forcably delete source code with extentions, and binary\""
					echo -e "${Choice,,} --bin <src>\t\t\t\"delete binary\""
					echo -e "${Choice,,} --bin -f <src>\t\t\t\"forcably dekete binary\""
					echo "------------------------------------------------"
					echo ""
					;;
				rmsrc)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Deleting source code files"
					echo ""
					echo -e "${Choice,,} <src>\t\t\t\t\"delete source code with extentions\""
					echo -e "${Choice,,} -f <src>\t\t\t\t\"forcably delete source code with extentions\""
					echo "------------------------------------------------"
					echo ""
					;;
				rmbin|remove-bin|delete-bin)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Deleting binary"
					echo ""
					echo -e "${Choice,,} <src>\t\t\t\t\"delete binary\""
					echo -e "${Choice,,} -f <src>\t\t\t\t\"forcably delete binary\""
					echo "------------------------------------------------"
					echo ""
					;;
				set|select)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Selecting source code to assist with editing, compiling, and running code"
					echo ""
					echo -e "${Choice,,} <src>\t\t\t\"select source code, with or without extentions\""
					echo -e "${Choice,,} <src>,<src>\t\t\t\"select multiple source code files\""
					echo "------------------------------------------------"
					echo ""
					;;
				add)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Having already selected source code, additional code can be selected"
					echo ""
					echo -e "${Choice,,} <src>\t\t\t\"add source code, with or without extentions\""
					echo -e "${Choice,,} <src>,<src>\t\t\"add multiple source code files\""
					echo "------------------------------------------------"
					echo ""
					;;
				notes)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Not everyone remembers everything about a language"
					echo ""
					echo -e "${Choice,,} edit\t\t\t\"Edit the notes for a given language\""
					echo -e "${Choice,,} <src>,<src>\t\t\"Read the notes for a given language\""
					echo "------------------------------------------------"
					echo ""
					;;
				${editor}|edit)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Edit your selected code. ONLY selected code will be used"
					echo ""
					echo -e "${Choice,,}\t\t\t\t\"Edit a single source file\""
					echo -e "${Choice,,} <src>\t\t\"Edit a single source file (when multiple source files are selected)\""
					echo -e "${Choice,,} non-lang <file>\t\t\"Edit a non-selectable file (files that are not language specific)\""
					echo "------------------------------------------------"
					echo ""
					;;
				${ReadBy}|read)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: read your selected code. ONLY selected code will be used"
					echo ""
					echo -e "${Choice,,}\t\t\t\t\"read a single source file\""
					echo -e "${Choice,,} <src>\t\t\"read a single source file (when multiple source files are selected)\""
					echo -e "${Choice,,} non-lang <file>\t\t\"read a non-selectable file (files that are not language specific)\""
					echo "------------------------------------------------"
					echo ""
					;;
				time)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Run and time your executable."
					echo -e "Projects: selected source code not required"
					echo -e "Non-project: source code MUST be selected"
					echo ""
					echo -e "${Choice,,}\t\t\t\t\"run and time code\""
					echo -e "${Choice,,} -a <args>\t\t\t\"run code with a cli argument\""
					echo -e "${Choice,,} --args <args>\t\t\"run code with a cli argument\""
					echo "------------------------------------------------"
					echo ""
					;;
				execute|exe|run)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Run your executable."
					echo -e "Projects: selected source code not required"
					echo -e "Non-project: source code MUST be selected"
					echo ""
					echo -e "${Choice,,}\t\t\t\t\"run code\""
					echo -e "${Choice,,} -a <args>\t\t\t\"run code with a cli argument\""
					echo -e "${Choice,,} --args <args>\t\t\"run code with a cli argument\""
					echo "------------------------------------------------"
					echo ""
					;;
				bkup|backup)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Need a quick change or something to test? Backup/restore your code for testing"
					echo -e "(source code MUST be selected)"
					echo ""
					echo -e "${Choice,,}\t\t\t\t\"backup your selected source code\""
					echo -e "${Choice,,} <src>\t\t\t\"Choose source code, when multiple source code selected\""
					echo "------------------------------------------------"
					echo ""
					;;
				restore)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Need a quick change or something to test? Backup/restore your code for testing"
					echo -e "(source code MUST be selected)"
					echo ""
					echo -e "${Choice,,}\t\t\t\t\"restore your selected source code\""
					echo -e "${Choice,,} <src>\t\t\t\"Choose source code, when multiple source code selected\""
					echo ""
					echo -e "${Choice,,} --help\t\t\t\"This Help Page\""
					echo "------------------------------------------------"
					echo ""
					;;
				rename)
					;;
				src|source)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: setting three or more active source files, '${Choice,,}' displays your selected code"
					echo "------------------------------------------------"
					echo ""
					;;
				copy)
					;;
				session)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Manage Sessions"
					echo ""
					echo -e "${Choice,,} save <session>\t\t\"choose session by name\""
					echo -e "${Choice,,} save\t\t\t\"save your session as default\""
					echo -e "${Choice,,} load <session>\t\t\"choose your session by name\""
					echo -e "${Choice,,} load\t\t\t\"load your default session\""
					echo -e "${Choice,,} list\t\t\t\"Get the list of your saved sessions\""
					echo ""
					echo -e "${Choice,,} --help\t\t\t\"This Help Page\""
					echo "------------------------------------------------"
					echo ""
					;;
				save)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Save your active session"
					echo ""
					echo -e "${Choice,,} <session>\t\t\t\"save session by name\""
					echo -e "${Choice,,}\t\t\t\t\"save your session as default\""
					echo ""
					echo -e "${Choice,,} --help\t\t\t\"This Help Page\""
					echo "------------------------------------------------"
					echo ""
					;;
				last|load)
					echo ""
					echo "----------------[(${Choice,,}) Menu]----------------"
					echo -e "Purpose: Load your saved session to pick up where you left off"
					echo -e "(saved sessions MUST exist)"
					echo ""
					echo -e "${Choice,,} <session>\t\t\t\"choose your session by name\""
					echo -e "${Choice,,}\t\t\t\t\"load your default session\""
					echo ""
					echo -e "${Choice,,} --help\t\t\t\"This Help Page\""
					echo "------------------------------------------------"
					echo ""
					;;
				create)
					CreateHelp ${Lang}
					;;
				make)
					makeHelp
					;;
				project)
					ProjectHelp
					;;
				package)
					PackageHelp
					;;
				notes)
					NotesHelp
					;;
				debug)
					debuggerHelp
					;;
				search)
					LookForHelp
					;;
				*)
					echo ""
					echo "----------------[(${Head}) Menu]----------------"
					echo -e "ls\t\t\t\t: \"list progams\""
					echo -e "lscpl\t\t\t\t: \"list compiled progams\""
					echo -e "using\t\t\t\t: \"get the language being used\""
					echo -e "unset\t\t\t\t: \"deselect source code\""
					echo -e "unset <code>\t\t\t: \"deselect source code\""
					echo -e "use <language> <code>\t\t: \"choose language\""
					echo -e "save\t\t\t\t: \"Save session\""
					echo -e "create <arg>\t\t\t: \"create compile type, compile arguments, and runtime arguments"
					echo -e "\thelp\t\t\t: \"create help page"
					echo -e "debug\t\t\t\t: \"debug your program\""
					echo ""
					ManageLangs ${Lang} "MenuHelp"
					echo -e "cpl, compile --args <args>\t: \"compile program with one-time-use arguments\""
					echo -e "cpl, compile --get-args\t\t: \"show compile arguments\""
					echo -e "car\t\t\t\t: \"compile and run; compile and run with arguments\""
					echo -e "rm, remove, delete\t\t: \"delete source AND binary file\""
					echo -e "rmbin, remove-bin, delete-bin\t: \"delete ONLY binary file\""
					echo -e "set <file>\t\t\t: \"select source code\""
					echo -e "select <file>\t\t\t: \"select source code\""
					echo -e "add <file>\t\t\t: \"add new file to project\""
					echo -e "notes <action>\t\t\t: \"make notes for the ${Lang} language\""
					echo -e "${editor}, edit, ed\t\t\t: \"edit source code\""
					echo -e "${ReadBy}, read\t\t\t: \"Read source code\""
					echo -e "search <find>\t\t\t: \"search for code in project\""
					case ${project} in
						none)
							echo -e "project <action> <name>\t\t: \"handle projects\""
							echo -e "\tnew <name>\t\t: \"create a new project\""
							echo -e "\tlist <name>\t\t: \"list all your projects\""
							echo -e "\tload <name>\t\t: \"load and existing projects\""
							echo -e "\tset <name>\t\t: \"load and existing projects\""
							echo -e "\tselect <name>\t\t: \"load and existing projects\""
							;;
						*)
							echo -e "project <action> <name>\t\t: \"handle projects\""
							echo -e "\tnew <name>\t\t\t: \"create a new project\""
							echo -e "\ttype <name>\t\t\t: \"display the type of project\""
							echo -e "\ttitle <name>\t\t\t: \"give your project a title\""
							echo -e "\tupdate <name>\t\t\t: \"update your existing project\""
							echo -e "\tlist <name>\t\t\t: \"list all your projects\""
							echo -e "\tload <name>\t\t\t: \"load and existing projects\""
							echo -e "\texport <name>\t\t\t: \"export existing project to tar.gz\""
							echo -e "\tset <name>\t\t\t: \"load and existing projects\""
							echo -e "\tselect <name>\t\t\t: \"load and existing projects\""
							echo -e "\tlink <lang>\t\t: \"Link a language to an active project\""
							echo -e "\t\t--list, list\t: \"list the linked languages in an active project\""
							echo -e "\tswap, use <lang>\t: \"swap to a language in an active project\""
							echo -e "\t\t--list, list\t: \"list the linked languages in an active project\""
							echo -e "\tdiscover\t\t: \"update the list of projects\""
							echo -e "${repoTool}, repo\t\t\t: \"handle repos\""
							;;
					esac
					echo -e "execute, exe, run <option>\t: \"run active program\""
					echo -e "\t\t-a, --args\t: \"run program with cli arguments\""
					echo -e "\t\t-d, --debug\t: \"run program in debug mode\""
					echo -e "time <options>\t\t\t: \"runime of an active program\""
					echo -e "\t-a, --args\t\t: \"run program with cli arguments\""
					echo -e "bkup, backup\t\t\t: \"make backup of existing source code\""
					echo -e "restore\t\t\t\t: \"restore the backup to original source code\""
					echo -e "rename <new>\t\t\t: \"rename the existing source code\""
					echo -e "src, source\t\t\t: \"list selected source code\""
					echo -e "copy <new>\t\t\t: \"copy the existing source code\""
					echo -e "last, load\t\t\t: \"Load last session\""
					echo -e "exit, close\t\t\t: \"close ide\""
					echo ""
					echo -e "help\t\t\t\t: \"This help page\""
					echo -e "help <command>\t\t\t: \"Get more details on a given command\""
					echo "------------------------------------------------"
					echo ""
					;;
			esac
			;;
	esac
}

LookForHelp()
{
	local cmd="search"
	echo ""
	echo "----------------[(${cmd}) Menu]----------------"
	echo "Search project for text in your source code"
	echo ""
	echo -e "${cmd} <look for>\t\t\t: \"Search your project\""
	echo -e "${cmd} --file-only <look for>\t\t: \"ONLY display source file\""
	echo -e "${cmd} --files <look for>\t\t: \"ONLY display source file\""
	echo -e "${cmd} --count <look for>\t\t: \"display number of search results\""
	echo -e "${cmd} --occur <look for>\t\t: \"display number of search results\""
	echo -e "${cmd} --help\t\t\t\t: \"ONLY display source file\""
	echo "------------------------------------------------"
	echo ""
}

CreateHelp()
{
	local Lang=$1
	local Action=$2
	case ${Action} in
		cpl|cpl-args)
			ManageLangs ${Lang} "setCplArgs-help"
			;;
		type)
			ManageLangs ${Lang} "compileType-list"
			;;
		*)
			echo ""
			echo "----------------[(${Head}) \"Create\" Help]----------------"
			echo -e "args\t\t\t\t: create custom runtime args"
			echo -e "cpl, cpl-args\t\t\t: create compiler args"
			echo -e "newCodeTemp <type>\t\t: make your own source code ($ new <code>)"
			echo -e "\tcustom\t\t\t: Create template"
			echo -e "\tdefault\t\t\t: Use the tempalte from ${Head}"
			ManageLangs ${Lang} "CreateHelp"
			echo -e "type <args>\t\t\t: Create compile type"
			echo -e "time\t\t\t\t: set runtime of program"
			echo -e "reset <args>\t\t\t: clear settings"
			echo -e "\ttype\t\t\t: clear compile type"
			echo -e "\targs\t\t\t: clear run time args"
			echo -e "\tcpl, cpl-args\t\t: clear compile args"
			echo "---------------------------------------------------------"
			echo ""
			;;
	esac
}

makeHelp()
{
	local Lang=$1
	echo ""
	echo "----------------[(${Head}) \"Make\" Help]----------------"
	echo -e "Purpose: \"create and handle makefiles\""
	echo -e "create\t\t\t\t: \"Create a makefile in a ${Lang} Project\""
	echo -e "edit\t\t\t\t: \"Edit an existing makefile in a ${Lang} Project\""
	echo -e "enable\t\t\t\t: \"Enable previously disabled makefile in a ${Lang} Project\""
	echo -e "disable\t\t\t\t: \"Disable makefile in a ${Lang} Project\""
	echo -e "(Can be used to create a new makefile)"
	echo -e "(To run make, just tell ${Head} to compile)"
#	ManageLangs ${Lang} "makeHelp"
	echo "---------------------------------------------------------"
	echo ""
}

makeCliHelp()
{
	local Lang=$1
	echo ""
	echo "----------------[(${Head}) \"Make\" Help]----------------"
	echo -e "Purpose: \"create and handle makefiles\""
	echo -e "--create\t\t\t\t: \"Create a makefile in a ${Lang} Project\""
	echo -e "--edit\t\t\t\t: \"Edit an existing makefile in a ${Lang} Project\""
	echo -e "--enable\t\t\t\t: \"Enable previously disabled makefile in a ${Lang} Project\""
	echo -e "--disable\t\t\t\t: \"Disable makefile in a ${Lang} Project\""
	echo -e "(Can be used to create a new makefile)"
	echo -e "(To run make, just tell ${Head} to compile)"
#	ManageLangs ${Lang} "makeHelp"
	echo "---------------------------------------------------------"
	echo ""
}

ProjectDelete()
{
	echo ""
	echo "----------------[(${Head}) \"Project\" Help]----------------"
	echo -e "Purpose: \"handle projects\""
	echo -e "remove <project>\t\t\t: \"Remove a project entry in ${Head}\""
	echo -e "remove all\t\t\t: \"Remove ALL project entry in ${Head}\""
	echo "----------------------------------------------------------"
	echo ""
}

ProjectHelp()
{
	echo ""
	echo "----------------[(${Head}) \"Project\" Help]----------------"
	echo -e "Purpose: \"handle projects\""
	echo -e "project <action>\t\t\t: \"handle projects\""
	echo -e "\tnew <project>\t\t\t: \"Create a new project\""
	echo -e "\timport <project> <path>\t\t: \"Import projects\""
	echo -e "\tupdate, save\t\t\t: \"Update the active project\""
	echo -e "\texport\t\t\t\t: \"Export the active project to a tar.gz\""
	echo -e "\tload <project>\t\t\t: \"Choose a project to make active\""
	echo -e "\tload <project> <lang>\t\t: \"Choose a project to make active with a given language\""
	echo -e "\tset <project>\t\t\t: \"Choose a project to make active\""
	echo -e "\tset <project> <lang>\t\t: \"Choose a project to make active with a given langauge\""
	echo -e "\tselect <project>\t\t: \"Choose a project to make active\""
	echo -e "\tselect <project> <lang>\t\t: \"Choose a project to make active with a given langauge\""
	echo -e "\ttitle\t\t\t\t: \"Make a title for a project\""
	echo -e "\tremove, delete <project>\t: \"Choose a project to remove or delete\""
	echo -e "\ttype\t\t\t\t: \"display the type of project\""
	echo -e "\t\tlist\t\t\t: \"Show list of possible project types\""
	echo -e "\tlist\t\t\t\t: \"List ALL projects\""
	echo -e "\tlink <lang>\t\t\t: \"Link a language to an active project\""
	echo -e "\t\t--list, list\t\t: \"list the linked languages in an active project\""
	echo -e "\tswap <lang>\t\t\t: \"swap to a language in an active project\""
	echo -e "\t\t--list, list\t\t: \"list the linked languages in an active project\""
	echo -e "\tactive\t\t\t\t: \"Display the name of the current project\""
	echo -e "\tfiles\t\t\t\t: \"List the files under the active project\""
	echo -e "\tfiles src\t\t\t: \"List the source code paths only in an active project\""
	echo -e "\ttypes\t\t\t\t: \"Display the types of projects under ${Lang}\""
	echo -e "\tdiscover\t\t\t: \"Discover project on system (creates project profile)"
	ManageLangs ${Lang} "ProjectHelp"
	echo "----------------------------------------------------------"
	echo ""
}

PackageHelp()
{
	echo ""
	echo "----------------[(${Head}) \"Package\" Help]----------------"
	echo -e "Purpose: \"Handle Java Packages\""
	echo -e "new <package>\t\t\t: \"Create a new package name (this.is.a.package)\""
	echo -e "check <package>\t\t\t: \"Check if package name exists (this.is.a.package)\""
	echo -e "set <package>\t\t\t: \"Enter the package name (this.is.a.package)\""
	echo -e "list\t\t\t\t: \"List all the packages\""
	echo "----------------------------------------------------------"
	echo ""
}

NotesHelp()
{
	echo ""
	echo "----------------[(${Head}) \"Notes\" Help]----------------"
	echo -e "edit, add\t: \"edit notes\""
	echo -e "read\t\t: \"read notes\""
	echo "----------------------------------------------------------"
	echo ""

}

debuggerHelp()
{
	case ${Debugger} in
		gdb)
			echo "GDB is best suited for C, C++, Rust, and Java code"
			echo ""
			echo -e "Command\t\tDescription"
			echo -e "r\t\tStart running program until a breakpoint or end of program"
			echo -e "b fun\t\tSet a breakpoint at the begining of function \"fun\""
			echo -e "b N\t\tSet a breakpoint at line number N of source file currently executing"
			echo -e "b file.c:N\tSet a breakpoint at line number N of file \"file.c\""
			echo -e "d N\t\tRemove breakpoint number N"
			echo -e "info break\tList all breakpoints"
			echo -e "c\t\tContinues/Resumes running the program until the next breakpoint or end of program"
			echo -e "f\t\tRuns until the current function is finished"
			echo -e "s\t\tRuns the next line of the program"
			echo -e "s N\t\tRuns the next N lines of program"
			echo -e "n\t\tLike s, but it does not step into functions"
			echo -e "p var\t\tPrints the current value of the variable \"var\""
			echo -e "set var=val\tAssign \"val\" value to the variable \"var\""
			echo -e "bt\t\tPrints a stack trace"
			echo -e "q\t\tQuit from gdb"
			;;
		*)
			;;
	esac
}

newCodeHelp()
{
	local Lang=$1
	echo ""
	echo "----------------[(${Head}) \"new\" Help]----------------"
	echo -e "new <args>"
	echo -e "\t-v, --version\t\t\t: \"Get Version for each code template\""
	echo -e "\t-h, --help\t\t\t: \"This page\""
	ManageLangs ${Lang} "newCodeHelp"
	echo -e "\t<code>\t\t\t\t: \"provide code name; default settings\""
	echo "----------------------------------------------------------"
	echo ""
}

#Clide cli help page2
CliHelp()
{
	local calledBy=$1
	local cmd="clide ${calledBy}"
	local option=$2
	local example=$3
	case ${option} in
		info)
			echo ""
			echo "----------------[(${Head}) Info]----------------"
			echo ""
			echo "\"If you have a quick question for me, just ask.\""
			echo "\"What do you want to know about me?\""
			echo ""
			echo -e "-v, --version\t\t\t\t: \"My Version\""
			echo -e "-sv, --support-version\t\t\t: \"My Support Version for each langauge\""
			echo -e "-cv, --code-version\t\t\t: \"The Compile/Interpreter Version\""
			echo -e "-tv, --temp-version\t\t\t: \"The Code Template Version\""
			echo -e "-rv, --repo-version\t\t\t: \"The ${repoTool} Version\""
			echo -e "-c, --config\t\t\t\t: \"Read my configuration\""
			echo -e "-ll, --languages\t\t\t: \"List the languages I know\""
			echo -e "--type <args>\t\t\t\t: \"Show Language Info\""
			echo -e "-h, --help\t\t\t\t: \"Get to know me better\""
			echo ""
			echo "\"I hope this helps\""
			echo "-----------------------------------------------"
			echo ""
			;;
		function)
			case ${example} in
				-n|--new)
					NewCliHelp
					;;
				--edit)
					EditCliHelp
					;;
				--cpl|--compile)
					cplCliHelp ${example}
					;;
				--cpl-run|--car|--cat|--cpl-time)
					cplAndRunCliHelp ${example}
					;;
				--notes)
					CliNotes
					;;
				--read)
					ReadCliHelp
					;;
				--path|--find)
					PathCliHelp ${example}
					;;
				-x|--run|--time)
					RunCliHelp ${example}
					;;
				--rm|--rm-bin|--rm-src)
					RmCliHelp ${example}
					;;
				--install)
					InstallCliHelp ${example}
					;;
				--debug)
					debuggerHelp
					;;
				--list|--ls|--src|--list-cpl|--lscpl|--bin)
					listHelp ${example}
					;;
				-p|--project)
					ProjectCliHelp ${example}
					;;
				*)
					echo ""
					echo "----------------[(${Head}) Functions]----------------"
					echo ""
					echo "\"Don't want to chat long? Want me to perform a simple task?\""
					echo "\"Want to include me in a shell script?\""
					echo "\"I can perform normal tasks quickly.\""
					echo "\"Here is how I can help\""
					echo ""
					echo -e "\t[Without a session]"
					echo "$ clide <args>"
					echo -e "\t--new <args>\t\t\t\t\t: \"New source code\""
					echo -e "\t--edit <args>\t\t\t\t\t: \"Edit source code\""
					echo -e "\t--edit --config\t\t\t\t\t: \"Edit ${Head} config\""
					echo -e "\t--edit --lang <language>\t\t\t: \"Edit the ${Head} langauge support file\""
					echo -e "\t--cpl, --compile <args>\t\t\t\t: \"Compile source code\""
					echo -e "\t\t--args <compile args>\t\t\t: \"Compile with one-time-use args\""
					echo -e "\t\t--get-args\t\t\t\t: \"Get the compile args\""
					echo -e "\t--cpl-run, --car <args>\t\t\t\t: \"Compile and run source code\""
					echo -e "\t--cpl-time, --cat <args>\t\t\t: \"Compile and time source code\""
					echo -e "\t--install <args>\t\t\t\t: \"install program (.bash_aliases)\""
					echo -e "\t--debug <args>\t\t\t\t\t: \"Debug compiled code\""
					echo -e "\t--run <args>\t\t\t\t\t: \"Run compiled code\""
					echo -e "\t-x <args>\t\t\t\t\t: \"Run compiled code\""
					echo -e "\t--rm <args>\t\t\t\t\t: \"Remove binary and source code\""
					echo -e "\t--rm-bin <args>\t\t\t\t\t: \"Remove binary code\""
					echo -e "\t--rm-src <args>\t\t\t\t\t: \"Remove source code\""
					echo -e "\t--time <args>\t\t\t\t\t: \"Run and time compiled code\""
					echo -e "\t--notes <args>\t\t\t\t\t: \"Manage the notes for a given language\""
					echo -e "\t--read <args>\t\t\t\t\t: \"Read out (cat) source code\""
					echo -e "\t--list <lang>\t\t\t\t\t: \"List source code\""
					echo -e "\t--list-cpl <lang>\t\t\t\t: \"List compiled code\""
					echo -e "\t--lscpl <lang>\t\t\t\t\t: \"List compiled code\""
					echo -e "\t--find <args>\t\t\t\t\t: \"Find the souce code\""
					echo -e "\t--path <args>\t\t\t\t\t: \"Find the souce code\""
					echo -e "\t-p, --project <args>\t\t\t\t: \"List or Load Clide Projects\""
					echo -e "\t-l, --last, --load, --session <name>\t\t: \"Lets start back where we left; that is if you saved it\""
					echo ""
					echo "\"Still want a session?\""
					echo "\"Want me to setup your session before entering one?\""
					echo "\"I can pre-setup an action before providing you with a session\""
					echo ""
					echo -e "\t[With a session]"
					echo -e "$ clide <language> --new <code>\t\t\t\t: \"New source code\""
					echo -e "$ clide <language> --new <code>,<code>\t\t\t: \"New source code\""
					echo ""
					echo -e "\"Need more information? Just ask!\""
					echo ""
					if [ ! -z "${example}" ]; then
						cmd="clide ${calledBy} ${example} "
					else
						cmd="clide ${calledBy} function "
					fi
					case ${calledBy} in
						--help)
							echo -e "${cmd}<function>\t\t\t: \"Learn more about a given function\""
							;;
						-h)
							echo -e "${cmd}<function>\t\t\t: \"Learn more about a given function\""
							;;
						*)
							;;
					esac
					echo ""
					echo "-----------------------------------------------"
					echo ""
					;;
			esac
			;;
		usage)
			echo ""
			echo "----------------[(${Head}) Usage]----------------"
			echo ""
			echo "\"Ready to work? Lets get started!\""
			echo ""
			echo "\"Lets start with a language; just tell me what we are using.\""
			echo "\"Say you're using Java\""
			echo "$ clide Java"
			echo ""
			echo "\"If you want to save time, you can pre-select the code\""
			echo "$ clide Java MyCode"
			echo ""
			echo "$ clide Java MyCode,MyOtherCode"
			echo ""
			echo "\"I can determine the langauge by providing the extention of your source code\""
			echo "$ clide MyCode.java"
			echo ""
			echo "$ clide MyCode.java,MyOtherCode.java"
			echo ""
			echo "\"You want something done quickly?\""
			echo "\"Provide me with the action as well as the language and/or source code\""
			echo "[\"Learn more by asking or help regarding my 'function'\"]"
			echo "$ clide <Action> <Language> <Code> <Args>"
			echo "or"
			echo "$ clide <Action> <Code> <Args>"
			echo ""
			echo "\"Don't have anything in mind? Give me a call.\""
			echo "$ clide"
			echo ""
			echo "\"Happy Programming!\""
			echo "-----------------------------------------------"
			echo ""
			;;
		*)
			echo ""
			echo "----------------[(${Head}) Help]----------------"
			echo "\"Hello ${USER}!\""
			echo ""
			echo "\"My name is clide; I am here to help with all your programming needs.\""
			echo "\"Lets get to know each other.\""
			echo "\"To start, ask me the following:\""
			echo ""
			echo -e "${cmd} info\t\t\t: \"Get to know some information about me\""
			echo -e "${cmd} function\t\t\t: \"Ask me to perform a quick task\""
			echo -e "${cmd} usage\t\t\t: \"How we can start programming\""
			echo "-----------------------------------------------"
			echo ""
			;;
	esac
}

CliNotes()
{
	local cli="--notes"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) \"Notes\" Help]----------------"
	echo "${cmd} <args> <lang>"
	echo -e "\t\t--edit \t\t\t: \"edit notes\""
	echo -e "\t\t--add \t\t\t: \"edit notes\""
	echo -e "\t\t--read \t\t\t: \"read notes\""
	echo "----------------------------------------------------------"
	echo ""
}


NewCliHelp()
{
	local cli="--new"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "Create new code without having a ${Head} session"
	echo ""
	echo -e "${cmd} <language> <code> {arguments}"
	echo -e "${cmd} <code> {arguments}"
	echo -e "${cmd} <language> <code> {arguments}"
	echo ""
	echo -e "Create new code, using a created code template, without having a ${Head} session"
	echo -e "${cmd} <language> -c {arguments}"
	echo -e "${cmd} <language> --custom {arguments}"
	echo ""
	echo -e "Pre-create new code AND start a ${Head} session"
	echo ""
	echo -e "$ clide <language> ${cli} <code> {arguments}"
	echo "-----------------------------------------------"
	echo ""
}

PathCliHelp()
{
	local cli="--path"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "Get the path of your source code without having a ${Head} session"
	echo ""
	echo -e "${cmd} <language> <code>\t\t\t: \"display the path of your source code\""
	echo -e "${cmd} <code>\t\t\t\t\t: \"lists language and source code\""
	echo -e "\t\t<code>.<ext>\t\t\t\t: \"displays the path of your source code"
	echo -e "${cmd} -h, --help\t\t\t\t: \"help page\""
	echo "-----------------------------------------------"
	echo ""
}

TypeCliHelp()
{
	local cli="$1"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "Get the type of programming language"
	echo ""
	echo -e "${cmd} <language> <arg>\t\t: \"get info about a give langauge\""
	echo -e "${cmd} all <arg>\t\t\t: \"get info about ALL langauges\""
	echo -e "\t\t\tclassified\t: \"Get the type of Language\""
	echo -e "\t\t\texecutable\t: \"Get the executable of Language\""
	echo -e "\t\t\truntime\t\t: \"Get how the code is run\""
	echo -e "${cmd} -h, --help\t\t: \"help page\""
	echo "-----------------------------------------------"
	echo ""
}

RunCliHelp()
{
	local cli="$1"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "Run your compiled code without having a ${Head} session"
	echo ""
	echo -e "${cmd} <language> <code> {arguments}"
	echo -e "${cmd} <language>,<language>,<language> <code> {arguments}\t: \"Run same programs in different langaugaes\""
	echo -e "${cmd} <code>,<code>,<code> {arguments}\t\t\t\t: \"Run multiple programs\""
	echo -e "${cmd} -h, --help\t\t\t\t\t\t: \"help page\""
	echo "-----------------------------------------------"
	echo ""
}

RmCliHelp()
{
	local cli="$1"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	case ${cli} in
		--rm)
			echo -e "Remove your source and compiled code without having a ${Head} session"
			;;
		--rm-src)
			echo -e "Remove your source code without having a ${Head} session"
			;;
		--rm-bin)
			echo -e "Remove your compiled code without having a ${Head} session"
			;;
		*)
			;;
	esac
	echo ""
	echo -e "${cmd} <language> <code>"
	echo -e "${cmd} <code>"
	echo -e "${cmd} -h, --help\t\t\t: \"help page\""
	echo "-----------------------------------------------"
	echo ""
}

ReadCliHelp()
{
	local cli="--read"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "Read your compiled code without having a ${Head} session"
	echo ""
	echo -e "${cmd} <language> <code>"
	echo -e "${cmd} <code> {arguments}"
	echo -e "${cmd} -h, --help\t\t\t: \"help page\""
	echo "-----------------------------------------------"
	echo ""
}

cplCliHelp()
{
	local cli="$1"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "\"Compile your code without having a session\""
	echo ""
	echo -e "${cmd} <language> <code> <args>"
	echo -e "${cmd} <code> <args>"
	echo -e "${cmd} --<type> <language> <code> <args>\t: \"compile language specific binary\""
	echo -e "${cmd} --<type> <code> <args>\t\t: \"compile language specific binary\""
	echo -e "${cmd} -h, --help\t\t\t: \"help page\""
	echo "-----------------------------------------------"
	echo ""
}

cplAndRunCliHelp()
{
	local cli="$1"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "\"Compile and run your code without having a session\""
	echo ""
	echo -e "${cmd} <language> <code> <run_args>\t\t\t\t\t: \"compile and run executable\""
	echo -e "${cmd} <code> <run_args>\t\t\t\t\t\t\t: \"compile and run executable\""
	echo -e "${cmd} --<type> <language> <code> <run_args>\t\t\t\t: \"compile, a compile type, and run executable\""
	echo -e "${cmd} --<type> <code> <run_args>\t\t\t\t\t: \"compile, a compile type, and run executable\""
	echo -e "${cmd} --<type> <cpl_args> <language> <code> <run_args>\t\t\t: \"compile, a compile type, provide compile args, and run executable\""
	echo -e "${cmd} --<type> <cpl_args> <code> <run_args>\t\t\t\t: \"compile, a compile type, provide compile args, and run executable\""
	echo -e "${cmd} --<type> --args <cpl_args> <language> <code> <run_args>\t\t: \"compile, a compile type, provide compile args, and run executable\""
	echo -e "${cmd} --<type> --args <cpl_args> <code> <run_args>\t\t\t: \"compile, a compile type, provide compile args, and run executable\""
	echo -e "${cmd} --args <cpl_args> <language> <code> <run_args>\t\t\t: \"compile, provide compile arges WITHOUT compile type, and run executable\""
	echo -e "${cmd} --args <cpl_args> <code> <run_args>\t\t\t\t: \"compile, provide compile arges WITHOUT compile type, and run executable\""
	echo -e "${cmd} <cpl_args> <language> <code> <run_args>\t\t\t\t: \"compile, provide compile arges WITHOUT compile type, and run executable\""
	echo -e "${cmd} <cpl_args> <code> <run_args>\t\t\t\t\t: \"compile, provide compile arges WITHOUT compile type, and run executable\""
	echo ""
	echo -e "${cmd} -h, --help\t\t\t\t\t\t\t: \"help page\""
	echo "-----------------------------------------------"
	echo ""
}

InstallCliHelp()
{
	local cli="--install"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "\"Add your code to your ~/.bash_aliases without having a session\""
	echo -e "\"code MUST be compiled\""
	echo ""
	echo -e "${cmd} <language> <code>"
	echo -e "${cmd} <code>"
	echo -e "${cmd} -h, --help\t\t: \"help p2age\""
	echo "-----------------------------------------------"
	echo ""
}

EditCliHelp()
{
	local cli="--edit"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "\"Edit your code without having a session\""
	echo ""
	echo -e "${cmd} --config <force>\t\t\t\t: \"Edit the ${Head} config file\""
	echo -e "\t\t\ty, yes, -y, --yes\t\t: \"Force edit\""
	echo -e "${cmd} --lang <language> <force>\t\t: \"Edit the ${Head} langauge support file\""
	echo -e "\t\t\t\ty, yes, -y, --yes\t: \"Force edit\""
	echo -e "${cmd} <language> <code>\t\t\t: \"Edit the source code by identifying langauge and source code\""
	echo -e "${cmd} <code>\t\t\t\t\t: \"Edit source code by providing source code and extension\""
	echo -e "${cmd} -h, --help\t\t\t\t: \"help page\""
	echo "-----------------------------------------------"
	echo ""
}

listHelp()
{
	local cli="$1"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	case ${cli} in
		--list|--ls|--src)
			echo -e "\"List your source code without having a session\""
			echo ""
			echo -e "${cmd} <language>"
			echo -e "${cmd} -h, --help\t\t: \"help page\""
			echo "-----------------------------------------------"
			echo ""
			;;
		--list-cpl|--lscpl|--bin)
			echo -e "\"List your compiled code without having a session\""
			echo ""
			echo -e "${cmd} <language>"
			echo -e "${cmd} -h, --help\t\t: \"help page\""
			echo "-----------------------------------------------"
			echo ""
			;;
		*)
			;;
	esac
}

ProjectCliHelp()
{
	local cli="$1"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "\t\"Handle loading Projects\""
	echo ""
	echo -e "${cmd} --info\t\t\t\t: \"List ${Head} Project's info\""
	echo -e "${cmd} --info <project>\t\t\t: \"List ${Head} Project's info\""
	echo -e "${cmd} --files <project>\t\t\t: \"List the contents of a project's files\""
	echo -e "${cmd} --list\t\t\t\t: \"List ${Head} Projects\""
	echo -e "${cmd} --list <project>\t\t\t: \"List the contents of a given project\""
	echo -e "${cmd} --list --info\t\t\t\t: \"List ${Head} Project's info\""
	echo -e "${cmd} --list --info <project>\t\t: \"List ${Head} Project's info\""
	echo -e "${cmd} --link <lang> <project>\t\t: \"Link a language to a given project\""
	echo -e "${cmd} --link --list <project>\t\t: \"List the linked languages in a given project\""
	echo -e "${cmd} --langs <project>\t\t\t: \"List the langes associated a given project\""
	echo -e "${cmd} --new <language> <project> <type>\t: \"Create a new project using the given language\""
	echo -e "${cmd} --edit <project> <src>\t\t: \"Run compiled project\""
	echo -e "${cmd} --edit <language> <project> <src>\t: \"Run compoled code from given langauge inside project\""
	echo -e "${cmd} --run <project>\t\t\t: \"Run compiled project\""
	echo -e "${cmd} --run <language> <project>\t\t: \"Run compoled code from given langauge inside project\""
	echo -e "${cmd} -x <project>\t\t\t\t: \"Run compiled project\""
	echo -e "${cmd} -x <language> <project>\t\t: \"Run compiled code from given langauge inside project\""
	echo -e "${cmd} --time <project>\t\t\t: \"Run and time compiled project\""
	echo -e "${cmd} --time <language> <project>\t\t: \"Run and time compoled code from given langauge inside project\""
	echo -e "${cmd} --build <project>\t\t\t: \"Build a ${Head} Project\""
	echo -e "${cmd} --remove <project>\t\t\t: \"Remove a ${Head} Project\""
	echo -e "${cmd} --remove all\t\t\t\t: \"Remove ALL ${Head} Projects\""
	echo -e "${cmd} -r <project>\t\t\t\t: \"Remove a ${Head} Project\""
	echo -e "${cmd} -r all\t\t\t\t: \"Remove ALL ${Head} Projects\""
	echo -e "${cmd} --make <project> <action>\t\t: \"For C/C++ Projects, handle make files\""
	echo -e "${cmd} --export <project>\t\t\t: \"package a ${Head} Project into a <project>.tar.gz\""
	echo -e "${cmd} --import <lang> <project>\t\t: \"install a ${Head} Project <project>.tar.gz file (if <project>.clide is not present)\""
	echo -e "${cmd} --import <project>\t\t\t: \"install a ${Head} Project <project>.tar.gz file\""
	echo -e "${cmd} --discover\t\t\t\t: \"Discover ${Head} Projects\""
	echo -e "${cmd} -h, --help\t\t\t\t: \"help page\""
	echo ""
	echo -e "\t\"These arguments could be as follows\""
	echo -e "$ clide ${cli} <project> <action> <type>"
	echo ""
	echo -e "\t\"Alternativly, a ${Head} session can held after performing a given action\""
	echo ""
	echo -e "$ clide <language> ${cli} --new <project> <type>\t: \"Create, Select and Load project\""
	case ${cli} in
		-p)
			echo -e "$ clide <language> ${cli} --import <project>\t: \"Import, Select and Load project\""
			;;
		--project)
			echo -e "$ clide <language> ${cli} --import <project>\t\t: \"Import, Select and Load project\""
			;;
		*)
			;;
	esac
	echo ""
	echo -e "\t\"Default project Functionality\""
	echo ""
	echo "\"Select and Load ${Head} project\""
	echo "${cmd} <project>"
	echo "${cmd} <language> <project>"
	echo ""
	echo "\"Select ${Head} project and Load into a <mode> shell\""
	echo "${cmd} <project> --mode <mode> <mode arg>"
	echo "${cmd} <language> <project> --mode <mode> <mode arg>"
	echo "-----------------------------------------------"
	echo ""
}

RepoHelp()
{
	local Selection=$1
	case ${repoTool} in
		git)
			case ${Selection} in
				branch|branches)
					echo "help"
					echo "new"
					echo "remove, delete"
					echo "select, checkout"
					;;
				*)
					echo ""
					echo "------------------[GIT Help]------------------"
					echo ""
					echo -e "ActiveBranch\t\t\t\t: \"get active branch\""
					echo -e "new, init\t\t\t\t: \"create a new repo\""
					echo -e "ignore <files>\t\t\t\t: \"manage files git will ignore\""
					echo -e "setup, clone <url>\t\t\t: \"clone a local copy from an existing repo\""
					echo -e "add <files>\t\t\t\t: \"add files to active branch\""
					echo -e "message, commit <message>\t\t: \"get active branch\""
					echo -e "branch, branches <args>\t\t\t: \"Handle branches\""
					echo -e "\tnew <branch>\t\t\t: \"Create a new branch\""
					echo -e "\tremove, delete <branch>\t\t: \"Delete a local branch\""
					echo -e "\tselect, checkout <branch>\t: \"Select a branch to become active\""
					echo -e "remove, delete <branch>\t\t\t: \"Delete a local branch\""
					echo -e "select, checkout <branch>\t\t: \"Select a branch to become active\""
					echo -e "upload, push\t\t\t\t: \"push your committed code to repo\""
					echo -e "download, pull\t\t\t\t: \"pull and update your active branch\""
					echo -e "state, status\t\t\t\t: \"check for the list of changed files\""
					echo -e "slamdunk yes <message>\t\t\t: \"perform an 'add', 'commit', and 'push' in one keystroke\""
					echo -e "help\t\t\t\t\t: \"get active branch\""
					echo -e "version\t\t\t\t\t: \"get active branch\""
					echo "--------------------------------------------"
					echo ""
					;;
			esac
			;;
		svn)
			echo "SVN Help"
			;;
		*)
			;;
	esac
}

BuildCliHelp()
{
	local cli="$1 --build"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "\"Compile your project without having a session\""
	echo ""
	echo -e "${cmd} <project>\t\t: \"Select and Build your Project\""
	echo -e "${cmd} -h, --help\t\t: \"help page\""
	echo "-----------------------------------------------"
	echo ""
}

ModesHelp()
{
	local CalledBy=$1
	case ${CalledBy} in
		add.sh)
			shift
			local Lang=$1
			shift
			local component=( $@ )
			case ${component[0],,} in
				shortcut)
					case ${component[1],,} in
						create)
							echo "${component[1]}"
							echo -e "\tclide\t\t\t:\"Create a clide.desktop\""
							echo -e "\tproject, app <app>\t\t:\"Create an <app>.desktop\""
							;;
						*)
							echo "Component: shortcut"
							echo -e "create <shortcut>\t\t:\"Create an application shortcut\""
							echo -e "\tclide\t\t\t:\"Create a clide.desktop\""
							echo -e "\tapp <app> \t\t:\"Create an <app>.desktop\""
							echo -e "correct <app>\t\t\t:\"Adjust existing application shortcut\""
							;;
					esac
					echo ""
					echo -e "done\t\t\t\t: \"done with adding component\""
					echo -e "exit, close\t\t\t: \"close mode\""
					;;
				project)
					echo "Component: Project"
					echo -e "create <project>\t\t:\"Create a brand new project template\""
					echo -e "import\t\t\t\t:\"import a new project type (Lang.${Lang}.<type> FILE MUST EXIST)\""
					echo -e "correct\t\t\t\t:\"Adjust existing project tempalte\""
					echo ""
					echo -e "done\t\t\t\t: \"done with adding component\""
					echo -e "exit, close\t\t\t: \"close mode\""
					;;
				language)
					echo "Component: Language Support"
					echo -e "create <new language>\t\t:\"Create support for another language\""
					echo -e "import\t\t\t\t:\"import new language to support (Lang.<type> FILE MUST EXIST)\""
#					echo -e "change <lang> {run|cpl} <val>\t\t:\"Change the compiler/interpretor\""
#					echo -e "change {run|cpl} <val>\t\t\t:\"Change the compiler/interpretor\""
					echo -e "correct\t\t\t\t:\"Adjust existing support for Langauge\""
					echo ""
					echo -e "done\t\t\t\t: \"done with adding component\""
					echo -e "exit, close\t\t\t: \"close mode\""
					;;
				*)
					echo "Help options"
					echo -e "set <cmp>\t\t\t: \"select component to add\""
					echo -e "\tshortcut\t\t: \"Create shortcut for cl[ide]\""
					echo -e "\tproject\t\t\t: \"select the 'project' component\""
					echo -e "\tsupport, language\t: \"select the 'language' component\""
					echo -e "using\t\t\t\t: \"List the content used in cl[ide]\""
					echo ""
					echo -e "exit, close\t\t\t: \"close mode\""
					;;
			esac
			;;
		*)
			echo ""
			echo "----------------[(${Head}) Modes]----------------"
			echo -e "${repoTool}, repo\t\t: repo management"
			echo -e "add <component>\t\t: install/add component management"
			echo -e "pkg\t\t\t: Use distro package manager"
			echo -e "-h, --help\t\t: \"Modes help page\""
			echo "-----------------------------------------------"
			echo ""
			;;
	esac
}

ModeHandler()
{
	local Mode=$1
	local Lang=$2
	local cLang=$3
	local Code=$4
	local cCode=$5
	local Arg=$6
	case ${Mode} in
		${repoTool}|repo)
			#Use ONLY for Projects
			if [[ ! "${CodeProject}" == "none" ]]; then
				${ModesDir}/repo.sh ${repoTool} ${CodeProject} ${repoAssist}
			else
				echo "Must have an active project"
			fi
			;;
		add)
			${ModesDir}/add.sh ${Head} "${LibDir}" "${LangsDir}" "${ClideProjectDir}" ${Lang} ${cLang} ${Code} ${cCode} ${Arg}
			;;
		-h|--help)
			ModesHelp
			;;
		*)
			ModesHelp
			;;
	esac
}

main()
{
	local Call=$1
	shift
	case ${Call} in
		MenuHelp|makeHelp|makeCliHelp|NotesHelp)
			${Call} $@
			;;
		debuggerHelp|newCodeHelp|InstallCliHelp)
			${Call} $@
			;;
		CliHelp|TypeCliHelp|RunCliHelp|cplCliHelp|EditCliHelp)
			${Call} $@
			;;
		CliNotes|PathCliHelp)
			${Call} $@
			;;
		ProjectCliHelp|PackageHelp|BuildCliHelp)
			${Call} $@
			;;
		ModesHelp|ModeHandler|RepoHelp)
			${Call} $@
			;;
		*)
			;;
	esac
}

echo -en "${Start}"
main $@
echo -e "${End}"
