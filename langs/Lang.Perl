Shell=$(which bash)
#!${Shell}

SupportV="0.1.55"
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
	local LangRun=${cplPerl}

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
		getProjSrc)
			local name=$1
			local project=${CodeProject}
			local TheSrcDir=${LangProject}/${project}/src
			if [ ! -z "${name}" ]; then
				find ${TheSrcDir} -name "${name}" 2> /dev/null
			fi
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
			name=${name%${LangExt}}
			local project=${CodeProject}
			local newName
			local DirPath
			local TheSrcDir
			case ${project} in
				none)
					TheSrcDir=${LangSrc}
					;;
				*)
					case ${ProjectType} in
						Generic)
							case ${name} in
								*.*)
									newName=${name##*.}
									DirPath=$(echo ${name%${newName}} | tr '.' '/')
									TheSrcDir="${LangProject}/${project}/src/${DirPath}"
									name=${newName}
									;;
								*/*)
									newName=${name##*/}
									DirPath=${name%${newName}}
									TheSrcDir="${LangProject}/${project}/src/${DirPath}"
									name=${newName}
									;;
								*)
									TheSrcDir="$(pwd)/"
									;;
							esac
							;;
						*)
							TheSrcDir=$(ProjectTemplateHandler ${EnvVars[@]} ${Type} ${mode})
							;;
					esac
					;;
			esac

			if [ -f ${TheSrcDir}/${name}${LangExt} ]; then
				echo ${name}${LangExt}
			elif [ -f ${TheSrcDir}/${name} ]; then
				echo ${name}
			fi
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
			${LangRun} -v 2> /dev/null | grep "This is perl" | sed "s/This is perl/perl/g"
			echo ""
			;;
		selectCode|addCode)
			local name=$1
			local new=$2
			local project=${CodeProject}
			local newName
			local DirPath
			local TheSrcDir
			#Correct filename
			if [ ! -z "${name}" ]; then
				name=${name%${LangExt}}${LangExt}
				case ${project} in
					#not a project
					none)
						case ${Type} in
							addCode)
								case ${new} in
									*${LangExt})
										if [ -f "${new}" ]; then
											echo "${name},${new}"
										else
											echo "${name}"
										fi
										;;
									*)
										if [ -f "${new}${LangExt}" ]; then
											echo "${name},${new}${LangExt}"
										else
											echo "${name}"
										fi
										;;
								esac
								;;
							selectCode)
									#Return source file if exists
									if [ -f "${name}" ]; then
										echo "${name}"
									fi
									;;
							*)
									;;
						esac
						;;
					#is a project
					*)
						local LookFor
						TheSrcDir="${LangProject}/${project}/src/"
						case ${Type} in
							addCode)
								new=${new%${LangExt}}${LangExt}
								LookFor=${new}
								;;
							selectCode)
								name=${name%${LangExt}}${LangExt}
								LookFor=${name}
								;;
							*)
								;;
						esac

						local NumFound=$(find ${TheSrcDir} -name ${LookFor} 2> /dev/null | wc -l)
						case ${NumFound} in
							0)
								;;
							1)
								case ${Type} in
									addCode)
										new=$(find ${TheSrcDir} -name ${new} 2> /dev/null)
										if [ -f ${new} ]; then
											new=${new%${LangExt}}
											newName=${new##*/}
											echo "${name},${newName}${LangExt}"
										else
											echo "${name}"
										fi
										;;
									selectCode)
										name=$(find ${TheSrcDir} -name ${name} 2> /dev/null)
										if [ -f ${name} ]; then
											name=${name%${LangExt}}
											newName=${name##*/}
											echo ${newName}${LangExt}
										fi
										;;
									*)
										;;
								esac
								;;
							*)
