Shell=$(which bash)
#!${Shell}

#cl[ide] future features
#{
	#Allow User to input template args
#}

#cl[ide] config
#{
editor=nano
ReadBy=less
Aliases=~/.bash_aliases
repoTool=git
#repoTool=svn

#Repo assist is for simplistic commands
#True = cl[ide] takes care of repo commands
repoAssist="True"
#False = User handles repo commands
#repoAssist="False"
#Repo mangement is neither run by user nor cl[ide]
#repoAssist=

Head="cl[ide]"
IDE=$(echo -e "\e[1;40mide\e[0m")
Name="cl${IDE}"

#Compilers/Interpreters
BashCpl=bash
PythonRun=python
CppCpl=g++
JavaCpl=javac
JavaRun=java

#Version tracking
#Increment by 1 number per category
#1st # = Overflow
#2nd # = Additional features
#3rd # = Bug/code tweaks/fixes
Version="0.56.27"

#root dir
ProgDir=~/Programs
ClideDir=${ProgDir}/.clide

#Program Homes
BashHome=${ProgDir}/Bash
PythonHome=${ProgDir}/Python
CppHome=${ProgDir}/C++
JavaHome=${ProgDir}/Java

#Soruce Code
BashSrc=${BashHome}/src
PythonSrc=${PythonHome}/src
CppSrc=${CppHome}/src
JavaSrc=${JavaHome}/src

#Bin Code
BashBin=${BashHome}/bin
PythonBin=${PythonHome}/bin
CppBin=${CppHome}/bin
JavaBin=${JavaHome}/bin

#Public Vars
#{
Project=""
CodeProject="none"
RunTimeArgs=""
JavaRunProp=""
#}

#}

Art()
{
	echo "                ____                       ____ "
	echo "               |  __|                     |__  |"
	echo "   ___   _     | |  _______   _____    ____  | |"
	echo "  / __| | |    | | |__   __| |  __ \  |  __| | |"
	echo " / /    | |    | |    | |    | |  \ \ | |_   | |"
	echo "| |     | |    | |    | |    | |  | | |  _|  | |"
	echo " \ \__  | |__  | |  __| |__  | |__/ / | |__  | |"
	echo "  \___| |____| | | |_______| |_____/  |____| | |"
	echo "               | |__                       __| |"
	echo "               |____|                     |____|"
}

#Clide menu help page
MenuHelp()
{
	local Lang=$1
	local project=$2
	echo ""
	echo "----------------[(${Head}) Menu]----------------"
	echo "ls: \"list progams\""
	echo "unset: \"deselect source code\""
	echo "use {Bash|Python|C++|Java}: \"choose language\""
	echo "swap|swp {src|bin}: \"swap between sorce code and executable\""
	echo "create <arg> : \"create compile and runtime arguments"
	case ${Lang} in
		Bash|Python)
			echo "new <file>: \"create new ${Lang} script\""
			echo "compile|cpl: \"make code executable\""
			;;
		C++)
			echo "new <file> <type>: \"create new ${Lang} source file\""
			echo "             main: \"create the main ${Lang} file\""
			echo "           header: \"create a ${Lang} header file\""
			echo "        component: \"create a standard ${Lang} file\""
			echo "compile|cpl: \"make code executable\""
			;;
		Java)
			echo "new <file> <type>: \"create new ${Lang} source file\""
			echo "             main: \"create the main ${Lang} file\""
			echo "        component: \"create a standard ${Lang} file\""
			echo "compile|cpl: \"make code (CLASS) executable\""
			echo "compile jar|cpl jar: \"make code (JAR) executable\""
			;;
		*)
			echo "compile|cpl: \"make code executable\""
			;;
	esac
	echo "rm|remove|delete: \"delete src file\""
	echo "set <file>: \"select source code\""
	echo "add <file>: \"add new file to project\""
	echo "${editor}|edit|ed: \"edit source code\""
	echo "${ReadBy}|read: \"Read source code\""
	echo "search <find>: \"search for code in project\""
	case ${project} in
		none)
			echo "project {new|list|load}: \"handle projects\""
			;;
		*)
#			echo "project {new|update|list|load|active}: \"handle projects\""
			echo "project {new|update|list|load}: \"handle projects\""
			echo "${repoTool}|repo: \"handle repos\""
			;;
	esac
	echo "search: \"search project src files for line of code\""
	echo "execute|exe|run: {-a|--args}: \"run active program\""
	echo "last|load: \"Load last session\""
	echo "exit|close: \"close ide\""
	echo "------------------------------------------------"
	echo ""
}

CreateHelp()
{
	local Lang=$1

	echo ""
	echo "----------------[(${Head}) \"Create\" Help]----------------"
	echo "args : create custom args"
	case ${Lang} in
#		Bash|Python)
#			echo "args : create custom args"
#			;;
		C++)
			echo "make : create makefile"
			;;
		Java)
			echo "prop|properties|-D : create custome Java properties"
			;;
		*)
			;;
	esac
	echo "reset : clear all"
	echo "---------------------------------------------------------"
	echo ""
}

ProjectHelp()
{
	echo ""
	echo "----------------[(${Head}) \"Project\" Help]----------------"
	echo "{new|update|load|list|active}: \"handle projects\""
	echo "new <project>: \"Create a new project\""
	echo "update: \"Update the active project\""
	echo "load <project>: \"Choose a project to make active\""
	echo "list: \"List ALL projects\""
	echo "active: \"Display the name of the current project\""
	echo "----------------------------------------------------------"
	echo ""
}

#Clide cli help page
CliHelp()
{
	echo ""
	echo "----------------[(${Head}) CLI]----------------"
	echo "-v |--version: \"Get Clide Version\""
	echo "-cv|--code-version: \"Get Compile/Interpreter Version\""
	echo "-rv|--repo-version: \"Get git/svn Version\""
	echo "-c |--config: \"Get Clide Config\""
	echo "-p |--projects: \"List Clide Projects\""
	echo "-h |--help: \"Get CLI Help Page (Cl[ide] Menu: \"help\") \""
	echo "-l |--last|--load: \"Load last session\""
	echo "-----------------------------------------------"
	echo ""
}

