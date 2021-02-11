Shell=$(which bash)
#!${Shell}
ShellPath=$(realpath $0)
root=$(dirname ${ShellPath})
#cl[ide] future features
#{
	#provide X11 support via -lX11 g++ flag
#}

GetConfig()
{
	local ConfigFile=${root}/var/clide.conf
	local Item=$1
	if [ ! -z "${Item}" ]; then
		grep "${Item}" ${ConfigFile} | grep -v "#" | cut -d "=" -f 2
	fi
}

Head="cl[ide]"
IDE=$(echo -e "\e[1;40mide\e[0m")
Name="cl[${IDE}]"

#Version tracking
#Increment by 1 number per category
#1st # = Overflow
#2nd # = Additional features
#3rd # = Bug/code tweaks/fixes
Version=$(GetConfig Version)

#cl[ide] config
#{
editor=$(GetConfig editor)
ReadBy=$(GetConfig ReadBy)
repoTool=$(GetConfig repoTool)
repoAssist=$(GetConfig repoAssist)

#root dir
ProgDir=$(eval echo $(GetConfig ProgDir))
ClideDir=${ProgDir}/.clide
ModesDir=${ClideDir}/modes
NotesDir=${ClideDir}/notes
LibDir=${ClideDir}/lib
LangsDir=${ClideDir}/langs
ClideProjectDir=${ClideDir}/projects

#Global Vars
#{
CodeProject="none"
RunTimeArgs=""
RunCplArgs="none"
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
	echo -e "using\t\t\t\t: \"get the language being used\""
	echo -e "unset\t\t\t\t: \"deselect source code\""
	echo -e "use <language> <code>\t\t: \"choose language\""
	echo -e "swap, swp {src|bin}\t\t: \"swap between sorce code and executable\""
	echo -e "create <arg>\t\t\t: \"create compile and runtime arguments"
	ManageLangs ${Lang} "MenuHelp"
	echo -e "rm, remove, delete\t\t: \"delete src file\""
	echo -e "set <file>\t\t\t: \"select source code\""
	echo -e "add <file>\t\t\t: \"add new file to project\""
	echo -e "notes <action>\t\t\t: \"make notes for the ${Lang} language\""
	echo -e "${editor}, edit, ed\t\t\t: \"edit source code\""
	echo -e "${ReadBy}, read\t\t\t: \"Read source code\""
	echo -e "search <find>\t\t\t: \"search for code in project\""
	case ${project} in
		none)
			echo -e "project {new|list|load}\t\t: \"handle projects\""
			;;
		*)
#			echo -e "project {new|update|list|load|active}\t: \"handle projects\""
			echo -e "project {new|update|list|load}\t: \"handle projects\""
			echo -e "${repoTool}, repo\t: \"handle repos\""
			;;
	esac
	echo -e "search\t\t\t\t: \"search project src files for line of code\""
	echo -e "execute, exe, run {-a|--args}\t: \"run active program\""
	echo -e "bkup, backup\t\t\t: \"make backup of existing source code\""
	echo -e "restore\t\t\t\t: \"make backup of existing source code\""
	echo -e "rename <new>\t\t\t: \"rename the existing source code\""
	echo -e "copy <new>\t\t\t: \"copy the existing source code\""
	echo -e "last, load\t\t\t: \"Load last session\""
	echo -e "exit, close\t\t\t: \"close ide\""
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
	echo ""
	echo "----------------[(${Head}) CLI]----------------"
	echo -e "-v, --version\t\t\t: \"Get Clide Version\""
	echo -e "-sv, --support-version\t\t: \"Get Code Support Version\""
	echo -e "-cv, --code-version\t\t: \"Get Compile/Interpreter Version\""
	echo -e "-tv, --temp-version\t\t: \"Get Code Template Version\""
	echo -e "-rv, --repo-version\t\t: \"Get git/svn Version\""
	echo -e "-c, --config\t\t\t: \"Get Clide Config\""
	echo -e "-p, --projects\t\t\t: \"List Clide Projects\""
	echo -e "-h, --help\t\t\t: \"Get CLI Help Page (Cl[ide] Menu: \"help\")\""
	echo -e "-l, --last, --load\t\t: \"Load last session\""
	echo ""
	echo "-----------------------------------------------"
	echo -e "\t\t\"Quick ${Head} Functions\""
	echo -e "--edit\t\t\t\t:\"Edit source code\""
	echo -e "--cpl, --compile\t\t:\"Compile source code\""
	echo -e "--install\t\t\t:\"install program (.bash_aliases)\""
	echo -e "--run\t\t\t\t:\"Run compiled code\""
	echo -e "--read\t\t\t\t:\"Read out (cat) source code\""
	echo -e "--list\t\t\t\t:\"List source code\""
	echo ""
	echo -e "$ clide <Action> <Language> <Code> <Args>"
	echo ""
	echo "-----------------------------------------------"
	echo -e "\t\t\"Run ${Head} IDE\""
	echo -e "$ clide <language> <code>\t: start clide"
	echo -e "$ clide java program.java\t: start clide using java and program.java"
	echo -e "$ clide java\t\t\t: start clide using java"
	echo ""
}

