#!/bin/bash

Version="0.1.1"

Help()
{
	echo "Author: Joespider"
	echo "Program: \"newBash\""
	echo "Version: ${Version}"
	echo "Purpose: make new Bash Scripts"
	echo "Usage: newBash <args>"
	echo -e "\t-n <name> : script name"
	echo -e "\t--name <name> : script name"
	echo -e "\t--pipe : enable piping"
	echo -e "\t--random : enable random (1 - 10)"
}

GetPipe()
{
	echo "if readlink /proc/$$/fd/0 | grep -q \"^pipe:\"; then"
	echo -e	"\techo \"[piped]\""
	echo -e "\techo \"{\""
	echo -e "\tcat /dev/stdin"
	echo -e "\techo \"}\""
	echo "else"
	echo -e "\techo \"nothing was piped in\""
	echo "fi"
	echo ""
}

GetRandom()
{
	#random between 0 and 10
	echo "num=\"\$((( RANDOM % 10) + 0 ))\""
	echo "echo \${num}"
	echo ""
}

main()
{
	local GetName="no"
	local UsePipe="no"
	local UseRandom="no"
	local TheName=""

	for arg in "$@"; do
		case ${arg} in
			-n|--name)
				GetName="yes"
				;;
			--pipe)
				UsePipe="yes"
				;;
			--random)
				UseRandom="yes"
				;;
			*)
				case ${GetName} in
					yes)
						TheName="${arg}"
						GetName="no"
						;;
					*)
						;;
				esac
			;;
		esac
	done

	if [ ! -z "${TheName}" ]; then
		echo "#!/bin/bash" > "${TheName}.sh"
		echo "" >> "${TheName}.sh"

		case ${UsePipe} in
			yes)
				GetPipe >> "${TheName}.sh"
				;;
			*)
				;;
		esac

		case ${UseRandom} in
			yes)
				GetRandom >> "${TheName}.sh"
				;;
			*)
				;;
		esac
	else
		Help
	fi
}

main $@