ClideConfig()
{
	if [[ "$USER" == "root" ]]; then
		Replace="\\$HOME\\/"
	else
		Replace="\\/home\\/$USER\\/"
	fi
	With="\~\\/"
	echo "----------------[(${Head}) Config]----------------"
	echo "Editor: \"${editor}\""
	echo "Read By: \"${ReadBy}\""
	Repo=$(which ${repoTool})
	if [ ! -z "${Repo}" ]; then
		echo "Repo By: \"${repoTool}\""
		case ${repoAssist} in
			True)
				echo "${Head} handles the repo commands"
				;;
			False)
				echo "The User is responsible for repo commands"
				;;
			*)
				echo "repo version control has been disabled"
				;;
		esac
	fi
	echo ""
	echo "---[${Head} Compilers/Interpreters]---"
	if [ ! -z "${BashCpl}" ]; then
		echo "Bash: \"${BashCpl}\""
	fi
	if [ ! -z "${PythonRun}" ]; then
		echo "Python: \"${PythonRun}\""
	fi
	if [ ! -z "${CppCpl}" ]; then
		echo "C++: \"${CppCpl}\""
	fi
	if [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
		echo "Java: \"${JavaRun}\"/\"${JavaCpl}\""
	fi
	echo "--------------------------------------"
	echo ""
	echo "---[${Head} FileSystem]---"
	TheProgDir=$(echo ${ProgDir} | sed "s/${Replace}/${With}/g")
	echo "Root: \"${TheProgDir}\""
	TheClideDir=$(echo ${ClideDir} | sed "s/${Replace}/${With}/g")
	echo "Config: \"${TheClideDir}\""
	echo ""
	echo "[Language Directory]"
	if [ ! -z "${BashCpl}" ]; then
		TheBashHome=$(echo ${BashHome} | sed "s/${Replace}/${With}/g")
		echo "Bash: \"${TheBashHome}\""
	fi
	if [ ! -z "${PythonRun}" ]; then
		ThePythonHome=$(echo ${PythonHome} | sed "s/${Replace}/${With}/g")
		echo "Python: \"${ThePythonHome}\""
	fi
	if [ ! -z "${CppCpl}" ]; then
		TheCppHome=$(echo ${CppHome} | sed "s/${Replace}/${With}/g")
		echo "C++: \"${TheCppHome}\""
	fi
	if [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
		TheJavaHome=$(echo ${JavaHome} | sed "s/${Replace}/${With}/g")
		echo "Java: \"${TheJavaHome}\""
	fi
	echo ""
	echo "[Source Directory]"
	if [ ! -z "${BashCpl}" ]; then
		TheBashSrc=$(echo ${BashSrc} | sed "s/${Replace}/${With}/g")
		echo "Bash: \"${TheBashSrc}\""
	fi
	if [ ! -z "${PythonRun}" ]; then
		ThePythonSrc=$(echo ${PythonSrc} | sed "s/${Replace}/${With}/g")
		echo "Python: \"${ThePythonSrc}\""
	fi
	if [ ! -z "${CppCpl}" ]; then
		TheCppSrc=$(echo ${CppSrc} | sed "s/${Replace}/${With}/g")
		echo "C++: \"${TheCppSrc}\""
	fi
	if [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
		TheJavaSrc=$(echo ${JavaSrc} | sed "s/${Replace}/${With}/g")
		echo "Java: \"${TheJavaSrc}\""
	fi
	echo ""
	echo "[Binary Directory]"
	if [ ! -z "${BashCpl}" ]; then
		TheBashBin=$(echo ${BashBin} | sed "s/${Replace}/${With}/g")
		echo "Bash: \"${TheBashBin}\""
	fi
	if [ ! -z "${PythonRun}" ]; then
		ThePythonBin=$(echo ${PythonBin} | sed "s/${Replace}/${With}/g")
		echo "Python: \"${ThePythonBin}\""
	fi
	if [ ! -z "${CppCpl}" ]; then
		TheCppBin=$(echo ${CppBin} | sed "s/${Replace}/${With}/g")
		echo "C++: \"${TheCppBin}\""
	fi
	if [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
		TheJavaBin=$(echo ${JavaBin} | sed "s/${Replace}/${With}/g")
		echo "Java: \"${TheJavaBin}\""
	fi
	echo "--------------------------"
	echo ""
	echo "--------------------------------------------------"
}

EnsureLangs()
{
	#Compilers/Interpreters
#Check for Shell
#{
	CheckForShell=$(which bash)
	if [ -z "${CheckForShell}" ]; then
		CheckForShell=$(which zsh)
		if [ -z "${CheckForShell}" ]; then
			BashCpl=""
		else
			BashCpl=zsh
		fi
	fi
#}
#Check if Python Interpreter present
#{
	CheckForPython2=$(which python)
	CheckForPython3=$(which python3)
	if [ -z "${CheckForPython2}" ] && [[ "${PythonRun}" == "python" ]]; then
		CheckForPython=$(which python3)
		if [ -z "${CheckForPython}" ]; then
			PythonRun=""
		else
			PythonRun=python3
		fi
	elif [ -z "${CheckForPython3}" ] && [[ "${PythonRun}" == "python3" ]]; then
		CheckForPython=$(which python)
		if [ -z "${CheckForPython}" ]; then
			PythonRun=""
		else
			PythonRun=python
		fi
	fi
#}
#Check if C++ Compiler present
#{
	CheckForGpp=$(which g++)
	CheckForClangpp=$(which clang++)
	if [ -z "${CheckForGpp}" ] && [[ "${CppCpl}" == "g++" ]]; then
		CheckForCpp=$(which clang++)
		if [ -z "${CheckForCpp}" ]; then
			CppCpl=""
		else
			CppCpl=clang++
		fi
	elif [ -z "${CheckForClangpp}" ] && [[ "${CppCpl}" == "clang++" ]]; then
		CheckForCpp=$(which g++)
		if [ -z "${CheckForCpp}" ]; then
			CppCpl=""
		else
			CppCpl=g++
		fi
	fi
#}
#Check Java is installed
#{
	CheckForJava=$(which java)
	CheckForJavac=$(which javac)
	if [ -z "${CheckForJava}" ] && [ -z "${CheckForJavac}" ]; then
		JavaCpl=""
		JavaRun=""
	fi
#}
}

EnsureDirs()
{
	#If missing...create "Programs" dir
	if [ ! -d "${ProgDir}" ]; then
		mkdir "${ProgDir}"
	fi
#check for .clide dir
#{
	if [ ! -d "${ClideDir}" ]; then
		mkdir "${ClideDir}"
	fi
#}

#Program Homes
#{
	if [ ! -d "${BashHome}" ] && [ ! -z "${BashCpl}" ]; then
		mkdir "${BashHome}"
	fi
	if [ ! -d "${PythonHome}" ] && [ ! -z "${PythonRun}" ]; then
		mkdir "${PythonHome}"
	fi
	if [ ! -d "${CppHome}" ] && [ ! -z "${CppCpl}" ]; then
		mkdir "${CppHome}"
	fi
	if [ ! -d "${JavaHome}" ] && [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
		mkdir "${JavaHome}"
	fi
#}

#Soruce Code
#{
	if [ ! -d "${BashSrc}" ] && [ ! -z "${BashCpl}" ]; then
		mkdir "${BashSrc}"
	fi
	if [ ! -d "${PythonSrc}" ] && [ ! -z "${PythonRun}" ]; then
		mkdir "${PythonSrc}"
	fi
	if [ ! -d "${CppSrc}" ] && [ ! -z "${CppCpl}" ]; then
		mkdir "${CppSrc}"
	fi
	if [ ! -d "${JavaSrc}" ] && [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
		mkdir "${JavaSrc}"
	fi
#}

#Bin Code
#{
	if [ ! -d "${BashBin}" ] && [ ! -z "${BashCpl}" ]; then
		mkdir "${BashBin}"
	fi
	if [ ! -d "${PythonBin}" ] && [ ! -z "${PythonRun}" ]; then
		mkdir "${PythonBin}"
	fi
	if [ ! -d "${CppBin}" ] && [ ! -z "${CppCpl}" ]; then
		mkdir "${CppBin}"
	fi
	if [ ! -d "${JavaBin}" ] && [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
		mkdir "${JavaBin}"
	fi
#}

}

ClideVersion()
{
	echo ${Version}
}

RepoVersion()
{
	IsInstalled=$(which ${repoTool})
	if [ ! -z "${IsInstalled}" ]; then
		${repoTool} --version
	else
		echo "\"${repoTool}\" is not installed"
	fi
}

CodeVersion()
{
	local Lang=$1
	if [[ "${Lang}" == "Bash" ]] || [ -z "${Lang}" ]; then
		if [ ! -z "${BashCpl}" ]; then
			BashVersion=$(${BashCpl} --version | head -n 1)
			if [ -z "${Lang}" ]; then
				echo "[Bash]"
			fi
			echo "${BashVersion}"
		fi
	fi
	if [[ "${Lang}" == "Python" ]] || [ -z "${Lang}" ]; then
		if [ ! -z "${PythonRun}" ]; then
			if [ -z "${Lang}" ]; then
				echo "[Python]"
			fi
			${PythonRun} --version
		fi
	fi
	if [[ "${Lang}" == "C++" ]] || [ -z "${Lang}" ]; then
		if [ ! -z "${CppCpl}" ]; then
			CppVersion=$(${CppCpl} --version | head -n 1)
			if [ -z "${Lang}" ]; then
				echo "[C++]"
			fi
			echo "${CppVersion}"
		fi
	fi
	if [[ "${Lang}" == "Java" ]] || [ -z "${Lang}" ]; then
		if [ ! -z "${JavaRun}" ]; then
			if [ -z "${Lang}" ]; then
				echo "[Java]"
			fi
			JavaRunVersion=$(${JavaRun} --version 2> /dev/null)
			JavaCplVersion=$(${JavaCpl} --version 2> /dev/null)
			if [ ! -z "${JavaRunVersion}" ]; then
				JavaRunVersion=$(${JavaRun} --version | head -n 1)
				JavaCplVersion=$(${JavaCpl} --version | head -n 1)
				echo "${JavaRunVersion}"
				echo "${JavaCplVersion}"
			else
				${JavaRun} -version
				${JavaCpl} -version
			fi
		fi
	fi
}

Banner()
{
	Art
	echo ""
	echo "\"Welcome to ${Head} Version:(${Version})\""
	echo "\"The command line IDE for the Linux/Unix user\""
}

#Error messages
errorCode()
{
	local ecd=$1
	local sec=$2
	local thr=$3
	case $ecd in
		alias)
			echo "\"${sec}\" already installed"
			;;
		install)
			case ${sec} in
				choose)
					echo "hint: please choose script"
					;;
				*.java|*.class)
					echo "\"${sec}\" needs to be an java jar"
					echo "[to compile]: cpl jar"
					;;
				*)
					echo "\"${sec}\" needs to be an executable"
					echo "[to compile]: cpl"
					echo "OR"
					echo "[swap to executable]: swp bin"
					;;
			esac
			;;
		noCode)
			echo "No Code Found"
			echo "[to set code]: set <name>"
			;;
		newCode)
			echo "Please Provide The Name Of Your New Code"
			echo "EX: new <name>"
			;;
		editNull)
			echo "hint: ${editor}|edit|ed <file>"
			;;
		editNot)
			echo "code is not found in project"
			;;
		readNull)
			echo "hint: ${ReadBy}|read <file>"
			;;
		readNot)
			echo "code is not found in project"
			;;
		project)
			case ${sec} in
				none)
					echo "Your session MUST be a ${Head} Project"
					echo "hint: Please create or load a project"
					echo "$ project new <project>"
					echo "$ project load <project>"
					;;
				exists)
					echo "\"${thr}\" is already a project"
					;;
				NotAProject)
					echo "No \"${thr}\" project found"
					;;
				*)
					echo "Project error"
					;;
			esac
			;;
		cpl)
			case ${sec} in
				choose)
					echo "hint: please choose a program name"
					;;
				already)
					echo "\"${thr}\" already compiled"
					;;
				not)
					echo "code not found"
					;;
				*)
					echo "Nothing to Compile"
					echo "[to set code]: set <name>"
					;;
			esac
			;;
		loadSession)
				echo "No Session to load"
			;;
		*)
			;;
	esac
}

