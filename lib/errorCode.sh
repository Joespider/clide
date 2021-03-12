Shell=$(which bash)
#!${Shell}

errorCode()
{
	local ecd=$1
	shift
	local sec=$1
	case $ecd in
		alias)
			echo "\"${sec}\" already installed"
			;;
		install)
			case ${sec} in
				choose)
					echo "hint: please choose script"
					;;
				*.java|*.class)
					echo "\"${sec}\" needs to be an java jar"
					echo "[to compile]: cpl --jar"
					;;
				*)
					echo "\"${sec}\" needs to be an executable"
					echo "[to compile]: cpl"
					echo "OR"
					echo "[swap to executable]: swp bin"
					;;
			esac
			;;
		lookFor)
			case ${sec} in
				none)
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
					echo "WARNING: YOU ARE TRYING TO DELETE A FILE"
					echo "WARNING: You will NOT recover this file"
					echo ""
					echo "\"yes\" is NOT \"YES\""
					;;
				hint)
					echo ""
					echo "HINT: to force removal, provide a \"--force\""
					;;
				not-file)
					echo "\"${thr}\" not a file"
					;;
				*)
					;;
			esac
			;;
		noCode)
			echo "No Code Found"
			echo "[to set code]: set <name>"
			;;
		newCode)
			echo "Please Provide The Name Of Your New Code"
			echo "EX: new <name>"
			;;
		runCode)
			echo "${sec} can only handle ONE file"
			;;
		customCode)
			shift
			local thr=$1
			case ${sec} in
				completeNotFound)
					echo "${Head} did not find, or is not configured to find, your program"
					echo "Please select your code"
					echo "[to select code]: set <name>"
					;;
				notemp)
					echo "No ${thr} Template Found"
					;;
				*)
					;;
			esac
			;;
		editNull)
			echo "hint: ${editor}|edit|ed <file>"
			;;
		editNot)
			echo "code is not found in project"
			;;
		selectCode)
			echo "Please select a file to edit"
			;;
		editMe)
			echo "For your safety, I am not allowed to edit myself"
			;;
		readNull)
			echo "hint: ${ReadBy}|read <file>"
			;;
		readNot)
			echo "code is not found in project"
			;;
		project)
			shift
			local thr=$1
			case ${sec} in
				none)
					echo "Your session MUST be a ${thr} Project"
					echo "hint: Please create or load a project"
					echo "$ project new <project>"
					echo "$ project load <project>"
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
							echo "[HINT]: project <name> <path>"
							;;
						name-in-path)
							echo "\"${four}\" must be in the directory of \"${five}\""
							echo "[HINT]: /path/to/${four}/src"
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
					echo "hint: please choose a program name"
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
					echo "[HINT] \$ cpl"
					;;
				none)
					echo "no code to run"
					echo "[hint] set <code>"
					;;
				*)
					echo "Nothing to Compile"
					echo "[to set code]: set <name>"
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
							echo "[Hint] create <lang>"
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
		*)
			;;
	esac
}

errorCode $@