ModesHelp()
{
	echo ""
	echo "----------------[(${Head}) Modes]----------------"
	echo -e "${repoTool}, repo\t\t: repo management"
	echo -e "add\t\t\t: install/add component management"
	echo -e "-h, --help\t\t: \"Modes help page\""
	echo "-----------------------------------------------"
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
			echo -e "cpl, compile\t: \"make code executable\""
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
	local Langs=$1
	#Make first letter uppercase
	shift
	local Manage=$@
	if [ -f ${LangsDir}/Lang.${Langs^} ]; then
		${LangsDir}/Lang.${Langs^} ${ProgDir} ${ClideDir} ${editor} ${ReadBy} ${CodeProject} ${RunCplArgs} ${Manage[@]}
	else
		UseOther ${Langs} ${Manage[@]}
	fi
}

ModeHanlder()
{
	local Mode=$1
	case ${Mode} in
		${repoTool}|repo)
			#Use ONLY for Projects
			if [[ ! "${CodeProject}" == "none" ]]; then
				${ModesDir}/repo.sh ${repoTool} ${CodeProject}
			else
				echo "Must have an active project"
			fi
			;;
		add)
				${ModesDir}/add.sh
			;;
		-h|--help)
			ModesHelp
			;;
		*)
			ModesHelp
			;;
	esac
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

	if [ ! -d "${LibDir}" ]; then
		mkdir "${LibDir}"
	fi

	if [ ! -d "${ClideProjectDir}" ]; then
		mkdir "${ClideProjectDir}"
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

CodeSupportVersion()
{
	local TheLang=$1
	local Langs=""
	if [ ! -z "${TheLang}" ]; then
		SupportNum=$(ManageLangs ${TheLang} "SupportVersion")
		if [ ! -z "${SupportNum}" ]; then
			echo "[Clide ${TheLang} Support]"
			echo "Version: ${SupportNum}"
		fi
	else
		Langs=$(ls ${LangsDir}/ | sed "s/Lang.//g" | tr '\n' '|' | rev | sed "s/|//1" | rev)
		local NumOfLangs=$(ls | wc -l)
		local look=1
		local text
		local SupportNum
		while [ ${look} -le ${NumOfLangs} ];
		do
			text=$(echo ${Langs} | cut -d '|' -f ${look})
			text=$(ManageLangs ${text} "pgLang")
			case ${text} in
				no)
					;;
				*)
					SupportNum=$(ManageLangs "${text}" "SupportVersion")
					if [ ! -z "${SupportNum}" ]; then
						echo "${text}: ${SupportNum}"
					fi
					;;
			esac
			look=$((${look}+1))
		done
	fi
}

