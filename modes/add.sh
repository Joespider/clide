Shell=$(which bash)
#!${Shell}

LibDir=$1
shift
LangsDir=$1
shift
ClideProjectDir=$1
ClideProjectDir=${ClideProjectDir}/Templates
shift

IDE=$(echo -e "\e[1;43madd\e[0m")
Name="cl[${IDE}]"

errorCode()
{
	${LibDir}/errorCode.sh $@
}

colors()
{
	text=$1
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
	local options=$1
	local Lang=$2
	case ${options} in
		project)
			echo "Component: Project"
			echo -e "create <project>\t\t\t:\"Create a brand new project template\""
			echo -e "import\t\t\t\t:\"import a new project type (Lang.${Lang}.<type> FILE MUST EXIST)\""
			echo -e "correct\t\t\t\t:\"Adjust existing project tempalte\""
			echo ""
			echo -e "done\t\t\t\t: \"done with adding component\""
			echo -e "exit,close\t\t\t\t: \"close mode\""
			;;
		language)
			echo "Component: Language Support"
			echo -e "create <new language>\t\t:\"Create support for another language\""
			echo -e "import\t\t\t\t:\"import new language to support (Lang.<type> FILE MUST EXIST)\""
			echo -e "change <lang> {run|cpl} <val>\t\t:\"Change the compiler/interpretor\""
			echo -e "change {run|cpl} <val>\t\t\t:\"Change the compiler/interpretor\""
			echo -e "correct\t\t\t\t:\"Adjust existing support for Langauge\""
			echo ""
			echo -e "done\t\t\t\t: \"done with adding component\""
			echo -e "exit,close\t\t\t\t: \"close mode\""
			;;
		*)
			echo "Help options"
			echo -e "add <cmp>\t\t\t: \"select component to add\""
			echo -e "\tproject\t: \"select the 'project' component\""
			echo -e "\tsupport, language\t: \"select the 'project' component\""
			echo -e "using\t\t\t\t: \"Show what langauge is being used\""
			echo ""
			echo -e "exit,close\t\t\t\t: \"close mode\""
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
			if [ ! -z "${NewLang}" ]; then
				NewLang=${NewLang^}
				NewSupportFile=${LangsDir}/Lang.${NewLang}
				local GetLang
				local OldVersion
				local NewVersion
				local OldCpl
				local NewCpl
				local OldRun
				local NewRun
				local OldExt
				local NewExt
				if [ ! -f ${NewSupportFile} ]; then
					echo "Which Language is \"${NewLang}\" most like?"
					ListLanguages | tr '\n' ' '
					echo ""
					echo -n "\"${Lang}\"> "
					read GetLang
					if [ ! -z "${GetLang}" ]; then
						GetLang=$(echo ${GetLang} | tr A-Z a-z)
						Lang=${GetLang^}
					fi
					SupportFile=${LangsDir}/Lang.${Lang^}
					if [ -f ${SupportFile} ]; then
						cp "${SupportFile}" "${NewSupportFile}"
						#Reset Version
						#{
						OldVersion=$(grep "SupportV=" "${SupportFile}" | tr -d '\t')
						NewVersion="SupportV=\"0.0.1\""
						sed -i "s/${OldVersion}/${NewVersion}/g" "${NewSupportFile}"
						#}
						OldExt=$(grep "LangExt=" "${SupportFile}" | tr -d '\t' | sed "s/local LangExt=//g")
						echo -n "\"${NewLang}\" extension > "
						read NewExt
						sed -i "s/LangExt=${OldExt}/local LangExt=\"${NewExt}\"/g" "${NewSupportFile}"
						#Change Compiler/Interpretor
						OldCpl=$(grep "LangCpl=" "${SupportFile}" | tr -d '\t' | sed "s/local LangCpl=//g")
						OldRun=$(grep "LangRun=" "${SupportFile}" | tr -d '\t' | sed "s/local LangRun=//g" | tr -d '\n')
						sed -i "s/${Lang}/${NewLang}/g" "${NewSupportFile}"
						if [ ! -z "${OldCpl}" ]; then
							echo -n "Compiler> "
							read NewCpl
							if [ ! -z "${NewCpl}" ]; then
								sed -i "s/local LangCpl=${OldCpl}/local LangCpl=${NewCpl}/g" "${NewSupportFile}"
							fi
						fi
						if [ ! -z "${OldRun}"  ]; then
							echo -n "Interpretor> "
							read NewRun
							if [ ! -z "${NewRun}" ]; then
								sed -i "s/local LangRun=${OldRun}/local LangRun=${NewRun}/g" "${NewSupportFile}"
							fi
						fi
						sed -i "s/${Lang}/${NewLang}/g" "${NewSupportFile}"
						echo "Support for \"${NewLang}\" is created"
					else
						errorCode "add" "support" "not-supported" "${Lang}"
					fi
				else
					errorCode "add" "support" "already-supported" "${NewLang}"
				fi
			else
				errorCode "add" "support" "no-lang"
			fi
			;;
		import)
			errorCode "no-support" "add-Lang"
			;;
		change)
			local prop=$4
			local to=$5
			if [ ! -z "${prop}" ] && [ -z "${to}" ]; then
				to=${prop}
				prop=${NewLang}
				NewLang=${Lang}
			fi
			local OldCpl
			local NewCpl
			local OldRun
			local NewRun
			SupportFile=${LangsDir}/Lang.${NewLang^}
			case ${prop} in
				cpl)
					#Change Compiler
					OldCpl=$(grep "LangCpl=" "${SupportFile}" | tr -d '\t' | sed "s/local LangCpl=//g")
					if [ ! -z "${OldCpl}" ]; then
						sed -i "s/local LangCpl=${OldCpl}/local LangCpl=${to}/g" "${SupportFile}"
					fi
					;;
				run)
					#Change Interpretor
					OldRun=$(grep "LangRun=" "${SupportFile}" | tr -d '\t' | sed "s/local LangRun=//g" | tr -d '\n')
					if [ ! -z "${OldRun}" ]; then
						sed -i "s/local LangRun=${OldRun}/local LangRun=${to}/g" "${SupportFile}"
					fi
					;;
				*)
					;;
			esac
			;;
		correct)
			echo "Manually correct project template"
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
	local prompt
	local UserArg
	local component
	while true
	do
		if [ -z "${component}" ]; then
			prompt="${Name}:$ "
		else
			prompt="${Name}(${component}):$ "
		fi
		#Handle CLI
		read -e -p "${prompt}" -a UserIn
		UserArg=$(echo ${UserIn[0]} | tr A-Z a-z)
		case ${UserArg} in
			add)
				component=$(SelectComp "${UserIn[1]}")
				;;
			done)
				component=$(SelectComp "")
				;;
			create|import|change|correct)
				case ${component} in
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
				echo ${cLang}
				;;
			clear)
				clear
				;;
			help)
				Help "${component}" "${Lang}"
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
