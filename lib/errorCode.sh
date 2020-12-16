Shell=$(which bash)
#!${Shell}

errorCode()
{
	local ecd=$1
	local sec=$2
	local thr=$3
	local four=$4
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
		customCode)
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
			case ${sec} in
				none)
					echo "Your session MUST be a ${Head} Project"
					echo "hint: Please create or load a project"
					echo "$ project new <project>"
					echo "$ project load <project>"
					;;
				import)
					case ${thr} in
						link-nothing)
							echo "\"${four}\" is not a working directory"
							;;
						*)
							echo "import Methods"
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
				choose)
					echo "hint: please choose a program name"
					;;
				already)
					echo "\"${thr}\" already compiled"
					;;
				not)
					echo "code not found"
					;;
				need)
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
		*)
			;;
	esac
}

errorCode $@
