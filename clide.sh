Shell=$(which bash)
#!${Shell}
#Get path of the script
ShellPath=$(realpath $0)
#Get the dir name
root=$(dirname ${ShellPath})
#load the config files
source ${root}/var/clide.conf
source ${root}/var/version

#InAndOut determines if internal functions can run via cli
InAndOut="no"

#Name of the program
Head="cl[ide]"
#Give color of IDE
IDE=$(echo -e "\e[1;40mide\e[0m")
#cl[ide] in session
Name="cl[${IDE}]"

#Global Vars
#{
declare -A Commands
#}

#call help shell script
theHelp()
{
	${LibDir}/help.sh ${Head} ${LangsDir} ${RunCplArgs} $@
}

#call errorcode shell script
errorCode()
{
	${LibDir}/errorCode.sh $@
}

#Handle Aliases
AddAlias()
{
	${LibDir}/AddAlias.sh $@
}

ColorPrompt()
{
	echo -e "\e[1;40m${1}\e[0m"
}

#Handle the banner
Art()
{
	#Ensure ALL colors are refferenced in clide.conf
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
	#Fall back on no colors when ONE color is not present
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

#refference the modes allowed by cl[ide]
ModeHandler()
{
	local Mode=$1
	local Lang=$2
	local cLang=$3
	local Code=$4
	local cCode=$5
	shift
	shift
	shift
	shift
	shift
	local Arg=$@
	case ${Mode} in
		${repoTool}|repo)
			#Use ONLY for Projects
			if [[ ! "${CodeProject}" == "none" ]]; then
				${ModesDir}/repo.sh
			else
				errorCode "project" "must-be-active"
			fi
			;;
		pkg)
			${ModesDir}/pkg.sh
			;;
		add)
			${ModesDir}/add.sh ${Head} "${LibDir}" "${LangsDir}" "${ClideProjectDir}" ${Lang} ${cLang} ${Code} ${cCode} ${Arg[@]}

			;;
		#Provide help page when asked
		-h|--help)
			theHelp ModesHelp
			;;
		#Provide help page when nothing is asked
		*)
			theHelp ModesHelp
			;;
	esac
}

#Make sure the propper directories are in place in order for cl[ide] to run
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
		mkdir "${ImportProjectDir}"
		mkdir "${ExportProjectDir}"
	fi

	#Handle the langauge specific directories
	#{
	#Get the list of Lang.<language> files from cl[ide]
	local text
	for TheLang in ${LangsDir}/Lang.*; do
		#Select the next langauge
		TheLang=${TheLang##*/}
		text=${TheLang#Lang.*}
		#Make sure language is supported on computer
		text=$(ManageLangs ${text} "pgLang")
		case ${text} in
			no)
				;;
			*)
				#Call the Lang.<language> to ensure directories
				ManageLangs "${text}" "EnsureDirs"
				;;
		esac
	done
	#}
}

#provide the langauge number of cl[ide]
ClideVersion()
{
	echo ${Version}
}

#Get repo version
RepoVersion()
{
	IsInstalled=$(which ${repoTool})
	if [ ! -z "${IsInstalled}" ]; then
		${repoTool} --version
	else
		errorCode "mode-repo" "not-installed" ${repoTool}
	fi
}

#Get the version of the Lang.<language>
CodeSupportVersion()
{
	local TheLang=$1
	local Langs=""
	local LangColor
	#Get the support version of the current language in session
	if [ ! -z "${TheLang}" ]; then
		LangColor=$(ManageLangs ${TheLang} "color-number")
		#Pull the version number form Lang.<language>
		SupportNum=$(ManageLangs ${TheLang} "SupportVersion")
		if [ ! -z "${SupportNum}" ]; then
			echo -e "\e[1;4${LangColor}m[Clide ${TheLang} Support]\e[0m"
			echo "Version: ${SupportNum}"
			echo ""
		fi
	#Get ALL support versions
	else
		local text
		local SupportNum
		for TheLang in ${LangsDir}/Lang.*;
		do
			#Select the next langauge
			TheLang=${TheLang##*/}
			text=${TheLang#Lang.*}
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
		done
	fi
}

#get the of the "new" code template...this assumes that "Version: <num>" is found in help page
CodeTemplateVersion()
{
	local TheLang=$1
	local TempNum
	local Langs=""
	local LangColor
	if [ ! -z "${TheLang}" ]; then
		LangColor=$(ManageLangs ${TheLang} "color-number")
		TempNum=$(ManageLangs ${TheLang} "TemplateVersion" | sed "s/Version/${text}/g" | grep -v found)
		if [ ! -z "${TempNum}" ]; then
			echo -e "\e[1;4${LangColor}m[\"New Code\" Template]\e[0m"
			echo "${TempNum}"
			echo ""
		fi
	else
		local CharCount
		local text
		for TheLang in ${LangsDir}/Lang.*;
		do
			#Select the next langauge
			TheLang=${TheLang##*/}
			text=${TheLang#Lang.*}
			text=$(ManageLangs ${text} "pgLang")
			case ${text} in
				no)
					#do nothing
					;;
				*)
					TempNum=$(ManageLangs "${text}" "TemplateVersion" | sed "s/Version/${text}/g" | grep -v found)
					if [ ! -z "${TempNum}" ]; then
						#Tab based on size of chars in lable
						CharCount=$(echo ${text} | wc -m)
						if [ ${CharCount} -lt 6 ]; then
							echo -e "(${text})\t\t{${TempNum}}"
						else
							echo -e "(${text})\t{${TempNum}}"
						fi
					fi
					;;
				esac
		done
	fi
}

#Get the compiler/interpreter version of language
CodeVersion()
{
	local TheLang=$1
	local Langs=""
	if [ ! -z "${TheLang}" ]; then
		ManageLangs ${TheLang} "CplVersion"
	else
		local text
		for TheLang in ${LangsDir}/Lang.*;
		do
			#Select the next langauge
			TheLang=${TheLang##*/}
			text=${TheLang#Lang.*}
			#Ensure langauge is supported on computer
			text=$(ManageLangs ${text} "pgLang")
			case ${text} in
				no)
					;;
				*)
					#Pull the compiler/interpreter version using Lang.<language>
					ManageLangs "${text}" "CplVersion" | sed "s/Version:/${text}:/g"
					;;
			esac
		done
	fi
}

DebugVersion()
{
	local TheLang=$1
	local Langs=""
	local LangColors
	local DebugV
	#Get the ddebugger version of the langauge in session
	if [ ! -z "${TheLang}" ]; then
		LangColor=$(ManageLangs ${TheLang} "color-number")
		DebugV=$(ManageLangs ${TheLang} "getDebugVersion")
		if [ ! -z "${DebugV}" ]; then
			echo -e "\e[1;4${LangColor}m[${TheLang} Debugger]\e[0m"
			echo "${DebugV}"
			echo ""
		fi
	else
		local text
		for TheLang in ${LangsDir}/Lang.*;
		do
			#Select the next langauge
			TheLang=${TheLang##*/}
			text=${TheLang#Lang.*}
			#Ensure langauge is supported on computer
			text=$(ManageLangs ${text} "pgLang")
			case ${text} in
				no)
					;;
				*)
					#Pull degger version from Lang.<language>
					DebugV=$(ManageLangs "${text}" "getDebugVersion")
					if [ ! -z "${DebugV}" ]; then
						echo -n "${text}: "
						echo "${DebugV}"
					fi
					;;
			esac
		done
	fi
}

Banner()
{
	local Type=$1
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
	#Determin if it is a project
	case ${project} in
		#IS NOT a project
		none)
			#Provide message
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

recoverProject()
{
	local Lang=$1
	local Name=$2
	local Path=$3
	local projectType=$4
	#If project type is not provided, assume is generic
	if [ -z "${projectType}" ]; then
		projectType="Generic"
	fi

	local ProjectFile=${ActiveProjectDir}/${Name}.clide
	if [ ! -z "${Name}" ]; then
		if [ ! -f ${ProjectFile} ]; then

			if [ -z "${Path}" ]; then
				errorCode "project" "recover" "no-path"
			else
				case ${Path} in
					#Path does not exist and save details
					*${Name}|*${Name}/)
						local cName=$(color "${Name}")
						local cLang=$(color "${Lang}")
						#Format and save details into project file
						echo "name=${Name}" > ${ProjectFile}
						echo "lang=${Lang}" >> ${ProjectFile}
						echo "type=${projectType}" >> ${ProjectFile}
						echo "path=${Path}" >> ${ProjectFile}
						echo "src=" >> ${ProjectFile}
						echo "[Imported ${cLang} Project: ${cName}]"
						;;
					#Path does not exist
					*)
						errorCode "project" "recover" "name-in-path" "${Name}" "${Path}"
						;;
				esac
			fi
		else
			errorCode "project" "recover" "exists" "${Name}"
		fi
	else

		errorCode "project" "recover" "no-name"
	fi
}

