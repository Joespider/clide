Shell=$(which bash)
#!${Shell}
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
Version="0.51.01"

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

Project=""
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
	Lang=$1
	project=$2
	echo ""
	echo "----------------[(${Head}) Menu]----------------"
	echo "ls: \"list progams\""
	echo "unset: \"deselect source code\""
	echo "use {Bash|Python|C++|Java}: \"choose language\""
#	echo "swap|swp {src|bin}: \"swap between sorce code and executable\""
	case ${Lang} in
		Bash|Python)
			echo "new <file>: \"create new ${Lang} script\""
			;;
		C++)
			echo "new <file> <type>: \"create new ${Lang} source file\""
			echo "             main: \"create the main ${Lang} file\""
			echo "           header: \"create a ${Lang} header file\""
			echo "        component: \"create a standard ${Lang} file\""
			;;
		Java)
			echo "new <file> <type>: \"create new ${Lang} source file\""
			echo "             main: \"create the main ${Lang} file\""
			echo "        component: \"create a standard ${Lang} file\""
			;;
		*)
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
	echo "compile|cpl: \"make code executable\""
	echo "search: \"search project src files for line of code\""
	echo "execute|exe|run: {-a|--args}: \"run active program\""
	echo "last|load: \"Load last session\""
	echo "exit|close: \"close ide\""
	echo "------------------------------------------------"
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
	echo "-rv|--repo-version: \"Get Compile/Interpreter Version\""
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
		if [[ "${repoAssist}" == "True" ]]; then
			echo "${Head} handles the repo commands"
		elif [[ "${repoAssist}" == "False" ]]; then
			echo "The User is responsible for repo commands"
		else
			echo "repo version control has been disabled"
		fi
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
	Lang=$1
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
	ecd=$1
	sec=$2
	thr=$3
	case $ecd in
		alias)
			echo "\"${sec}\" already installed"
			;;
		install)
			if [[ "${sec}" == "choose" ]]; then
				echo "hint: please choose script"
			else
				echo "\"${sec}\" needs to be an executable"
				echo "[to compile]: cpl"
				echo "OR"
				echo "[swap to executable]: swp bin"
			fi
			;;
		noCode)
			echo "No Code Found"
			echo "[to set code]: set <name>"
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
			if [[ "${sec}" == "none" ]]; then
				echo "Your session MUST be a ${Head} Project"
				echo "hint: Please create or load a project"
				echo "$ project new <project>"
				echo "$ project load <project>"
			elif [[ "${sec}" == "exists" ]]; then
				echo "\"${thr}\" is already a project"
			elif [[ "${sec}" == "NotAProject" ]]; then
				echo "No \"${thr}\" project found"
			else
				echo "Project error"
			fi
			;;
		cpl)
			if [[ "${sec}" == "choose" ]]; then
				echo "hint: please choose script"
			elif [[ "${sec}" == "already" ]]; then
				echo "\"${thr}\" already compiled"
			elif [[ "${sec}" == "not" ]]; then
				echo "code not found"
			else
				echo "Nothing to Compile"
				echo "[to set code]: set <name>"
			fi
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
	project=$1
	search=$2
	if [[ "${project}" == "none" ]]; then
		errorCode "project" "none"
	else
		if [ ! -z "${search}" ]; then
			grep -iR ${search} * | less
		else
			echo "Nothing to search for"
			echo "Please provide a value"
		fi
	fi
}

#Save Last Session
SaveSession()
{
	Session="${ClideDir}/session"
	Language=$1
	Project=$2
	SrcCode=$3
	#Source Needs to be present
	if [ ! -z ${SrcCode} ]; then
		touch ${Session}
		echo "${Project};${Language};${SrcCode}" > ${Session}
	fi
}

