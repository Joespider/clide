Shell=$(which bash)
#!${Shell}

SupportV="0.1.70"
Lang=Bash
LangExt=".sh"
ColorNum=2

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
	${LibDir}/ProjectTemplateHandler.sh ${Lang} $@
}

UseBash()
{
	local LangRun=${cplBash}

	local LangHome=${ProgDir}/${Lang}
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local LangProject=${LangHome}/projects

	local TemplateCode=${NewBash}
	TemplateCode=${LangBin}/${TemplateCode%${LangExt}}${LangExt}

	local TemplateCodeSrc=${NewBash%${LangExt}}${LangExt}

	local EnvVars=( ${LangRun} ${LangHome} ${LangSrc} ${LangBin} ${LangExt} )
	local Type=$1
	shift
	case ${Type} in
		Art)
			local srt="\e[1;3${ColorNum}m"
			local end="\e[0m"
			echo -e "${srt}oooooooooo.${end}                     ${srt}oooo${end}"
			echo -e "${srt}\`888'${end}   ${srt}\`Y8b${end}                    ${srt}\`888${end}"
			echo -e " ${srt}888${end}     ${srt}888${end}  ${srt}.oooo.${end}    ${srt}.oooo.o${end}  ${srt}888${end} ${srt}.oo.${end}"
			echo -e " ${srt}888oooo888'${end} ${srt}\`P${end}  ${srt})88b${end}  ${srt}d88(${end}  ${srt}\"8${end}  ${srt}888P\"Y88b${end}"
			echo -e " ${srt}888${end}    ${srt}\`88b${end}  ${srt}.oP\"888${end}  ${srt}\`\"Y88b.${end}   ${srt}888${end}   ${srt}888${end}"
			echo -e " ${srt}888${end}    ${srt}.88P${end} ${srt}d8(${end}  ${srt}888${end}  ${srt}o.${end}  ${srt})88b${end}  ${srt}888${end}   ${srt}888${end}"
			echo -e "${srt}o888bood8P'${end}  ${srt}\`Y888\"\"8o${end} ${srt}8\"\"888P'${end} ${srt}o888o${end} ${srt}o888o${end}"
			echo ""
			;;
		color)
			#Return Green
			echo -e "\e[1;3${ColorNum}m${Lang}\e[0m"
			;;
		color-number)
			echo "${ColorNum}"
			;;
		ProjectColor)
			echo -e "\e[1;4${ColorNum}m${CodeProject}\e[0m"
			;;
		SupportVersion)
			echo ${SupportV}
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
			HasLang=$(which ${LangRun} 2> /dev/null)
			if [ ! -z "${HasLang}" ]; then
				#Return Bash tag
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
				local CplList=$(UseBash lscpl | tr '\n' '|')
				local look=1
				local NumOfCpls=$(echo -e "${srcCode//,/\\n}" | wc -l)
				while [ ${look} -le ${NumOfCpls} ];
				do
					TheItem=$(echo ${srcCode} | cut -d ',' -f ${look})
					TheCpl=$(echo -e "${CplList//|/\\n}" | grep -w ${TheItem})
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
			name=$(UseBash "removeExt" ${name})
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
		pgDir)
			#Return Bash src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
			;;
		shell)
			cd
			${Shell}
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
				echo "${TemplateCode##*/} "
				${TemplateCode} 2> /dev/null | grep Version | sed "s/Version//g"
			else
				echo "no ${TemplateCode##*/} found"
			fi
			;;
		CplVersion)
			echo -e "\e[1;4${ColorNum}m[${Lang} Shell]\e[0m"
			${LangRun} --version | head -n 1
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
			name=$(UseBash "removeExt" ${name})
			local ThePath
			local theSrc
			local project=${CodeProject}

			if [ -z "${name}" ]; then
				case ${project} in
					none)
						;;
					*)
						name=${project}
						;;
				esac
			fi

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
	
			if [ -f ${ThePath}/${name}${LangExt} ] ; then
				echo ${ThePath}/${name}${LangExt}
			elif [ -f ${ThePath}/${project}${LangExt} ]; then
				echo ${ThePath}/${project}${LangExt}
			else
				case ${Type} in
					rmSrc)
						cd ${ThePath}/
						theSrc=$(UseBash "getProjSrc" ${name}${LangExt})
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
										num=$(echo -e "${src//,/\\n}" | grep ${num})
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
								GetCount=$(UseBash "getProjSrc" ${src} | wc -l)
								case ${GetCount} in
									0)
										;;
									1)
										src=$(UseBash "getProjSrc" ${src})
										src="..${src##*${CodeProject}}"
										ERROR=$(ln -s ${src} ${CodeProject}${LangExt} 2>&1 | tr '\n' '|')
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
					#Check if Bash Script does NOT exist
					if [ ! -f "${TheBinDir}/${src}" ]; then
						#Change to Bash Binary dir
						cd ${TheBinDir}
						case ${CodeProject} in
							none)
								#Create Symbolic Link to Bash Script
								chmod +x ../src/${src} 2> /dev/null
								ERROR=$(ln -s ../src/${src} 2>&1 | tr '\n' '|')
								;;
							*)
								local GetCount=$(UseBash "getProjSrc" ${src} | wc -l)
								case ${GetCount} in
									0)
										;;
									1)
										src=$(UseBash "getProjSrc" ${src})
										src="..${src##*${CodeProject}}"
										chmod +x ${src} 2> /dev/null
										ERROR=$(ln -s ${src} ${CodeProject}${LangExt} 2>&1 | tr '\n' '|')
										;;
									*)
										;;
								esac
								;;
						esac
						#Change to Bash Source dir
						cd - > /dev/null
						if [ -f "${TheBinDir}/${src}" ]; then
							UseBash compileCode-message
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
						cd ${path}
						mkdir src bin
						cd ${path}/src
						;;
					*)
						ProjectTemplateHandler ${EnvVars[@]} ${Type} ${project}
						;;
				esac
			else
				cd ${path}/srs
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
					path=${LangProject}/${project}/bin/
					;;
			esac
			if [ -d ${path} ]; then
				ls ${path}
			fi
			;;
		Install|exe-string)
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

			case ${Type} in
				Install)
					#Make sure Binary exists
					if [ -f "${TheBinDir}/${bin}" ]; then
						#Add command to Aliases
						AddAlias "${BinFile}" "${TheBinDir}/${bin}"
					elif [ ! -f "${TheBinDir}/${bin}" ]; then
						errorCode "install" "${bin}"
					else
						errorCode "noCode"
					fi
					;;
				exe-string)
					#Make sure Binary exists
					if [ -f "${TheBinDir}/${bin}" ]; then
						#Add command to Aliases
						echo "${TheBinDir}/${bin}"
					fi
					;;
				*)
					;;
			esac
			;;
		customCode)
			local cLang=$(UseBash "color")
			local cTemplate=$(OtherColor ${TemplateCode##*/})
			local Type=${Type,,}
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				echo -n "${cLang}\$ ./${cTemplate} "
				read -a Args
				#Template Args Given
				if [ ! -z "${Args}" ]; then
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
			local Type=$2
			local oldCode=$3
			local project=${CodeProject}

			Type=${Type,,}
			name=$(UseBash "removeExt" ${name})
			if [ ! -f ${name}${LangExt} ]; then
				#Check for Custom Code Template
				if [ -f ${TemplateCode} ]; then
					#Program Name Given
					if [ ! -z "${name}" ]; then
						${TemplateCode} ${name} > ${name}${LangExt}
					#No Program Name Given
					else
						${TemplateCode} --help
					fi
				else
					#Program Name Given
					if [ ! -z "${name}" ]; then
						touch ${name}${LangExt}
						echo -e "#!/bin/${LangRun}\n" > ${name}${LangExt}
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

			#Check if Bash Bin exists
			if [ -f ${TheBinDir}/${TheBin} ]; then
				${TheBinDir}/${TheBin} ${Args[@]}
			else
				errorCode "cpl" "need" "${name}"
			fi
			;;
		backup|restore)
			local name=$1
			name=$(UseBash "removeExt" ${name})
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
								TheCount=$(UseBash "getProjSrc" "${name}.bak" | wc -l)
								case ${TheCount} in
									0)
										errorCode "restore" "null"
										;;
									1)
										TheFound=$(UseBash "getProjSrc" "${name}.bak")
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
								TheCount=$(UseBash "getProjSrc" "${name}" | wc -l)
								case ${TheCount} in
									0)
										errorCode "backup" "null"
										;;
									1)
										TheFound=$(UseBash "getProjSrc" "${name}")
										cp ${TheFound} ${TheFound}.bak
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
			local Src=$1
			local New=$2
			local TheOld
			local TheNew
			local project=${CodeProject}
			case ${project} in
				none)
					if [ ! -f ${New} ]; then
						TheOld=$(UseBash "removeExt" ${Src})
						TheNew=$(UseBash "removeExt" ${New})

						#Remove old file for "rename"
						case ${Type} in
							rename)
								mv ${LangSrc}/${TheOld}${LangExt} ${LangSrc}/${TheNew}${LangExt}
								;;
							copy)
								cp ${LangSrc}/${TheOld}${LangExt} ${LangSrc}/${TheNew}${LangExt}
								;;
							*)
								;;
						esac

						#return new file
						echo ${TheNew}${LangExt}
					fi
					;;
				*)
					#Check if extenion is given
					local HasAnExt
					local CheckForSrc
					local ThePath

					HasAnExt=$(UseBash "hasExt" ${Src})
					if [ ! -f ${Src} ]; then
						#Extension is NOT given
						if [ -z "${HasAnExt}" ]; then
							#Find src
							CheckForSrc=$(UseBash "getProjSrc" ${Src}${LangExt} 2> /dev/null)
							ThePath=${CheckForSrc%/*}
							Src=${CheckForSrc##*/}
						else
							CheckForFile=$(UseBash "getProjSrc" ${Src} 2> /dev/null)
							if [ ! -z "${CheckForFile}" ]; then
								ThePath=${CheckForFile%/*}
							fi
						fi
					fi

					TheOld=${Src}
					HasAnExt=$(UseBash "hasExt" ${New})
					if [ -z "${HasAnExt}" ]; then
						TheNew="${New}${LangExt}"
					else
						TheNew=${New}
					fi

					if [ ! -z "${TheOld}" ] && [ ! -z "${TheNew}" ]; then
						if [ ! -z "${ThePath}" ]; then
							cd ${ThePath}
							case ${Type} in
								rename)
									mv ${TheOld} ${TheNew}
									;;
								copy)
									cp ${TheOld} ${TheNew}
									;;
								*)
									;;
							esac
							echo ${TheNew}
							cd - > /dev/null
						else
							case ${Type} in
								rename)
									mv ${TheOld} ${TheNew}
									;;
								copy)
									cp ${TheOld} ${TheNew}
									;;
								*)
									;;
							esac
							echo ${TheNew}
						fi
					fi
					;;
			esac
			;;
		*)
			;;
	esac
}

UseBash $@