exportProject()
{
	local project=$1
	if [ -z "${project}" ]; then
		project=${CodeProject}
	fi
	local ClideFile
	local ProjectLang
	local ProjectPath
	local ProjectType
	#Ensure this is a project
	case ${project} in
		#Is not a project
		none)
			errorCode "project" "none" "${Head}"
			;;
		#Is a project
		*)
			if [ -f ${ActiveProjectDir}/${project}.clide ]; then
				if [ -d ${ExportProjectDir} ]; then
					if [ ! -f ${ExportProjectDir}/${project}.tar.gz ]; then
						ClideFile=$(loadProject ${project})
						ProjectLang=$(echo ${ClideFile} | cut -d ';' -f 1)
						ProjectPath=$(echo ${ClideFile} | cut -d ';' -f 3)
						ProjectType=$(echo ${ClideFile} | cut -d ';' -f 4)
						if [ -d ${ProjectPath} ]; then
							cd ${ExportProjectDir}/
							case ${ProjectType} in
								Generic)
									cp -pR ${ProjectPath}/ .
									grep -v "path=" ${ActiveProjectDir}/${project}.clide > ${project}.clide
									tar -cpzf ${project}.tar.gz ${project}/ ${project}.clide 2> /dev/null
									rm -rf ${project} ${project}.clide
									;;
								*)
									if [ -f ${TemplateProjectDir}/${ProjectLang}.${ProjectType} ]; then
										cp -pR ${ProjectPath}/ .
										cp ${ActiveProjectDir}/${project}.clide .
										tar -cpzf ${project}.tar.gz ${project}/ ${project}.clide 2> /dev/null
										rm -rf ${project} ${project}.clide ${ProjectLang}.${ProjectType}
									fi
									;;
							esac
							cd - > /dev/null
							if [ -f ${ExportProjectDir}/${project}.tar.gz ]; then
								errorCode "HINT" "Exported: ${project}"
								errorCode "HINT"
								errorCode "HINT" "File: ${ExportProjectDir}/${project}.tar.gz"
							else
								errorCode "project" "export" "not-supported"
							fi
						else
							errorCode "project" "export" "corrupted"
						fi
					else
						errorCode "project" "export" "already" "${project}"
					fi
				else
					errorCode "project" "export" "not-found" "${project}"
				fi
			else
				errorCode "project" "export" "not-project" "${project}"
			fi
			;;
	esac
}

importProject()
{
	local ProjectLang=$1
	local project=$2
	local ProjectFile=${ActiveProjectDir}/${project}.clide
	local ClideFile
	local ProjectType
	local ProjectPath
	local IsSupported
	#No Project is found
	if [ -z "${project}" ]; then
		errorCode "project" "none" "${Head}"
	else
		#Make sure Imports dir exists
		if [ -d ${ImportProjectDir} ]; then
			#Make sure project.tar.gz exists and project isn't already installed
			if [ -f ${ImportProjectDir}/${project}.tar.gz ] && [ ! -f ${ActiveProjectDir}/${project}.clide ]; then
				#Go to Imports dir
				cd ${ImportProjectDir}/
				#Untar file
				tar xzf ${project}.tar.gz
				#Make sure the tar file has all the needed contents
				if [ -d ${project} ]; then
					if [ -f ${project}.clide ]; then
						#Move config file to clide's records
						grep -v "path=" ${project}.clide > ${ActiveProjectDir}/${project}.clide
						rm ${project}.clide
						#Get contents of file
						ClideFile=$(loadProject ${project})
						#Get Langauge
						ProjectLang=$(echo ${ClideFile} | cut -d ';' -f 1)
					fi
					#Check if language is supported
					IsSupported=$(ManageLangs ${ProjectLang} "pgLang")
					case ${IsSupported} in
						no)
							#remove config from clide
							if [ -f ${ActiveProjectDir}/${project}.clide ]; then
								rm ${ActiveProjectDir}/${project}.clide
							fi
							errorCode "project" "import" "not-supported" "${project}"
							;;
						*)
							#Get the project path from the language
							ProjectPath=$(ManageLangs ${ProjectLang} "getProjectDir")
							#Make sure project path was found and project isn't already installed
							if [ ! -d ${ProjectPath}/${project} ] && [ ! -z "${ProjectPath}" ]; then
								#make sure tar unziped the project directory
								if [ -d ${project} ]; then
									#Copy project to languages project folder
									cp -pR  ${project}/ ${ProjectPath}/
									if [ ! -f ${ActiveProjectDir}/${project}.clide ]; then
										recoverProject ${ProjectLang} ${project} ${ProjectPath}/${project} > /dev/null
									else
										#Record path into the config
										echo  "path=${ProjectPath}/${project}" >> ${ActiveProjectDir}/${project}.clide
										#Check for the project type
										ProjectType=$(echo ${ClideFile} | cut -d ';' -f 4)
										case ${ProjectType} in
											#if Generic...do nothing
											Generic)
												;;
											#If specified
											*)
												#Make sure project type was included in tar.gz
												if [ -f ${ProjectLang}.${ProjectType} ] && [ ! -z "${ProjectType}" ]; then
													#Make sure existing project type doesn't already exist
													if [ ! -f ${TemplateProjectDir}/${ProjectLang}.${ProjectType} ] && [ -d ${TemplateProjectDir} ]; then
														mv ${ProjectLang}.${ProjectType} ${TemplateProjectDir}/
													else
														rm ${ProjectLang}.${ProjectType}
													fi
												fi
												;;
										esac
									fi
									rm -rf ${project}/ ${project}.tar.gz
									errorCode "HINT" "${project} has been imported"
								fi
							else
								if [ -f ${ActiveProjectDir}/${project}.clide ]; then
									rm ${ActiveProjectDir}/${project}.clide
								fi
								errorCode "project" "exists" "${project}"
							fi
							;;
					esac
				cd - > /dev/null
				fi
			else
				errorCode "ERROR"
				errorCode "ERROR" "Please make this file exists"
				errorCode "HINT"
				errorCode "HINT" "File: ${ImportProjectDir}/${project}.tar.gz"

			fi
		fi
	fi
}

#Create new project
newProject()
{
	local lang=$1
	local project=$2
	local projectType=$3
	local ProjectFile=${ActiveProjectDir}/${project}.clide
	local path
	#No Project is found
	if [ -z "${project}" ]; then
		errorCode "project" "none" "${Head}"
	else
		if [ -z "${projectType}" ]; then
			projectType="Generic"
		else
			case ${projectType} in
				--*)
					projectType="Generic"
					;;
				*)
					;;
			esac
		fi

		#Get the project path from Lang.<language>
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
			local SrcLine=$(grep "src=" ${ProjectFile})
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
		local Langs=$(ls ${LangsDir}/ | sed "s/Lang./|/g" | tr -d '\n')
		ThePath=$(ManageLangs ${LinkLang} "getProjDir")
		LinkPath=$(ManageLangs ${Lang} "getProjDir")
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

