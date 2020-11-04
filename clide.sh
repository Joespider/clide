Shell=$(which bash)
#!${Shell}

#cl[ide] future features
#{
	#provide X11 support via -lX11 g++ flag
#}

#Version tracking
#Increment by 1 number per category
#1st # = Overflow
#2nd # = Additional features
#3rd # = Bug/code tweaks/fixes
Version="0.65.83"

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
PerlRun=perl
RubyRun=ruby
CppCpl=g++
JavaCpl=javac
JavaRun=java

#root dir
ProgDir=~/Programs
ClideDir=${ProgDir}/.clide
NotesDir=${ClideDir}/notes
LangsDir=${ClideDir}/langs

#Program Homes
BashHome=${ProgDir}/Bash
PythonHome=${ProgDir}/Python
PerlHome=${ProgDir}/Perl
RubyHome=${ProgDir}/Ruby
CppHome=${ProgDir}/C++
JavaHome=${ProgDir}/Java

#Soruce Code
BashSrc=${BashHome}/src
PythonSrc=${PythonHome}/src
PerlSrc=${PerlHome}/src
RubySrc=${RubyHome}/src
CppSrc=${CppHome}/src
JavaSrc=${JavaHome}/src

#Bin Code
BashBin=${BashHome}/bin
PythonBin=${PythonHome}/bin
PerlBin=${PerlHome}/bin
RubyBin=${RubyHome}/bin
CppBin=${CppHome}/bin
JavaBin=${JavaHome}/bin

#Global Vars
#{
Project=""
CodeProject="none"
RunTimeArgs=""
JavaRunProp=""
CppCplVersion=""
declare -A Commands
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
	echo -e "ls\t\t\t\t: \"list progams\""
	echo -e "unset\t\t\t\t: \"deselect source code\""
	echo -e "use <language> <code>\t\t: \"choose language\""
	echo -e "swap|swp {src|bin}\t\t: \"swap between sorce code and executable\""
	echo -e "create <arg>\t\t\t: \"create compile and runtime arguments"
	ManageLangs ${Lang} "MenuHelp"
	echo -e "rm|remove|delete\t\t: \"delete src file\""
	echo -e "set <file>\t\t\t: \"select source code\""
	echo -e "add <file>\t\t\t: \"add new file to project\""
	echo -e "notes <action>\t\t\t: \"make notes for the ${Lang} language\""
	echo -e "${editor}|edit|ed\t\t\t: \"edit source code\""
	echo -e "${ReadBy}|read\t\t\t: \"Read source code\""
	echo -e "search <find>\t\t\t: \"search for code in project\""
	case ${project} in
		none)
			echo -e "project {new|list|load}\t\t: \"handle projects\""
			;;
		*)
#			echo -e "project {new|update|list|load|active}\t: \"handle projects\""
			echo -e "project {new|update|list|load}\t: \"handle projects\""
			echo -e "${repoTool}|repo\t: \"handle repos\""
			;;
	esac
	echo -e "search\t\t\t\t: \"search project src files for line of code\""
	echo -e "execute|exe|run {-a|--args}\t: \"run active program\""
	echo -e "last|load\t\t\t: \"Load last session\""
	echo -e "exit|close\t\t\t: \"close ide\""
	echo "------------------------------------------------"
	echo ""
}

CreateHelp()
{
	local Lang=$1
	echo ""
	echo "----------------[(${Head}) \"Create\" Help]----------------"
	echo -e "args\t\t\t: create custom args"
	ManageLangs ${Lang} "CreateHelp"
	echo -e "reset\t\t\t: clear all"
	echo "---------------------------------------------------------"
	echo ""
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
	echo -e "list\t\t\t\t: \"List ALL projects\""
	echo -e "active\t\t\t\t: \"Display the name of the current project\""
	echo "----------------------------------------------------------"
	echo ""
}

NotesHelp()
{
	local Lang=$1
	echo ""
	echo "----------------[(${Head}) \"Notes\" Help]----------------"
	echo -e "edit|add\t\t: \"edit notes\""
	echo -e "read\t\t: \"read notes\""
	echo "----------------------------------------------------------"
	echo ""

}

