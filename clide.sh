#!/usr/bin/env bash

#Handle Pipes
#{
ThePipe=""
if readlink /proc/$$/fd/0 | grep -q "^pipe:"; then
	ThePipe="Pipe"
fi
#}

ThisFile=$0
#Get path of the script
ShellPath=$(realpath ${ThisFile})
#Get the dir name
root=$(dirname ${ShellPath})
#load the config files
source ${root}/etc/clide.conf
source ${root}/etc/version

export TypeOfCpl
export RunType
export RunCplArgs
export TheSrcCode
export TimeRun

#InAndOut determines if internal functions can run via cli
InAndOut="no"
MessageOverride="no"
SessionName="clide"

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
	if [ -d ${LibDir} ] && [ -f ${LibDir}/help.sh ]; then
		${LibDir}/help.sh ${Head} ${LangsDir} "${@}"
	fi
}

HelpMenu()
{
	local Lang=$1
	shift
	local HelpArgs=( "${@}" )
	case ${HelpArgs[0]} in
		help)
			HelpArgs[0]=""
			;;
		*)
			case ${HelpArgs[1]} in
				--help)
					HelpArgs[1]=""
					;;
				*)
					;;
			esac
			;;
	esac
	theHelp MenuHelp ${Lang} "${HelpArgs[@]}"
}

#call errorcode shell script
errorCode()
{
	if [ -d ${LibDir} ] && [ -f ${LibDir}/errorCode.sh ]; then
		${LibDir}/errorCode.sh "${@}"
	fi
}

#Handle Aliases
AddAlias()
{
	if [ -d ${LibDir} ] && [ -f ${LibDir}/AddAlias.sh ]; then
		${LibDir}/AddAlias.sh "${@}"
	fi
}

Protect()
{
	local Done=$1
	if [ -z "${Done}" ] && [ -w "${ThisFile}" ]; then
		chmod -w ${ThisFile} 2> /dev/null
	else
		chmod u+w ${ThisFile} 2> /dev/null
	fi
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
	local Args=( "${@}" )
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
	local TheAction=$2
	local Langs=${LangsDir}/Lang.${TheLang^}
	#Make first letter uppercase
	shift
	local Manage=( "${@}" )
	if [ ! -z "${TheAction}" ]; then
		if [ -d ${LangsDir} ] && [ -f ${Langs} ]; then
			chmod -w ${Langs} 2> /dev/null
			case ${TheAction} in
				runCode)
					if [ ! -z "${ThePipe}" ]; then
						cat /dev/stdin | ${Langs} "${Manage[@]}"
					else
						${Langs} "${Manage[@]}"
					fi
					;;
				*)
					${Langs} "${Manage[@]}"
					;;
			esac
			chmod u+w ${Langs} 2> /dev/null
		else
			UseOther ${TheLang} "${Manage[@]}"
		fi
	fi
}

#refference the modes allowed by cl[ide]
ModeHandler()
{
	local Mode=$1
	local Lang=$2
	local cLang=$3
	local cCode
	shift
	shift
	shift
	local Arg=( "${@}" )
	if [ -d ${ModesDir} ]; then
		case ${Mode} in
			${repoTool}|repo)
				case ${Mode} in
					repo)
						#Use ONLY for Projects
						case ${CodeProject} in
							none)
								errorCode "project" "must-be-active"
								;;
							*)
								if [ -f ${ModesDir}/repo.sh ]; then
									chmod -w ${ModesDir}/repo.sh 2> /dev/null
									${ModesDir}/repo.sh
									chmod u+w ${ModesDir}/repo.sh 2> /dev/null
								fi
								;;
						esac
						;;
					${repoTool})
						ModeHandler repo
						;;
					*)
						;;
				esac
				;;
			pkg)
				if [ -f ${ModesDir}/pkg.sh ]; then
					chmod -w ${ModesDir}/pkg.sh 2> /dev/null
					${ModesDir}/pkg.sh
					chmod u+w ${ModesDir}/pkg.sh 2> /dev/null
				fi
				;;
			add)
				if [ -f ${ModesDir}/add.sh ]; then
					#cCode=${TheSrcCode}
					#if [ -z "${TheSrcCode}" ]; then
					#	cCode="none"
					#fi
					chmod -w ${ModesDir}/add.sh 2> /dev/null
					#${ModesDir}/add.sh ${Head} "${LibDir}" "${LangsDir}" "${ClideProjectDir}" ${Lang} ${cLang} ${cCode} ${Arg[@]}
					${ModesDir}/add.sh ${Head} "${LibDir}" "${LangsDir}" "${ClideProjectDir}" ${Lang} ${cLang} "${Arg[@]}"
					chmod u+w ${ModesDir}/add.sh 2> /dev/null
				fi
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
	fi
}

#Make sure the propper directories are in place in order for cl[ide] to run
EnsureDirs()
{
	#If missing...create "Programs" dir
#	if [ ! -d "${ProgDir}" ]; then
#		mkdir -p "${ProgDir}"
#	fi

#	if [ ! -d "${ClideDir}" ]; then
#		mkdir -p "${ClideDir}"
#	fi

#	if [ ! -d "${NotesDir}" ]; then
#		mkdir -p "${NotesDir}"
#	fi

#	if [ ! -d "${LibDir}" ]; then
#		mkdir -p "${LibDir}"
#	fi

#	if [ ! -d "${ClideProjectDir}" ]; then
#		mkdir -p "${ClideProjectDir}"
#	fi

#	if [ ! -d "${TemplateProjectDir}" ]; then
#		mkdir -p "${TemplateProjectDir}"
#	fi

#	if [ ! -d "${ClideUserDir}" ]; then
#		mkdir -p "${ClideUserDir}"
#	fi

#	if [ ! -d "${ClideUserProjectDir}" ]; then
#		mkdir -p "${ClideUserProjectDir}"
#	fi

	if [ ! -d "${ExportProjectDir}" ]; then
		mkdir -p "${ExportProjectDir}"
	fi

	if [ ! -d "${ActiveProjectDir}" ]; then
		mkdir -p "${ActiveProjectDir}"
	fi

	if [ ! -d "${ImportProjectDir}" ]; then
		mkdir -p "${ImportProjectDir}"
	fi

#	if [ ! -d "${LangsDir}" ]; then
#		mkdir -p "${LangDir}"
#	fi

	#Handle the langauge specific directories
	#{
	#Get the list of Lang.<language> files from cl[ide]
	local text
	for TheLang in ${LangsDir}/Lang.*; do
		#Select the next langauge
		if [ -f ${TheLang} ]; then
			TheLang=${TheLang##*/}
			text=${TheLang#Lang.*}
			#Make sure language is supported on computer
			text=$(ManageLangs ${text} "pgLang")
			if [ ! -z "${text}" ]; then
				case ${text} in
					no)
						;;
					*)
						#Call the Lang.<language> to ensure directories
						ManageLangs "${text}" "EnsureDirs"
						;;
				esac
			fi
		fi
	done
	#}
}

#provide the langauge number of cl[ide]
ClideVersion()
{
	echo ${clideVersion}
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
		if [ -d ${LangsDir} ]; then
			local text
			local SupportNum
			for TheLang in ${LangsDir}/Lang.*;
			do
				if [ -f ${TheLang} ]; then
					#Select the next langauge
					TheLang=${TheLang##*/}
					text=${TheLang#Lang.*}
					text=$(ManageLangs ${text} "pgLang")
					if [ ! -z "${text}" ]; then
						case ${text} in
							no)
								;;
							*)
								LangColor=$(ManageLangs ${text} "color-number")
								SupportNum=$(ManageLangs "${text}" "SupportVersion")
								if [ ! -z "${SupportNum}" ]; then
									echo -e "\e[1;3${LangColor}m${text}: ${SupportNum}\e[0m"
								fi
								;;
						esac
					fi
				fi
			done
		fi
	fi
}

ShellCodeVersion()
{
	local TheLang=$1
	local Langs=""
	if [ ! -z "${TheLang}" ]; then
		ManageLangs ${TheLang} "ShellVersion"
	else
		local text
		if [ -d ${LangsDir} ]; then
			for TheLang in ${LangsDir}/Lang.*;
			do
				#Select the next langauge
				if [ -f ${TheLang} ]; then
					TheLang=${TheLang##*/}
					text=${TheLang#Lang.*}
					#Ensure langauge is supported on computer
					text=$(ManageLangs ${text} "pgLang")
					if [ ! -z "${text}" ]; then
						case ${text} in
							no)
								;;
							*)
								#Pull the compiler/interpreter version using Lang.<language>
								ManageLangs "${text}" "ShellVersion"
								;;
						esac
					fi
				fi
			done
		fi
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
		TempNum=$(ManageLangs ${TheLang} "TemplateVersion" | sed "s/Version//g" | grep -v found)
		if [ ! -z "${TempNum}" ]; then
			echo -e "\e[1;4${LangColor}m[\"New Code\" Template]\e[0m"
			echo "${TempNum}"
			echo ""
		fi
	else
		local CharCount
		local text
		if [ -d ${LangsDir} ]; then
			for TheLang in ${LangsDir}/Lang.*;
			do
				#Select the next langauge
				if [ -f ${TheLang} ]; then
					TheLang=${TheLang##*/}
					text=${TheLang#Lang.*}
					text=$(ManageLangs ${text} "pgLang")
					if [ ! -z "${text}" ]; then
						case ${text} in
							no)
								#do nothing
								;;
							*)
								LangColor=$(ManageLangs ${text} "color-number")
								TempNum=$(ManageLangs "${text}" "TemplateVersion" | sed "s/Version/${text}/g" | grep -v found)
								if [ ! -z "${TempNum}" ]; then
									#Tab based on size of chars in lable
									CharCount=$(echo ${#text})
									if [ ${CharCount} -lt 7 ]; then
										echo -e "\e[1;3${LangColor}m${text}\e[0m\t\t\e[1;3${LangColor}m${TempNum}\e[0m"
										#echo -e "\e[1;4${LangColor}m(\e[0m\e[1;3${LangColor}m${text}\e[0m\e[1;4${LangColor}m)\e[0m\t\t{\e[1;3${LangColor}m${TempNum}\e[0m}"
									else
										echo -e "\e[1;3${LangColor}m${text}\e[0m\t\e[1;3${LangColor}m${TempNum}\e[0m"
										#echo -e "\e[1;4${LangColor}m(\e[0m\e[1;3${LangColor}m${text}\e[0m\e[1;4${LangColor}m)\e[0m\t{\e[1;3${LangColor}m${TempNum}\e[0m}"
									fi
								fi
								;;
						esac
					fi
				fi
			done
		fi
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
		if [ -d ${LangsDir} ]; then
			for TheLang in ${LangsDir}/Lang.*;
			do
				#Select the next langauge
				if [ -f ${TheLang} ]; then
					TheLang=${TheLang##*/}
					text=${TheLang#Lang.*}
					#Ensure langauge is supported on computer
					text=$(ManageLangs ${text} "pgLang")
					if [ ! -z "${text}" ]; then
						case ${text} in
							no)
								;;
							*)
								#Pull the compiler/interpreter version using Lang.<language>
								ManageLangs "${text}" "CplVersion" | sed "s/Version:/${text}:/g"
								;;
						esac
					fi
				fi
			done
		fi
	fi
}

CompileAllCode()
{
	local text
	local TheLang
	local Type=$1
	if [ -d ${LangsDir} ]; then
		for TheLang in ${LangsDir}/Lang.*;
		do
			if [ -f ${TheLang} ]; then
				#Select the next langauge
				TheLang=${TheLang##*/}
				text=${TheLang#Lang.*}
				#Ensure langauge is supported on computer
				text=$(ManageLangs ${text} "pgLang")
				if [ ! -z "${text}" ]; then
					case ${text} in
						no)
							;;
						*)
							if [ ! -z "${Type}" ]; then
								case ${Type,,} in
									shell)
										CLI --cpl-sh ${text} | egrep -v "ERROR|HINT"
										;;
									template)
										CLI --cpl-ct ${text} | egrep -v "ERROR|HINT"
										;;
									*)
										;;
								esac
							fi
							;;
					esac
				fi
			fi
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
		if [ -d ${LangsDir} ]; then
			for TheLang in ${LangsDir}/Lang.*;
			do
				if [ -f ${TheLang} ]; then
					#Select the next langauge
					TheLang=${TheLang##*/}
					text=${TheLang#Lang.*}
					#Ensure langauge is supported on computer
					text=$(ManageLangs ${text} "pgLang")
					if [ ! -z "${text}" ]; then
						case ${text} in
							no)
								;;
							*)
								LangColor=$(ManageLangs ${text} "color-number")
								#Pull degger version from Lang.<language>
								DebugV=$(ManageLangs "${text}" "getDebugVersion")
								if [ ! -z "${DebugV}" ]; then
									echo -e "\e[1;4${LangColor}m[${text} Debugger]\e[0m"
									echo "${DebugV}"
									echo ""
								fi
								;;
						esac
					fi
				fi
			done
		fi
	fi
}

Banner()
{
	local Type=$1
	if [ ! -z "${Type}" ]; then
		case ${Type} in
			main)
				Art
				;;
			*)
				ManageLangs ${Type} "Art"
				;;
		esac
	fi
	if [ ! -z "${VerColor}" ]; then
		echo -e "(\e[1;4${VerColor}m${clideVersion}\e[0m)"
	else
		echo "(${clideVersion})"
	fi
	echo ""
	echo "\"Welcome to ${Head}\""
	echo "\"The command line IDE for the Linux/Unix user\""
}

#Search selected code for element
lookFor()
{
	local Count
	local project=${CodeProject}
	local TypeOfSearch=$1
	local search=$2

	if [ ! -z "${TypeOfSearch}" ] && [ -z "${search}" ]; then
		case ${TypeOfSearch} in
			-*)
				;;
			*)
				search=${TypeOfSearch}
				TypeOfSearch=""
				;;
		esac
	fi

	#Determin if it is a project
	case ${project} in
		#IS NOT a project
		none)
			#Provide message
			errorCode "project" "none" "${Head}"
			;;
		*)
			case ${TypeOfSearch} in
				-*help)
					theHelp LookForHelp
					;;
				*)
					if [ ! -z "${search}" ]; then
						case ${TypeOfSearch} in
							--file-only|--files)
								Count=$(grep -liR ${search} * | wc -l)
								if [ ${Count} -gt 20 ]; then
									grep -liR ${search} * | less
								else
									grep -liR ${search} *
								fi
								;;
							--count|--occur)
								grep -iR ${search} * | wc -l
								;;
							*)
								Count=$(grep -iR ${search} * | wc -l)
								if [ ${Count} -gt 20 ]; then
									grep -iR ${search} * | less
								else
									grep -iR ${search} *
								fi
								;;
						esac
					else
						errorCode "lookFor" "none"
					fi
					;;
			esac
			;;
	esac
}

GetProjectType()
{
	local GetType
	local Lang=$1
	GetType=$(ManageLangs "${Lang}" "GetProjectType")
	if [ ! -z "${GetType}" ]; then
		ProjectType=${GetType}
	fi
}

#Save Last Session
SaveSession()
{
	local Language=$1
	local TheFileName=$2
	local Session

	if [ -z "${TheFileName}" ]; then
		Session="${ClideUserDir}/${SessionName}.session"
	else
		Session="${ClideUserDir}/${TheFileName}.session"
		SessionName="${TheFileName}"
	fi

	#Source Needs to be present
	if [ ! -z "${TheSrcCode}" ]; then
		if [ -d ${ClideUserDir} ] && [ -d ${ClideDir} ] && [ ! -z "${Language}" ]; then
			touch ${Session}
			echo "${CodeProject};${Language};${TheSrcCode}" > ${Session}
			if [ -z "${TheFileName}" ]; then
				echo "Session saved"
			else
				echo "\"${TheFileName}\" Session saved"
			fi
		fi
	fi
}

#Load Last Session
LoadSession()
{
	local TheFileName=$1
	local Session
	if [ -d ${ClideUserDir} ] && [ -d ${ClideDir} ]; then
		if [ -z "${TheFileName}" ]; then
			Session="${ClideUserDir}/${SessionName}.session"

		else
			Session="${ClideUserDir}/${TheFileName}.session"
			SessionName="${TheFileName}"
		fi

		#check for clide session
		if [ ! -f "${Session}" ]; then
			errorCode "loadSession"
		else
			cat ${Session}
		fi
	fi
}

#Load Last Session
ListSession()
{
	local Session
	if [ -d ${ClideUserDir} ] && [ -d ${ClideDir} ]; then
		cd ${ClideUserDir}
		ls *.session 2> /dev/null | grep -v "clide.session" | sed "s/.session//g"
		cd - > /dev/null
	fi
}

recoverProject()
{
	local Lang=$1
	local Name=$2
	local Path=$3
	local projectType=$4
	local ProjectFile
	#If project type is not provided, assume is generic
	if [ -z "${projectType}" ]; then
		projectType="${ProjectDefaultType}"
	fi

	if [ -d ${ActiveProjectDir} ]; then
		if [ ! -z "${Name}" ]; then
			ProjectFile=${ActiveProjectDir}/${Name}.clide
			if [ ! -f ${ProjectFile} ]; then
				if [ -z "${Path}" ]; then
					errorCode "project" "recover" "no-path"
				else
					case ${Path} in
						#Path does not exist and save details
						*${Name}|*${Name}/)
							local cName=$(ManageLangs ${Lang} "ProjectColor" "${Name}")
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
			if [ ! -z "${project}" ]; then
				if [ -f ${ActiveProjectDir}/${project}.clide ] && [ -d ${ActiveProjectDir} ]; then
					if [ -d ${ExportProjectDir} ]; then
						if [ ! -f ${ExportProjectDir}/${project}.tar.gz ]; then
							ClideFile=$(loadProject ${project})
							if [ ! -z "${ClideFile}" ]; then
								ProjectLang=$(echo ${ClideFile} | cut -d ';' -f 1 2> /dev/null)
								ProjectPath=$(echo ${ClideFile} | cut -d ';' -f 3 2> /dev/null)
								ProjectType=$(echo ${ClideFile} | cut -d ';' -f 4 2> /dev/null)
								if [ ! -z "${ProjectLang}" ] &&	[ ! -z "${ProjectPath}" ] && [ ! -z "${ProjectType}" ]; then
									if [ -d ${ProjectPath} ]; then
										cd ${ExportProjectDir}/
										case ${ProjectType} in
											${ProjectDefaultType})
												cp -pR ${ProjectPath}/ .
												grep -v "path=" ${ActiveProjectDir}/${project}.clide > ${project}.clide
												tar -cpzf ${project}.tar.gz ${project}/ ${project}.clide 2> /dev/null
												rm -rf ${project} ${project}.clide 2> /dev/null
												;;
											*)
												if [ -d ${TemplateProjectDir}/${ProjectLang}.${ProjectType} ]; then
													cp -pR ${ProjectPath}/ .
													cp -pR ${TemplateProjectDir}/${ProjectLang}.${ProjectType}/ .
													cp ${ActiveProjectDir}/${project}.clide .
													tar -cpzf ${project}.tar.gz ${project}/ ${project}.clide 2> /dev/null
													rm -rf ${project} ${project}.clide ${ProjectLang}.${ProjectType} 2> /dev/null
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
									errorCode "project" "export" "corrupted"
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
			else
				errorCode "project" "none" "${Head}"
			fi
			;;
	esac
}