#Search selected code for element
lookFor()
{
	local project=$1
	local search=$2
	case ${project} in
		none)
			errorCode "project" "none"
			;;
		*)
			if [ ! -z "${search}" ]; then
				grep -iR ${search} * | less
			else
				echo "Nothing to search for"
				echo "Please provide a value"
			fi
			;;
	esac
}

#Save Last Session
SaveSession()
{
	local Session="${ClideDir}/session"
	local Language=$1
	local Project=$2
	local SrcCode=$3
	#Source Needs to be present
	if [ ! -z ${SrcCode} ]; then
		touch ${Session}
		echo "${Project};${Language};${SrcCode}" > ${Session}
	fi
}

#Load Last Session
LoadSession()
{
	local Session="${ClideDir}/session"
	#check for clide session
	if [ ! -f "${Session}" ]; then
		errorCode "loadSession"
	else
		cat ${Session}
	fi
}

#Create new project
newProject()
{
	local lang=$1
	local project=$2
	local path=""
	#No Project is found
	if [ -z ${project} ]; then
		errorCode "project" "none"
	else
		#Grab Project Data
		#Name Value
		echo "name=${project}" > ${ClideDir}/${project}.clide
		#Language Value
		echo "lang=${lang}" >> ${ClideDir}/${project}.clide
		#Source Value
		echo "src=" >> ${ClideDir}/${project}.clide
		#Check if Project dir is made
		case ${lang} in
			#Bash
			Bash)
				path=${BashSrc}/${project}
				if [ ! -d ${path} ]; then
					mkdir ${path}
					cd ${path}
					mkdir src bin
					cd ${path}/src
				else
					cd ${path}/src
				fi
				;;
			#Python
			Python)
				path=${PythonSrc}/${project}
				if [ ! -d ${path} ]; then
					mkdir ${path}
					cd ${path}
					mkdir src bin
					cd ${path}/src
				else
					cd ${path}/src
				fi
				;;
			#C++
			C++)
				path=${CppSrc}/${project}
				#create and cd to project dir
				if [ ! -d ${path} ]; then
					mkdir ${path}
					cd ${path}
					mkdir bin build doc include lib spike src test
					cd src
				else
					cd ${path}/src
				fi
				;;
			#Java
			Java)
				path=${JavaSrc}/${project}
				if [ ! -d ${path} ]; then
					mkdir ${path}
					cd ${path}
				else
					cd ${path}
				fi
				;;
			*)
				;;
		esac
	fi
}

#Update config of active Projects
updateProject()
{
	local project=$1
	local src=$2
	#No Project is found
	if [ ! -z ${src} ]; then
		#Locate Project Directory
		if [ ! -f ${ClideDir}/${project}.clide ]; then
			errorCode "project" "NotAProject" ${project}
		else
			grep -v "src=" ${ClideDir}/${project}.clide > new
			mv new ${ClideDir}/${project}.clide
			#Grab Project Data
			echo "src=${src}" >> ${ClideDir}/${project}.clide
		fi
	fi
}

#list active projects
listProjects()
{
	#Get list of active prijects from .clide files
	ls ${ClideDir}/ | grep -v "session" | sed "s/.clide//g"
}

#Load active projects
loadProject()
{
	local project=$1
	local path=""
	local RtnVals=""
	if [ ! -d "${ClideDir}" ]; then
		errorCode "project"
	else
		if [ -z ${project} ]; then
			echo "no"
		else
			#Locate Project Directory
			if [ -f ${ClideDir}/${project}.clide ]; then
				#Grab Project Data
				#Name Value
				tag="name"
				name=$(grep ${tag} ${ClideDir}/${project}.clide | sed "s/${tag}=//g")
				#Language Value
				tag="lang"
				lang=$(grep ${tag} ${ClideDir}/${project}.clide | sed "s/${tag}=//g")
				#Source Value
				tag="src"
				src=$(grep ${tag} ${ClideDir}/${project}.clide | sed "s/${tag}=//g")
				case ${lang} in
					#Bash
					Bash)
						path=${BashSrc}/${name}/src
						;;
					#Python
					Python)
						path=${PythonSrc}/${name}/src
						;;
					#C++
					C++)
						path=${CppSrc}/${name}/src
						;;
					#Java
					Java)
						path=${JavaSrc}/${name}
						;;
					*)
						;;
				esac
				#return valid
				RtnVals="${lang};${src};${path}"
				echo ${RtnVals}
			else
				#return false value
				echo "no"
			fi
		fi
	fi
}

