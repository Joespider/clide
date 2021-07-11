Shell=$(which bash)
#!${Shell}

SupportV="0.1.47"
Lang=Perl
LangExt=".pl"
#Color Purple
ColorNum=5

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
	echo -e "\e[1;3${ColorNum}m${text}\e[0m"
}

ProjectTemplateHandler()
{
	local SupportArgs=( "${LibDir}" "${VarDir}" "${editor}" "${ReadBy}" "${CodeProject}" "${ProjectMode}" "${CplArgs}" )
	local Envs=( ${Lang} "$1" "$2" "$3" "$4" "$5" )
	shift
	shift
	shift
	shift
	shift

	local Type=$1
	shift
	if [ -f ${TemplateProjectDir}/${Lang}.${ProjectType} ]; then
		${TemplateProjectDir}/${Lang}.${ProjectType} ${SupportArgs[@]} ${Envs[@]} ${Type} $@
	fi
}

UsePerl()
{
	local LangRun=${UsePerl}

	local LangHome=${ProgDir}/${Lang}
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local LangProject=${LangHome}/projects

	local TemplateCode=${NewPerl}
	TemplateCode=${LangBin}/${TemplateCode%${LangExt}}${LangExt}

	local TemplateCodeSrc=${NewPerl%${LangExt}}${LangExt}

	local EnvVars=( ${LangRun} ${LangHome} ${LangSrc} ${LangBin} ${LangExt} )
	local Type=$1
	shift
	case ${Type} in
		Art)
			local srt="\e[1;3${ColorNum}m"
			local end="\e[0m"
			echo -e "${srt}ooooooooo.${end}                      ${srt}oooo${end}"
			echo -e "${srt}\`888${end}   ${srt}\`Y88.${end}                    ${srt}\`888${end}"
			echo -e " ${srt}888${end}   ${srt}.d88'${end}  ${srt}.ooooo.${end}  ${srt}oooo${end} ${srt}d8b${end}  ${srt}888${end}" 
			echo -e " ${srt}888ooo88P'${end}  ${srt}d88'${end} ${srt}\`88b${end} ${srt}\`888\"\"8P${end}  ${srt}888${end}" 
			echo -e " ${srt}888${end}         ${srt}888ooo888${end}  ${srt}888${end}      ${srt}888${end}" 
			echo -e " ${srt}888${end}         ${srt}888${end}    ${srt}.o${end}  ${srt}888${end}      ${srt}888${end}" 
			echo -e "${srt}o888o${end}        ${srt}\`Y8bod8P'${end} ${srt}d888b${end}    ${srt}o888o${end}"
			echo ""
			;;
		color)
			#Return Purple
			echo -e "\e[1;3${ColorNum}m${Lang}\e[0m"
			;;
		ProjectColor)
			echo -e "\e[1;4${ColorNum}m${CodeProject}\e[0m"
			;;
		getNewCode)
			echo ${TemplateCodeSrc}
			;;
		getSrcDir)
			echo ${LangSrc}
			;;
		getProjDir)
			echo ${LangProject}
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
		ProjectHelp)
			echo ""
			echo -e "${Lang} specific project help"
			echo ""
			;;
		getProjectDir)
			local project=${CodeProject}
			echo ${LangProject}/${project}
			;;
		getBin)
			local srcCode=$(echo $1 | sed "s/${LangExt}//g")
			if [ ! -z "${srcCode}" ]; then
				local TheCpl
				local TheItem
				local CplList=$(UsePerl lscpl | tr '\n' '|')
				local look=1
				local NumOfCpls=$(echo ${srcCode} | tr ',' '\n' | wc -l)
				while [ ${look} -le ${NumOfCpls} ];
				do
					TheItem=$(echo ${srcCode} | cut -d ',' -f ${look})
					TheCpl=$(echo ${CplList} | tr '|' '\n' | grep -w ${TheItem})
					if [ ! -z "${TheCpl}" ]; then
						break
					fi
					look=$((${look}+1))
				done
				echo ${TheCpl}
			fi
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
					case ${ProjectType} in
						Generic)
							if [ -f ${LangSrc}/${CodeProject}/src/${name}${LangExt} ]; then
								echo ${name}${LangExt}
							elif [ -f ${LangSrc}/${CodeProject}/src/${name} ]; then
								echo ${name}
							fi
							;;
						*)
							ProjectTemplateHandler ${EnvVars[@]} ${Type} ${mode}
							;;
					esac
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
			if [ ! -z "${LangRun}" ]; then
				#Home
				if [ ! -d "${LangHome}" ]; then
					mkdir "${LangHome}"
				fi
				#Src
				if [ ! -d "${LangSrc}" ]; then
					mkdir "${LangSrc}"
				fi
				#Bin
				if [ ! -d "${LangBin}" ]; then
					mkdir "${LangBin}"
				fi
				#projects
				if [ ! -d "${LangProject}" ]; then
					mkdir "${LangProject}"
				fi
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
		rmBin|rmSrc)
			local name=$1
			local ThePath
			name=${name%${LangExt}}${LangExt}
			case ${Type} in
				rmBin)
					ThePath=${LangBin}
					;;
				rmSrc)
					ThePath=${LangSrc}
					;;
				*)
					;;
			esac
			if [ -f ${ThePath}/${name} ]; then
				echo ${ThePath}/${name}
			fi
			;;
		editCode|readCode)
			local src=$1
			local num=$2
			local ReadOrEdit

			#Select the tool
			#{
			case ${Type} in
				readCode)
					ReadOrEdit=${ReadBy}
					;;
				editCode)
					ReadOrEdit=${editor}
					;;
				*)
					;;
			esac
			#}

			case ${src} in
				*${LangExt})
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							#ERROR
							#{
							case ${Type} in
								readCode)
									errorCode "readNull"
									;;
								editCode)
									errorCode "editNull"
									;;
								*)
									;;
							esac
							#}
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *"${LangExt}" ]]; then
									${ReadOrEdit} ${num}
								else
									${ReadOrEdit} "${num}${LangExt}"
								fi
							else
								#ERROR
								#{
								case ${Type} in
									readCode)
										errorCode "readNot"
										;;
									editCode)
										errorCode "editNot"
										;;
									*)
										;;
								esac
								#}
							fi
						fi
					else
						${ReadOrEdit} ${src}
					fi
					;;
				*)
					;;
			esac
			;;
		setCplArgs)
			;;
		setCplArgs-help)
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
					TheBinDir="${LangProject}/${project}bin"
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
										echo -e "\e[1;4${ColorNum}m[${Lang} Code Compiled]\e[0m"
									else
										errorCode "cpl" "ERROR" "${ERROR}"
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
						#Check if Perl Script does NOT exist
						if [ ! -f "${TheBinDir}/${src}" ]; then
							#Change to Perl Binary dir
							cd ${TheBinDir}
							#Create Symbolic Link to Perl Script
							ERROR=$(ln -s ../src/${src} 2>&1 | tr '\n' '|')
							#Change to Perl Source dir
							cd - > /dev/null
							if [ -f "${TheBinDir}/${src}" ]; then
								echo -e "\e[1;4${ColorNum}m[${Lang} Code Compiled]\e[0m"
							else
								errorCode "cpl" "ERROR" "${ERROR}"
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
		discoverProject)
			local path=${LangProject}/
			local ProjectList=$(ls ${path} 2> /dev/null | tr '\n' '|' | rev | sed "s/|//1" | rev)
			if [ ! -z "${ProjectList}" ]; then
				echo "${path}:${ProjectList}"
			fi
			;;
		newProject)
			local TheProjectType=$1
			local project=$2
			local path=${LangProject}/${project}
			if [ ! -d ${path} ]; then
				case ${ProjectType} in
					Generic)
						mkdir ${path}
						mkdir ${path}/src
						mkdir ${path}/bin
						cd ${path}/src
						;;
					*)
						ProjectTemplateHandler ${EnvVars[@]} ${Type} ${project}
						;;
				esac
			else
				cd ${path}/src
			fi
			echo ${path}
			;;
		projectMode)
			local mode=$1
			case ${ProjectType} in
				Generic)
					case ${mode} in
#						main|test)
#							echo "${mode}"
#							;;
						*)
							;;
					esac
					;;
				*)
					ProjectTemplateHandler ${EnvVars[@]} ${Type} ${mode}
					;;
			esac
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
					path=${LangProject}/${project}/bin
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
					TheBinDir="${LangProject}/${project}bin"
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

			Type=${Type,,}
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
                                        TheBinDir="${LangProject}/${project}bin"
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