#								find ${TheSrcDir} -name ${name} 2> /dev/null | nl
#								if [ -f ${name} ]; then
#									name=${name%${LangExt}}
#									newName=${name##*/}
#									echo ${newName}${LangExt}
#								fi
								;;
						esac
					;;
				esac
			fi
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
						if [ -z "${num}" ]; then
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
			shift
			shift
			local Vals="none"
			local Item=""
			local str=$@
			local IFS=' '         # space is set as delimiter
			read -ra arg <<< "${str}"
			for TheItem in "${arg[@]}"; do
				if [ ! -z "${TheItem}" ]; then
					case ${TheItem} in
						--warnings)
							Item="-Wall -g"
							;;
						--std=*)
							local stdVal=${TheItem}
							case ${stdVal} in
								--std=)
									;;
								*)
									Item=${stdVal}
									;;
							esac
							;;
						*)
							;;
					esac
				fi
				if [ ! -z "${Item}" ]; then
					case ${Vals} in
						none)
							Vals=${Item}
							;;
						*${Item}*)
							;;
						*)
							Vals="${Vals} ${Item}"
							;;
					esac
				fi
				Item=""
			done
			echo ${Vals// /,}
			;;
		setCplArgs-help)
			echo -e "--warnings\t\t: \"Show ALL warnings (-W)\""
			;;
		compileCode-message)
			echo -e "\e[1;4${ColorNum}m[${Lang} Code Compiled]\e[0m"
			;;
		compileCode)
			local src=$1
			local name=$2
			local keep=$3
			local project=${CodeProject}
			local cplArgs=""
			local TheBinDir
			local GetCount
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

			#Handle multiple files
			if [[ "${src}" == *","* ]]; then
				if [ -z "${name}" ]; then
					src=""
					if [ -z "${name}" ]; then
						echo "Unable to find the \"main\" file"
						echo -n "Please choose: "
						read name
						case ${CodeProject} in
							none)
								if [ ! -f ${LangSrc}/${name%.*}${LangExt} ]; then
									name=""
								fi
								;;
							*)
								GetCount=$(UsePerl "getProjSrc" ${src} | wc -l)
								case ${GetCount} in
									0)
										;;
									1)
										src=$(UsePerl "getProjSrc" ${src})
										src="..${src##*${CodeProject}}"
										ERROR=$(ln -s ${src} 2>&1 | tr '\n' '|')
										;;
									*)
										;;
								esac
								;;
						esac
					fi

					if [ ! -z "${name}" ]; then
						src="${name%.*}${LangExt}"
					fi
				fi
			fi

			#Set Code to executable
			case ${src} in
				*${LangExt})
					#Check if Perl Script does NOT exist
					if [ ! -f "${TheBinDir}/${src}" ]; then
						#Change to Perl Binary dir
						cd ${TheBinDir}
						case ${CodeProject} in
							none)
								#Create Symbolic Link to Perl Script
								ERROR=$(ln -s ../src/${src} 2>&1 | tr '\n' '|')
								;;
							*)
								GetCount=$(UsePerl "getProjSrc" ${src} | wc -l)
								case ${GetCount} in
									0)
										;;
									1)
										src=$(UsePerl "getProjSrc" ${src})
										src="..${src##*${CodeProject}}"
										ERROR=$(ln -s ${src} 2>&1 | tr '\n' '|')
										;;
									*)
										;;
								esac
								;;
						esac
						#Change to Bash Source dir
						cd - > /dev/null
						if [ -f "${TheBinDir}/${src}" ]; then
							UsePerl compileCode-message
						else
							errorCode "cpl" "ERROR" "${ERROR}"
						fi
					#Code is already found
					else
						errorCode "cpl" "already" ${src}
					fi
					;;
				*)
					errorCode "cpl" "choose"
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
		runCode|debug)
			local name=$1
			local TheBin="${name%.*}${LangExt}"
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
					cd ${LangSrc}/
					;;
				*)
					project="${project}/"
					TheBinDir="${LangProject}/${project}bin"
					cd ${LangProject}/${project}/src
					;;
			esac

			#Handle multiple files
			if [[ "${name}" == *","* ]]; then
				#name=$(echo ${name} | tr ',' ' ')
				if [ -z "${name}" ]; then
					echo "Unable to find the \"main\" file"
					echo -n "Please choose: "
					read name
				fi
				TheBin="${name}"
			fi

			#Check if Python Bin exists
			if [ -f ${TheBinDir}/${TheBin} ]; then
				case ${Type} in
					debug)
						echo "no debugger for Perl"
						#${LangRun} -m ${UseDebugger} ${TheBinDir}/${TheBin} ${Args[@]}
						;;
					runCode)
						${LangRun} ${TheBinDir}/${TheBin} ${Args[@]}
						;;
				esac
			else
				errorCode "cpl" "need" "${name}"
			fi
			;;
		backup|restore)
			local name=$1
			name="${name%${LangExt}}${LangExt}"
			local project=${CodeProject}
			local TheDir
			local TheCount
			local TheFound

			case ${project} in
				none)
					if [ ! -z "${name}" ]; then
						case ${Type} in
							restore)
								if [ -f "${LangSrc}/${name}.bak" ]; then
									mv ${LangSrc}/${name}.bak ${LangSrc}/${name}
									echo "\"${name}\" restored"
								else
									errorCode "restore" "exists"
								fi
								;;
							backup)
								if [ ! -f "${LangSrc}/${name}.bak" ]; then
									cp ${LangSrc}/${name} ${LangSrc}/${name}.bak
									echo "\"${name}\" backed-up"
								else
									errorCode "backup" "exists"
								fi
								;;
							*)
								;;
						esac
					else
						case ${Type} in
							restore)
								errorCode "restore" "null"
								;;
							backup)
								errorCode "backup" "null"
								;;
							*)
								;;
						esac
					fi
					;;
				*)
					case ${Type} in
						restore)
							if [ -f "${name}.bak" ]; then
								mv ${name}.bak ${name}
								echo "\"${name}\" restored"
							else
								TheCount=$(UsePerl "getProjSrc" "${name}.bak" | wc -l)
								case ${TheCount} in
									0)
										errorCode "restore" "null"
										;;
									1)
										TheFound=$(UsePerl "getProjSrc" "${name}.bak")
										mv ${TheFound} ${TheFound%.bak}
										echo "\"${name}\" restored"
										;;
									*)
										;;
								esac
							fi
							;;
						backup)
							if [ -f "${name}" ] && [ ! -f "${name}.bak" ]; then
								cp ${name} ${name}.bak
								echo "\"${name}\" backed-up"
							else
								TheCount=$(UsePerl "getProjSrc" "${name}" | wc -l)
								case ${TheCount} in
									0)
										errorCode "backup" "null"
										;;
									1)
										TheFound=$(UsePerl "getProjSrc" "${name}")
										mv ${TheFound} ${TheFound}.bak
										echo "\"${name}\" backed-up"
										;;
									*)
										;;
								esac
							fi
							;;
						*)
							;;
					esac
					;;
			esac
			;;
		#create a copy of set code
		copy|rename)
			local TheOld=$1
			local TheNew=$2
			TheOld="${TheOld%${LangExt}}${LangExt}"
			TheNew="${TheNew%${LangExt}}${LangExt}"
			local project=${CodeProject}
			case ${project} in
				none)
					if [ ! -z "${TheNew}" ]; then
						TheOld="${TheOld%${LangExt}}"
						TheNew="${TheNew%${LangExt}}"
						sed "s/${TheOld}/${TheNew}/g" ${LangSrc}/${TheOld}${LangExt} > ${LangSrc}/${TheNew}${LangExt}

						#Remove old file for "rename"
						case ${Type} in
							rename)
								rm ${LangSrc}/${TheOld}${LangExt}
								;;
							*)
								;;
						esac

						#return new file
						echo ${TheNew}${LangExt}
					fi
					;;
				*)
					if [ ! -z "${TheNew}" ]; then
						#File is in current dir
						if [ -f ${TheNew} ]; then
							#Remove the extention
							TheOld="${TheOld%${LangExt}}"
							TheNew="${TheNew%${LangExt}}"
							sed "s/${TheOld}/${TheNew}/g" ${TheOld}${LangExt} > ${TheNew}${LangExt}

							#Remove old file for "rename"
							case ${Type} in
								rename)
									rm ${LangSrc}/${TheOld}${LangExt}
									;;
								*)
									;;
							esac

							echo ${TheNew}${LangExt}
						else
							local TheDir
							local TheCount=$(UsePerl "getProjSrc" "${TheOld}" | wc -l)
							case ${TheCount} in
								1)
									local TheFound=$(UsePerl "getProjSrc" "${TheOld}")
									#Get the dir
									TheDir=${TheFound%/*}
									#Get the file
									TheFound=${TheFound##*/}
									#Remove the extention
									TheOld="${TheOld%${LangExt}}"
									TheNew="${TheNew%${LangExt}}"
									sed "s/${TheOld}/${TheNew}/g" ${TheDir}/${TheOld}${LangExt} > ${TheDir}/${TheNew}${LangExt}

									#Remove old file for "rename"
									case ${Type} in
										rename)
											rm ${LangSrc}/${TheOld}${LangExt}
											;;
										*)
											;;
									esac

									#return new file
									echo ${TheNew}${LangExt}
									;;
								*)
									;;
							esac
						fi
					fi
					;;
			esac
			;;
		*)
			;;
	esac
}

UsePerl $@