#Edit Source code
editCode()
{
	local src=$1
	local num=$2
	#Bash
	if [[ "${src}" == *".sh" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "editNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".sh" ]]; then
						${editor} ${num}
					else
						${editor} "${num}.sh"
					fi
				else
					errorCode "editNot"
				fi
			fi
		else
			${editor} ${src}
		fi
	#Python
	elif [[ "${src}" == *".py" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "editNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".py" ]]; then
						${editor} ${num}
					else
						${editor} "${num}.py"
					fi
				else
					errorCode "editNot"
				fi
			fi
		else
			${editor} ${src}
		fi
	#C++
	elif [[ "${src}" == *".cpp" ]] || [[ "${src}" == *".h" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "editNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".cpp" ]] || [[ "${num}" == *".h" ]]; then
						${editor} ${num}
					else
						${editor} "${num}.cpp"
					fi
				else
					errorCode "editNot"
				fi
			fi
		else
			 ${editor} ${src}
		fi
	#Java
	elif [[ "${src}" == *".java" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "editNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".java" ]]; then
						${editor} ${num}
					else
						${editor} "${num}.java"
					fi
				else
					errorCode "editNot"
				fi
			fi
		else
			${editor} ${src}
		fi
	fi
}

#Add code to active session
addCode()
{
	local src=$1
	local new=$2
	#Bash
	if [[ "$src" == *".sh" ]]; then
		if [[ "${new}" == *".sh" ]]; then
			if [ -f "${new}" ]; then
				echo "${src},${new}"
			else
				echo "${src}"
			fi
		else
			if [ -f "${new}.sh" ]; then
				echo "${src},${new}.sh"
			else
				echo "${src}"
			fi
		fi
	#Python
	elif [[ "$src" == *".py" ]]; then
		if [[ "${new}" == *".py" ]]; then
			if [ -f "${new}" ]; then
				echo "${src},${new}"
			else
				echo "${src}"
			fi
		else
			if [ -f "${new}.py" ]; then
				echo "${src},${new}.py"
			else
				echo "${src}"
			fi
		fi
	#C++
	elif [[ "$src" == *".cpp" ]] || [[ "$src" == *".h" ]]; then
		#Add cpp or header files with file extensions
		if [[ "${new}" == *".cpp" ]] || [[ "${new}" == *".h" ]]; then
			#Append file
			if [ -f "${new}" ]; then
				echo "${src},${new}"
			else
				echo "${src}"
			fi
		#Add cpp or header files without file extensions
		else
			#Append cpp files
			if [ -f "${new}.cpp" ]; then
				echo "${src},${new}.cpp"
			#Append header files
			elif [ -f "${new}.h" ]; then
				echo "${src},${new}.h"
			else
				echo "${src}"
			fi
		fi
	#Java
	elif [[ "$src" == *".java" ]]; then
		if [[ "${new}" == *".java" ]]; then
			if [ -f "${new}" ]; then
				echo "${src},${new}"
			else
				echo "${src}"
			fi
		else
			if [ -f "${new}.java" ]; then
				echo "${src},${new}.java"
			else
				echo "${src}"
			fi
		fi
	fi
}

#Read source code without editing
readCode()
{
	local src=$1
	local num=$2
	#Bash
	if [[ "${src}" == *".sh" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "readNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".sh" ]]; then
						${ReadBy} ${num}
					else
						${ReadBy} "${num}.sh"
					fi
				else
					errorCode "readNot"
				fi
			fi
		else
			${ReadBy} ${src}
		fi
	#Python
	elif [[ "${src}" == *".py" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "readNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".py" ]]; then
						${ReadBy} ${num}
					else
						${ReadBy} "${num}.py"
					fi
				else
					errorCode "readNot"
				fi
			fi
		else
			${ReadBy} ${src}
		fi
	#C++
	elif [[ "${src}" == *".cpp" ]] || [[ "${src}" == *".h" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "readNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".cpp" ]] || [[ "${num}" == *".h" ]]; then
						${ReadBy} ${num}
					else
						${ReadBy} "${num}.cpp"
					fi
				else
					errorCode "readNot"
				fi
			fi
		else
			${ReadBy} ${src}
		fi
	#Java
	elif [[ "${src}" == *".java" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "readNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".java" ]]; then

						${ReadBy} ${num}
					else
						${ReadBy} "${num}.java"
					fi
				else
					errorCode "readNot"
				fi
			fi
		else
			${ReadBy} ${src}
		fi
	fi
}

#Create new source code
newCode()
{
	local Lang=$1
	local name=$2
	local Project=$3
	local Type=$4
	Type=$(echo ${Type} | tr A-Z a-z)
	case ${Lang} in
		#Bash
		Bash)
			name=${name%.sh}
			if [ ! -f ${name}.sh ]; then
				#Check for Custom Code Template
				if [ -f ${BashBin}/newBash.sh ]; then
					#Program Name Given
					if [ ! -z "${name}" ];then
						${BashBin}/newBash.sh ${name} > ${name}.sh
					#No Program Name Given
					else
						${BashBin}/newBash.sh --help
					fi
				else
					#Program Name Given
					if [ ! -z "${name}" ];then
						touch ${name}.sh
					else
						errorCode "newCode"
					fi
				fi
			fi
			;;
		#Python
		Python)
			name=${name%.py}
			if [ ! -f ${name}.py ]; then
				#Check for Custom Code Template
				if [ -f ${PythonBin}/newPython.py ]; then
					#Program Name Given
					if [ ! -z "${name}" ];then
						${PythonRun} ${PythonBin}/newPython.py -n ${name} --cli --main -w -r -o
					#No Program Name Given
					else
						${PythonRun} ${PythonBin}/newPython.py --help
					fi
				else
					#Program Name Given
					if [ ! -z "${name}" ];then
						touch ${name}.py
					else
						errorCode "newCode"
					fi
				fi
			fi
			;;
		#C++
		C++)
			name=${name%.cpp}
			name=${name%.h}
			if [ ! -f ${name}.cpp ] || [ ! -f ${name}.h ]; then
				case ${Type} in
					#create header file
					header)
						#Program Name Given
						if [ ! -z "${name}" ];then
							touch "${name}.h"
						else
							errorCode "newCode"
						fi
						;;
					#create main file
					main)
						#Check for Custom Code Template
						if [ -f ${CppBin}/newC++ ]; then
							#Program Name Given
							if [ ! -z "${name}" ];then
								${CppBin}/newC++ -w -r --cli --main -i -u -n ${name}
							#No Program Name Given
							else
								#Help Page
								${CppBin}/newC++ --help
							fi
						else
							#Program Name Given
							if [ ! -z "${name}" ];then
								touch ${name}.cpp
							else
								errorCode "newCode"
							fi
						fi
						;;
					#create component file
					component)
						if [ -f ${CppBin}/newC++ ]; then
							#Program Name Given
							if [ ! -z "${name}" ];then
								${CppBin}/newC++ -n "${name}"
							#No Program Name Given
							else
								#Help Page
								${CppBin}/newC++ --help
							fi
						else
							#Program Name Given
							if [ ! -z "${name}" ];then
								touch ${name}.cpp
							else
								errorCode "newCode"
							fi
						fi
						;;
					#cl[ide] knows best
					*)
						#Is not a project
						if [[ "${Project}" == "none" ]]; then
							newCode ${Lang} ${name} ${oldCode} ${Project} "main"
						#Is a project
						else
							if [[ "${oldCode}" == *".cpp" ]] || [[ "${oldCode}" == *".cpp" ]]; then
								newCode ${Lang} ${name} ${oldCode} ${Project} "component"
							else
								newCode ${Lang} ${name} ${oldCode} ${Project} "main"
							fi
						fi
						;;
				esac
			fi
			;;
		#Java
		Java)
			name=${name%.java}
			if [ ! -f ${name}.java ]; then
				#Check for Custom Code Template...is class
				if [ -f ${JavaBin}/newJava.class ]; then
					#Program Name Given
					if [ ! -z "${name}" ];then
						case ${Type} in
							#create main file
							main)
								cd ${JavaBin}
								java newJava --user $USER --main -w -r -u -n "${name}"
								cd - > /dev/null
								mv "${JavaBin}/${name}.java" .
								;;
							#create component file
							component)
								cd ${JavaBin}
								java newJava --user $USER -w -r -n "${name}"
								cd - > /dev/null
								mv "${JavaBin}/${name}.java" .
								;;
							#cl[ide] knows best
							*)
								#main class already created
								if [[ "${oldCode}" == *".java" ]]; then
									#Create libary class
									newCode ${Lang} ${name} ${oldCode} ${Project} "component"
								else
									#Create new main code
									newCode ${Lang} ${name} ${oldCode} ${Project} "main"
								fi
								;;
						esac
					#No Program Name Given
					else
						cd ${JavaBin}
						java newJava --help
						cd - > /dev/null
					fi
				#Check for Custom Code Template...is jar
				elif [ -f ${JavaBin}/newJava.jar ]; then
					#Program Name Given
					if [ ! -z "${name}" ];then
						case ${Type} in
							#create main file
							main)
								${JavaBin}/newJava.jar --user $USER --main -w -r -u -n "${name}"
								;;
							#create component file
							component)
								${JavaBin}/newJava.jar --user $USER -w -r -n "${name}"
								;;
							#cl[ide] knows best
							*)
								#main class already created
								if [[ "${oldCode}" == *".java" ]]; then
									#Create libary class
									newCode ${Lang} ${name} ${oldCode} ${Project} "component"
								else
									#Create new main code
									newCode ${Lang} ${name} ${oldCode} ${Project} "main"
								fi
								;;
						esac
					#No Program Name Given
					else
						${JavaBin}/newJava.jar --help
					fi
				#No Program Name Given
				else
					#Program Name Given
					if [ ! -z "${name}" ];then
						touch ${name}.java
					else
						errorCode "newCode"
					fi
				fi
			fi
			;;
		#no langague given
		*)
			;;
	esac
}

#remove source code
Remove()
{
	local active=$1
	local src=$2
	local option=$3
	if [ ! -z "${src}" ]; then
		if [ *"${src}"* == "${active}" ]; then
			if [ -f ${src} ]; then
				if [ "${option}" == "--force" ]; then
					rm ${src}
					echo "\"${src}\" is REMOVED"
				else
					clear
					echo "WARNING: YOU ARE TRYING TO DELETE A FILE"
					echo "WARNING: You will NOT recover this file"
					echo ""
					echo "\"yes\" is NOT \"YES\""
					echo -n "Are you Sure you want to remove \"${src}\" (YES/NO)? "
					read User
					case ${User} in
						YES)
							clear
							rm ${src}
							echo "\"${src}\" is REMOVED"
							;;
						*)
							clear
							echo "\"${src}\" is NOT removed"
							;;
		 			esac
					echo ""
					echo "HINT: to force removal, provide a \"--force\""
				fi
			else
				echo "\"${src}\" not a file"
			fi
		else
			echo "\"${src}\" not a file"
		fi
	fi
}

RunCode()
{
	local Lang=$1
	local name=$2
	local option=$3
	local Args=""
	local JavaProp=""
	local TheBin=""
	local TheJar=""
	if [[ "${name}" == *","* ]]; then
		echo "${Head} can only handle ONE file"
	else
		case ${Lang} in
			#Adjust for C++ code
			C++)
				TheBin="${name%.*}"
				;;
			#Adjust for Java code
			Java)
				TheBin="${name%.*}.class"
				TheJar="${name%.*}.jar"
				#Check for Java System.getProperty
				getPropPresent=$(grep "System.getProperty" ${name} | grep \, | tr -d '\t')
				if [ ! -z "${getPropPresent}" ] && [ -z "${JavaProp}" ]; then
					if [ -z "${JavaRunProp}" ]; then
						#User Provide Values
						echo "Please Provide Java Property"
						echo -n "-D"
						read -e EnvArgs
						EnvArgs=$(echo "-D${EnvArgs}")
						#All Given in one line
					fi
					#Ensure correct flags
					if [[ "${EnvArgs}" == "-D"*"=\""*"\"" ]]; then
						JavaProp=${EnvArgs}
					#Args pre-set
					elif [[ "${JavaRunProp}" == "-D"*"=\""*"\"" ]]; then
						JavaProp=${JavaRunProp}
					else
						JavaProp=""
					fi
				fi
				;;
			#Bash and Python
			*)
				TheBin="${name}"
				;;
		esac

		#Come up with a way to know if arguments are needed
		TheLang=$(color "${Lang}")
		#If Java Class, remove .class
		if [[ "${TheBin}" == *".class" ]]; then
			TheName=$(color "${TheBin%.*}")
			TheNameJar=$(color "${TheBin%.*}.jar")
		#Other Languages
		else
			TheName=$(color "${TheBin}")
		fi
		#User Wishes to provide arments for program
		case ${option} in
			-a|--args)
				CLIout=""
				case ${Lang} in
					Python)
						CLIout="$USER@${Name}:~/${TheLang}\$ ${PythonRun} ${TheName}"
						;;
					Java)
						if [ ! -z "${JavaProp}" ]; then
							#Its a Class
							if [ -f ${JavaBin}/${TheBin} ]; then
								CLIout="$USER@${Name}:~/${TheLang}\$ java ${JavaProp} ${TheName}"
							#Its a Jar
							elif [ -f ${JavaBin}/${TheJar} ]; then
								CLIout="$USER@${Name}:~/${TheLang}\$ ./${TheNameJar}"
							fi
						else
							#Its a Class
							if [ -f ${JavaBin}/${TheBin} ]; then
								CLIout="$USER@${Name}:~/${TheLang}\$ java ${TheName}"
							#Its a Jar
							elif [ -f ${JavaBin}/${TheJar} ]; then
								CLIout="$USER@${Name}:~/${TheLang}\$ ./${TheNameJar}"
							fi
						fi
						;;
					*)
						CLIout="$USER@${Name}:~/${TheLang}\$ ./${TheName}"
						;;
				esac
				#User Args not Pre-done
				if [ -z "${RunTimeArgs}" ]; then
					#Get User Args
					echo -n "${CLIout} "
					read -a Args
				#User Args Pre-done
				else
					#Show Args
					echo -n ${CLIout} "${RunTimeArgs[@]}"
					read
					Args=${RunTimeArgs[@]}
				fi
				;;
			*)
				;;
		esac

		case ${Lang} in
			#Bash
			Bash)
				#Check if Bash Script exists
				if [ -f ${BashBin}/${name} ]; then
				${BashBin}/${name} ${Args[@]}
				else
					echo "${name} is not compiled"
					echo "[HINT] \$ cpl"
				fi
				;;
			#Python
			Python)
				#Check if Pythin Bin exists
				if [ -f ${PythonBin}/${TheBin} ]; then
					${PythonRun} ${PythonBin}/${TheBin} ${Args[@]}
				else
					echo "${name} is not compiled"
					echo "[HINT] \$ cpl"

				fi
				;;
			#C++
			C++)
				#Check if C++ Bin exists
				if [ -f ${CppBin}/${TheBin} ]; then
					${CppBin}/${TheBin} ${Args[@]}
				else
					echo "${name} is not compiled"
					echo "[HINT] \$ cpl"
				fi
				;;
			#Java
			Java)
				#Check if Java Class exists
				if [ -f ${JavaBin}/${TheBin} ]; then
					TheBin=${TheBin%.*}
					cd ${JavaBin}
					#If no JavaProp found
					if [ -z "${JavaProp}" ]; then
						#Execute without
						${JavaRun} ${TheBin} ${Args[@]}
					else
						${JavaRun} "${JavaProp}" ${TheBin} ${Args[@]}
					fi
					cd - > /dev/null
				#Check if Java Jar exists
				elif [ -f ${JavaBin}/${TheJar} ]; then
					${JavaRun} -jar ${JavaBin}/${TheJar} ${Args[@]}
				else
					echo "${name} is not compiled"
					echo "[HINT] \$ cpl"
				fi
				;;
			*)
				;;
		esac
	fi
}

