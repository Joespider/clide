#!/usr/bin/env bash
ThisFile=$0

ShellPath=$(realpath ${ThisFile})
root=$(dirname ${ShellPath})
root=${root%/modes}

Head=$1
shift
LibDir=$1
shift
LangsDir=$1
shift
ClideProjectDir=$1
ClideProjectDir=${ClideProjectDir}/Templates
shift
addVersion="0.1.05"
IDE=$(echo -e "\e[1;43madd\e[0m")
Name="cl[${IDE}]"

errorCode()
{
	${LibDir}/errorCode.sh $@
}

#call help shell script
theHelp()
{
	${LibDir}/help.sh ${Head} ${LangsDir} ModesHelp add.sh $@
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
	fi
}

colors()
{
	local text=$1
	case ${text} in
		add)
			echo -e "\e[1;31m${text}\e[0m"
			;;
		*)
			;;
	esac
}

ListLanguages()
{
	ls ${LangsDir} | sed "s/Lang.//g"
}

AddLangSupport()
{
	local Lang=$1
	local Choice=$2
	local NewLang=$3
	local NewSupportFile
	local SupportFile
	case ${Choice} in
		--help|help)
			theHelp "language"
			;;
		create)
			echo "refactor please"
			;;
		import)
			errorCode "no-support" "add-Lang"
			;;
		correct)
			echo "Manually correct project template"
			;;
		*)
			;;
	esac
}

AddShortcut()
{
	local DebainAppDir=/usr/share/applications
	local Lang=$1
	local Project=$2
	local ExeString
	shift
	shift
	local Choice=( $@ )
	case ${Choice[0],,} in
		create)
			case ${Choice[1],,} in
				clide)
					local ClideDesktop="clide.desktop"
					echo -e "[Desktop Entry]\nName=cl[ide]\nEncoding=UTF-8\nExec=bash -c \"${root}/clide.sh\"\nIcon=${root}/icons/clide.png\nStartupNotify=false\nTerminal=true\nType=Application\nCategories=Programming;Development;IDE;" > ${ClideDesktop}
					if [ -f ${ClideDesktop} ]; then
						case ${USER} in
							root)
								mv ${ClideDesktop} ${DebainAppDir}/
								;;
							*)
								sudo mv ${ClideDesktop} ${DebainAppDir}/
								;;
						esac

						if [ -f ${DebainAppDir}/${ClideDesktop} ]; then
							echo -e "\e[1;42m${Head} App Installed\e[0m"
						fi
					else
						errorCode "mode-add" "shortcut" "create" "clide"
					fi
					;;
				app)
					local Name=${Choice[2]}
					local shortcut="/usr/share/applications/${Name}.desktop"
					case ${TheSrcCode} in
						none)
							errorCode "mode-add" "shortcut" "app" "none"
							;;
						*)
							case ${Project} in
								none)
									;;
								*)
									if [ -z "${Name}" ]; then
										Name=${Project}
									fi
									;;
							esac
							if [ ! -z "${Name}" ]; then
								ExeString=$(ManageLangs ${Lang} "exe-string" "${TheSrcCode}")
								if [ ! -z "${ExeString}" ] && [ ! -f ${shortcut} ]; then
									echo -e "[Desktop Entry]\nName=${Name}\nEncoding=UTF-8\nExec=bash -c \"${ExeString}\"\nStartupNotify=false\nType=Application" > ${Name}.desktop
									case ${USER,,} in
										root)
											mv ${Name}.desktop ${shortcut}
											;;
										*)
											sudo mv ${Name}.desktop ${shortcut}
											;;
									esac
									errorCode "HINT" "${Name}.desktop created"
								fi
							else
								theHelp "${Lang}" "shortcut" "${Choice[0],,}"
							fi
							;;
					esac
					;;
				*)
					theHelp "${Lang}" "shortcut" "${Choice[0],,}"
					;;
			esac
			;;
		correct)
			local shortcut
			local Name=${Choice[1]}
			if [ ! -z "${Name}" ]; then
				shortcut="/usr/share/applications/${Name}.desktop"
				if [ -f "${shortcut}" ]; then
					case ${USER,,} in
						root)
							${editor} ${shortcut}
							;;
						*)
							sudo ${editor} ${shortcut}
							;;
					esac
				else
					errorCode "mode-add" "shortcut" "correct"
				fi
			else
				theHelp "${Lang}" "shortcut" "${Choice[0],,}"
			fi
			;;
		*)
			;;
	esac
}

