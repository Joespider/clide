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

UseBash()
{
	local BashCpl=bash
	local LangHome=${ProgDir}/Bash
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local TemplateCode=${LangBin}/newBash.sh
	local Type=$1
	shift
	case ${Type} in
		color)
			#Return Green
			echo -e "\e[1;32mBash\e[0m"
			;;
		MenuHelp)
			echo -e "new <file>\t\t\t: \"create new ${Lang} script\""
			echo -e "compile|cpl\t\t\t: \"make code executable\""
			;;
		pgLang)
			HasLang=$(which ${BashCpl} 2> /dev/null)
			if [ ! -z "${HasLang}" ]; then
				#Return Bash tag
				echo "Bash"
			else
				#Return rejection
				echo "no"
			fi
			;;
		getCode)
			local name=$1
			#Get code
			if [ -f ${LangSrc}/${name}.sh ]; then
				echo ${name}.sh
			elif [ -f ${LangSrc}/${name} ]; then
				echo ${name}
			fi
			;;
		BeforeFiles|AfterFiles)
				ls *.sh
			;;
		pgDir)
			#Return Bash src Dir
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
			if [ ! -d "${LangHome}" ] && [ ! -z "${BashCpl}" ]; then
				mkdir "${LangHome}"
			fi
			#Src
			if [ ! -d "${LangSrc}" ] && [ ! -z "${BashCpl}" ]; then
				mkdir "${LangSrc}"
			fi
			#Bin
			if [ ! -d "${LangBin}" ] && [ ! -z "${BashCpl}" ]; then
				mkdir "${LangBin}"
			fi
			;;
		TemplateVersion)
			if [ -f ${TemplateCode} ]; then
				${TemplateCode} 2> /dev/null | grep Version
			else
				echo "no newBash.sh found"
			fi
			;;
		CodeVersion)
			echo "[Bash]"
			${BashCpl} --version | head -n 1
			;;
		selectCode)
			local name=$1
			#Correct filename
			if [[ ! "${name}" == *".sh" ]]; then
				name="${name}.sh"
			fi
			echo ${name}
			;;
			#Add code to active session
		addCode)
			local src=$1
			local new=$2
			case ${src} in
				*.sh)
					case ${new} in
						*.sh)
							if [ -f "${new}" ]; then
							echo "${src},${new}"
						else
							echo "${src}"
						fi
						;;
					*)
						if [ -f "${new}.sh" ]; then
							echo "${src},${new}.sh"
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
			local src=$1
			local num=$2
			case ${src} in
				*.sh)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "editNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".sh" ]]; then
									${editor} ${num}
								else
									${editor} "${num}.sh"
								fi
							else
								errorCode "editNot"
							fi
						fi
					else
						case ${src} in
							clide.sh)
								errorCode "editMe"
							;;
						*)
								${editor} ${src}
								;;
						esac
					fi
					;;
				*)
					;;
			esac
			;;
		readCode)
			local src=$1
			local num=$2
			case ${src} in
				*.sh)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "readNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".sh" ]]; then
									${ReadBy} ${num}
								else
									${ReadBy} "${num}.sh"
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
			local src=$1
			local project=${CodeProject}
			local name=$2
			local keep=$3
			local cplArgs=""
			#Handle Project Dir
			if [[ "${project}" == "none" ]]; then
				project=""
			else
				project="${project}/"
			fi
			case ${src} in
				*.sh)
					#Multiple code selected
					if [[ "${src}" == *","* ]]; then
						#varable is empty
						if [ -z ${name} ]; then
							errorCode "cpl" "choose"
						else
							#chosen file is in the list of files
							if [[ "${src}" == *"${name}"* ]]; then
								#only name is given
								if [[ "${name}" != *".sh" ]]; then
									#full filename given
									num=${name}.sh
								fi
								#Make Bash Script executable
								chmod +x ${name}
								#Check if Bash Script does NOT exist
								if [[ ! -f "${LangBin}/${name}" ]]; then
									#Change to Bash Binary dir
									cd ${LangBin}
									#Create Symbolic Link to Bash Script
									ln -s ../src/${project}${name}
									#Change to Bash Source dir
									cd "${LangSrc}/${project}"
									echo -e "\e[1;42m[Bash Code Compiled]\e[0m"
								else
									errorCode "cpl" "already" ${name}
								fi
							else
								errorCode "cpl" "not"
							fi
						fi
					#single code selected
					else
						#Make Bash Script executable
						chmod +x ${src}
						#Check if Bash Script does NOT exist
						if [[ ! -f "${LangBin}/${src}" ]]; then
							#Change to Bash Binary dir
							cd ${LangBin}
							#Create Symbolic Link to Bash Script
							ln -s ../src/${project}${src}
							#Change to Bash Source dir
							cd "${LangSrc}/${project}"
							echo -e "\e[1;42m[Bash Code Compiled]\e[0m"
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
			local path=${LangSrc}/${project}
			if [ ! -d ${path} ]; then
				mkdir ${path}
				cd ${path}
				mkdir src bin
				cd ${path}/src
			else
				cd ${path}/srs
			fi
			echo ${path}
			;;
		SwapToSrc)
			local src=$1
			echo "${src}"
			;;
		SwapToBin)
			local bin=$1
			case ${bin} in
				*.sh)
					#Check if Bash Binary exists
					if [ -f "${LangBin}/${bin}" ]; then
						#Return Bash Binary Name
						#cd "${LangBin}"
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
			local bin=$1
			local BinFile="${bin%.*}"
			#Make sure Binary exists
			if [ -f "${LangBin}/${bin}" ]; then
				#Add command to Aliases
				AddAlias "${BinFile}" "${LangBin}/${bin}"
			elif [ ! -f "${LangBin}/${bin}" ]; then
				errorCode "install" "${bin}"
			else
				errorCode "noCode"
			fi
			;;
		customCode)
			local cLang=$1
			local Type=$(echo ${Type} | tr A-Z a-z)
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				echo -n "${cLang}\$ ./newBash.sh "
				read -a Args
				#Template Args Given
				if [ ! -z "${Args}" ];then
					${TemplateCode} ${Args[@]}
				#No Template Args Given
				else
					${TemplateCode} --help
				fi
			else
				#Program Name Given
				errorCode "customCode" "notemp" "${Lang}"
			fi
			;;
		newCode)
			local name=$1
			local Project=$2
			local Type=$3
			Type=$(echo ${Type} | tr A-Z a-z)
			name=${name%.sh}
			if [ ! -f ${name}.sh ]; then
				#Check for Custom Code Template
				if [ -f ${TemplateCode} ]; then
					#Program Name Given
					if [ ! -z "${name}" ];then
						${TemplateCode} ${name} > ${name}.sh
					#No Program Name Given
					else
						${TemplateCode} --help
					fi
				else
					#Program Name Given
					if [ ! -z "${name}" ];then
						touch ${name}.sh
					else
						errorCode "newCode"
					fi
				fi
			fi
			;;
		cli)
			local TheName=$(OtherColor $1)
			echo "./${TheName}"
			;;
		runCode)
			local name=$1
			shift
			Args=$@
			#Check if Bash Script exists
			if [ -f ${LangBin}/${name} ]; then
				${LangBin}/${name} ${Args[@]}
			else
				errorCode "cpl" "need" "${name}"
			fi
			;;
		*)
			;;
	esac
}

UseBash $@