selectCode()
{
	local code=$1
	local name=$2
	local old=$3
	case ${code} in
		#Bash
		Bash)
			#Correct filename
			if [[ ! "${name}" == *".sh" ]] && [[ ! "${name}" == "clide" ]]; then
				name="${name}.sh"
			fi
			;;
		#Python
		Python)
			#Correct filename
			if [[ ! "${name}" == *".py" ]]; then
				name="${name}.py"
			fi
			;;
		#C++
		C++)
			#Correct filename
			if [[ ! "${name}" == *".cpp" ]] && [ -f "${name}.cpp" ]; then
				name="${name}.cpp"
			elif [[ ! "${name}" == *".h" ]] && [ -f "${name}.h" ]; then
				name="${name}.h"
			fi
			;;
		#Java
		Java)
			#Correct filename
			if [[ ! "${name}" == *".java" ]]; then
				name="${name}.java"
			fi
			;;
		*)
			;;
	esac

	#Return source file if exists
	if [ -f "${name}" ]; then
		echo "${name}"
	#Return old source file if new does not exist
	else
		echo "${old}"
	fi
}

#get Program Source Code Dir
pgDir()
{
	local code=$1
	case ${code} in
		#Bash
		Bash)
			#Return Bash src Dir
			echo ${BashSrc}
			;;
		#Python
		Python)
			#Return Python src Dir
			echo ${PythonSrc}
			;;
		#C++
		C++)
			#Return C++ src Dir
			echo ${CppSrc}
			;;
		#Java
		Java)
			#Return Java src Dir
			echo ${JavaSrc}
			;;
		#No Languge found
		*)
			#Return rejection
			echo "no"
			;;
	esac
}

#get Language Name
pgLang()
{
	local Lang=$(echo "$1" | tr A-Z a-z)
	case ${Lang} in
		#Bash
		b|bash)
			if [ ! -z "${BashCpl}" ]; then
				#Return Bash tag
				echo "Bash"
			else
				#Return rejection
				echo "no"
			fi
			;;
		#Python
		p|python)
			if [ ! -z "${PythonRun}" ]; then
				#Return Python tag
				echo "Python"
			else
				#Return rejection
				echo "no"
			fi
			;;
		#C++
		c|c++)
			if [ ! -z "${CppCpl}" ]; then
				#Return C++ tag
				echo "C++"
			else
				#Return rejection
				echo "no"
			fi
			;;
		#Java
		j|java)
			if [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
				#Return Java tag
				echo "Java"
			else
				#Return rejection
				echo "no"
			fi
			;;
		#No Languge found
		*)
			#Return rejection
			echo "no"
			;;
	esac
}

#Color Text
color()
{
	local text=$1
	case ${text} in
		#Bash
		Bash)
			#Return Green
			echo -e "\e[1;32m${text}\e[0m"
			;;
		#Python
		Python)
			#Return Yellow
			echo -e "\e[1;33m${text}\e[0m"
			;;
			#C++
		C++)
			#Return Blue
			echo -e "\e[1;34m${text}\e[0m"
			;;
		#Java
		Java)
			#Return Red
			echo -e "\e[1;31m${text}\e[0m"
			;;
		#Other
		*)
			#Return Purple
			echo -e "\e[1;35m${text}\e[0m"
			;;
	esac
}

ColorCodes()
{
	if [ ! -z "${BashCpl}" ]; then
		Bash=$(color "Bash")
	fi
	if [ ! -z "${PythonRun}" ]; then
		Python=$(color "Python")
	fi
	if [ ! -z "${CppCpl}" ]; then
		Cpp=$(color "C++")
	fi
	if [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
		Java=$(color "Java")
	fi
	pg="${Bash} ${Python} ${Cpp} ${Java}"
	echo ${pg}
}

#Compile Python script
py2bin()
{
	local TheFile=$1
	#Make sure its python
	if [[ "$TheFile" == *".py" ]]; then
		#Get program name
		Name=${TheFile[0]%.*}
		#Compile Python script
		pyinstaller -F $TheFile
		#clear terminal
		clear
		#move compiled to src dir
		mv dist/$Name .
		#Remove unwanted files/dir
		rm ${Name}.spec
		rm -rf build
		rm -rf dist
	fi
}

#Handle Aliases
AddAlias()
{
	local AliasName=$1
	local Command="$2 $3"
	local Insert="alias ${AliasName}=\"${Command} \$@\""
	if [[ "$USER" == "root" ]]; then
		Replace="\\$HOME\\/"
	else
		Replace="\\/home\\/$USER\\/"
	fi
	local With="\~\\/"
	local CheckFor=$(echo ${Insert} | sed "s/${Replace}/${With}/g")
	touch ${Aliases}
	if grep -q "alias ${AliasName}=" ${Aliases}; then
		errorCode "alias" ${AliasName}
	else
		if grep -q "${CheckFor}" ${Aliases}; then
			errorCode "alias" ${AliasName}
		else
			#Add Alias to .bash_aliases file
			echo ${Insert} >> ${Aliases}
			cat ${Aliases} | sort | uniq > ${Aliases}.new
			mv ${Aliases}.new ${Aliases}
			sed "s/${Replace}/${With}/g" ${Aliases} > ${Aliases}.new
			mv ${Aliases}.new ${Aliases}
			echo "\"${AliasName}\" installed"
		fi
	fi
}

#Install into bash_aliases
Install()
{
	local code=$1
	local bin=$2
	local BinFile="${bin%.*}"
	case ${code} in
		#Bash
		Bash)
			#Make sure Binary exists
			if [ -f "${BashBin}/${bin}" ]; then
				#Add command to Aliases
				AddAlias "${BinFile}" "${BashBin}/${bin}"
			elif [ ! -f "${BashBin}/${bin}" ]; then
				errorCode "install" "${bin}"
			else
				errorCode "noCode"
			fi
			;;
		#Python
		Python)
			#Make sure Binary exists
			if [ -f "${PythonBin}/${bin}" ]; then
				#Add command to Aliases
				AddAlias "${BinFile}" "python ${PythonBin}/${bin}"
			elif [ ! -f "${PythonBin}/${bin}" ]; then
				errorCode "install" "${bin}"
			else
				errorCode "noCode"
			fi
			;;
		#C++
		C++)
			#Make sure Binary exists
			if [ -f "${CppBin}/${bin}" ]; then
				#Add command to Aliases
				AddAlias "${bin}" "${CppBin}/${bin}"
			elif [ ! -f "${CppBin}/${bin}" ]; then
				#compule or swap to binary
				errorCode "install" "${bin}"
			else
				errorCode "noCode"
			fi
			;;
		#Java
		Java)
			#Java binary
			if [[ "${bin}" == *".java" ]]; then
				#Check for Jar file
				if [ -f "${JavaBin}/${BinFile}.jar" ]; then
					AddAlias "${BinFile}" "${JavaRun} -jar ${JavaBin}/${BinFile}.jar"
				elif [ -f "${JavaBin}/${bin}.class" ]; then
					echo "Please compile as jar file"
					echo "[hint] $ cpl jar"
				else
					errorCode "install" "${bin}"
				fi
			else
				errorCode "noCode"
			fi
			;;
		#Not found
		*)
			errorCode "noCode"
			;;
	esac
}

