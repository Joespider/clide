Shell=$(which bash)
#!${Shell}

SupportV="0.1.29"

ProgDir=$1
shift
ClideDir=$1
LibDir=${ClideDir}/lib
VarDir=${ClideDir}/var
shift
editor=$1
shift
ReadBy=$1
shift
CodeProject=$1
shift
ProjectType=$1
shift
TemplateProjectDir=$1
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

UsePerl()
{
	local Lang=Perl
	local LangConfig=$(grep ${Lang} ${VarDir}/clide.conf | sed "s/${Lang}=//1")
	local LangRun=${LangConfig}

#	local LangRun=perl
	local LangHome=${ProgDir}/${Lang}
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local LangExt=".pl"
	local TemplateCode=${LangBin}/new${Lang}${LangExt}
	local Type=$1
	shift
	case ${Type} in
		color)
			#Return Purple
			echo -e "\e[1;35m${Lang}\e[0m"
			;;
		ProjectColor)
			echo -e "\e[1;45m${CodeProject}\e[0m"
			;;
		getExt)
			echo ${LangExt}
			;;
		SupportVersion)
			echo ${SupportV}
			;;
		MenuHelp)
			echo -e "new <file>\t\t\t: \"create new ${Lang} script\""
			echo -e "cpl, compile\t\t\t: \"make code executable\""
			;;
		getCode)
			local name=$1
			case ${CodeProject} in
				none)
					if [ -f ${LangSrc}/${name}${LangExt} ]; then
						echo ${name}${LangExt}
					elif [ -f ${LangSrc}/${name} ]; then
						echo ${name}
					fi
					;;
				*)
					if [ -f ${LangSrc}/${CodeProject}/src/${name}${LangExt} ]; then
						echo ${name}${LangExt}
					elif [ -f ${LangSrc}/${CodeProject}/src/${name} ]; then
						echo ${name}
					fi
					;;
			esac
			;;
		BeforeFiles|AfterFiles)
			ls *${LangExt} 2> /dev/null
			;;
		pgLang)
			local HasLang=$(which ${LangRun} 2> /dev/null)
			if [ ! -z "${HasLang}" ]; then
				#Return Perl tag
				echo "${Lang}"
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
				echo -e "-c, --custom\t\t\t: \"Custom src file using ${Lang} template\""
			fi
			;;
		EnsureDirs)
			#Home
			if [ ! -d "${LangHome}" ] && [ ! -z "${LangRun}" ]; then
				mkdir "${LangHome}"
			fi
			#Src
			if [ ! -d "${LangSrc}" ] && [ ! -z "${LangRun}" ]; then
				mkdir "${LangSrc}"
			fi
			#Bin
			if [ ! -d "${LangBin}" ] && [ ! -z "${LangRun}" ]; then
				mkdir "${LangBin}"
			fi
			;;
		TemplateVersion)
			if [ -f ${TemplateCode} ]; then
				echo -n "${TemplateCode##*/} "
				${LangRun} ${TemplateCode} 2> /dev/null | grep Version | sed "s/Version//g"
			else
				echo "no ${TemplateCode##*/} found"
			fi
			;;
		CplVersion)
			echo "[${Lang} Shell]"
			${LangRun} --version 2> /dev/null | grep Version
			echo ""
			;;
		selectCode)
			local name=$1
			#Correct filename
			if [[ ! "${name}" == *"${LangExt}" ]]; then
				name="${name}${LangExt}"
			fi
			#Return source file if exists
			if [ -f "${name}" ]; then
				echo "${name}"
			fi
			;;
		addCode)
			local src=$1
			local new=$2
			case ${src} in
				*${LangExt})
					case ${new} in
						*${LangExt})
							if [ -f "${new}" ]; then
								echo "${src},${new}"
							else
								echo "${src}"
							fi
							;;
						*)
							if [ -f "${new}${LangExt}" ]; then
								echo "${src},${new}${LangExt}"
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
				*${LangExt})
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "editNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *"${LangExt}" ]]; then
									${editor} ${num}
								else
									${editor} "${num}${LangExt}"
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
			local src=$1
			local num=$2
			case ${src} in
				*${LangExt})
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "readNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *"${LangExt}" ]]; then
									${ReadBy} ${num}
								else
									${ReadBy} "${num}${LangExt}"
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
			local name=$2
			local keep=$3
			local project=${CodeProject}
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
				*${LangExt})
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
								if [[ "${name}" != *"${LangExt}" ]]; then
									#full filename given
									num=${name}${LangExt}
								fi
								#Make Perl Script executable
								chmod +x ${name}
								#Check if Perl Script does NOT exist
								if [ ! -f "${TheBinDir}/${name}" ]; then
									#Change to Perl Binary dir
									cd ${TheBinDir}
									#Create Symbolic Link to Perl Script
									ERROR=$(ln -s ../src/${name} 2>&1 | tr '\n' '|')
									#Change to Perl Source dir
									cd - > /dev/null
									if [ -f "${TheBinDir}/${name}" ]; then
										echo -e "\e[1;45m[${Lang} Code Compiled]\e[0m"
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
								echo "code not found"
							fi
						fi
					#single code selected
					else
						#Make Perl Script executable
						chmod +x ${src}
						#Check if Perl Script does NOT exist
						if [ ! -f "${TheBinDir}/${src}" ]; then
							#Change to Perl Binary dir
							cd ${TheBinDir}
							#Create Symbolic Link to Perl Script
							ERROR=$(ln -s ../src/${src} 2>&1 | tr '\n' '|')
							#Change to Perl Source dir
							cd - > /dev/null
							if [ -f "${TheBinDir}/${src}" ]; then
								echo -e "\e[1;45m[${Lang} Code Compiled]\e[0m"
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
			local type=$1
			local project=$2
			local path=${LangSrc}/${project}
			if [ ! -d ${path} ]; then
				if [ -f ${TemplateProjectDir}/${Lang}.${type} ]; then
					${TemplateProjectDir}/${Lang}.${type} newProject ${project}
				else
					mkdir ${path}
					mkdir ${path}/src
					mkdir ${path}/bin
				fi
				cd ${path}/src
			else
				cd ${path}/src
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
					path=${LangSrc}/${project}/bin
					;;
			esac
			if [ -d ${path} ]; then
				ls ${path}
			fi
			;;
		SwapToSrc)
			src=$1
			#Get Perl Name
			echo "${src}"
			;;
		SwapToBin)
			bin=$1
			case ${bin} in
				*${LangExt})
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
			local project=${CodeProject}
			local TheBinDir
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
			#Make sure Binary exists
			if [ -f "${TheBinDir}/${bin}" ]; then
				#Add command to Aliases
				AddAlias "${BinFile}" "${LangRun} ${TheBinDir}/${bin}"
			elif [ ! -f "${TheBinDir}/${bin}" ]; then
				errorCode "install" "${bin}"
			else
				errorCode "noCode"
			fi
			;;
		customCode)
			local cLang=$(UsePerl "color")
			local cTemplate=$(OtherColor ${TemplateCode##*/})
			if [ -f ${TemplateCode} ]; then
				echo -n "${cLang}\$ ${LangRun} ${cTemplate} "
				read -a Args
				#Program Args Given
				if [ ! -z "${Args}" ];then
					${LangRun} ${TemplateCode} ${Args[@]}
				#No Program Name Given
				else
					${LangRun} ${TemplateCode} --help
				fi
			else
				#Program Name Given
				errorCode "customCode" "notemp" "${Lang}"
			fi
			;;
		newCode)
			local name=$1
			local Type=$2
			local oldCode=$3
			local project=${CodeProject}

			Type=$(echo ${Type} | tr A-Z a-z)
			name=${name%${LangExt}}
			if [ ! -f ${name}${LangExt} ]; then
				#Check for Custom Code Template
				if [ -f ${TemplateCode} ]; then
					#Program Name Given
					if [ ! -z "${name}" ];then
						${LangRun} ${TemplateCode} --name ${name} --cli --main --write-file --read-file --os
					#No Program Name Given
					else
						${LangRun} ${TemplateCode} --help
					fi
				else
					#Program Name Given
					if [ ! -z "${name}" ];then
						touch ${name}${LangExt}
					else
						errorCode "newCode"
					fi
				fi
			fi
			;;
		cli)
			local TheName=$(OtherColor $2)
			echo "${LangRun} ${TheName}"
			;;
		runCode)
			local name=$1
			local TheBin="${name}"
			local project=${CodeProject}
                        local TheBinDir
                        shift
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
			#Check if Perl Bin exists
			if [ -f ${TheBinDir}/${TheBin} ]; then
				${LangRun} ${TheBinDir}/${TheBin} ${Args[@]}
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
				TheOld="${TheOld%${LangExt}}" 
				TheNew="${TheNew%${LangExt}}"
				mv ${LangSrc}/${TheOld}${LangExt} ${LangSrc}/${TheNew}${LangExt}
				echo ${TheNew}${LangExt}
			fi
			;;
		copy)
			local TheOld=$1
			local TheNew=$2
			if [ ! -z "${TheNew}" ]; then
				TheOld="${TheOld%${LangExt}}" 
				TheNew="${TheNew%${LangExt}}"
				cp ${LangSrc}/${TheOld}${LangExt} ${LangSrc}/${TheNew}${LangExt}
				echo ${TheNew}${LangExt}
			fi
			;;
		*)
			;;
	esac
}

UsePerl $@