importProject()
{
	local ProjectLang=$1
	local project=$2
	local ProjectFile
	local ClideFile
	local ProjectType
	local ProjectPath
	local IsSupported
	#No Project is found
	if [ -z "${project}" ]; then
		errorCode "project" "none" "${Head}"
	else
		#Make sure Imports dir exists
		if [ -d ${ImportProjectDir} ] && [ -d ${ActiveProjectDir} ]; then
			ProjectFile=${ActiveProjectDir}/${project}.clide
			#Make sure project.tar.gz exists and project isn't already installed
			if [ -f ${ImportProjectDir}/${project}.tar.gz ] && [ ! -f ${ProjectFile} ]; then
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
						ProjectLang=$(echo ${ClideFile} | cut -d ';' -f 1 2> /dev/null)
					fi

					if [ ! -z "${ProjectLang}" ]; then
						#Check if language is supported
						IsSupported=$(ManageLangs ${ProjectLang} "pgLang")
						if [ ! -z "${IsSupported}" ]; then
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
												ProjectType=$(echo ${ClideFile} | cut -d ';' -f 4 2> /dev/null)
												case ${ProjectType} in
													#if Generic...do nothing
													${ProjectDefaultType})
														;;
													#If specified
													*)
														#Make sure project type was included in tar.gz
														if [ -f ${ProjectLang}.${ProjectType} ] && [ ! -z "${ProjectType}" ]; then
															#Make sure existing project type doesn't already exist
															if [ ! -f ${TemplateProjectDir}/${ProjectLang}.${ProjectType} ] && [ -d ${TemplateProjectDir} ]; then
																mv ${ProjectLang}.${ProjectType} ${TemplateProjectDir}/ 2> /dev/null
															else
																rm ${ProjectLang}.${ProjectType}  2> /dev/null
															fi
														fi
														;;
												esac
											fi
											rm -rf ${project}/ ${project}.tar.gz 2> /dev/null
											errorCode "HINT" "${project} has been imported"
										fi
									else
										if [ -f ${ActiveProjectDir}/${project}.clide ]; then
											rm ${ActiveProjectDir}/${project}.clide 2> /dev/null
										fi
										errorCode "project" "exists" "${project}"
									fi
									;;
							esac
						else
							errorCode "project" "import" "corrupted"
						fi
					else
						errorCode "project" "import" "corrupted"
					fi
				fi
				cd - > /dev/null
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
			projectType="${ProjectDefaultType}"
		else
			case ${projectType} in
				--*)
					projectType="${ProjectDefaultType}"
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
	local SrcLine
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
	local Already
	local Lang=$1
	local Langs
	local LinkLang=$2
	local ThePath
	local LinkPath
	local project=$3
	if [  -z "${project}" ]; then
		project=${CodeProject}
	fi
	local ProjectFile=${ActiveProjectDir}/${project}.clide
	LinkLang="${LinkLang,,}"
	LinkLang="${LinkLang^}"

	if [ ! -z "${LinkLang}" ]; then
		Already=$(grep "link=" ${ProjectFile})
		Langs=$(ls ${LangsDir}/ | sed "s/Lang./|/g" | tr -d '\n')
		if [ ! -f "${Langs}" ]; then
			ThePath=$(ManageLangs ${LinkLang} "getProjDir")
			LinkPath=$(ManageLangs ${Lang} "getProjDir")
			if [ -d ${ThePath} ]; then
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
		fi
	fi
}

#swap project to linked lagnauge
swapProjects()
{
	local Lang=$1
	local LinkLang=$2
	local Langs
	local ThePath
	local LinkPath
	#ALL Lowercase
	LinkLang="${LinkLang,,}"
	#FIRST character uppercase
	LinkLang="${LinkLang^}"
	local project=${CodeProject}
	local ProjectFile=${ActiveProjectDir}/${project}.clide
	local Already

	if [ ! -z "${LinkLang}" ]; then
		if [ -f ${ProjectFile} ]; then
			Already=$(grep "link=" ${ProjectFile})
			Langs=$(ls ${LangsDir}/ | sed "s/Lang./|/g" | tr -d '\n')
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
	fi
}