#Compile code
compileCode()
{
	local src=$1
	local project=${CodeProject}
	local name=$2
	local cplArgs=""
	#Handle Project Dir
	if [[ "${project}" == "none" ]]; then
		project=""
	else
		project="${project}/"
	fi
	#bash
	if [[ "${src}" == *".sh" ]]; then
		#Multiple code selected
		if [[ "${src}" == *","* ]]; then
			#varable is empty
			if [ -z ${name} ]; then
				errorCode "cpl" "choose"
			else
				#chosen file is in the list of files
				if [[ "${src}" == *"${name}"* ]]; then
					#only name is given
					if [[ "${name}" != *".sh" ]]; then
						#full filename given
						num=${name}.sh
					fi
					#Make Bash Script executable
					chmod +x ${name}
					#Check if Bash Script does NOT exist
					if [[ ! -f "${BashBin}/${name}" ]]; then
						#Change to Bash Binary dir
						cd ${BashBin}
						#Create Symbolic Link to Bash Script
						ln -s ../src/${project}${name}
						#Change to Bash Source dir
						cd "${BashSrc}/${project}"
						echo -e "\e[1;42m[Bash Code Compiled]\e[0m"
					else
						errorCode "cpl" "already" ${name}
					fi
				else
					errorCode "cpl" "not"
				fi
			fi
		#single code selected
		else
			#Make Bash Script executable
			chmod +x ${src}
			#Check if Bash Script does NOT exist
			if [[ ! -f "${BashBin}/${src}" ]]; then
				#Change to Bash Binary dir
				cd ${BashBin}
				#Create Symbolic Link to Bash Script
				ln -s ../src/${project}${src}
				#Change to Bash Source dir
				cd "${BashSrc}/${project}"
				echo -e "\e[1;42m[Bash Code Compiled]\e[0m"
			else
				errorCode "cpl" "already" ${src}
			fi
		fi
	#Python
	elif [[ "$src" == *".py" ]]; then
		#Compile Python Script
		#py2bin "${src}"
		#Get Python Name
                #pyBin="${src%.*}"
		#Move Python Program to Binary dir
		#mv ${pyBin} ../bin/
		#Check if Python Script does NOT exist
		#
		#Multiple code selected
		if [[ "${src}" == *","* ]]; then
			#variable is empty
			if [ -z ${name} ]; then
				errorCode "cpl" "choose"
			#variable found
			else
				#chosen file is in the list of files
				if [[ "${src}" == *"${name}"* ]]; then
					#only name is given
					if [[ "${name}" != *".py" ]]; then
						#full filename given
						num=${name}.py
					fi
					#Make Python Script executable
					chmod +x ${name}
					#Check if Python Script does NOT exist
					if [[ ! -f "${PythonBin}/${name}" ]]; then
						#Change to Python Binary dir
						cd ${PythonBin}
						#Create Symbolic Link to Python Script
						ln -s ../src/${project}${name}
						#Change to Python Source dir
						cd "${PythonSrc}/${project}"
						echo -e "\e[1;43m[Python Code Compiled]\e[0m"
					else
						errorCode "cpl" "already" ${name}
					fi
				else
					echo "code not found"
				fi
			fi
		#single code selected
		else
			#Make Python Script executable
			chmod +x ${src}
			#Check if Python Script does NOT exist
			if [[ ! -f "${PythonBin}/${src}" ]]; then
				#Change to Python Binary dir
				cd ${PythonBin}
				#Create Symbolic Link to Python Script
				ln -s ../src/${project}${src}
				#Change to Python Source dir
				cd "${PythonSrc}/${project}"
				echo -e "\e[1;43m[Python Code Compiled]\e[0m"
			#Code is already found
			else
				errorCode "cpl" "already" ${src}
			fi
		fi
	#C++
	elif [[ "$src" == *".cpp"* ]] || [ -f ${CppSrc}/${project}makefile ]; then
		if [ -f ${CppSrc}/${project}makefile ]; then
			cd ${CppSrc}/${project}
			echo "make"
			cd - > /dev/null
			echo -e "\e[1;44m[C++ Code Compiled]\e[0m"
		else
			#Multiple code selected
			if [[ "${src}" == *","* ]]; then
				#num is empty
				if [ -z ${name} ]; then
					errorCode "cpl" "choose"
				else
					#Separate list of selected code
					prog=$(echo ${src} | sed "s/,/ /g")
					#Compile for Threads
					NeedThreads=$(grep "#include <thread>" ${prog})
					if [ ! -z "${NeedThreads}" ]; then
						cplArgs="-lpthread"
					fi
					${CppCpl} ${prog} -o ../bin/${name} ${cplArgs}
					echo -e "\e[1;44m[C++ Code Compiled]\e[0m"
				fi
			#single code selected
			else
				#Compile for threading
				NeedThreads=$(grep "#include <thread>" ${src})
				if [ ! -z "${NeedThreads}" ]; then
					cplArgs="-lpthread"
				fi
				#Compile and move C++ to Binary dir
				${CppCpl} ${src} -o ../bin/${src%.*} ${cplArgs}
				echo -e "\e[1;44m[C++ Code Compiled]\e[0m"
			fi
		fi
	#Java
	elif [[ "$src" == *".java" ]]; then
		#Multiple code selected
		if [[ "${src}" == *","* ]]; then
			if [[ "${project}" == *"/" ]]; then
				#Compile Java prgram
				${JavaCpl} *.java
				#move Java Class to Binary dir
				if [ -f *.class ]; then
					mv *.class ../bin/
				fi
			else
				echo "Is not a project"
			fi
		#single code selected
		else
			#Compile Java prgram
			${JavaCpl} ${src}
			#get Java Class/compiled file name
			des=${src%.*}.class
			if [ -f ${des} ]; then
				#Compile as jar or class
				case ${name} in
					#Compile as Jar
					jar)
						if [ ! -f manifest.mf ]; then
							echo "Main-Class: ${des%.class}" > manifest.mf
						fi
						jar -cmf manifest.mf ${des%.class}.jar ${des}
						#remove class file
						if [ -f ../bin/${des} ]; then
							rm ../bin/${des}
						fi
						rm manifest.mf ${des}
						#move Java Jar to Binary dir
						mv ${des%.class}.jar ../bin/
						;;
					#Do nothing...keep class
					*)
						#move Java Class to Binary dir
						mv ${des} ../bin/
						#remove old jar
						if [ -f ../bin/${des%.class}.jar ]; then
							rm ../bin/${des%.class}.jar
						fi
						;;
				esac
				echo -e "\e[1;41m[Java Code Compiled]\e[0m"
			fi
		fi
	#Not found
	else
		errorCode "cpl"
	fi
}

#Handle Git commands
gitHandler()
{
	local repoAct=$1
	shift
	#check if git is installed
	GitTool=$(which git)
	#Git is installed
	if [ ! -z "${GitTool}" ]; then
		case ${repoAct} in
			#Create a new repo
			new|init)
				echo git init
				;;
			#clone a new repo
			setup|clone)
				#Find repo name
				repo=$@
				if [ ! -z "${repo}" ]; then
					echo git clone ${repo[@]}
				#Repo not given
				else
					#Ask User for Repo
					echo -n "repo: "
					read -a repo
					#Repo given
					if [ ! -z "${repo}" ]; then
						#Run through 2nd time
						gitHandler "clone" "${repo[@]}"
					#Again...nothing
					else
						#Nothing to do
						echo "Nothing to clone"
					fi
				fi
				;;
			#Add files to changes
			add)
				files=$@
				#Files given
				if [ ! -z "${files}" ]; then
					echo git add ${files}
				else
					#Get ALL files from user
					echo git add .
				fi
				;;
			#Provide message for repo
			message|commit)
				#Get message
				msg=$@
				if [ ! -z "${msg}" ]; then
					echo git commit -m "\"${msg}\""
				#No message found
				else
					#As for user...get EVERYTHING typed
					echo -n "Message: "
					read -a msg
					#Message given
					if [ ! -z "${msg}" ]; then
						gitHandler "commit" "${msg[@]}"
					else
						echo "No message found"
					fi
				fi
				;;
			#Handles Git Branches
			branch|branches)
				branchAct=$1
				shift
				case ${branchAct} in
					new)
						name=$1
						if [ ! -z "${name}" ]; then
							echo git checkout -b "${name}"
						else
							echo -n "Provide a branch name"
							read name
							if [ ! -z "${name}" ]; then
								gitHandler "branch" "new" "${name}"
							else
								echo "No branch has been created"
							fi
						fi
						;;
					#delete branches on local repo
					remove|delete)
						#Get branch name
						name=$1
						#branch name given
						if [ ! -z "${name}" ]; then
							#remove branch
							echo git branch -d "${name}"
						#no branch name given
						else
							#Get user to type branch name
							echo -n "Provide a branch name"
							read name
							#branch name given
							if [ ! -z "${name}" ]; then
								#remove branch
								gitHandler "branch" "delete" "${name}"
							#no branch name given
							else
								echo "No Branch has been deleted"
							fi
						fi
						;;
					select|checkout)
						#Get branch name
						name=$1
						#branch name given
						if [ ! -z "${name}" ]; then
							#Select branch
							echo git checkout "${name}"
						#no branch name given
						else
							#Get user to type branch name
							echo -n "Provide a branch name"
							read name
							#branch name given
							if [ ! -z "${name}" ]; then
								#Select branch
								gitHandler "branch" "checkout" "${name}"
							#no branch name given
							else
								echo "No Branch has been selected"
							fi
						fi
						;;
					#list all branches
					*)
						echo git branch -a
						;;
				esac
				;;
			upload|push)
				branch=$1
				if [ ! -z "${branch}" ]; then
					echo git push origin "\"${branch}\""
				else
					echo -n "Please choose a banch: "
					read branch
					if [ ! -z "${branch}" ]; then
						gitHandler "push" "${branch}"
					else
						echo "Code not pushed"
					fi
				fi
				;;
			#Download from the repo
			download|pull)
				echo git pull
				;;
			#Display repo infortmation
			state|status)
				echo git status
				;;
			#Peform quick and dirty commit
			slamdunk)
				gitHandler "add"
				gitHandler "commit"
				gitHandler "push"
				;;
			help|options)
				echo "git help page"
				;;
			*)
				RepoVersion
				;;
		esac
	#git is not installed
	else
		echo "Please Install git"
	fi
}