CodeTemplateVersion()
{
	local TheLang=$1
	local Langs=""
	if [ ! -z "${TheLang}" ]; then
		TempNum=$(ManageLangs ${TheLang} "TemplateVersion" | sed "s/Version/${text}/g" | grep -v found)
		if [ ! -z "${TempNum}" ]; then
			echo "[\"New Code\" Teplate]"
			echo "${TempNum}"
		fi
	else
		local GetLangs=$(ls ${LangsDir}/ | sed "s/Lang.//g" | tr '\n' '|' | rev | sed "s/|//1" | rev)
		local NumOfLangs=$(ls | wc -l)
		local look=1
		local text
		while [ ${look} -le ${NumOfLangs} ];
		do
			text=$(echo ${GetLangs} | cut -d '|' -f ${look})
			text=$(ManageLangs ${text} "pgLang")
			case ${text} in
				no)
					;;
				*)
					ManageLangs "${text}" "TemplateVersion" | sed "s/Version/${text}/g" | grep -v found
					;;
				esac
			look=$((${look}+1))
		done
	fi
}

CodeVersion()
{
	local TheLang=$1
	local Langs=""
	if [ ! -z "${TheLang}" ]; then
		ManageLangs ${TheLang} "CplVersion"
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
					ManageLangs "${text}" "CplVersion" | sed "s/Version:/${text}:/g"
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
	${LibDir}/errorCode.sh $@
}

#Search selected code for element
lookFor()
{
	local project=$1
	local search=$2
	case ${project} in
		none)
			errorCode "project" "none" "${Head}"
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
	local ProjectFile=${ClideProjectDir}/${Name}.clide
	if [ ! -z "${Name}" ]; then
		Path=$(eval $(echo ${Path}))
		if [ ! -f ${ProjectFile} ]; then
			if [ -z "${Path}" ]; then
				local prompt="Import Project \"${Name}\" from : "
				read -e -p "${prompt}" Path
				Path=$(eval $(echo ${Path}))
			fi

			if [ -z "${Path}" ]; then
				errorCode "project" "import" "no-path"
			else
				case ${Path} in
					*${Name}|*${Name}/)

						echo "name=${Name}" > ${ProjectFile}
						echo "lang=${Lang}" >> ${ProjectFile}
						echo "path=${Path}" >> ${ProjectFile}
						echo "src=" >> ${ProjectFile}
						echo "Project \"${Name}\" Imported"
						;;
					*)
						errorCode "project" "import" "name-in-path" "${Name}" "${Path}"
						;;
				esac
			fi
		else
			errorCode "project" "import" "exists" "${Name}"
		fi
	else

		errorCode "project" "import" "no-name"
	fi
}

#Create new project
newProject()
{
	local lang=$1
	local project=$2
	local ProjectFile=${ClideProjectDir}/${project}.clide
	local path=""
	#No Project is found
	if [ -z ${project} ]; then
		errorCode "project" "none" "${Head}"
	else
		#Grab Project Data
		#Name Value
		echo "name=${project}" > ${ProjectFile}
		#Language Value
		echo "lang=${lang}" >> ${ProjectFile}
		#Create Project and get path
		path=$(ManageLangs ${Lang} "newProject" ${project})
		cd ${path}/src
		#Path Value
		echo "path=${path}" >> ${ProjectFile}
		#Source Value
		echo "src=" >> ${ProjectFile}
	fi
}

#Update config of active Projects
updateProject()
{
	local project=$1
	local src=$2
	local ProjectFile=${ClideProjectDir}/${project}.clide
	#No Project is found
	if [ ! -z ${src} ]; then
		#Locate Project Directory
		if [ ! -f ${ProjectFile} ]; then
			errorCode "project" "NotAProject" ${project}
		else
			#Incorperate sed instead of what you're doing
			SrcLine=$(grep "src=" ${ProjectFile})
			sed -i "s/${SrcLine}/src=${src}/g" ${ProjectFile}
		fi
	fi
}

#list active projects
listProjects()
{
	#Get list of active prijects from .clide files
	ls ${ClideProjectDir}/ | sed "s/.clide//g"
}

