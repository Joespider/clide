Shell=$(which bash)
#!${Shell}
ShellPath=$(realpath $0)
root=$(dirname ${ShellPath})
source ${root}/var/clide.conf
source ${root}/var/version

InAndOut="no"

Head="cl[ide]"
IDE=$(echo -e "\e[1;40mide\e[0m")
Name="cl[${IDE}]"

#Global Vars
#{
declare -A Commands
#}

theHelp()
{
	${LibDir}/help.sh ${Head} ${LangsDir} ${RunCplArgs} $@
}

errorCode()
{
	${LibDir}/errorCode.sh $@
}

#Handle Aliases
AddAlias()
{
	${LibDir}/AddAlias.sh $@
}

Art()
{
	if [ ! -z "${IDEcolor}" ] && [ ! -z "${CLcolor}" ] && [ ! -z "${BKTcolor}" ]; then
		local CL="\e[1;4${CLcolor}m"
		local BKT="\e[1;4${BKTcolor}m"
		local IDE="\e[1;4${IDEcolor}m"
		local end="\e[0m"
		echo -e "                ____                         ____ "
		echo -e "               ${BKT}|  __|${end}                       ${BKT}|__  |${end}"
		echo -e "   ___   _     ${BKT}| |${end}  _______    _____     ____  ${BKT}| |${end}"
		echo -e "  ${CL}/ __|${end} ${CL}| |${end}    ${BKT}| |${end} ${IDE}|__   __|${end}  ${IDE}|  __ \\\\${end}   ${IDE}|  __|${end} ${BKT}| |${end}"
		echo -e " ${CL}/ /${end}    ${CL}| |${end}    ${BKT}| |${end}    ${IDE}| |${end}     ${IDE}| |${end}  ${IDE}\ \\\\${end}  ${IDE}| |${end}_   ${BKT}| |${end}"
		echo -e "${CL}| |${end}     ${CL}| |${end}    ${BKT}| |${end}    ${IDE}| |${end}     ${IDE}| |${end}  ${IDE}| |${end}  ${IDE}|  _|${end}  ${BKT}| |${end}"
		echo -e " ${CL}\ \\\\${end}__  ${CL}| |${end}__  ${BKT}| |${end}  __${IDE}| |${end}__   ${IDE}| |${end}__${IDE}/ /${end}  ${IDE}| |${end}__  ${BKT}| |${end}"
		echo -e "  ${CL}\___|${end} ${CL}|____|${end} ${BKT}| |${end} ${IDE}|_______|${end}  ${IDE}|_____/${end}   ${IDE}|____|${end} ${BKT}| |${end}"
		echo -e "               ${BKT}| |${end}__                         __${BKT}| |${end}"
		echo -e "               ${BKT}|____|${end}                       ${BKT}|____|${end}"
	else
		echo -e "                ____                         ____ "
		echo -e "               |  __|                       |__  |"
		echo -e "   ___   _     | |  _______    _____     ____  | |"
		echo -e "  / __| | |    | | |__   __|  |  __ \   |  __| | |"
		echo -e " / /    | |    | |    | |     | |  \ \  | |_   | |"
		echo -e "| |     | |    | |    | |     | |  | |  |  _|  | |"
		echo -e " \ \__  | |__  | |  __| |__   | |__/ /  | |__  | |"
		echo -e "  \___| |____| | | |_______|  |_____/   |____| | |"
		echo -e "               | |__                         __| |"
		echo -e "               |____|                       |____|"
	fi
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
	local TheLang=$1
	local Langs=${LangsDir}/Lang.${TheLang^}
	local PassedVars=( "${RunCplArgs}" )
	#Make first letter uppercase
	shift
	local Manage=$@
	if [ -f ${Langs} ]; then
		${Langs} ${PassedVars[@]} ${Manage[@]}
	else
		UseOther ${TheLang} ${Manage[@]}
	fi
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
			theHelp ModesHelp
			;;
		*)
			theHelp ModesHelp
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
		mkdir "${TemplateProjectDir}"
		mkdir "${ActiveProjectDir}"
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

DebugVersion()
{
	local TheLang=$1
	local Langs=""
	if [ ! -z "${TheLang}" ]; then
		ManageLangs ${TheLang} "getDebugVersion"
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
					ManageLangs "${text}" "getDebugVersion" | sed "s/Version:/${text}:/g"
					;;
			esac
			look=$((${look}+1))
		done
	fi
}

Banner()
{
	local Type=$1
	local Version=$(echo ${Version} | tr -d '\n')
	case ${Type} in
		main)
			Art
			;;
		*)

			ManageLangs ${Type} "Art"
			;;
	esac
	if [ ! -z "${VerColor}" ]; then
		echo -e "(\e[1;4${VerColor}m${Version}\e[0m)"
	else
		echo "(${Version})"
	fi
	echo ""
	echo "\"Welcome to ${Head}\""
	echo "\"The command line IDE for the Linux/Unix user\""
}

#Search selected code for element
lookFor()
{
	local project=${CodeProject}
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

GetProjectType()
{
	local GetType
	GetType=$(ManageLangs "${text}" "GetProjectType")
	if [ ! -z "${GetType}" ]; then
		ProjectType=${GetType}
	fi
}

#Save Last Session
SaveSession()
{
	local Session="${ClideDir}/session"
	local Project=${CodeProject}
	local Language=$1
	local SrcCode=$2
	#Source Needs to be present
	if [ ! -z "${SrcCode}" ]; then
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
	local projectType=$4
	if [ -z "${projectType}" ]; then
		projectType="Generic"
	fi

	local ProjectFile=${ActiveProjectDir}/${Name}.clide
	if [ ! -z "${Name}" ]; then
#		Path=$(eval $(echo ${Path}))
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
						echo "type=${projectType}" >> ${ProjectFile}
						echo "path=${Path}" >> ${ProjectFile}
						echo "src=" >> ${ProjectFile}
						echo "[Project \"${Name}\" Imported"
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
	local projectType=$3
	local ProjectFile=${ActiveProjectDir}/${project}.clide
	local path=""
	#No Project is found
	if [ -z "${project}" ]; then
		errorCode "project" "none" "${Head}"
	else
		if [ -z "${projectType}" ]; then
			projectType="Generic"
		fi
		path=$(ManageLangs ${Lang} "newProject" "${projectType}" ${project})
		if [ ! -z "${path}" ]; then
			#Grab Project Data
			#Name Value
			echo "name=${project}" > ${ProjectFile}
			#Language Value
			echo "lang=${lang}" >> ${ProjectFile}
			#Type Value
			echo "type=${projectType}" >> ${ProjectFile}
			#Path Value
			echo "path=${path}" >> ${ProjectFile}
			#Source Value
			echo "src=" >> ${ProjectFile}
			if [ -d "${path}/src/" ]; then
				#Create Project and get path
				cd ${path}/src
				ProjectType=${projectType}
			else
				rm ${ProjectFile}
			fi
		else
			errorCode "project" "type" "${Head}"
		fi
	fi
}

#Update config of active Projects
updateProject()
{
	local src=$1
	local project=${CodeProject}
	local ProjectFile=${ActiveProjectDir}/${project}.clide
	#No Project is found
	if [ ! -z "${src}" ]; then
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

linkProjects()
{
	local Lang=$1
	local LinkLang=$2
	local ThePath
	local LinkPath
	local project
	if [ ! -z "${3}" ]; then
		project=$3
	else
		project=${CodeProject}
	fi
	local ProjectFile=${ActiveProjectDir}/${project}.clide
	LinkLang="${LinkLang,,}"
	LinkLang="${LinkLang^}"

	if [ ! -z "${LinkLang}" ]; then
		local Already=$(grep "link=" ${ProjectFile})
		local Langs=$(ls ${LangsDir}/ | sed "s/Lang./|/g")
		ThePath=$(ManageLangs ${LinkLang} "getProjDir")
		LinkPath=$(ManageLangs ${Lang} "getProjDir")
		Langs=$(echo ${Langs} | tr -d ' ')
		Langs="${Langs}|"
		case ${Langs} in
			*"|${LinkLang}|"*)
				if [ -z "${Already}" ]; then
					echo "link=${Lang},${LinkLang}," >> ${ProjectFile}
					if [ ! -f ${LinkPath}/${project} ]; then
						cd ${ThePath}
						ln -s ${LinkPath}/${project} 2> /dev/null
						cd - > /dev/null
					fi
					echo ${LinkLang}
				else
					case ${Already} in
						*"${LinkLang},"*)
							;;
						*)
							sed -i "s/${Already}/${Already}${LinkLang},/g" ${ProjectFile}
							if [ ! -f ${LinkPath}/${project} ]; then
								cd ${ThePath}
								ln -s ${LinkPath}/${project} 2> /dev/null
								cd - > /dev/null
							fi
							echo ${LinkLang}
							;;
					esac
				fi
				;;
			*)
				;;
		esac
	fi
}

