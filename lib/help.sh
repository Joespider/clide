Shell=$(which bash)
#!${Shell}

Head=$1
LangsDir=$2
RunCplArgs=$3
shift
shift
shift

#Select Languge
ManageLangs()
{
	local TheLang=$1
	local Langs=${LangsDir}/Lang.${TheLang^}
	local PassedVars=( "${RunCplArgs}" )
	#Make first letter uppercase
	shift
	local Manage=$@
	if [ -f ${Langs} ]; then
		${Langs} ${PassedVars[@]} ${Manage[@]}
#	else
#		UseOther ${TheLang} ${Manage[@]}
	fi
}

#Clide menu help page
MenuHelp()
{
	local Lang=$1
	local project=$2
	case ${Lang} in
		no-lang)
			echo ""
			echo "----------------[(${Lang}) Menu]----------------"
			echo -e "edit config\t\t\t: \"edit ${Head} config\""
			echo -e "version\t\t\t\t: \"Get ${Head} Version\""
			echo -e "cv, code-version\t\t: \"Get compile/interpreter version of supported languages\""
			echo -e "sv, support-version\t\t: \"#Get compile/interpreter version of supported languages\""
			echo -e "tv, temp-version\t\t: \"Get version of templates\""
			echo -e "rv, repo-version\t\t: \"Get version control version\""
			echo -e "use <language> <code>\t\t: \"choose language\""
			echo -e "<language> <code>\t\t: \"choose language\""
			echo "------------------------------------------------"
			echo ""
			;;
		*)
			echo ""
			echo "----------------[(${Head}) Menu]----------------"
			echo -e "ls\t\t\t\t: \"list progams\""
			echo -e "lscpl\t\t\t\t: \"list compiled progams\""
			echo -e "using\t\t\t\t: \"get the language being used\""
			echo -e "unset\t\t\t\t: \"deselect source code\""
			echo -e "use <language> <code>\t\t: \"choose language\""
			echo -e "using\t\t\t\t: \"Display what language is being used\""
			echo -e "save\t\t\t\t: \"Save session\""
			echo -e "create <arg>\t\t\t: \"create compile and runtime arguments"
			echo -e "\thelp\t\t\t: \"create help page"
			echo -e "${Debugger}, Debugger, debug\t\t: \"debug your program\""
			echo ""
			ManageLangs ${Lang} "MenuHelp"
			echo -e "car, car-a\t\t\t: \"compile and run; compile and run with arguments\""
			echo -e "rm, remove, delete\t\t: \"delete src file\""
			echo -e "set <file>\t\t\t: \"select source code\""
			echo -e "add <file>\t\t\t: \"add new file to project\""
			echo -e "notes <action>\t\t\t: \"make notes for the ${Lang} language\""
			echo -e "${editor}, edit, ed\t\t\t: \"edit source code\""
			echo -e "${ReadBy}, read\t\t\t: \"Read source code\""
			echo -e "search <find>\t\t\t: \"search for code in project\""
			case ${project} in
				none)
					echo -e "project <action> \t\t: \"handle projects\""
					echo -e "\tnew\t\t\t: \"create a new project\""
					echo -e "\tlist\t\t\t: \"list all your projects\""
					echo -e "\tload\t\t\t: \"load and existing projects\""
					;;
				*)
					echo -e "project <action> \t\t: \"handle projects\""
					echo -e "\tnew\t\t\t: \"create a new project\""
					echo -e "\ttype\t\t\t: \"display the type of project\""
					echo -e "\ttitle\t\t\t: \"give your project a title\""
					echo -e "\tupdate\t\t\t: \"update your existing project\""
					echo -e "\tlist\t\t\t: \"list all your projects\""
					echo -e "\tload\t\t\t: \"load and existing projects\""
					echo -e "\tlink <lang>\t\t: \"Link a language to an active project\""
					echo -e "\t\t--list, list\t: \"list the linked languages in an active project\""
					echo -e "\tswap <lang>\t\t: \"swap to a language in an active project\""
					echo -e "\t\t--list, list\t: \"list the linked languages in an active project\""
					echo -e "\tdiscover\t\t: \"update the list of projects\""
					echo -e "${repoTool}, repo\t\t\t: \"handle repos\""
					;;
			esac
			echo -e "search\t\t\t\t: \"search project src files for line of code\""
			echo -e "execute, exe, run <option>\t: \"run active program\""
			echo -e "\t\t-a, --args\t: \"run program with cli arguments\""
			echo -e "\t\t-d, --debug\t: \"run program in debug mode\""
			echo -e "bkup, backup\t\t\t: \"make backup of existing source code\""
			echo -e "restore\t\t\t\t: \"make backup of existing source code\""
			echo -e "rename <new>\t\t\t: \"rename the existing source code\""
			echo -e "src, source\t\t\t: \"list source code\""
			echo -e "copy <new>\t\t\t: \"copy the existing source code\""
			echo -e "last, load\t\t\t: \"Load last session\""
			echo -e "exit, close\t\t\t: \"close ide\""
			echo "------------------------------------------------"
			echo ""
			;;
	esac
}