#swap project to linked lagnauge
swapProjects()
{
	local Lang=$1
	local LinkLang=$2
	local ThePath
	local LinkPath
	#ALL Lowercase
	LinkLang="${LinkLang,,}"
	#FIRST character uppercase
	LinkLang="${LinkLang^}"
	local project=${CodeProject}
	local ProjectFile=${ActiveProjectDir}/${project}.clide
	local Already=$(grep "link=" ${ProjectFile})

	if [ ! -z "${LinkLang}" ]; then
		local Langs=$(ls ${LangsDir}/ | sed "s/Lang./|/g" | tr -d '\n')
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
	local Name
	local cName
	local Path
	local ChosenLangs=""

	for TheLang in ${LangsDir}/Lang.*;
	do
		#Select the next langauge
		TheLang=${TheLang##*/}
		TheLang=${TheLang#Lang.*}
		Path=$(ManageLangs ${TheLang} "discoverProject")
		if [ ! -z "${Path}" ]; then
			for Name in ${Path}/*;
			do
				if [ -d "${Name}" ]; then
					Name=$(echo ${Name} | sed "s/projects\//|/g" | cut -d '|' -f 2)
					case ${Action} in
						relink)
							#Ignore anything that isn't a symbolic link
							if [ -L ${Path}/${Name} ]; then
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
							if [ ! -L ${Path}/${Name} ]; then
								if [ ! -f ${ActiveProjectDir}/${Name}.clide ]; then
									cName=$(color "${Name}")
									cTheLang=$(color "${TheLang}")
									cLinkLang=$(color "${LinkLang}")
									echo "[${cTheLang} Project: ${cName}]"
									recoverProject ${TheLang} ${Name} ${Path}/${Name} > /dev/null
									errorCode "HINT" "\tProject Imported"
									discoverProject "relink" ${TheLang} ${Name} "Not Done"
								fi
							fi
							;;
					esac
				fi
			done

		fi
	done
	if [ -z "${NotDone}" ]; then
		echo ""
		errorCode "HINT" "${Head} is all caught up"
	fi
}

#Load active projects
loadProject()
{
	local project=$1
	local ProjectFile=${ActiveProjectDir}/${project}.clide
	local name
	local ProjectType
	local path
	local src
	local links
	local RtnVals
	local tag
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
				tag="link="
				links=$(grep ${tag} ${ProjectFile} | sed "s/${tag}//g")
				#return valid
				RtnVals="${lang};${src};${path};${ProjectType};${links}"
				echo ${RtnVals}
			else
				#return false value
				echo "no"
			fi
		fi
	fi
}

HandleJavaPackage()
{
	local Lang=$1
	local TheAction=$2
	local ThePackage=$3
	local PackageName=${ThePackage}
	#package commands
	case ${TheAction} in
		#Create new package
		new)
			#Ensure package has a name
			if [ ! -z "${ThePackage}" ]; then
				ManageLangs ${Lang} "newPackage" ${ThePackage}
				ThePackage=$(ManageLangs ${Lang} "setPackage" ${ThePackage})
				if [ ! -z "${ThePackage}" ]; then
					errorCode "HINT" "Package \"${PackageName}\" has been created"
					cd ${ThePackage}
				fi
			else
				errorCode "package" "null-name"
			fi
			;;
		set|check)
			#Ensure package has a name
			if [ ! -z "${ThePackage}" ]; then
				ThePackage=$(ManageLangs ${Lang} "setPackage" ${ThePackage})
				if [ ! -z "${ThePackage}" ]; then
					case ${TheAction} in
						set)
							errorCode "HINT" "Package \"${PackageName}\" Set"
							cd ${ThePackage}
							;;
						check)
							echo ${PackageName}
							;;
						*)
							;;
					esac
				else
					errorCode "package" "null-name"
				fi
			else
				errorCode "package" "null-name"
			fi
			;;
		list)
			ManageLangs ${Lang} "listPackage"
			;;
		*)
			theHelp PackageHelp
			;;
	esac
}

#remove source code and bin
Remove()
{
	local BinOnly=$1
	local active=$2
	local src=$3
	local option=$4
	local TheFile
	if [ ! -z "${src}" ]; then
		case ${src} in
			-f)
				src=${option}
				option="-f"
				;;
			*)
				;;
		esac
		case ${active} in
			*"${src}"*)
				case ${option} in
					-f)
						case ${BinOnly} in
							#Remove the binary ONLY
							--bin)
								#Get the binary path
								TheFile=$(ManageLangs ${Lang} "rmBin" ${src})
								if [ ! -z "${TheFile}" ]; then
									#remove file
									rm ${TheFile}
								fi
								TheFile=${TheFile##*/}
								echo "\"${TheFile}\" binary REMOVED"
								;;
							#Remove the source code ONLY
							--src)
								#Get the source code path
								TheFile=$(ManageLangs ${Lang} "rmSrc" ${src})
								if [ ! -z "${TheFile}" ]; then
									rm ${TheFile}
								fi
								TheFile=${TheFile##*/}
								echo "\"${TheFile}\" source code REMOVED"
								;;
							#remove ALL
							--all)
								Remove --bin ${active} ${src} ${option} > /dev/null
								Remove --src ${active} ${src} ${option} > /dev/null
								echo "binary and source code REMOVED"
								;;
							*)
								;;
						esac
						;;
					*)
						clear
						errorCode "remove" "sure"
						echo -n "Are you Sure you want to remove \"${src}\" (YES/NO)? "
						read User
						case ${User} in
							YES)
								option="-f"
								clear
								case ${BinOnly} in
									--bin)
										Remove --bin ${active} ${src} ${option} > /dev/null
										;;
									--src)
										Remove --src ${active} ${src} ${option} > /dev/null
										;;
									--all)
										Remove --bin ${active} ${src} ${option} > /dev/null
										Remove --src ${active} ${src} ${option} > /dev/null
										;;
									*)
										;;
								esac
								echo "\"${src}\" is REMOVED"
								;;
							*)
								clear
								echo "\"${src}\" is NOT removed"
								;;
	 					esac
						errorCode "remove" "hint"
						;;
				esac
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
	local TheBin
	local TheLang

#	case ${Lang} in
#		C|C++|Go|Java|Rust)
			case ${CodeProject} in
				none)
					TheBin=$(ManageLangs ${Lang} "getBin" "${name}")
					;;
				*)
					TheBin=$(ManageLangs ${Lang} "getBin" "${CodeProject}")
					;;
			esac
#			;;
#		*)
#			TheBin=$(ManageLangs ${Lang} "getBin" "${name}")
#			;;
#	esac

	if [ ! -z "${TheBin}" ]; then
		#User Wishes to provide arments for program
		case ${option} in
			-a|--args)
				TheLang=$(color "${Lang}")
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
		#Get the Lang.<language> to handle running the code
		ManageLangs ${Lang} "runCode" "${TheBin}" "${JavaProp}" ${Args[@]}
	else
		errorCode "cpl" "need" ${Lang}
	fi
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
	local text
	local TheColor
	local ChosenLangs=""

	for TheLang in ${LangsDir}/Lang.*;
	do
		#Select the next langauge
		TheLang=${TheLang##*/}
		text=${TheLang#Lang.*}
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
	done
	echo ${ChosenLangs}
}

preSelectSrc()
{
	local Lang=$1
	local Code=$2
	if [ -z "${Code}" ]; then
		Code=${Lang}
	fi
	case ${Code} in
		#Handle adding multiple files to initial session
		*,*)
			local TheCode
			local newCode
			#Keep track of initial request
			local WantedCode=${Code}
			#Clean source code
			Code=""
			# set comma as internal field separator for the string list
			for newCode in ${WantedCode//,/ };
			do
				#Set the first file
				if [ -z "${Code}" ]; then
					Code=$(selectCode ${Lang} ${newCode})
				#Add files
				else
					TheCode=$(ManageLangs ${Lang} "addCode" ${Code} ${newCode})
					if [ ! -z "${TheCode}" ]; then
						Code=${TheCode}
					fi
				fi
			done
			;;
		*)
			Code=$(selectCode ${Lang} ${Code})
			;;
	esac
	echo ${Code}
}