swapProjects()
{
	local Lang=$1
	local LinkLang=$2
	local ThePath
	local LinkPath
	LinkLang="${LinkLang,,}"
	LinkLang="${LinkLang^}"
	local project=${CodeProject}
	local ProjectFile=${ActiveProjectDir}/${project}.clide
	local Already=$(grep "link=" ${ProjectFile})

	if [ ! -z "${LinkLang}" ]; then
		local Langs=$(ls ${LangsDir}/ | sed "s/Lang./|/g")
		Langs=$(echo ${Langs} | tr -d ' ')
		Langs="${Langs}|"
		case ${Langs} in
			*"|${LinkLang}|"*)
				if [ ! -z "${Already}" ]; then
					case ${Already} in
						*"${LinkLang},"*)
							echo ${LinkLang}
							;;
						*)
							;;
					esac
				fi
				;;
			*)
				;;
		esac
	fi
}

#list active projects
listProjects()
{
	#Get list of active prijects from .clide files
	cd ${ActiveProjectDir}/
	ls *.clide 2> /dev/null | sed "s/.clide//g"
	cd - > /dev/null
}

#Discover Project in clide
discoverProject()
{
	local Action=$1
	local LinkLang=$2
	local cLinkLang
	local TheProjName=$3
	local NotDone=$4
	local TheLang
	local cTheLang
	local Langs=$(ls ${LangsDir}/ | sed "s/Lang.//g" | tr '\n' '|' | rev | sed "s/|//1" | rev)
	local NumOfLangs=$(ls ${LangsDir}/ | wc -l)
	local NumOfProject
	local look=1
	local For
	local text
	local Name
	local cName
	local Path
	local ChosenLangs=""
	while [ ${look} -le ${NumOfLangs} ];
	do
		TheLang=$(echo ${Langs} | cut -d '|' -f ${look})
		text=$(ManageLangs ${TheLang} "discoverProject")
		if [ ! -z "${text}" ]; then
			Path=$(echo ${text} | cut -d ":" -f 1)
			text=$(echo ${text} | cut -d ":" -f 2)
			NumOfProject=$(echo ${text} | tr '|' '\n' | wc -l)
			For=1
			while [ ${For} -le ${NumOfProject} ];
			do
				Name=$(echo ${text} | cut -d '|' -f ${For})
				case ${Action} in
					relink)
						#Ignore anything that isn't a symbolic link
						if [ -L ${Path}${Name} ]; then
							case ${TheProjName} in
								${Name})
									cTheLang=$(color "${TheLang}")
									cLinkLang=$(color "${LinkLang}")
									echo -e "\tLinking ${cLinkLang} ---> ${cTheLang}"
									linkProjects ${LinkLang} ${TheLang} ${Name} > /dev/null
									;;
								*)
									;;
							esac
						fi
						;;
					*)
						#Ignore anything that isn't a symbolic link
						if [ ! -L ${Path}${Name} ]; then
							if [ ! -f ${ActiveProjectDir}/${Name}.clide ]; then
								cName=$(color "${Name}")
								cTheLang=$(color "${TheLang}")
								cLinkLang=$(color "${LinkLang}")
								echo "[${cTheLang} Project: ${cName}]"
								importProject ${TheLang} ${Name} ${Path}${Name} > /dev/null
								echo -e "\tProject Imported"
								discoverProject "relink" ${TheLang} ${Name} "Not Done"
							fi
						fi
						;;
				esac
				For=$((${For}+1))
			done

		fi
		look=$((${look}+1))
	done
	if [ -z "${NotDone}" ]; then
		echo ""
		echo "${Head} is all caught up"
	fi
}

#Load active projects
loadProject()
{
	local project=$1
	local ProjectFile=${ActiveProjectDir}/${project}.clide
	local path=""
	local RtnVals=""
	local tag=""
	if [ ! -d "${ClideDir}" ]; then
		errorCode "project"
	else
		#Is not a project
		if [ -z "${project}" ]; then
			echo "no"
		else
			#Locate Project Directory
			if [ -f ${ProjectFile} ]; then
				#Grab Project Data
				#Name Value
				tag="name="
				name=$(grep ${tag} ${ProjectFile} | sed "s/${tag}//g")
				#Project Type
				tag="type="
				ProjectType=$(grep ${tag} ${ProjectFile} | sed "s/${tag}//g")
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
				RtnVals="${lang};${src};${path};${ProjectType}"
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
	local TheFile
	if [ ! -z "${src}" ]; then
		case  ${src} in
			--force)
				src=${option}
				option="--force"
				;;
			*)
				;;
		esac

		case ${active} in
			*"${src}"*)
				if [ "${option}" == "--force" ]; then
					TheFile=$(ManageLangs ${Lang} "rmBin" ${src})
					if [ ! -z "${TheFile}" ]; then
						rm ${TheFile}
					fi
					TheFile=$(ManageLangs ${Lang} "rmSrc" ${src})
					if [ ! -z "${TheFile}" ]; then
						rm ${TheFile}
					fi
					echo "\"${src}\" is REMOVED"
				else
					clear
					errorCode "remove" "sure"
					echo -n "Are you Sure you want to remove \"${src}\" (YES/NO)? "
					read User
					case ${User} in
						YES)
							clear
							TheFile=$(ManageLangs ${Lang} "rmBin" ${src})
							if [ ! -z "${TheFile}" ]; then
								rm ${TheFile}
							fi
							TheFile=$(ManageLangs ${Lang} "rmSrc" ${src})
							if [ ! -z "${TheFile}" ]; then
								rm ${TheFile}
							fi
							echo "\"${src}\" is REMOVED"
							;;
						*)
							clear
							echo "\"${src}\" is NOT removed"
							;;
	 				esac
					errorCode "remove" "hint"
				fi
				;;
			*)
				errorCode "remove" "not-file" "${src}"
				;;
		esac
	else
		errorCode "remove" "hint"
	fi
}