newCodeHelp()
{
	local Lang=$1
	echo ""
	echo "----------------[(${Head}) \"new\" Help]----------------"
	echo -e "--version|-v\t\t\t: \"Get Version for each code template\""
	echo -e "--help|-h\t\t\t: \"This page\""
	ManageLangs ${Lang} "newCodeHelp"
	echo -e "<code>\t\t\t\t: \"provide code name; default settings\""
	echo "----------------------------------------------------------"
	echo ""
}

#Clide cli help page
CliHelp()
{
	echo ""
	echo "----------------[(${Head}) CLI]----------------"
	echo -e "-v |--version\t\t\t: \"Get Clide Version\""
	echo -e "-cv|--code-version\t\t: \"Get Compile/Interpreter Version\""
	echo -e "-tv|--temp-version\t\t: \"Get Code Template Version\""
	echo -e "-rv|--repo-version\t\t: \"Get git/svn Version\""
	echo -e "-c |--config\t\t\t: \"Get Clide Config\""
	echo -e "-p |--projects\t\t\t: \"List Clide Projects\""
	echo -e "-h |--help\t\t\t: \"Get CLI Help Page (Cl[ide] Menu: \"help\")\""
	echo -e "-l |--last|--load\t\t: \"Load last session\""
	echo "-----------------------------------------------"
	echo -e "$ clide <language> <code>\t: start clide"
	echo -e "$ clide java program.java\t: start clide using java and program.java"
	echo -e "$ clide java\t\t\t: start clide using java"
	echo ""
}

#Language not yet supported
UseOther()
{
	local Lang=$1
	shift
	local Type=$1
	shift
	local Args=$@
	case ${Type} in
		color)
			local text=${Lang}
			#Return Purple
			echo -e "\e[1;35m${text}\e[0m"
			;;
		MenuHelp)
			echo -e "compile|cpl\t: \"make code executable\""
			;;
		#No Languge found
		pgLang|pgDir)
			#Return rejection
			echo "no"
			;;
		CreateHelp)
			;;
		newCodeHelp)
			;;
		compileCode)
			errorCode "cpl"
			;;
		TemplateVersion)
			echo "Please Choose a Language"
			;;
		SwapToSrc|SwapToBin)
			echo "${Args[0]}"
			;;
		Install)
			errorCode "noCode"
			;;
		*)
			;;
	esac
}

#Select Languge
ManageLangs()
{
	local Langs=$(echo $1 | tr A-Z a-z)
	#Make first letter uppercase
	Langs=${Langs^}
	shift
	local Manage=$@
	if [ -f ${LangsDir}/Lang.${Langs} ]; then
		${LangsDir}/Lang.${Langs} ${ProgDir} ${ClideDir} ${editor} ${ReadBy} ${Manage[@]}
	else
		UseOther ${Langs} ${Manage[@]}
	fi
}

EnsureDirs()
{
	#If missing...create "Programs" dir
	if [ ! -d "${ProgDir}" ]; then
		mkdir "${ProgDir}"
	fi

	if [ ! -d "${ClideDir}" ]; then
		mkdir "${ClideDir}"
	fi

	if [ ! -d "${NotesDir}" ]; then
		mkdir "${NotesDir}"
	fi

	if [ ! -d "${LangsDir}" ]; then
		mkdir "${LangDir}"
	fi

	local Langs=$(ls ${LangsDir}/ | sed "s/Lang.//g" | tr '\n' '|' | rev | sed "s/|//1" | rev)
	local NumOfLangs=$(ls | wc -l)
	local look=1
	local text
	while [ ${look} -le ${NumOfLangs} ];
	do
		text=$(echo ${Langs} | cut -d '|' -f ${look})
		text=$(ManageLangs ${text} "pgLang")
		case ${text} in
			no)
				;;
			*)
				ManageLangs "${text}" "EnsureDirs"
				;;
		esac
		look=$((${look}+1))
	done
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
	local TheLang=$1
	local Langs=""
	if [ ! -z "${TheLang}" ]; then
		ManageLangs ${TheLang} "TemplateVersion"
	else
		Langs=$(ls ${LangsDir}/ | sed "s/Lang.//g" | tr '\n' '|' | rev | sed "s/|//1" | rev)
		local NumOfLangs=$(ls | wc -l)
		local look=1
		local text
		while [ ${look} -le ${NumOfLangs} ];
		do
			text=$(echo ${Langs} | cut -d '|' -f ${look})
			text=$(ManageLangs ${text} "pgLang")
			case ${text} in
				no)
					;;
				*)
					ManageLangs "${text}" "TemplateVersion" | sed "s/Version:/${text}:/g"
					;;
			esac
			look=$((${look}+1))
		done
	fi
}

