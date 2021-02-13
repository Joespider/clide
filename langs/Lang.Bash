Shell=$(which bash)
#!${Shell}

SupportV="0.1.18"

ProgDir=$1
shift
ClideDir=$1
LibDir=${ClideDir}/lib
shift
editor=$1
shift
ReadBy=$1
shift
CodeProject=$1
shift
CplArgs=$1
shift

errorCode()
{
	${LibDir}/errorCode.sh $@
}

#Handle Aliases
AddAlias()
{
	${LibDir}/AddAlias.sh $@
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
		ProjectColor)
			local text=$1
			if [ ! -z "${text}" ]; then
				echo -e "\e[1;42m${text}\e[0m"
			fi
			;;
		SupportVersion)
			echo ${SupportV}
			;;
		MenuHelp)
			echo -e "new <file>\t\t\t: \"create new ${Lang} script\""
			echo -e "cpl, compile\t\t\t: \"make code executable\""
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
			local project=${CodeProject}
			#Get code
                        case ${project} in
                                none)
					if [ -f ${LangSrc}/${name}.sh ]; then
						echo ${name}.sh
					elif [ -f ${LangSrc}/${name} ]; then
						echo ${name}
					fi
					;;
				*)
					if [ -f ${LangSrc}/${project}/src/${name}.sh ]; then
						echo ${name}.sh
					elif [ -f ${LangSrc}/${project}/src/${name} ]; then
						echo ${name}
					fi
					;;
			esac
                        ;;
		BeforeFiles|AfterFiles)
				ls *.sh 2> /dev/null
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
				echo -e "-c, --custom\t\t\t: \"Custom src file using ${Lang} template\""
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
				echo "${TemplateCode##*/} "
				${TemplateCode} 2> /dev/null | grep Version | sed "s/Version//g"
			else
				echo "no ${TemplateCode##*/} found"
			fi
			;;
		CplVersion)
			echo "[Shell]"
			${BashCpl} --version | head -n 1
			echo ""
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
			local TheBinDir
			local ERROR
			#Handle Project Dir
			case ${project} in
				none)
					project=""
					TheBinDir=${LangBin}
					;;
				*)
					project="${project}/"
					TheBinDir="${LangSrc}/${project}bin"
					;;
			esac

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
								if [ ! -f "${TheBinDir}/${name}" ]; then
									#Change to Bash Binary dir
									cd ${TheBinLan}
									#Create Symbolic Link to Bash Script
									ERROR=$(ln -s ../src/${name} 2>&1 | tr '\n' '|')
									#Change to Bash Source dir
									cd - > /dev/null
									if [ -f "${TheBinDir}/${name}" ]; then
										echo -e "\e[1;42m[Bash Code Compiled]\e[0m"
									else
										ERROR=$(echo ${ERROR} | tr '|' '\n')
										echo -en "\e[1;31m[\e[0m"
										echo -en "\e[1;41mERROR\e[0m"
										echo -e "\e[1;31m]\e[0m"
										echo -e "\e[1;31m${ERROR}\e[0m"
									fi
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
						if [ ! -f "${TheBinDir}/${src}" ]; then
							#Change to Bash Binary dir
							cd ${TheBinDir}
							#Create Symbolic Link to Bash Script
							ERROR=$(ln -s ../src/${src} 2>&1 | tr '\n' '|')
							#Change to Bash Source dir
							cd - > /dev/null
							if [ -f "${TheBinDir}/${src}" ]; then
								echo -e "\e[1;42m[Bash Code Compiled]\e[0m"
							else
								ERROR=$(echo ${ERROR} | tr '|' '\n')
								echo -en "\e[1;31m[\e[0m"
								echo -en "\e[1;41mERROR\e[0m"
								echo -e "\e[1;31m]\e[0m"
								echo -e "\e[1;31m${ERROR}\e[0m"
							fi
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
			local project=$1
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
		lscpl)
			local project
			local path
			case ${CodeProject} in
				none)
					path=${LangBin}/
					;;
				*)
					project=${CodeProject}
					path=${LangSrc}/${project}/bin/
					;;
			esac
			if [ -d ${path} ]; then
				ls ${path}
			fi
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
			local cLang=$(UseBash "color")
			local cTemplate=$(OtherColor ${TemplateCode##*/})
			local Type=$(echo ${Type} | tr A-Z a-z)
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				echo -n "${cLang}\$ ./${cTemplate} "
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
						echo -e "#!/bin/bash\n" > ${name}.sh
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
			local project=${CodeProject}
			local TheBinDir
                        shift
                        local Args=$@
                        #Handle Project Dir
                        case ${project} in
                                none)
                                        project=""
                                        TheBinDir=${LangBin}
                                        ;;
                                *)
                                        project="${project}/"
                                        TheBinDir="${LangSrc}/${project}bin"
				;;
                        esac

			#Check if Bash Script exists
			if [ -f ${TheBinDir}/${name} ]; then
				${TheBinDir}/${name} ${Args[@]}
			else
				errorCode "cpl" "need" "${name}"
			fi
			;;
		backup)
			local name=$1
			if [ ! -z "${name}" ]; then
				if [ ! -f "${LangSrc}/${name}.bak" ]; then
					cp ${LangSrc}/${name} ${LangSrc}/${name}.bak
					echo "\"${name}\" backed-up"
				else
					errorCode "backup" "exists"
				fi
			else
				errorCode "backup" "null"
			fi
			;;
		restore)
			local name=$1
			if [ ! -z "${name}" ]; then
				if [ -f "${LangSrc}/${name}.bak" ]; then
					mv ${LangSrc}/${name}.bak ${LangSrc}/${name}
					echo "\"${name}\" restored"
				else
					errorCode "restore" "exists"
				fi
			else
				errorCode "restore" "null"
			fi
			;;
		rename)
			local TheOld=$1
			local TheNew=$2
			if [ ! -z "${TheNew}" ]; then
				TheOld="${TheOld%.sh}"
				TheNew="${TheNew%.sh}"
				mv ${LangSrc}/${TheOld}.sh ${LangSrc}/${TheNew}.sh
				echo ${TheNew}.sh
			fi
			;;
		copy)
			local TheOld=$1
			local TheNew=$2
			if [ ! -z "${TheNew}" ]; then
				TheOld="${TheOld%.sh}"
				TheNew="${TheNew%.sh}"
				cp ${LangSrc}/${TheOld}.sh ${LangSrc}/${TheNew}.sh
				echo ${TheNew}.sh
			fi
			;;
		*)
			;;
	esac
}

UseBash $@