#list active projects
listProjects()
{
	local options=$1
	local TheName=$2
	case ${options} in
		-i|--info)
			local Name
			local Lang
			local Linked
			local TheColor
			local TheProject
			if [ ! -z "${TheName}" ]; then
				TheProject=${ActiveProjectDir}/${TheName}.clide
				if [ -f ${TheProject} ]; then
					Name=$(grep "name=" ${TheProject} | sed "s/name=//1")
					Lang=$(grep "lang=" ${TheProject} | sed "s/lang=//1")
					Linked=$(grep "link=" ${TheProject} | sed "s/link=//1")
					TheColor=$(ManageLangs ${Lang} "color-number")
					echo -e "\e[1;4${TheColor}mProject:\e[0m \e[1;3${TheColor}m${Name}\e[0m"
					echo -e "\e[1;4${TheColor}mLanguage:\e[0m \e[1;3${TheColor}m${Lang}\e[0m"
					if [ ! -z "${Linked}" ]; then
						echo -en "\e[1;4${TheColor}mLinked:\e[0m"
						echo -n " "
						for TheLang in ${Linked//,/ };
						do
							case ${TheLang} in
								${Lang})
									;;
								*)
									TheColor=$(ManageLangs ${TheLang} "color-number")
									echo -en "\e[1;3${TheColor}m${TheLang}\e[0m"
									echo -n " "
									;;
							esac
						done
						echo ""
					fi
					echo ""
				fi
			else
				for TheProject in ${ActiveProjectDir}/*.clide;
				do
					Name=$(grep "name=" ${TheProject} | sed "s/name=//1")
					Lang=$(grep "lang=" ${TheProject} | sed "s/lang=//1")
					Linked=$(grep "link=" ${TheProject} | sed "s/link=//1")
					TheColor=$(ManageLangs ${Lang} "color-number")
					#echo -e "\e[1;4${TheColor}mProject:\e[0m \e[1;3${TheColor}m${Name}\e[0m"
					#echo -e "\e[1;4${TheColor}mLanguage:\e[0m \e[1;3${TheColor}m${Lang}\e[0m"
					echo -e "Project: \e[1;3${TheColor}m${Name}\e[0m"
					echo -e "Language: \e[1;3${TheColor}m${Lang}\e[0m"
					if [ ! -z "${Linked}" ]; then
						echo -en "\e[1;4${TheColor}mLinked:\e[0m"
						echo -n " "
						for TheLang in ${Linked//,/ };
						do
							case ${TheLang} in
								${Lang})
									;;
								*)
									TheColor=$(ManageLangs ${TheLang} "color-number")
									echo -en "\e[1;3${TheColor}m${TheLang}\e[0m"
									echo -n " "
									;;
							esac
						done
						echo ""
					fi
					echo ""
				done
			fi
			;;
		*)
			#Get list of active prijects from .clide files
			if [ -d ${ActiveProjectDir} ]; then
				cd ${ActiveProjectDir}/
				ls *.clide 2> /dev/null | sed "s/.clide//g"
				cd - > /dev/null
			fi
			;;
	esac
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

	if [ -d ${LangsDir} ]; then
		for TheLang in ${LangsDir}/Lang.*;
		do
			#Select the next langauge
			if [ -f ${TheLang} ]; then
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
											cName=$(ManageLangs ${TheLang} "ProjectColor" "${Name}")
											cTheLang=$(color "${TheLang}")
											cLinkLang=$(color "${LinkLang}")
											echo "[Project: ${cTheLang}{${cName}}]"
											recoverProject ${TheLang} ${Name} ${Path}/${Name} > /dev/null
											discoverProject "relink" ${TheLang} ${Name} "Not Done"
										fi
									fi
									;;
							esac
						fi
					done
				fi
			fi
		done
	fi
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
	local TheSrc=$3
	local NewPackage=$4
	local PackageName=${ThePackage}
	local OldPackagePath
	local NewPackagePath
	local Proceed
	local TheExt
	local AllSrc
	local TheClass
	local aSrc
	#package commands
	case ${TheAction,,} in
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
		get)
			ThePackage=$(ManageLangs ${Lang} "getPackage" ${TheSrc})
			if [ ! -z "${ThePackage}" ]; then
				echo ${ThePackage}
			fi
			;;
		mv|move)
			if [ ! -z "${TheSrc}" ]; then
				ThePackage=$(HandleJavaPackage ${Lang} "get" ${TheSrc})
				if [ ! -z "${ThePackage}" ] && [ ! -z "${NewPackage}" ]; then
					Proceed=$(ManageLangs ${Lang} "isPackage" ${ThePackage})
					case ${Proceed} in
						yes)
							TheExt=$(ManageLangs ${Lang} "getExt")
							OldPackagePath=$(ManageLangs ${Lang} "pathPackage" ${ThePackage})
							HandleJavaPackage ${Lang} "new" ${NewPackage} > /dev/null
							NewPackagePath=$(ManageLangs ${Lang} "pathPackage" ${NewPackage})
							case ${TheSrc} in
								*${TheExt})
									;;
								*)
									TheSrc=${TheSrc}${TheExt}
									;;
							esac
							case ${OldPackagePath} in
								${NewPackagePath})
									errorCode "package" "same"
									;;
								*)
									TheClass=$(ManageLangs ${Lang} "removeExt" ${TheSrc})
									AllSrc=$(ManageLangs ${Lang} "getAllProjSrc")
									for aSrc in ${AllSrc};
									do
										if [ ! -z "${aSrc}" ]; then
											sed -i "s/import ${ThePackage}.${TheClass};/import ${NewPackage}.${TheClass};/g" ${aSrc}
										fi
									done
									mv ${OldPackagePath}/${TheSrc} ${NewPackagePath}/${TheSrc}
									sed -i "s/package ${ThePackage};/package ${NewPackage};/g" ${NewPackagePath}/${TheSrc}
									echo "${TheSrc}: Package (${ThePackage} -> ${NewPackage})"
									;;
							esac
							cd - > /dev/null
							;;
						*)
							;;
					esac
				else
					echo "package or source code not found"
				fi
			else
				echo "no source code found"
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

compileCode()
{
	local Lang=$1
	shift
	local options
	local CplFlag
	local CplInputs=( "${@}" )
	CplInputs[0]=""
	CplFlag=${CplInputs[1]}
	case ${CplInputs[1]} in
		-a|--args|--get-args|--type)
			CplInputs[1]=""
			;;
		*)
			;;
	esac

	case ${CplFlag} in
		-a|--args)
			if [ -z "${CplInputs[2]}" ]; then
				#Get help page from language support file
				options=$(ManageLangs ${Lang} "setCplArgs-help" | tr '\n' '|')
				if [ -z "${options}" ]; then
					errorCode "cpl" "cpl-args"
				else
					echo -e "${options//|/\\n}"
				fi
				#Show Active cpl args
				case ${RunCplArgs} in
					none)
						;;
					*)
						echo -n "Compile Arguments: "
						echo "\"${RunCplArgs//,/ }\""
						;;
				esac
			else
				case ${CplInputs[2]} in
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
						#Keep OLD cpl args
						local OldCplArgs=${RunCplArgs}
						#Checking and getting compile arguments
						local newCplArgs=$(ManageLangs ${Lang} "setCplArgs" "${CplInputs[@]}")
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
									case ${newCplArgs} in
										none)
											;;
										*)
											RunCplArgs="${RunCplArgs},${newCplArgs}"
											;;
									esac
									;;
							esac
						fi
						#CompileCode
						ManageLangs ${Lang} "compileCode"
						#Reset to OLD cpl args
						RunCplArgs=${OldCplArgs}
						;;
				esac
			fi
			;;
		--get-args)
			case ${RunCplArgs} in
				none)
					;;
				*)
					echo -n "Compile Arguments: "
					echo "\"${RunCplArgs//,/ }\""
					;;
			esac
			;;
		--type)
			local NewCplType
			if [ -z "${CplInputs[2]}" ]; then
				echo "Possible Compile Types"
				ManageLangs ${Lang} "compileType-list"
				echo ""
				echo -n "Active: "
				if [ ! -z "${TypeOfCpl}" ]; then
					echo ${TypeOfCpl}
				else
					echo "Default"
				fi
			else
				case ${CplInputs[2]} in
					--help)
						ManageLangs ${Lang} "compileType-list"
						;;
					--reset|reset)
						TypeOfCpl=""
						errorCode "HINT" "Compile Type reset to default"
						;;
					*)
						NewCplType=$(ManageLangs ${Lang} "compileType" ${CplInputs[2]})
						if [ ! -z "${NewCplType}" ]; then
							TypeOfCpl="${NewCplType}"
							errorCode "HINT" "Set to Compile as a \"${TypeOfCpl}\""
						fi
						;;
				esac
			fi
			;;
		--*)
			local NewCplType=$(ManageLangs ${Lang} "compileType" ${CplInputs[1]})
			if [ ! -z "${NewCplType}" ]; then
				TypeOfCpl="${NewCplType}"
				CplInputs[1]=""
			fi
			ManageLangs ${Lang} "compileCode" "${CplInputs[@]}"
			TypeOfCpl=""
			;;
		*)
			ManageLangs ${Lang} "compileCode" "${CplInputs[@]}"
			;;
	esac
	CplFlag=""
}

MultiPipe()
{
	local PipeAction=$1
	if [ ! -z "${ThePipe}" ]; then
		if [ ! -z "${PipeAction}" ]; then
			case ${PipeAction} in
				--save)
					cp /dev/stdin ${MultiPipeFile}
					;;
				--remove)
					rm ${MultiPipeFile}
					;;
				*)
					;;
			esac
		fi
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
	local Args=( "${@}" )
	local First="${Args[0]}"
	local JavaProp="none"
	local TheBin
	local TheLang
	case ${CodeProject} in
		none)
			TheBin=$(ManageLangs ${Lang} "getBin" "${name}")
			;;
		*)
			TheBin=$(ManageLangs ${Lang} "getBin" "${CodeProject}")
			;;
	esac

	if [ ! -z "${TheBin}" ]; then
		#User Wishes to provide arments for program
		case ${option} in
			-a|--args)
				TheLang=$(color "${Lang}")
				CLIout=$(ManageLangs ${Lang} "cli" "${TheBin}")
				if [ -z "${TimeRun}" ]; then
					CLIout="$USER@${Name}:~/${TheLang}\$ ${CLIout}"
				else
					CLIout="$USER@${Name}:~/${TheLang}\$ ${TimeRun} ${CLIout}"
				fi
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
						Args=( "${RunTimeArgs[@]}" )
						CodeRunArgs=( "${RunTimeArgs[@]}" )
					fi
				fi
				;;
			*)
				;;
		esac

		runCodeMessage ${Lang} ${TheBin} "started"
		#Get the Lang.<language> to handle running the code
		ManageLangs ${Lang} "runCode" "${TheBin}" "${JavaProp}" "${Args[@]}"
		runCodeMessage ${Lang} ${TheBin} "finished"

	else
		errorCode "cpl" "need" ${Lang}
	fi
}

runCodeMessage()
{
	local Lang=$1
	local TheCode=$2
	local TheColor
	local Status=$3
	Status=${Status,,}
	if [ ! -z "${Lang}" ]; then
		case ${InAndOut} in
			yes)
				case ${MessageOverride} in
					yes)
						TheColor=$(ManageLangs ${Lang} "color-number")
						case ${Status} in
							started)
								echo -e "\e[1;3${TheColor}m{[${Lang}: ${TheCode}] *${Status^}*}\e[0m"
								;;
							finished)
								echo -e "\e[1;3${TheColor}m{[${Lang}: ${TheCode}] *${Status^}*}\e[0m"
								;;
							*)
								;;
						esac
						;;
					*)
						;;
				esac
				;;
			*)
				case ${Lang} in
					no)
						;;
					*)
						TheColor=$(ManageLangs ${Lang} "color-number")
						case ${Status} in
							started|finished)
								echo -e "\e[1;3${TheColor}m[${TheCode}] *${Status^}*\e[0m"
								;;
							*)
								;;
						esac
						;;
				esac
				;;
		esac
	fi
}

InstallCode()
{
	local Lang=$1
	shift
	local InstallType=$2
	shift
	local UserIn=( "${@}" )
	case ${InstallType} in
		--alias)
			ManageLangs ${Lang} "Install-alias" ${TheSrcCode} "${UserIn[@]}"
			;;
		--bin)
			ManageLangs ${Lang} "Install-bin" ${TheSrcCode} "${UserIn[@]}"
			;;
		--check)
			ManageLangs ${Lang} "Install-check" ${TheSrcCode} "${UserIn[@]}"
			;;
		--root-bin)
			ManageLangs ${Lang} "Install-root" ${TheSrcCode} "${UserIn[@]}"
			;;
		--user-bin)
			ManageLangs ${Lang} "Install-user" ${TheSrcCode} "${UserIn[@]}"
			;;
		--help)
			HelpMenu ${Lang} "install"
			;;
		*)
			HelpMenu ${Lang} "install"
			;;
	esac
}

CopyOrRename()
{
	local Lang=$1
	local UserArg=$2
	local chosen
	local TheNewChosen
	local GetCount
	shift
	local UserIn=( "${@}" )
	case ${UserIn[1]} in
		--help)
			HelpMenu ${Lang} "${UserIn[@]}"
				;;
		*)
			chosen=${UserIn[1]}
			TheNewChosen=${UserIn[2]}
			case ${TheSrcCode} in
				*,*)
					if [ ! -z "${TheNewChosen}" ]; then
						case ${TheSrcCode} in
							*${chosen}*)
								GetCount=$(echo -e ${TheSrcCode//,/\\n} | grep ${chosen} | wc -l)
								case ${GetCount} in
									1)
										chosen=$(echo -e ${TheSrcCode//,/\\n} | grep ${chosen})
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
										TheSrcCode=${TheSrcCode//${chosen}/${TheNewChosen}}
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
						if [ ! -z "${chosen}" ]; then
							case ${UserArg} in
								rename)
									TheSrcCode=$(ManageLangs ${Lang} "rename" ${TheSrcCode} ${chosen})
									;;
								cp|copy)
									TheSrcCode=$(ManageLangs ${Lang} "copy" ${TheSrcCode} ${chosen})
									;;
								*)
									;;
							esac
							refresh="yes"
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
					else
						case ${TheSrcCode} in
							${chosen})
								if [ ! -z "${chosen}" ]; then
									case ${UserArg} in
										rename)
											TheSrcCode=$(ManageLangs ${Lang} "rename" ${chosen} ${TheNewChosen})
											;;
										cp|copy)
											TheSrcCode=$(ManageLangs ${Lang} "copy" ${chosen} ${TheNewChosen})
											;;
										*)
											;;
									esac
									refresh="yes"
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
							*${chosen}*)
								chosen=$(echo ${TheSrcCode} | grep ${chosen})
								case ${UserArg} in
									rename)
										TheSrcCode=$(ManageLangs ${Lang} "rename" ${chosen} ${TheNewChosen})
										;;
									cp|copy)
										TheSrcCode=$(ManageLangs ${Lang} "copy" ${chosen} ${TheNewChosen})
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
	esac
}

BackupOrRestore()
{
	local Lang=$1
	local UserArg=$2
	shift
	shift
	shift
	local theAction=$1
	local chosen=$1
	local LangByExt
	case ${TheSrcCode} in
		*,*)
			#handle flag aruyments
			if [ ! -z "${chosen}" ]; then
				case ${theAction} in
					--*)
						chosen=$2
						;;
					*)
						;;
				esac

				case ${TheSrcCode} in
					*${chosen}*)
						LangByExt=$(ManageLangs ${Lang} "hasExt" "${chosen}")
						if [ ! -z "${LangByExt}" ]; then
							case ${UserArg} in
								bkup|backup)
									case ${theAction} in
										--remove)
											ManageLangs ${Lang} "backup-remove" ${chosen}
											;;
										--restore)
											ManageLangs ${Lang} "restore" ${chosen}
											;;
										*)
											ManageLangs ${Lang} "backup" ${chosen}
											;;
									esac
									;;
								restore)
									ManageLangs ${Lang} "restore" ${chosen}
									;;
								*)
									;;
							esac
						else
							errorCode "backup" "need-ext"
						fi
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
			case ${UserArg} in
				bkup|backup)
					case ${theAction} in
						--remove)
							ManageLangs ${Lang} "backup-remove" ${TheSrcCode}
							;;
						--restore)
							ManageLangs ${Lang} "restore" ${TheSrcCode}
							;;
						*)
							ManageLangs ${Lang} "backup" ${TheSrcCode}
							;;
					esac
					;;
				restore)
					ManageLangs ${Lang} "restore" ${TheSrcCode}
					;;
				*)
					;;
			esac
			;;
	esac
}

ManageCreate()
{
	local Lang=$1
	shift
	local Code=$1
	shift
	local Choice=$1
	shift
	local CreateArgs=( "${@}" )
	if [ ! -z "${Choice}" ]; then
		ManageLangs ${Lang} "${Choice}" ${Code} "${UserIn[@]}"
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

ListLangs()
{
	local text
	local TheColor
	local ChosenLangs=""
	local Option=$1

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
				if [ ! -z "${Option}" ]; then
					case ${Option} in
						--cpl|--compiler|--run-time)
							local ShowCpl=$(ManageLangs ${text} "pgLang" --cpl)
							echo "${TheColor}: {${ShowCpl}}"
							;;
						*)
							;;
					esac
				else
					if [ -z "${ChosenLangs}" ]; then
						ChosenLangs=${TheColor}
					else
						ChosenLangs="${ChosenLangs} ${TheColor}"
					fi
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

#No-Lang IDE
Actions-NoLang()
{
	history -c
	Lang="no-lang"
	local NoLang=cl[$(echo -e "\e[1;41mide\e[0m")]
	local UserIn
	local cLang=$(echo -e "\e[1;31m${Lang}\e[0m")
	local prompt="${NoLang}(${cLang}):~$ "
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
			read)
				case ${UserIn[1],,} in
					--config)
						main "--read" "--config" "session"
						;;
					*)
						;;
				esac
				;;
			edit)
				case ${UserIn[1],,} in
					--config)
						main "--edit" "--config"
						;;
					*)
						;;
				esac
				;;
			config)
				case ${UserIn[1],,} in
					--read)
						main "--read" "--config" "session"
						;;
					--edit)
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
			ll|languages)
				CLI "-ll" "${UserIn[1],,}"
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
			#list projects
			project)
				case ${UserIn[1],,} in
					info)
						main "--project" "--list" "--info"
						;;
					discover)
						main "--project" "--discover"
						;;
					remove|delete)
						if [ ! -z "${UserIn[2]}" ]; then
							main --project --${UserIn[1]} ${UserIn[2]}
						fi
						;;
					*)
						main "--project" "--list"
						;;
				esac
				;;
			#jump out of No-Lang session and into a language session
			use|bash|c|c++|go|java|python|perl|php|ruby|rust)
				local Lang
				local Code
				case ${UserIn[0],,} in
					use)
						if [ ! -z "${UserIn[1]}" ]; then
							Lang=${UserIn[1]}
							Code=${UserIn[2]}
							TypeOfCpl=""
						else
							Lang=""
						fi
						;;
					*)
						Lang=${UserIn[0]}
						Code=${UserIn[1]}
						TypeOfCpl=""
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
			#Modes
			mode)
				local ModeArgs=( "${UserIn[@]}" )
				case ${UserIn[1]} in
					#Provide help page when asked
					-h|--help)
						ModeArgs[0]=""
						ModeArgs[1]=""
						theHelp ModesHelp "${ModeArgs[@]}"
						;;
					*)
						local useMode=${ModeArgs[1]}
						ModeArgs[0]=""
						ModeArgs[1]=""
						#Swap cl[ide] to a given mode
						ModeHandler ${useMode} ${Lang} ${cLang} "none" "${ModeArgs[@]}"
						;;
				esac
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
	TheSrcCode="$2"
	shift
	shift
	local CodeDir=$(pgDir ${Lang})
	local pLangs=$(ListLangs)
	local prompt
	local listSrc
	local cntSrc
	local ThePWD
	local refresh
	local UserArg
	local ProjectPrompt
	local GenLines
	local FirstAction=$1
	#Pass into array
	local UserIn=( "${@}" )
	CodeProject="none"

	#Language Chosen
	if [[ ! "${CodeDir}" == "no" ]]; then
		cd ${CodeDir}/${Dir}
		TheSrcCode=$(preSelectSrc ${Lang} ${TheSrcCode})
		#Change Color for Language
		cLang=$(color ${Lang})
		#Handle the CLI User Interface
		#{
		if [ -z "${TheSrcCode}" ]; then
			case ${CodeProject} in
				none)
					#Menu with no code
					prompt="${Name}(${cLang}):~$ "
					;;
				*)
					ThePWD=${PWD}
					ProjectDir=${ThePWD##*/}
					cCodeProject=$(ManageLangs ${Lang} "ProjectColor")
					#Menu with no code
					case ${ProjectDir} in
						${CodeProject})
							ProjectDir=""
							;;
						*)
							;;
					esac
					prompt="${Name}(${cCodeProject}):~/${ProjectDir}$ "
					;;
			esac
		else
			#Change Color for Code
			cCode=$(color ${TheSrcCode})
			case ${TheSrcCode} in
				*,*)
					cntSrc=$(echo -e "${TheSrcCode//,/\\n}" | wc -l)
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
					prompt="${Name}(${cLang}{${listSrc}}):~$ "
					;;
				*)
					ThePWD=${PWD}
					ProjectDir=${ThePWD##*/}
					#Menu with no code
					cCodeProject=$(ManageLangs ${Lang} "ProjectColor")
					case ${ProjectDir} in
						${CodeProject})
							#ProjectDir="/"
							ProjectDir=""
							;;
						*)
							;;
					esac
					prompt="${Name}(${cCodeProject}{${listSrc}}):~/${ProjectDir}$ "
					;;
			esac
		fi
		#}
		case ${InAndOut} in
			yes)
				;;
			*)
				if [ -z "${ThePipe}" ]; then
					VerColor=$(ManageLangs ${Lang} "color-number")
					Banner ${Lang}
				fi
				;;
		esac

		#Keep IDE running until user is done
		while true
		do
			#Protect clide from being edited
			Protect
			#User's first action
			if [ ! -z "${FirstAction}" ]; then
				UserArg=${FirstAction,,}
			else
				if [ -z "${ThePipe}" ]; then
					#Handle CLI
					#read -a UserIn
					read -e -p "${prompt}" -a UserIn
					UserArg=${UserIn[0],,}
				fi
			fi

			if [ ! -z "${UserArg}" ]; then
				case ${UserArg} in
					banner)
						VerColor=$(ManageLangs ${Lang} "color-number")
						Banner ${Lang}
						;;
					#List files
					ls)
						ls --color=auto ${UserIn[1]}
						;;
					lscpl)
						#list compiled code using Lang.<language>
						ManageLangs ${Lang} "lscpl"
						;;
					ll)
						shift
						ls -lh --color=auto ${UserIn[1]}
						;;
					#Clear screen
					clear)
						clear
						;;
					whoami)
						echo "${USER}"
						;;
					type)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								ManageLangs ${Lang} "Lang-Type" ${UserIn[1]}
								;;
						esac
						;;
					#Set for session or add code to session
					select|set|add)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								local theExt
								local theOtherExt
								local newCode
								local newCodeWithoutExt
								local OldCode
								if [ ! -z "${TheSrcCode}" ]; then
									if [ ! -z "${UserIn[1]}" ]; then
										theExt=$(ManageLangs ${Lang} "getExt")
										theOtherExt=$(ManageLangs ${Lang} "getOtherExt")
										for newCode in ${UserIn[1]//,/ };
										do
											newCodeWithoutExt=$(ManageLangs ${Lang} "removeExt" ${newCode})
											#Ensure Code is not added twice
											if [[ ! "${TheSrcCode}" == *"${newCodeWithoutExt}${theExt}"* ]] || [[ ! "${TheSrcCode}" == *"${newCodeWithoutExt}${theOtherExt}"* ]]; then
												OldCode=${TheSrcCode}
												TheSrcCode=$(ManageLangs ${Lang} "addCode" ${TheSrcCode} ${newCode})
												#make sure code has changed
												case ${TheSrcCode} in
													#Code has not changed...do nothing
													${OldCode})
														errorCode "selectCode" "not-found" "${newCode}"
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
												TheSrcCode=$(preSelectSrc ${Lang} ${UserIn[1]})
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
						esac
						;;
					#Unset code for session
					unset)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								local TheNewChosen
								if [ ! -z "${UserIn[1]}" ]; then
									TheNewChosen=$(preSelectSrc ${Lang} ${UserIn[1]})
									if [ ! -z "${TheNewChosen}" ]; then
										case ${TheSrcCode} in
											"${TheNewChosen},"*)
												TheSrcCode=${TheSrcCode//${TheNewChosen},/}
												refresh="yes"
												;;
											*",${TheNewChosen},"*)
												TheSrcCode=${TheSrcCode//,${TheNewChosen},/,}
												refresh="yes"
												;;
											*",${TheNewChosen}")
												TheSrcCode=${TheSrcCode//,${TheNewChosen}/}
												refresh="yes"
												;;
											*)
												;;
										esac
									fi
								else
									TheSrcCode=""
									refresh="yes"
								fi
								;;
						esac
						;;
					#Delete source code and binary
					rm|remove|delete)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							--src|--bin)
								Remove ${UserIn[1]} ${TheSrcCode} ${UserIn[2]} ${UserIn[3]}
								TheSrcCode=""
								refresh="yes"
								;;
							*)
								Remove "--all" ${TheSrcCode} ${UserIn[1]} ${UserIn[2]}
								TheSrcCode=""
								refresh="yes"
								;;
						esac
						;;
					#Delete source code
					rmsrc)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								Remove "--src" ${TheSrcCode} ${UserIn[1]} ${UserIn[2]}
								TheSrcCode=""
								refresh="yes"
								;;
						esac
						;;
					#Delete binary
					rmbin)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								Remove "--bin" ${TheSrcCode} ${UserIn[1]} ${UserIn[2]}
								refresh="yes"
								;;
						esac
						;;
					#Display the language being used
					using)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								echo "${cLang}"
								;;
						esac
						;;
					#change dir in project
					cd)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								local here
								local ProjectDir=$(ManageLangs ${Lang} "getProjectDir")
								#Use ONLY for Projects
								case ${CodeProject} in
									none)
										errorCode "project" "none"
										;;
									*)
										if [ ! -z "${UserIn[1]}" ]; then
											cd ${UserIn[1]} > /dev/null
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
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
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
										case ${UserIn[1]} in
											--help)
												HelpMenu ${Lang} "${UserIn[@]}"
												;;
											mv|move)
												TheExt=$(ManageLangs ${Lang} "getExt")
												case ${TheSrcCode} in
													*,*)
														case ${TheSrcCode} in
															*"${UserIn[2]}"*)
																case ${TheSrcCode} in
																	*"${UserIn[3]}"*|*"${UserIn[3]}${TheExt}"*)
																		errorCode "package" "need-name"
																		;;
																	*)
																		HandleJavaPackage ${Lang} ${UserIn[1]} ${UserIn[2]} ${UserIn[3]}
																		;;
																esac
																;;
															*)
																errorCode "package" "none"
																;;
														esac
														;;
													*)
														if [ ! -z "${TheSrcCode}" ] && [ -z "${UserIn[3]}" ]; then
															case ${TheSrcCode} in
																${UserIn[2]}|${UserIn[2]}${TheExt})
																	errorCode "package" "need-name"
																	;;
																*)
																	HandleJavaPackage ${Lang} ${UserIn[1]} ${TheSrcCode} ${UserIn[2]}
																	;;
															esac
														else
															HandleJavaPackage ${Lang} ${UserIn[1]} ${UserIn[2]} ${UserIn[3]} ${UserIn[4]}
														fi
														;;
												esac
												;;
											get)
												if [ -z "${UserIn[2]}" ]; then
													HandleJavaPackage ${Lang} ${UserIn[1]} ${TheSrcCode}
												else
													HandleJavaPackage ${Lang} ${UserIn[1]} ${UserIn[2]}
												fi
												;;
											*)
												HandleJavaPackage ${Lang} ${UserIn[1]} ${UserIn[2]} ${UserIn[3]} ${UserIn[4]}
												refresh="yes"
												;;
										esac
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
						if [ ! -z "${TheSrcCode}" ]; then
							case ${UserIn[1]} in
								--help)
									HelpMenu ${Lang} "${UserIn[@]}"
									;;
								*)
									echo -e "${TheSrcCode//,/\\n}"
									;;
							esac
						fi
						;;
					make)
						case ${CodeProject} in
							#Is not a project
							none)
								errorCode "project" "none" "${Head}"
								;;
							#Is a project
							*)
								case ${UserIn[1]} in
									--help)
										HelpMenu ${Lang} "${UserIn[@]}"
										;;
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
														ManageLangs ${Lang} "create-make"
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
						esac
						;;
					#Handle Projects
					project)
						#Project commands
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							#Create new project
							new)
								local ProjectName=${UserIn[2]}
								local projectType=${UserIn[3]}
								#Ensure project has a name
								if [ ! -z "${ProjectName}" ]; then
									case ${ProjectName} in
										-*)
											;;
										*)
											#Locate Project Directory
											if [ -f ${ActiveProjectDir}/${ProjectName}.clide ]; then
												errorCode "project" "exists" ${ProjectName}
											else
												newProject ${Lang} ${ProjectName} ${projectType} ${UserIn[4]}
												if [ -f ${ActiveProjectDir}/${ProjectName}.clide ]; then
													TheSrcCode=""
													updateProject ${TheSrcCode}
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
											;;
									esac
								fi
								refresh="yes"
								;;
							#Add a title to the project
							title)
								local LangColor
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
											LangColor=$(ManageLangs ${Lang} "color-number")
											local HasTitle=$(grep "title=" ${TheFile})
											if [ -z "${HasTitle}" ]; then
												local Args
												echo -n "Title: "
												read -a Args
												if [ ! -z "${Args[0]}" ]; then
													echo "title=${Args[@]}" >> ${TheFile}
													echo -e "\e[1;4${LangColor}mTitle added\e[0m"
												else
													errorCode "project" "no-title"
												fi
											else
												errorCode "project" "already-title" "${CodeProject}"
												HasTitle=$(echo ${HasTitle} | sed "s/title=//g")
												echo ""
												echo -e "\e[1;4${LangColor}mTitle:\e[0m \e[1;3${LangColor}m\"${HasTitle}\"\e[0m"
											fi
										fi
										;;
								esac
								;;
							#Update live project
							update|save)
								local LangColor=$(ManageLangs ${Lang} "color-number")
								updateProject ${TheSrcCode}
								echo -e "\e[1;4${LangColor}m\"${CodeProject}\" updated\e[0m"
								;;
							#list the project files
							files)
								local CodeDir=$(ManageLangs ${Lang} "getProjectDir")
								local RemoveDirs=${CodeDir//\//|}
								case ${UserIn[2]} in
									src)
										ManageLangs ${Lang} "getAllProjSrc" | tr '/' '|' | sed "s/${RemoveDirs}//g" | tr '|' '/'
										;;
									*)
										find ${CodeDir} -print | tr '/' '|' | sed "s/${RemoveDirs}//g" | tr '|' '/'
										;;
								esac
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
										TheSrcCode=""
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
										TheSrcCode=""
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
											TheSrcCode=""
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
												TheSrcCode=$(selectCode ${Lang} ${UserIn[3]})
											else
												TheSrcCode=""
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
								local LangColor

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
										TheSrcCode=$(echo ${project} | cut -d ";" -f 2)
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
											LangColor=$(ManageLangs ${Lang} "color-number")
											local HasTitle=$(grep "title=" ${TheFile})
											if [ ! -z "${HasTitle}" ]; then
												HasTitle=$(echo ${HasTitle} | sed "s/title=//g")
												echo -e "\e[1;4${LangColor}m${CodeProject}:\e[0m \e[1;3${LangColor}m\"${HasTitle}\"\e[0m"
											else
												echo -e "\e[1;4${LangColor}mProject \"${CodeProject}\" loaded\e[0m"
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
					use|bash|c|c++|go|java|python|perl|php|ruby|rust|no-lang|nl)
						Old=${Lang}
						OldCode=${TheSrcCode}
						case ${UserIn[0]} in
							use)
								if [ ! -z "${UserIn[1]}" ]; then
									case ${UserIn[1]} in
										no-lang|nl)
											Lang=${UserIn[1]}
											cLang=$(echo -e "\e[1;31m${Lang}\e[0m")
											TheSrcCode=""
											#Start IDE
											Actions-NoLang
											Protect "done"
											Lang=${Old}
											cLang=$(color ${Lang})
											TheSrcCode=${OldCode}
											;;
										*)
											Lang=$(pgLang ${UserIn[1]})
											TheSrcCode=${UserIn[2]}
											;;
									esac
								else
									Lang="no"
								fi
								;;
							*)
								case ${UserArg} in
									no-lang|nl)
										Lang=${UserArg}
										cLang=$(echo -e "\e[1;31m${Lang}\e[0m")
										TheSrcCode=""
										#Start IDE
										Actions-NoLang
										Protect "done"
										Lang=${Old}
										cLang=$(color ${Lang})
										TheSrcCode=${OldCode}
										;;
									*)
										Lang=$(pgLang ${UserIn[0]})
										TheSrcCode=${UserIn[1]}
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
							CodeProject="none"
							TheSrcCode=$(preSelectSrc ${Lang} ${TheSrcCode})
							ProjectType="${ProjectDefaultType}"
							RunTimeArgs=""
							TypeOfCpl=""
							#}
						else
							Lang=${Old}
							echo "Supported Languages: ${pLangs}"
						fi
						refresh="yes"
						;;
					#backup and restore the selected code
					bkup|backup|restore)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								BackupOrRestore ${Lang} ${UserArg} "${UserIn[@]}"
								;;
						esac
						;;
					#Rename the source code of selected code
					#OR
					#Make a copy of your selected code...similar to backup...but nothing to restore
					cp|copy|rename)
						CopyOrRename ${Lang} "${UserIn[@]}"
						refresh="yes"
						;;
					gencode)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							--all)
								if [ ! -z "${listSrc}" ]; then
									ManageLangs ${Lang} "gencode" "${TheSrcCode}"
								fi
								;;
							--lines)
								if [ ! -z "${listSrc}" ]; then
									ManageLangs ${Lang} "gencodeShow" "${TheSrcCode}"
								fi
								;;
							--keep|--save)
								if [ ! -z "${listSrc}" ]; then
									ManageLangs ${Lang} "gencodeSave" "${TheSrcCode}"
								fi
								;;
							*)
								if [ ! -z "${listSrc}" ]; then
									errorCode "WARNING"
									errorCode "WARNING" "Make sure you backup your code before saving"
									echo ""
									ManageLangs ${Lang} "gencodeOnly" "${TheSrcCode}"
									echo ""
									errorCode "WARNING"
									errorCode "WARNING" "Make sure you backup your code before saving"
								fi
						esac
						#tell user to remove backup if changes are good
						;;
					#use the shell of a given language
					shell)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								#UserIn[0]=""
								local ShellArgs=( "${UserIn[@]}" )
								case ${InAndOut} in
									no)
										if [ ! -z "${ShellArgs[1]}" ]; then
											case ${ShellArgs[1],,} in
												"help:"*|"help")
													ManageLangs ${Lang} "shell" "${ShellArgs[@]}"
													;;
												*)
													ManageLangs ${Lang} "shell" "${ShellArgs[@]}" | ${editor} -l -
													;;
											esac
										else
											ManageLangs ${Lang} "shell" "${ShellArgs[@]}"
										fi
										;;
									*)
										ManageLangs ${Lang} "shell" "${ShellArgs[@]}"
										;;
								esac
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
								ManageLangs ${Lang} "customCode" ${Lang} ${cLang} "${UserIn[@]}"
								AfterFiles=$(ManageLangs ${Lang} "AfterFiles")
								AllFiles="${BeforeFiles} ${AfterFiles}"
								#Look ALL files for new for new file
								NewCode=$(echo -e "${AllFiles// /\\n}" | sort | uniq -u | tr -d '\n')
								#Check if new code is found
								NewCode="${NewCode#*/}"
								if [ ! -z "${NewCode}" ]; then
									#Select new Code
									TheSrcCode=$(selectCode ${Lang} ${NewCode} ${TheSrcCode})
								fi
								;;
							--show|-s)
								#Show Source Code
								ManageLangs ${Lang} "customCodeShow" ${Lang} ${cLang} "${UserIn[@]}"
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
													ManageLangs ${Lang} "newCode" ${SrcName} ${SrcType} ${TheSrcCode}
													if [ ! -z "${TheSrcCode}" ]; then
														local OldCode=${TheSrcCode}
														local NewCode=$(ManageLangs ${Lang} "getCode" ${SrcName} ${OldCode})
														if [ ! -z "${NewCode}" ]; then
															case ${OldCode} in
																*"${NewCode}"*)
																	errorCode "selectCode" "already"
																	;;
																*)
																	TheSrcCode=$(ManageLangs ${Lang} "addCode" ${OldCode} ${NewCode})
																	;;
															esac
														fi
													else
														TheSrcCode=$(ManageLangs ${Lang} "getCode" ${SrcName} ${OldCode})
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
					#Edit new source code...Read code without editing
					${editor}|edit|ed|${ReadBy}|read)
						case ${UserIn[1]} in
							"--"*)
								case ${UserIn[1]} in
									--line)
										case ${UserArg} in
											#Edit new source code
											${editor}|edit|ed)
												if [ ! -z "${UserIn[2]}" ]; then
													EditLineNum=$(echo ${UserIn[2]} | sed "s/[^0-9]//g")
													if [ ! -z "${EditLineNum}" ]; then
														ManageLangs ${Lang} "editCode" "--line" ${EditLineNum} ${UserIn[3]}
													else
														errorCode "WARNING"
														errorCode "WARNING" "Please provide the line number you wish to edit"
													fi
												else
													errorCode "WARNING"
													errorCode "WARNING" "Please provide the line number you wish to edit"
												fi
												EditLineNum=""
												;;
											*)
												;;
										esac
										;;
									--help|*)
										HelpMenu ${Lang} "${UserIn[@]}"
										;;
								esac
								;;
							#edit non-langugage source files
							non-lang)
								if [ ! -z "${UserIn[2]}" ]; then
									case ${UserArg} in
										#Edit new source code
										${editor}|edit|ed)
											${editor} ${UserIn[2]}
											;;
										#Read code without editing
										${ReadBy}|read)
											${ReadBy} ${UserIn[2]}
											;;
										*)
											;;
									esac
								else
									case ${UserArg} in
										#Edit new source code
										${editor}|edit|ed)
											errorCode "selectCode"
											;;
										#Read code without editing
										${ReadBy}|read)
											errorCode "readCode"
											;;
										*)
											;;
									esac
								fi
								;;
							#edit language source code
							*)
								case ${UserArg} in
									#Edit new source code
									${editor}|edit|ed)
										ManageLangs ${Lang} "editCode" ${UserIn[1]}
										;;
									#Read code without editing
									${ReadBy}|read)
										ManageLangs ${Lang} "readCode" ${UserIn[1]}
										;;
									*)
										;;
								esac
								;;
						esac
						;;
					#Modes
					mode)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								#Swap cl[ide] to a given mode
								local ModeArgs=( "${UserIn[@]}" )
								ModeArgs[0]=""
								ModeArgs[1]="none"
								ModeHandler ${UserIn[1]} ${Lang} ${cLang} "${ModeArgs[@]}"
								;;
						esac
						;;
					#search for element in project
					search)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								lookFor ${UserIn[1]} ${UserIn[2]}
								;;
						esac
						;;
					#Write notes for code
					notes)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
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
						esac
						;;
					#create various files/vars for running/compiling code
					create)
						local NewVal
						local OldVal=${RunCplArgs}
						#what to create
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
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
												echo -e "${options//|/\\n}"
												case ${OldVal} in
													none)
														;;
													*)
														echo ""
														echo -n "Current Args: \""
														echo -ne "${OldVal//,/ }"
														echo "\""
														echo ""
														;;
												esac

												#User input
												echo -n "${cLang}\$ "
												read -a NewVal

												#User provided a value
												if [ ! -z "${NewVal}" ]; then
													NewVal=( ${UserIn[0]} ${UserIn[1]} ${UserIn[2]} "${NewVal[@]}" )
												fi
											fi
										#User gave pre-set argument
										else
											NewVal="${UserIn[@]}"
										fi

										#User Value was given
										if [ ! -z "${NewVal}" ]; then
											#Checking and getting compile arguments
											local newCplArgs=$(ManageLangs ${Lang} "setCplArgs" "${NewVal[@]}")
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
														case ${newCplArgs} in
															none)
																;;
															*)
																RunCplArgs="${RunCplArgs},${newCplArgs}"
																;;
														esac
														;;
												esac
											fi
										fi
										;;
								esac
								;;
							make)
								case ${UserIn[1]} in
									--help)
										HelpMenu ${Lang} "${UserIn[@]}"
										;;
									*)
										case ${Lang} in
											#only C and C++ uses make
											C*)
												ManageLangs ${Lang} "create-make"
												;;
											*)
												errorCode "make" "not-for-lang" ${Lang}
												;;
										esac
										;;
								esac
								;;
							#Args for run time
							args)
								case ${UserIn[1]} in
									--help)
										HelpMenu ${Lang} "${UserIn[@]}"
										;;
									*)
										echo -n "${cLang}\$ "
										read -a RunTimeArgs
										;;
								esac
								;;
							type)
								local NewCplType
								if [ -z "${UserIn[2]}" ]; then
									echo "Possible Compile Types"
									ManageLangs ${Lang} "compileType-list"
									echo ""
									echo -n "Active: "
									if [ ! -z "${TypeOfCpl}" ]; then
										echo ${TypeOfCpl}
									else
										echo "Default"
									fi
								else
									case ${UserIn[2]} in
										--help)
											ManageLangs ${Lang} "compileType-list"
											;;
										--reset|reset)
											TypeOfCpl=""
											errorCode "HINT" "Compile Type reset to default"
											;;
										*)
											NewCplType=$(ManageLangs ${Lang} "compileType" ${UserIn[2]})
											if [ ! -z "${NewCplType}" ]; then
												TypeOfCpl="${NewCplType}"
												errorCode "HINT" "Set to Compile as a \"${TypeOfCpl}\""
											fi
											;;
									esac
								fi
								;;
							time)
								TimeRun="time"
								errorCode "HINT" "Set to record runtime of a program"
								;;
							#Create new Template
							newCodeTemp)
								local NewCode=$(ManageLangs ${Lang} "getNewCode")
								local LangSrcDir=$(ManageLangs ${Lang} "getSrcDir")
								local MoveError
								local LinkError

								case ${UserIn[2]} in
									#Create your own "new" code template
									custom)
										if [ ! -f ${LangSrcDir}/${NewCode} ]; then
											ManageLangs ${Lang} "newCode" ${NewCode}
										fi
										#Select code
										TheSrcCode=$(selectCode ${Lang} "set" ${NewCode})
										refresh="yes"
										;;
									--help|help)
										theHelp CreateHelp ${Lang}
										;;
									#Use the template provided but cl[ide]
									*)
										#Create new souce code in newCode/
										if [ ! -f ${NewCodeDir}/${NewCode} ]; then
											if [ ! -f ${LangSrcDir}/${NewCode} ]; then
												ManageLangs ${Lang} "newCode" ${NewCode}
											fi
											#Move your custom code to cl[ide]'s template directory
											MoveError=$(mv ${LangSrcDir}/${NewCode} ${NewCodeDir}/ 2>&1)
										fi
										#Copy and set source code to src/
										if [ ! -f ${LangSrcDir}/${NewCode} ] && [ -f ${NewCodeDir}/${NewCode} ]; then
											LinkError=$(ln -s ${NewCodeDir}/${NewCode} 2>&1)
										elif [ ! -f ${LangSrcDir}/${NewCode} ] && [ ! -f ${NewCodeDir}/${NewCode} ]; then
											LinkError="no"
										fi
										if [ -z "${LinkError}" ] && [ -z "${MoveError}" ]; then
											TheSrcCode=$(selectCode ${Lang} "set" ${NewCode})
											refresh="yes"
										fi
										;;
								esac
								;;
							shellCode)
								local ShellCode=$(ManageLangs ${Lang} "getShellCode")
								local LangSrcDir=$(ManageLangs ${Lang} "getSrcDir")
								local MoveError
								local LinkError

								case ${UserIn[2]} in
									#Create your own "new" code template
									custom)
										if [ ! -f ${LangSrcDir}/${ShellCode} ]; then
											ManageLangs ${Lang} "newCode" ${ShellCode}
										fi
										#Select code
										TheSrcCode=$(selectCode ${Lang} "set" ${ShellCode})
										refresh="yes"
										;;
									--help|help)
										theHelp CreateHelp ${Lang}
										;;
									#Use the template provided but cl[ide]
									*)
										#Create new souce code in shellCode/
										if [ ! -f ${ShellsDir}/${ShellCode} ]; then
											if [ ! -f ${LangSrcDir}/${ShellCode} ]; then
												ManageLangs ${Lang} "newCode" ${ShellCode}
											fi
											#Move your custom code to cl[ide]'s template directory
											MoveError=$(mv ${LangSrcDir}/${ShellCode} ${ShellsDir}/ 2>&1)
										fi
										#Copy and set source code to src/
										if [ ! -f ${LangSrcDir}/${ShellCode} ] && [ -f ${ShellsDir}/${ShellCode} ]; then
											LinkError=$(ln -s ${ShellsDir}/${ShellCode} 2>&1)
										elif [ ! -f ${LangSrcDir}/${ShellCode} ] && [ ! -f ${ShellsDir}/${ShellCode} ]; then
											LinkError="no"
										fi
										if [ -z "${LinkError}" ] && [ -z "${MoveError}" ]; then
											TheSrcCode=$(selectCode ${Lang} "set" ${ShellCode})
											refresh="yes"
										fi
										;;
								esac
								;;
							version)
								case ${Lang} in
									#only C and C++ uses make
									C*)
										case ${RunCplArgs} in
											*-std=c*)
												echo -e ${RunCplArgs//,/\\n} | grep "std"
												;;
											*)
												if [ ! -z "${UserIn[2]}" ]; then
													case ${UserIn[2]} in
														*-std=c*)
															case ${RunCplArgs} in
																none)
																	RunCplArgs="${UserIn[2]}"
																	;;
																*)
																	RunCplArgs="${RunCplArgs},${UserIn[2]}"
																	;;
															esac
															;;
														*)
															ManageLangs ${Lang} "setCplArgs-help" | grep "c++"
															;;
													esac
												else
													ManageLangs ${Lang} "setCplArgs-help" | grep "c++"
													#User input
													echo -n "${cLang}\$ "
													read -a NewVal

													#User provided a value
													if [ ! -z "${NewVal}" ]; then
														case ${NewVal} in
															*-std=c*)
																case ${RunCplArgs} in
																	none)
																		RunCplArgs="${NewVal},"
																		;;
																	*)
																		RunCplArgs="${RunCplArgs},${NewVal}"
																		;;
																esac
																;;
															*)
																ManageLangs ${Lang} "setCplArgs-help" | grep "c++"
																;;
														esac
													fi
												fi
												;;
										esac
										;;
									*)
										;;
								esac
								;;
							#Clear all
							reset)
								case ${UserIn[2]} in
									cpl|cpl-args|version)
										RunCplArgs="none"
										echo "Compile args reset"
										;;
									args)
										RunTimeArgs=""
										echo "Run time args reset"
										;;
									type)
										TypeOfCpl=""
										echo "compile type reset"
										;;
									time)
										TimeRun=""
										;;
									all)
										#Default values
										RunTimeArgs=""
										RunCplArgs="none"
										TypeOfCpl=""
										TimeRun=""
										echo "All rest"
										;;
									--help|help|*)
										theHelp CreateHelp ${Lang}
										;;
								esac
								;;
							#Compile arguments
							${UserIn[1]}-${UserIn[2]})
								case ${OldVal} in
									none)
										RunCplArgs=$(ManageLangs ${Lang} "${UserIn[1]}-${UserIn[2]}" ${TheSrcCode} "${UserIn[@]}")
										;;
									*)
										RunCplArgs=$(ManageLangs ${Lang} "${UserIn[1]}-${UserIn[2]}" ${TheSrcCode} "${UserIn[@]}")
										RunCplArgs="${RunCplArgs} ${OldVal}"
										;;
								esac
								;;
							#Manage Create
							*)
								if [ ! -z "${UserIn[1]}" ]; then
									ManageCreate ${Lang} ${TheSrcCode} ${UserIn[1]} ${UserIn[2]} ${UserIn[3]}
								else
									HelpMenu ${Lang} "${UserIn[@]}"
								fi
								;;
						esac
						;;
					#(c)ompile (a)nd (r)un
					car)
						local CarArgs=( "${UserIn[@]}" )
						local CplArgs=( )
						local RunArgs=( )
						local GetRun
						CarArgs[0]=""
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								if [ ! -z "${TheSrcCode}" ]; then
									case ${CarArgs[1]} in
										-a|--args)
