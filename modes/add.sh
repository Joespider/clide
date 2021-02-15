Shell=$(which bash)
#!${Shell}

IDE=$(echo -e "\e[1;43madd\e[0m")
Name="cl[${IDE}]"

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

#IDE
Add()
{
	local prompt=""
	local UserArg=""
	local component=""
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