#Load Last Session
LoadSession()
{
	Session="${ClideDir}/session"
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
	lang=$1
	project=$2
	path=""
	#No Project is found
	if [ -z ${project} ]; then
		errorCode "project" "none"
	else
		#Grab Project Data
		#Name Value
		echo "name=${project}" > "${ClideDir}/${project}.clide"
		#Language Value
		echo "lang=${lang}" >> "${ClideDir}/${project}.clide"
		#Source Value
		echo "src=" >> "${ClideDir}/${project}.clide"
		#Check if Project dir is made
		if [[ "${lang}" == "Bash" ]]; then
			path=${BashSrc}/${project}
			if [ ! -d ${path} ]; then
				mkdir ${path}
				cd ${path}
				mkdir src bin
				cd ${path}/src
			else
				cd ${path}/src
			fi
		#Python
		elif [[ "${lang}" == "Python" ]]; then
			path=${PythonSrc}/${project}
			if [ ! -d ${path} ]; then
				mkdir ${path}
				cd ${path}
				mkdir src bin
				cd ${path}/src
			else
				cd ${path}/src
			fi
		#C++
		elif [[ "${lang}" == "C++" ]]; then
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
		#Java
		elif [[ "${lang}" == "Java" ]]; then
			path=${JavaSrc}/${project}
			if [ ! -d ${path} ]; then
				mkdir ${path}
				cd ${path}
			else
				cd ${path}
			fi
		fi
	fi
}

#Update config of active Projects
updateProject()
{
	project=$1
	src=$2
	#No Project is found
	if [ ! -z ${src} ]; then
		#Locate Project Directory
		if [ ! -f "${ClideDir}/${project}.clide" ]; then
			errorCode "project" "NotAProject" ${project}
		else
			grep -v "src=" ${ClideDir}/${project}.clide > new
			mv new ${ClideDir}/${project}.clide
			#Grab Project Data
			echo "src=${src}" >> "${ClideDir}/${project}.clide"
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
	project=$1
	path=""
	RtnVals=""
	if [ ! -d "${ClideDir}" ]; then
		errorCode "project"
	else
		if [ -z ${project} ]; then
			echo "no"
		else
			#Locate Project Directory
			if [ -f "${ClideDir}/${project}.clide" ]; then
				#Grab Project Data
				#Name Value
				tag="name"
				name=$(grep ${tag} "${ClideDir}/${project}.clide" | sed "s/${tag}=//g")
				#Language Value
				tag="lang"
				lang=$(grep ${tag} "${ClideDir}/${project}.clide" | sed "s/${tag}=//g")
				#Source Value
				tag="src"
				src=$(grep ${tag} "${ClideDir}/${project}.clide" | sed "s/${tag}=//g")
				#Bash
				if [[ "${lang}" == "Bash" ]]; then
					path=${BashSrc}/${name}/src
				#Python
				elif [[ "${lang}" == "Python" ]]; then
					path=${PythonSrc}/${name}/src
				#C++
				elif [[ "${lang}" == "C++" ]]; then
					path=${CppSrc}/${name}/src
				#Java
				elif [[ "${lang}" == "Java" ]]; then
					path=${JavaSrc}/${name}
				fi
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
	src=$1
	num=$2
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
	src=$1
	new=$2
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
	src=$1
	num=$2
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
	Lang=$1
	name=$2
	oldCode=$3
	Project=$4
	Type=$5
	Type=$(echo ${Type} | tr A-Z a-z)
	#Bash
	if [[ "${Lang}" == "Bash" ]]; then
		if [[ "${name}" == *".sh" ]]; then
			touch ${name}
			echo "#!/bin/bash" > ${name}
			echo "" >> ${name}
			echo "${name}"
		else
			touch "${name}.sh"
			echo "#!/bin/bash" > "${name}.sh"
			echo "" >> "${name}.sh"
			echo "${name}.sh"
		fi
	#Python
	elif [[ "${Lang}" == "Python" ]]; then
		if [[ "${name}" == *".py" ]]; then
			touch "${name}"
			echo "${name}"
		else
			touch "${name}.py"
			echo "${name}.py"
		fi
	#C++
	elif [[ "${Lang}" == "C++" ]]; then
		if [ ! -f "${name}.cpp" ]; then
			if [ -f "${CppBin}/newC++" ]; then
				case ${Type} in
					#create header file
					header)
						if [[ "${name}" == *".h" ]];then
							touch "${name}"
							echo "${name}"
						else
							touch "${name}.h"
							echo "${name}.h"
						fi
						;;
					#create main file
					main)
						${CppBin}/newC++ -w -r -cli --main -i -u -n "${name}"
						echo "${name}.cpp"
						;;
					#create component file
					component)
						${CppBin}/newC++ -n "${name}"
						echo "${name}.cpp"
						;;
					*)
						if [[ "${Project}" == "none" ]]; then
							newCode ${Lang} ${name} ${oldCode} ${Project} "main"
						else
							if [[ "${oldCode}" == *".cpp" ]] || [[ "${oldCode}" == *".cpp" ]]; then
								newCode ${Lang} ${name} ${oldCode} ${Project} "component"
							else
								newCode ${Lang} ${name} ${oldCode} ${Project} "main"
							fi
						fi
						;;
					esac
			else
				echo "${oldCode}"
			fi
		else
			echo "${oldCode}"
		fi
	#Java
	elif [[ "${Lang}" == "Java" ]]; then
		if [ ! -f "${name}.java" ]; then
			if [ -f "${JavaBin}/newJava.class" ]; then
				case ${Type} in
					#create main file
					main)
						cd ${JavaBin}
						java newJava --user $USER --main -w -r -u -n "${name}"
						cd - > /dev/null
						mv "${JavaBin}/${name}.java" .
						echo "${name}.java"
						;;
					#create component file
					component)
						cd ${JavaBin}
						java newJava --user $USER -w -r -n "${name}"
						cd - > /dev/null
						mv "${JavaBin}/${name}.java" .
						echo "${name}.java"
						;;
					*)
						#main class already created
						if [[ "${oldCode}" == *".java" ]]; then
							#Create libary class
							newCode ${Lang} ${name} ${oldCode} ${Project} "component"
						else
							newCode ${Lang} ${name} ${oldCode} ${Project} "main"
						fi
						;;
				esac
			else
				echo "${oldCode}"
			fi
		else
			echo "${oldCode}"
		fi
	else
		echo "${oldCode}"
	fi
}