CreateHelp()
{
	local Lang=$1
	local Action=$2
	case ${Action} in
		cpl|cpl-args)
			ManageLangs ${Lang} "setCplArgs-help"
			;;
		*)
			echo ""
			echo "----------------[(${Head}) \"Create\" Help]----------------"
			echo -e "args\t\t\t: create custom args"
			echo -e "cpl, cpl-args\t\t: create compiler args"
			echo -e "newCodeTemp <type>\t: make your own source code ($ new <code>)"
			echo -e "\tcustom\t\t: Create template"
			echo -e "\tdefault\t\t: Use the tempalte from ${Head}"
			ManageLangs ${Lang} "CreateHelp"
			echo -e "reset\t\t\t: clear all"
			echo "---------------------------------------------------------"
			echo ""
			;;
	esac
}

ProjectHelp()
{
	echo ""
	echo "----------------[(${Head}) \"Project\" Help]----------------"
	echo -e "Purpose: \"handle projects\""
	echo -e "new <project>\t\t\t: \"Create a new project\""
	echo -e "import <project> <path>\t\t: \"Import projects\""
	echo -e "update\t\t\t\t: \"Update the active project\""
	echo -e "load <project>\t\t\t: \"Choose a project to make active\""
	echo -e "type\t\t\t\t: \"display the type of project\""
	echo -e "\tlist\t\t\t: \"Show list of possible project types\""
	echo -e "list\t\t\t\t: \"List ALL projects\""
	echo -e "link <lang>\t\t\t: \"Link a language to an active project\""
	echo -e "\t--list, list\t\t: \"list the linked languages in an active project\""
	echo -e "swap <lang>\t\t\t: \"swap to a language in an active project\""
	echo -e "\t--list, list\t\t: \"list the linked languages in an active project\""
	echo -e "active\t\t\t\t: \"Display the name of the current project\""
	echo -e "types\t\t\t\t: \"Display the types of projects under ${Lang}\""
	echo -e "discover\t\t\t: \"Discover project on system (creates project profile)"
	ManageLangs ${Lang} "ProjectHelp"
	echo "----------------------------------------------------------"
	echo ""
}

NotesHelp()
{
	local Lang=$1
	echo ""
	echo "----------------[(${Head}) \"Notes\" Help]----------------"
	echo -e "edit, add\t: \"edit notes\""
	echo -e "read\t\t: \"read notes\""
	echo "----------------------------------------------------------"
	echo ""

}

newCodeHelp()
{
	local Lang=$1
	echo ""
	echo "----------------[(${Head}) \"new\" Help]----------------"
	echo -e "-v, --version\t\t\t: \"Get Version for each code template\""
	echo -e "-h, --help\t\t\t: \"This page\""
	ManageLangs ${Lang} "newCodeHelp"
	echo -e "<code>\t\t\t\t: \"provide code name; default settings\""
	echo "----------------------------------------------------------"
	echo ""
}

#Clide cli help page
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
			echo -e "-v, --version\t\t\t: \"My Version\""
			echo -e "-sv, --support-version\t\t: \"My Support Version for each langauge\""
			echo -e "-cv, --code-version\t\t: \"The Compile/Interpreter Version\""
			echo -e "-tv, --temp-version\t\t: \"The Code Template Version\""
			echo -e "-rv, --repo-version\t\t: \"The ${repoTool} Version\""
			echo -e "-c, --config\t\t\t: \"Read my configuration\""
			echo -e "-ll, --languages\t\t: \"List the languages I know\""
			echo -e "-h, --help\t\t\t: \"Get to know me better\""
			echo -e "-l, --last, --load\t\t: \"Lets start back where we left; that is if you saved it\""
			echo ""
			echo "\"I hope this helps\""
			echo "-----------------------------------------------"
			echo ""
			;;
		function)
			case ${example} in
				--new)
					NewHelp
					;;
				--edit)
					EditHelp
					;;
				--cpl|--compile)
					cplHelp
					;;
				--run)
					RunHelp
					;;
				--install)
					installHelp
					;;
				--read)
					RunHelp
					;;
				--list|--list-cpl)
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
					echo -e "--new <args>\t\t\t: \"New source code\""
					echo -e "--edit <args>\t\t\t: \"Edit source code\""
					echo -e "--edit --config\t\t\t: \"Edit ${Head} config\""
					echo -e "--cpl, --compile <args>\t\t: \"Compile source code\""
					echo -e "--install <args>\t\t: \"install program (.bash_aliases)\""
					echo -e "--debug <args>\t\t\t: \"Debug compiled code\""
					echo -e "--run <args>\t\t\t: \"Run compiled code\""
					echo -e "--read <args>\t\t\t: \"Read out (cat) source code\""
					echo -e "--list <lang>\t\t\t: \"List source code\""
					echo -e "--list-cpl <lang>\t\t: \"List compiled code\""
					echo -e "-p, --project <args>\t\t\t: \"List or Load Clide Projects\""
					echo ""
					echo -e "\"Need more information? Just ask!\""
					echo ""
					cmd="clide ${calledBy} ${example}"
					echo -e "${cmd}--edit\t\t: \"Get more information about editing files\""
					echo -e "${cmd}--cpl\t\t: \"Learn how to do quick compiles\""
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
			echo "\"I can determine the langauge by providing the extention of your source code\""
			echo "$ clide MyCode.java"
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
			echo -e "${cmd} info\t\t: \"Get to know some information about me\""
			echo -e "${cmd} function\t\t: \"Ask me to perform a quick task\""
			echo -e "${cmd} usage\t\t: \"How we can start programming\""
			echo "-----------------------------------------------"
			echo ""
			;;
	esac
}