runCode()
{
	local Lang=$1
	local name=$2
	shift
	local option=$3
	shift
	shift
	shift
	local Args=( $@ )
	local First="${Args[0]}"
	local JavaProp="none"
	local TheBin=""
	case ${name} in
		*,*)
			TheBin=$(ManageLangs ${Lang} "getBin" "${name}")
			;;
		*)
			TheBin=${name}
			;;
	esac
	#Come up with a way to know if arguments are needed
	TheLang=$(color "${Lang}")
	#User Wishes to provide arments for program
	case ${option} in
		-a|--args)
			CLIout=$(ManageLangs ${Lang} "cli" "${TheBin}")
			CLIout="$USER@${Name}:~/${TheLang}\$ ${CLIout}"
			#User Args not Pre-done'
			if [ -z "${First}" ]; then
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
			fi
			;;
		*)
			;;
	esac
	ManageLangs ${Lang} "runCode" "${TheBin}" "${JavaProp}" ${Args[@]}
}

ManageCreate()
{
	local Lang=$1
	shift
	local Code=$1
	shift
	local Choice=$1
	shift
	local CreateArgs=( $@ )
	if [ ! -z "${Choice}" ]; then
		ManageLangs ${Lang} "${Choice}" ${Code} ${UserIn[@]}
	else
		#Show help page
		theHelp CreateHelp ${Lang}
	fi
}

selectProjectMode()
{
	local Lang=$1
	local mode=$2
	ManageLangs ${Lang} "projectMode" ${mode}
}

selectCode()
{
	local Lang=$1
	local name=$2
	local old=$3
	name=$(ManageLangs ${Lang} "selectCode" ${name})
	if [ ! -z "${name}" ]; then
		echo ${name}
	else
		echo ${old}
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
	local Lang=$1
	Lang=${Lang,,}
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

#No-Lang IDE
Actions-NoLang()
{
	history -c
	local NoLang=cl[$(echo -e "\e[1;41mide\e[0m")]
	local UserIn
#	local prompt="${NoLang}($(echo -e "\e[1;41mno-lang\e[0m")):$ "
#	local prompt="${NoLang}($(echo -e "\e[1;31mno-lang\e[0m")):$ "
	local prompt="${NoLang}():$ "
#	local prompt="${NoLang}:$ "
	while true
	do
		read -e -p "${prompt}" -a UserIn
		if [ ! -z "${UserIn[0]}" ]; then
			history -s "${UserIn[@]}"
		fi

		case ${UserIn[0],,} in
			clear)
				clear
				;;
			edit)
				case ${UserIn[1],,} in
					config)
						main "--edit" "--config"
						;;
					*)
						;;
				esac
				;;
			exit)
				break
				;;
			version)
				main "--version"
				;;
			#Get compile/interpreter version from cli
			cv|code-version)
				main "--code-version"
				;;
			#Get compile/interpreter version from cli
			dv|debug-version)
				main "--debug-version"
				;;
			#Get compile/interpreter version from cli
			sv|support-version)
				main "--support-version"
				;;
			#Get version of template
			tv|temp-version)
				main "--temp-version"
				;;
			#Get version control version from cli
			rv|repo-version)
				main "--repo-version"
				;;
			use|bash|c|c++|go|java|python|perl|ruby)
				local Lang
				local Code
				case ${UserIn[0],,} in
					use)
						if [ ! -z "${UserIn[1]}" ]; then
							Lang=${UserIn[1]}
							Code=${UserIn[2]}
						else
							Lang=""
						fi
						;;
					*)
						Lang=${UserIn[0]}
						Code=${UserIn[1]}
						;;
				esac

				#Ignore if program resolves to alias
				local AliasTest=$(echo ${Lang} | grep "/")
				if [ -z "${AliasTest}" ]; then
					#Run clide
					main ${Lang} ${Code}
				fi
				break
				;;
			#Display help page
			help)
				theHelp MenuHelp "no-lang"
				;;
			*)
				;;
		esac
	done
}