AddProjectTemplate()
{
	echo "${ClideProjectDir}/"
	local Lang=$1
	local Choice=$2
	case ${Choice} in
		--help|help)
			theHelp "project"
			;;
		create)
			echo "Create a new project template"
			;;
		import)
			echo "Import project for ${Lang}"
			;;
		correct)
			echo "Manually correct project template"
			;;
		*)
			;;
	esac
}

SelectComp()
{
	local Use=$1
	case ${Use} in
		shortcut)
			echo "${Use}"
			;;
		project|projects)
			echo "project"
			;;
		support|language)
			echo "language"
			;;
		*)
			;;
	esac
}

#IDE
Add()
{
	local Lang=$1
	local cLang=$2
	shift
	shift
	shift
	local FirstAction=( $@ )
	local UserIn
	local prompt
	local UserArg
	local component
	local Ccomponent
	while true
	do
		if [ -z "${component}" ]; then
			prompt="${Name}:$ "
		else
			prompt="${Name}(${Ccomponent}):$ "
		fi

		#User's first action
		if [ ! -z "${FirstAction[0]}" ]; then
			UserIn=( ${FirstAction[@]} )
			UserArg=${UserIn[0]}
			FirstAction=""
		else
			#Handle CLI
			#read -a UserIn
			#Handle CLI
			read -e -p "${prompt}" -a UserIn
			UserArg=${UserIn[0],,}
		fi
		case ${UserArg} in
			version)
				echo "Mode(\"add\"): ${addVersion}"
				;;
			set)
				local GetComp
				if [ ! -z "${UserIn[1]}" ]; then
					GetComp=$(SelectComp "${UserIn[1],,}")
					if [ ! -z "${GetComp}" ]; then
						component="${GetComp}"
						Ccomponent=$(echo -e "\e[1;35m${component}\e[0m")
					fi
				fi
				;;
			unset|done)
				component=$(SelectComp "")
				Ccomponent=""
				;;
			create|import|change|correct)
				case ${component} in
					shortcut)
						AddShortcut ${Lang} ${CodeProject} ${UserIn[@]}
						;;
					project)
						AddProjectTemplate ${Lang} ${UserArg}
						;;
					language)
						AddLangSupport ${Lang} ${UserIn[@]}
						;;
					*)
						;;
				esac
				;;
			using)
				echo "Language: \"${cLang}\""
				if [ ! -z "${TheSrcCode}" ]; then
					echo "Code: \"${TheSrcCode}\""
				fi
				case ${CodeProject} in
					none)
						;;
					*)
						local cCodeProject=$(ManageLangs ${Lang} "ProjectColor")
						echo "Project: \"${cCodeProject}\""
						;;
				esac
				;;
			clear)
				clear
				;;
			help|-h|--help)
				UserIn[1]=""
				if [ ! -z "${component}" ]; then
					theHelp ${Lang} ${component} ${UserIn[@]}
				else
					theHelp ${Lang} ${UserIn[@]}
				fi
				;;
			exit|close)
				break
				;;
			#ignore all other commands
			*)
				local GetComp
				if [ ! -z "${UserArg[0]}" ]; then
					GetComp=$(SelectComp "${UserIn[0],,}")
					if [ ! -z "${GetComp}" ]; then
						component="${GetComp}"
						Ccomponent=$(echo -e "\e[1;35m${component}\e[0m")
					fi
				fi
				;;
		esac
	done
}

#Add IDE
Add $@
