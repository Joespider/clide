Shell=$(which bash)
#!${Shell}

errorCode()
{
	local ecd=$1
	shift
	local sec=$1
	case ${ecd} in
		alias)
			errorCode "ERROR"
			echo "\"${sec}\" already installed"
			;;
		install)
			case ${sec} in
				choose)
					errorCode "HINT" "command"
					echo "please choose script"
					;;
				*.java|*.class)
					errorCode "ERROR"
					echo "\"${sec}\" needs to be an java jar"
					errorCode "HINT" "command"
					echo "cpl --jar"
					;;
				*)
					errorCode "ERROR"
					echo "\"${sec}\" needs to be an executable"
					errorCode "HINT" "command"
					echo "cpl"
					;;
			esac
			;;
		lookFor)
			case ${sec} in
				none)
					errorCode "ERROR"
					echo ""
					echo "Nothing to search for"
					echo "Please provide a value"
					;;
				*)
					;;
			esac
			;;
		remove)
			shift
			local thr=$1
			case ${sec} in
				sure)
					errorCode "WARNING"
					echo "YOU ARE TRYING TO DELETE A FILE"
					errorCode "WARNING"
					echo "You will NOT recover this file"
					echo ""
					echo "\"yes\" is NOT \"YES\""
					;;
				hint)
					echo ""
					errorCode "HINT"
					echo "To force removal, provide a \"--force\""
					;;
				not-file)
					echo "\"${thr}\" not a file"
					;;
				*)
					;;
			esac
			;;
		noCode)
			errorCode "ERROR"
			echo "No Code Found"
			errorCode "HINT" "command"
			echo "set <name>"
			;;
		newCode)
			case ${sec} in
				already)
					errorCode "ERROR"
					echo "source code already made"
					errorCode "HINT" "command"
					echo "set <name>"
					;;
				*)
					errorCode "ERROR"
					echo "Please Provide The Name Of Your New Code"
					errorCode "HINT" "command"
					echo "new <name>"
					;;
			esac
			;;
		newCodeTemp)
			case ${sec} in
				no-exist)
					errorCode "ERROR"
					echo "No source code found"
					errorCode "HINT" "command"
					echo "create ${ecd} new"
					;;
				exist)
					errorCode "ERROR"
					echo "Template source code already found"
					errorCode "HINT" "command"
					echo "create ${ecd} update"
					;;
				update)
					echo "[Template created]"
					echo "To edit and compile, pleae execute the following"
					errorCode "HINT" "command"
					echo "create ${ecd} update"
					;;
				*)
					;;
			esac
			;;
		runCode)
			errorCode "ERROR"
			echo "${sec} can only handle ONE file"
			;;
		customCode)
			shift
			local thr=$1
			case ${sec} in
				completeNotFound)
					echo "${Head} did not find, or is not configured to find, your program"
					echo "Please select your code"
					errorCode "HINT" "command"
					echo "set <name>"
					;;
				notemp)
					errorCode "ERROR"
					echo "No ${thr} Template Found"
					;;
				*)
					;;
			esac
			;;
		editNull)
			errorCode "HINT" "command"
			echo "${editor}|edit|ed <file>"
			;;
		editNot)
			errorCode "ERROR"
			echo "code is not found in project"
			;;
		selectCode)
			shift
			local thr=$1
			case ${sec} in
				set)
					errorCode "HINT" "command"
					echo "set <source>"
					;;
				nothing)
					errorCode "ERROR"
					echo "There is nothing to add"
					;;
				exists)
					errorCode "ERROR"
					echo "Source Code has already been selected"
					errorCode "HINT" "command"
					echo "add <source>"
					;;
				already)
					errorCode "ERROR"
					echo "No need to add it again"
					;;
				*)
					errorCode "ERROR"
					echo "Please select a file to edit"
					;;
			esac
			;;
		editMe)
			errorCode "WARNING"
			echo "For your safety, I am not allowed to edit myself"
			;;
		readNull)
			errorCode "HINT" "command"
			echo "${ReadBy}"
			echo "or"
			errorCode "HINT" "command"
			echo "read"
			echo "or"
			errorCode "HINT" "command"
			echo "read <file>"
			echo "or"
			errorCode "HINT" "command"
			echo "${ReadBy} <file>"

			;;
		readNot)
			errorCode "ERROR"
			echo "code is not found in project"
			;;
		project)
			shift
			local thr=$1
			case ${sec} in
				none)
					echo "Your session MUST be a ${thr} Project"
					echo "Please create or load a project"
					errorCode "HINT" "command"
					echo "project new <project>"
					errorCode "HINT" "command"
					echo "project load <project>"
					;;
				type)
					echo "Could not create project type: \"${thr}\""
					;;
				active)
					echo "There are no active projects"
					;;
				can-not-leave)
					echo "Leaving your project is not allowed"
					;;
				import)
					shift
					local four=$1
					case ${thr} in
						link-nothing)
							echo "\"${four}\" is not a working directory"
							;;
						no-path)
							echo "no path Given"
							;;
						no-name)
							echo "no project name given"
							errorCode "HINT" "command"
							echo "project <name> <path>"
							;;
						name-in-path)
							echo "\"${four}\" must be in the directory of \"${five}\""
							errorCode "HINT"
							echo "/path/to/${four}/src"
							;;
						exists)
							echo "You Already have a project named \"${four}\""
							;;
						*)
							echo "import Methods"
							;;
					esac
					;;
				load)
					shift
					local four=$1
					case ${thr} in
						no-path)
							echo "Project \"${four}\" Directory not Found"
							;;
						no-project)
							echo "Not \"${four}\" a valid project"
							;;
						*)
							;;
					esac
					;;
				not-exist)
					echo "Unable to create your project \"${thr}\""
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
				ERROR)
					shift
					local thr=$@
					local ERROR=$(echo ${thr} | tr '|' '\n')
					echo -en "\e[1;31m[\e[0m"
					echo -en "\e[1;41mERROR\e[0m"
					echo -e "\e[1;31m]\e[0m"
					echo -e "\e[1;31m${ERROR}\e[0m"
					;;
				choose)
					errorCode "HINT"
					echo "please choose a program name"
					;;
				already)
					shift
					local thr=$1
					echo "\"${thr}\" already compiled"
					;;
				not)
					echo "code not found"
					;;
				need)
					shift
					local thr=$1
					echo "${thr} is not compiled"
					errorCode "HINT" "command"
					echo "cpl"
					;;
				none)
					echo "no code to run"
					errorCode "HINT" "command"
					echo "set <code>"
					;;
				*)
					echo "Nothing to Compile"
					errorCode "HINT" "command"
					echo "set <name>"
					;;
			esac
			;;
		loadSession)
			echo "No Session to load"
			;;
		backup)
			case ${sec} in
				null)
					echo "No source code given"
					;;
				exists)
					echo "Back-up file already exists"
					;;
				wrong)
					echo "Please choose the correct source file"
					;;
				*)
					;;
			esac
			;;
		restore)
			case ${sec} in
				null)
					echo "No source code given"
					;;
				exists)
					echo "No back-up file found"
					;;
				wrong)
					echo "Please choose the correct source file"
					;;
				*)
					;;
			esac
			;;
		no-langs)
			echo "No Languages installed"
			echo "Please Lang.<language> in \"${LangsDir}/\""
			;;
		not-a-lang)
			echo "Language is not found"
			;;
		add)
			shift
			local thr=$1
			shift
			local four=$1
			case ${sec} in
				support)
					case ${thr} in
						no-lang)
							echo "Please provide a new language"
							errorCode "HINT" "command"
							echo "create <lang>"
							;;
						not-supported)
							echo "\"${four}\" is not a supported language"
							;;
						already-supported)
							echo "\"${four}\" is already supported language"
							;;
						*)
							echo "Adding Language Support error"
							;;
					esac
					;;
				*)
					;;
			esac
			;;
		no-support)
			echo "The following feature is not yet supported"
			echo "Feature: ${sec}"
			;;
		HINT)
			case ${sec} in
				command)
					echo -n "[HINT]: \$ "
					;;
				*)
					echo -n "[HINT]: "
					;;
			esac
			;;
		ERROR)
			echo -n "[ERROR]: "
			;;
		WARNING)
			echo -n "[WARNING]: "
			;;
		*)
			;;
	esac
}

errorCode $@