#											CarArgs[1]=""
											for ThisTime in ${CarArgs[@]};
											do
												if [ ! -z "${ThisTime}" ]; then
													case ${ThisTime} in
														--run)
															if [ -z "${GetRun}" ]; then
																GetRun="-a"
																ThisTime=""
															fi
															;;
														*)
															;;
													esac

													if [ ! -z "${ThisTime}" ] && [ -z "${GetRun}" ]; then
														CplArgs+=( "${ThisTime}" )
													else
														RunArgs+=( "${ThisTime}" )
													fi
												fi
											done
											#Lets Compile
											compileCode ${Lang} "cpl" "${CplArgs[@]}"
											;;
										--run)
											GetRun="-a"
											CarArgs[1]=""
											RunArgs=( "${CarArgs[@]}" )
											compileCode ${Lang} "cpl"
											;;
										*)
											#Lets Compile
											compileCode ${Lang} "cpl"
											;;
									esac

									if [ ! -z "${GetRun}" ]; then
										runCode ${Lang} ${TheSrcCode} "run" "--args"  "${RunArgs[@]}"
									else
										runCode ${Lang} ${TheSrcCode}
									fi
								fi
								;;
						esac
						CarArgs=""
						CplArgs=""
						RunArgs=""
						GetRun=""
						;;
					#Compile code
					compile|cpl)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								#Lets Compile
								compileCode ${Lang} "${UserIn[@]}"
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
						;;
					build)
						case ${CodeProject} in
							none)
								errorCode "project" "must-be-active"
								;;
							*)
								case ${UserIn[1]} in
									--help)
										HelpMenu ${Lang} "${UserIn[@]}"
										;;
									*)
										case ${Lang} in
											Java)
												TypeOfCpl="--jar"
												ManageLangs ${Lang} "compileCode" ${UserIn[1]} ${UserIn[2]}
												;;
											Rust)
												TypeOfCpl="--release"
												ManageLangs ${Lang} "compileCode" ${UserIn[1]} ${UserIn[2]}
												;;
											*)
												ManageLangs ${Lang} "compileCode" ${UserIn[1]} ${UserIn[2]}
												;;
										esac
										;;
								esac
								;;
						esac
						;;
					#Install compiled code into aliases
					install)
						InstallCode ${Lang} "${UserIn[@]}"
						;;
					#Add debugging functionality
					debug)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								if [ ! -z "${TheSrcCode}" ]; then
									local DebugEnabled
									local IsInstalled
									#Check if debugger is set in clide.conf
									local HasDebugger=$(ManageLangs ${Lang} "getDebugger")
									if [ ! -z "${HasDebugger}" ]; then
										#Determin if debugger is installed
										IsInstalled=$(which ${HasDebugger})
										if [ ! -z "${IsInstalled}" ]; then
											#Determine of source code has debugging enabled
											DebugEnabled=$(ManageLangs ${Lang} "IsDebugEnabled" "${TheSrcCode}")
											case ${DebugEnabled} in
												#Source code has debugging enabled
												yes)
													#Debug code by using Lang.<language>
													ManageLangs ${Lang} "debug" ${TheSrcCode}
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
						esac
						;;
					#restore edit on bash code
					edrst)
						if [ ! -z "${TheSrcCode}" ]; then
							ManageLangs ${Lang} "restore-edit" ${TheSrcCode}
						fi
						;;
					#run compiled code
					execute|exe|run)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							-d|--debug)
								ManageLangs ${Lang} "debug" ${TheSrcCode} "${UserIn[1]}"
								;;
							*)
								case ${CodeProject} in
									none)
										if [ ! -z "${TheSrcCode}" ]; then
											runCode ${Lang} ${TheSrcCode} "${UserIn[@]}"
										else
											errorCode "cpl" "none"
										fi
										;;
									#It is assumed that the project name is the binary
									*)
										if [ ! -z "${TheSrcCode}" ]; then
											runCode ${Lang} ${TheSrcCode} "${UserIn[@]}"
										else
											#May Cause Prolems
											runCode ${Lang} ${CodeProject} "${UserIn[@]}"
										fi
										;;
								esac
								;;
						esac
						;;
					time)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								TimeRun="time"
								case ${CodeProject} in
									none)
										if [ ! -z "${TheSrcCode}" ]; then
											runCode ${Lang} ${TheSrcCode} "${UserIn[@]}"
										else
											errorCode "cpl" "none"
										fi
										;;
									#It is assumed that the project name is the binary
									*)
										if [ ! -z "${TheSrcCode}" ]; then
											runCode ${Lang} ${TheSrcCode} "${UserIn[@]}"
										else
											#May Cause Prolems
											runCode ${Lang} ${CodeProject} "${UserIn[@]}"
										fi
										;;
								esac
								TimeRun=""
								;;
						esac
						;;
					#Display cl[ide] version
					version|v)
						CodeSupportVersion ${Lang}
						CodeTemplateVersion ${Lang}
						ShellCodeVersion ${Lang}
						CodeVersion ${Lang}
						DebugVersion ${Lang}
						;;
					#Display help page
					help)
						HelpMenu ${Lang} "${UserIn[@]}"
						;;
					#load last session
					last|load)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								local SavedLang=${Lang}
								local SavedCode=${TheSrcCode}
								local SavedProject=${CodeProject}
								local SavedCodeDir=${CodeDir}
								Dir=""
								session=$(LoadSession ${UserIn[1]})
								case ${session} in
									*"ERROR"*"No Session to load"*)
										echo ${session}
										;;
									*)
										Lang=$(echo ${session} | cut -d ";" -f 2)
										CodeProject=$(echo ${session} | cut -d ";" -f 1)
										TheSrcCode=$(echo ${session} | cut -d ";" -f 3)
										case ${CodeProject} in
											none)
												;;
											*)
												Dir="${CodeProject}"
												;;
										esac
										#Determine Language
										CodeDir=$(ManageLangs "${Lang}" "pgDir")
										if [ ! -z "${CodeDir}" ]; then
											CodeDir=${CodeDir}/${Dir}
											#Go to dir
											if [ -d ${CodeDir} ]; then
												cd ${CodeDir}
											else
												Lang=${SavedLang}
												TheSrcCode=${SavedCode}
												CodeProject=${SavedProject}
												CodeDir=${SavedCodeDir}
											fi
										else
											Lang=${SavedLang}
											TheSrcCode=${SavedCode}
											CodeProject=${SavedProject}
											CodeDir=${SavedCodeDir}
										fi

										if [ ! -z "${UserIn[1]}" ]; then
											echo "Session \"${UserIn[1]}\" is loaded"
										else
											echo "Session loaded"
										fi
										refresh="yes"
										;;
								esac
								;;
						esac
						;;
					#List supported languages
					langs|languages)
						local pg=$(ListLangs)
						echo "Supported Languages: ${pg}"
						;;
					#Save cl[ide] session
					save)
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							*)
								SaveSession ${Lang} ${UserIn[1]}
								;;
						esac
						;;
					session)
						local NewArgs=( "${UserIn[@]}" )
						NewArgs[0]=""
						case ${UserIn[1]} in
							--help)
								HelpMenu ${Lang} "${UserIn[@]}"
								;;
							list)
								ListSession
								;;
							#Save cl[ide] session
							save)
								case ${UserIn[2]} in
									--help)
										HelpMenu ${Lang} "${NewArgs[@]}"
										;;
									*)
										SaveSession ${Lang} ${UserIn[2]}
										;;
								esac
								;;
							#load last session
							last|load)
								case ${UserIn[2]} in
									--help)
										HelpMenu ${Lang} "${NewArgs[@]}"
										;;
									*)
										local SavedLang=${Lang}
										local SavedCode=${TheSrcCode}
										local SavedProject=${CodeProject}
										local SavedCodeDir=${CodeDir}
										Dir=""
										session=$(LoadSession ${UserIn[2]})
										case ${session} in
											*"ERROR"*"No Session to load"*)
												echo ${session}
												;;
											*)
												Lang=$(echo ${session} | cut -d ";" -f 2)
												CodeProject=$(echo ${session} | cut -d ";" -f 1)
												TheSrcCode=$(echo ${session} | cut -d ";" -f 3)
												case ${CodeProject} in
													none)
														;;
													*)
														Dir="${CodeProject}"
														;;
												esac
												#Determine Language
												CodeDir=$(ManageLangs "${Lang}" "pgDir")
												if [ ! -z "${CodeDir}" ]; then
													CodeDir=${CodeDir}/${Dir}
													#Go to dir
													if [ -d ${CodeDir} ]; then
														cd ${CodeDir}
													else
														Lang=${SavedLang}
														TheSrcCode=${SavedCode}
														CodeProject=${SavedProject}
														CodeDir=${SavedCodeDir}
													fi
												else
													Lang=${SavedLang}
													TheSrcCode=${SavedCode}
													CodeProject=${SavedProject}
													CodeDir=${SavedCodeDir}
												fi

												if [ ! -z "${UserIn[2]}" ]; then
													echo "Session \"${UserIn[2]}\" is loaded"
												else
													echo "Session loaded"
												fi
												refresh="yes"
												;;
										esac
										;;
								esac
								;;
							*)
								ListSession
								;;
						esac
						;;
					#Close cl[ide]
					exit|close)
						#cd - > /dev/null
						break
						;;
					#ignore all other commands
					*)
						;;
				esac

				#Jump-in and Jump-out
				case ${InAndOut} in
					yes)
						#cd - > /dev/null
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
						if [ -z "${FirstAction}" ]; then
							history -s "${UserIn[@]}"
						else
							FirstAction=""
						fi
						#Refresh CLI User Interface
						case ${refresh} in
							yes)
								#Handle the CLI User Interface
								#{
								#Change Color for Language
								cLang=$(color ${Lang})
								#Handle the CLI User Interface
								if [ -z "${TheSrcCode}" ]; then
									case ${CodeProject} in
										none)
											#Menu with no code
											prompt="${Name}(${cLang}):~$ "
											;;
										*)
											ThePWD=$(pwd)
											#ProjectDir=${ThePWD#*${CodeProject}}
											ProjectDir=${ThePWD##*/}
											#ProjectDir=${ProjectDir/\//:}
											cCodeProject=$(ManageLangs ${Lang} "ProjectColor")
											#ProjectPrompt=$(ColorPrompt ${ProjectType:0:1}:${ProjectDir})
											case ${ProjectDir} in
												${CodeProject})
													#ProjectDir="/"
													ProjectDir=""
													;;
												*)
													;;
											esac
											#ProjectPrompt=$(ColorPrompt ${ProjectDir})
											#Menu with no code
											prompt="${Name}(${cCodeProject}):~/${ProjectDir}$ "
											;;
									esac
								else
									#Change Color for Code
									cCode=$(color ${TheSrcCode})
									case ${TheSrcCode} in
										*,*)
											cntSrc=$(echo -e "${TheSrcCode//,/\\n}" | wc -l)
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
											prompt="${Name}(${cLang}{${listSrc}}):~$ "
											;;
										*)
											ThePWD=${PWD}
											#ProjectDir=${ThePWD#*${CodeProject}}
											ProjectDir=${ThePWD##*/}
											#ProjectDir=${ProjectDir/\//:}
											#Menu with no code
											cCodeProject=$(ManageLangs ${Lang} "ProjectColor")
											#ProjectPrompt=$(ColorPrompt ${ProjectType:0:1}:${ProjectDir})
											case ${ProjectDir} in
												${CodeProject})
													#ProjectDir="/"
													ProjectDir=""
													;;
												*)
													;;
											esac
											prompt="${Name}(${cCodeProject}{${listSrc}}):~/${ProjectDir}$ "
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

			if [ ! -z "${ThePipe}" ]; then
				break
			fi
		done
		#Protect clide from being edited
		Protect "done"
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
	comp_list "banner"
	comp_list "ls"
	comp_list "whoami"
	comp_list "build" "--help"
	comp_list "save"
	comp_list "session" "save load"
	comp_list "lscpl"
	comp_list "using" "--help"
	comp_list "ll"
	comp_list "type" "classified executable runtime --help"
	comp_list "clear" "--help"
	comp_list "debug" "--help"
	comp_list "set select" "--help"
	comp_list "unset" "--help"
	comp_list "rm remove delete rmbin rmsrc" "-f --help"
	comp_list "cd" "--help"
	comp_list "pwd" "--help"
	comp_list "mkdir" "--help"
	comp_list "mode" "add pkg ${repoTool} repo --help"
	comp_list "use" "${pg}"
	comp_list "project" "build delete discover export files import load list link mode new remove swap select src use save title type update --help"
	comp_list "package" "get new set list mv move --help"
	comp_list "gencode" "--all --help --keep --save --lines"
	comp_list "shell" "--help"
	comp_list "time" "--help"
	comp_list "new" "--version -v --help -h --custom -c --show -s"
	comp_list "${editor} ed edit edrst" "non-lang --help --line"
	comp_list "add" "--help"
	comp_list "${ReadBy} read" "non-lang --help"
	comp_list "search" "--help"
	comp_list "create" "args cpl cpl-args make shellCode newCodeTemp reset version type time --help"
	comp_list "compile cpl car car-a" "--args --get-args --type --help"
	comp_list "execute exe run" "-a --args --help"
	comp_list "version" "--help"
	comp_list "help"
	comp_list "notes" "edit add read --help"
	comp_list "last load" "--help"
	comp_list "install" "--help --alias --bin --check --root-bin --user-bin"
	comp_list "bkup backup" "--help --remove --restore"
	comp_list "restore" "--help"
	comp_list "rename" "--help"
	comp_list "copy" "--help"
	comp_list "langs languages" "--help"
	comp_list "exit close"
}