#Load active projects
loadProject()
{
	local project=$1
	local ProjectFile=${ClideProjectDir}/${project}.clide
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
			if [ -f ${ProjectFile} ]; then
				#Grab Project Data
				#Name Value
				tag="name="
				name=$(grep ${tag} ${ProjectFile} | sed "s/${tag}//g")
				#Language Value
				tag="lang="
				lang=$(grep ${tag} ${ProjectFile} | sed "s/${tag}//g")
				#Source Value
				tag="path="
				path=$(grep ${tag} ${ProjectFile} | sed "s/${tag}//g")
				#Source Value
				tag="src="
				src=$(grep ${tag} ${ProjectFile} | sed "s/${tag}//g")
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
				errorCode "remove" "not-file" "${src}"
			fi
		else
			errorCode "remove" "not-file" "${src}"
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
	if [[ "${name}" == *","* ]]; then
		errorCode "runCode" "${Head}"
	else
		TheBin=${name}
		#Come up with a way to know if arguments are needed
		TheLang=$(color "${Lang}")
		#User Wishes to provide arments for program
		case ${option} in
			-a|--args)
				CLIout=$(ManageLangs ${Lang} "cli" "${TheBin}")
				CLIout="$USER@${Name}:~/${TheLang}\$ ${CLIout}"
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
		ManageLangs ${Lang} "runCode" "${TheBin}" ${Args[@]}
	fi
}

