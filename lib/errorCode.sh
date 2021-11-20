Shell=$(which bash)
#!${Shell}

errorCode()
{
	local ecd=$1
	shift
	local sec=$1
	case ${ecd} in
		missing)
			shift
			local thr=$1
			case ${sec} in
				dir)
					errorCode "ERROR"
					errorCode "ERROR" "MISSING: ${thr}/"
					;;
				file)
					errorCode "ERROR"
					errorCode "ERROR" "MISSING: ${thr}"
					;;
				*)
					;;
			esac
			;;
		pipe)
			errorCode "ERROR"
			errorCode "ERROR" "Using pipes with ${sec} is interfering with normal funtionality"
			echo ""
			errorCode "HINT" "${sec} can pass piped data to programs"
			errorCode "HINT" "command"
			errorCode "HINT" "echo \"Try me\" | clide --run <lang> <program>"
			;;
		rename)
			shift
			local thr=$1
			case ${sec} in
				wrong)
					errorCode "ERROR"
					errorCode "ERROR" "${thr} may not be specific enough"
					;;
				null)
					errorCode "ERROR"
					errorCode "ERROR" "No source code selected"
					;;
				*)
					;;
			esac
			;;
		make)
			shift
			local thr=$1
			case ${sec} in
				not-for-lang)
					errorCode "ERROR"
					errorCode "ERROR" "${thr} does not support make"
					;;
				edit-make)
					errorCode "ERROR"
					errorCode "ERROR" "No Make file created"
					errorCode "HINT" "command"
					errorCode "HINT" "make create"
					errorCode "HINT" "\tor"
					errorCode "HINT" "command"
					errorCode "HINT" "create make"
					;;
				already)
					errorCode "ERROR"
					errorCode "ERROR" "make file already created"
					;;
				need-to-be-project)
					errorCode "ERROR"
					errorCode "ERROR" "Project ${thr} ONLY"
					;;
				*)
					;;
			esac
			;;
		mode-pkg)
			shift
			local thr=$1
			local four=$2
			case ${sec} in
				no-manager)
					errorCode "ERROR"
					errorCode "ERROR" "unable to find a package manager for ${thr}"
					errorCode "WARNING" "\texiting mode..."
					;;
				*)
					;;
			esac
			;;
		mode-add)
			shift
			local thr=$1
			local four=$2
			case ${sec} in
				shortcut)
					case ${thr} in
						create)
							case ${four} in
								clide)
									errorCode "ERROR"
									errorCode "ERROR" "unable to create clide.desktop"
									;;
								*)
									;;
							esac
							;;
						app)
							case ${four} in
								none)
									errorCode "ERROR"
									errorCode "ERROR" "No source code found"
									;;
								*)
									;;
							esac
							;;
						correct)
							errorCode "ERROR"
							errorCode "ERROR" "\"${Name}.desktop\" is not installed"
							;;
						*)
							;;
					esac
					;;
				*)
					;;
			esac
			;;
		mode-repo)
			shift
			local thr=$1
			local four=$2
			case ${sec} in
				git)
					case ${thr} in
						not-installed)
							errorCode "ERROR"
							errorCode "ERROR" "\"${sec}\" is not installed"
							;;
						clone-nothing)
							errorCode "ERROR"
							errorCode "ERROR" "Nothing to clone"
							;;
						create-no-branch)
							errorCode "ERROR"
							errorCode "ERROR" "No branch has been created"
							;;
						delete-no-branch)
							errorCode "ERROR"
							errorCode "ERROR" "No branch to delete"
							;;
						select-no-branch)
							errorCode "ERROR"
							errorCode "ERROR" "No branch has been selected"
							;;
						push-no-branch)
							errorCode "ERROR"
							errorCode "ERROR" "Code not pushed; no branch found"
							;;
						please-install)
							errorCode "ERROR"
							errorCode "ERROR" "Please Install ${sec}"
							;;
						*)
							;;
					esac
					;;
				svn)
					case ${thr} in
						not-installed)
							errorCode "ERROR"
							errorCode "ERROR" "\"${sec}\" is not installed"
							;;
						please-install)
							errorCode "ERROR"
							errorCode "ERROR" "Please Install ${sec}"
							;;
						disabled)
							errorCode "ERROR"
							errorCode "ERROR" "repo version control has been disabled"
							;;
						*)
							;;
					esac
					;;
				*)
					;;
			esac
			;;
		readCode)
			errorCode "ERROR"
			errorCode "ERROR" "No code to read"
			;;
		lang)
			shift
			local thr=$1
			case ${sec} in
				already-supported)
					errorCode "ERROR"
					errorCode "ERROR" "\"${thr}\" is already supported language"
					;;
				cli-not-supported)
					errorCode "ERROR"
					errorCode "ERROR" "\"${thr}\" is not a supported language"
					;;
				not-a-lang)
					errorCode "ERROR"
					errorCode "ERROR" "Language is not found"
					;;
				no-lang)
					errorCode "ERROR"
					errorCode "ERROR" "Cannot find the language"
					;;
				no-langs)
					errorCode "ERROR"
					errorCode "ERROR" "No Languages installed"
					errorCode "ERROR" "Please ensure Lang.<language> is in \"${LangsDir}/\" and given permission to execute"
					;;
				*)
					;;
			esac
			;;
		debug)
			shift
			local thr=$1
			case ${sec} in
				not-installed)
					errorCode "ERROR"
					errorCode "ERROR" "\"${thr}\" is not installed"
					;;
				not-set)
					errorCode "ERROR"
					errorCode "ERROR" "No debugger is set for ${thr}"
					errorCode "HINT"
					errorCode "HINT" "please exit cl[ide] and set the config file"
					errorCode "HINT" "command"
					errorCode "HINT" "clide --edit --config"
					;;
				need-enable)
					shift
					local four=$1
					errorCode "ERROR"
					errorCode "ERROR" "Program is not ready for debugging"
					echo ""
					errorCode "HINT"
					errorCode "HINT" "please enable debugging"
					case ${thr,,} in
						java)
							echo -en "\t"
							errorCode "HINT" "Compile as a class file"
							errorCode "HINT" "command"
							errorCode "HINT" "cpl"
							;;
						python)
							echo -en "\t"
							errorCode "HINT" "Add \"import ${four}\" into your code"
							;;
						*)
							errorCode "HINT" "command"
							errorCode "HINT" "create cpl"
							;;
					esac
					;;
				*)
					;;
			esac
			;;
		alias)
			errorCode "ERROR"
			errorCode "ERROR" "\"${sec}\" already installed"
			;;
		install)
			shift
			local thr=$1
			case ${sec} in
				cli-not-supported)
					errorCode "lang" "cli-not-supported" "${thr}"
					;;
				choose)
					errorCode "HINT" "command"
					errorCode "HINT" "please choose script"
					;;
				*.java|*.class)
					errorCode "ERROR"
					errorCode "ERROR" "\"${sec}\" needs to be an java jar"
					errorCode "HINT" "command"
					errorCode "HINT" "cpl --jar"
					;;
				*)
					errorCode "ERROR"
					errorCode "ERROR" "\"${sec}\" needs to be an executable"
					errorCode "HINT" "command"
					errorCode "HINT" "cpl"
					;;
			esac
			;;
		lookFor)
			case ${sec} in
				none)
					errorCode "ERROR"
					echo ""
					errorCode "ERROR" "Nothing to search for"
					errorCode "ERROR" "Please provide a value"
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
					errorCode "WARNING" "YOU ARE TRYING TO DELETE A FILE"
					errorCode "WARNING" "You will NOT recover this file"
					echo ""
					errorCode "WARNING" "\"yes\" is NOT \"YES\""
					;;
				hint)
					echo ""
					errorCode "HINT"
					errorCode "HINT" "To force removal, provide a \"-f\""
					;;
				not-file)
					errorCode "ERROR"
					errorCode "ERROR" "\"${thr}\" not a file"
					;;
				*)
					;;
			esac
			;;
		noCode)
			errorCode "ERROR"
			errorCode "ERROR" "No Code Found"
			errorCode "HINT" "command"
			errorCode "HINT" "set <name>"
			;;
		notes)
			shift
			local thr=$1
			case ${sec} in
				none)
					errorCode "ERROR"
					errorCode "ERROR" "No notes for ${thr} found"
					;;
				*)
					;;
			esac
			;;
		package)
			shift
			local thr=$1
			case ${sec} in
				need-java)
					errorCode "ERROR"
					errorCode "ERROR" "packages are reserved for Java projects"
					;;
				null-name)
					errorCode "ERROR"
					errorCode "ERROR" "Please provide a package name"
					errorCode "HINT" "command"
					errorCode "HINT" "package new name.of.package"
					;;
				not-valid)
					errorCode "ERROR"
					errorCode "ERROR" "\"${thr}\" is not a valid package"
					errorCode "HINT" "package can not contain \".new.\" or \".this.\""
					;;
				need-name)
					errorCode "ERROR"
					errorCode "ERROR" "Please provide new package"
					;;
				same)
					errorCode "ERROR"
					errorCode "ERROR" "Old Pacakge can NOT be the same as the new package"
					;;
				none)
					errorCode "ERROR"
					errorCode "ERROR" "Source Code not found"
					;;
				*)
					;;
			esac
			;;
		newCode)
			case ${sec} in
				one-at-a-time)
					errorCode "ERROR"
					errorCode "ERROR" "Can create only one filename at a time"
					;;
				already)
					errorCode "ERROR"
					errorCode "ERROR" "source code already made"
					errorCode "HINT" "command"
					errorCode "HINT" "set <name>"
					;;
				cli-already)
					errorCode "ERROR"
					errorCode "ERROR" "source code already made"
					;;
				need-package)
					errorCode "ERROR"
					errorCode "ERROR" "Need to be in a package"
					echo ""
					errorCode "HINT" "Create a package"
					errorCode "HINT" "command"
					errorCode "HINT" "package new path.to.package"
					errorCode "HINT" "Or"
					errorCode "HINT" "Change directory to package"
					errorCode "HINT" "command"
					errorCode "HINT" "cd path/to/package"
					;;
				choose-dir)
					errorCode "ERROR"
					errorCode "ERROR" "Please be in \"src/main/java\" or \"src/test/java\" when creating new code"
					echo ""
					errorCode "HINT" "Change directory"
					errorCode "HINT" "command"
					errorCode "HINT" "cd <path>"
					;;
				*)
					errorCode "ERROR"
					errorCode "ERROR" "Please Provide The Name Of Your New Code"
					errorCode "HINT" "command"
					errorCode "HINT" "new <name>"
					;;
			esac
			;;
		newCodeTemp)
			case ${sec} in
				no-exist)
					errorCode "ERROR"
					errorCode "ERROR" "No source code found"
					errorCode "HINT" "command"
					errorCode "HINT" "create ${ecd} new"
					;;
				exist)
					errorCode "ERROR"
					errorCode "ERROR" "Template source code already found"
					errorCode "HINT" "command"
					errorCode "HINT" "create ${ecd} update"
					;;
				update)
					errorCode "WARNING" "[Template created]"
					errorCode "WARNING" "To edit and compile, pleae execute the following"
					errorCode "HINT" "command"
					errorCode "HINT" "create ${ecd} update"
					;;
				*)
					;;
			esac
			;;
		runCode)
			shift
			local thr=$1
			case ${sec} in
				no-lang)
					errorCode "lang" "no-langs"
					;;
				*)
					errorCode "ERROR"
					errorCode "ERROR" "${sec} can only handle ONE file"
					;;
			esac
			;;
		customCode)
			shift
			local thr=$1
			case ${sec} in
				completeNotFound)
					errorCode "WARNING" "${Head} did not find, or is not configured to find, your program"
					errorCode "WARNING" "Please select your code"
					errorCode "HINT" "command"
					errorCode "HINT" "set <name>"
					;;
				notemp)
					errorCode "ERROR"
					errorCode "ERROR" "No ${thr} Template Found"
					;;
				*)
					;;
			esac
			;;
		editNull)
			errorCode "HINT" "command"
			errorCode "HINT" "${editor}|edit|ed <file>"
			;;
		editNot)
			errorCode "ERROR"
			errorCode "ERROR" "code is not found in project"
			;;
		selectCode)
			shift
			local thr=$1
			case ${sec} in
				not-found)
					if [ -z "${thr}" ]; then
						errorCode "ERROR"
						errorCode "ERROR" "no source code found"
					else
						errorCode "ERROR"
						errorCode "ERROR" "${thr} not found"
					fi
					;;
				set)
					errorCode "HINT" "command"
					errorCode "HINT" "set <source>"
					;;
				nothing)
					errorCode "ERROR"
					errorCode "ERROR" "There is nothing to add"
					;;
				exists)
					errorCode "ERROR"
					errorCode "ERROR" "Source Code has already been selected"
					errorCode "HINT" "command"
					errorCode "HINT" "add <source>"
					;;
				already)
					errorCode "ERROR"
					errorCode "ERROR" "No need to add ${thr} again"
					;;
				*)
					errorCode "ERROR"
					errorCode "ERROR" "Please select a file to edit"
					;;
			esac
			;;
		editMe)
			errorCode "WARNING"
			errorCode "WARNING" "For your safety, I am not allowed to edit myself"
			;;
		readNull)
			errorCode "HINT" "command"
			errorCode "HINT" "${ReadBy}"
			errorCode "HINT" "or"
			errorCode "HINT" "command"
			errorCode "HINT" "read"
			errorCode "HINT" "or"
			errorCode "HINT" "command"
			errorCode "HINT" "read <file>"
			errorCode "HINT" "or"
			errorCode "HINT" "command"
			errorCode "HINT" "${ReadBy} <file>"

			;;
		readNot)
			errorCode "ERROR"
			errorCode "ERROR" "code is not found in project"
			;;
		project)
			shift
			local thr=$1
			case ${sec} in
				must-be-active)
					errorCode "ERROR"
					errorCode "ERROR" "Must have an active project"
					;;
				already-title)
					errorCode "ERROR"
					errorCode "ERROR" "The \"${thr}\" project already has a title"
					;;
				no-title)
					errorCode "ERROR"
					errorCode "ERROR" "project title not given"
					;;
				none)
					errorCode "ERROR"
					errorCode "ERROR" "Your session MUST be a Project"
					errorCode "ERROR" "\tPlease create or load a project"
					errorCode "HINT" "command"
					errorCode "HINT" "project new <project>"
					errorCode "HINT" "\tor"
					errorCode "HINT" "command"
					errorCode "HINT" "project load <project>"
					;;
				type)
					errorCode "ERROR"
					errorCode "ERROR" "Could not create project type: \"${thr}\""
					;;
				active)
					errorCode "ERROR"
					errorCode "ERROR" "There are no active projects"
					;;
				can-not-leave)
					errorCode "ERROR"
					errorCode "ERROR" "Leaving your project is not allowed"
					;;
				recover)
					shift
					local four=$1
					case ${thr} in
						link-nothing)
							errorCode "ERROR"
							errorCode "ERROR" "\"${four}\" is not a working directory"
							;;
						no-path)
							errorCode "ERROR"
							errorCode "ERROR" "no path Given"
							;;
						no-name)
							errorCode "ERROR"
							errorCode "ERROR" "no project name given"
							errorCode "HINT" "command"
							errorCode "HINT" "project <name> <path>"
							;;
						name-in-path)
							errorCode "ERROR"
							errorCode "ERROR" "\"${four}\" must be in the directory of \"${five}\""
							errorCode "HINT"
							errorCode "HINT" "/path/to/${four}/src"
							;;
						exists)
							errorCode "ERROR"
							errorCode "ERROR" "You Already have a project named \"${four}\""
							;;
						*)
							echo "no"
							;;
					esac
					;;
				export)
					shift
					local four=$1
					case ${thr} in
						unable=to-exportn)
							errorCode "ERROR"
							errorCode "ERROR" "Unable to include export project"
							;;
						corrupted)
							errorCode "ERROR"
							errorCode "ERROR" "Project File Corrupted"
							;;
						already)
							errorCode "ERROR"
							errorCode "ERROR" "Export of project ${four} has already been made"
							;;
						not-project|not-found)
							errorCode "ERROR"
							errorCode "ERROR" "project \"${four}\" not found"
							;;
						*)
							;;
					esac
					;;
				import)
					shift
					local four=$1
					case ${thr} in
						nothing-given)
							errorCode "ERROR"
							errorCode "ERROR" "Please provide a project name"
							errorCode "HINT"
							errorCode "HINT" "command"
							errorCode "HINT" "project import <nane>"
							;;
						not-supported)
							errorCode "ERROR"
							errorCode "ERROR" "Language in ${four} project is not supported"
							;;
						already)
							errorCode "ERROR"
							errorCode "ERROR" "${four} project already exists"
							;;
						not-found)
							errorCode "ERROR"
							errorCode "ERROR" "Unable to locate exports directory"
							;;
						corrupted)
							errorCode "ERROR"
							errorCode "ERROR" "Project Corrupted"
							;;
						*)
							;;
					esac
					;;
				load)
					shift
					local four=$1
					case ${thr} in
						no-path)
							errorCode "ERROR"
							errorCode "ERROR" "Project \"${four}\" Directory not Found"
							;;
						no-project)
							errorCode "ERROR"
							errorCode "ERROR" "Not \"${four}\" a valid project"
							;;
						*)
							;;
					esac
					;;
				link)
					shift
					local four=$1
					case ${thr} in
						unable-link)
							if [ ! -z "${four}" ]; then
								errorCode "ERROR"
								errorCode "ERROR" "Unable to link \"${four}\""
								errorCode "ERROR" "May have already been linked"
							else
								errorCode "ERROR"
								errorCode "ERROR" "Please provide language"
								errorCode "HINT" "command"
								errorCode "HINT" "project link <lang>"
							fi
							;;
						not-link)
							if [ ! -z "${four}" ]; then
								errorCode "ERROR"
								errorCode "ERROR" "Unable to swap to \"${four}\""
								echo ""
								errorCode "ERROR" "Please link ${four}"
								errorCode "HINT" "command"
								echo "project link ${four}"
							else
								errorCode "ERROR"
								errorCode "ERROR" "Please provide language"
								errorCode "HINT" "command"
								errorCode "HINT" "project swap <lang>"
							fi
							;;
						*)
							;;
					esac
					;;
				not-exist)
					errorCode "ERROR"
					errorCode "ERROR" "Unable to create your project \"${thr}\""
					;;
				exists)
					errorCode "ERROR"
					errorCode "ERROR" "\"${thr}\" is already a project"
					;;
				NotAProject)
					errorCode "ERROR"
					errorCode "ERROR" "No \"${thr}\" project found"
					;;
				not-valid)
					errorCode "ERROR"
					errorCode "ERROR" "\"${thr}\" is Not a valid project"
					;;
				*)
					errorCode "ERROR"
					errorCode "ERROR" "Project error"
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
					echo -en "\e[5;41mERROR\e[0m"
					echo -e "\e[1;31m]\e[0m"
					echo -e "\e[1;31m${ERROR}\e[0m"
					;;
				Verbose)
					shift
					local thr=$@
					local Verbose=$(echo ${thr} | tr '|' '\n')
					echo -en "\e[1;32m[\e[0m"
					echo -en "\e[1;42mVerbose\e[0m"
					echo -e "\e[1;32m]\e[0m"
					echo -e "\e[1;32m${Verbose}\e[0m"
					;;
				choose)
					errorCode "ERROR"
					errorCode "ERROR" "please choose a program name"
					errorCode "HINT" "command"
					errorCode "HINT" "set <code>"
					;;
				C++Version)
					shift
					local thr=$@
					errorCode "cpl" "ERROR" "${thr[@]}"
					echo ""
					errorCode "HINT"
					errorCode "HINT" "Set C++ version with the following command"
					errorCode "HINT" "command"
					errorCode "HINT" "create cpl"
					echo ""
					errorCode "HINT"
					errorCode "HINT" "In case a C++ version is already chosen, please reset"
					errorCode "HINT" "command"
					errorCode "HINT" "create reset cpl"
					echo ""
					errorCode "HINT"
					errorCode "HINT" "Compile C++ with a one-time argument"
					errorCode "HINT" "command"
					errorCode "HINT" "cpl --args -std=c++<version>"
					;;
				cpl-args)
					errorCode "WARNING"
					errorCode "WARNING" "No compile/interpeter flags at this moment"
					;;
				already)
					shift
					local thr=$1
					errorCode "ERROR"
					errorCode "ERROR" "\"${thr}\" already compiled"
					;;
				not)
					errorCode "ERROR"
					errorCode "ERROR" "Code not found"
					;;
				no-name)
					errorCode "ERROR"
					errorCode "ERROR" "No \"main\" file found"
					errorCode "HINT" "command"
					errorCode "HINT" "cpl <code>"
					;;
				cli-need)
					shift
					local thr=$1
					errorCode "ERROR"
					errorCode "ERROR" "${thr} code is not compiled"
					;;
				need)
					shift
					local thr=$1
					errorCode "ERROR"
					errorCode "ERROR" "${thr} code is not compiled"
					errorCode "HINT" "command"
					errorCode "HINT" "cpl"
					;;
				none)
					errorCode "ERROR"
					errorCode "ERROR" "no code to run"
					errorCode "HINT" "command"
					errorCode "HINT" "set <code>"
					;;
				*)
					errorCode "ERROR"
					errorCode "ERROR" "Nothing to Compile"
					errorCode "HINT" "command"
					errorCode "HINT" "set <name>"
					;;
			esac
			;;
		cli-cpl)
			case ${sec} in
				none)
					errorCode "ERROR"
					errorCode "ERROR" "Source code not found"
					;;
				*)
					;;
			esac
			;;
		loadSession)
			errorCode "ERROR"
			errorCode "ERROR" "No Session to load"
			;;
		backup)
			case ${sec} in
				null)
					errorCode "ERROR"
					errorCode "ERROR" "No source code given"
					;;
				exists)
					errorCode "ERROR"
					errorCode "ERROR" "Back-up file already exists"
					;;
				wrong)
					errorCode "ERROR"
					errorCode "ERROR" "Please choose the correct source file"
					;;
				*)
					;;
			esac
			;;
		restore)
			case ${sec} in
				null)
					errorCode "ERROR"
					errorCode "ERROR" "No source code given"
					;;
				exists)
					errorCode "ERROR"
					errorCode "ERROR" "No back-up file found"
					;;
				wrong)
					errorCode "ERROR"
					errorCode "ERROR" "Please choose the correct source file"
					;;
				*)
					;;
			esac
			;;
		no-langs)
			errorCode "lang" "no-langs"
			;;
		not-a-lang)
			errorCode "lang" "not-a-lang"
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
							errorCode "ERROR"
							errorCode "ERROR" "Please provide a new language"
							errorCode "HINT" "command"
							errorCode "HINT" "create <lang>"
							;;
						not-supported)
							errorCode "lang" "cli-not-supported" "${four}"
							;;
						already-supported)
							errorCode "lang" "already-supported" "${four}"
							;;
						*)
							errorCode "ERROR"
							errorCode "ERROR" "Adding Language Support error"
							;;
					esac
					;;
				*)
					;;
			esac
			;;
		no-support)
			errorCode "ERROR"
			errorCode "ERROR" "The following feature is not yet supported"
			errorCode "ERROR" "Feature: ${sec}"
			;;
		HINT)
			local message=$@
			case ${sec} in
				command)
					echo -en "\e[1;32m[\e[0m"
					echo -en "\e[1;42mHINT\e[0m"
					echo -en "\e[1;32m]:\e[0m \$ "
					;;
				*)
					if [ -z "${sec}" ]; then
						echo -en "\e[1;32m[\e[0m"
						echo -en "\e[1;42mHINT\e[0m"
						echo -en "\e[1;32m]:\e[0m "
					else
						echo -e "\e[1;32m${message[@]}\e[0m"
					fi
					;;
			esac
			;;
		ERROR)
			local message=$@
			if [ -z "${sec}" ]; then
				echo -en "\e[1;31m[\e[0m"
				echo -en "\e[1;41mERROR\e[0m"
				echo -en "\e[1;31m]:\e[0m "
			else
				echo -e "\e[1;31m${message[@]}\e[0m"
			fi
			;;
		WARNING)
			local message=$@
			if [ -z "${sec}" ]; then
				echo -en "\e[1;33m[\e[0m"
				echo -en "\e[1;43mWARNING\e[0m"
				echo -en "\e[1;33m]:\e[0m "
			else
				echo -e "\e[1;33m${message[@]}\e[0m"
			fi
			;;
		*)
			;;
	esac
}

errorCode $@