Banner()
{
	Art
	echo "(${Version})"
	echo ""
	echo "\"Welcome to ${Head}\""
	echo "\"The command line IDE for the Linux/Unix user\""
}

#Error messages
errorCode()
{
	${ClideDir}/errorCode.sh $@
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
				errorCode "lookFor" "none"
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

importProject()
{
	local Lang=$1
	local Name=$2
	local Path=$3
	if [ ! -z "${Name}" ]; then
		if [ ! -f ${ClideDir}/${Name}.clide ]; then
			if [ -z "${Path}" ]; then
				echo -n "Import Project \"${Name}\" from : "
				read Path
			fi

			if [ -z "${Path}" ]; then
				echo "no path Given"
			else
				case ${Path} in
					*${Name}|*${Name}/)
						echo "name=${Name}" > ${ClideDir}/${Name}.clide
						echo "lang=${Lang}" >> ${ClideDir}/${Name}.clide
						echo "path=${Path}" >> ${ClideDir}/${Name}.clide
						echo "src=" >> ${ClideDir}/${Name}.clide
						echo "Project \"${Name}\" Imported"
						;;
					*)
						echo "${Name} must be in the directory of \"${Path}\""
						;;
				esac
			fi
		else
			echo "You Already have a project named \"${Name}\""
		fi
	else
		echo "import help"
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
		#Create Project and get path
		path=$(ManageLangs ${Lang} "newProject")
		#Path Value
		echo "path=${path}" >> ${ClideDir}/${project}.clide
		#Source Value
		echo "src=" >> ${ClideDir}/${project}.clide
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
			#Incorperate sed instead of what you're doing
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
	local tag=""
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
				tag="name="
				name=$(grep ${tag} ${ClideDir}/${project}.clide | sed "s/${tag}//g")
				#Language Value
				tag="lang="
				lang=$(grep ${tag} ${ClideDir}/${project}.clide | sed "s/${tag}//g")
				#Source Value
				tag="path="
				path=$(grep ${tag} ${ClideDir}/${project}.clide | sed "s/${tag}//g")
				#Source Value
				tag="src="
				src=$(grep ${tag} ${ClideDir}/${project}.clide | sed "s/${tag}//g")
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

#remove source code
Remove()
{
	local active=$1
	local src=$2
	local option=$3
	if [ ! -z "${src}" ]; then
		case  ${src} in
			--force)
				src=${option}
				option="--force"
				;;
			*)
				;;
		esac
		if [ *"${src}"* == "${active}" ]; then
			if [ -f ${src} ]; then
				if [ "${option}" == "--force" ]; then
					rm ${src}
					echo "\"${src}\" is REMOVED"
				else
					clear
					errorCode "remove" "sure"
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
					errorCode "remove" "hint"
				fi
			else
				echo "\"${src}\" not a file"
			fi
		else
			echo "\"${src}\" not a file"
		fi
	fi
}