selectCode()
{
	local Lang=$1
	local name=$2
	local old=$3
	name=$(ManageLangs ${Lang} "selectCode" ${name})
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
	local NumOfLangs=$(ls ${LangsDir}/ | wc -l)
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
	local Code="$2"
	local FirstAction="$3"
	CodeProject="none"

#	#No Project Given
#	if [ -z $2 ]; then
#		Code=""
#	else
#		Code=$2
#	fi
#
#	#No Project Given
#	if [ -z $3 ]; then
#		CodeProject="none"
#	else
#		CodeProject=$3
#		Dir="${CodeProject}"
#	fi
#
#	#Avoid getting incorrect directory name
#	if [[ "${Dir}" == "none" ]]; then
#		Dir=""
#	fi

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
				case ${CodeProject} in
					none)
						#Menu with no code
						prompt="${Name}(${cLang}):$ "
						;;
					*)
						ThePWD=$(pwd)
						ProjectDir=$(echo ${ThePWD#*${CodeProject}} | sed "s/\//:/1")
						cCodeProject=$(ManageLangs ${Lang} "ProjectColor" "${CodeProject}")
						#Menu with no code
						prompt="${Name}([${cCodeProject}${ProjectDir}]):$ "
						;;
				esac
			else
				case ${CodeProject} in
					none)
						#Menu with code
						prompt="${Name}(${cLang}{${cCode}}):$ "
						;;
					*)
						ThePWD=$(pwd)
						ProjectDir=$(echo ${ThePWD#*${CodeProject}} | sed "s/\//:/1")
						#Menu with no code
						cCodeProject=$(ManageLangs ${Lang} "ProjectColor" "${CodeProject}")
						prompt="${Name}([${cCodeProject}${ProjectDir}]{${cCode}}):$ "
						;;
				esac
			fi
			#User's first action
			if [ ! -z "${FirstAction}" ]; then
				UserArg=${FirstAction}
				FirstAction=""
			else
				#Handle CLI
				#read -a UserIn
				read -e -p "${prompt}" -a UserIn
				UserArg=$(echo ${UserIn[0]} | tr A-Z a-z)

			fi
			if [ ! -z "${UserIn[0]}" ]; then
				case ${UserIn[0]} in
					#ignore anything beginning with '-'
					-*)
						;;
					*)
						history -s "${UserIn[@]}"
						;;
				esac
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
				using)
					echo "${cLang}"
					;;
				#change dir in project
				cd)
					#Use ONLY for Projects
					case ${CodeProject} in
						none)
							errorCode "project" "none"
							;;
						*)
							cd ${UserIn[1]} 2> /dev/null
							here=$(pwd)
							if [[ ! "${here}" == *"${CodeProject}"* ]]; then
								errorCode "project" "can-not-leave"
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
						errorCode "project" "none" "${Head}"
					fi
					;;
				#make dir in project
				mkdir)
					#Use ONLY for Projects
					if [[ ! "${CodeProject}" == "none" ]]; then
						mkdir ${UserIn[1]}
					else
						errorCode "project" "none" "${Head}"
					fi
					;;
				#Handle Projects
				project)
					#Project commands
					case ${UserIn[1]} in
						#Create new project
						new)
							#Locate Project Directory
							if [ -f "${ClideDir}/${UserIn[2]}.clide" ]; then
								errorCode "project" "exists" ${UserIn[2]}
							else
								newProject ${Lang} ${UserIn[2]}
								Code=""
								updateProject ${UserIn[2]} ${Code}
								if [ ! -z "${UserIn[2]}" ]; then
									CodeProject=${UserIn[2]}
									echo "Created \"${CodeProject}\""
									ProjectDir=$(echo ${ThePWD#*${CodeProject}} | sed "s/\//:/1")
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
								CodeDir=$(eval echo ${CodeDir})
								if [ -d ${CodeDir} ]; then
									Lang=$(echo ${project} | cut -d ";" -f 1)
									Code=$(echo ${project} | cut -d ";" -f 2)
									CodeProject=${UserIn[2]}
									cd ${CodeDir}/src
									echo "Project \"${CodeProject}\" loaded"
								else
									errorCode "project" "load" "no-path" "${UserIn[2]}"
								fi
							else
								errorCode "project" "load" "no-project" "${UserIn[2]}"
							fi
							;;
						#Import project not created by cl[ide]
						import)
							importProject ${Lang} ${UserIn[2]} ${UserIn[3]}
							;;
						#Display active project
						active)
							case ${CodeProject} in
								#There is no project listed
								none)
									errorCode "project" "active"
									;;
								#Project is found
								*)
									echo "Active Project [\"${CodeProject}\"]"
									;;
							esac
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
							if [ ! -z "${UserIn[1]}" ]; then
								Lang=$(pgLang ${UserIn[1]})
								Code=${UserIn[2]}
							else
								Lang="no"
							fi
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
						echo "Supported Languages: ${pLangs}"
					fi
					;;
				bkup|backup)
					local chosen=${UserIn[1]}
					case ${Code} in
						*,*)
							if [ ! -z "${chosen}" ]; then
								if [[ "${Code}" == *"${chosen}"* ]]; then
									ManageLangs ${Lang} "backup" ${chosen}
								else
									errorCode "backup" "wrong"
								fi
							else
								errorCode "backup" "null"
							fi
							;;
						*)
							ManageLangs ${Lang} "backup" ${Code}
							;;
					esac
					;;
				restore)
					local chosen=${UserIn[1]}
					case ${Code} in
						*,*)
							if [ ! -z "${chosen}" ]; then
								if [[ "${Code}" == *"${chosen}"* ]]; then
									ManageLangs ${Lang} "restore" ${chosen}
								else
									errorCode "backup" "wrong"
								fi
							else
								errorCode "backup" "null"
							fi
							;;
						*)
							ManageLangs ${Lang} "restore" ${Code}
							;;
					esac
					;;
				rename)
					local chosen=${UserIn[1]}
					local TheNewChosen=${UserIn[2]}
					case ${Code} in
						*,*)
							if [ ! -z "${TheNewChosen}" ]; then
								if [[ "${Code}" == *"${chosen}"* ]]; then
									ManageLangs ${Lang} "rename" ${chosen} ${TheNewChosen} > /dev/null
									Code=$(echo ${Code} | sed "s/${chosen}/${TheNewChosen}/g")
								else
									errorCode "rename" "wrong"
								fi
							else
								errorCode "rename" "null"
							fi
							;;
						*)
							Code=$(ManageLangs ${Lang} "rename" ${Code} ${chosen})
							;;
					esac
					;;
				copy)
					local chosen=${UserIn[1]}
					local TheNewChosen=${UserIn[2]}
					case ${Code} in
						*,*)
							if [ ! -z "${TheNewChosen}" ]; then
								if [[ "${Code}" == *"${chosen}"* ]]; then
									ManageLangs ${Lang} "copy" ${chosen} ${TheNewChosen} > /dev/null
									Code=$(echo ${Code} | sed "s/${chosen}/${TheNewChosen}/g")
								else
									errorCode "copy" "wrong"
								fi
							else
								errorCode "backup" "null"
							fi
							;;
						*)
							Code=$(ManageLangs ${Lang} "copy" ${Code} ${chosen})
							;;
					esac
					;;
				#use the shell of a given language
				shell)
					ManageLangs ${Lang} "shell"
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
							BeforeFiles=$(ManageLangs ${Lang} "BeforeFiles")
							#Create new code
							ManageLangs ${Lang} "customCode" ${Lang} ${cLang}
							AfterFiles=$(ManageLangs ${Lang} "AfterFiles")
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
								Code=$(ManageLangs ${Lang} "getCode" ${UserIn[1]})
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
								errorCode "selectCode"
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
				#Modes
				mode)
					ModeHanlder ${UserIn[1]}
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
						#Args for run time
						args)
							echo -n "${cLang}\$ "
							read -a RunTimeArgs
							;;
						#Clear all
						reset)
							#Default values
							RunTimeArgs=""
							RunCplArgs="none"
							echo "All rest"
							;;
						${UserIn[1]}-${UserIn[2]})
							RunCplArgs=$(ManageLangs ${Lang} "${UserIn[1]}-${UserIn[2]}" ${Code} ${UserIn[@]})
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
					echo ""
					CodeSupportVersion ${Lang}
					echo ""
					CodeTemplateVersion ${Lang}
					echo ""
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
					CodeDir=$(ManageLangs "${Lang}" "pgDir")
					if [ ! -z "${CodeDir}" ]; then
						CodeDir=${CodeDir}/${Dir}
						#Go to dir
						cd ${CodeDir}
					fi
					;;
				#List supported languages
				langs|languages)
					local pg=$(ColorCodes)
					echo "Supported Languages: ${pg}"
					;;
				#Close cl[ide]
				exit|close)
					#SaveSession ${CodeProject} ${Lang} ${Code}
					break
					;;
				#ignore all other commands
				*)
					;;
			esac
		done
	fi
}