#IDE
Actions()
{
	loadAuto
	local Dir=""
	local ProjectDir=""
	local Lang="$1"
	local Code="$2"
	shift
	shift
	local CodeDir=$(pgDir ${Lang})
	local pLangs=$(ColorCodes)
	local prompt=""
	local listSrc
	local cntSrc
	local ThePWD
	local refresh
	local UserArg
	local FirstAction=$1
	#Pass into array
	local UserIn=( $@ )
	CodeProject="none"

	#Language Chosen
	if [[ ! "${CodeDir}" == "no" ]]; then
		cd ${CodeDir}/${Dir}
		Code=$(selectCode ${Lang} ${Code})
		#Change Color for Language
		cLang=$(color ${Lang})
		#Handle the CLI User Interface
		#{
		if [ -z "${Code}" ]; then
			case ${CodeProject} in
				none)
					#Menu with no code
					prompt="${Name}(${cLang}):$ "
					;;
				*)
					ThePWD=${PWD}
					#ProjectDir=${ThePWD#*${CodeProject}}
					ProjectDir=${ThePWD##*/}
					#ProjectDir=${ProjectDir/\//:}
					cCodeProject=$(ManageLangs ${Lang} "ProjectColor")
					#Menu with no code
					prompt="${Name}(${cCodeProject}[${ProjectType:0:1}${ProjectDir}]):$ "
					;;
			esac
		else
			#Change Color for Code
			cCode=$(color ${Code})
			case ${Code} in
				*,*)
					cntSrc=$(echo ${Code} | tr ',' '\n' | wc -l)
					case ${cntSrc} in
						2)
							listSrc=${cCode}
							;;
						*)
							listSrc=$(color ${cntSrc})
							;;
					esac
					;;
				*)
					listSrc=${cCode}
					;;
			esac
			case ${CodeProject} in
				none)
					#Menu with code
					prompt="${Name}(${cLang}{${listSrc}}):$ "
					;;
				*)
					ThePWD=${PWD}
					#ProjectDir=${ThePWD#*${CodeProject}}
					ProjectDir=${ThePWD##*/}
					#ProjectDir=${ProjectDir/\//:}
					#Menu with no code
					cCodeProject=$(ManageLangs ${Lang} "ProjectColor")
					prompt="${Name}(${cCodeProject}[${ProjectType:0:1}:${ProjectDir}]{${listSrc}}):$ "
					;;
			esac
		fi
		#}
		case ${InAndOut} in
			yes)
				;;
			*)
				Banner ${Lang}
				;;
		esac
		while true
		do
			#User's first action
			if [ ! -z "${FirstAction}" ]; then
				UserArg=${FirstAction,,}
				FirstAction=""
			else
				#Handle CLI
				#read -a UserIn
				read -e -p "${prompt}" -a UserIn
				UserArg=${UserIn[0],,}
			fi
			case ${UserArg} in
				#List files
				ls)
					ls ${UserIn[1]}
					;;
				lscpl)
					ManageLangs ${Lang} "lscpl"
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
					if [ -z "${Code}" ]; then
						Code=$(selectCode ${Lang} ${UserIn[1]} ${Code})
						refresh="yes"
					else
						errorCode "selectCode" "exists"
					fi
					;;
				#Unset code for session
				unset)
					Code=""
					refresh="yes"
					;;
				#Delete source code
				rm|remove|delete)
					Remove ${Code} ${UserIn[1]} ${UserIn[2]}
					Code=""
					refresh="yes"
					;;
				#Display the language being used
				using)
					echo "${cLang}"
					;;
				#change dir in project
				cd)
					local ProjectDir=$(ManageLangs ${Lang} "getProjectDir")
					#Use ONLY for Projects
					case ${CodeProject} in
						none)
							errorCode "project" "none"
							;;
						*)
							if [ ! -z "${UserIn[1]}" ]; then
								cd ${UserIn[1]} 2> /dev/null
								here=$(pwd)
								case ${here} in
									${ProjectDir}*)
										;;
									*)
										errorCode "project" "can-not-leave"
										cd - > /dev/null
										;;
								esac
							else
								cd ${ProjectDir}
							fi
							refresh="yes"
							;;
					esac
					;;
				#get pwd of dir
				pwd)
					#Use ONLY for Projects
					case ${CodeProject} in
						none)
							errorCode "project" "none" "${Head}"
							;;
						*)
							here=$(pwd)/
							echo ${here#*${CodeProject}}
							;;
					esac
					;;
				#make dir in project
				mkdir)
					#Use ONLY for Projects
					case ${CodeProject} in
						none)
							errorCode "project" "none" "${Head}"
							;;
						*)
							mkdir ${UserIn[1]}
							;;
					esac
					;;
				#handle java packages
				package)
					#Make sure this is a project
					case ${CodeProject} in
						none)
							errorCode "project" "active"
							;;
						*)
							#package commands
							case ${UserIn[1]} in
								#Create new package
								new)
									#Ensure package has a name
									if [ ! -z "${UserIn[2]}" ]; then
										ManageLangs ${Lang} "newPackage" ${UserIn[2]}
									fi
									;;
								*)
									;;
							esac
							;;
					esac
					;;
				#List source code
				src|source)
					echo ${Code} | tr ',' '\n'
					;;
				#Handle Projects
				project)
					#Project commands
					case ${UserIn[1]} in
						#Create new project
						new)
							#Ensure project has a name
							if [ ! -z "${UserIn[2]}" ]; then
								#Locate Project Directory
								if [ -f "${ClideDir}/projects/${UserIn[2]}.clide" ]; then
									errorCode "project" "exists" ${UserIn[2]}
								else
									newProject ${Lang} ${UserIn[2]} ${UserIn[3]} ${UserIn[4]}
									if [ -f ${ActiveProjectDir}/${UserIn[2]}.clide ]; then
										Code=""
										updateProject ${Code}
										if [ ! -z "${UserIn[2]}" ]; then
											CodeProject=${UserIn[2]}
											echo "Created \"${CodeProject}\""
											ProjectDir=$(echo ${ThePWD#*${CodeProject}})
											ProjectDir=${ProjectDir/\//:}
										fi
									else
										errorCode "project" "not-exist" ${UserIn[2]}
									fi
								fi
							fi
							refresh="yes"
							;;
						#Add a title to the project
						title)
							#Ensure this is a project
							case ${CodeProject} in
								#Is not a project
								none)
									errorCode "project" "none" "${Head}"
									;;
								#Is a project
								*)
									local TheFile=${ActiveProjectDir}/${CodeProject}.clide
									if [ -f ${TheFile} ]; then
										local HasTitle=$(grep "title=" ${TheFile})
										if [ -z "${HasTitle}" ]; then
											local Args
											echo -n "Title: "
											read -a Args
											if [ ! -z "${Args[0]}" ]; then
												echo "title=${Args[@]}" >> ${TheFile}
												echo "Title added"
											else
												errorCode "project" "no-title"
											fi
										else
											errorCode "project" "already-title" "${CodeProject}"
											HasTitle=$(echo ${HasTitle} | sed "s/title=//g")
											echo ""
											echo "Title: \"${HasTitle}\""
										fi
									fi
									;;
							esac
							;;
						#Update live project
						update)
							updateProject ${Code}
							echo "\"${CodeProject}\" updated"
							;;
						#Link a project with another language
						link)
							local project=${CodeProject}
						        local ProjectFile=${ActiveProjectDir}/${project}.clide
						        local Already=$(grep "link=" ${ProjectFile})
						        case ${UserIn[2]} in
					        	        --list|list)
				                        		echo ${Already} | sed "s/link=//g" | tr ',' '\n'
									;;
								*)
									local IsLinked=$(linkProjects ${Lang} ${UserIn[2]})
									if [ ! -z "${IsLinked}" ]; then
										Lang=${IsLinked}
										Code=""
									else
										errorCode "project" "link" "unable-link" ${UserIn[2]}
									fi
									;;
							esac
							;;
						swap)
							local project=${CodeProject}
							local ProjectFile=${ActiveProjectDir}/${project}.clide
							local Already=$(grep "link=" ${ProjectFile})
							case ${UserIn[2]} in
								#list the active projects
					        	        --list|list)
				                        		echo ${Already} | sed "s/link=//g" | tr ',' '\n'
									;;
								#swap new language and code
								*)
									local IsLinked=$(swapProjects ${Lang} ${UserIn[2]})
									if [ ! -z "${IsLinked}" ]; then
										Lang=${IsLinked}
										if [ ! -z "${UserIn[3]}" ]; then
											Code=$(selectCode ${Lang} ${UserIn[3]})
										else
											Code=""
										fi
									else
										errorCode "project" "link" "not-link" ${UserIn[2]}
									fi
									;;
							esac
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
									ProjectType=$(echo ${project} | cut -d ";" -f 4)
									CodeProject=${UserIn[2]}
									cd ${CodeDir}/src 2> /dev/null
									#Read title or project
									local TheFile=${ActiveProjectDir}/${CodeProject}.clide
									if [ -f ${TheFile} ]; then
										echo ""
										local HasTitle=$(grep "title=" ${TheFile})
										if [ ! -z "${HasTitle}" ]; then
											HasTitle=$(echo ${HasTitle} | sed "s/title=//g")
											echo "${CodeProject}: \"${HasTitle}\""
										else
											echo "Project \"${CodeProject}\" loaded"
										fi
										echo ""
									fi
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
						#Discover projects for clide
						discover)
							discoverProject
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
						#Swap between main and test
						mode)
							#Make sure this is a project
							case ${CodeProject} in
								none)
									errorCode "project" "active"
									;;
								*)
									if [ ! -z "${UserIn[2]}" ]; then
										local newMode=$(selectProjectMode ${Lang} ${UserIn[2]})
										if [ ! -z "${newMode}"]; then
											ProjectMode=${newMode}
										fi
									fi
									;;
							esac
							;;
						#List the projects under the language
						type)
							case ${UserIn[2]} in
								list)
									cd ${TemplateProjectDir}/
									ls ${Lang}.* 2> /dev/null | sed "s/${Lang}.//g"
									cd - > /dev/null
									;;
								*)
									case ${CodeProject} in
										none)
											echo "\"${Lang}\" Code"
											;;
										*)
											echo "${ProjectType} \"${Lang}\" Project"
											;;
										esac
									;;
							esac
							;;
						#Show Project help page
						*)
							theHelp ProjectHelp
							;;
					esac
					refresh="yes"
					;;
				#Swap Programming Languages
				use|bash|c|c++|go|java|python|perl|ruby)
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
						CodeProject="none"
						ProjectType="Generic"
						RunTimeArgs=""
						#}
					else
						Lang=${Old}
						echo "Supported Languages: ${pLangs}"
					fi
					refresh="yes"
					;;
				bkup|backup)
					local chosen=${UserIn[1]}
					case ${Code} in
						*,*)
							if [ ! -z "${chosen}" ]; then
								case ${Code} in
									*${chosen}*)
										ManageLangs ${Lang} "backup" ${chosen}
										;;
									*)
										errorCode "backup" "wrong"
										;;
								esac
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
								case ${Code} in
									*${chosen}*)
										ManageLangs ${Lang} "restore" ${chosen}
										;;
									*)
										errorCode "backup" "wrong"
										;;
								esac
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
								case ${Code} in
									*${chosen}*)
										ManageLangs ${Lang} "rename" ${chosen} ${TheNewChosen} > /dev/null
										Code=${Code//${chosen}/${TheNewChosen}}
										refresh="yes"
										;;
									*)
										errorCode "rename" "wrong"
										;;
								esac
							else
								errorCode "rename" "null"
							fi
							;;
						*)
							Code=$(ManageLangs ${Lang} "rename" ${Code} ${chosen})
							;;
					esac
					refresh="yes"
					;;
				cp|copy)
					local chosen=${UserIn[1]}
					local TheNewChosen=${UserIn[2]}
					case ${Code} in
						*,*)
							if [ ! -z "${TheNewChosen}" ]; then
								case ${Code} in
									*${chosen}*)
										ManageLangs ${Lang} "copy" ${chosen} ${TheNewChosen} > /dev/null
										Code=${Code//${chosen}/${TheNewChosen}}
										;;
									*)
										errorCode "copy" "wrong"
										;;
								esac
							else
								errorCode "backup" "null"
							fi
							;;
						*)
							Code=$(ManageLangs ${Lang} "copy" ${Code} ${chosen})
							;;
					esac
					refresh="yes"
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
							theHelp newCodeHelp ${Lang}
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
							local project=${CodeProject}
								#Ensure filename is given
							if [ ! -z "${UserIn[1]}" ]; then
								if [[ "${UserIn[1]}" == *","* ]]; then
									errorCode "newCode" "one-at-a-time"
									IsOk="no"
								elif [[ "${UserIn[1]}" == *";"* ]]; then
									errorCode "newCode" "one-at-a-time"
									IsOk="no"
								else
									local IsOk
									local TheFile="${UserIn[1]}"
									local TheExt=$(ManageLangs ${Lang} "getExt")
									local TheOtherExt=$(ManageLangs ${Lang} "getOtherExt")

									#Language has more than one extension
									if [ ! -z "${TheOtherExt}" ]; then
										#Remove the extensions
										TheFile=${TheFile%${TheExt}}
										TheFile=${TheFile%${TheOtherExt}}
										#make sure file does not exist
											if [ ! -f ${TheFile}${TheExt} ] || [ ! -f ${TheFile}${TheOtherExt} ]; then
											IsOk="yes"
										else
											IsOk="no"
										fi
									#Language has one extension
									else
										#Remove the extensions
										TheFile=${TheFile%${TheExt}}
										#make sure file does not exist
										if [ ! -f ${TheFile}${TheExt} ]; then
											IsOk="yes"
										else
											IsOk="no"
										fi
									fi

									#Make sure it is ok to create the source code
									case ${IsOk} in
										yes)
											#Return the name of source code
											ManageLangs ${Lang} "newCode" ${UserIn[1]} ${UserIn[2]} ${Code}
											if [ ! -z "${Code}" ]; then
												local OldCode=${Code}
												local NewCode=$(ManageLangs ${Lang} "getCode" ${UserIn[1]} ${OldCode})
												case ${OldCode} in
													*"${NewCode}"*)
														errorCode "selectCode" "already"
														;;
													*)
														Code=$(ManageLangs ${Lang} "addCode" ${OldCode} ${NewCode})
														;;
												esac
											else
												Code=$(ManageLangs ${Lang} "getCode" ${UserIn[1]} ${OldCode})
											fi
											refresh="yes"
											;;
											no)
											#Jump-in and Jump-out
											case ${InAndOut} in
												yes)
													errorCode "newCode" "cli-already"
													;;
												*)
													errorCode "newCode" "already"
													;;
											esac
											;;
										*)
											;;
									esac
								fi
							else
								theHelp newCodeHelp ${Lang}
							fi
							;;
					esac
					refresh="yes"

					#Jump-in and Jump-out
					case ${InAndOut} in
						yes)
							break
							;;
						*)
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
						#edit language source code
						*)
							ManageLangs ${Lang} "editCode" ${Code} ${UserIn[1]}
							;;
					esac
					;;
				#Add code to Source Code
				add)
					local theExt
					local theOtherExt
					local newCode
					if [ ! -z "${Code}" ]; then
						if [ ! -z "${UserIn[1]}" ]; then
							theExt=$(ManageLangs ${Lang} "getExt")
							theOtherExt=$(ManageLangs ${Lang} "getOtherExt")
							newCode=${UserIn[1]}
							newCode=${newCode%${theExt}}
							if [ ! -z "${theOtherExt}" ]; then
								newCode=${newCode%${theOtherExt}}
							fi
							#Ensure Code is not added twice
							if [[ ! "${Code}" == *"${newCode}${theExt}"* ]] || [[ ! "${Code}" == *"${newCode}${theOtherExt}"* ]]; then
								Code=$(ManageLangs ${Lang} "addCode" ${Code} ${newCode})
								refresh="yes"
							#Code is trying to be added twice
							else
								errorCode "selectCode" "already"
							fi
						else
							errorCode "selectCode" "nothing"
						fi
					else
						errorCode "selectCode" "set"
					fi
					;;
				#Read code without editing
				${ReadBy}|read)
					ManageLangs ${Lang} "readCode" ${Code} ${UserIn[1]}
					;;
				#Modes
				mode)
					local passCode=${Code}
					local passcCode=${cCode}
					if [ -z "${passCode}" ]; then
						passCode="none"
					fi
					if [ -z "${passcCode}" ]; then
						passcCode="none"
					fi
					#Swap cl[ide] to a given mode
					ModeHandler ${UserIn[1]} ${Lang} ${cLang} ${passCode} ${passcCode} ${UserIn[2]}
					;;
				#search for element in project
				search)
					lookFor ${UserIn[1]}
					;;
				#Write notes for code
				notes)
					#Handle language notes
					case ${UserIn[1]} in
						#create or edit notes for a given language
						edit|add)
							#Notes file does not exist...creating new
							if [ ! -f "${NotesDir}/${Lang}.notes" ]; then
								echo "[${Lang} Notes]" > ${NotesDir}/${Lang}.notes
							fi
							#Edit notes file
							${editor} ${NotesDir}/${Lang}.notes
							;;
						#If the file exists...read your notes
						read)
							if [ -f "${NotesDir}/${Lang}.notes" ]; then
								${ReadBy} ${NotesDir}/${Lang}.notes
							else
								echo "No notes for ${Lang} found"
							fi
							;;
						*)
							theHelp NotesHelp ${Lang}
							;;
					esac
					;;
				#create various files/vars for running/compiling code
				create)
					local NewVal
					local OldVal=${RunCplArgs}
					#what to create
					case ${UserIn[1]} in
						cpl|cpl-args)
							local options
							case ${UserIn[2]} in
								#User asks for help page
								help)
									#Get help page from language support file
									options=$(ManageLangs ${Lang} "setCplArgs-help" | tr '\n' '|')
									if [ -z "${options}" ]; then
										errorCode "cpl" "cpl-args"
									else
										echo ${options} | tr '|' '\n'
									fi
									;;
								*)
									#No value was given...yet
									if [ -z "${UserIn[2]}" ]; then
										#Show compile arguments options
										options=$(ManageLangs ${Lang} "setCplArgs-help" | tr '\n' '|')
										if [ -z "${options}" ]; then
											errorCode "cpl" "cpl-args"
										else
											echo ${options} | tr '|' '\n'
											#User input
											echo -n "${cLang}\$ "
											read -a NewVal

											#User provided a value
											if [ ! -z "${NewVal}" ]; then
												NewVal=( ${UserIn[0]} ${UserIn[1]} ${UserIn[2]} ${NewVal[@]} )
											fi
										fi
									#User gave pre-set argument
									else
										NewVal=${UserIn[@]}
									fi

									#User Value was given
									if [ ! -z "${NewVal}" ]; then
										#Checking and getting compile arguments
										local newCplArgs=$(ManageLangs ${Lang} "setCplArgs" ${Code} ${NewVal[@]})
										#compile argument was given
										if [ ! -z "${newCplArgs}" ]; then
											#Checks of returned values
											case ${RunCplArgs} in
												#Nothing previously given or was reset
												none)
													RunCplArgs="${newCplArgs}"
													;;
												#Value was already given
												*${newCplArgs}*)
													;;
												#Append new value to existing compile arguments
												*)
													RunCplArgs="${RunCplArgs},${newCplArgs}"
													;;
											esac
										fi
									fi
									;;
							esac
							;;
						#Args for run time
						args)
							echo -n "${cLang}\$ "
							read -a RunTimeArgs
							;;
						#Create new Template
						newCodeTemp)
							local NewCode=$(ManageLangs ${Lang} "getNewCode")
							local LangSrcDir=$(ManageLangs ${Lang} "getSrcDir")

							case ${UserIn[2]} in
								custom)
									if [ ! -f ${LangSrcDir}/${NewCode} ]; then
										ManageLangs ${Lang} "newCode" ${NewCode}
									fi
									Code=$(selectCode ${Lang} "set" ${NewCode})
									refresh="yes"
									;;
								default)
									#Create new souce code in newCode/
									if [ ! -f ${NewCodeDir}/${NewCode} ]; then
										if [ ! -f ${LangSrcDir}/${NewCode} ]; then
											ManageLangs ${Lang} "newCode" ${NewCode}
										fi
										mv ${LangSrcDir}/${NewCode} ${NewCodeDir}/
									fi

									#Copy and set source code to src/
									cd ${LangSrcDir}/
									if [ ! -f ${LangSrcDir}/${NewCode} ]; then
										case ${Lang} in
											Java)
												cp ${NewCodeDir}/${NewCode} .
												;;
											*)
												ln -s ${NewCodeDir}/${NewCode}
												;;
										esac
									else
										case ${Lang} in
											Java)
												local choice
												echo -n "Are you sure you want to overwrite \"${NewCode}\"? (Y/N): "
												read choice
												case ${choice^^} in
													Y|YES)
														cp ${NewCode} ${NewCodeDir}/
														;;
													*)
														;;
												esac
												;;
											*)
												;;
										esac
									fi
									Code=$(selectCode ${Lang} "set" ${NewCode})
									refresh="yes"
									;;
								help|*)
									theHelp CreateHelp ${Lang}
									;;
							esac
							;;
						#Clear all
						reset)
							#Default values
							RunTimeArgs=""
							RunCplArgs="none"
							echo "All rest"
							;;
						#Compile arguments
						${UserIn[1]}-${UserIn[2]})
							case ${OldVal} in
								none)
									RunCplArgs=$(ManageLangs ${Lang} "${UserIn[1]}-${UserIn[2]}" ${Code} ${UserIn[@]})
									;;
								*)
									RunCplArgs=$(ManageLangs ${Lang} "${UserIn[1]}-${UserIn[2]}" ${Code} ${UserIn[@]})
									RunCplArgs="${RunCplArgs} ${OldVal}"
									;;
							esac
							;;
						#Manage Create
						*)
							ManageCreate ${Lang} ${Code} ${UserIn[1]} ${UserIn[2]} ${UserIn[3]}
							;;
					esac
					;;
				#(c)ompile (a)nd (r)un
				car|car-a)
					ManageLangs ${Lang} "compileCode" ${Code} ${UserIn[1]} ${UserIn[2]}
					if [ ! -z "${Code}" ]; then
						case ${UserArg} in
							#Run without args
							car)
								runCode ${Lang} ${Code}
								;;
							#Run WITH args
							car-a)
								runCode ${Lang} ${Code} "run" "--args"
								;;
							*)
								;;
						esac
					fi
					;;
				#Compile code
				compile|cpl)
					ManageLangs ${Lang} "compileCode" ${Code} ${UserIn[1]} ${UserIn[2]}
					#Jump-in and Jump-out
					case ${InAndOut} in
						yes)
							break
							;;
						*)
							;;
					esac
					;;
				#Install compiled code into aliases
				install)
					ManageLangs ${Lang} "Install" ${Code} ${UserIn[1]}
					;;
				#Add debugging functionality
				debug)
					if [ ! -z "${Code}" ]; then
						local DebugEnabled
						local IsInstalled
						local HasDebugger=$(ManageLangs ${Lang} "getDebugger")
						if [ ! -z "${HasDebugger}" ]; then
							IsInstalled=$(which ${HasDebugger})
							if [ ! -z "${IsInstalled}" ]; then
								DebugEnabled=$(ManageLangs ${Lang} "IsDebugEnabled" "${Code}")
								case ${DebugEnabled} in
									yes)
										ManageLangs ${Lang} "debug" ${Code}
										;;
									none|*)
										errorCode "debug" "need-enable" "${Lang}" "${HasDebugger}"
										;;
								esac
							else
								errorCode "debug" "not-installed"
							fi
						else
							errorCode "debug" "not-set" "${Lang}"
						fi
					else
						errorCode "noCode"
					fi
					;;
				#run compiled code
				execute|exe|run)
					case ${UserIn[1]} in
						-d|--debug)
							ManageLangs ${Lang} "debug" ${Code} ${UserIn[1]}
							;;
						*)
							case ${CodeProject} in
								none)
									if [ ! -z "${Code}" ]; then
										runCode ${Lang} ${Code} ${UserIn[@]}
									else
										errorCode "cpl" "none"
									fi
									;;
								#It is assumed that the project name is the binary
								*)
									if [ ! -z "${Code}" ]; then
										runCode ${Lang} ${Code} ${UserIn[@]}
									else
										#May Cause Prolems
										runCode ${Lang} ${CodeProject} ${UserIn[@]}
									fi
									;;
							esac
							;;
					esac
					;;
				#Display cl[ide] version
				version|v)
					echo ""
					CodeSupportVersion ${Lang}
					echo ""
					CodeTemplateVersion ${Lang}
					echo ""
					CodeVersion ${Lang}
					echo ""
					DebugVersion ${Lang}
					;;
				#Display help page
				help)
					theHelp MenuHelp ${Lang}
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
					refresh="yes"
					;;
				#List supported languages
				langs|languages)
					local pg=$(ColorCodes)
					echo "Supported Languages: ${pg}"
					;;
				#Save cl[ide] session
				save)
					SaveSession ${Lang} ${Code}
					echo "session saved"
					;;
				#Close cl[ide]
				exit|close)
					break
					;;
				#ignore all other commands
				*)
					;;
			esac
			if [ ! -z "${UserIn[0]}" ]; then
				case ${UserIn[0]} in
					#ignore anything beginning with '-'
					-*)
						;;
					*)
						history -s "${UserIn[@]}"
						#Refresh CLI User Interface
						case ${refresh} in
							yes)
								#Handle the CLI User Interface
								#{
								#Change Color for Language
								cLang=$(color ${Lang})
								#Handle the CLI User Interface
								if [ -z "${Code}" ]; then
									case ${CodeProject} in
										none)
											#Menu with no code
											prompt="${Name}(${cLang}):$ "
											;;
										*)
											ThePWD=$(pwd)
											#ProjectDir=${ThePWD#*${CodeProject}}
											ProjectDir=${ThePWD##*/}
											#ProjectDir=${ProjectDir/\//:}
											cCodeProject=$(ManageLangs ${Lang} "ProjectColor")
											#Menu with no code
											prompt="${Name}(${cCodeProject}[${ProjectType:0:1}:${ProjectDir}]):$ "
											;;
									esac
								else
									#Change Color for Code
									cCode=$(color ${Code})
									case ${Code} in
										*,*)
											cntSrc=$(echo ${Code} | tr ',' '\n' | wc -l)
											case ${cntSrc} in
												2)
													listSrc=${cCode}
													;;
												*)
													listSrc=$(color ${cntSrc})
													;;
											esac
											;;
										*)
											listSrc=${cCode}
											;;
									esac
									case ${CodeProject} in
										none)
											#Menu with code
											prompt="${Name}(${cLang}{${listSrc}}):$ "
											;;
										*)
											ThePWD=${PWD}
											#ProjectDir=${ThePWD#*${CodeProject}}
											ProjectDir=${ThePWD##*/}
											#ProjectDir=${ProjectDir/\//:}
											#Menu with no code
											cCodeProject=$(ManageLangs ${Lang} "ProjectColor")
											prompt="${Name}(${cCodeProject}[${ProjectType:0:1}:${ProjectDir}]{${listSrc}}):$ "
											;;
									esac
								fi
								#}
								refresh="no"
								;;
							*)
								refresh="no"
								;;
						esac
						;;
				esac
			fi
		done
	fi
}