svnHandler()
{
	local repoAct=$1
	shift
	#check if git is installed
	SvnTool=$(which svn)
	#Git is installed
	if [ ! -z "${SvnTool}" ]; then
		echo "svn is installed"
	#svn is not installed
	else
		echo "Please Install svn"
	fi
}

repoHandler()
{
	case ${repoTool} in
		git)
			#git execution is handled by user
			if [[ "${repoAssist}" == "False" ]] && [[ "$1" == "${repoTool}" ]]; then
				IsInstalled=$(which ${repoTool})
				if [ ! -z "${IsInstalled}" ]; then
					$@
				else
					echo "\"${repoTool}\" is not installed"
				fi
			#git execution is handled by cl[ide]
			elif [[ "${repoAssist}" == "True" ]]; then
				shift
				gitHandler $@
			else
				echo "repo version control has been disabled"
			fi
			;;
		svn)
			#svn execution is handled by user
			if [[ "${repoAssist}" == "False" ]] && [[ "$1" == "${repoTool}" ]]; then
				IsInstalled=$(which ${repoTool})
				if [ ! -z "${IsInstalled}" ]; then
					$@
				else
					echo "\"${repoTool}\" is not installed"
				fi
			#svn execution is handled by cl[ide]
			elif [[ "${repoAssist}" == "True" ]]; then
				shift
				svnHandler $@
			else
				echo "repo version control has been disabled"
			fi
			;;
		*)
			echo "${Head} is unable to use \"${repoTool}\" at this time"
			;;
	esac
}

#Switch to Src file
SwapToSrc()
{
	local Lang=$1
	local src=$2
	case ${Lang} in
		#Bash
		Bash)
			echo "${src}"
			;;
		#Python
		Python)
			#Get Python Name
		#	src="${src}.py"
		#	#Check if Python source exists
		#	if [[ -f "${PythonSrc}/${src}" ]]; then
		#		#Return Python Source Name
				echo "${src}"
		#	fi
			;;
		#C++
		C++)
			#cd "${CppSrc}"
			#Get C++ Name
			src="${src}.cpp"
			#Check if C++ source exists
			if [ -f "${CppSrc}/${src}" ]; then
				#Return C++ Source Name
				echo "${src}"
			fi
			;;
		#Java
		Java)
			#cd "${JavaSrc}"
			#Get Java Name
			src="${src%.*}.java"
			#Check if Java source exists
			if [ -f "${JavaSrc}/${src}" ]; then
				#Return Java Source Name
				echo "${src}"
			fi
			;;
		*)
			echo "${src}"
			;;
	esac
}

#Switch to Bin file
SwapToBin()
{
	local bin=$1
	#bash
	if [[ "${bin}" == *".sh" ]]; then
		#Check if Bash Binary exists
		if [[ -f "${BashBin}/${bin}" ]]; then
			#Return Bash Binary Name
			#cd "${BashBin}"
			echo "${bin}"
		else
			echo "${bin}"
		fi
	#Python
	elif [[ "${bin}" == *".py" ]]; then
		#Get Python Name
	#	bin="${bin%.*}"
		#Check if Python Binary exists
		if [[ -f "${PythonBin}/${bin}" ]]; then
			#cd "${PythonBin}"
			#Return Python Binary Name
			echo "${bin}"
		else
			echo "${bin}"
		fi
	#C++
	elif [[ "${bin}" == *".cpp" ]]; then
		#cd "${CppBin}"
		#Keep Src Name
		OldBin="${bin}"
		#Get C++ Name
		bin="${bin%.*}"
		#Check if C++ Binary exists
		if [ -f "${CppBin}/${bin}" ]; then
			#Return C++ Binary Name
			echo "${bin}"
		else
			echo "${OldBin}"
		fi
	#Java
	elif [[ "${bin}" == *".java" ]]; then
		#cd "${JavaBin}"
		#Keep SrcName
		OldBin="${bin}"
		#Get Java Name
		bin="${bin%.*}.class"
		#Check Java Binary exists
		if [ -f "${JavaBin}/${bin}" ]; then
			#Return Java Binary Name
			echo "${bin}"
		else
			echo "${OldBin}"
		fi
	#Nothing found
	else
		#Return the Source File
		echo ${bin}
	fi
}

