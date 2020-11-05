Shell=$(which bash)
#!${Shell}

ProgDir=$1
shift
ClideDir=$1
shift
editor=$1
shift
ReadBy=$1
shift
project=$1
shift
CplArgs=$1
shift

SupportVersion()
{
        echo "0.1.0"
}

errorCode()
{
        ${ClideDir}/errorCode.sh $@
}

OtherColor()
{
	local text=$1
	#Return Purple
	echo -e "\e[1;35m${text}\e[0m"
}

UsePerl()
{
	local PerlRun=perl
	local LangHome=${ProgDir}/Perl
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local TemplateCode=${LangBin}/newPerl.pl
	local Type=$1
	shift
	case ${Type} in
		color)
			#Return Purple
			echo -e "\e[1;35mPerl\e[0m"
			;;
		MenuHelp)
			echo -e "new <file>\t\t\t: \"create new ${Lang} script\""
			echo -e "compile|cpl\t\t\t: \"make code executable\""
			;;
		getCode)
			local name=$1
			if [ -f ${LangSrc}/${name}.pl ]; then
				echo ${name}.pl
			elif [ -f ${LangSrc}/${name} ]; then
				echo ${name}
			fi
			;;
		BeforeFiles|AfterFiles)
			ls *.pl
			;;
		pgLang)
			local HasLang=$(which ${PerlRun} 2> /dev/null)
			if [ ! -z "${HasLang}" ]; then
				#Return Perl tag
				echo "Perl"
			else
				#Return rejection
				echo "no"
			fi
			;;
		pgDir)
			#Return Perl src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
			;;
		shell)
			;;
		newCodeHelp)
			if [ -f ${TemplateCode} ]; then
				echo -e "--custom|-c\t\t\t: \"Custom src file using ${Lang} template\""
			fi
			;;
		EnsureDirs)
			#Home
			if [ ! -d "${LangHome}" ] && [ ! -z "${PerlRun}" ]; then
				mkdir "${LangHome}"
			fi
			#Src
			if [ ! -d "${LangSrc}" ] && [ ! -z "${PerlRun}" ]; then
				mkdir "${LangSrc}"
			fi
			#Bin
			if [ ! -d "${LangBin}" ] && [ ! -z "${PerlRun}" ]; then
				mkdir "${LangBin}"
			fi
			;;
		TemplateVersion)
			if [ -f ${TemplateCode} ]; then
				${PerlRun} ${TemplateCode} 2> /dev/null | grep Version
			else
				echo "no newPerl found"
			fi
			;;
		CodeVersion)
			echo "[Perl]"
			${PerlRun} --version 2> /dev/null | grep Version
			;;
		selectCode)
			name=$1
			#Correct filename
			if [[ ! "${name}" == *".pl" ]]; then
				name="${name}.pl"
			fi
			echo ${name}
			;;
		addCode)
			src=$1
			new=$2
			case ${src} in
				*.pl)
					case ${new} in
						*.pl)
							if [ -f "${new}" ]; then
								echo "${src},${new}"
							else
								echo "${src}"
							fi
							;;
						*)
							if [ -f "${new}.pl" ]; then
								echo "${src},${new}.pl"
							else
								echo "${src}"
							fi
							;;
					esac
					;;
				*)
					;;
			esac
			;;
		editCode)
			src=$1
			num=$2
			case ${src} in
				*.pl)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "editNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".pl" ]]; then
									${editor} ${num}
								else
									${editor} "${num}.pl"
								fi
							else
								errorCode "editNot"
							fi
						fi
					else
						${editor} ${src}
					fi
					;;
				*)
					;;
			esac
			;;
		readCode)
			src=$1
			num=$2
			case ${src} in
				*.pl)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "readNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".pl" ]]; then
									${ReadBy} ${num}
								else
									${ReadBy} "${num}.pl"
								fi
							else
								errorCode "readNot"
							fi
						fi
					else
						${ReadBy} ${src}
					fi
					;;
				*)
					;;
			esac
			;;
		compileCode)
			src=$1
			project=${CodeProject}
			name=$2
			keep=$3
			cplArgs=""
			#Handle Project Dir
			if [[ "${project}" == "none" ]]; then
				project=""
			else
				project="${project}/"
			fi
			case ${src} in
				*.pl)
					#Multiple code selected
					if [[ "${src}" == *","* ]]; then
						#variable is empty
						if [ -z ${name} ]; then
							errorCode "cpl" "choose"
						#variable found
						else
							#chosen file is in the list of files
							if [[ "${src}" == *"${name}"* ]]; then
								#only name is given
								if [[ "${name}" != *".pl" ]]; then
									#full filename given
									num=${name}.pl
								fi
								#Make Perl Script executable
								chmod +x ${name}
								#Check if Perl Script does NOT exist
								if [[ ! -f "${LangBin}/${name}" ]]; then
									#Change to Perl Binary dir
									cd ${LangBin}
									#Create Symbolic Link to Perl Script
									ln -s ../src/${project}${name}
									#Change to Perl Source dir
									cd "${LangSrc}/${project}"
									echo -e "\e[1;45m[Perl Code Compiled]\e[0m"
								else
									errorCode "cpl" "already" ${name}
								fi
							else
								echo "code not found"
							fi
						fi
					#single code selected
					else
						#Make Perl Script executable
						chmod +x ${src}
						#Check if Perl Script does NOT exist
						if [[ ! -f "${LangBin}/${src}" ]]; then
							#Change to Perl Binary dir
							cd ${LangBin}
							#Create Symbolic Link to Perl Script
							ln -s ../src/${project}${src}
							#Change to Perl Source dir
							cd "${LangSrc}/${project}"
							echo -e "\e[1;45m[Perl Code Compiled]\e[0m"
							#Code is already found
						else
							errorCode "cpl" "already" ${src}
						fi
					fi
					;;
				*)
					;;
			esac
			;;
		newProject)
			path=${LangSrc}/${project}
			if [ ! -d ${path} ]; then
				mkdir ${path}
				cd ${path}
				mkdir src bin
				cd ${path}/src
			else
				cd ${path}/src
			fi
			echo ${path}
			;;
		SwapToSrc)
			src=$1
			#Get Perl Name
			echo "${src}"
			;;
		SwapToBin)
			bin=$1
			case ${bin} in
				*.pl)
					#Get Perl Name
					#	bin="${bin%.*}"
					#Check if Perl Binary exists
					if [[ -f "${LangBin}/${bin}" ]]; then
						#cd "${LangBin}"
						#Return Perl Binary Name
						echo "${bin}"
					else
						echo "${bin}"
					fi
					;;
				*)
					echo ${bin}
					;;
			esac
			;;
		Install)
			bin=$1
			BinFile="${bin%.*}"
			#Make sure Binary exists
			if [ -f "${LangBin}/${bin}" ]; then
				#Add command to Aliases
				AddAlias "${BinFile}" "${PerlRun} ${LangBin}/${bin}"
			elif [ ! -f "${LangBin}/${bin}" ]; then
				errorCode "install" "${bin}"
			else
				errorCode "noCode"
			fi
			;;
		customCode)
			cLang=$1
			if [ -f ${TemplateCode} ]; then
				echo -n "${cLang}\$ ${PerlRun} newPerl.pl "
				read -a Args
				#Program Args Given
				if [ ! -z "${Args}" ];then
					${PerlRun} ${TemplateCode} ${Args[@]}
				#No Program Name Given
				else
					${PerlRun} ${TemplateCode} --help
				fi
			else
				#Program Name Given
				errorCode "customCode" "notemp" "${Lang}"
			fi
			;;
		newCode)
			name=$1
			Project=$2
			Type=$3
			Type=$(echo ${Type} | tr A-Z a-z)
			name=${name%.pl}
			if [ ! -f ${name}.pl ]; then
				#Check for Custom Code Template
				if [ -f ${TemplateCode} ]; then
					#Program Name Given
					if [ ! -z "${name}" ];then
						${PerlRun} ${TemplateCode} --name ${name} --cli --main --write-file --read-file --os
					#No Program Name Given
					else
						${PerlRun} ${TemplateCode} --help
					fi
				else
					#Program Name Given
					if [ ! -z "${name}" ];then
						touch ${name}.pl
					else
						errorCode "newCode"
					fi
				fi
			fi
			;;
		cli)
			local TheName=$(OtherColor $2)
			echo "${PerlRun} ${TheName}"
			;;
		runCode)
			local name=$1
			local TheBin="${name}"
			shift
			local Arg=$@
			#Check if Perl Bin exists
			if [ -f ${LangBin}/${TheBin} ]; then
				${PerlRun} ${LangBin}/${TheBin} ${Args[@]}
			else
				errorCode "cpl" "need" "${name}"
			fi
			;;
		*)
			;;
	esac
}

UsePerl $@