#Choose Lang by code
SelectLangByCode()
{
	local GetExt=$1
	local Langs
	local NumOfLangs
	local look
	local text
	local LangExt
	local ChosenLangs
	if [ ! -z "${GetExt}" ]; then
#		GetExt=".${GetExt##*.}"
#		echo ${GetExt}
		Langs=$(ls ${LangsDir}/ | sed "s/Lang.//g" | tr '\n' '|' | rev | sed "s/|//1" | rev)
		NumOfLangs=$(ls ${LangsDir}/ | wc -l)
		look=1
		while [ ${look} -le ${NumOfLangs} ];
		do
			text=$(echo ${Langs} | cut -d '|' -f ${look})
			text=$(ManageLangs ${text} "pgLang")
			case ${text} in
				no)
					;;
				*)
					LangExt=$(ManageLangs ${text} "getExt")
					case ${GetExt} in
						*${LangExt})
							pgLang ${text}
							break
							;;
						*)
							;;
					esac
					;;
			esac
			look=$((${look}+1))
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
	comp_list "save"
	comp_list "lscpl"
	comp_list "using"
	comp_list "ll"
	comp_list "clear"
	comp_list "debug"
	comp_list "set"
	comp_list "unset"
	comp_list "rm remove delete" "--force"
	comp_list "cd"
	comp_list "pwd"
	comp_list "mkdir"
	comp_list "use" "${pg}"
	comp_list "project" "discover import load list link mode new swap update title type"
	comp_list "package" "new"
	comp_list "shell"
	comp_list "new" "--version -v --help -h --custom -c"
	comp_list "${editor} ed edit" "non-lang"
	comp_list "add"
	comp_list "${ReadBy} read"
	comp_list "search"
	comp_list "create" "args cpl cpl-args make newCodeTemp reset version"
	comp_list "compile cpl car car-a"
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
			Banner "main"
			echo "enter \"no-lang\" or \"nl\" to enter into a ${Head} shell"
			echo ""
			echo "~Choose a language~"
			#Force user to select language
			while [[ "${getLang}" == "" ]] || [[ "${Lang}" == "no" ]];
			do
				prompt="${Name}(${pg}):$ "
				read -e -p "${prompt}" getLang
				case ${getLang} in
					exit)
						break
						;;
					no-lang|nl)
						Lang="no-lang"
						break
						;;
					*)
						#Verify Language
						Lang=$(pgLang ${getLang})
						;;
				esac
			done

			clear
			if [ ! -z "${Lang}" ]; then
				case ${Lang} in
					no-lang|nl)
						#Start IDE
						Actions-NoLang
						;;
					*)
						#Start IDE
						Actions ${Lang}
						;;
				esac
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
			-dv|--debug-version)
				DebugVersion
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
			#list supported Langauges
			-ll|--languages)
				local pg=$(ColorCodes)
				echo "Supported Languages: ${pg}"
				;;
			#List projects from cli
			-p|--project)
				shift
				local GetProject=$1
				if [ ! -z "${GetProject}" ]; then
					case ${GetProject} in
						--discover)
							discoverProject
							;;
						--build)
							shift
							local Lang
							local GetProject=$1
							if [ -z "${GetProject}" ]; then
								theHelp BuildHelp ${UserArg}
							else
								case ${GetProject} in
									#Provide the help page
									-h|--help)
										theHelp BuildHelp ${UserArg}
										;;
									*)
										TheProject=$(loadProject ${GetProject})
										if [ "${TheProject}" != "no" ]; then
											Lang=$(echo ${TheProject} | cut -d ";" -f 1)
											Lang=$(pgLang ${Lang})
											local CodeDir=$(echo ${TheProject} | cut -d ";" -f 3)
											if [ ! -z "${CodeDir}" ]; then
												echo "Needs work"
												cd ${CodeDir}
												ManageLangs ${Lang} "compileCode" ${GetProject} ${Args[@]}
											else
												errorCode "cli-cpl" "none"
											fi
										else
											echo "\"${GetProject}\" is Not a valid project"
										fi
										;;
								esac
							fi
							;;
						--list)
							listProjects
							;;
						-h|--help)
							theHelp ProjectCliHelp ${UserArg}
							;;
						*)
							TheProject=$(loadProject ${GetProject})
							if [ "${TheProject}" != "no" ]; then
								Lang=$(echo ${TheProject} | cut -d ";" -f 1)
								Lang=$(pgLang ${Lang})
								Actions ${Lang} "code" "project" "load" "${GetProject}"
								fi
							;;
					esac
				else
					theHelp ProjectCliHelp ${UserArg}
				fi
				;;
			#Get cli help page
			-h|--help)
				theHelp CliHelp ${UserArg} $2 $3
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
			--new)
				shift
				local Lang
				local Code=$2
				local Args
				if [ -z "${Code}" ]; then
					Lang=$(SelectLangByCode $1)
					if [ ! -z "${Lang}" ]; then
						Code=$1
						shift
						local Args=$@
						case ${Code} in
							-h|--help)