#No-Lang IDE
Actions-NoLang()
{
	history -c
	local NoLang=cl[$(echo -e "\e[1;41mide\e[0m")]
	local UserIn
	local prompt="${NoLang}($(echo -e "\e[1;31mno-lang\e[0m")):$ "
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
			#jump out of No-Lang session and into a language session
			use|bash|c|c++|go|java|python|perl|ruby|rust)
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
	local ProjectPrompt
	local FirstAction=$1
	#Pass into array
	local UserIn=( $@ )
	CodeProject="none"

	#Language Chosen
	if [[ ! "${CodeDir}" == "no" ]]; then
		cd ${CodeDir}/${Dir}
		Code=$(preSelectSrc ${Lang} ${Code})
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
					ProjectPrompt=$(ColorPrompt ${ProjectType:0:1}:${ProjectDir})
					prompt="${Name}(${cCodeProject}[${ProjectPrompt}]):$ "
					;;
			esac
		else
			#Change Color for Code
			cCode=$(color ${Code})
			case ${Code} in
				*,*)
					cntSrc=$(echo -e "${Code//,/\\n}" | wc -l)
					case ${cntSrc} in
						2)
							listSrc=${cCode}
							;;
						#Change listed source code to number
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
					ProjectPrompt=$(ColorPrompt ${ProjectType:0:1}:${ProjectDir})
					prompt="${Name}(${cCodeProject}[${ProjectPrompt}]{${listSrc}}):$ "
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

		#Keep IDE running until user is done
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

			if [ ! -z "${UserArg}" ]; then
				case ${UserArg} in
					#List files
					ls)
						ls ${UserIn[1]}
						;;
					lscpl)
						#list compiled code using Lang.<language>
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
					#Set for session or add code to session
					select|set|add)
						local theExt
						local theOtherExt
						local newCode
						local newCodeWithoutExt
						local OldCode
						if [ ! -z "${Code}" ]; then
							if [ ! -z "${UserIn[1]}" ]; then
								theExt=$(ManageLangs ${Lang} "getExt")
								theOtherExt=$(ManageLangs ${Lang} "getOtherExt")
								for newCode in ${UserIn[1]//,/ };
								do
									newCodeWithoutExt=$(ManageLangs ${Lang} "removeExt" ${newCode})
									#Ensure Code is not added twice
									if [[ ! "${Code}" == *"${newCodeWithoutExt}${theExt}"* ]] || [[ ! "${Code}" == *"${newCodeWithoutExt}${theOtherExt}"* ]]; then
										OldCode=${Code}
										Code=$(ManageLangs ${Lang} "addCode" ${Code} ${newCode})
										#make sure code has changed
										case ${Code} in
											#Code has not changed...do nothing
											${OldCode})
												errorCode "selectCode" "already" "${newCode}"
												;;
											#Code has changed
											*)
												#refresh
												refresh="yes"
												;;
										esac
									#Code is trying to be added twice
									else
										errorCode "selectCode" "already" "${newCode}"
									fi
								done
							else
								errorCode "selectCode" "nothing"
							fi
						else
							case ${UserArg} in
								select|set)
									if [ ! -z "${UserIn[1]}" ]; then
										Code=$(preSelectSrc ${Lang} ${UserIn[1]})
										refresh="yes"
									else
										errorCode "selectCode" "nothing"
									fi
									;;
								add)
									errorCode "selectCode" "set"
									;;
								*)
									;;
							esac
						fi
						;;
					#Unset code for session
					unset)
						Code=""
						refresh="yes"
						;;
					#Delete source code and binary
					rm|remove|delete)
						Remove "--all" ${Code} ${UserIn[1]} ${UserIn[2]}
						Code=""
						refresh="yes"
						;;
					#Delete source code
					rmsrc)
						Remove "--src" ${Code} ${UserIn[1]} ${UserIn[2]}
						Code=""
						refresh="yes"
						;;
					#Delete binary
					rmbin)
						Remove "--bin" ${Code} ${UserIn[1]} ${UserIn[2]}
						Code=""
						refresh="yes"
						;;
					#Display the language being used
					using)
						echo "${cLang}"
						;;
					#change dir in project
					cd)
						local here
						local ProjectDir=$(ManageLangs ${Lang} "getProjectDir")
						#Use ONLY for Projects
						case ${CodeProject} in
							none)
								errorCode "project" "none"
								;;
							*)
								if [ ! -z "${UserIn[1]}" ]; then
									cd ${UserIn[1]} 2> /dev/null
									here=${PWD}
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
						local here
						#Use ONLY for Projects
						case ${CodeProject} in
							none)
								errorCode "project" "none" "${Head}"
								;;
							*)
								here=${PWD}/
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
						case ${Lang} in
							Java)
								#Make sure this is a project
								case ${CodeProject} in
									none)
										errorCode "project" "active"
										;;
									*)
										HandleJavaPackage ${Lang} ${UserIn[1]} ${UserIn[2]}
										refresh="yes"
										;;
									esac
									;;
							*)
								errorCode "package" "need-java"
								;;
						esac
						;;
					#List source code
					src|source)
						echo -e "${Code//,/\\n}"
						;;
					make)
						case ${CodeProject} in
							#Is not a project
							none)
								errorCode "project" "none" "${Head}"
								;;
							#Is a project
							*)
								case ${Lang} in
									#only C and C++ uses make
									C*)
										case ${UserIn[1]} in
											delete)
												ManageLangs ${Lang} "delete-make"
												;;
											disable)
												ManageLangs ${Lang} "disable-make"
												;;
											enable)
												ManageLangs ${Lang} "enable-make"
												;;
											create)
												ManageLangs ${Lang} "create-make" "${Code}"
												;;
											edit)
												ManageLangs ${Lang} "edit-make"
												;;
											*|help)
												theHelp makeHelp ${Lang}
												;;
										esac
										;;
									*)
										errorCode "make" "not-for-lang" ${Lang}
										;;
								esac
								;;
						esac
						;;
					#Handle Projects
					project)
						#Project commands
						case ${UserIn[1]} in
							#Create new project
							new)
								local ProjectName=${UserIn[2]}
								#Ensure project has a name
								if [ ! -z "${ProjectName}" ]; then
									#Locate Project Directory
									if [ -f ${ActiveProjectDir}/${ProjectName}.clide ]; then
										errorCode "project" "exists" ${ProjectName}
									else
										newProject ${Lang} ${ProjectName} ${UserIn[3]} ${UserIn[4]}
										if [ -f ${ActiveProjectDir}/${ProjectName}.clide ]; then
											Code=""
											updateProject ${Code}
											if [ ! -z "${UserIn[2]}" ]; then
												CodeProject=${ProjectName}
												errorCode "HINT" "Created \"${CodeProject}\""
												ProjectDir=$(echo ${ThePWD#*${CodeProject}})
												ProjectDir=${ProjectDir/\//:}
											fi
										else
											errorCode "project" "not-exist" ${ProjectName}
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
							update|save)
								updateProject ${Code}
								echo "\"${CodeProject}\" updated"
								;;
							#list the project files
							files)
								local CodeDir=$(ManageLangs ${Lang} "getProjectDir")
								local RemoveDirs=${CodeDir//\//|}
								find ${CodeDir} -print | tr '/' '|' | sed "s/${RemoveDirs}//g" | tr '|' '/'
								;;
							#Delete project
							remove|delete)
								local TheProjectAction=${UserIn[1]}
								local project=${UserIn[2]}
								local text
								local ProjectPath
								local TheProject
								local TheLang
								local CodeDir
								local LangSrcDir

								case ${CodeProject} in
									${project})
										CodeProject="none"
										Code=""
										refresh="yes"
										LangSrcDir=$(ManageLangs ${Lang} "getSrcDir")
										if [ ! -z "${LangSrcDir}" ]; then
											cd ${LangSrcDir}
										fi
										;;
									*)
										;;
								esac

								case ${project} in
									all)
										CodeProject="none"
										Code=""
										refresh="yes"
										LangSrcDir=$(ManageLangs ${Lang} "getSrcDir")
										if [ ! -z "${LangSrcDir}" ]; then
											cd ${LangSrcDir}
										fi

										case ${TheProjectAction} in
											#remove project ONLY from record
											remove)
												rm ${ActiveProjectDir}/*.clide
												echo "ALL projects removed from record"
												;;
											#remove project files AND record
											delete)
												rm ${ActiveProjectDir}/*.clide
												#Handle the langauge specific directories
												#{
												#Get the list of Lang.<language> files from cl[ide]
												for TheLang in ${LangsDir}/Lang.*; do
													#Select the next langauge
													TheLang=${TheLang##*/}
													text=${TheLang#Lang.*}
													#Make sure language is supported on computer
													text=$(ManageLangs ${text} "pgLang")
													case ${text} in
														no)
															;;
														*)
															ProjectPath=$(ManageLangs ${text} "getProjectDir")
															if [ ! -z "${ProjectPath}" ] && [ -d "${ProjectPath}" ]; then
																rm -rf ${ProjectPath}/* 2> /dev/null
															fi
															;;
													esac
												done
												#}
												echo "Deleted ALL projects"
												;;
											*)
												;;
										esac
										;;
									*)
										if [ ! -z "${project}" ]; then
											case ${project} in
												--help)
													listProjects
													theHelp ProjectDelete
													;;
												*)
													case ${TheProjectAction} in
														#remove project ONLY from record
														remove)
															if [ -f "${ActiveProjectDir}/${project}.clide" ]; then
																rm ${ActiveProjectDir}/${project}.clide
																echo "Project \"${project}\" Removed"
															fi
															;;
														#remove project files AND record
														delete)
															TheProject=$(loadProject ${project})
															if [ "${TheProject}" != "no" ]; then
																TheLang=$(echo ${TheProject} | cut -d ";" -f 1)
																TheLang=$(pgLang ${TheLang})
																CodeDir=$(echo ${TheProject} | cut -d ";" -f 3)
																if [ ! -z "${CodeDir}" ]; then
																	rm -rf ${CodeDir} 2> /dev/null
																fi
																rm ${ActiveProjectDir}/${project}.clide 2> /dev/null
																echo "Deleted the \"${project}\" project"
															fi
															;;
														*)
															;;
													esac
													;;
											esac
										else
											listProjects
											theHelp ProjectDelete
										fi
										;;
								esac
								;;
							#Link a project with another language
							link)
								local project=${CodeProject}
								local ProjectFile=${ActiveProjectDir}/${project}.clide
								local Already=$(grep "link=" ${ProjectFile})
								case ${UserIn[2]} in
									--list|list)
										echo -e "${Already//,/\\n}" | sed "s/link=//g"
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
							use|swap)
								local here
								local project=${CodeProject}
								local ProjectFile=${ActiveProjectDir}/${project}.clide
								local Already=$(grep "link=" ${ProjectFile})
								local ProjectDir

								case ${UserIn[2]} in
									#list the active projects
									--list|list)
										echo -e "${Already//,/\\n}" | sed "s/link=//g"
										;;
									#swap new language and code
									*)
										local IsLinked=$(swapProjects ${Lang} ${UserIn[2]})
										if [ ! -z "${IsLinked}" ]; then
											Lang=${IsLinked}
											here=${PWD}/
											ProjectDir=$(ManageLangs ${Lang} "getProjectDir")
											if [ -d ${ProjectDir}${here#*${CodeProject}} ]; then
												cd ${ProjectDir}${here#*${CodeProject}}
											fi

											if [ ! -z "${UserIn[3]}" ]; then
												Code=$(selectCode ${Lang} ${UserIn[3]})
											else
												Code=""
											fi
										else
											echo "Linked Languages:"
											echo -e "${Already//,/\\n}" | sed "s/link=//g" | nl
											errorCode "project" "link" "not-link" ${UserIn[2]}
										fi
										;;
								esac
								;;
							#Load an existing project
							load|set|select)
								local here
								local HasLink
								local ChosenLang
								local IsLang=$(pgLang ${UserIn[2]})
								local TheFile
								local ProjectDir

								case ${IsLang} in
									no)
										ChosenLang=""
										project=$(loadProject ${UserIn[2]})
										CodeProject=${UserIn[2]}
										;;
									*)
										ChosenLang=${UserIn[2]}
										project=$(loadProject ${UserIn[3]})
										CodeProject=${UserIn[3]}
										;;
								esac

								#If no language given, try the active language
								if [ -z "${ChosenLang}" ]; then
									ChosenLang=${Lang}
								fi

								if [ "${project}" != "no" ]; then
									CodeDir=$(echo ${project} | cut -d ";" -f 3)
									CodeDir=$(eval echo ${CodeDir})

									if [ -d ${CodeDir} ]; then
										Lang=$(echo ${project} | cut -d ";" -f 1)
										Code=$(echo ${project} | cut -d ";" -f 2)
										ProjectType=$(echo ${project} | cut -d ";" -f 4)
										cd ${CodeDir}/src 2> /dev/null
										#Read title or project
										TheFile=${ActiveProjectDir}/${CodeProject}.clide
										if [ -f ${TheFile} ]; then
											if [ ! -z "${ChosenLang}" ]; then
												HasLink=$(grep "link=" ${TheFile} | grep ${ChosenLang})
												if [ ! -z "${HasLink}" ]; then
													Lang=${ChosenLang}
													here=${PWD}/

													ProjectDir=$(ManageLangs ${Lang} "getProjectDir")
													if [ -d ${ProjectDir}${here#*${CodeProject}} ]; then
														cd ${ProjectDir}${here#*${CodeProject}}
													fi
												fi
											fi

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
										CodeProject="none"
									fi
								else
									errorCode "project" "load" "no-project" "${UserIn[2]}"
									CodeProject="none"
								fi
								;;
							export)
								exportProject
								;;
							#Import project not created by cl[ide]
							import)
								if [ ! -z "${UserIn[2]}" ]; then
									if [ ! -z "${UserIn[3]}" ]; then
										importProject ${UserIn[2]} ${UserIn[3]}
									else
										importProject ${Lang} ${UserIn[2]}
									fi
								else
									errorCode "project" "import" "nothing-given"
								fi
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
					use|bash|c|c++|go|java|python|perl|ruby|rust|no-lang|nl)
						Old=${Lang}
						OldCode=${Code}
						case ${UserIn[0]} in
							use)
								if [ ! -z "${UserIn[1]}" ]; then
									case ${UserIn[1]} in
										no-lang|nl)
											#Start IDE
											Actions-NoLang
											;;
										*)
											Lang=$(pgLang ${UserIn[1]})
											Code=${UserIn[2]}
											;;
									esac
								else
									Lang="no"
								fi
								;;
							*)
								case ${UserArg} in
									no-lang|nl)
										#Start IDE
										Actions-NoLang
										;;
									*)
										Lang=$(pgLang ${UserIn[0]})
										Code=${UserIn[1]}
										;;
								esac
								;;
						esac

						if [[ ! "${Lang}" == "no" ]]; then
							cLang=$(color ${Lang})
							CodeDir=$(pgDir ${Lang})
							cd ${CodeDir}
							#Rest
							#{
							Code=$(preSelectSrc ${Lang} ${Code})
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
					#backup the selected code
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
					#restore the backup made
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
					#Rename the source code of selected code
					#OR
					#Make a copy of your selected code...similar to backup...but nothing to restore
					cp|copy|rename)
						local chosen=${UserIn[1]}
						local TheNewChosen=${UserIn[2]}
						case ${Code} in
							*,*)
								if [ ! -z "${TheNewChosen}" ]; then
									case ${Code} in
										*${chosen}*)
											local GetCount=$(echo -e ${Code//,/\\n} | grep ${chosen} | wc -l)
											case ${GetCount} in
												1)
													chosen=$(echo -e ${Code//,/\\n} | grep ${chosen})
													case ${UserArg} in
														rename)
															TheNewChosen=$(ManageLangs ${Lang} "rename" ${chosen} ${TheNewChosen})
															;;
														cp|copy)
															TheNewChosen=$(ManageLangs ${Lang} "copy" ${chosen} ${TheNewChosen})
															;;
														*)
															;;
													esac
													Code=${Code//${chosen}/${TheNewChosen}}
													refresh="yes"
													;;
												*)
													case ${UserArg} in
														rename)
															errorCode "rename" "wrong" ${chosen}
															;;
														cp|copy)
															errorCode "copy" "wrong" ${chosen}
															;;
														*)
															;;
													esac
													;;
											esac
											;;
										*)
											case ${UserArg} in
												rename)
													errorCode "rename" "wrong" ${chosen}
													;;
												cp|copy)
													errorCode "copy" "wrong" ${chosen}
													;;
												*)
													;;
											esac
											;;
									esac
								else
									case ${UserArg} in
										rename)
											errorCode "rename" "null"
											;;
										cp|copy)
											errorCode "backup" "null"
											;;
										*)
											;;
									esac
								fi
								;;
							*)
								if [ -z "${TheNewChosen}" ]; then
									case ${UserArg} in
										rename)
											Code=$(ManageLangs ${Lang} "rename" ${Code} ${chosen})
											;;
										cp|copy)
											Code=$(ManageLangs ${Lang} "copy" ${Code} ${chosen})
											;;
										*)
											;;
									esac
									refresh="yes"
								else
									case ${Code} in
										${chosen})
											case ${UserArg} in
												rename)
													Code=$(ManageLangs ${Lang} "rename" ${chosen} ${TheNewChosen})
													;;
												cp|copy)
													Code=$(ManageLangs ${Lang} "copy" ${chosen} ${TheNewChosen})
													;;
												*)
													;;
											esac
											refresh="yes"
											;;
										*${chosen}*)
											chosen=$(echo ${Code} | grep ${chosen})
											case ${UserArg} in
												rename)
													Code=$(ManageLangs ${Lang} "rename" ${chosen} ${TheNewChosen})
													;;
												cp|copy)
													Code=$(ManageLangs ${Lang} "copy" ${chosen} ${TheNewChosen})
													;;
												*)
													;;
											esac
											refresh="yes"
											;;
										*)
											case ${UserArg} in
												rename)
													errorCode "rename" "wrong" ${chosen}
													;;
												cp|copy)
													errorCode "copy" "wrong" ${chosen}
													;;
												*)
													;;
 											esac
											;;
									esac
								fi
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
								theHelp newCodeHelp ${Lang}
								;;
							--custom|-c)
								local BeforeFiles
								local AfterFiles
								local AllFiles
								local Type
								local NewCode
								BeforeFiles=$(ManageLangs ${Lang} "BeforeFiles")
								#Create new code
								ManageLangs ${Lang} "customCode" ${Lang} ${cLang}
								AfterFiles=$(ManageLangs ${Lang} "AfterFiles")
								AllFiles="${BeforeFiles} ${AfterFiles}"
								#Look ALL files for new for new file
								NewCode=$(echo -e "${AllFiles// /\\n}" | sort | uniq -u | tr -d '\n')
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
								local SrcName=${UserIn[1]}
								local SrcType=${UserIn[2]}
								local ActionType=${UserIn[2]}
								local ThePackageName=${UserIn[3]}
								local IsOk
								local HasPackage
								case ${Lang} in
									Java)
										#Make sure this is a project
										case ${CodeProject} in
											none)
												if [ ! -z "${ActionType}" ] && [ ! -z "${ThePackageName}" ]; then
													errorCode "project" "must-be-active"
												fi
												;;
											*)
												if [ ! -z "${ActionType}" ] && [ ! -z "${ThePackageName}" ]; then
													if [ ! -z "${UserIn[4]}" ]; then
														SrcType=${UserIn[2]}
														ActionType=${UserIn[3]}
														ThePackageName=${UserIn[4]}
													fi

													case ${ActionType} in
														--package)
															HasPackage=$(HandleJavaPackage ${Lang} "check" ${ThePackageName})
															case ${HasPackage} in
																${ThePackageName})
																	HandleJavaPackage ${Lang} "set" ${ThePackageName}
																	;;
																*)
																	HandleJavaPackage ${Lang} "new" ${ThePackageName}
																	HasPackage=${ThePackageName}
																	;;
															esac
																	;;
														*)
															;;
													esac
												fi
												;;
										esac
										;;
									*)
										;;
								esac

								#Ensure filename is given
								if [ ! -z "${SrcName}" ]; then
									case ${SrcName} in
										*","*|*";"*)
											errorCode "newCode" "one-at-a-time"
											IsOk="no"
											;;
										*)
											local TheFile="${UserIn[1]}"
											#Remove the extensions
											TheFile=$(ManageLangs ${Lang} "removeExt" ${TheFile})
											local TheExt=$(ManageLangs ${Lang} "getExt")
											local TheOtherExt=$(ManageLangs ${Lang} "getOtherExt")

											#Language has more than one extension
											if [ ! -z "${TheOtherExt}" ]; then
												#make sure file does not exist
												if [ ! -f ${TheFile}${TheExt} ] || [ ! -f ${TheFile}${TheOtherExt} ]; then
													IsOk="yes"
												else
													IsOk="no"
												fi
											#Language has one extension
											else
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
													ManageLangs ${Lang} "newCode" ${SrcName} ${SrcType} ${Code}
													if [ ! -z "${Code}" ]; then
														local OldCode=${Code}
														local NewCode=$(ManageLangs ${Lang} "getCode" ${SrcName} ${OldCode})
														if [ ! -z "${NewCode}" ]; then
															case ${OldCode} in
																*"${NewCode}"*)
																	errorCode "selectCode" "already"
																	;;
																*)
																	Code=$(ManageLangs ${Lang} "addCode" ${OldCode} ${NewCode})
																	;;
															esac
														fi
													else
														Code=$(ManageLangs ${Lang} "getCode" ${SrcName} ${OldCode})
													fi

													if [ ! -z "${ThePackageName}" ]; then
														case ${HasPackage} in
															${ThePackageName})
																cd - > /dev/null
																;;
															*)
																;;
														esac
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
											;;
									esac
								else
									theHelp newCodeHelp ${Lang}
								fi
								;;
						esac
						refresh="yes"
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
					#Read code without editing
					${ReadBy}|read)
						case ${UserIn[1]} in
							#edit non-langugage source files
							non-lang)
								if [ ! -z "${UserIn[2]}" ]; then
									${ReadBy} ${UserIn[2]}
								else
									errorCode "readCode"
								fi
								;;
							#edit language source code
							*)
								ManageLangs ${Lang} "readCode" ${Code} ${UserIn[1]}
								;;
						esac
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
									errorCode "notes" "none" "${Lang}"
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
											echo -e "${options//|/\\n}"
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
												case ${OldVal} in
													none)
														;;
													*)
														echo ""
														echo -n "Current: \""
														echo -ne "${OldVal//,/ }"
														echo "\""
														echo ""
														;;
												esac

												echo -e "${options//|/\\n}"
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
							make)
								case ${Lang} in
									#only C and C++ uses make
									C*)
										ManageLangs ${Lang} "create-make" "${Code}"
										;;
									*)
										errorCode "make" "not-for-lang" ${Lang}
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
									#Create your own "new" code template
									custom)
										if [ ! -f ${LangSrcDir}/${NewCode} ]; then
											ManageLangs ${Lang} "newCode" ${NewCode}
										fi
										#Select code
										Code=$(selectCode ${Lang} "set" ${NewCode})
										refresh="yes"
										;;
									#Use the template provided but cl[ide]
									default)
										#Create new souce code in newCode/
										if [ ! -f ${NewCodeDir}/${NewCode} ]; then
											if [ ! -f ${LangSrcDir}/${NewCode} ]; then
												ManageLangs ${Lang} "newCode" ${NewCode}
											fi
											#Move your custom code to cl[ide]'s template directory
											mv ${LangSrcDir}/${NewCode} ${NewCodeDir}/
										fi

										#Copy and set source code to src/
										cd ${LangSrcDir}/
										if [ ! -f ${LangSrcDir}/${NewCode} ]; then
											ln -s ${NewCodeDir}/${NewCode}
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
								case ${UserIn[2]} in
									cpl|cpl-args)
										RunCplArgs="none"
										echo "Compile args reset"
										;;
									args)
										RunTimeArgs=""
										echo "Run time args reset"
										;;
									all)
										#Default values
										RunTimeArgs=""
										RunCplArgs="none"
										echo "All rest"
										;;
									help|*)
										theHelp CreateHelp ${Lang}
										;;
								esac
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
					build)
						case ${CodeProject} in
							none)
								errorCode "project" "must-be-active"
								;;
							*)
								case ${Lang} in
									Java)
										ManageLangs ${Lang} "compileCode" "--jar" ${UserIn[1]} ${UserIn[2]}
										;;
									Rust)
										ManageLangs ${Lang} "compileCode" "--release" ${UserIn[1]} ${UserIn[2]}
										;;
									*)
										ManageLangs ${Lang} "compileCode" ${Code} ${UserIn[1]} ${UserIn[2]}
										;;
								esac
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
							#Check if debugger is set in clide.conf
							local HasDebugger=$(ManageLangs ${Lang} "getDebugger")
							if [ ! -z "${HasDebugger}" ]; then
								#Determin if debugger is installed
								IsInstalled=$(which ${HasDebugger})
								if [ ! -z "${IsInstalled}" ]; then
									#Determine of source code has debugging enabled
									DebugEnabled=$(ManageLangs ${Lang} "IsDebugEnabled" "${Code}")
									case ${DebugEnabled} in
										#Source code has debugging enabled
										yes)
											#Debug code by using Lang.<language>
											ManageLangs ${Lang} "debug" ${Code}
											;;
										#Source code NEEDS to enable debugging
										none|*)
											errorCode "debug" "need-enable" "${Lang}" "${HasDebugger}"
											;;
									esac
								#Debugger is not installed on computer
								else
									errorCode "debug" "not-installed"
								fi
							#No debugger was found in clide.conf
							else
								errorCode "debug" "not-set" "${Lang}"
							fi
						#No source code is selected
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
						CodeSupportVersion ${Lang}
						CodeTemplateVersion ${Lang}
						CodeVersion ${Lang}
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

				#Jump-in and Jump-out
				case ${InAndOut} in
					yes)
						break
						;;
					*)
						;;
				esac

				#Handle history and refreshing screen
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
											ProjectPrompt=$(ColorPrompt ${ProjectType:0:1}:${ProjectDir})
											#Menu with no code
											prompt="${Name}(${cCodeProject}[${ProjectPrompt}]):$ "
											;;
									esac
								else
									#Change Color for Code
									cCode=$(color ${Code})
									case ${Code} in
										*,*)
											cntSrc=$(echo -e "${Code//,/\\n}" | wc -l)
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
											ProjectPrompt=$(ColorPrompt ${ProjectType:0:1}:${ProjectDir})
											prompt="${Name}(${cCodeProject}[${ProjectPrompt}]{${listSrc}}):$ "
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
	local LangByExt
	local ChosenLangs
	if [ ! -z "${GetExt}" ]; then
		case ${GetExt} in
			*,*)
				local CodeDir
				local Lang
				local WantedCode=${GetExt}
				local newCode
				local look=1
				local NumOfSrc=$(echo -e "${GetExt//,/\\n}" | wc -l)
				while [ ${look} -le ${NumOfSrc} ];
				do
					#Get the next file
					newCode=$(echo ${WantedCode} | cut -d ',' -f ${look})
					#Get language by extension from source file
					Lang=$(SelectLangByCode ${newCode})
					if [ ! -z "${Lang}" ]; then
						echo ${Lang}
						break
					fi
					look=$((${look}+1))
				done
				;;
			*)
				for TheLang in ${LangsDir}/Lang.*;
				do
					#Select the next langauge
					TheLang=${TheLang##*/}
					text=${TheLang#Lang.*}
					text=$(ManageLangs ${text} "pgLang")
					case ${text} in
						no)
							;;
						*)
							LangByExt=$(ManageLangs ${text} "hasExt" "${GetExt}")
							if [ ! -z "${LangByExt}" ]; then
								pgLang ${text}
							fi
							;;
					esac
				done
				;;
		esac
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
	comp_list "set select"
	comp_list "unset"
	comp_list "rm remove delete rmbin rmsrc" "-f"
	comp_list "cd"
	comp_list "pwd"
	comp_list "mkdir"
	comp_list "mode" "add pkg ${repoTool} repo"
	comp_list "use" "${pg}"
	comp_list "project" "build delete discover export files import load list link mode new remove swap set select use save title type update"
	comp_list "package" "new set list"
	comp_list "shell"
	comp_list "new" "--version -v --help -h --custom -c"
	comp_list "${editor} ed edit" "non-lang"
	comp_list "add"
	comp_list "${ReadBy} read" "non-lang"
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
			errorCode "HINT"
			errorCode "HINT" "enter \"no-lang\" or \"nl\" to enter into a ${Head} shell"
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
			#Get Config
			-c|--config)
				grep -v "#" ${root}/var/clide.conf | sed "s/export //g" | sed "s/=/: /g" | tr -d "\""
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
			-ll|--languages|--langs)
				local pg=$(ColorCodes)
				echo "Supported Languages: ${pg}"
				;;
			#List projects from cli
			-p|--project)
				shift
				local ActionProject=$1
				local GetProject=$1
				local Code=$2
				if [ ! -z "${ActionProject}" ]; then
					case ${ActionProject} in
						--new)
							shift
							local TheLang=$1
							local TheProjectName=$2
							shift
							shift
							TheLang=$(pgLang ${TheLang})
							local Args=$@
							if [ ! -z "${TheProjectName}" ]; then
								case ${TheLang} in
									no)
										;;
									*)
										InAndOut="yes"
										Actions ${TheLang} "code" "project" "new" ${TheProjectName} ${Args[@]}
										;;
								esac
							fi
							;;
						--discover)
							discoverProject
							;;
						#Link a project with another language
						--link)
							shift
							local Lang
							local TheLinkAction=$1
							local TheLang=$1
							TheLang=$(pgLang ${TheLang})
							local TheProjectName=$2
							local TheProject
							local ProjectFile
							local Already

							if [ ! -z "${TheProjectName}" ]; then
								TheProject=$(loadProject ${TheProjectName})
								if [ "${TheProject}" != "no" ]; then
									local GetLang=$(echo ${TheProject} | cut -d ";" -f 1)
									Lang=$(pgLang ${GetLang})
									case ${Lang} in
										no)
											errorCode "ERROR"
											errorCode "ERROR" "{Default Language} \"${GetLang}\" is not supported"
											;;
										*)
											ProjectFile=${ActiveProjectDir}/${TheProjectName}.clide
											Already=$(grep "link=" ${ProjectFile})
											case ${TheLinkAction} in
												--list)
													echo ${Already} | sed "s/link=//g" | tr ',' '\n' | sort
													;;
												*)
													case ${TheLang} in
														no)
															;;
														*)
															local IsLinked=$(linkProjects ${Lang} ${TheLang} ${TheProjectName})
															if [ ! -z "${IsLinked}" ]; then
																local cTheLang=$(color "${TheLang}")
																local cLinkLang=$(color "${Lang}")
																local cName=$(color "${TheProjectName}")
																echo "[${cLinkLang} Project: ${cName}]"
																echo -e "\tLinking ${cLinkLang} ---> ${cTheLang}"
															else
																errorCode "project" "link" "unable-link" ${TheLang}
															fi
															;;
													esac
													;;
											esac
											;;
									esac
								else
									errorCode "project" "load" "no-path" "${TheProjectName}"
								fi
							else
								theHelp ProjectCliHelp ${UserArg}
							fi
							;;
						--run|--build)
							shift
							local Lang=$1
							Lang=$(pgLang ${Lang})

							case ${Lang} in
								no)
									Lang=""
									GetProject=$1
									Code=$2
									;;
								*)
									GetProject=$2
									Code=$3
									;;
							esac

							if [ -z "${GetProject}" ]; then
								theHelp BuildHelp ${UserArg}
							else
								case ${GetProject} in
									#Provide the help page
									-h|--help)
										theHelp BuildHelp ${UserArg}
										;;
									*)
										local TheProject=$(loadProject ${GetProject})
										if [ "${TheProject}" != "no" ]; then

											if [ -z "${Lang}" ]; then
												Lang=$(echo ${TheProject} | cut -d ";" -f 1)
												Lang=$(pgLang ${Lang})
											fi

											#If no source code is found, look in project file
											if [ -z "${Code}" ]; then
												Code=$(echo ${TheProject} | cut -d ";" -f 2)
											fi

											local CodeDir=$(echo ${TheProject} | cut -d ";" -f 3)
											if [ ! -z "${CodeDir}" ]; then
												CodeProject="${GetProject}"
												if [ -d ${CodeDir} ]; then
													cd ${CodeDir}
													case ${ActionProject} in
														--run)
															shift
															local ArgFlag=$1
															if [ ! -z "${ArgFlag}" ]; then
																runCode ${Lang} "none" "none" "none" $@
															else
																runCode ${Lang} "none"
															fi
															;;
														--build)
															#Determine action based on language
															case ${Lang} in
																Java)
																	if [ -z "${Code}" ]; then
																		ManageLangs ${Lang} "compileCode" ${Code}
																	else
																		ManageLangs ${Lang} "compileCode" "--jar"
																	fi
																	;;
																C|C++)
																	#Get Make file
																	local TheMakeFile=$(ManageLangs ${Lang} "getMakeFile" ${GetProject})
																	#Compile with makefile
																	if [ ! -z "${TheMakeFile}" ]; then
																		ManageLangs ${Lang} "compileCode"
																	#Compile with selected code
																	elif [ ! -z "${Code}" ]; then
																		ManageLangs ${Lang} "compileCode" ${Code}
																	else
																		errorCode "cli-cpl" "none"
																	fi
																	;;
																Rust)
																	if [ -z "${Code}" ]; then
																		ManageLangs ${Lang} "compileCode" ${Code}
																	else
																		ManageLangs ${Lang} "compileCode" "--release"
																	fi
																	;;
																*)
																	if [ ! -z "${Code}" ]; then
																		ManageLangs ${Lang} "compileCode" ${Code}
																	else
																		errorCode "cli-cpl" "none"
																	fi
																	;;
															esac
															;;
														*)
															;;
													esac
												else
													errorCode "project" "not-valid" "${GetProject}"
												fi
											else
												errorCode "cli-cpl" "none"
											fi
										else
											errorCode "project" "not-valid" "${GetProject}"
										fi
										;;
								esac
							fi
							;;
						--export)
							shift
							local TheProjectName=$1
							if [ ! -z "${TheProjectName}" ]; then
								exportProject ${TheProjectName}
							fi
							;;
						--import)
							shift
							local TheLang=$1
							local TheProjectName=$2
							if [ ! -z "${TheLang}" ] && [ ! -z "${TheProjectName}" ]; then
									importProject ${TheLang} ${TheProjectName}
							elif [ ! -z "${TheLang}" ] && [ -z "${TheProjectName}" ]; then
									importProject "none" ${TheLang}
							fi
							;;
						--remove|--delete)
							shift
							local TheProjectName=$1
							if [ ! -z "${TheProjectName}" ]; then
								case ${TheProjectName} in
									all)
										case ${GetProject} in
											#remove project ONLY from record
											--remove)
												rm ${ActiveProjectDir}/*.clide 2> /dev/null
												echo "ALL projects removed from record"
												;;
											#remove project files AND record
											--delete)
												rm ${ActiveProjectDir}/*.clide 2> /dev/null
												#Handle the langauge specific directories
												#{
												#Get the list of Lang.<language> files from cl[ide]
												local text
												local ProjectPath
												for TheLang in ${LangsDir}/Lang.*; do
													#Select the next langauge
													TheLang=${TheLang##*/}
													text=${TheLang#Lang.*}
													#Make sure language is supported on computer
													text=$(ManageLangs ${text} "pgLang")
													case ${text} in
														no)
															;;
														*)
															ProjectPath=$(ManageLangs ${text} "getProjectDir")
															if [ ! -z "${ProjectPath}" ] && [ -d "${ProjectPath}" ]; then
																rm -rf ${ProjectPath}/* 2> /dev/null
															fi
															;;
													esac
												done
												#}
												echo "Deleted ALL projects"
												;;
											*)
												;;
										esac
										;;
									*)
										if [ -f "${ActiveProjectDir}/${TheProjectName}.clide" ]; then
											case ${GetProject} in
												#remove project ONLY from record
												--remove)
													rm ${ActiveProjectDir}/${TheProjectName}.clide 2> /dev/null
													echo "The project \"${TheProjectName}\" removed from record"
													;;
												#remove project files AND record
												--delete)
													local TheProject=$(loadProject ${TheProjectName})
													if [ "${TheProject}" != "no" ]; then
														Lang=$(echo ${TheProject} | cut -d ";" -f 1)
														Lang=$(pgLang ${Lang})
														local CodeDir=$(echo ${TheProject} | cut -d ";" -f 3)
														if [ ! -z "${CodeDir}" ]; then
															rm -rf ${CodeDir} 2> /dev/null
														fi
														rm ${ActiveProjectDir}/${TheProjectName}.clide 2> /dev/null
														echo "Deleted the \"${TheProjectName}\" project"
													fi
													;;
												*)
													;;
											esac
										else
											theHelp ProjectCliHelp ${UserArg}
										fi
										;;
								esac
							else
								theHelp ProjectCliHelp ${UserArg}
							fi
							;;
						--list)
							shift
							local Lang
							local CodeDir
							local TheProject
							local RemoveDirs
							GetProject=$1
							#Just list the projects
							if [ -z "${GetProject}" ]; then
								listProjects
							#list the entire project
							else
								TheProject=$(loadProject ${GetProject})
								if [ "${TheProject}" != "no" ]; then
									Lang=$(echo ${TheProject} | cut -d ";" -f 1)
									Lang=$(pgLang ${Lang})
									CodeDir=$(echo ${TheProject} | cut -d ";" -f 3)
									if [ ! -z "${CodeDir}" ]; then
										RemoveDirs=${CodeDir//\//|}
										find ${CodeDir} -print | tr '/' '|' | sed "s/${RemoveDirs}//g" | tr '|' '/'
									else
										errorCode "cli-cpl" "none"
									fi
								else
									errorCode "project" "not-valid" "${GetProject}"
								fi
							fi
							;;
						--langs)
							shift
							local LangSupported
							local CodeDir
							local TheProject
							GetProject=$1
							#Just list the projects
							if [ -z "${GetProject}" ]; then
								listProjects
							else
								TheProject=$(loadProject ${GetProject})
								if [ "${TheProject}" != "no" ]; then
									Lang=$(echo ${TheProject} | cut -d ";" -f 1)
									Lang=$(pgLang ${Lang})
									local CodeDir=$(echo ${TheProject} | cut -d ";" -f 3)
									if [ ! -z "${CodeDir}" ]; then
										LangSupported=$(echo ${TheProject} | cut -d ";" -f 5)
										if [ ! -z "${LangSupported}" ]; then
											echo ${LangSupported} | tr ',' '\n'
										else
											echo ${Lang}
										fi
									else
										errorCode "cli-cpl" "none"
									fi
								else
									errorCode "project" "not-valid" "${GetProject}"
								fi
							fi
							;;
						-h|--help)
							theHelp ProjectCliHelp ${UserArg}
							;;
						*)
							shift
							local TheProjectDir
							local ChosenLang=$1
							local SaveProject=$1
							local ModeAction
							local ModeType
							local IsLang=$(pgLang ${GetProject})

							if [ ! -z "${ChosenLang}" ]; then
								case ${IsLang} in
									no)
										ChosenLang=""
										TheProject=$(loadProject ${GetProject})
										SaveProject=${GetProject}
										ModeAction=$1
										ModeType=$2
										;;
									*)
										TheProject=$(loadProject ${ChosenLang})
										ChosenLang=${GetProject}
										project=$(loadProject ${UserIn[3]})
										GetProject=${SaveProject}
										ModeAction=$2
										ModeType=$3
										;;
								esac
							else
								TheProject=$(loadProject ${GetProject})
							fi

							local HasLink
							if [ "${TheProject}" != "no" ]; then
								if [ -z "${ChosenLang}" ]; then
									Lang=$(echo ${TheProject} | cut -d ";" -f 1)
								else
									HasLink=$(echo ${TheProject} | cut -d ";" -f 5)
									if [ ! -z "${HasLink}" ]; then
										case ${HasLink,,} in
											*"${ChosenLang,,},"*)
												Lang=${ChosenLang}
												;;
											*)
												Lang=$(echo ${TheProject} | cut -d ";" -f 1)
												;;
										esac
									else
										Lang=$(echo ${TheProject} | cut -d ";" -f 1)
									fi
								fi
								Lang=$(pgLang ${Lang})
								TheProjectDir=$(echo ${TheProject} | cut -d ";" -f 3)
								if [ -d ${TheProjectDir} ]; then
									CodeProject=${SaveProject}
									if [ ! -z "${ModeAction}" ]; then
										case ${ModeAction} in
											--mode)
												shift
												local cCode
												local cLang=$(color "${Lang}")

												if [ ! -z "${ModeType}" ]; then
													shift
													Code=$(echo ${TheProject} | cut -d ";" -f 2)
													local passCode=${Code}
													local passcCode=$(color "${Code}")
													if [ -z "${passCode}" ]; then
														passCode="none"
													fi
													if [ -z "${passcCode}" ]; then
														passcCode="none"
													fi
													#Swap cl[ide] to a given mode
													ModeHandler ${ModeType} ${Lang} ${cLang} ${passCode} ${passcCode} $@
												fi
												;;
											*)
												theHelp ProjectCliHelp ${UserArg}
												;;
										esac
									else
										Actions ${Lang} "code" "project" "load" "${GetProject}" "${Lang}"
									fi
								else
									errorCode "project" "load" "no-path" "${GetProject}"
								fi
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
				local FindCode
				local AlreadyCode
				local ColorCode
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
							errorCode "install" "cli-not-supported" "$1"
							;;
						*)
							local CodeDir=$(pgDir ${Lang})
							if [ ! -z "${CodeDir}" ]; then
								ColorCode=$(ManageLangs ${Lang} "color-number")
								cd ${CodeDir}
								InAndOut="yes"
								IFS=',' read -ra ADDR <<< "${Code}"
								for NewCode in "${ADDR[@]}";
								do
									AlreadyCode=$(ManageLangs ${Lang} "getCode" ${NewCode})
									if [ -z "${AlreadyCode}" ]; then
										Actions ${Lang} "code" "new" ${NewCode} ${Args[@]}
										FindCode=$(ManageLangs ${Lang} "getCode" ${NewCode})
										if [ ! -z "${FindCode}" ]; then
											echo -e "\e[1;4${ColorCode}m[${Lang} (${FindCode}) Created]\e[0m"

										fi
									fi
								done
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
						errorCode "WARNING"
						errorCode "WARNING" "Editing this file incorrectly could render ${Head} unusable"
						echo ""
						errorCode "WARNING" "Do you wish to continue (y/n)"
						echo -n "> "
						read YourAnswer
						YourAnswer=${YourAnswer,,}
						case ${YourAnswer} in
							y)
								${editor} ${root}/var/clide.conf
								clear
								errorCode "WARNING" "Please restart ${Head} for changes to take affect"
								errorCode "WARNING" "May God have mercy on your ${Head}"
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
												errorCode "lang" "cli-not-supported" "$1"
												;;
											*)
												local CodeDir=$(pgDir ${Lang})
												if [ ! -z "${CodeDir}" ]; then
													cd ${CodeDir}
													Code=$(selectCode ${Lang} ${Code})
													ManageLangs ${Lang} "editCode" ${Code}
												else
													errorCode "cli-cpl" "none"
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
							errorCode "lang" "cli-not-supported" "$1"
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
								cd - > /dev/null
							else
								errorCode "cli-cpl" "none"
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
				local Code=$2
				local CodeDir
				#Provide the help page
				if [ -z "${Lang}" ]; then
					theHelp RunHelp
				else
					case ${Lang} in
						#Provide the help page
						-h|--help)
							theHelp RunHelp
							;;
						*)
							Lang=$(pgLang ${Lang})
							case ${Lang} in
								no)
									Lang=$(SelectLangByCode $1)
									Code=$1
									shift
									if [ -z "${Lang}" ]; then
										errorCode "runCode" "no-lang"
										Code=""
									else
										CodeDir=$(pgDir ${Lang})
									fi
									;;
								*)
									;;
							esac

							if [ -z "${Code}" ]; then
								errorCode "selectCode" "not-found"
							else
								local TheBin=$(ManageLangs ${Lang} "getBin" "${Code}")
								if [ ! -z "${TheBin}" ]; then
									local Args=$@
									#run the code..."none" "none" is to provide the needed padding to run
									runCode ${Lang} ${Code} "none" "none" ${Args[@]}
								else
									errorCode "cpl" "cli-need" "${Lang}"
								fi
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
							errorCode "lang" "no-lang" "$1"
							;;
						*)
							local CodeDir=$(pgDir ${Lang})
							if [ ! -z "${CodeDir}" ]; then
								cd ${CodeDir}
								Code=$(selectCode ${Lang} ${Code})
								if [ ! -z "${Code}" ]; then
									cat ${Code}
								else
									errorCode "lang" "readCode"
								fi
							else
								errorCode "lang" "readCode"
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
						errorCode "lang" "cli-not-supported" "$1"
						;;
					*)
						local CodeDir=$(pgDir ${Lang})
						if [ ! -z "${CodeDir}" ]; then
							ls ${CodeDir}
						fi
						;;
				esac
				;;
			--list-cpl|--lscpl)
				shift
				local Lang=$(pgLang $1)
				case ${Lang} in
					no)
						errorCode "lang" "cli-not-supported" "$1"
						;;
					*)
						ManageLangs ${Lang} "lscpl"
						;;
				esac
				;;
			#Get by file extension
			*.*)
				local CodeDir
				local Code=$1
				#Get language by extension from source file
				local Lang=$(SelectLangByCode ${Code})
				CodeDir=$(pgDir ${Lang})
				case ${CodeDir} in
					no)
						errorCode "not-a-lang" "${Lang}"
						;;
					*)
						if [ ! -z "${CodeDir}" ]; then
							cd ${CodeDir}
							Code=$(preSelectSrc ${Lang} ${Code})
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
						local Args
						Lang=$(pgLang ${Lang})
						shift
						local HiddenAction=$1
						local NextHiddenAction=$2
						case ${HiddenAction} in
							--new)
								shift
								Args=$@
								main ${HiddenAction} ${Lang} ${Args[@]}
								InAndOut="no"
								Actions ${Lang} ${Args[@]}
								;;
							# $ clide <lang> --project <action> <ProjectName>
							-p|--project)
								case ${NextHiddenAction} in
									# $ clide <lang> --project --new <ProjectName>
									#Or
									# $ clide <lang> --project --new <ProjectName>
									--new|--import)
										shift
										shift
										Args=$@
										main ${HiddenAction} ${NextHiddenAction} ${Lang} ${Args[@]}
										InAndOut="no"
										main ${HiddenAction} ${Lang} ${Args[@]}
										;;
									# $ clide <lang> --project <ProjectName>
									*)
										shift
										Args=$@
										main ${HiddenAction} ${Lang} ${Args[@]}
										;;
								esac
								#main ${HiddenAction} ${Lang} ${Args[@]}
								;;
							#Normal usage
							*)
								Args=$@
								#Start IDE
								Actions ${Lang} ${Args[@]}
								;;
						esac
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