runCode()
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
					Perl)
						CLIout="$USER@${Name}:~/${TheLang}\$ ${PerlRun} ${TheName}"
						;;
					Ruby)
						CLIout="$USER@${Name}:~/${TheLang}\$ ${RubyRun} ${TheName}"
						;;
					Java)
						if [ ! -z "${JavaProp}" ]; then
							#Its a Class
							if [ -f ${JavaBin}/${TheBin} ]; then
								CLIout="$USER@${Name}:~/${TheLang}\$ java ${JavaProp} ${TheName}"
							#Its a Jar
							elif [ -f ${JavaBin}/${TheJar} ]; then
								CLIout="$USER@${Name}:~/${TheLang}\$ java -jar ${TheNameJar}"
							fi
						else
							#Its a Class
							if [ -f ${JavaBin}/${TheBin} ]; then
								CLIout="$USER@${Name}:~/${TheLang}\$ java ${TheName}"
							#Its a Jar
							elif [ -f ${JavaBin}/${TheJar} ]; then
								CLIout="$USER@${Name}:~/${TheLang}\$ java -jar ${TheNameJar}"
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
					errorCode "cpl" "need" "${name}"
				fi
				;;
			#Python
			Python)
				#Check if Pythin Bin exists
				if [ -f ${PythonBin}/${TheBin} ]; then
					${PythonRun} ${PythonBin}/${TheBin} ${Args[@]}
				else
					errorCode "cpl" "need" "${name}"
				fi
				;;
			#Perl
			Perl)
				#Check if Perl Bin exists
				if [ -f ${PerlBin}/${TheBin} ]; then
					${PerlRun} ${PerlBin}/${TheBin} ${Args[@]}
				else
					errorCode "cpl" "need" "${name}"
				fi
				;;
			#Ruby
			Ruby)
				#Check if Ruby Bin exists
				if [ -f ${RubyBin}/${TheBin} ]; then
					${RubyRun} ${RubyBin}/${TheBin} ${Args[@]}
				else
					errorCode "cpl" "need" "${name}"
				fi
				;;
			#C++
			C++)
				#Check if C++ Bin exists
				if [ -f ${CppBin}/${TheBin} ]; then
					${CppBin}/${TheBin} ${Args[@]}
				else
					errorCode "cpl" "need" "${name}"
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
					errorCode "cpl" "need" "${name}"
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
	name=$(ManageLangs ${code} "selectCode" ${name})
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
	ManageLangs ${code} "pgDir" ${name}
}

#get Language Name
pgLang()
{
	local Lang=$(echo "$1" | tr A-Z a-z)
	ManageLangs ${Lang} "pgLang"
}

#Color Text
color()
{
	local text=$1
	ManageLangs ${text} "color"
}

ColorCodes()
{
	local Langs=$(ls ${LangsDir}/ | sed "s/Lang.//g" | tr '\n' '|' | rev | sed "s/|//1" | rev)
	local NumOfLangs=$(ls | wc -l)
	local look=1
	local text
	local TheColor
	local ChosenLangs=""
	while [ ${look} -le ${NumOfLangs} ];
	do
		text=$(echo ${Langs} | cut -d '|' -f ${look})
		text=$(ManageLangs ${text} "pgLang")
		case ${text} in
			no)
				;;
			*)
				TheColor=$(color ${text})
				if [ -z "${ChosenLangs}" ]; then
					ChosenLangs=${TheColor}
				else
					ChosenLangs="${ChosenLangs} ${TheColor}"
				fi
				;;
		esac
		look=$((${look}+1))
	done
	echo ${ChosenLangs}
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
			sed  -i "s/${Replace}/${With}/g" ${Aliases}
			echo "\"${AliasName}\" installed"
		fi
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

