Shell=$(which bash)
#!${Shell}

Head="cl[ide]"
IDE=$(echo -e "\e[1;43mrepo\e[0m")
Name="cl[${IDE}]"

repoTool="git"
shift
CodeProject="testing"
shift
repoAssist="True"
shift
Branch=""


#Refresh page
Refresh=True

IsInstalled=$(which ${repoTool})
#check if git is installed
GitTool=$(which git)
#check if svn is installed
SvnTool=$(which svn)

Help()
{
	local Selection=$1
	case ${repoTool} in
		git)
			case ${Selection} in
				branch|branches)
					echo "help"
					echo "new"
					echo "remove, delete"
					echo "select, checkout"
					;;
				*)
					echo "GIT Help"
					echo ""
					echo "ActiveBranch"
					echo "use, init"
					echo "setup, clone"
					echo "add"
					echo "message, commit"
					echo "branch, branches"
					echo "upload, push"
					echo "download, pull"
					echo "state, status"
					echo "slamdunk"
					echo "help, options"
					echo "version"
					;;
			esac
			;;
		svn)
			echo "SVN Help"
			;;
		*)
			;;
	esac
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
		echo "\"${repoTool}\" is not installed"
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
						echo "Nothing to clone"
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
					git commit -m "\"${msg}\""
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
								gitHandler "branch" "checkout" "${name}"
							#no branch name given
							else
								echo "No Branch has been selected"
							fi
						fi
						;;
					help)
						Help "${repoAct}"
						;;
					#list all branches
					*)
						git branch -a
						;;
				esac
				;;
			upload|push)
				branch=$1
				if [ ! -z "${branch}" ]; then
					git push origin "${branch}"
				else
					if [ ! -z "${Branch}" ]; then
						gitHandler "push" "${branch}"
					else
						echo "Code not pushed; no branch found"
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
				gitHandler "add"
				gitHandler "commit"
				gitHandler "push"
				;;
			help|options)
				Help
				;;
			version)
				RepoVersion
				;;
			*)
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
	case ${repoAssist} in
		False)
			if [ ! -z "${IsInstalled}" ]; then
				$@
			else
				echo "\"${repoTool}\" is not installed"
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
			echo "repo version control has been disabled"
			;;
	esac
}

#IDE
Repo()
{
	local cRepoTool=$(colors ${repoTool})
	local cBranch
	local prompt=""
	local UserArg=""
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
			exit|close)
				break
				;;
			*)
				if [ ! -z "${UserIn[0]}" ]; then
					repoHandler ${UserIn[@]}
				fi
				;;
		esac
	done
}

#Repo IDE
Repo
