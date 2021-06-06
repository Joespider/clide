Shell=$(which bash)
#!${Shell}

ShellPath=$(realpath $0)
root=$(dirname ${ShellPath})
root=${root%/modes}

LibDir=$1
shift
LangsDir=$1
shift
ClideProjectDir=$1
ClideProjectDir=${ClideProjectDir}/Templates
shift

Version="0.1.01"
IDE=$(echo -e "\e[1;43madd\e[0m")
Name="cl[${IDE}]"

errorCode()
{
	${LibDir}/errorCode.sh $@
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

Help()
{
	local Lang=$1
	shift
	local component=( $@ )
	case ${component[0],,} in
		shortcut)
			case ${component[1],,} in
				create)
					echo -e "clide\t\t\t\t:\"Create a clide.desktop\""
					echo -e "project, app\t\t\t:\"Create an <application>.desktop\""
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
#			echo -e "change <lang> {run|cpl} <val>\t\t:\"Change the compiler/interpretor\""
#			echo -e "change {run|cpl} <val>\t\t\t:\"Change the compiler/interpretor\""
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
}

AddLangSupport()
{
	local Lang=$1
	local Choice=$2
	local NewLang=$3
	local NewSupportFile
	local SupportFile
	case ${Choice} in
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
	local Lang=$1
	local Code=$2
	local Project=$3
	shift
	shift
	shift
	local Choice=( $@ )
	case ${Choice[0],,} in
		create)
			case ${Choice[1],,} in
				clide)
					echo -e "[Desktop Entry]\nName=cl[ide]\nEncoding=UTF-8\nExec=bash -c \"${root}/clide.sh\"\nIcon=${root}/icons/clide.png\nStartupNotify=false\nTerminal=true\nType=Application\nCategories=Programming;" > clide.desktop
					if [ -f clide.desktop ]; then
						case $USER in
							root)
								mv clide.desktop /usr/share/applications/
								;;
							*)
								sudo mv clide.desktop /usr/share/applications/
								;;
						esac
					else
						echo "unable to create clide.desktop"
					fi
					;;
				app)
					local Name=${Choice[2]}
					case ${Code} in
						none)
							echo "No code found"
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
								echo "${Name}.desktop"
								echo "{"
								echo -e "[Desktop Entry]\nName=${Name}\nEncoding=UTF-8\nExec=bash -c \"\"\nStartupNotify=false\nType=Application"
								echo "}"
							else
								Help "${Lang}" "shortcut" "${Choice[0],,}"
							fi
							;;
					esac
					;;
				*)
					Help "${Lang}" "shortcut" "${Choice[0],,}"
					;;
			esac
			;;
		correct)
			local shortcut
			local Name=${Choice[1]}
			if [ ! -z "${Name}" ]; then
				shortcut="/usr/share/applications/${Name}.desktop"
				if [ -f "${shortcut}" ]; then
					case $USER in
						root)
							${editor} ${shortcut}
							;;
						*)
							sudo ${editor} ${shortcut}
							;;
					esac
				else
					echo "\"${Name}.desktop\" is not installed"
				fi
			else
				Help "${Lang}" "shortcut" "${Choice[0],,}"
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
	local Code=$3
	local cCode=$4
	local FirstAction=$5
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
		if [ ! -z "${FirstAction}" ]; then
			UserArg="set"
			component=${FirstAction,,}
			FirstAction=""
		else
			#Handle CLI
			#read -a UserIn
			#Handle CLI
			read -e -p "${prompt}" -a UserIn
			UserArg=${UserIn[0],,}
			component=${UserIn[1],,}
		fi
		case ${UserArg} in
			set)
				component=$(SelectComp "${component}")
				Ccomponent=$(echo -e "\e[1;35m${component}\e[0m")
				;;
			done)
				component=$(SelectComp "")
				Ccomponent=""
				;;
			create|import|change|correct)
				case ${component} in
					shortcut)
						AddShortcut ${Lang} ${Code} ${CodeProject} ${UserIn[@]}
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
				case ${Code} in
					none)
						;;
					*)
						echo "Code: \"${cCode}\""
						;;
				esac
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
			help)
				Help "${Lang}" "${component}"
				;;
			exit|close)
				break
				;;
			#ignore all other commands
			*)
				;;
		esac
	done
}

#Add IDE
Add $@