#IDE
Actions()
{
	loadAuto
	local Dir=""
	local ProjectDir=""
	local Lang=$1
	local CodeDir=$(pgDir ${Lang})
	local pLangs=$(ColorCodes)
	local prompt=""
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
		Code=$(selectCode ${Lang} ${Code})
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
					prompt="${Name}(${cLang}):$ "
				else
					ThePWD=$(pwd)
					ProjectDir=$(echo ${ThePWD#*${CodeProject}} | sed "s/\//:/1")
					cCodeProject=$(echo -e "\e[1;40m${CodeProject}\e[0m")
					#Menu with no code
					prompt="${Name}(${cLang}[${cCodeProject}${ProjectDir}]):$ "
				fi
			else
				if [[ "${CodeProject}" == "none" ]]; then
					#Menu with code
					cCodeProject=$(echo -e "\e[1;40m${CodeProject}\e[0m")
					prompt="${Name}(${cLang}{${cCode}}):$ "
				else
					ThePWD=$(pwd)
					ProjectDir=$(echo ${ThePWD#*${CodeProject}} | sed "s/\//:/1")
					#Menu with no code
					cCodeProject=$(echo -e "\e[1;40m${CodeProject}\e[0m")
					prompt="${Name}(${cLang}[${cCodeProject}${ProjectDir}]{${cCode}}):$ "
				fi
			fi
			#Handle CLI
			#read -a UserIn
			read -e -p "${prompt}" -a UserIn
			UserArg=$(echo ${UserIn[0]} | tr A-Z a-z)
			if [ ! -z "${UserIn[0]}" ]; then
				history -s "${UserIn[@]}"
			fi
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
					case ${CodeProject} in
						none)
							echo "Must have an active project"
							;;
						*)
							cd ${UserIn[1]}
							here=$(pwd)
							if [[ ! "${here}" == *"${CodeProject}"* ]]; then
								echo "Leaving your project is not allowed"
								cd - > /dev/null
							fi
							;;
					esac
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
										ThePWD=$(pwd)
										ProjectDir=$(echo ${ThePWD#*${CodeProject}} | sed "s/\//:/1")
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
								CodeDir=$(echo ${project} | cut -d ";" -f 3)
								if [ -d ${CodeDir} ]; then
									Lang=$(echo ${project} | cut -d ";" -f 1)
									Code=$(echo ${project} | cut -d ";" -f 2)
									CodeProject=${UserIn[2]}
									cd ${CodeDir}
									echo "Project \"${CodeProject}\" loaded"
								else
									echo "Project \"${UserIn[2]}\" Directory not Found"
								fi
							else
								echo "Not a valid project"
							fi
							;;
						#Import project not created by cl[ide]
						import)
							importProject ${Lang} ${UserIn[2]} ${UserIn[3]}
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
				use|c++|java|python|perl|ruby|bash)
					Old=${Lang}
					OldCode=${Code}
					case ${UserIn[0]} in
						use)
							Lang=$(pgLang ${UserIn[1]})
							Code=${UserIn[2]}
							;;
						*)
							Lang=$(pgLang ${UserIn[0]})
							Code=${UserIn[1]}
							;;
					esac
					if [[ ! "${Lang}" == "no" ]]; then
						cLang=$(color ${Lang})
						CodeDir=$(pgDir ${Lang})
						cd ${CodeDir}
						#Rest
						#{
						Code=$(selectCode ${Lang} ${Code} "")
						RunTimeArgs=""
						CodeProject="none"
						#}
					else
						Lang=${Old}
						echo "Possible: ${pLangs}"
					fi
					;;
				#use the shell of a given language
				shell)
					case ${Lang} in
						#Python
						Python)
							#Enter shell
							${PythonRun}
							;;
						#Language does not support a shell
						*)
							;;
					esac
					;;
				#Create new source code
				new)
					case ${UserIn[1]} in
						#Get Code Template Versions
						--version|-v)
							ManageLangs ${Lang} "TemplateVersion"
							;;
						#Get Help Page for new code
						--help|-h)
							newCodeHelp ${Lang}
							;;
						--custom|-c)
							local BeforeFiles=""
							local AfterFiles=""
							local Type=""
							case ${Lang} in
								#Language is Bash
								Bash)
									#Type="sh"
									#BeforeFiles=$(ls *.${Type})
									BeforeFiles=$(ls *.*)
									;;
								#Language is Python
								Python)
									#Type="py"
									#BeforeFiles=$(ls *.${Type})
									BeforeFiles=$(ls *.*)
									;;
								#Language is Perl
								Perl)
									#Type="pl"
									#BeforeFiles=$(ls *.${Type})
									BeforeFiles=$(ls *.*)
									;;
								#Language is Ruby
								Ruby)
									#Type="rb"
									#BeforeFiles=$(ls *.${Type})
									BeforeFiles=$(ls *.*)
									;;
								#Language is C++
								C++)
									#Type="cpp"
									#BeforeFiles=$(ls *.${Type})
									BeforeFiles=$(ls *.*)
									;;
								#Language is Java
								Java)
									#Type="java"
									#BeforeFiles=$(ls *.${Type})
									BeforeFiles=$(ls *.*)
									;;
								*)
									;;
							esac
							#Create new code
							ManageLangs ${Lang} "customCode" ${Lang} ${cLang}
							#AfterFiles=$(ls *.${Type})
							AfterFiles=$(ls *.*)
							#look for created files
							NewCode=$(echo ${BeforeFiles} ${AfterFiles} | tr ' ' '\n' | sort | uniq -u | tr -d '\n')
							#Check if new code is found
							if [ ! -z "${NewCode}" ]; then
								#Select new Code
								Code=$(selectCode ${Lang} ${NewCode} ${Code})
							fi
							;;
						#Protect against incorrect file naming
						-*)
							echo "\"${UserIn[1]}\" is not a valid program name"
							;;
						#Create new src file
						*)
							#Ensure filename is given
							if [ ! -z "${UserIn[1]}" ]; then
								#Return the name of source code
								ManageLangs ${Lang} "newCode" ${UserIn[1]} ${CodeProject} ${UserIn[2]}
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
									#Language is Perl
									Perl)
										#Get code
										if [ -f ${PerlSrc}/${UserIn[1]}.pl ]; then
											Code=${UserIn[1]}.pl
										elif [ -f ${PerlSrc}/${UserIn[1]} ]; then
										Code=${UserIn[1]}
										fi
										;;
									#Language is Ruby
									Ruby)
										#Get code
										if [ -f ${RubySrc}/${UserIn[1]}.rb ]; then
											Code=${UserIn[1]}.rb
										elif [ -f ${RubySrc}/${UserIn[1]} ]; then
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
							else
								newCodeHelp ${Lang}
							fi
							;;
					esac
					;;
				#Edit new source code
				${editor}|edit|ed)
					case ${UserIn[1]} in
						#edit non-langugage source files
						non-lang)
							if [ ! -z "${UserIn[2]}" ]; then
								${editor} ${UserIn[2]}
							else
								echo "Please select a file to edit"
							fi
							;;
						*)
							ManageLangs ${Lang} "editCode" ${Code} ${UserIn[1]}
							;;
					esac
					;;
				#Add code to Source Code
				add)
					Code=$(ManageLangs ${Lang} "addCode" ${Code} ${UserIn[1]})
					;;
				#Read code without editing
				${ReadBy}|read)
					ManageLangs ${Lang} "readCode" ${Code} ${UserIn[1]}
					;;
				#Swap from Binary to Src and vise-versa
				swap|swp)
					if [[ "${UserIn[1]}" == "bin" ]]; then
						Code=$(ManageLangs ${Lang} "SwapToBin" ${Code})
					elif [[ "${UserIn[1]}" == "src" ]]; then
						Code=$(ManageLangs ${Lang} "SwapToSrc" ${Code})
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
				#Write notes for code
				notes)
					case ${UserIn[1]} in
						edit|add)
							if [ ! -f "${NotesDir}/${Lang}.notes" ]; then
								echo "[${Lang} Notes]" > ${NotesDir}/${Lang}.notes
							fi
								${editor} ${NotesDir}/${Lang}.notes
							;;
						read)
							if [ -f "${NotesDir}/${Lang}.notes" ]; then
								${ReadBy} ${NotesDir}/${Lang}.notes
							else
								echo "No notes for ${Lang} found"
							fi
							;;
						*)
							NotesHelp ${Lang}
							;;
					esac
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
						version|-std=*)
							case ${Lang} in
								C++)
									case ${UserIn[1]} in
										-std=*)
											CppCplVersion="${UserIn[1]}"
											;;
										*)
											CppCplVersion="${UserIn[2]}"
											;;
									esac

									if [ -z "${CppCplVersion}" ]; then
										echo -n "${cLang}\$ -std="
										read -a CppCplVersion
									fi
									if [ ! -z "${CppCplVersion}" ]; then
										case ${CppCplVersion} in
											-std=*)
												CppCplVersion=${CppCplVersion#-std=}
												;;
											*)
												;;
										esac
										if [ ! -z "${CppCplVersion}" ] && [[ "${CppCplVersion}" == *"c++"* ]]; then
											CppCplVersion="-std=${CppCplVersion}"
										else
											CppCplVersion=""
										fi
									fi
									;;
								*)
									echo "At this time, only for C++"
									;;
							esac
							;;
						jar|manifest)
							#Manage languages
							case ${Lang} in
								#Java Properties
								Java)
									#Creating new manifast.mf
									if [ ! -f manifest.mf ]; then
										echo "Manifest-Version: 1.1" > manifest.mf
										echo "Created-By: $USER" >> manifest.mf
										echo "Main-Class: " >> manifest.mf
										echo "Sealed: true" >> manifest.mf
									fi
									#edit manifest.mf
									${editor} manifest.mf
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
					ManageLangs ${Lang} "compileCode" ${Code} ${UserIn[1]} ${UserIn[2]}
					#Code=$(ManageLangs ${Lang} "SwapToBin" ${Code})
					;;
				#Install compiled code into aliases
				install)
					ManageLangs ${Lang} "Install" ${Code} ${UserIn[1]}
					;;
				#run compiled code
				execute|exe|run)
					if [ ! -z "${Code}" ]; then
						runCode ${Lang} ${Code} ${UserIn[1]}
					else
						errorCode "cpl" "none"
					fi
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
						#Language is Perl
						Perl)
							#Get code dir
							CodeDir=${PerlSrc}/${Dir}
							;;
						#Language is Ruby
						Ruby)
							#Get code dir
							CodeDir=${RubySrc}/${Dir}
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
				#List supported languages
				langs|languages)
					echo -n "${UserArg}: "
					echo ${pg}
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