CLI()
{
	local UserArg=$1
	local Option=$2
	local pg
	local prompt
	#No argument given
	if [ ! -z "${UserArg}" ]; then
		case ${UserArg} in
			#Get version from cli
			-v|--version)
				if [ -z "${ThePipe}" ]; then
					ClideVersion
				fi
				;;
			#Get Config
			-c|--config)
				if [ -z "${ThePipe}" ]; then
					grep -v "#" ${root}/etc/clide.conf | sed "s/export //g" | sed "s/=/: /g" | tr -d "\""
				fi
				;;
			#Get compile/interpreter version from cli
			-cv|--code-version)
				if [ -z "${ThePipe}" ]; then
					CodeVersion
				fi
				;;
			#Get compile/interpreter version from cli
			-dv|--debug-version)
				if [ -z "${ThePipe}" ]; then
					DebugVersion
				fi
				;;
			#Get compile/interpreter version from cli
			-sv|--support-version)
				if [ -z "${ThePipe}" ]; then
					CodeSupportVersion
				fi
				;;
			#Get version of template
			-tv|--temp-version)
				if [ -z "${ThePipe}" ]; then
					shift
					CodeTemplateVersion "$@" | grep -v "Template"
				fi
				;;
			#Get version of shell
			-shv|--shell-version)
				if [ -z "${ThePipe}" ]; then
					shift
					ShellCodeVersion "$@"
				fi
				;;
			#Get version control version from cli
			-rv|--repo-version)
				if [ -z "${ThePipe}" ]; then
					RepoVersion
				fi
				;;
			#list supported Langauges
			-ll|--languages|--langs)
				if [ -z "${ThePipe}" ]; then
					ListLangs ${Option}
				fi
				;;
			#List projects from cli
			-p|--project)
				#Protect clide from being edited
				Protect
				shift
				local ActionProject=$1
				local GetProject=$1
				local Code=$2
				if [ ! -z "${ActionProject}" ]; then
					case ${ActionProject} in
						-n|--new)
							if [ -z "${ThePipe}" ]; then
								shift
								local TheLang=$1
								local TheProjectName=$2
								shift
								shift
								TheLang=$(pgLang ${TheLang})
								local Args=( "${@}" )
								if [ ! -z "${TheProjectName}" ]; then
									case ${TheLang} in
										no)
											;;
										*)
											InAndOut="yes"
											Actions ${TheLang} "code" "project" "new" ${TheProjectName} "${Args[@]}"
											;;
									esac
								fi
							fi
							;;
						--discover)
							if [ -z "${ThePipe}" ]; then
								discoverProject
							fi
							;;
						#Link a project with another language
						--link)
							if [ -z "${ThePipe}" ]; then
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
													*)
														;;
												esac
												;;
										esac
									else
										errorCode "project" "link" "cli-link" ${UserArg}

									fi
								else
									theHelp ProjectCliHelp ${UserArg}
								fi
							fi
							;;
						-x|--run|--time|--build|--edit|--files)
							shift
							local CheckSrc
							local Lang=$1

							case ${Lang} in
								--*)
									RunType=$1
									RunType=${RunType#--*}
									shift
									Lang=$1
									;;
								*)
									;;
							esac

							Lang=$(pgLang ${Lang})

							case ${Lang} in
								no)
									Lang=""
									CheckSrc="Please"
									GetProject=$1
									Code=$2
									;;
								*)
									GetProject=$2
									Code=$3
									shift
									;;
							esac


							if [ -z "${GetProject}" ]; then
								if [ -z "${ThePipe}" ]; then
									theHelp BuildCliHelp ${UserArg}
								fi
							else
								case ${GetProject} in
									#Provide the help page
									-h|--help)
										if [ -z "${ThePipe}" ]; then
											theHelp BuildCliHelp ${UserArg}
										fi
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
												TheSrcCode=$(echo ${TheProject} | cut -d ";" -f 2)
											fi

											local CodeDir=$(echo ${TheProject} | cut -d ";" -f 3)
											if [ ! -z "${CodeDir}" ]; then
												CodeProject="${GetProject}"
												if [ -d ${CodeDir} ]; then
													cd ${CodeDir}
													case ${ActionProject} in
														--files)
															local FileType
															local ChosenLang=$1
															local LinkedLangs
															local TheSrcFound
															local RemoveDirs=${CodeDir//\//|}

															ChosenLang=$(pgLang ${ChosenLang})
															case ${ChosenLang} in
																no)
																	;;
																*)
																	LinkedLangs=$(echo ${TheProject} | cut -d ";" -f 5)
																	if [ ! -z "${LinkedLangs}" ]; then
																		case ${ChosenLang} in
																			*"${LinkedLangs},"*)
																				Lang=${ChosenLang}
																				;;
																			*)
																				Lang=""
																				;;
																		esac
																	fi
																	;;
															esac

															case $# in
																#Name "src"
																2)
																	FileType=$2
																	;;
																#Lang Name "src"
																3)
																	FileType=$3
																	;;
																*)
																	;;
															esac

															#Make sure Langauge is not empty
															if [ ! -z "${Lang}" ]; then
																case ${FileType} in
																	src)
																		ManageLangs ${Lang} "getAllProjSrc" | tr '/' '|' | sed "s/${RemoveDirs}//g" | tr '|' '/'
																		;;
																	*)
																		find ${CodeDir} -print | tr '/' '|' | sed "s/${RemoveDirs}//g" | tr '|' '/'
																		;;
																esac
															fi
															;;
														--time)
															TimeRun="time"
															shift
															local ArgFlag=$1
															local CodeRunArgs=( "${@}" )
															if [ ! -z "${ArgFlag}" ]; then
																runCode ${Lang} "none" "none" "none" "${CodeRunArgs[@]}"
															else
																runCode ${Lang} "none"
															fi
															;;
														--edit)
															local LinkedLangs
															local TheSrcFound
															if [ ! -z "${CheckSrc}" ]; then
																LinkedLangs=$(echo ${TheProject} | cut -d ";" -f 5)
																if [ ! -z "${LinkedLangs}" ]; then
																	for Link in ${LinkedLangs//,/ };
																	do
																		TheSrcFound=$(selectCode ${Link} ${Code})
																		if [ ! -z "${TheSrcFound}" ]; then
																			Lang=${Link}
																			TheSrcCode=${TheSrcFound}
																			break
																		fi
																	done
																else
																	TheSrcCode=$(selectCode ${Lang} ${Code})
																fi
															else
																TheSrcCode=$(selectCode ${Lang} ${Code})
															fi
															if [ ! -z "${TheSrcCode}" ]; then
																ManageLangs ${Lang} "editCode"
															else
																errorCode "selectCode" "not-found" "${Code}"
															fi
															;;
														-x|--run)
															InAndOut="yes"
															shift
															local ArgFlag=$1
															local CodeRunArgs=( "${@}" )
															if [ ! -z "${ArgFlag}" ]; then
																runCode ${Lang} "none" "none" "none" "${CodeRunArgs[@]}"
															else
																runCode ${Lang} "none"
															fi
															;;
														--build)
															if [ -z "${ThePipe}" ]; then
																#Determine action based on language
																case ${Lang} in
																	Java)
																		if [ -z "${TheSrcCode}" ]; then
																			ManageLangs ${Lang} "compileCode"
																		else
																			TypeOfCpl="--jar"
																			ManageLangs ${Lang} "compileCode"
																		fi
																		;;
																	C|C++)
																		ManageLangs ${Lang} "compileCode"
																		#Keep this for future features
																		#{

																		##Get Make file
																		#local TheMakeFile=$(ManageLangs ${Lang} "getMakeFile" ${GetProject})
																		##Compile with makefile
																		#if [ ! -z "${TheMakeFile}" ] || [ ! -z "${TheSrcCode}" ]; then
																		#	ManageLangs ${Lang} "compileCode"
																		#	#Compile with selected code
																		#	ManageLangs ${Lang} "compileCode"
																		#else
																		#	errorCode "cli-cpl" "none" "project" "Please provide source code or create a make file"
																		#fi

																		#}
																		;;
																	Rust)
																		if [ -z "${TheSrcCode}" ]; then
																			ManageLangs ${Lang} "compileCode"
																		else
																			TypeOfCpl="--release"
																			ManageLangs ${Lang} "compileCode"
																		fi
																		;;
																	*)
																		if [ ! -z "${TheSrcCode}" ]; then
																			ManageLangs ${Lang} "compileCode"
																		else
																			errorCode "cli-cpl" "none"
																		fi
																		;;
																esac
															fi
															;;
														*)
															;;
													esac
													cd - > /dev/null
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
							if [ -z "${ThePipe}" ]; then
								shift
								local TheProjectName=$1
								if [ ! -z "${TheProjectName}" ]; then
									exportProject ${TheProjectName}
								fi
							fi
							;;
						-i|--import)
							if [ -z "${ThePipe}" ]; then
								shift
								local TheLang=$1
								local TheProjectName=$2
								if [ ! -z "${TheLang}" ] && [ ! -z "${TheProjectName}" ]; then
									importProject ${TheLang} ${TheProjectName}
								elif [ ! -z "${TheLang}" ] && [ -z "${TheProjectName}" ]; then
									importProject "none" ${TheLang}
								fi
							fi
							;;
						-r|--remove|-d|--delete)
							if [ -z "${ThePipe}" ]; then
								shift
								local TheProjectName=$1
								if [ ! -z "${TheProjectName}" ]; then
									case ${TheProjectName} in
										all)
											case ${GetProject} in
												#remove project ONLY from record
												-r|--remove)
													rm ${ActiveProjectDir}/*.clide 2> /dev/null
													echo "ALL projects removed from record"
													;;
												#remove project files AND record
												-d|--delete)
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
													-r|--remove)
														rm ${ActiveProjectDir}/${TheProjectName}.clide 2> /dev/null
														echo "The project \"${TheProjectName}\" removed from record"
														;;
													#remove project files AND record
													-d|--delete)
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
							fi
							;;
						--info)
							if [ -z "${ThePipe}" ]; then
								GetProject=$2
								listProjects --info ${GetProject}
							fi
							;;
						--list|--lscpl|--make)
							if [ -z "${ThePipe}" ]; then
								shift
								local Lang
								local Code
								local CodeDir
								local TheProject
								local RemoveDirs
								GetProject=$1
								#Just list the projects
								if [ -z "${GetProject}" ]; then
									listProjects
								#list the entire project
								else
									case ${ActionProject} in
										--make)
											local MakeAction=$2
											TheProject=$(loadProject ${GetProject})
											if [ "${TheProject}" != "no" ]; then
												Lang=$(echo ${TheProject} | cut -d ";" -f 1)
												TheSrcCode=$(echo ${TheProject} | cut -d ";" -f 2)
												Lang=$(pgLang ${Lang})
												CodeDir=$(echo ${TheProject} | cut -d ";" -f 3)
												if [ ! -z "${CodeDir}" ]; then
													CodeProject=${GetProject}
													case ${Lang} in
														C|C++)
															#Make Actions
															case ${MakeAction} in
																--delete|delete)
																	ManageLangs ${Lang} "delete-make"
																	;;
																--disable|disable)
																	ManageLangs ${Lang} "disable-make"
																	;;
																--enable|enable)
																	ManageLangs ${Lang} "enable-make"
																	;;
																--create|create)
																	ManageLangs ${Lang} "create-make"
																	;;
																--edit|edit)
																	ManageLangs ${Lang} "edit-make"
																	;;
																*|--help|help)
																	theHelp makeCliHelp ${Lang}
																	;;
															esac
															;;
														*)
															errorCode "ERROR"
															errorCode "ERROR" "The Language for \"${GetProject}\" must be C or C++"
															;;
													esac
												else
													errorCode "cli-cpl" "none"
												fi
											else
												errorCode "project" "not-valid" "${GetProject}"
											fi
											;;
										--lscpl)
											TheProject=$(loadProject ${GetProject})
											if [ "${TheProject}" != "no" ]; then
												Lang=$(echo ${TheProject} | cut -d ";" -f 1)
												Lang=$(pgLang ${Lang})
												CodeDir=$(echo ${TheProject} | cut -d ";" -f 3)
												if [ ! -z "${CodeDir}" ]; then
													CodeProject=${GetProject}
													#list compiled code using Lang.<language>
													ManageLangs ${Lang} "lscpl"
												else
													errorCode "cli-cpl" "none"
												fi
											else
												errorCode "project" "not-valid" "${GetProject}"
											fi
											;;
										--list)
											case ${GetProject} in
												-i|--info)
													GetProject=$2
													listProjects --info ${GetProject}
													;;
												*)
													TheProject=$(loadProject ${GetProject})
													if [ "${TheProject}" != "no" ]; then
														Lang=$(echo ${TheProject} | cut -d ";" -f 1)
														Lang=$(pgLang ${Lang})
														CodeDir=$(echo ${TheProject} | cut -d ";" -f 3)
														if [ ! -z "${CodeDir}" ]; then
															RemoveDirs=${CodeDir//\//|}
															find -L ${CodeDir} -print | tr '/' '|' | sed "s/${RemoveDirs}//g" | tr '|' '/'
														else
															errorCode "cli-cpl" "none"
														fi
													else
														errorCode "project" "not-valid" "${GetProject}"
													fi
													;;
											esac
											;;
										*)
											;;
									esac
								fi
							fi
							;;
						--langs)
							if [ -z "${ThePipe}" ]; then
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
							fi
							;;
						--read|--read-num)
							if [ -z "${ThePipe}" ]; then
								shift
								local Lang
								local CodeDir
								local TheProject
								local RemoveDirs
								GetProject=$1
								local TheSrc=$2
								#Just list the projects
								if [ ! -z "${GetProject}" ]; then
									TheProject=$(loadProject ${GetProject})
									if [ "${TheProject}" != "no" ]; then
										Lang=$(echo ${TheProject} | cut -d ";" -f 1)
										Lang=$(pgLang ${Lang})
										CodeDir=$(echo ${TheProject} | cut -d ";" -f 3)
										if [ ! -z "${CodeDir}" ]; then
											if [ ! -z "${TheSrc}" ]; then
												TheSrc=$(find ${CodeDir} -name ${TheSrc})
												if [ ! -z "${TheSrc}" ]; then
													case ${ActionProject} in
														--read-num)
															cat -n "${TheSrc}"
															;;
														*)
															cat "${TheSrc}"
															;;
													esac
												fi
											else
												CLI --project --list ${GetProject} | grep "\."
											fi
										fi
									fi
								fi
							fi
							;;
						-h|--help)
							if [ -z "${ThePipe}" ]; then
								theHelp ProjectCliHelp ${UserArg}
							fi
							;;
						*)
							if [ -z "${ThePipe}" ]; then
								shift
								local TheProjectDir
								local ChosenLang=$1
								local SaveProject=$1
								local ModeAction
								local ModeType
								local TheSrc
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
														if [ -z "${passcCode}" ]; then
															passcCode="none"
														fi
														#Swap cl[ide] to a given mode
														ModeHandler ${ModeType} ${Lang} ${cLang} ${passcCode} "${@}"
													fi
													;;
												-*|--*)
													shift
													case ${ModeAction} in
														#Swap arguments from "--<arg> <project> <arg>" to "<project> --<arg> <args>"
														--edit|--files|--link)
															local CheckForLang=$1
															if [ ! -z "${CheckForLang}" ]; then
																CheckForLang=$(pgLang ${CheckForLang})
																case ${CheckForLang} in
																	no)
																		CheckForLang=""
																		;;
																	*)
																		shift
																		;;
																esac
															fi
															CLI --project ${ModeAction} ${CheckForLang} ${GetProject} "${@}"
															;;
														*)
															CLI --project ${ModeAction} ${GetProject} "${@}"
															;;
													esac
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
							fi
							;;
					esac
				else
					theHelp ProjectCliHelp ${UserArg}
				fi
				#Done protecting
				Protect "done"
				;;
			#Get cli help page
			-h|--help)
				if [ -z "${ThePipe}" ]; then
					theHelp CliHelp ${UserArg} $2 $3
				fi
				;;
			#Get the type of language
			--type)
				if [ -z "${ThePipe}" ]; then
					shift
					local TheLang
					local text
					local ColorCode
					local Lang=$1
					local TypeInfo=$2
					case ${Lang} in
						all)
							for TheLang in ${LangsDir}/Lang.*;
							do
								#Select the next langauge
								TheLang=${TheLang##*/}
								Lang=${TheLang#Lang.*}
								text=$(pgLang ${Lang})
								if [ ! -z "${text}" ]; then
									case ${text} in
										no)
											#do nothing
											;;
										*)
											#get langauge color
											ColorCode=$(ManageLangs ${Lang} "color-number")
											#Display language and code
											if [ -z "${TypeInfo}" ]; then
												echo -e "\e[1;3${ColorCode}m{${Lang}}"
												echo "{"
												CLI ${UserArg} ${Lang}
												echo "}"
												echo -e "\e[0m"
											else
												TypeInfo=${TypeInfo,,}
												case ${TypeInfo} in
													classified|executable|runtime)
														echo -en "\e[1;3${ColorCode}m${Lang}: "
														CLI ${UserArg} ${Lang} ${TypeInfo}
														echo -en "\e[0m"
														;;
													*)
														theHelp TypeCliHelp ${UserArg}
														break
														;;
												esac
											fi
											;;
									esac
								fi
							done
							;;
						*)
							Lang=$(pgLang ${Lang})
							if [ ! -z "${Lang}" ]; then
								case ${Lang} in
									no)
										theHelp TypeCliHelp ${UserArg}
										;;
									*)
										InAndOut="yes"
										Actions ${Lang} "none" "type" "${TypeInfo}"
										;;
								esac
							else
								theHelp TypeCliHelp ${UserArg}
							fi
							;;
					esac
				fi
				;;
			#Remove Src Or Bin
			--rm|--rm-bin|--rm-src)
				if [ -z "${ThePipe}" ]; then
					shift
					local Lang=$1
					local LangSrc=$2
					if [ ! -z "${Lang}" ]; then
						Lang=$(pgLang ${Lang})
						case ${Lang} in
							no)
								LangSrc=$1
								Lang=$(SelectLangByCode ${LangSrc})
								case ${Lang} in
									no)
										Lang=""
										LangSrc=""
										;;
									*)
										;;
								esac
								;;
							*)
								;;
						esac
						if [ ! -z "${Lang}" ]; then
							case ${UserArg} in
								--rm)
									CLI --rm-bin "${@}"
									CLI --rm-src "${@}"
									;;
								--rm-bin)
									#Get the binary path
									TheFile=$(ManageLangs ${Lang} "rmBin" ${LangSrc})
									if [ ! -z "${TheFile}" ]; then
										#remove file
										rm ${TheFile}
										TheFile=${TheFile##*/}
										echo "Binary \"${TheFile}\" Removed"
									fi
									;;
								--rm-src)
									#Get the source code path
									TheFile=$(ManageLangs ${Lang} "rmSrc" ${LangSrc})
									if [ ! -z "${TheFile}" ]; then
										rm ${TheFile}
										TheFile=${TheFile##*/}
										echo "Source \"${TheFile}\" Removed"
									fi
									;;
								*)
									;;
							esac
						fi
					fi
				fi
				;;
			#Load last saved session
			-l|--load|--last|--session)
				if [ -z "${ThePipe}" ]; then
					shift
					local Name=$1
					if [ ! -z "${Name}" ]; then
						case ${Name} in
							--list)
								ListSession
								;;
							*)
								session=$(LoadSession ${Name})
								case ${session} in
									*"ERROR"*"No Session to load"*)
										echo ${session}
										;;
									*)
										Lang=$(echo ${session} | cut -d ";" -f 2)
										Code=$(echo ${session} | cut -d ";" -f 3)
										CodeProject=$(echo ${session} | cut -d ";" -f 1)
										if [ ! -z "${Name}" ]; then
											echo "Session \"${Name}\" is loaded"
										else
											echo "Session loaded"
										fi
										#Start IDE
										Actions ${Lang} ${Code} ${CodeProject}
										;;
								esac
								;;
						esac
					else
						ListSession
					fi
				fi
				;;
			#Search for source code path OR langauge and source code name
			--find|--find-src|--find-bin|--path|--path-src|--path-bin)
				if [ -z "${ThePipe}" ]; then
					shift
					local Lang=$1
					local TheSrc=$2
					local TheBin=$2
					local CodeDir
					local srcPath
					local isCompiled
					local src
					local Found
					local ColorCode
					local TypeOfCode
					#Language not provided...but source code is
					if [ -z "${TheSrc}" ]; then
						TheSrc=${Lang}
						Lang=""
					#Langauge and source code provided
					else
						#adjust letter
						Lang=${Lang,,}
						Lang=${Lang^}
						CodeDir=$(pgDir ${Lang})
						if [ ! -z "${CodeDir}" ]; then
							cd ${CodeDir}
							TheSrc=$(selectCode ${Lang} ${TheSrc})
							cd - > /dev/null
						fi
					fi

					#incorrect characters given in source code
					case ${TheSrc} in
						*/*)
							#reset search
							TheSrc=""
							;;
						*)
							;;
					esac
					#source code provided
					if [ ! -z "${TheSrc}" ]; then
						#Language not provided
						if [ -z "${Lang}" ]; then
							case ${TheSrc} in
								.*)
									;;
								*.*)
									#Attempt to locate language using source code
									Lang=$(SelectLangByCode ${TheSrc})
									;;
								*)
									;;
							esac
						fi
						#Langauge provided or found
						if [ ! -z "${Lang}" ]; then
							if [ ! -z "${TheSrc}" ]; then
								case ${UserArg} in
									--find|--find-src|--path|--path-src)
										find -L ${ProgDir} -name ${TheSrc} 2> /dev/null | grep "${Lang}/*/src/"
										;;
									--find-bin|--path-bin)
										TheBin=$(ManageLangs ${Lang} "getBin" "${TheSrc}")
										find -L ${ProgDir} -name ${TheBin} 2> /dev/null | grep "${Lang}/*/bin/"
										;;
									*)
										;;
								esac
							else
								theHelp PathCliHelp ${UserArg}
							fi
						#No Language found
						else
							#remove extension
							#Search for source code via name
							Found=$(find -L ${ProgDir} -name *${TheSrc}* | grep "/src/" | sort)
							#Code has been founs
							if [ ! -z "${Found}" ]; then
								echo -e "\e[1;40m{Language}\t\t{Source Code}\t\t{Compiled}\t\t{Project}\e[0m"
								for src in ${Found};
								do
									srcPath=${src}
									src=${src##*/}
									#Get language by source code
									Lang=$(SelectLangByCode ${src})
									if [ ! -z "${Lang}" ]; then
										isCompiled=$(ManageLangs ${Lang} "getBin" "${src}")
										case ${srcPath} in
											*/${Lang}/projects/*)
												srcPath=$(echo ${srcPath} | sed "s/\/${Lang}\/projects\//|/g" | cut -d '|' -f 2)
												TypeOfCode="${srcPath%%/*}"
												;;
											*)
												TypeOfCode=""
												;;
										esac
										#get langauge color
										ColorCode=$(ManageLangs ${Lang} "color-number")
										#Display language and code
										if [ ! -z "${isCompiled}" ]; then
											echo -e "\e[1;3${ColorCode}m${Lang}\t\t\t${src}\t\t${isCompiled}\t\t${TypeOfCode}\e[0m"
										else
											echo -e "\e[1;3${ColorCode}m${Lang}\t\t\t${src}\t\t\t\t\t${TypeOfCode}\e[0m"
										fi
									fi
								done
							fi
						fi
					else
						theHelp PathCliHelp ${UserArg}
					fi
				fi
				;;
			#clide --new <args>
			#or
			#clide -n <args>
			-n|--new)
				if [ -z "${ThePipe}" ]; then
					shift
					local NoSupportLang
					local Lang
					local Code=$2
					local Args
					local FindCode
					local AlreadyCode
					local ColorCode
					local BeforeFiles
					local AfterFiles
					local AllFiles
					local NewCode

					#clide --new <src>.<ext>
					#or
					#clide --new --help
					#or
					#clide --new <lang>
					if [ -z "${Code}" ]; then
						#Identify the language by code
						Lang=$(SelectLangByCode $1)
						#Langauge has been found
						if [ ! -z "${Lang}" ]; then
							Code=$1
							shift
							local Args=( "${@}" )
							case ${Code} in
								-h|--help)
									#theHelp InstallCliHelp
									;;
								*)
									if [ ! -z "${Code}" ]; then
										main --new "${Lang}" "${Code}" "${Args[@]}"
									fi
									;;
							esac
						#clide --new <lang>
						else
							Lang=$1
							case ${Lang} in
								#clide --new <lang> --help
								-h|--help)
									main --help function --new
									;;
								#clide --new <lang>
								*)
									#assume the user wants to create a custom tempalte
									main --new "${Lang}" "-c"
									;;
							esac
						fi
					#clide --new <lang> <src>.<ext> <args>
					else
						case ${Code} in
							#clide --new <lang> --help
							-h|--help)
								NoSupportLang=$1
								Lang=$1
								;;
							#clide --new <lang> --custom <args>
							--custom)
								NoSupportLang=$1
								#check if language is supported
								Lang=$(pgLang $1)
								shift
								shift
								Args=( "${@}" )
								;;
							#clide --new <lang> <src> --<other>
							--*)
								NoSupportLang=$1
								Lang=$(pgLang $1)
								case ${Lang} in
									no)
										#clide --new <src> --<other>
										Lang=$(SelectLangByCode $1)
										;;
									*)
										shift
										;;
								esac
								Code=$1
								shift
								Args=( "${@}" )
								;;
							#clide --new <lang> <code> <flag> <args>
							*)
								NoSupportLang=$1
								#check if language is supported
								Lang=$(pgLang $1)
								shift
								shift
								Args=( "${@}" )
								;;
						esac
						if [ ! -z "${Lang}" ]; then
							case ${Lang} in
								no)
									errorCode "install" "cli-not-supported" "${NoSupportLang}"
									;;
								*)
									local CodeDir=$(pgDir ${Lang})
									if [ ! -z "${CodeDir}" ]; then
										ColorCode=$(ManageLangs ${Lang} "color-number")
										cd ${CodeDir}
										InAndOut="yes"
										case ${Code} in
											#clide --new <lang> --help
											#or
											#clide --new <lang> -h
											-h|--help)
												main --help function --new
												;;
											#clide --new <lang> --custom <args>
											#or
											#clide --new <lang> -c <args>
											-c|--custom)
												#Get list of files  BEFORE creation
												BeforeFiles=$(ManageLangs ${Lang} "BeforeFiles")
												#Create new code
												Actions ${Lang} "code" "new" "-c" "${Args[@]}"
												#Get list of files  AFTER creation
												AfterFiles=$(ManageLangs ${Lang} "AfterFiles")
												#Combine BEFORE and AFTER
												AllFiles="${BeforeFiles} ${AfterFiles}"
												#Look ALL files for new for new file
												NewCode=$(echo -e "${AllFiles// /\\n}" | sort | uniq -u | tr -d '\n')
												#Check if new code is found
												if [ ! -z "${NewCode}" ]; then
													echo -e "\e[1;4${ColorCode}m[${Lang} (${NewCode}) Created]\e[0m"
												fi
												;;
											*)
												#clide --new <lang> <src>
												#or
												#clide --new <lang> <src>,<src>
												IFS=',' read -ra ADDR <<< "${Code}"
												for NewCode in "${ADDR[@]}";
												do
													AlreadyCode=$(ManageLangs ${Lang} "getCode" ${NewCode})
													if [ -z "${AlreadyCode}" ]; then
														Actions ${Lang} "code" "new" ${NewCode} "${Args[@]}"
														FindCode=$(ManageLangs ${Lang} "getCode" ${NewCode} ${AlreadyCode})
														if [ ! -z "${FindCode}" ]; then
															echo -e "\e[1;4${ColorCode}m[${Lang} (${FindCode}) Created]\e[0m"
														fi
													else
														local SecondTry=$(ManageLangs ${Lang} "getCode" ${NewCode} ${AlreadyCode})
														if [ -z "${SecondTry}" ]; then
															Actions ${Lang} "code" "new" ${NewCode} "${Args[@]}"
															FindCode=$(ManageLangs ${Lang} "getCode" ${NewCode} ${AlreadyCode})
															if [ ! -z "${FindCode}" ]; then
																echo -e "\e[1;4${ColorCode}m[${Lang} (${FindCode}) Created]\e[0m"
															fi
														fi
													fi
												done
												;;
										esac
#									else
#										errorCode "cli-cpl" "none"
									fi
							esac
						else
								errorCode "install" "cli-not-supported" "${NoSupportLang}"
						fi
					fi
				fi
				;;
			#clide --edit <args>
			--edit)
				if [ -z "${ThePipe}" ]; then
					#Protecting
					Protect
					shift
					local Action=$1
					local Lang=$2
					local Code
					local EditLine
					local confirm=$3
					case ${Action} in
						#clide --edit --config <arg>
						--config)
							if [ -z "${confirm}" ]; then
								confirm=${Lang}
							fi
							case ${confirm,,} in
								y|yes|-y|--yes)
									${editor} ${root}/etc/clide.conf
									clear
									errorCode "WARNING" "Please restart ${Head} for changes to take affect"
									errorCode "WARNING" "May God have mercy on your ${Head}"
									echo ""
									;;
								*)
									local YourAnswer
									errorCode "WARNING"
									errorCode "WARNING" "Editing this file incorrectly could render ${Head} unusable"
									echo ""
									errorCode "WARNING" "Do you wish to continue (y/n)"
									echo -n "> "
									read YourAnswer
									YourAnswer=${YourAnswer,,}
									case ${YourAnswer} in
										y|yes|-y|--yes)
											CLI ${UserArg} ${Action} "--yes"
											;;
										*)
											;;
									esac
									;;
							esac
							;;
						#clide --edit --lang <lang> <args>
						--lang)
							if [ ! -z "${Lang}" ]; then
								Lang=${Lang,,}
								Lang=${Lang^}
								local TheLang=${LangsDir}/Lang.${Lang}

								if [ -f "${TheLang}" ]; then
									case ${confirm,,} in
										y|yes|-y|--yes)
											${editor} ${TheLang}
											clear
											errorCode "WARNING" "May God have mercy on your ${Head}"
											echo ""
											;;
										*)
											local YourAnswer
											errorCode "WARNING"
											errorCode "WARNING" "Editing this file incorrectly could render ${Lang} unusable"
											echo ""
											errorCode "WARNING" "Do you wish to continue (y/n)"
											echo -n "> "
											read YourAnswer
											YourAnswer=${YourAnswer,,}
											case ${YourAnswer} in
												y|yes|-y|--yes)
													CLI ${UserArg} ${Action} ${Lang} "--yes"
													;;
												*)
													;;
											esac
											;;
									esac
								else
									errorCode "ERROR"
									errorCode "ERROR" "\"${Lang}\" is not a supported language"
								fi
							else
								theHelp EditCliHelp
							fi
							;;
						#clide --edit --line <lang> <src> <line>
						--line)
							EditLine="$2"
							Lang=$(pgLang "$3")
							Code="$4"
							EditLineNum=$(echo ${EditLineNum} | sed "s/[^0-9]//g")
							if [ -z "${EditLine}" ]; then
								EditLine="$2"
								Lang=$(SelectLangByCode $3)
								Code=$3
								EditLineNum=$(echo ${EditLineNum} | sed "s/[^0-9]//g")
								shift
								if [ ! -z "${EditLine}" ]; then
									main --edit "${Action}" "${Lang}" "${Code}" "${EditLine}"
								fi
							else
								case ${Lang} in
									no)
										errorCode "lang" "cli-not-supported" "$1"
										;;
									*)
										local CodeDir=$(pgDir ${Lang})
										if [ ! -z "${CodeDir}" ] && [ ! -z "${EditLine}" ]; then
											cd ${CodeDir}
											TheSrcCode=$(selectCode ${Lang} ${Code})
											if [ ! -z "${TheSrcCode}" ]; then
												ManageLangs ${Lang} "editCode" "${Action}" "${EditLine}"
											else
												errorCode "cli-cpl" "none"
											fi
										else
											errorCode "cli-cpl" "none"
									fi
									;;
								esac
							fi
							;;
						#clide --edit <lang> <src>
						*)
							if [ -z "${Action}" ]; then
								theHelp EditCliHelp
							else
								case ${Action} in
									#clide --edit --help
									-h|--help)
										theHelp EditCliHelp
										;;
									*)
										Lang=$(pgLang $1)
										Code=$2
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
														TheSrcCode=$(selectCode ${Lang} ${Code})
														ManageLangs ${Lang} "editCode"
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
					#Done protecting
					Protect "done"
				fi
				;;
			--cp|--copy|--rename)
				if [ -z "${ThePipe}" ]; then
					#Protecting
					Protect
					shift
					local DoAction
					local NotLang
					local Lang
					local TheSrc
					local TheNew

					case $# in
						2)
							Lang=$(SelectLangByCode $1)
							TheSrc=$1
							TheNew=$2
							if [ ! -z "${Lang}" ]; then
								CodeDir=$(pgDir ${Lang})
								if [ ! -z "${CodeDir}" ]; then
									cd ${CodeDir}
									TheSrcCode=$(selectCode ${Lang} ${TheSrc})
									cd - > /dev/null
								fi
								DoAction="do"
							else
								DoAction="dont"
							fi
							;;
						3)
							NotLang=$1
							Lang=$(pgLang $1)
							TheSrc=$2
							TheNew=$3
							case ${Lang} in
								no)
									DoAction="dont"
									;;
								*)
									CodeDir=$(pgDir ${Lang})
									if [ ! -z "${CodeDir}" ]; then
										cd ${CodeDir}
										TheSrcCode=$(selectCode ${Lang} ${TheSrc})
										cd - > /dev/null
										DoAction="do"
									else
										DoAction="dont"
									fi
									;;
							esac
							;;
						*)
							DoAction="dont"
							;;
					esac

					case ${DoAction} in
						do)
							case ${UserArg} in
								--cp|--copy)
									CopyOrRename ${Lang} "cp" ${TheNew}
									;;
								--rename)
									CopyOrRename ${Lang} "rename" ${TheNew}
									;;
								*)
									;;
							esac
							;;
						*)
							theHelp CliCopyOrRename ${UserArg}
							;;
					esac

					#Done protecting
					Protect "done"
				fi
				;;
			--cpl-run|--car|--cat|--cpl-time)
				if [ -z "${ThePipe}" ]; then
					local RunLang
					local TheSrcCplAndRun
					local Item=0
					local ThisTime
					local TheOldPWD="${PWD}"
					shift
					local cplArg=$1

					case ${cplArg} in
						--args)
							cplArg=""
							shift
							;;
						-*)
							shift
							;;
						*)
							cplArg=""
							;;
					esac

					local CplArgs=( )
					local RunArgs=( )
					for ThisTime in ${@};
					do
						if [ ! -z "${TheSrcCplAndRun}" ]; then
							break
						fi

						if [ ! -z "${RunLang}" ]; then
							TheSrcCplAndRun=${ThisTime}
							shift
							break
						fi

						if [ ! -z "${ThisTime}" ]; then
							case ${ThisTime} in
								-*)
									CplArgs+=(${ThisTime})
									shift
									;;
								*)
									RunLang=$(pgLang ${ThisTime})
									case ${RunLang} in
										no)
											RunLang=$(SelectLangByCode ${ThisTime})
											if [ ! -z "${RunLang}" ]; then
												TheSrcCplAndRun="${ThisTime}"
											else
												CplArgs+=(${ThisTime})
											fi
											;;
										${ThisTime})
											;;
										*)
											;;
									esac
									shift
									;;
							esac
						fi
					done
					RunArgs=( "${@}" )

					CLI --cpl ${cplArg} ${RunLang} ${TheSrcCplAndRun} "${CplArgs[@]}"
					cd "${TheOldPWD}"
					case ${UserArg} in
						--cat|--cpl-time)
							CLI --time ${RunLang} ${TheSrcCplAndRun} "${RunArgs[@]}"
							;;
						*)
							CLI --run ${RunLang} ${TheSrcCplAndRun} "${RunArgs[@]}"
							;;
					esac
				fi
				;;
			--car-ct|--edit-ct|--run-ct|--read-ct)
				if [ -z "${ThePipe}" ]; then
					shift
					local Lang=$1
					local TheTempCode
					if [ ! -z "${Lang}" ]; then
						Lang=$(pgLang $1)
						case ${Lang} in
							no)
								;;
							*)
								TheTempCode=$(ManageLangs ${Lang} "getNewCode")
								case ${UserArg} in
									--run-ct)
										CLI --run ${Lang} ${TheTempCode} "${@}"
										;;
									--edit-ct)
										CLI --edit ${Lang} ${TheTempCode}
										;;
									--read-ct)
										CLI --read ${Lang} ${TheTempCode}
										;;
									--car-ct)
										CLI --cpl-ct ${Lang}
										CLI --run-ct ${Lang} "${@}"
										;;
									*)
										;;
								esac
								;;
						esac
					fi
				fi
				;;
			#Compile the code templates of a given language
			--compile-code-temp|--cpl-ct)
				if [ -z "${ThePipe}" ]; then
					shift
					local Lang=$1
					local TheTempCode
					if [ ! -z "${Lang}" ]; then
						case ${Lang,,} in
							all)
								CompileAllCode Template
								Lang="no"
								;;
							*)
								Lang=$(pgLang $1)
								;;
						esac

						case ${Lang} in
							no)
								;;
							*)
								TheTempCode=$(ManageLangs ${Lang} "getNewCode")
								case ${Lang} in
									Java)
										CLI --cpl --jar ${Lang} ${TheTempCode}
										;;
									*)
										CLI --cpl ${Lang} ${TheTempCode}
										;;
								esac
								;;
						esac
					fi
				fi
				;;
			--edit-shell|--edit-sh)
				if [ -z "${ThePipe}" ]; then
					shift
					local Lang=$1
					local TheTempCode
					if [ ! -z "${Lang}" ]; then
						Lang=$(pgLang $1)
						case ${Lang} in
							no)
								;;
							*)
								CLI --edit ${Lang} "shell"
								;;
						esac
					fi
				fi
				;;
			--cpl-shell|--cpl-sh)
				if [ -z "${ThePipe}" ]; then
					shift
					local Lang=$1
					local TheTempCode
					if [ ! -z "${Lang}" ]; then
						case ${Lang,,} in
							all)
								CompileAllCode Shell
								Lang="no"
								;;
							*)
								Lang=$(pgLang $1)
								;;
						esac

						case ${Lang} in
							no)
								;;
							*)
								case ${Lang} in
									Java)
										CLI --cpl --jar ${Lang} "shell"
										;;
									*)
										CLI --cpl ${Lang} "shell"
										;;
								esac
								;;
						esac
					fi
				fi
				;;
			--gencode)
				if [ -z "${ThePipe}" ]; then
					shift
					local Lang
					local Code=$2
					#clide --gencode <code>.<ext>
					if [ -z "${Code}" ]; then
						Lang=$(SelectLangByCode $1)
						if [ ! -z "${Lang}" ]; then
							Code=$1
							case ${Code} in
								-h|--help)
									theHelp cplCliHelp
									;;
								*)
									if [ ! -z "${Code}" ]; then
										main --gencode "${Lang}" "${Code}"
									fi
									;;
							esac
						else
							theHelp cplCliHelp
						fi
					# $ clide --gencode <lang> <code> or $ clide --gencode <lang>
					else
						case ${Code} in
							#clide --gencode <code>
							-*)
								Lang=$(SelectLangByCode $1)
								Code=$1
								;;
							# $ clide --gencode <lang> <code> or $ clide --gencode <code>
							*)
								Lang=$(pgLang $1)
								;;
						esac

						case ${Lang} in
							no)
								errorCode "lang" "cli-not-supported" "$1"
								;;
							*)
								local CodeDir=$(pgDir ${Lang})
								if [ ! -z "${CodeDir}" ] && [ -d "${CodeDir}" ]; then
									cd ${CodeDir}
									TheSrcCode=$(selectCode ${Lang} ${Code})
									if [ ! -z "${Code}" ]; then
										InAndOut="yes"
										Actions ${Lang} ${Code} "gencode"
									else
										errorCode "cli-gencode" "none"
									fi
								else
									errorCode "cli-gencode" "none"
								fi
								;;
						esac
					fi
				fi
				;;
			#compile code without entering cl[ide]
			#clide --cpl <lang> <code> <args>
			--cpl|--compile)
				if [ -z "${ThePipe}" ]; then
					local NewCplType
					shift
					local Lang
					local Code=$2
					local Args

					#clide --cpl <code>.<ext>
					if [ -z "${Code}" ]; then
						Lang=$(SelectLangByCode $1)
						if [ ! -z "${Lang}" ]; then
							Code=$1
							shift
							Args=( "${@}" )
							case ${Code} in
								-h|--help)
									theHelp cplCliHelp
									;;
								*)
									if [ ! -z "${Code}" ]; then
										main --cpl "${Lang}" "${Code}" "${Args[@]}"
									fi
									;;
							esac
						else
							theHelp cplCliHelp
						fi
					# $ clide --cpl <lang> <code> or $ clide --cpl <lang>
					else
						case ${1} in
							# $ clide --cpl --<cplType> <lang> <code> or $ clide --cpl --<cplType> <code>
							--)
								shift
								main --cpl "${@}"
								;;
							--*)
								case $1 in
									--args)
										;;
									*)
										TypeOfCpl=$1
										;;
								esac
								shift
								main --cpl "${@}"
								;;
							*)
								case ${Code} in
									#clide --cpl <code> --args <args>
									-*)
										Lang=$(SelectLangByCode $1)
										Code=$1
										shift
										Args=( "${@}" )
										;;
									# $ clide --cpl <lang> <code> <args> or $ clide --cpl <code> <args>
									*)
										Lang=$(pgLang $1)
										shift
										shift
										Args=( "${@}" )
										;;
								esac

								case ${Lang} in
									no)
										errorCode "lang" "cli-not-supported" "$1"
										;;
									*)
										local CodeDir=$(pgDir ${Lang})
										if [ ! -z "${CodeDir}" ] && [ -d "${CodeDir}" ]; then
											cd ${CodeDir}
											TheSrcCode=$(selectCode ${Lang} ${Code})
											if [ ! -z "${Code}" ]; then
												if [ ! -z "${TypeOfCpl}" ]; then
													NewCplType=$(ManageLangs ${Lang} "compileType" ${TypeOfCpl})
													if [ ! -z "${NewCplType}" ]; then
														TypeOfCpl="${NewCplType}"
													fi
												fi
												InAndOut="yes"
												if [ ! -z "${Args[0]}" ]; then
													case ${Args[0]} in
														--args*)
															Actions ${Lang} ${Code} "cpl" "${Args[@]}"
															;;
														*)
															Actions ${Lang} ${Code} "cpl" --args "${Args[@]}"
															;;
													esac
												else
													Actions ${Lang} ${Code} "cpl"
												fi
											else
												errorCode "cli-cpl" "none"
											fi
										else
											errorCode "cli-cpl" "none"
										fi
										;;
								esac
								;;
						esac
					fi
				fi
				;;
			#Install compiled code into aliases
			--install)
				if [ -z "${ThePipe}" ]; then
					local TypeOfInstall
					local NotSupported
					shift
					local Lang
					local Code=$2
					local Args

					#clide --install <code>.<ext>
					if [ -z "${Code}" ]; then
						NotSupported=$1
						Lang=$(SelectLangByCode $1)
						if [ ! -z "${Lang}" ]; then
							Code=$1
							shift
							Args=( "${@}" )
							case ${Code} in
								-h|--help)
									theHelp InstallCliHelp
									;;
								*)
									if [ ! -z "${Code}" ]; then
										main --install "${Lang}" "${Code}" "${Args[@]}"
									fi
									;;
							esac
						else
							theHelp InstallCliHelp
						fi
					# $ clide --install <lang> <code> or $ clide --install <lang>
					else
						case ${1} in
							# $ clide --install --<installType> <lang> <code> or $ clide --install --<installType> <code>
							--*)
								TypeOfInstall=$1
								shift
								main --install $@ ${TypeOfInstall}
								;;
							*)
								case ${Code} in
									#clide --install <code> --<args>
									-*)
										Lang=$(SelectLangByCode $1)
										Code=$1
										shift
										Args=( "${@}" )
										;;
									# $ clide --install <lang> <code> <args> or $ clide --install <code> <args>
									*)
										Lang=$(pgLang $1)
										shift
										shift
										Args=( "${@}" )
										;;
								esac

								case ${Lang} in
									no)
										errorCode "install" "cli-not-supported" "${NotSupported}"
										;;
									*)
										local CodeDir=$(pgDir ${Lang})
										if [ ! -z "${CodeDir}" ] && [ -d "${CodeDir}" ]; then
											cd ${CodeDir}
											TheSrcCode=$(selectCode ${Lang} ${Code})
											if [ ! -z "${TheSrcCode}" ]; then
												InAndOut="yes"
												if [ ! -z "${Args[@]}" ]; then
													InstallCode ${Lang} "install" "${Args[@]}"
												else
													InstallCode ${Lang} "install"
												fi
											else
												errorCode "cli-cpl" "none"
											fi
											cd - > /dev/null
										else
											errorCode "cli-cpl" "none"
										fi
										;;
								esac
								;;
						esac
					fi
				fi
				;;
			#debug your compiled code
			--debug)
				;;
			--run-sh|--shell)
				shift
				local Lang=$1
				#Provide the help page
				if [ -z "${Lang}" ]; then
					theHelp RunCliHelp ${UserArg}
				else
					case ${Lang} in
						--ls|--list)
							main --find shell
							;;
						*)
							Lang=$(pgLang ${Lang})
							case ${Lang} in
								no)
									;;
								*)
									InAndOut="yes"
									shift
									Actions ${Lang} "none" "shell" "${@}"
								;;
							esac
							;;
					esac
				fi
				;;
			#run your compiled code
			-x|--run|--time|--edit-restore)
				#Protect
				Protect
				shift
				local Lang=$1
				local Code=$2
				local CodeDir
				local IsLang
				local TheLang
				local TheCode
				local LangColor

				#Provide the help page
				if [ -z "${Lang}" ]; then
					theHelp RunCliHelp ${UserArg}
				else
					InAndOut="yes"
					case ${Code} in
						*","*)
							MultiPipe --save
							shift
							shift
							for TheCode in ${Code//,/ };
							do
								case ${Lang} in
									*","*)
										;;
									*)
										MessageOverride="yes"
										;;
								esac
								CLI ${UserArg} ${Lang} ${TheCode} "${@}"
							done
							MultiPipe --remove
							;;
						*)
							case ${Lang} in
								#Run multiple languages
								*","*)
									MultiPipe --save
									MessageOverride="yes"
									local TheCode
									shift
									for TheLang in ${Lang//,/ };
									do
										IsLang=$(pgLang ${TheLang})
										case ${IsLang} in
											no)
												IsLang=$(SelectLangByCode ${TheLang})
												if [ ! -z "${IsLang}" ]; then
													Code=${TheLang}
													TheLang=${IsLang}
													CLI ${UserArg} ${TheLang} ${Code} "${@}"
												fi
												;;
											*)
												CodeDir=$(pgDir ${TheLang})
												case ${CodeDir} in
													no)
														;;
													*)
														if [ ! -z "${CodeDir}" ]; then
															CLI ${UserArg} ${TheLang} "${@}"
														fi
														;;
												esac
												;;
										esac
									done
									MultiPipe --remove
									;;
								#Provide the help page
								-h|--help|-*)
									theHelp RunCliHelp ${UserArg}
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
											shift
											shift
											;;
									esac

									if [ -z "${Code}" ]; then
										errorCode "selectCode" "not-found"
									else
										local TheBin=$(ManageLangs ${Lang} "getBin" "${Code}")
										if [ ! -z "${TheBin}" ]; then
											case ${UserArg} in
												--time)
													TimeRun="time"
													;;
												*)
													;;
											esac
											local Args=( "${@}" )


											case ${UserArg} in
												--edit-restore)
													ManageLangs ${Lang} "restore-edit" ${TheBin}
													echo "Edit rights restored"
													;;
												*)
													#run the code..."none" "none" is to provide the needed padding to run
													runCode ${Lang} ${Code} "none" "none" "${Args[@]}"
													;;
											esac
										else
											errorCode "cpl" "cli-need" "${Lang}"
										fi
									fi
									;;
							esac
							;;
					esac
				fi
				#Done protecting
				Protect "done"
				;;
			--notes)
				if [ -z "${ThePipe}" ]; then
					shift
					local Action=$1
					local Lang=$(pgLang $2)
					if [ ! -z "${Lang}" ]; then
						case ${Lang} in
							no)
								theHelp CliNotes
								;;
							*)
								case ${Action} in
									--edit|--add)
										InAndOut="yes"
										Actions ${Lang} "none" "notes" "edit"
										;;
									--read)
										InAndOut="yes"
										Actions ${Lang} "none" "notes" "read"
										;;
									*)
										;;
								esac
								;;
						esac
					else
						theHelp CliNotes
					fi
				fi
				;;
			--bkup|--restore)
				if [ -z "${ThePipe}" ]; then
					shift
					local Action=$1
					local Lang
					local Code
					local CodeDir
					case ${Action} in
						--*)
							Lang=$2
							Code=$3
							;;
						*)
							Action=""
							Lang=$1
							Code=$2
							;;
					esac

					#Handle source code and langugage
					if [ -z "${Code}" ]; then
						Code=${Lang}
						Lang=$(SelectLangByCode ${Code})
					else
						Lang=$(pgLang ${Lang})
					fi

					CodeDir=$(pgDir ${Lang})
					if [ ! -z "${CodeDir}" ]; then
						cd ${CodeDir}
						TheSrcCode=$(selectCode ${Lang} ${Code})
						if [ ! -z "${TheSrcCode}" ]; then
							case ${UserArg} in
								--restore)
									case ${Action} in
										--help)
											theHelp CliBackupOrRestore ${UserArg}
											;;
										*)
											BackupOrRestore ${Lang} "bkup" "none" --restore
											;;
									esac
									;;
								*)
									case ${Action} in
										--help)
											theHelp CliBackupOrRestore ${UserArg}
											;;
										--remove)
											BackupOrRestore ${Lang} "bkup" "none" --remove
											;;
										--restore)
											BackupOrRestore ${Lang} "bkup" "none" --restore
											;;
										*)
											BackupOrRestore ${Lang} "bkup"
											;;
									esac
									;;
							esac
						fi
					fi
				fi
				;;
			#cat out source code
			--read|--read-num)
				#ensure nothing is getting piped into clide
				if [ -z "${ThePipe}" ]; then
					shift
					local Action=$1
					local Lang=$(pgLang $1)
					local Code=$2
					if [ -z "${Code}" ]; then
						case ${Action} in
							--config)
								case ${UserArg} in
									--read-num)
										cat -n ${root}/etc/clide.conf
										;;
									*)
										cat ${root}/etc/clide.conf
										;;
								esac
								;;
							--lang)
								Lang=$2
								#All characters are lowercase
								Lang=${Lang,,}
								#Frist character is uppercase
								Lang=${Lang^}
								#Make sure the support file exists
								if [ -f ${LangsDir}/Lang.${Lang} ]; then
									case ${UserArg} in
										--read-num)
											cat -n ${LangsDir}/Lang.${Lang}
											;;
										*)
											cat ${LangsDir}/Lang.${Lang}
											;;
									esac
								fi
								;;
							*)
								Lang=$(SelectLangByCode $1)
								Code=$1
								shift
								local Args=( "${@}" )
								if [ ! -z "${Lang}" ] && [ ! -z "${Code}" ]; then
									main ${UserArg} "${Lang}" "${Code}" "${Args[@]}"
								fi
								;;
						esac
					else
						case ${Action} in
							--config)
								${ReadBy} ${root}/etc/clide.conf
								;;
							--lang)
								Lang=$2
								Lang=${Lang,,}
								Lang=${Lang^}
								if [ -f ${LangsDir}/Lang.${Lang} ]; then
									${ReadBy} ${LangsDir}/Lang.${Lang}
								fi
								;;
							*)
								case ${Lang} in
									no)
										errorCode "lang" "no-lang" "$1"
										;;
									*)
										local CodeDir=$(pgDir ${Lang})
										if [ ! -z "${CodeDir}" ]; then
											cd ${CodeDir}
											TheSrcCode=$(selectCode ${Lang} ${Code})
											if [ ! -z "${TheSrcCode}" ]; then
												case ${UserArg} in
													--read-num)
														cat -n ${TheSrcCode}
														;;
													*)
														cat ${TheSrcCode}
														;;
												esac
											else
												errorCode "lang" "readCode"
											fi
										else
											errorCode "lang" "readCode"
										fi
								esac
								;;
						esac
					fi
				fi
				;;
			#List source code from given language
			--list|--ls|--src)
				#ensure nothing is getting piped into clide
				if [ -z "${ThePipe}" ]; then
					shift
					#Select language
					local Lang=$(pgLang $1)
					local SrcFile=$2
					local TheExt
					case ${Lang} in
						#language does not exist
						no)
							Lang=$(SelectLangByCode $1)
							if [ ! -z "${Lang}" ]; then
								CLI ${UserArg} ${Lang} "${1}"
							else
								errorCode "lang" "cli-not-supported" "$1"
							fi
							;;
						#language exists
						*)
							#select source code directory
							local CodeDir=$(pgDir ${Lang})
							#directory exists
							if [ ! -z "${CodeDir}" ] && [ -z "${SrcFile}" ]; then
								#list files
								ls ${CodeDir}
							elif [ ! -z "${CodeDir}" ] && [ ! -z "${SrcFile}" ]; then
								TheExt=$(ManageLangs ${Lang} "getExt")
								SrcFile=${SrcFile%%.*}${TheExt}
								#list files
								if [ -f ${CodeDir}/${SrcFile} ]; then
									echo ${SrcFile}
								fi
							fi
							;;
					esac
				fi
				;;
			#list the compiled/runable code
			--list-cpl|--lscpl|--bin)
				#ensure nothing is getting piped into clide
				if [ -z "${ThePipe}" ]; then
					shift
					#Select language
					local Lang=$(pgLang $1)
					case ${Lang} in
						#language does not exist
						no)
							errorCode "lang" "cli-not-supported" "$1"
							;;
						#language exists
						*)
							#list the compiled code of a given language
							ManageLangs ${Lang} "lscpl"
							;;
					esac
				fi
				;;
			*)
				;;
		esac
	fi
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
		#Get the list of supported languages
		pg=$(ListLangs)
		local getLang=""
		#Make sure lanugages exist
		if [ ! -z "${pg}" ]; then
			#Ensure nothing is getting piped in
			if [ -z "${ThePipe}" ]; then
				#Protect clide from edits during runtime
				Protect
				#CliHelp
				Banner "main"
				errorCode "HINT"
				errorCode "HINT" "enter \"no-lang\" or \"nl\" to enter into a ${Head} shell"
				echo ""
				echo "~Choose a language~"
				#Force user to select language
				while [[ "${getLang}" == "" ]] || [[ "${Lang}" == "no" ]];
				do
					#display prompt
					prompt="${Name}(${pg}):~$ "
					#Get user prompt
					read -e -p "${prompt}" getLang
					case ${getLang} in
						#close clide session
						exit|close)
							Protect "done"
							break
							;;
						#no lnaguage is desired
						no-lang|nl)
							Lang="no-lang"
							break
							;;
						#Attempt choosing a language
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
							Protect "done"
							;;
						#A valid language has been given
						*)
							#Start IDE
							Actions ${Lang}
							;;
					esac
				fi
			else
				errorCode "pipe" "${Head}"
			fi
		else
			errorCode "no-langs"
		fi
	#Handle cli arugments
	else
		case ${UserArg} in
			#Clide is without a session
			-*)
				#handle clide from a cli command and not an IDE
				CLI "${@}"
				;;
			*)
				case ${UserArg} in
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
								#Make sure a directory exists
								if [ ! -z "${CodeDir}" ]; then
									#Go to the language's directory
									cd ${CodeDir}
									#preslect source code
									Code=$(preSelectSrc ${Lang} ${Code})
									#source code exists
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
								#Done protecting
								Protect
								#Start IDE
								Actions-NoLang "${Args[@]}"
								#Done protecting
								Protect "done"
								;;
							*)
								local Args
								Lang=$(pgLang ${Lang})
								shift
								local HiddenAction=$1
								local NextHiddenAction=$2
								local CodeDir
								local BeforeFiles
								local AfterFiles
								local AllFiles
								local NewCode

								case ${HiddenAction} in
									-n|--new)
										shift
										Args=( "${@}" )
										if [ ! -z "${Args[0]}" ]; then
											case ${Args[0]} in
												--custom|-c)
													CodeDir=$(pgDir ${Lang})
													if [ ! -z "${CodeDir}" ] && [ -d "${CodeDir}" ]; then
														cd ${CodeDir}
														BeforeFiles=$(ManageLangs ${Lang} "BeforeFiles")
														main ${HiddenAction} ${Lang} "${Args[@]}"
														AfterFiles=$(ManageLangs ${Lang} "AfterFiles")
														#Combine BEFORE and AFTER
														AllFiles="${BeforeFiles} ${AfterFiles}"
														#Look ALL files for new for new file
														NewCode=$(echo -e "${AllFiles// /\\n}" | sort | uniq -u | tr -d '\n')
														#Check if new code is found
														Args=( "" )
														if [ ! -z "${NewCode}" ]; then
															Args="${NewCode}"
														else
															Args=""
														fi
														cd - > /dev/null
													fi
													;;
												*)
													main ${HiddenAction} ${Lang} "${Args[0]}"
													;;
											esac
										fi
										InAndOut="no"
										case ${Args[0]} in
											--*)
												;;
											*)
											Actions ${Lang} "${Args[0]}"
											;;
										esac
										;;
									# $ clide <lang> --project <action> <ProjectName>
									-p|--project)
										case ${NextHiddenAction} in
											# $ clide <lang> --project --new <ProjectName>
											#Or
											# $ clide <lang> --project --new <ProjectName>
											-n|--new|-i|--import)
												shift
												shift
												Args=( "${@}" )
												main ${HiddenAction} ${NextHiddenAction} ${Lang} "${Args[@]}"
												InAndOut="no"
												main ${HiddenAction} ${Lang} "${Args[@]}"
												;;
											# $ clide <lang> --project <ProjectName>
											*)
												shift
												Args=( "${@}" )
												main ${HiddenAction} ${Lang} "${Args[@]}"
												;;
										esac
										;;
									#Normal usage
									*)
										Args=( "${@}" )
										#Start IDE
										Actions ${Lang} "${Args[@]}"
										;;
								esac
								;;
						esac
						;;
				esac
				;;
		esac
	fi
}

FirstArg=$1
#No argument has been given
if [ -z "${FirstArg}" ]; then
	#Clear cli history
	history -c
	#Run clide
	main
else
	#Check number of arguments
	case $# in
		#Only one argument given
		1)
			#Ignore if program resolves to aliases
			AliasTest=$(echo $@ | grep "/")
			#make sure no alias is found
			if [ -z "${AliasTest}" ]; then
				#Clear cli history
				history -c
				#Run clide
				main "$@"
			fi
			;;
		*)
			#Clear cli history
			history -c
			#Run clide
			main "$@"
			;;
	esac
fi