#remove source code
Remove()
{
	active=$1
	src=$2
	option=$3
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
	Lang=$1
	name=$2
	option=$3
	Args=""
	if [[ "${name}" == *","* ]]; then
		echo "${Head} can only handle ONE file"
	else
		#Adjust for C++ code
		if [[ "${Lang}" == "C++" ]]; then
			TheBin="${name%.*}"
		#Adjust for Java code
		elif [[ "${Lang}" == "Java" ]]; then
			TheBin="${name%.*}.class"
		#Bash and Python
		else
			TheBin="${name}"
		fi

		#Come up with a way to know if arguments are needed
		TheLang=$(color "${Lang}")
		TheName=$(color "${TheBin}")
		if [[ "${option}"  == "-a" ]] || [[ "${option}"  == "--args" ]]; then
			echo "[Provide cli arguments]"
			if [[ "${Lang}" == "Python" ]]; then
			echo -n "$USER@${Name}:~/${TheLang}\$ ${PythonRun} ${TheName} "
			elif [[ "${Lang}" == "Java" ]]; then
				echo -n "$USER@${Name}:~/${TheLang}\$ java ${TheName} "
			else
				echo -n "$USER@${Name}:~/${TheLang}\$ ./${TheName} "
			fi
			read -a Args
		fi
		#Bash
		if [[ "${Lang}" == "Bash" ]]; then
			#Check if Bash Script exists
			if [ -f "${BashBin}/${name}" ]; then
				${BashBin}/${name} ${Args[@]}
			else
				echo "${name} is not compiled"
				echo "[HINT] \$ cpl"
			fi
		#Python
		elif [[ "${Lang}" == "Python" ]]; then
			#Check if Pythin Bin exists
			if [ -f "${PythonBin}/${TheBin}" ]; then
				${PythonRun} ${PythonBin}/${TheBin} ${Args[@]}
			else
				echo "${name} is not compiled"
				echo "[HINT] \$ cpl"

			fi
		#C++
		elif [[ "${Lang}" == "C++" ]]; then
			#Check if C++ Bin exists
			if [ -f "${CppBin}/${TheBin}" ]; then
				${CppBin}/${TheBin} ${Args[@]}
			else
				echo "${name} is not compiled"
				echo "[HINT] \$ cpl"
			fi
		#Java
		elif [[ "${Lang}" == "Java" ]]; then
			#Check if Java Class exists
			if [ -f "${JavaBin}/${TheBin}" ]; then
				TheBin=${TheBin%.*}
				cd ${JavaBin}
				${JavaRun} ${TheBin} ${Args[@]}
				cd ${JavaSrc}
				#cd -
			else
				echo "${name} is not compiled"
				echo "[HINT] \$ cpl"
			fi
		fi
	fi
}