#Autocomplete Function
autocomp()
{
	local i
	local x
	local y
	local z
	local opt
	local addr
	local types
	local last_addr
	local last_addr_len
	local READLINE_ARRAY
	if [[ "${READLINE_LINE}" == "" ]]; then
		opt=()
		x=0
		while [ ${x} -le ${len} ];
		do
			opt[${#opt[@]}]=${Commands[${x},0]}
			x=$((${x}+1))
		done
		echo "${prompt}${READLINE_LINE}"
		echo "${opt[@]}"
	else
		READLINE_ARRAY=()
		for i in ${READLINE_LINE};
		do
			READLINE_ARRAY[${#READLINE_ARRAY[@]}]=${i}
		done
		opt=()
		x=0
		while [ ${x} -le ${len} ];
		do
			for i in ${Commands[${x},0]};
			do
				if [[ "${i}" == "${READLINE_ARRAY[0]}"* ]]; then
					opt[${#opt[@]}]=${i}
				fi
			done
			x=$((${x}+1))
		done
		if [ ${#opt[@]} == 1 ]; then
			READLINE_LINE="${opt[0]} "
			x=0
			while [[ "${Commands[${x},0]}" != *"${opt[0]}"* ]];
			do
				x=$((x+1))
			done
			if [ ${#READLINE_ARRAY[@]} -gt 1 ]; then
				opt=()
				for i in ${Commands[$x,1]};
				do
					if [[ "${i}" == "" ]]; then
						break
					elif [[ "${i}" == "${READLINE_ARRAY[1]}"* ]]; then
						opt[${#opt[@]}]=${i}
					fi
				done
				if [ ${#opt[@]} == 1 ]; then
					READLINE_LINE="${READLINE_LINE}${opt[0]} "
					z=0
					for i in ${Commands[${x},1]};
					do
						if [[ "${i}" == "${opt[0]}" ]]; then
							break
						fi
						z=$((${z}+1))
					done
					y=2
					while [ ${y} -le 3 ];
					do
						types=()
						for i in ${Commands[${x},${y}]}
						do
							types[${#types[@]}]=${i}
						done
						if [[ "${types[$z]}" == "file" ]]; then
							last_addr=""
							last_addr_len=-${#READLINE_ARRAY[${y}]}
							opt=()
							if [[ "${READLINE_ARRAY[${y}]:$((${#READLINE_ARRAY[${y}]}-1))}" != '/' ]]; then
								addr=${READLINE_ARRAY[${y}]//'/'/' '}
								for i in ${addr}
								do
									last_addr=${i}
								done
								last_addr_len=${#last_addr}
							fi
							for i in $(ls -F ${READLINE_ARRAY[${y}]::-${last_addr_len}})
							do
								if [[ "${i}" == "${last_addr}"* ]]; then
									opt[${#opt[@]}]=${i}
								fi
							done
							if [ ${#opt[@]} == 1 ]; then
								READLINE_LINE="${READLINE_LINE}${READLINE_ARRAY[${y}]::-${last_addr_len}}${opt[0]}"
							else
								if [ ${#opt[@]} -gt 1 ]; then
									echo "${prompt}${READLINE_ARRAY[@]}"
									echo "${opt[@]}"
								fi
								READLINE_LINE="${READLINE_LINE}${READLINE_ARRAY[${y}]}"
							fi
						else
							READLINE_LINE="${READLINE_LINE}${READLINE_ARRAY[${y}]}"
						fi
						y=$((${y}+1))
					done
				else
					if [ ${#opt[@]} -gt 1 ]; then
						echo "${prompt}${READLINE_ARRAY[@]}"
						echo "${opt[@]}"
					fi
					READLINE_LINE="${READLINE_LINE}${READLINE_ARRAY[1]}"
				fi
			else
				if [[ "${Commands[${x},1]}" != "" ]]; then
					echo "${prompt}${READLINE_ARRAY[@]}"
					echo "${Commands[${x},1]}"
				fi
			fi
		elif [ ${#opt[@]} -gt 1 ]; then
			echo "${prompt}${READLINE_ARRAY[@]}"
			echo "${opt[@]}"
		fi
	fi
	READLINE_POINT=${#READLINE_LINE}
}

#Add To Autocomplete Function
comp_list()
{
	len=$(((${#Commands[@]}+2)/3))
	Commands[${len},0]=$1
	Commands[${len},1]=$2
	Commands[${len},2]=$3
	Commands[${len},3]=$4
}

#Load AutoComplete
loadAuto()
{
	#init autocomplete
	set -o vi
	bind -x '"\t":autocomp'
	bind -x '"\C-l":clear'
	comp_list "ls"
	comp_list "ll"
	comp_list "clear"
	comp_list "set"
	comp_list "unset"
	comp_list "rm remove delete" "--force"
	comp_list "cd"
	comp_list "pwd"
	comp_list "mkdir"
	comp_list "use" "${pg}"
	comp_list "swap swp" "src bin"
	comp_list "project" "load import new list"
	comp_list "shell"
	comp_list "new" "--version -v --help -h --custom -c"
	comp_list "${editor} ed edit" "non-lang"
	comp_list "add"
	comp_list "${ReadBy} read"
	comp_list "${repoTool} repo"
	comp_list "search"
	comp_list "create" "make version -std= jar manifest args prop properties -D reset"
	comp_list "compile cpl"
	comp_list "execute exe run" "-a --args"
	comp_list "version"
	comp_list "help"
	comp_list "notes" "edit add read"
	comp_list "last load"
	comp_list "install"
	comp_list "langs languages"
	comp_list "exit close"
}

#Main Function
main()
{
	#Make sure everything is working
	EnsureDirs
	local pg=$(ColorCodes)
	local UserArg=$1
	local prompt
	#No argument given
	if [ -z "${UserArg}" ]; then
		clear
		local getLang=""
		if [ ! -z "${pg}" ]; then
			CliHelp
			echo "~Choose a language~"
			#Force user to select language
			while [[ "$getLang" == "" ]] || [[ "$Lang" == "no" ]];
			do
				prompt="${Name}(${pg}):$ "
				read -e -p "${prompt}" getLang
				case ${getLang} in
					exit)
						break
						;;
					*)
						#Verify Language
						Lang=$(pgLang ${getLang})
						;;
				esac
			done

			if [ ! -z "${Lang}" ]; then
				#Start IDE
				Actions ${Lang}
			fi
		else
			echo "No Languages installed"
			echo "Please Lang.<language> in \"${LangsDir}/\""
		fi
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
			#Get version of template
			-tv|--temp-version)
				ManageLangs Bash "TemplateVersion" | sed "s/Version/Bash/g" | grep -v found
				ManageLangs Python "TemplateVersion" | sed "s/Version/Python/g" | grep -v found
				ManageLangs Perl "TemplateVersion" | sed "s/Version/Perl/g" | grep -v found
				ManageLangs Ruby "TemplateVersion" | sed "s/Version/Ruby/g" | grep -v found
				ManageLangs C++ "TemplateVersion" | sed "s/Version/C++/g" | grep -v found
				ManageLangs Java "TemplateVersion" | sed "s/Version/Java/g" | grep -v found
				;;
			#Get version control version from cli
			-rv|--repo-version)
				RepoVersion
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

history -c
#Run clide
main $@
