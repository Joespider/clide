Shell=$(which bash)
#!${Shell}

ThisFile=$0

#Add submodule feature
#https://git-scm.com/book/en/v2/Git-Tools-Submodules
#git submodule add https://github.com/chaconinc/DbConnector

Head="cl[ide]"
IDE=$(echo -e "\e[1;43mpkg\e[0m")
Name="cl[${IDE}]"

TheDistro=$(lsb_release -i 2> /dev/null | cut -f 2)

shift

#Refresh page
Refresh=True

GetPkgMgr()
{
	case ${TheDistro,,} in
		linuxmint|ubuntu|debian)
			echo "apt-get"
			;;
		*)
			;;
	esac
}

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
	local mamager=$1
#	local IsBranch=$2
	case ${mamager} in
		apt-get)
			echo -e "\e[1;34m${mamager}\e[0m"
			;;
#		svn)
#			echo -e "\e[1;31m${text}\e[0m"
#			;;
		*)
#			case ${IsBranch} in
#				branch)
#					echo -e "\e[1;35m${text}\e[0m"
#					;;
#				*)
#					;;
#			esac
			;;
	esac
}

pkgHandler()
{
	echo $@
}

#IDE
PgkMgr()
{
	local ThePkgMgr=$(GetPkgMgr)
	local cPkgMgr
	local cBranch
	local prompt
	local UserArg

	if [ ! -z "${ThePkgMgr}" ]; then
		cPkgMgr=$(colors ${ThePkgMgr})
		while true
		do
			case ${Refresh} in
				True)
					prompt="${Name}(${cPkgMgr}):$ "
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
						pkgHandler ${UserIn[@]}
		        	                history -s "${UserIn[@]}"
					fi
					;;
			esac
		done
	else
		errorCode "mode-pkg" "no-manager" "${TheDistro}"
	fi
}

#PgkMgr IDE
PgkMgr