selectCode()
{
	code=$1
	name=$2
	old=$3
	#bash
	if [[ "${code}" == "Bash" ]]; then
		#Correct filename
		if [[ ! "${name}" == *".sh" ]] && [[ ! "${name}" == "clide" ]]; then
			name="${name}.sh"
		fi
	#Python
	elif [[ "${code}" == "Python" ]]; then
		#Correct filename
		if [[ ! "${name}" == *".py" ]]; then
			name="${name}.py"
		fi
	#C++
	elif [[ "${code}" == "C++" ]]; then
		#Correct filename
		if [[ ! "${name}" == *".cpp" ]] && [ -f "${name}.cpp" ]; then
			name="${name}.cpp"
		elif [[ ! "${name}" == *".h" ]] && [ -f "${name}.h" ]; then
			name="${name}.h"
		fi
	#Java
	elif [[ "${code}" == "Java" ]]; then
		#Correct filename
		if [[ ! "${name}" == *".java" ]]; then
			name="${name}.java"
		fi
	fi

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
	code=$1
	#Bash
	if [[ "${code}" == "Bash" ]]; then
		#Return Bash src Dir
		echo ${BashSrc}
	#Python
	elif [[ "$code" == "Python" ]]; then
		#Return Python src Dir
		echo ${PythonSrc}
	#C++
	elif [[ "$code" == "C++" ]]; then
		#Return C++ src Dir
		echo ${CppSrc}
	#Java
	elif [[ "$code" == "Java" ]]; then
		#Return Java src Dir
		echo ${JavaSrc}
	#No Languge found
	else
		#Return rejection
		echo "no"
	fi
}