#IDE
Actions()
{
	local Dir=""
	local ProjectDir=""
	local Lang=$1
	local CodeDir=$(pgDir ${Lang})
	local pLangs=$(ColorCodes)
	local UserArg=""
	#No Project Given
	if [ -z $2 ]; then
		Code=""
	else
		Code=$2
	fi
	#No Project Given
	if [ -z $3 ]; then
		CodeProject="none"
	else
		CodeProject=$3
		Dir="${CodeProject}"
	fi

	#Avoid getting incorrect directory name
	if [[ "${Dir}" == "none" ]]; then
		Dir=""
	fi
	#Language Chosen
	if [[ ! "${CodeDir}" == "no" ]]; then
		cd ${CodeDir}/${Dir}
		Banner
		while true
		do
			#Change Color for Language
			cLang=$(color ${Lang})
			#Change Color for Code
			cCode=$(color ${Code})
			if [[ "${Code}" == "" ]]; then
				if [[ "${CodeProject}" == "none" ]]; then
					#Menu with no code
					echo -n "${Name}(${cLang}):$ "
				else
					ThePWD=$(pwd)
					ProjectDir=$(echo ${ThePWD#*${CodeProject}} | sed "s/\//:/1")
					#Menu with no code
					echo -n "${Name}(${cLang}[${CodeProject}${ProjectDir}]):$ "
				fi
			else
				if [[ "${CodeProject}" == "none" ]]; then
					#Menu with code
					echo -n "${Name}(${cLang}{${cCode}}):$ "
				else
					ThePWD=$(pwd)
					ProjectDir=$(echo ${ThePWD#*${CodeProject}} | sed "s/\//:/1")
					#Menu with no code
					echo -n "${Name}(${cLang}[${CodeProject}${ProjectDir}]{${cCode}}):$ "
				fi
			fi
			#Handle CLI
			read -a UserIn
			UserArg=$(echo ${UserIn[0]} | tr A-Z a-z)
			case ${UserArg} in
				#List files
				ls)
					ls ${UserIn[1]}
					;;
				ll)
					shift
					ls -lh ${UserIn[1]}
					;;
				#Clear screen
				clear)
					clear
					;;
				#Set for session
				set)
					Code=$(selectCode ${Lang} ${UserIn[1]} ${Code})
					;;
				#Unset code for session
				unset)
					Code=""
					;;
				#Delete source code
				rm|remove|delete)
					Remove ${Code} ${UserIn[1]} ${UserIn[2]}
					Code=""
					;;
				#change dir in project
				cd)
					#Use ONLY for Projects
					if [[ ! "${CodeProject}" == "none" ]]; then
						cd ${UserIn[1]}
						here=$(pwd)
						if [[ ! "${here}" == *"${CodeProject}"* ]]; then
							echo "Leaving your project is not allowed"
							cd - > /dev/null
						fi
						#Dir="${CodeProject}"
					else
						echo "Must have an active project"
					fi
					;;
				#get pwd of dir
				pwd)
					#Use ONLY for Projects
					if [[ ! "${CodeProject}" == "none" ]]; then
						here=$(pwd)/
						echo ${here#*${CodeProject}}
					else
						echo "Must have an active project"
					fi
					;;
				#make dir in project
				mkdir)
					#Use ONLY for Projects
					if [[ ! "${CodeProject}" == "none" ]]; then
						mkdir ${UserIn[1]}
					else
						echo "Must have an active project"
					fi
					;;
				#Handle Projects
				project)
					#Project commands
					case ${UserIn[1]} in
						#Create new project
						new)
							if [[ "${Lang}" == "Java" ]]; then
								echo "${Head} Cannot handle Java Projects"
							else
								#Locate Project Directory
								if [ -f "${ClideDir}/${UserIn[2]}.clide" ]; then
									errorCode "project" "exists" ${UserIn[2]}
								else
									newProject ${Lang} ${UserIn[2]}
									Code=""
									updateProject ${UserIn[2]} ${Code}
									if [ ! -z ${UserIn[2]} ]; then
										CodeProject=${UserIn[2]}
										echo "Created \"${CodeProject}\""
									fi
								fi
							fi
							;;
						#Update live project
						update)
							updateProject ${CodeProject} ${Code}
							echo "\"${CodeProject}\" updated"
							;;
						#Load an existing project
						load)
							project=$(loadProject ${UserIn[2]})
							if [ "${project}" != "no" ]; then
								Lang=$(echo ${project} | cut -d ";" -f 1)
								Code=$(echo ${project} | cut -d ";" -f 2)
								CodeDir=$(echo ${project} | cut -d ";" -f 3)
								CodeProject=${UserIn[2]}
								cd ${CodeDir}
								echo "Project \"${CodeProject}\" loaded"
							else
								echo "Not a valid project"
							fi
							;;
						#Display active project
						active)
							#There is no project listed
							if [[ "${CodeProject}" == "none" ]]; then
								echo "There are no active projects"
							#Project is found
							else
								echo "Active Project [\"${CodeProject}\"]"
							fi
							;;
						#List all known projects
						list)
							listProjects
							;;
						#Show Project help page
						*)
							ProjectHelp
							;;
					esac
					;;
				#Swap Programming Languages
				use|c++|java|python|bash)
					Old=${Lang}
					if [ -z "${UserIn[1]}" ]; then
						Lang=$(pgLang ${UserIn[0]})
					else
						Lang=$(pgLang ${UserIn[1]})
					fi
					if [[ ! "${Lang}" == "no" ]]; then
						cLang=$(color ${Lang})
						CodeDir=$(pgDir ${Lang})
						cd ${CodeDir}
						#Rest
						#{
						Code=""
						RunTimeArgs=""
						CodeProject="none"
						#}
					else
						Lang=${Old}
						echo "Possible: ${pLangs}"
					fi
					;;
				#Create new source code
				new)
					#Return the name of source code
					newCode ${Lang} ${UserIn[1]} ${CodeProject} ${UserIn[2]}
					case ${Lang} in
						#Language is Bash
						Bash)
							#Get code
							if [ -f ${BashSrc}/${UserIn[1]}.sh ]; then
								Code=${UserIn[1]}.sh
							elif [ -f ${BashSrc}/${UserIn[1]} ]; then
								Code=${UserIn[1]}
							fi
							;;
						#Language is Python
						Python)
							#Get code
							if [ -f ${PythonSrc}/${UserIn[1]}.py ]; then
								Code=${UserIn[1]}.py
							elif [ -f ${PythonSrc}/${UserIn[1]} ]; then
								Code=${UserIn[1]}
							fi
							;;
						#Language is C++
						C++)
							#Get code
							if [ -f ${CppSrc}/${UserIn[1]}.cpp ]; then
								Code=${UserIn[1]}.cpp
							elif [ -f ${CppSrc}/${UserIn[1]}.h ]; then
								Code=${UserIn[1]}.h
							elif [ -f ${CppSrc}/${UserIn[1]} ]; then
								Code=${UserIn[1]}
							fi
							;;
						#Language is Java
						Java)
							#Get code
							if [ -f ${JavaSrc}/${UserIn[1]}.java ]; then
								Code=${UserIn[1]}.java
							elif [ -f ${JavaSrc}/${UserIn[1]} ]; then
								Code=${UserIn[1]}
							fi
							;;
						*)
							;;
					esac
					;;
				#Edit new source code
				${editor}|edit|ed)
					editCode ${Code} ${UserIn[1]}
					;;
				#Add code to Source Code
				add)
					Code=$(addCode ${Code} ${UserIn[1]})
					;;
				#Read code without editing
				${ReadBy}|read)
					readCode ${Code} ${UserIn[1]}
					;;
				#Swap from Binary to Src and vise-versa
				swap|swp)
					if [[ "${UserIn[1]}" == "bin" ]]; then
						Code=$(SwapToBin ${Code})
					elif [[ "${UserIn[1]}" == "src" ]]; then
						Code=$(SwapToSrc ${Lang} ${Code})
					else
						echo "${mode} (src|bin)"
					fi
					;;
				#git/svn handler
				${repoTool}|repo)
					#Use ONLY for Projects
					if [[ ! "${CodeProject}" == "none" ]]; then
						repoHandler ${UserIn[@]}
					else
						echo "Must have an active project"
					fi
					;;
				#search for element in project
				search)
					lookFor ${CodeProject} ${UserIn[1]}
					;;
				#create various files/vars for running/compiling code
				create)
					#what to create
					case ${UserIn[1]} in
						make)
							#Manage languages
							case ${Lang} in
								#C++ Make file
								C++)
									case ${CodeProject} in
										#No Project
										none)
											echo "Project C++ ONLY"
											;;
										#Is a project
										*)
											#makefile already exists
											if [ -f ${CppSrc}/${CodeProject}/makefile ]; then
												echo "makefile Already made for \"${CodeProject}\""
											#makefile already made
											else
												touch ${CppSrc}/${CodeProject}/makefile
												echo "makefile Created"
											fi
											;;
									esac
									;;
								#Is not C++
								*)
									echo "make files C++ Only"
									;;

							esac
							;;
						jar|manifest)
							#Manage languages
							case ${Lang} in
								#Java Properties
								Java)
									#Enter Java properties
									echo "Java Jar manifest"
									;;
								*)
									echo "Java only"
									;;
							esac
							;;
						#Args for run time
						args)
							echo -n "${cLang}\$ "
							read -a RunTimeArgs
							;;
						#Java properties
						prop|properties|-D)
							#Manage languages
							case ${Lang} in
								#Java Properties
								Java)
									#Enter Java properties
									echo -n "-D"
									read -e EnvArgs
									EnvArgs=$(echo "-D${EnvArgs}")
									#Ensure correct flags
									if [[ "${EnvArgs}" == "-D"*"=\""*"\"" ]]; then
										JavaRunProp=${EnvArgs}
									else
										JavaRunProp=""
									fi
									;;
								*)
									echo "Java only"
									;;
							esac
							;;
						#Clear all
						reset)
							#Default values
							RunTimeArgs=""
							JavaRunProp=""
							echo "All rest"
							;;
						#Show help page
						*)
							CreateHelp ${Lang}
							;;
					esac
					;;
				#Compile code
				compile|cpl)
					compileCode ${Code} ${UserIn[1]}
					#Code=$(SwapToBin ${Code})
					;;
				#Install compiled code into aliases
				install)
					Install ${Lang} ${Code} ${UserIn[1]}
					;;
				#run compiled code
				execute|exe|run)
					RunCode ${Lang} ${Code} ${UserIn[1]}
					;;
				#Display cl[ide] version
				version|v)
					#echo "${Head}"
					#ClideVersion
					CodeVersion ${Lang}
					;;
				#Display help page
				help)
					MenuHelp ${Lang} ${CodeProject}
					;;
				#load last session
				last|load)
					Dir=""
					session=$(LoadSession)
					Lang=$(echo ${session} | cut -d ";" -f 1)
					CodeProject=$(echo ${session} | cut -d ";" -f 2)
					Code=$(echo ${session} | cut -d ";" -f 3)
					if [[ "${CodeProject}" != "none" ]]; then
						Dir="${CodeProject}"
					fi
					#Determine Language
					case ${Lang} in
						#Language is Bash
						Bash)
							#Get code dir
							CodeDir=${BashSrc}/${Dir}
							;;
						#Language is Python
						Python)
							#Get code dir
							CodeDir=${PythonSrc}/${Dir}
							;;
						#Language is C++
						C++)
							#Get code dir
							CodeDir=${CppSrc}/${Dir}
							;;
						#Language is Java
						Java)
							#Get code dir
							CodeDir=${JavaSrc}/${Dir}
							;;
					esac
					#Go to dir
					cd ${CodeDir}
					;;
				#Close cl[ide]
				exit|close)
					SaveSession ${CodeProject} ${Lang} ${Code}
					break
					;;
				#ignore all other commands
				*)
					;;
			esac
		done
	fi
}

#Main Function
main()
{
	#Make sure everything is working
	EnsureLangs
	EnsureDirs
	local pg=$(ColorCodes)
	local UserArg=$1
	#No argument given
	if [ -z "${UserArg}" ]; then
		clear
		CliHelp
		local getLang=""
		#Force user to select language
		while [ "$getLang" == "" ] || [[ "$getLang" == "no" ]];
		do
			echo "~Choose a language~"
			echo -n "${Name}(${pg}):$ "
			read getLang
			#Verify Language
			Lang=$(pgLang ${getLang})
			clear
		done
		#Start IDE
		Actions ${Lang}
	else
		case ${UserArg} in
			#Get version from cli
			-v|--version)
				ClideVersion
				;;
			#Get compile/interpreter version from cli
			-cv|--code-version)
				CodeVersion
				;;
			#Get version control version from cli
			-rv|--repo-version)
				RepoVersion
				;;
			#Get verseion from cli
			-c|--config)
				ClideConfig
				;;
			#List projects from cli
			-p|--projects)
				listProjects
				;;
			#Get cli help page
			-h|--help)
				CliHelp
				;;
			-l|--load|--last)
				session=$(LoadSession)
				Lang=$(echo ${session} | cut -d ";" -f 1)
				Code=$(echo ${session} | cut -d ";" -f 3)
				CodeProject=$(echo ${session} | cut -d ";" -f 2)
				#Start IDE
				Actions ${Lang} ${Code} ${CodeProject}
				;;
			#Check for language given
			*)
				#Verify Language
				Lang=$(pgLang $1)
				#Start IDE
				Actions ${Lang} $2
				;;
		esac
	fi
}

#Run clide
main $@
