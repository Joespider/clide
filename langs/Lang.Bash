#!/usr/bin/env bash

SupportV="0.2.09"
Lang=Bash
LangExt=".sh"
ColorNum=2
UseTypeOfCpl=${TypeOfCpl}

#Handle Pipes
#{
ThePipe=""
if readlink /proc/$$/fd/0 | grep -q "^pipe:"; then
	ThePipe="Pipe"
fi
#}

CplArgs=${RunCplArgs}
TheCode=${TheSrcCode}

errorCode()
{
	if [ -d ${LibDir} ] && [ -f ${LibDir}/errorCode.sh ]; then
		${LibDir}/errorCode.sh "${@}"
	fi
}

#Handle Aliases
AddAlias()
{
	if [ -d ${LibDir} ] && [ -f ${LibDir}/AddAlias.sh ]; then
		${LibDir}/AddAlias.sh "${@}"
	fi
}

OtherColor()
{
	local text=$1
	#Return Purple
	echo -e "\e[1;35m${text}\e[0m"
}

ProjectTemplateHandler()
{
	if [ -d ${LibDir} ] && [ -f ${LibDir}/ProjectTemplateHandler.sh ]; then
		${LibDir}/ProjectTemplateHandler.sh ${Lang} "${@}"
	fi
}

UseBash()
{
	local LangRun=${cplBash}

	local LangHome=${ProgDir}/${Lang}
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local LangProject=${LangHome}/projects

	local TemplateCode=${NewBash}
	local TemplateCodeArgs=${NewBashArgs}
	TemplateCode=${LangBin}/${TemplateCode%${LangExt}}${LangExt}

	local TemplateCodeSrc=${NewBash%${LangExt}}${LangExt}

	local EnvVars=( ${LangRun} ${LangHome} ${LangSrc} ${LangBin} ${LangExt} )
	local Type=$1
	shift
	case ${Type} in
		Art)
			#https://textkool.com/en/ascii-art-generator
			#Font: Roman
			#Width: default
			#height: default
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
		Lang-Type)
			local Get=$1
			case ${Get} in
				classified)
					echo "Scripting"
					;;
				executable)
					echo "Script"
					;;
				runtime)
					echo "Interpreted"
					;;
				*)
					local Classified=$(UseBash ${Type} classified)
					local Exe=$(UseBash ${Type} executable)
					local RunTime=$(UseBash ${Type} runtime)
					echo -e "Classified:\t${Classified}"
					echo -e "Executable:\t${Exe}"
					echo -e "Runtime:\t${RunTime}"
					;;
			esac
			;;
		color)
			#Return Green
			echo -e "\e[1;3${ColorNum}m${Lang}\e[0m"
			;;
		color-number)
			echo "${ColorNum}"
			;;
		ProjectColor)
			local TheText=$1
			if [ -z "${TheText}" ]; then
				echo -e "\e[1;4${ColorNum}m${CodeProject}\e[0m"
			else
				echo -e "\e[1;4${ColorNum}m${TheText}\e[0m"
			fi
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
		getAllProjSrc)
			local project=${CodeProject}
			local TheSrcDir=${LangProject}/${project}/src
			find ${TheSrcDir} -name *"${LangExt}" 2> /dev/null
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
			local UseProjectTemplate
			case ${project} in
				none)
					echo ${LangProject}
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
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
			local ShowCpl=$1
			if [ ! -z "${ShowCpl}" ]; then
				echo ${LangRun}
			else
				local HasLang=$(which ${LangRun} 2> /dev/null)
				if [ ! -z "${HasLang}" ]; then
					#Return Bash tag
					echo "${Lang}"
				else
					#Return rejection
					echo "no"
				fi
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
				for TheItem in ${srcCode//,/ };
				do
					TheCpl=$(echo -e "${CplList//|/\\n}" | grep -w ${TheItem})
					if [ ! -z "${TheCpl}" ]; then
						break
					fi
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
			local UseProjectTemplate
			case ${project} in
				none)
					TheSrcDir=${LangSrc}
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					case ${ProjectType} in
						${ProjectDefaultType})
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
							TheSrcDir=$(ProjectTemplateHandler "${EnvVars[@]}" ${Type} ${mode})
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
			${cplBash}
			;;
		newCodeHelp)
			if [ -f ${TemplateCode} ]; then
				echo -e "\t-c, --custom <args>\t\t: \"Custom src file using ${Lang} template\""
				echo -e "\t-s, --show <args>\t\t: \"Show custom src code from ${Lang} template without saving\""
			fi
			;;
		EnsureDirs)
			if [ ! -z "${LangRun}" ]; then
				#Home
				if [ ! -d "${LangHome}" ]; then
					mkdir -p "${LangHome}"
				fi
				#Src
				if [ ! -d "${LangSrc}" ]; then
					mkdir -p "${LangSrc}"
				fi
				#Bin
				if [ ! -d "${LangBin}" ]; then
					mkdir -p "${LangBin}"
				fi
				#projects
				if [ ! -d "${LangProject}" ]; then
					mkdir -p "${LangProject}"
				fi
			fi
			;;
		TemplateVersion)
			if [ -f ${TemplateCode} ]; then
				echo -n "${TemplateCode##*/} "
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
			local UseProjectTemplate

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
						UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
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
			local UseProjectTemplate

			if [ -z "${name}" ]; then
				case ${project} in
					none)
						;;
					*)
						UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
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
			local src=${TheCode}
			local num=$1
			local project=${CodeProject}
			local newName
			local DirPath
			local TheSrcDir
			local EditLine="$2"
			local ReadOrEdit
			local UseProjectTemplate

			#Select the tool
			#{
			case ${Type} in
				readCode)
					EditLine=""
					ReadOrEdit=${ReadBy}
					;;
				editCode)
					case ${num} in
						--line)
							num="$3"
							if [ ! -z "${EditLine}" ]; then
								EditLine="+${EditLine}"
							fi
							;;
						*)
							EditLine=""
							;;
					esac
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
							case ${src} in
								*","*)
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
										case ${src} in
											*"${num}"*)
												#Choose file from list of choices
												num=$(echo -e "${src//,/\\n}" | grep ${num})
												case ${ReadOrEdit,,} in
													nano)
														if [ ! -z "${EditLine}" ]; then
															${ReadOrEdit} -l "${EditLine}" ${num}
														else
															${ReadOrEdit} -l ${num}
														fi
														;;
													vi)
														if [ ! -z "${EditLine}" ]; then
															${ReadOrEdit} "+set number" "${EditLine}" ${num}
														else
															${ReadOrEdit} "+set number" ${num}
														fi
														;;
													*)
														${ReadOrEdit} ${num}
														;;
												esac
												;;
											*)
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
												;;
										esac
									fi
									;;
								*)
									#Read or Write Code
									#{
									case ${ReadOrEdit,,} in
										nano)
											if [ ! -z "${EditLine}" ]; then
												${ReadOrEdit} -l "${EditLine}" ${src}
											else
												${ReadOrEdit} -l ${src}
											fi
											;;
										vi)
											if [ ! -z "${EditLine}" ]; then
												${ReadOrEdit} "+set number" "${EditLine}" ${src}
											else
												${ReadOrEdit} "+set number" ${src}
											fi
											;;
										*)
											${ReadOrEdit} ${src}
											;;
									esac
									#}
									;;
							esac
							;;
						*)
							UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
							TheSrcDir="${LangProject}/${project}/src/"
							local NumFound
							case ${src} in
								*","*)
									if [ -z "${num}" ]; then
										errorCode "editNull"
										NumFound=0
									else
										case ${src} in
											*"${num}"*)
												case ${num} in
													*${LangExt})
														src=${num}
														;;
													*)
														src=${num}${LangExt}
														;;
												esac
												NumFound=$(find ${TheSrcDir} -name ${src} 2> /dev/null | wc -l)
												;;
											*)
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
												;;
										esac
									fi
									;;
								*)
									NumFound=$(find ${TheSrcDir} -name ${src} 2> /dev/null | wc -l)
									;;
							esac

							case ${NumFound} in
								0)
									;;
								1)
									src=$(find ${TheSrcDir} -name ${src} 2> /dev/null)
									if [ -f ${src} ]; then
										#Read or Write Code
										#{
										case ${ReadOrEdit,,} in
											nano)
												if [ ! -z "${EditLine}" ]; then
													${ReadOrEdit} -l "${EditLine}" ${src}
												else
													${ReadOrEdit} -l ${src}
												fi
												;;
											vi)
												if [ ! -z "${EditLine}" ]; then
													${ReadOrEdit} "+set number" "${EditLine}" ${src}
												else
													${ReadOrEdit} "+set number" ${src}
												fi
												;;
											*)
												${ReadOrEdit} ${src}
												;;
										esac
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
											case ${ReadOrEdit,,} in
												nano)
													if [ ! -z "${EditLine}" ]; then
														${ReadOrEdit} -l "${EditLine}" ${src}
													else
														${ReadOrEdit} -l ${src}
													fi
													;;
												vi)
													if [ ! -z "${EditLine}" ]; then
														${ReadOrEdit} "+set number" "${EditLine}" ${src}
													else
														${ReadOrEdit} "+set number" ${src}
													fi
													;;
												*)
													${ReadOrEdit} ${src}
													;;
											esac
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
			echo -e "\e[1;4${ColorNum}m[${Lang} Code Set To Execute]\e[0m"
			;;
		compileCode)
			local src=${TheCode}
			local name=$1
			local keep=$2
			local project=${CodeProject}
			local cplArgs=""
			local TheBinDir
			local ERROR
			local UseProjectTemplate
			#Handle Project Dir
			case ${project} in
				none)
					project=""
					TheBinDir=${LangBin}
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					TheBinDir="${LangProject}/${project}/bin"
					;;
			esac

			#Handle multiple files
			case ${src} in
				*","*)
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
					;;
				*)
					;;
			esac

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
						UseBash compileCode-message
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
			local UseProjectTemplate
			if [ ! -d ${path} ]; then
				case ${ProjectType} in
					${ProjectDefaultType})
						mkdir ${path}
						mkdir ${path}/bin
						mkdir ${path}/src
						;;
					*)
						UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
						mkdir ${path}
						if [ ! -z "${UseProjectTemplate}" ]; then
							ProjectTemplateHandler "${EnvVars[@]}" ${Type} ${project}
							if [ ! -d ${path}/bin ]; then
								mkdir ${path}/bin
							fi
							if [ ! -d ${path}/src ]; then
								mkdir ${path}/src
							fi
						else
							mkdir ${path}/bin
							mkdir ${path}/src
						fi
						;;
				esac
				cd ${path}/src
			else
				cd ${path}/srs
			fi
			echo ${path}
			;;
		projectMode)
			local mode=$1
			local UseProjectTemplate
			case ${ProjectType} in
				${ProjectDefaultType})
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					if [ ! -z "${UseProjectTemplate}" ]; then
						ProjectTemplateHandler "${EnvVars[@]}" ${Type} ${mode}
					fi
					;;
			esac
			;;
		lscpl)
			local project
			local path
			local UseProjectTemplate
			case ${CodeProject} in
				none)
					path=${LangBin}/
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					project=${CodeProject}
					path=${LangProject}/${project}/bin/
					;;
			esac
			if [ -d ${path} ]; then
				ls --color=auto ${path}
			fi
			;;
		Install*)
			local bin=$1
			local BinFile="${bin%.*}"
			local project=${CodeProject}
			local TheBinDir
			local UseProjectTemplate
			#Handle Project Dir
			case ${project} in
				none)
					project=""
					TheBinDir=${LangBin}
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					TheBinDir="${LangProject}/${project}/bin"
					;;
			esac

			case ${Type} in
				Install-alias)
					#Make sure Binary exists
					if [ -f "${TheBinDir}/${bin}" ]; then
						#Add command to Aliases
						AddAlias "${BinFile}" "${TheBinDir}/${bin}"
					elif [ ! -f "${TheBinDir}/${bin}" ]; then
						#compile or swap to binary
						errorCode "install" "${bin}"
					else
						errorCode "noCode"
					fi
					;;
				Install-check)
					local IsAlias
					echo -n "Install-alias (~/.bash_aliases): "
					if [ -f ~/.bash_aliases ]; then
						IsAlias=$(grep "alias ${BinFile}=\"" ~/.bash_aliases)
						if [ ! -z "${IsAlias}" ]; then
							errorCode "HINT" "INSTALLED"
						else
							errorCode "ERROR" "NOT-INSTALLED"
						fi
					else
						errorCode "ERROR" "NOT-INSTALLED"
					fi

					echo -n "Install-bin (/bin): "
					if [ -f /bin/${BinFile} ]; then
						errorCode "HINT" "INSTALLED"
					else
						errorCode "ERROR" "NOT-INSTALLED"
					fi

					echo -n "Install-root (/usr/sbin): "
					if [ -f /usr/sbin/${BinFile} ]; then
						errorCode "HINT" "INSTALLED"
					else
						errorCode "ERROR" "NOT-INSTALLED"
					fi

					echo -n "Install-user (~/bin): "
					if [ -f ~/bin/${BinFile} ]; then
						errorCode "HINT" "INSTALLED"
					else
						errorCode "ERROR" "NOT-INSTALLED"
					fi
					;;
				Install-bin)
					ThePath="/bin"
					#Make sure Binary exists
					if [ -f "${TheBinDir}/${bin}" ]; then
						HasTheTag=$(head ${TheBinDir}/${bin} | egrep "#\!/bin/${LangRun}|#\!/usr/bin/${LangRun}|#\! /usr/bin/${LangRun}|#\!/usr/bin/env ${LangRun}")
						if [ ! -z "${HasTheTag}" ]; then
							if [ -f ${ThePath}/${BinFile} ]; then
								errorCode "install" "already" "${BinFile}" "${ThePath}/"
								echo ""
								errorCode "HINT" "This must be done manually to protect from unwanted over-written binaries"
								errorCode "HINT" "command"
								case ${USER} in
									root)
										errorCode "HINT" "cp ${TheBinDir}/${bin} ${ThePath}/${BinFile}"
										;;
									*)
										errorCode "HINT" "sudo cp ${TheBinDir}/${bin} ${ThePath}/${BinFile}"
										;;
								esac
							else
								case ${USER} in
									root)
										cp ${TheBinDir}/${bin} ${ThePath}/${BinFile}
										chmod +x ${ThePath}/${BinFile}
										;;
									*)
										sudo cp ${TheBinDir}/${bin} ${ThePath}/${BinFile}
										sudo chmod +x ${ThePath}/${BinFile}
										;;
								esac
							fi
						else
							errorCode "install" "missing-env" "\n\t#!/bin/${LangRun}\n\t#!/usr/bin/${LangRun}\n\t#! /usr/bin/${LangRun}\n\t#!/usr/bin/env ${LangRun}"
						fi
					elif [ ! -f "${TheBinDir}/${bin}" ]; then
						#compile or swap to binary
						errorCode "install" "${BinFile}"
					else
						errorCode "noCode"
					fi
					;;
				Install-root)
					ThePath="/usr/sbin"
					#Make sure Binary exists
					if [ -f "${TheBinDir}/${bin}" ]; then
						HasTheTag=$(head ${TheBinDir}/${bin} | egrep "#\!/bin/${LangRun}|#\!/usr/bin/${LangRun}|#\! /usr/bin/${LangRun}|#\!/usr/bin/env ${LangRun}")
						if [ ! -z "${HasTheTag}" ]; then
							if [ -f ${ThePath}/${BinFile} ]; then
								errorCode "install" "already" "${BinFile}" "${ThePath}/"
							else
								case ${USER} in
									root)
										cp ${TheBinDir}/${bin} ${ThePath}/${BinFile}
										chmod +x ${ThePath}/${BinFile}
										;;
									*)
										sudo cp ${TheBinDir}/${bin} ${ThePath}/${BinFile}
										sudo chmod +x ${ThePath}/${BinFile}
										;;
								esac
							fi
						else
							errorCode "install" "missing-env" "\n\t#!/bin/${LangRun}\n\t#!/usr/bin/${LangRun}\n\t#! /usr/bin/${LangRun}\n\t#!/usr/bin/env ${LangRun}"
						fi
					elif [ ! -f "${TheBinDir}/${bin}" ]; then
						#compile or swap to binary
						errorCode "install" "${BinFile}"
					else
						errorCode "noCode"
					fi
					;;
				Install-user)
					ThePath="~/bin"
					#Make sure Binary exists
					if [ -f "${TheBinDir}/${bin}" ]; then
						HasTheTag=$(head ${TheBinDir}/${bin} | egrep "#\!/bin/${LangRun}|#\!/usr/bin/${LangRun}|#\! /usr/bin/${LangRun}|#\!/usr/bin/env ${LangRun}")
						if [ ! -z "${HasTheTag}" ]; then
							if [ -f ${ThePath}/${BinFile} ]; then
								errorCode "install" "already" "${BinFile}" "${ThePath}/"
							else
								if [ -d ${ThePath} ]; then
									cp ${TheBinDir}/${bin} ${ThePath}/${BinFile}
									chmod +x ${ThePath}/${BinFile}
								else
									errorCode "ERROR"
									errorCode "ERROR" "${ThePath}/ does not exist"
								fi
							fi
						else
							errorCode "install" "missing-env" "\n\t#!/bin/${LangRun}\n\t#!/usr/bin/${LangRun}\n\t#! /usr/bin/${LangRun}\n\t#!/usr/bin/env ${LangRun}"
						fi
					elif [ ! -f "${TheBinDir}/${bin}" ]; then
						#compile or swap to binary
						errorCode "install" "${BinFile}"
					else
						errorCode "noCode"
					fi
					;;
				*)
					;;
			esac
			;;
		exe-string)
			local bin=$1
			local BinFile="${bin%.*}"
			local project=${CodeProject}
			local TheBinDir
			local UseProjectTemplate
			#Handle Project Dir
			case ${project} in
				none)
					project=""
					TheBinDir=${LangBin}
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					TheBinDir="${LangProject}/${project}/bin"
					;;
			esac

			#Make sure Binary exists
			if [ -f "${TheBinDir}/${bin}" ]; then
				#Add command to Aliases
				echo "${TheBinDir}/${bin}"
			fi
			;;
		customCode)
			local cTemplate=$(OtherColor ${TemplateCode##*/})
			local Type=${Type,,}
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				shift
				shift
				shift
				shift
				Args=( "${@}" )
				if [ -z "${1}" ]; then
					echo -n "./${cTemplate} "
					read -a Args
				fi
				#Template Args Given
				if [ ! -z "${Args}" ]; then
					${TemplateCode} "${Args[@]}"
				#No Template Args Given
				else
					${TemplateCode} --help
				fi
			else
				#Program Name Given
				errorCode "customCode" "notemp" "${Lang}"
			fi
			;;
		customCodeShow)
			local cTemplate=$(OtherColor ${TemplateCode##*/})
			local Type=${Type,,}
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				shift
				shift
				shift
				shift
				Args=( "${@}" )
				if [ -z "${1}" ]; then
					echo -n "./${cTemplate} --no-save "
					read -a Args
				fi
				#Template Args Given
				if [ ! -z "${Args}" ]; then
					${TemplateCode} --no-save "${Args[@]}"
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
			local UseProjectTemplate

			Type=${Type,,}
			name=$(UseBash "removeExt" ${name})
			if [ ! -f ${name}${LangExt} ]; then
				UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
				if [ -z "${UseProjectTemplate}" ]; then
					#Check for Custom Code Template
					if [ -f ${TemplateCode} ]; then
						#Program Name Given
						if [ ! -z "${name}" ]; then
							${TemplateCode} -n ${name} ${TemplateCodeArgs}
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
				else
					echo ProjectTemplateHandler
				fi
			fi
			;;
		cli)
			local TheName=$(OtherColor $1)
			echo "./${TheName}"
			;;
		runCode|restore-edit)
			local name=$1
			local UseProjectTemplate
			shift
			shift
			local Args=( "${@}" )
			local TheBin
			local project=${CodeProject}
			local TheBinDir
			local TheSrcDir

			#Handle Project Dir
			case ${project} in
				none)
					project=""
					TheBinDir=${LangBin}
					TheSrcDir=${LangSrc}
					#Handle multiple files
					case ${name} in
						*","*)
							if [ -z "${name}" ]; then
								echo "Unable to find the \"main\" file"
								echo -n "Please choose: "
								read name
							fi
							;;
						*)
							;;
					esac
					TheBin=${name}
					;;
				*)
					if [ ! -z "${project}" ]; then
						UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
						TheBinDir="${LangProject}/${project}/bin"
						TheSrcDir="${LangProject}/${project}/src"
						TheBin="${project}"
					else
						TheBin=""
					fi
					;;
			esac

			#Check if Bash Bin exists
			if [ -f ${TheBinDir}/${TheBin} ]; then
				#protect the shell script while running
				chmod -w ${TheBinDir}/${TheBin} 2> /dev/null
				case ${Type} in
					restore-edit)
						;;
					*)
						if [ ! -z "${ThePipe}" ]; then
							if [ ! -z "${TimeRun}" ]; then
								if [ -f "${MultiPipeFile}" ]; then
									if [ -z "${Args[0]}" ]; then
										time cat ${MultiPipeFile} | ${TheBinDir}/${TheBin}
									else
										time cat ${MultiPipeFile} | ${TheBinDir}/${TheBin} "${Args[@]}"
									fi
								else
									if [ -z "${Args[0]}" ]; then
										time cat /dev/stdin | ${TheBinDir}/${TheBin}
									else
										time cat /dev/stdin | ${TheBinDir}/${TheBin} "${Args[@]}"
									fi
								fi
							else
								if [ -f "${MultiPipeFile}" ]; then
									if [ -z "${Args[0]}" ]; then
										cat ${MultiPipeFile} | ${TheBinDir}/${TheBin}
									else
										cat ${MultiPipeFile} | ${TheBinDir}/${TheBin} "${Args[@]}"
									fi
								else
									if [ -z "${Args[0]}" ]; then
										cat /dev/stdin | ${TheBinDir}/${TheBin}
									else
										cat /dev/stdin | ${TheBinDir}/${TheBin} "${Args[@]}"
									fi
								fi
							fi
						else
							if [ ! -z "${TimeRun}" ]; then
								if [ -z "${Args[0]}" ]; then
									time ${TheBinDir}/${TheBin}
								else
									time ${TheBinDir}/${TheBin} "${Args[@]}"
								fi
							else
								if [ -z "${Args[0]}" ]; then
									${TheBinDir}/${TheBin}
								else
									${TheBinDir}/${TheBin} "${Args[@]}"
								fi
							fi
						fi
						;;
				esac
				#release protection
				chmod u+w ${TheBinDir}/${TheBin} 2> /dev/null
			else
				errorCode "cpl" "need" "${name}"
			fi
			;;
		backup|backup-remove|restore)
			local name=$1
			name=$(UseBash "removeExt" ${name})
			name="${name}${LangExt}"
			local project=${CodeProject}
			local UseProjectTemplate
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
							backup-remove)
								if [ -f "${LangSrc}/${name}.bak" ]; then
									rm ${LangSrc}/${name}.bak
									echo "\"${name}\" backup removed"
								else
									errorCode "backup" "exists"
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
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
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
						backup-remove)
							if [ -f "${name}" ] && [ -f "${name}.bak" ]; then
								rm ${name}.bak
								echo "\"${name}\" backup removed"
							else
								TheCount=$(UseBash "getProjSrc" "${name}" | wc -l)
								case ${TheCount} in
									0)
										errorCode "backup" "null"
										;;
									1)
										TheFound=$(UseBash "getProjSrc" "${name}")
										if [ -f "${TheFound}.bak" ]; then
											rm ${TheFound}.bak
											echo "\"${name}\" backup removed"
										fi
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
			local UseProjectTemplate
			case ${project} in
				none)
					if [ ! -f ${New} ]; then
						TheOld=$(UseBash "removeExt" ${Src})
						TheNew=$(UseBash "removeExt" ${New})

						#Remove old file for "rename"
						case ${Type} in
							rename)
								mv ${LangSrc}/${TheOld}${LangExt} ${LangSrc}/${TheNew}${LangExt} 2> /dev/null
								;;
							copy)
								cp ${LangSrc}/${TheOld}${LangExt} ${LangSrc}/${TheNew}${LangExt} 2> /dev/null
								;;
							*)
								;;
						esac

						#return new file
						echo ${TheNew}${LangExt}
					fi
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
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
									mv ${TheOld} ${TheNew} 2> /dev/null
									;;
								copy)
									cp ${TheOld} ${TheNew} 2> /dev/null
									;;
								*)
									;;
							esac
							echo ${TheNew}
							cd - > /dev/null
						else
							case ${Type} in
								rename)
									mv ${TheOld} ${TheNew} 2> /dev/null
									;;
								copy)
									cp ${TheOld} ${TheNew} 2> /dev/null
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

UseBash "${@}"