#get Language Name
pgLang()
{
	Lang=$(echo "$1" | tr A-Z a-z)
	#bash
	if [[ "${Lang}" == "b" ]] || [[ "${Lang}" == "bash" ]]; then
		if [ ! -z "${BashCpl}" ]; then
			#Return Bash tag
			echo "Bash"
		else
			#Return rejection
			echo "no"
		fi
	#Python
	elif [[ "${Lang}" == "p" ]] || [[ "${Lang}" == "python" ]]; then
		if [ ! -z "${PythonRun}" ]; then
			#Return Python tag
			echo "Python"
		else
			#Return rejection
			echo "no"
		fi
	#C++
	elif [[ "${Lang}" == "c" ]] || [[ "${Lang}" == "c++" ]]; then
		if [ ! -z "${CppCpl}" ]; then
			#Return C++ tag
			echo "C++"
		else
			#Return rejection
			echo "no"
		fi
	#Java
	elif [[ "${Lang}" == "j" ]] || [[ "${Lang}" == "java" ]]; then
		if [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
			#Return Java tag
			echo "Java"
		else
			#Return rejection
			echo "no"
		fi
	#No Languge found
	else
		#Return rejection
		echo "no"
	fi
}

#Color Text
color()
{
	text=$1
	#bash
	if [[ "${text}" == "Bash" ]]; then
		#Return Green
		echo -e "\e[1;32m${text}\e[0m"
	#Python
	elif [[ "${text}" == "Python" ]]; then
		#Return Yellow
		echo -e "\e[33m${text}\e[0m"
	#C++
	elif [[ "${text}" == "C++" ]]; then
		#Return Blue
		echo -e "\e[1;34m${text}\e[0m"
	#Java
	elif [[ "${text}" == "Java" ]]; then
		#Return Red
		echo -e "\e[1;31m${text}\e[0m"
	#Other
	else
		#Return Purple
		echo -e "\e[1;35m${text}\e[0m"
	fi
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
	TheFile=$1
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
	AliasName=$1
	Command="$2 $3"
	Insert="alias ${AliasName}=\"${Command} \$@\""
	if [[ "$USER" == "root" ]]; then
		Replace="\\$HOME\\/"
	else
		Replace="\\/home\\/$USER\\/"
	fi
	With="\~\\/"
	CheckFor=$(echo ${Insert} | sed "s/${Replace}/${With}/g")
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
	code=$1
	bin=$2
	#bash
	if [[ "${bin}" == *".sh" ]]; then
		#Get Finary file name without extension
		BinFile="${bin%.*}"
		#Make sure Binary exists
		if [[ -f "${BashBin}/${bin}" ]]; then
			#Add command to Aliases
			AddAlias "${BinFile}" "${BashBin}/${bin}"
		else
			errorCode "install" "${bin}"
		fi
	#Python
	elif [[ "${bin}" == *".py" ]]; then
		#Get Finary file name without extension
		BinFile="${bin%.*}"
		#Make sure Binary exists
		if [[ -f "${PythonBin}/${bin}" ]]; then
			#Add command to Aliases
			AddAlias "${BinFile}" "python ${PythonBin}/${bin}"
		else
			errorCode "install" "${bin}"
		fi
	#C++ Binary
	elif [[ "${code}" == "C++" ]]; then
		#Make sure Binary exists
		if [[ -f "${CppBin}/${bin}" ]]; then
			#Add command to Aliases
			AddAlias "${bin}" "${CppBin}/${bin}"
		else
			errorCode "install" "${bin}"
		fi
	#C++ Source Code
	elif [[ "${bin}" == *".cpp" ]]; then
		errorCode "install" "${bin}"
	#Java binary
	elif [[ "${bin}" == *".class" ]]; then
		#Get Finary file name without extension
		BinFile="${bin%.*}"
		if [[ -f "${JavaBin}/${bin}" ]]; then
			AddAlias "${BinFile}" "${JavaBin}/${bin}"
		else
			errorCode "install" "${bin}"
		fi
	#Java Source Code
	elif [[ "${bin}" == *".java" ]]; then
		errorCode "install" "${bin}"
	#Not found
	else
		errorCode "noCode"
	fi
}

#Compile code
compileCode()
{
	src=$1
	project=$2
	num=$3
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
			if [ -z ${num} ]; then
				errorCode "cpl" "choose"
			else
				#chosen file is in the list of files
				if [[ "${src}" == *"${num}"* ]]; then
					#only name is given
					if [[ "${num}" != *".sh" ]]; then
						#full filename given
						num=${num}.sh
					fi
					#Make Bash Script executable
					chmod +x ${num}
					#Check if Bash Script does NOT exist
					if [[ ! -f "${BashBin}/${num}" ]]; then
						#Change to Bash Binary dir
						cd ${BashBin}
						#Create Symbolic Link to Bash Script
						ln -s ../src/${project}${num}
						#Change to Bash Source dir
						cd "${BashSrc}/${project}"
						echo "[Bash Code Compiled]"
					else
						errorCode "cpl" "already" ${num}
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
				echo "[Bash Code Compiled]"
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
			if [ -z ${num} ]; then
				errorCode "cpl" "choose"
			#variable found
			else
				#chosen file is in the list of files
				if [[ "${src}" == *"${num}"* ]]; then
					#only name is given
					if [[ "${num}" != *".py" ]]; then
						#full filename given
						num=${num}.py
					fi
					#Make Python Script executable
					chmod +x ${num}
					#Check if Python Script does NOT exist
					if [[ ! -f "${PythonBin}/${num}" ]]; then
						#Change to Python Binary dir
						cd ${PythonBin}
						#Create Symbolic Link to Python Script
						ln -s ../src/${project}${num}
						#Change to Python Source dir
						cd "${PythonSrc}/${project}"
						echo "[Python Code Compiled]"
					else
						errorCode "cpl" "already" ${num}
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
				echo "[Python Code Compiled]"
			#Code is already found
			else
				errorCode "cpl" "already" ${src}
			fi
		fi
	#C++
	elif [[ "$src" == *".cpp"* ]]; then
		#Multiple code selected
		if [[ "${src}" == *","* ]]; then
			#num is empty
			if [ -z ${num} ]; then
				errorCode "cpl" "choose"
			else
				#Separate list of selected code
				prog=$(echo ${src} | sed "s/,/ /g")
				#Compile and move C++ to Binary dir
				if [[ "${project}" == *"/" ]]; then
					${CppCpl} ${prog} -o ../../bin/${num}
				else
					${CppCpl} ${prog} -o ../bin/${num}
				fi
				echo "[C++ Code Compiled]"
			fi
		#single code selected
		else
			#Compile and move C++ to Binary dir
			if [[ "${project}" == *"/" ]]; then
				${CppCpl} ${src} -o ../../bin/${src%.*}

			else
				${CppCpl} ${src} -o ../bin/${src%.*}
			fi
			echo "[C++ Code Compiled]"
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
				#move Java Class to Binary dir
				mv ${des} ../bin/
				echo "[Java Code Compiled]"
			fi
		fi
	#Not found
	else
		errorCode "cpl"
	fi
}

gitHandler()
{
	repoAct=$1
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
	repoAct=$1
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
	if [[ "${repoTool}" == "git" ]]; then
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
	elif [[ "${repoTool}" == "svn" ]]; then
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
	else
		echo "${Head} is unable to use \"${repoTool}\" at this time"
	fi
}

#Switch to Src file
SwapToSrc()
{
	Lang=$1
	src=$2
	#bash
	if [[ "${Lang}" == "Bash" ]]; then
		echo "${src}"
	#Python
	elif [[ "${Lang}" == "Python" ]]; then
		#Get Python Name
	#	src="${src}.py"
	#	#Check if Python source exists
	#	if [[ -f "${PythonSrc}/${src}" ]]; then
	#		#Return Python Source Name
			echo "${src}"
	#	fi
	#C++
	elif [[ "${Lang}" == "C++" ]]; then
		#cd "${CppSrc}"
		#Get C++ Name
		src="${src}.cpp"
		#Check if C++ source exists
		if [ -f "${CppSrc}/${src}" ]; then
			#Return C++ Source Name
			echo "${src}"
		fi
	#Java
	elif [[ "${Lang}" == "Java" ]]; then
		#cd "${JavaSrc}"
		#Get Java Name
		src="${src%.*}.java"
		#Check if Java source exists
		if [ -f "${JavaSrc}/${src}" ]; then
			#Return Java Source Name
			echo "${src}"
		fi
	else
		echo "${src}"
	fi
}

#Switch to Bin file
SwapToBin()
{
	bin=$1
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
	Dir=""
	ProjectDir=""
	Lang=$1
	CodeDir=$(pgDir ${Lang})
	pLangs=$(ColorCodes)
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
			read -a UserIn
			case ${UserIn[0]} in
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
				pwd)
					#Use ONLY for Projects
					if [[ ! "${CodeProject}" == "none" ]]; then
						here=$(pwd)/
						echo ${here#*${CodeProject}}
					else
						echo "Must have an active project"
					fi
					;;
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
					#Create new project
					if [ "${UserIn[1]}" == "new" ]; then
						if [[ "${Lang}" == "Java" ]]; then
							echo "${Head} Cannot handle Java Projects"
						else
							#Locate Project Directory
							if [ -f "${ClideDir}/${UserIn[2]}.clide" ]; then
								errorCode "project" "exists" ${UserIn[2]}
							else
								newProject ${Lang} ${UserIn[2]}
								updateProject ${UserIn[2]} ${Code}
								if [ ! -z ${UserIn[2]} ]; then
									CodeProject=${UserIn[2]}
									echo "Created \"${CodeProject}\""
								fi
							fi
						fi
					#Update live project
					elif [ "${UserIn[1]}" == "update" ]; then
						updateProject ${CodeProject} ${Code}
						echo "\"${CodeProject}\" updated"
					#Load an existing project
					elif [ "${UserIn[1]}" == "load" ]; then
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
#					#Display active project
#					elif [ "${UserIn[1]}" == "active" ]; then
#						if [[ "${CodeProject}" == "none" ]]; then
#							echo "There are no active projects"
#						else
#							echo "Active Project [\"${CodeProject}\"]"
#						fi
					#List all known projects
					elif [ "${UserIn[1]}" == "list" ]; then
						listProjects
					else
						ProjectHelp
					fi
					;;
				#Swap Programming Languages
				use)
					Old=${Lang}
					Lang=$(pgLang ${UserIn[1]})
					if [[ ! "${Lang}" == "no" ]]; then
						cLang=$(color ${Lang})
						CodeDir=$(pgDir ${Lang})
						cd ${CodeDir}
						Code=""
						CodeProject="none"
					else
						Lang=${Old}
						echo "Possible: ${pLangs}"
					fi
					;;
				#Create new source code
				new)
					Code=$(newCode ${Lang} ${UserIn[1]} ${Code} ${CodeProject} ${UserIn[2]})
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
#				swap|swp)
#					if [[ "${UserIn[1]}" == "bin" ]]; then
#						Code=$(SwapToBin ${Code})
#					elif [[ "${UserIn[1]}" == "src" ]]; then
#						Code=$(SwapToSrc ${Lang} ${Code})
#					else
#						echo "${mode} (src|bin)"
#					fi
#					;;
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
				#Compile code
				compile|cpl)
					compileCode ${Code} ${CodeProject} ${UserIn[1]}
					#Code=$(SwapToBin ${Code})
					;;
				#Install compiled code into aliases
				install)
					Install ${Lang} ${Code} ${UserIn[1]}
					;;
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
					case ${Lang} in
						Bash)
							CodeDir=${BashSrc}/${Dir}
							;;
						Python)
							CodeDir=${PythonSrc}/${Dir}
							;;
						C++)
							CodeDir=${CppSrc}/${Dir}
							;;
						Java)
							CodeDir=${JavaSrc}/${Dir}
							;;
					esac
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
	EnsureLangs
	EnsureDirs
	pg=$(ColorCodes)
	#No argument given
	if [ -z "$1" ]; then
		clear
		CliHelp
		getLang=""
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
	#Get version from cli
	elif [[ "$1" == "-v" ]] || [[ "$1" == "--version" ]]; then
		ClideVersion
	#Get compile/interpreter version from cli
	elif [[ "$1" == "-cv" ]] || [[ "$1" == "--code-version" ]]; then
		CodeVersion
	#Get version control version from cli
	elif [[ "$1" == "-rv" ]] || [[ "$1" == "--repo-version" ]]; then
		RepoVersion
	#Get verseion from cli
	elif [[ "$1" == "-c" ]] || [[ "$1" == "--config" ]]; then
		ClideConfig
	#List projects from cli
	elif [[ "$1" == "-p" ]] || [[ "$1" == "--projects" ]]; then
		listProjects
	#Get cli help page
	elif [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
		CliHelp
	elif [[ "$1" == "-l" ]] || [[ "$1" == "--load" ]] || [[ "$1" == "--last" ]]; then
		session=$(LoadSession)
		Lang=$(echo ${session} | cut -d ";" -f 1)
		Code=$(echo ${session} | cut -d ";" -f 3)
		CodeProject=$(echo ${session} | cut -d ";" -f 2)
		#Start IDE
		Actions ${Lang} ${Code} ${CodeProject}
	#Check for language given
	else
		#Verify Language
		Lang=$(pgLang $1)
		#Start IDE
		Actions ${Lang} $2
	fi
}

#Run clide
main $@
