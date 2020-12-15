Shell=$(which bash)
#!${Shell}

Head="cl[ide]"
IDE=$(echo -e "\e[1;43mrepo\e[0m")
Name="cl[${IDE}]"

colors()
{
	text=$1
	IsBranch=$2
	case ${text} in
		git)
			echo -e "\e[1;34m${text}\e[0m"
			;;
		svn)
			echo -e "\e[1;31m${text}\e[0m"
			;;
		*)
			case ${IsBranch} in
				branch)
					echo -e "\e[1;35m${text}\e[0m"
					;;
				*)
					;;
			esac
			;;
	esac
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

#Handle Git commands
gitHandler()
{
	local repoAct=$1
	shift
	#check if git is installed
	GitTool=$(which git)
	#Git is installed
	if [ ! -z "${GitTool}" ]; then
		case ${repoAct} in
			#Create a new repo
			new|init)
				echo git init
				;;
			#clone a new repo
			setup|clone)
				#Find repo name
				repo=$@
				if [ ! -z "${repo}" ]; then
					echo git clone ${repo[@]}
				#Repo not given
				else
					#Ask User for Repo
					echo -n "repo: "
					read -a repo
					#Repo given
					if [ ! -z "${repo}" ]; then
						#Run through 2nd time
						gitHandler "clone" "${repo[@]}"
					#Again...nothing
					else
						#Nothing to do
						echo "Nothing to clone"
					fi
				fi
				;;
			#Add files to changes
			add)
				files=$@
				#Files given
				if [ ! -z "${files}" ]; then
					echo git add ${files}
				else
					#Get ALL files from user
					echo git add .
				fi
				;;
			#Provide message for repo
			message|commit)
				#Get message
				msg=$@
				if [ ! -z "${msg}" ]; then
					echo git commit -m "\"${msg}\""
				#No message found
				else
					#As for user...get EVERYTHING typed
					echo -n "Message: "
					read -a msg
					#Message given
					if [ ! -z "${msg}" ]; then
						gitHandler "commit" "${msg[@]}"
					else
						echo "No message found"
					fi
				fi
				;;
			#Handles Git Branches
			branch|branches)
				branchAct=$1
				shift
				case ${branchAct} in
					new)
						name=$1
						if [ ! -z "${name}" ]; then
							echo git checkout -b "${name}"
						else
							echo -n "Provide a branch name"
							read name
							if [ ! -z "${name}" ]; then
								gitHandler "branch" "new" "${name}"
							else
								echo "No branch has been created"
							fi
						fi
						;;
					#delete branches on local repo
					remove|delete)
						#Get branch name
						name=$1
						#branch name given
						if [ ! -z "${name}" ]; then
							#remove branch
							echo git branch -d "${name}"
						#no branch name given
						else
							#Get user to type branch name
							echo -n "Provide a branch name"
							read name
							#branch name given
							if [ ! -z "${name}" ]; then
								#remove branch
								gitHandler "branch" "delete" "${name}"
							#no branch name given
							else
								echo "No Branch has been deleted"
							fi
						fi
						;;
					select|checkout)
						#Get branch name
						name=$1
						#branch name given
						if [ ! -z "${name}" ]; then
							#Select branch
							echo git checkout "${name}"
						#no branch name given
						else
							#Get user to type branch name
							echo -n "Provide a branch name"
							read name
							#branch name given
							if [ ! -z "${name}" ]; then
								#Select branch
								gitHandler "branch" "checkout" "${name}"
							#no branch name given
							else
								echo "No Branch has been selected"
							fi
						fi
						;;
					#list all branches
					*)
						echo git branch -a
						;;
				esac
				;;
			upload|push)
				branch=$1
				if [ ! -z "${branch}" ]; then
					echo git push origin "\"${branch}\""
				else
					echo -n "Please choose a banch: "
					read branch
					if [ ! -z "${branch}" ]; then
						gitHandler "push" "${branch}"
					else
						echo "Code not pushed"
					fi
				fi
				;;
			#Download from the repo
			download|pull)
				echo git pull
				;;
			#Display repo infortmation
			state|status)
				echo git status
				;;
			#Peform quick and dirty commit
			slamdunk)
				gitHandler "add"
				gitHandler "commit"
				gitHandler "push"
				;;
			help|options)
				echo "git help page"
				;;
			*)
				RepoVersion
				;;
		esac
	#git is not installed
	else
		echo "Please Install git"
	fi
}

svnHandler()
{
	local repoAct=$1
	shift
	#check if git is installed
	SvnTool=$(which svn)
	#Git is installed
	if [ ! -z "${SvnTool}" ]; then
		echo "svn is installed"
	#svn is not installed
	else
		echo "Please Install svn"
	fi
}

repoHandler()
{
	case ${repoTool} in
		git)
			#git execution is handled by user
			if [[ "${repoAssist}" == "False" ]] && [[ "$1" == "${repoTool}" ]]; then
				IsInstalled=$(which ${repoTool})
				if [ ! -z "${IsInstalled}" ]; then
					$@
				else
					echo "\"${repoTool}\" is not installed"
				fi
			#git execution is handled by cl[ide]
			elif [[ "${repoAssist}" == "True" ]]; then
				shift
				gitHandler $@
			else
				echo "repo version control has been disabled"
			fi
			;;
		svn)
			#svn execution is handled by user
			if [[ "${repoAssist}" == "False" ]] && [[ "$1" == "${repoTool}" ]]; then
				IsInstalled=$(which ${repoTool})
				if [ ! -z "${IsInstalled}" ]; then
					$@
				else
					echo "\"${repoTool}\" is not installed"
				fi
			#svn execution is handled by cl[ide]
			elif [[ "${repoAssist}" == "True" ]]; then
				shift
				svnHandler $@
			else
				echo "repo version control has been disabled"
			fi
			;;
		*)
			;;
	esac
}

#IDE
Repo()
{
	local repoTool=$1
	local cRepoTool=$(colors ${repoTool})
	local CodeProject=$2
	local Branch="master"
	local cBranch=$(colors "${Branch}" "branch")
	local prompt=""
	local UserArg=""
	while true
	do
		if [ -z "${Branch}" ]; then
			prompt="${Name}(${cRepoTool}):$ "
		else
			prompt="${Name}(${cRepoTool}{${cBranch}}):$ "
		fi
		#Handle CLI
		read -e -p "${prompt}" -a UserIn
		UserArg=$(echo ${UserIn[0]} | tr A-Z a-z)
		case ${UserArg} in
			#git/svn handler
			${repoTool}|repo)
				repoHandler ${UserIn[@]}
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

#Repo IDE
Repo $@
