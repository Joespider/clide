Shell=$(which bash)
#!${Shell}

#Add submodule feature
#https://git-scm.com/book/en/v2/Git-Tools-Submodules
#git submodule add https://github.com/chaconinc/DbConnector

Head="cl[ide]"
IDE=$(echo -e "\e[1;43mrepo\e[0m")
Name="cl[${IDE}]"

shift
Branch=""

#Refresh page
Refresh=True

IsInstalled=$(which ${repoTool})
#check if git is installed
GitTool=$(which git)
#check if svn is installed
SvnTool=$(which svn)

#call help shell script
theHelp()
{
	${LibDir}/help.sh ${Head} ${LangsDir} ${RunCplArgs} RepoHelp $@
}

#call errorcode shell script
errorCode()
{
	${LibDir}/errorCode.sh $@
}

#Adjust colors
colors()
{
	local text=$1
	local IsBranch=$2
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
	if [ ! -z "${IsInstalled}" ]; then
		${repoTool} --version
	else
		errorCode "mode-repo" "${repoTool}" "not-installed"
	fi
}

#Handle Git commands
gitHandler()
{
	local repoAct=$1
	shift
	#Git is installed
	if [ ! -z "${GitTool}" ]; then
		case ${repoAct} in
			ActiveBranch)
				git branch 2> /dev/null| grep "*" | sed "s/* //g"
				;;
			#Create a new repo
			new|init)
				echo git init
				;;
			#clone a new repo
			use|clone)
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
						errorCode "mode-repo" "${repoTool}" "clone-nothing"
					fi
				fi
				;;
			#Add files to changes
			add)
				files=$@
				#Files given
				if [ ! -z "${files}" ]; then
					git add ${files[@]}
				else
					#Get ALL files from user
					git add .
				fi
				;;
			#Provide message for repo
			message|commit)
				#Get message
				msg=$@
				if [ ! -z "${msg}" ]; then
					git commit -m "\"${msg[@]}\""
				#No message found
				else
					git commit
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
							git checkout -b "${name}"
							#Refresh page
							Refresh=True
						else
							echo -n "Provide a branch name"
							read name
							if [ ! -z "${name}" ]; then
								gitHandler "${repoAct}" "${branchAct}" "${name}"
							else
								errorCode "mode-repo" "${repoTool}" "create-no-branch"
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
								gitHandler "${repoAct}" "${branchAct}" "${name}"
							#no branch name given
							else
								errorCode "mode-repo" "${repoTool}" "delete-no-branch"
							fi
						fi
						;;
					select|checkout)
						#Get branch name
						name=$1
						#branch name given
						if [ ! -z "${name}" ]; then
							#Select branch
							git checkout "${name}"
							#Refresh page
							Refresh=True
						#no branch name given
						else
							#Get user to type branch name
							echo -n "Provide a branch name"
							read name
							#branch name given
							if [ ! -z "${name}" ]; then
								#Select branch
								gitHandler "${repoAct}" "${branchAct}" "${name}"
							#no branch name given
							else
								errorCode "mode-repo" "${repoTool}" "select-no-branch"
							fi
						fi
						;;
					help)
						theHelp "${repoAct}"
						;;
					#list all branches
					*)
						git branch -a
						;;
				esac
				;;
			upload|push)
				local branch=$1
				if [ ! -z "${branch}" ]; then
					git push origin "${branch}"
				else
					if [ ! -z "${Branch}" ]; then
						gitHandler "${repoAct}" "${Branch}"
					else
						errorCode "mode-repo" "${repoTool}" "push-no-branch"
					fi
				fi
				;;
			#Download from the repo
			download|pull)
				git pull
				;;
			#Display repo infortmation
			state|status)
				git status
				;;
			#Peform quick and dirty commit
			slamdunk)
				local sure=$1
				local message
				case ${sure} in
					yes)
						shift
						message=$@
						gitHandler "add"
						gitHandler "commit" "${message[@]}"
						gitHandler "push"
						;;
					no)
						;;
					*)
						message=$@
						while true
						do
							errorCode "mode-repo" "${repoTool}" "not-install"
							errorCode "WARNING"
							errorCode "WARNING" "Are you sure? There is no stopping what is being done"
							errorCode "WARNING" "(yes/no)"
							echo -n " >"
							read sure
							sure=${sure,,}
							case ${sure} in
								yes|no)
									gitHandler "${repoAct}" "${sure}" "${message[@]}"
									break
									;;
								*)
									;;
							esac
						done
						;;
				esac
				;;
			help)
				theHelp
				;;
			version)
				RepoVersion
				;;
			*)
				;;
		esac
	#git is not installed
	else
		errorCode "mode-repo" "${repoTool}" "please-install"
	fi
}

svnHandler()
{
	local repoAct=$1
	shift
	#Git is installed
	if [ ! -z "${SvnTool}" ]; then
		echo "svn is installed"
	#svn is not installed
	else
		errorCode "mode-repo" "${repoTool}" "please-install"
	fi
}

repoHandler()
{
	case ${repoAssist} in
		False)
			if [ ! -z "${IsInstalled}" ]; then
				$@
			else
				errorCode "mode-repo" "${repoTool}" "not-install"
			fi
			;;
		True)
			case ${repoTool} in
				git)
					#git execution is handled by cl[ide]
					gitHandler $@
					;;
				svn)
					#svn execution is handled by user
					svnHandler $@
					;;
				*)
					;;
			esac
			;;
		*)
			errorCode "mode-repo" "${repoTool}" "disabled"
			;;
	esac
}

#IDE
Repo()
{
	local cRepoTool=$(colors ${repoTool})
	local cBranch
	local prompt
	local UserArg
	while true
	do
		case ${Refresh} in
			True)
				Branch=$(gitHandler "ActiveBranch")
				if [ -z "${Branch}" ]; then
					prompt="${Name}(${cRepoTool}):$ "
				else
					cBranch=$(colors "${Branch}" "branch")
					prompt="${Name}(${cRepoTool}{${cBranch}}):$ "
				fi
				Refresh=False
				;;
			*)
				;;
		esac
		#Handle CLI
		read -e -p "${prompt}" -a UserIn
		case ${UserIn[0]} in
			clear)
				clear
				;;
			exit|close)
				break
				;;
			*)
				if [ ! -z "${UserIn[0]}" ]; then
					repoHandler ${UserIn[@]}
		                        history -s "${UserIn[@]}"
				fi
				;;
		esac
	done
}

#Repo IDE
Repo
