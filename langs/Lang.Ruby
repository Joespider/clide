#!/usr/bin/env bash

SupportV="0.2.3"
Lang=Ruby
LangExt=".rb"
ColorNum=1
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
	local TemplateCodeArgs=${NewRubyArgs}

	local ShellCodeBin=${LangBin}/shell${LangExt}

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
					local Classified=$(UseRuby ${Type} classified)
					local Exe=$(UseRuby ${Type} executable)
					local RunTime=$(UseRuby ${Type} runtime)
					echo -e "Classified:\t${Classified}"
					echo -e "Executable:\t${Exe}"
					echo -e "Runtime:\t${RunTime}"
					;;
			esac
			;;
		color)
		#Return Red
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
		getAllProjSrc)
			local project=${CodeProject}
			local TheSrcDir=${LangProject}/${project}/src
			find ${TheSrcDir} -name *"${LangExt}" 2> /dev/null
			;;
		getProjSrc)
			local name=$1
			local project=${CodeProject}
			local TheSrcDir=${LangProject}/${project}/src
			local UseProjectTemplate
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
					#Return Ruby tag
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
				local CplList=$(UseRuby lscpl | tr '\n' '|')
				local NumOfCpls=$(echo -e "${srcCode//,/\\n}" | wc -l)
				for TheItem in ${srcCode//,/ };
				do
					TheItem=$(UseRuby "removeExt" ${TheItem})
					TheItem=${TheItem}${LangExt}
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
			name=$(UseRuby "removeExt" ${name})
			local project=${CodeProject}
			local UseProjectTemplate
			local newName
			local DirPath
			local TheSrcDir
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
				${LangRun} ${TemplateCode} 2> /dev/null | grep Version | sed "s/Version//g"
			else
				echo "no ${TemplateCode##*/} found"
			fi
			;;
		#shell code version
		ShellVersion)
			if [ -f ${ShellCodeBin} ]; then
				echo -n "${ShellCodeBin##*/} : "
				${LangRun} ${ShellCodeBin} --version 2> /dev/null
				echo ""
			else
				echo "no ${ShellCodeBin##*/} found"
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
			local UseProjectTemplate
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
			local src=${TheCode}
			local num=$1
			local project=${CodeProject}
			local UseProjectTemplate
			local newName
			local DirPath
			local TheSrcDir
			local EditLine="$2"
			local ReadOrEdit

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
			local GetCount
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
					project="${project}/"
					TheBinDir="${LangProject}/${project}bin"
					;;
			esac

			#Handle multiple files
			case ${src} in
				*","*)
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
					;;
				*)
					;;
			esac

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
										ERROR=$(ln -s ${src} ${CodeProject}${LangExt}  2>&1 | tr '\n' '|')
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
						UseRuby compileCode-message
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
						mkdir ${path}/src
						mkdir ${path}/bin
						cd ${path}/src
						;;
					*)
						UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
						if [ ! -z "${UseProjectTemplate}" ]; then
							ProjectTemplateHandler "${EnvVars[@]}" ${Type} ${project}
						fi
						;;
				esac
			else
				cd ${path}/src
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
					path=${LangProject}/${project}/bin
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
			local ThePath
			#Handle Project Dir
			case ${project} in
				none)
					project=""
					TheBinDir=${LangBin}
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					project="${project}/"
					TheBinDir="${LangProject}/${project}bin"
					;;
			esac

			case ${Type} in
				Install-alias)
					#Make sure Binary exists
					if [ -f "${TheBinDir}/${bin}" ]; then
						HasTheTag=$(head ${TheBinDir}/${bin} | egrep "#\!/usr/bin/${LangRun}|#\! /usr/bin/${LangRun}|#\!/usr/bin/env ${LangRun}")
						if [ ! -z "${HasTheTag}" ]; then
							#Add command to Aliases
							AddAlias "${BinFile}" "${TheBinDir}/${bin}"
						else
							#Add command to Aliases
							AddAlias "${BinFile}" "${LangRun} ${TheBinDir}/${bin}"
						fi
					elif [ ! -f "${TheBinDir}/${bin}" ]; then
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
						HasTheTag=$(head ${TheBinDir}/${bin} | egrep "#\!/usr/bin/${LangRun}|#\! /usr/bin/${LangRun}|#\!/usr/bin/env ${LangRun}")
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
							errorCode "install" "missing-env" "\n\t#!/usr/bin/${LangRun}\n\t#! /usr/bin/${LangRun}\n\t#!/usr/bin/env ${LangRun}"
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
						HasTheTag=$(head ${TheBinDir}/${bin} | egrep "#\!/usr/bin/${LangRun}|#\! /usr/bin/${LangRun}|#\!/usr/bin/env ${LangRun}")
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
							errorCode "install" "missing-env" "\n\t#!/usr/bin/${LangRun}\n\t#! /usr/bin/${LangRun}\n\t#!/usr/bin/env ${LangRun}"
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
						HasTheTag=$(head ${TheBinDir}/${bin} | egrep "#\!/usr/bin/${LangRun}|#\! /usr/bin/${LangRun}|#\!/usr/bin/env ${LangRun}")
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
							errorCode "install" "missing-env" "\n\t#!/usr/bin/${LangRun}\n\t#! /usr/bin/${LangRun}\n\t#!/usr/bin/env ${LangRun}"
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
					project="${project}/"
					TheBinDir="${LangProject}/${project}bin"
					;;
			esac

			#Make sure Binary exists
			if [ -f "${TheBinDir}/${bin}" ]; then
				echo "${LangRun} ${TheBinDir}/${bin}"
			fi
			;;
		customCode)
			local cTemplate=$(OtherColor ${TemplateCode##*/})
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				shift
				shift
				shift
				shift
				Args=( "${@}" )
				if [ -z "${1}" ]; then
					echo -n "${LangRun} ${cTemplate} "
					read -a Args
				fi
				#Program Args Given
				if [ ! -z "${Args}" ]; then
					${LangRun} ${TemplateCode} "${Args[@]}"
				#No Program Name Given
				else
					${LangRun} ${TemplateCode} --help
				fi
			else
				#Program Name Given
				errorCode "customCode" "notemp" "${Lang}"
			fi
			;;
		customCodeShow)
			local cTemplate=$(OtherColor ${TemplateCode##*/})
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				shift
				shift
				shift
				shift
				Args=( "${@}" )
				if [ -z "${1}" ]; then
					echo -n "${LangRun} ${cTemplate} --no-save "
					read -a Args
				fi
				#Program Args Given
				if [ ! -z "${Args}" ]; then
					${LangRun} ${TemplateCode} --no-save "${Args[@]}"
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
			local CodeType=$2
			local oldCode=$3
			local TheName
			local UseProjectTemplate
			local project=${CodeProject}
			local UseProjectTemplate

			#Sometimes "oldCode" gets passed as "CodeType"
			if [ -z "${oldCode}" ]; then
				case ${CodeType} in
					*${LangExt})
						oldCode=${CodeType}
						;;
					*)
						;;
				esac
			fi

			case ${project} in
				none)
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					;;
			esac

			CodeType=${CodeType,,}
			name=$(UseRuby "removeExt" ${name})

			if [ ! -f ${name}${LangExt} ]; then
				case ${CodeType} in
					#create main file
					main)
						if [ ! -f ${name}${LangExt} ]; then
							if [ -z "${UseProjectTemplate}" ]; then
								#Check for Custom Code Template
								if [ -f ${TemplateCode} ]; then
									#Program Name Given
									if [ ! -z "${name}" ]; then
										${LangRun} ${TemplateCode} --name ${name} --main ${TemplateCodeArgs}
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
							else
								ProjectTemplateHandler ${ProjectType} ${Type} ${name}${LangExt} ${CodeType}
							fi
						fi
						;;
					#create component file
					component)
						if [ ! -f ${name}${LangExt} ]; then
							if [ -z "${UseProjectTemplate}" ]; then
								if [ -f ${TemplateCode} ]; then
									#Program Name Given
									if [ ! -z "${name}" ]; then
										${LangRun} ${TemplateCode} --name "${name}"
									#No Program Name Given
									else
										#Help Page
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
							else
								ProjectTemplateHandler ${ProjectType} ${Type} ${name}${LangExt} ${CodeType}
							fi
						fi
						;;
					#cl[ide] knows best
					*)
						#Because projects are walled off from the rest of your source code,while non-project code is shared,
						#Source code creation must be handled differently.
						#(non-project) accounts for what is "set"
						#(project) accounts for source code living in the directories
						case ${project} in
							#Is not a project
							none)
								#Looks like you have source code already set
								TheName=$(UseRuby "removeExt" ${name})
								if [ ! -z "${oldCode}" ]; then
									UseRuby "newCode" ${name} "component" ${oldCode}
								#No source code has been made, create a main file
								else
									UseRuby "newCode" ${name} "main"
								fi
								;;
							#Is a project
							*)
								#Because a project can have source code scattered in different directories,
								#make sure you have one main component
								#Figure out how to account for headers
								local TheSrcDir="${LangProject}/${project}/src/"
								local HasSrcCode=$(find ${TheSrcDir} -type f -name "*${LangExt}")
								#Has Source Code
								if [ ! -z "${HasSrcCode}" ]; then
									TheName=$(UseRuby "removeExt" ${name})
									local NumFound=$(find ${TheSrcDir} -name ${TheName}}${LangExt} 2> /dev/null | wc -l)
									case ${NumFound} in
										#No other source code was found...make your main file
										0)
											UseRuby "newCode" ${name} "component" ${oldCode}
											;;
										*)
											;;
									esac
								#Make first source file
								else
									UseRuby "newCode" ${name} "main" ${oldCode}
								fi
								;;
						esac
						;;
				esac
			fi
			;;
		cli)
			local TheName=$(OtherColor $1)
			echo "${LangRun} ${TheName}"
			;;
		runCode|debug)
			local name=$1
			local TheBin
			name=$(UseRuby "removeExt" ${name})
			TheBin="${name}${LangExt}"
			local project=${CodeProject}
			local TheBinDir
			local UseProjectTemplate
			shift
			shift
			local Args=( "${@}" )
			#Handle Project Dir
			case ${project} in
				none)
					project=""
					TheBinDir=${LangBin}
					#Handle multiple files
					case ${name} in
						*","*)
							cd ${LangSrc}/
							if [ -z "${name}" ]; then
								echo "Unable to find the \"main\" file"
								echo -n "Please choose: "
								read name
							fi
							cd - /dev/null
							TheBin="${name}"
							;;
						*)
							;;
					esac
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					TheBinDir="${LangProject}/${project}/bin"
					cd ${LangProject}/${project}/src/
					;;
			esac

			#Check if Python Bin exists
			if [ -f ${TheBinDir}/${TheBin} ]; then
				#protect the shell script while running
				chmod -w ${TheBinDir}/${TheBin} 2> /dev/null
				case ${Type} in
					debug)
						if [ -z "${Args[0]}" ]; then
							${LangRun} -m ${UseDebugger} ${TheBinDir}/${TheBin}
						else
							${LangRun} -m ${UseDebugger} ${TheBinDir}/${TheBin} "${Args[@]}"
						fi
						;;
					runCode)
						if [ ! -z "${ThePipe}" ]; then
							if [ ! -z "${TimeRun}" ]; then
								if [ -f "${MultiPipeFile}" ]; then
									if [ -z "${Args[0]}" ]; then
										time cat ${MultiPipeFile} | ${LangRun} ${TheBinDir}/${TheBin}
									else
										time cat ${MultiPipeFile} | ${LangRun} ${TheBinDir}/${TheBin} "${Args[@]}"
									fi
								else
									if [ -z "${Args[0]}" ]; then
										time cat /dev/stdin | ${LangRun} ${TheBinDir}/${TheBin}
									else
										time cat /dev/stdin | ${LangRun} ${TheBinDir}/${TheBin} "${Args[@]}"
									fi
								fi
							else
								if [ -f "${MultiPipeFile}" ]; then
									if [ -z "${Args[0]}" ]; then
										cat ${MultiPipeFile} | ${LangRun} ${TheBinDir}/${TheBin}
									else
										cat ${MultiPipeFile} | ${LangRun} ${TheBinDir}/${TheBin} "${Args[@]}"
									fi
								else
									if [ -z "${Args[0]}" ]; then
										cat /dev/stdin | ${LangRun} ${TheBinDir}/${TheBin}
									else
										cat /dev/stdin | ${LangRun} ${TheBinDir}/${TheBin} "${Args[@]}"
									fi
								fi
							fi
						else
							if [ ! -z "${TimeRun}" ]; then
								if [ -z "${Args[0]}" ]; then
									time ${LangRun} ${TheBinDir}/${TheBin}
								else
									time ${LangRun} ${TheBinDir}/${TheBin} "${Args[@]}"
								fi
							else
								if [ -z "${Args[0]}" ]; then
									${LangRun} ${TheBinDir}/${TheBin}
								else
									${LangRun} ${TheBinDir}/${TheBin} "${Args[@]}"
								fi
							fi
						fi
						;;
				esac
				#release protections
				chmod u+w ${TheBinDir}/${TheBin} 2> /dev/null
			else
				errorCode "cpl" "need" "${name}"
			fi
			;;
		backup|backup-remove|restore)
			local name=$1
			name=$(UseRuby "removeExt" ${name})
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
						backup-remove)
							if [ -f "${name}" ] && [ -f "${name}.bak" ]; then
								rm ${name}.bak
								echo "\"${name}\" backup removed"
							else
								TheCount=$(UseRuby "getProjSrc" "${name}" | wc -l)
								case ${TheCount} in
									0)
										errorCode "backup" "null"
										;;
									1)
										TheFound=$(UseRuby "getProjSrc" "${name}")
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
								TheCount=$(UseRuby "getProjSrc" "${name}" | wc -l)
								case ${TheCount} in
									0)
										errorCode "backup" "null"
										;;
									1)
										TheFound=$(UseRuby "getProjSrc" "${name}")
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
					if [ ! -z "${New}" ]; then
						TheOld=$(UseRuby "removeExt" ${Src})
						TheNew=$(UseRuby "removeExt" ${New})

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

					HasAnExt=$(UseRuby "hasExt" ${Src})
					if [ ! -f ${Src} ]; then
						#Extension is NOT given
						if [ -z "${HasAnExt}" ]; then
							#Find src
							CheckForSrc=$(UseRuby "getProjSrc" ${Src}${LangExt} 2> /dev/null)
							ThePath=${CheckForSrc%/*}
							Src=${CheckForSrc##*/}
						else
							CheckForFile=$(UseRuby "getProjSrc" ${Src} 2> /dev/null)
							if [ ! -z "${CheckForFile}" ]; then
								ThePath=${CheckForFile%/*}
							fi
						fi
					fi

					TheOld=${Src}
					HasAnExt=$(UseRuby "hasExt" ${New})
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

UseRuby "${@}"
