Shell=$(which bash)
#!${Shell}

SupportV="0.1.60"
Lang=Ruby
LangExt=".rb"
ColorNum=1

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

UseRuby()
{
	local LangConfig=${cplRuby}
	local LangRun=${LangConfig}

	local LangHome=${ProgDir}/${Lang}
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local LangProject=${LangHome}/projects

	local TemplateCode=${NewRuby}
	TemplateCode=${LangBin}/${TemplateCode%${LangExt}}${LangExt}

	local TemplateCodeSrc=${NewRuby%${LangExt}}${LangExt}

	local EnvVars=( ${LangRun} ${LangHome} ${LangSrc} ${LangBin} ${LangExt} )
	local Type=$1
	shift
	case ${Type} in
		Art)
			local srt="\e[1;3${ColorNum}m"
			local end="\e[0m"
			echo -e "${srt}ooooooooo.${end}                ${srt}.o8${end}"
			echo -e "${srt}\`888${end}   ${srt}\`Y88.${end}             ${srt}\"888${end}"
			echo -e " ${srt}888${end}   ${srt}.d88'${end} ${srt}oooo${end}  ${srt}oooo${end}   ${srt}888oooo.${end}  ${srt}oooo${end}    ${srt}ooo${end}"
			echo -e " ${srt}888ooo88P'${end}  ${srt}\`888${end}  ${srt}\`888${end}   ${srt}d88'${end} ${srt}\`88b${end}  ${srt}\`88.${end}  ${srt}.8'${end}"
			echo -e " ${srt}888\`88b.${end}     ${srt}888${end}   ${srt}888${end}   ${srt}888${end}   ${srt}888${end}   ${srt}\`88..8'${end}"
			echo -e " ${srt}888${end}  ${srt}\`88b.${end}   ${srt}888${end}   ${srt}888${end}   ${srt}888${end}   ${srt}888${end}    ${srt}\`888'${end}"
			echo -e "${srt}o888o${end}  ${srt}o888o${end}  ${srt}\`V88V\"V8P'${end}  ${srt}\`Y8bod8P'${end}     ${srt}.8'${end}"
			echo -e "                                    ${srt}.o..P'${end}"
			echo -e "                                    ${srt}\`Y8P'${end}"
			echo ""
			;;
		color)
		#Return Red
			echo -e "\e[1;3${ColorNum}m${Lang}\e[0m"
			;;
		color-number)
			echo "${ColorNum}"
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
			case ${project} in
				none)
					echo ${LangProject}
					;;
				*)
					echo ${LangProject}/${project}
					;;
			esac
			;;
		getProjSrc)
			local name=$1
			local project=${CodeProject}
			local TheSrcDir=${LangProject}/${project}/src
			if [ ! -z "${name}" ]; then
				find ${TheSrcDir} -name "${name}" 2> /dev/null
			fi
			;;
		pgLang)
			local HasLang=$(which ${LangRun} 2> /dev/null)
			if [ ! -z "${HasLang}" ]; then
				#Return Ruby tag
				echo "${Lang}"
			else
				#Return rejection
				echo "no"
			fi
			;;
		hasExt)
			local SourceFile=$1
			if [ ! -z "${SourceFile}" ]; then
				case ${SourceFile,,} in
					*${LangExt})
						echo ${Lang}
						;;
					*)
						;;
				esac
			fi
			;;
		removeExt)
			local SourceFile=$1
			if [ ! -z "${SourceFile}" ]; then
				case ${SourceFile} in
					*${LangExt})
						echo ${SourceFile%${LangExt}}
						;;
					*)
						echo ${SourceFile}
						;;
				esac
			fi
			;;
		getBin)
			local srcCode=$1
			if [ ! -z "${srcCode}" ]; then
				local TheCpl
				local TheItem
				local CplList=$(UseRuby lscpl | tr '\n' '|')
				local look=1
				local NumOfCpls=$(echo ${srcCode} | tr ',' '\n' | wc -l)
				while [ ${look} -le ${NumOfCpls} ];
				do
					TheItem=$(echo ${srcCode} | cut -d ',' -f ${look})
					TheItem=$(UseRuby "removeExt" ${TheItem})
					TheItem=${TheItem}${LangExt}
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
			name=$(UseRuby "removeExt" ${name})
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
			ls *${LangExt}
			;;
		pgDir)
			#Return Ruby src Dir
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
			echo -e "\e[1;4${ColorNum}m[${Lang} Shell]\e[0m"
			${LangRun} --version
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

				case ${project} in
					#not a project
					none)
						case ${Type} in
							selectCode)
								#Correct filename
								if [[ ! "${name}" == *"${LangExt}" ]] && [ -f "${name}${LangExt}" ]; then
									name="${name}${LangExt}"
								fi

								#Return source file if exists
								if [ -f "${name}" ]; then
									echo "${name}"
								fi
								;;
							addCode)
								case ${name} in
									*${LangExt}|*.h)
										#Add cpp or header files with file extensions
										case ${new} in
											*${LangExt})
												#Append file
												if [ -f "${new}" ]; then
													echo "${name},${new}"
												else
													echo "${name}"
												fi
												;;
											#Add cpp or header files without file extensions
											*)
												#Append cpp files
												if [ -f "${new}${LangExt}" ]; then
													echo "${name},${new}${LangExt}"
												else
													echo "${name}"
												fi
												;;
										esac
										;;
									*)
										;;
								esac
								;;
							*)
								;;
						esac
						;;
					#is a project
					*)
						TheSrcDir="${LangProject}/${project}/src/"
						local LookFor
						case ${Type} in
							addCode)
								#Correct filename
								if [[ ! "${new}" == *"${LangExt}" ]]; then
									new="${new}${LangExt}"
								fi
								LookFor=${new}
								;;
							selectCode)
								#Correct filename
								if [[ ! "${name}" == *"${LangExt}" ]]; then
									name="${name}${LangExt}"
								fi
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
										#Append file
										if [ -f "${new}" ]; then
											new=${new##*/}
											echo "${name},${new}"
										else
											echo "${name}"
										fi
										;;
									selectCode)
										name=$(find ${TheSrcDir} -name ${name} 2> /dev/null)
										if [ -f ${name} ]; then
											newName=${name##*/}
											echo ${newName}
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
			name=$(UseRuby "removeExt" ${name})
			local ThePath
			local theSrc
			local project=${CodeProject}
			case ${Type} in
				rmBin)
					case ${project} in
						#not a project
						none)
							ThePath=${LangBin}
							;;
						*)
							ThePath="${LangProject}/${project}/bin"
							;;
					esac
					;;
				rmSrc)
					case ${project} in
						#not a project
						none)
							ThePath=${LangSrc}
							;;
						*)
							ThePath="${LangProject}/${project}/src"
							;;
					esac
					;;
				*)
					;;
			esac
	
			if [ -f ${ThePath}/${name}${LangExt} ]; then
				echo ${ThePath}/${name}${LangExt}
			else
				case ${Type} in
					rmSrc)
						cd ${ThePath}/
						theSrc=$(UseRuby "getProjSrc" ${name}${LangExt})
						cd -> /dev/null
						if [ ! -z "${theSrc}" ]; then
							echo ${theSrc}
						fi
						;;
					*)
						;;
				esac
			fi
			;;
		editCode|readCode)
			local src=$1
			local num=$2
			local project=${CodeProject}
			local newName
			local DirPath
			local TheSrcDir
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
					case ${project} in
						none)
							if [[ "${src}" == *","* ]]; then
								if [ -z "${num}" ]; then
									#Error
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
										#Choose file from list of choices
										num=$(echo ${src} | tr ',' '\n' | grep ${num})
										${ReadOrEdit} ${num}
									else
										#Error
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
								#Read or Write Code
								#{
								${ReadOrEdit} ${src}
								#}
							fi
							;;
						*)
							TheSrcDir="${LangProject}/${project}/src/"
							local NumFound
							if [[ "${src}" == *","* ]]; then
								if [ -z "${num}" ]; then
									errorCode "editNull"
									NumFound=0
								else
									if [[ "${src}" == *"${num}"* ]]; then
										case ${num} in
											*${LangExt})
												src=${num}
												;;
											*)
												src=${num}${LangExt}
												;;
										esac
										NumFound=$(find ${TheSrcDir} -name ${src} 2> /dev/null | wc -l)
									else
										#Error
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
										NumFound=0
										#}
									fi
								fi
							else
								NumFound=$(find ${TheSrcDir} -name ${src} 2> /dev/null | wc -l)
							fi

							case ${NumFound} in
								0)
									;;
								1)
									src=$(find ${TheSrcDir} -name ${src} 2> /dev/null)
									if [ -f ${src} ]; then
										#Read or Write Code
										#{
										${ReadOrEdit} ${src}
										#}
									fi
									;;
								*)
									local Select
									find ${TheSrcDir} -name ${src} 2> /dev/null | sed "s/\/${project}\/src\//|/1" | cut -d '|' -f 2 | nl
									echo -n "> "
									read Select
									Select=$(echo ${Select} | grep "^-\?[0-9]*$")
									if [ ! -z "${Select}" ]; then
										if [ ${Select} -le ${NumFound} ] && [ ${Select} -gt 0 ]; then
											src=$(find ${TheSrcDir} -name ${src} 2> /dev/null | tr '\n' '|' | cut -d '|' -f ${Select})
											#Read or Write Code
											#{
											${ReadOrEdit} ${src}
											#}
										fi
									fi
									;;
							esac
							;;
					esac
					;;
				*)
					;;
			esac
			 ;;
		setCplArgs)
			;;
		setCplArgs-help)
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
								GetCount=$(UseRuby "getProjSrc" ${src} | wc -l)
								case ${GetCount} in
									0)
										;;
									1)
										src=$(UseRuby "getProjSrc" ${src})
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
					#Check if Ruby Script does NOT exist
					if [ ! -f "${TheBinDir}/${src}" ]; then
						#Change to Ruby Binary dir
						cd ${TheBinDir}
						case ${CodeProject} in
							none)
								#Create Symbolic Link to Ruby Script
								ERROR=$(ln -s ../src/${src} 2>&1 | tr '\n' '|')
								;;
							*)
								GetCount=$(UseRuby "getProjSrc" ${src} | wc -l)
								case ${GetCount} in
									0)
										;;
									1)
										src=$(UseRuby "getProjSrc" ${src})
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
							UseRuby compileCode-message
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
			echo ${LangProject}
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
		Install)
			local bin=$1
			local BinFile="${bin%.*}"
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
			local cLang=$(UseRuby "color")
			local cTemplate=$(OtherColor ${TemplateCode##*/})
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				echo -n "${cLang}\$ ${LangRun} ${cTemplate} "
				read -a Args
				#Program Args Given
				if [ ! -z "${Args}" ]; then
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
			name=$(UseRuby "removeExt" ${name})
			if [ ! -f ${name}${LangExt} ]; then
				#Check for Custom Code Template
				if [ -f ${TemplateCode} ]; then
					#Program Name Given
					if [ ! -z "${name}" ]; then
						${LangRun} ${TemplateCode} -n ${name} --cli --user $USER --main --write-file --read-file --user-input
					#No Program Name Given
					else
						${LangRun} ${TemplateCode} --help
					fi
				else
					#Program Name Given
					if [ ! -z "${name}" ]; then
						touch ${name}${LangExt}
					else
						errorCode "newCode"
					fi
				fi
			fi
			;;
		cli)
			local TheName=$(OtherColor $1)
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
			#Check if Ruby Bin exists
			if [ -f ${TheBinDir}/${TheBin} ]; then
				${LangRun} ${TheBinDir}/${TheBin} ${Args[@]}
			else
				errorCode "cpl" "need" "${name}"
			fi
			;;
		backup|restore)
			local name=$1
			name=$(UseRuby "removeExt" ${name})
			name="${name}${LangExt}"
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
								TheCount=$(UseRuby "getProjSrc" "${name}.bak" | wc -l)
								case ${TheCount} in
									0)
										errorCode "restore" "null"
										;;
									1)
										TheFound=$(UseRuby "getProjSrc" "${name}.bak")
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
								TheCount=$(UseRuby "getProjSrc" "${name}" | wc -l)
								case ${TheCount} in
									0)
										errorCode "backup" "null"
										;;
									1)
										TheFound=$(UseRuby "getProjSrc" "${name}")
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
			local TheOld=$(UseRuby "removeExt" $1)
			local TheNew=$(UseRuby "removeExt" $2)
			TheOld="${TheOld}${LangExt}"
			TheNew="${TheNew}${LangExt}"
			local project=${CodeProject}
			case ${project} in
				none)
					if [ ! -z "${TheNew}" ]; then
						TheOld=$(UseRuby "removeExt" ${TheOld})
						TheNew=$(UseRuby "removeExt" ${TheNew})
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
							TheOld=$(UseRuby "removeExt" ${TheOld})
							TheNew=$(UseRuby "removeExt" ${TheNew})

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
							local TheCount=$(UseRuby "getProjSrc" "${TheOld}" | wc -l)
							case ${TheCount} in
								1)
									local TheFound=$(UseRuby "getProjSrc" "${TheOld}")
									#Get the dir
									TheDir=${TheFound%/*}
									#Get the file
									TheFound=${TheFound##*/}
									#Remove the extention
									TheOld=$(UseRuby "removeExt" ${TheOld})
									TheNew=$(UseRuby "removeExt" ${TheNew})
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

UseRuby $@