NewHelp()
{
	local cli="--new"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "Run your compiled code without having a ${Head} session"
	echo ""
	echo -e "${cmd} <language> <code> {arguments}"
	echo -e "${cmd} <code> {arguments}"
	echo -e "${cmd} -h, --help\t\t\t: \"help page\""
	echo "-----------------------------------------------"
	echo ""
}

RunHelp()
{
	local cli="--run"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "Run your compiled code without having a ${Head} session"
	echo ""
	echo -e "${cmd} <language> <code> {arguments}"
	echo -e "${cmd} <code> {arguments}"
	echo -e "${cmd} -h, --help\t\t\t: \"help page\""
	echo "-----------------------------------------------"
	echo ""
}

ReadHelp()
{
	local cli="--run"
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

cplHelp()
{
	local cli="--cpl"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "\"Compile your code without having a session\""
	echo ""
	echo -e "${cmd} <language> <code>"
	echo -e "${cmd} <code>"
	echo -e "${cmd} -h, --help\t\t: \"help p2age\""
	echo "-----------------------------------------------"
	echo ""
}

installHelp()
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

EditHelp()
{
	local cli="--edit"
	local cmd="\$ clide ${cli}"
	echo ""
	echo "----------------[(${Head}) cli {${cli}}]----------------"
	echo -e "\"Edit your code without having a session\""
	echo ""
	echo -e "${cmd} --config\t\t\t: \"Edit the ${Head} config file\""
	echo -e "${cmd} <language> <code>\t: \"Edit the source code by identifying langauge and source code\""
	echo -e "${cmd} <code>\t\t\t: \"Edit source code by providing source code and extension\""
	echo -e "${cmd} -h, --help\t\t: \"help page\""
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
		--list)
			echo -e "\"List your source code without having a session\""
			echo ""
			echo -e "${cmd} <language>"
			echo -e "${cmd} -h, --help\t\t: \"help page\""
			echo "-----------------------------------------------"
			echo ""
			;;
		--list-cpl)
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
	echo -e "\"Handle loading Projects\""
	echo ""
	echo -e "${cmd} <project>\t: \"Select and Load\""
	echo -e "${cmd} --list\t: \"List ${Head} Projects\""
	echo -e "${cmd} --build\t: \"Build a ${Head} Project\""
	echo -e "${cmd} --discover\t: \"Discover ${Head} Projects\""
	echo -e "${cmd} -h, --help\t: \"help page\""
	echo "-----------------------------------------------"
	echo ""
}

BuildHelp()
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
	echo ""
	echo "----------------[(${Head}) Modes]----------------"
	echo -e "${repoTool}, repo\t\t: repo management"
	echo -e "add <component>\t\t: install/add component management"
	echo -e "-h, --help\t\t: \"Modes help page\""
	echo "-----------------------------------------------"
	echo ""
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
			${ModesDir}/add.sh "${LibDir}" "${LangsDir}" "${ClideProjectDir}" ${Lang} ${cLang} ${Code} ${cCode} ${Arg}

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
		MenuHelp)
			MenuHelp $@
			;;
		CreateHelp)
			CreateHelp $@
			;;
		ProjectHelp)
			ProjectHelp $@
			;;
		NotesHelp)
			NotesHelp $@
			;;
		newCodeHelp)
			newCodeHelp $@
			;;
		installHelp)
			installHelp $@
			;;
		CliHelp)
			CliHelp $@
			;;
		RunHelp)
			RunHelp $@
			;;
		cplHelp)
			cplHelp $@
			;;
		EditHelp)
			EditHelp $@
			;;
		ProjectCliHelp)
			ProjectCliHelp $@
			;;
		BuildHelp)
			BuildHelp $@
			;;
		ModesHelp)
			ModesHelp $@
			;;
		ModeHandler)
			ModeHandler $@
			;;
		*)
			;;
	esac
}

main $@