#Choose Lang by code
SelectLangByCode()
{
	local Code=$1
	#Select Language
	case ${Code} in
		*.sh)
			pgLang Bash
			;;
		*.py)
			pgLang Python
			;;
		*.cpp|*.h)
			pgLang C++
			;;
		*.java)
			pgLang Java
			;;
		*.pl)
			pgLang Perl
			;;
		*.rb)
			pgLang Ruby
			;;
		*)
			echo "no"
			;;
	esac
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
	comp_list "using"
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
	comp_list "bkup backup"
	comp_list "restore"
	comp_list "rename"
	comp_list "copy"
	comp_list "langs languages"
	comp_list "exit close"
}

#Main Function
main()
{
	#Make sure everything is working
	EnsureDirs
	local UserArg=$1
	local pg
	local prompt
	#No argument given
	if [ -z "${UserArg}" ]; then
		clear
		pg=$(ColorCodes)
		local getLang=""
		if [ ! -z "${pg}" ]; then
			#CliHelp
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
			errorCode "no-langs"
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
			#Get compile/interpreter version from cli
			-sv|--support-version)
				CodeSupportVersion
				;;
			#Get version of template
			-tv|--temp-version)
				CodeTemplateVersion
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
			#Load last saved session
			-l|--load|--last)
				session=$(LoadSession)
				Lang=$(echo ${session} | cut -d ";" -f 1)
				Code=$(echo ${session} | cut -d ";" -f 3)
				CodeProject=$(echo ${session} | cut -d ";" -f 2)
				#Start IDE
				Actions ${Lang} ${Code} ${CodeProject}
				;;
			--edit)
				shift
				local Lang=$(pgLang $1)
				local Code=$2
				if [ -z "${Code}" ]; then
					Lang=$(SelectLangByCode $1)
					Code=$1
					shift
					main --edit "${Lang}" "${Code}"
				else
					case ${Lang} in
						no)
							echo "\"$1\" is not a supported language"
							;;
						*)
							local CodeDir=$(pgDir ${Lang})
							if [ ! -z "${CodeDir}" ]; then
								cd ${CodeDir}
								Code=$(selectCode ${Lang} ${Code})
								ManageLangs ${Lang} "editCode" ${Code}
							else
								echo "Source code not found"
							fi
					esac
				fi
				;;
			#compile code without entering cl[ide]
			--cpl|--compile)
				shift
				local Lang=$(pgLang $1)
				local Code=$2
				if [ -z "${Code}" ]; then
					Lang=$(SelectLangByCode $1)
					Code=$1
					shift
					local Args=$@
					main --cpl "${Lang}" "${Code}" ${Args[@]}
				else
					shift
					shift
					local Args=$@
					case ${Lang} in
						no)
							echo "\"$1\" is not a supported language"
							;;
						*)
							local CodeDir=$(pgDir ${Lang})
							if [ ! -z "${CodeDir}" ]; then
								cd ${CodeDir}
								Code=$(selectCode ${Lang} ${Code})
								ManageLangs ${Lang} "compileCode" ${Code} ${Args[@]}
							else
								echo "Source code not found"
							fi
					esac
				fi
				;;
			#Install compiled code into aliases
			--install)
				shift
				local Lang=$(pgLang $1)
				local Code=$2
				if [ -z "${Code}" ]; then
					Lang=$(SelectLangByCode $1)
					Code=$1
					shift
					local Args=$@
					main --install "${Lang}" "${Code}" ${Args[@]}

				else
					shift
					shift
					local Args=$@
					case ${Lang} in
						no)
							echo "\"$1\" is not a supported language"
							;;
						*)
							local CodeDir=$(pgDir ${Lang})
							if [ ! -z "${CodeDir}" ]; then
								cd ${CodeDir}
								Code=$(selectCode ${Lang} ${Code})
								ManageLangs ${Lang} "Install" ${Code} ${Args[@]}
							else
								echo "Source code not found"
							fi
					esac
				fi
				;;
			#run compiled code
			--run)
				shift
				local Lang=$(pgLang $1)
				local Code=$2
				if [ -z "${Code}" ]; then
					Lang=$(SelectLangByCode $1)
					Code=$1
					shift
					local Args=$@
					main --run "${Lang}" "${Code}" ${Args[@]}
				else
					shift
					shift
					local Args=$@
					case ${Lang} in
						no)
							echo "\"$1\" is not a supported language"
							;;
						*)
							local CodeDir=$(pgDir ${Lang})
							if [ ! -z "${CodeDir}" ]; then
								ManageLangs ${Lang} "runCode" "${Code}" ${Args[@]}
							else
								errorCode "cpl" "none"
							fi
					esac
				fi
				;;
			#cat out source code
			--read)
				shift
				local Lang=$(pgLang $1)
				local Code=$2
				if [ -z "${Code}" ]; then
					Lang=$(SelectLangByCode $1)
					Code=$1
					shift
					local Args=$@
					main --read "${Lang}" "${Code}" ${Args[@]}
				else
					case ${Lang} in
						no)
							echo "\"$1\" is not a supported language"
							;;
						*)
							local CodeDir=$(pgDir ${Lang})
							if [ ! -z "${CodeDir}" ]; then
								cd ${CodeDir}
								Code=$(selectCode ${Lang} ${Code})
								if [ ! -z "${Code}" ]; then
									cat ${Code}
								else
									echo "No code to read"
								fi
							else
								echo "No code to read"
							fi
					esac
				fi
				;;
			#List source code from given language
			--list)
				shift
				local Lang=$(pgLang $1)
				case ${Lang} in
					no)
						echo "\"$1\" is not a supported language"
						;;
					*)
						local CodeDir=$(pgDir ${Lang})
						if [ ! -z "${CodeDir}" ]; then
							ls ${CodeDir}
						fi
						;;
				esac
				;;
			*.sh|*.py|*.cpp|*.h|*.java|*.pl|*.rb)
				local Code=$1
				local Lang=$(SelectLangByCode $1)
				local CodeDir=$(pgDir ${Lang})
				if [ ! -z "${CodeDir}" ]; then
					cd ${CodeDir}
					Code=$(selectCode ${Lang} ${Code})
					if [ ! -z "${Code}" ]; then
						#Start IDE
						Actions ${Lang} ${Code}
					fi
				fi
				;;
			#Check for language given
			*)
				#Verify Language
				local Lang=$(pgLang $1)
				shift
				local Args=$@
				#Start IDE
				Actions ${Lang} ${Args[@]}

				;;
		esac
	fi
}

history -c
#Run clide
main $@