#								theHelp installHelp
								;;
							*)
								if [ ! -z "${Code}" ]; then
									main --new "${Lang}" "${Code}" ${Args[@]}
								fi
								;;
						esac
#					else
#						theHelp cplHelp
					fi
				else
					case ${Code} in
						--*)
							Lang=$(SelectLangByCode $1)
							Code=$1
							shift
							Args=$@
							;;
						*)
							Lang=$(pgLang $1)
							shift
							shift
							Args=$@
							;;
					esac
					case ${Lang} in
						no)
							echo "\"$1\" is not a supported language"
							;;
						*)
							local CodeDir=$(pgDir ${Lang})
							if [ ! -z "${CodeDir}" ]; then
								cd ${CodeDir}
								InAndOut="yes"
								Actions ${Lang} "code" "new" ${Code} ${Args[@]}
#							else
#								errorCode "cli-cpl" "none"
							fi
					esac
				fi
				;;
			--edit)
				shift
				local Action=$1
				case ${Action} in
					--config)
						local YourAnswer
						echo "WARNING!!!"
						echo "Editing this file incorrectly could render ${Head} unusable"
						echo ""
						echo -n "Do you wish to continue (y/n)> "
						read YourAnswer
						YourAnswer=${YourAnswer,,}
						case ${YourAnswer} in
							y)
								${editor} ${root}/var/clide.conf
								clear
								echo "Please restart ${Head} for changes to take affect"
								echo "May God have mercy on your ${Head}"
								echo ""
								;;
							*)
								;;
						esac
						;;
					*)
						if [ -z "${Action}" ]; then
							theHelp EditHelp
						else
							case ${Action} in
								-h|--help)
									theHelp EditHelp
									;;
								*)
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
												;;
										esac
									fi
									;;
							esac
						fi
						;;
				esac
				;;
			#compile code without entering cl[ide]
			--cpl|--compile)
				shift
				local Lang
				local Code=$2
				local Args
				if [ -z "${Code}" ]; then
					Lang=$(SelectLangByCode $1)
					if [ ! -z "${Lang}" ]; then
						Code=$1
						shift
						local Args=$@
						case ${Code} in
							-h|--help)
								theHelp cplHelp
								;;
							*)
								if [ ! -z "${Code}" ]; then
									main --cpl "${Lang}" "${Code}" ${Args[@]}
								fi
								;;
						esac
					else
						theHelp cplHelp
					fi
				else
					case ${Code} in
						--*)
							Lang=$(SelectLangByCode $1)
							Code=$1
							shift
							Args=$@
							;;
						*)
							Lang=$(pgLang $1)
							shift
							shift
							Args=$@
							;;
					esac
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
									InAndOut="yes"
									Actions ${Lang} "code" "cpl" ${Code} ${Args[@]}
								else
									errorCode "cli-cpl" "none"
								fi
							else
								errorCode "cli-cpl" "none"
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
					case ${Code} in
						-h|--help)
							theHelp installHelp
							;;
						*)
							if [ ! -z "${Code}" ]; then
								main --install "${Lang}" "${Code}" ${Args[@]}
							fi
							;;
					esac
				else
					shift
					shift
					local Args=$@
					case ${Lang} in
						no)
							errorCode "install" "cli-not-supported" "$1"
							theHelp installHelp
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
			#debug your compiled code
			--debug)
				;;
			#run your compiled code
			--run)
				shift
				local Lang=$1
				#Provide the help page
				if [ -z "${Lang}" ]; then
					theHelp RunHelp
				else
					local Lang=$(pgLang ${Lang})
					case ${Lang} in
						#Provide the help page
						-h|--help)
							theHelp RunHelp
							;;
						*)
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
					if [ ! -z "${Lang}" ] && [ ! -z "${Code}" ]; then
						main --read "${Lang}" "${Code}" ${Args[@]}
					fi
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
			--list-cpl)
				shift
				local Lang=$(pgLang $1)
				case ${Lang} in
					no)
						echo "\"$1\" is not a supported language"
						;;
					*)
						ManageLangs ${Lang} "lscpl"
						;;
				esac
				;;
			#Get by file extension
			*.*)
				local Code=$1
				local Lang=$(SelectLangByCode $1)
				local CodeDir=$(pgDir ${Lang})
				case ${CodeDir} in
					no)
						errorCode "not-a-lang"
						;;
					*)
						if [ ! -z "${CodeDir}" ]; then
							cd ${CodeDir}
							Code=$(selectCode ${Lang} ${Code})
							if [ ! -z "${Code}" ]; then
								#Start IDE
								Actions ${Lang} ${Code}
							fi
						fi
						;;
				esac
				;;
			#Check for language given
			*)
				#Verify Language
				local Lang=$1
				case ${Lang} in
					no-lang|nl)
						#Start IDE
						Actions-NoLang ${Args[@]}
						;;
					*)
						Lang=$(pgLang ${Lang})
						shift
						local Args=$@
						#Start IDE
						Actions ${Lang} ${Args[@]}
						;;
				esac
				;;
		esac
	fi
}

#Ignore if program resolves to alias
AliasTest=$(echo $@ | grep "/")
if [ -z "${AliasTest}" ]; then
	history -c
	#Run clide
	main $@
fi
