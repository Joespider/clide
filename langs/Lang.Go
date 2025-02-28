#!/usr/bin/env bash

SupportV="0.1.97"
Lang=Go
LangExt=".go"
#Color Green
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

UseGo()
{
	#Get the enviornment variables for Go
	#{
	local LangCpl=${cplGo}
	local UseDebugger=${debugGo}

	local LangHome=${ProgDir}/${Lang}
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local LangProject=${LangHome}/projects

	local TemplateCode=${NewGo}
	TemplateCode=${LangBin}/${TemplateCode%${LangExt}}

	local TemplateCodeSrc=${NewGo%${LangExt}}${LangExt}
	local TemplateCodeArgs=${NewGoArgs}
	local ShellCodeSrc="shell"${LangExt}

	local EnvVars=( ${LangRun} ${LangHome} ${LangSrc} ${LangBin} ${LangExt} )
	#}

	#Get action for from cl[ide]
	local Type=$1
	shift
	case ${Type} in
		#Go artwork
		Art)
			#https://textkool.com/en/ascii-art-generator
			#Font: Roman
			#Width: default
			#height: default
			local srt="\e[1;3${ColorNum}m"
			local end="\e[0m"
			echo -e "  ${srt}.oooooo.${end}"
			echo -e " ${srt}d8P'${end}  ${srt}\`Y8b${end}"
			echo -e "${srt}888${end}            ${srt}.ooooo.${end}"
			echo -e "${srt}888${end}           ${srt}d88'${end} ${srt}\`88b${end}"
			echo -e "${srt}888${end}     ${srt}ooooo${end} ${srt}888${end}   ${srt}888${end}"
			echo -e "${srt}\`88.${end}    ${srt}.88'${end}  ${srt}888${end}   ${srt}888${end}"
			echo -e " ${srt}\`Y8bood8P'${end}   ${srt}\`Y8bod8P'${end}"
			echo ""
			;;
		Lang-Type)
			local Get=$1
			case ${Get} in
				classified)
					echo "Programming"
					;;
				executable)
					echo "Binary"
					;;
				runtime)
					echo "Compiled"
					;;
				*)
					local Classified=$(UseGo ${Type} classified)
					local Exe=$(UseGo ${Type} executable)
					local RunTime=$(UseGo ${Type} runtime)
					echo -e "Classified:\t${Classified}"
					echo -e "Executable:\t${Exe}"
					echo -e "Runtime:\t${RunTime}"
					;;
			esac
			;;
		color)
			#Return Blue
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
		getShellCode)
			echo ${ShellCodeSrc}
			;;
		gencodeSave)
			local HasSponge
			local TheCode=${1}
			HasSponge=$(which sponge 2> /dev/null)
			if [ ! -z "${HasSponge}" ]; then
				TheCode=$(UseGo "removeExt" ${TheCode})
				TheCode=$(UseGo "FindTheSrc" ${TheCode})
				GenLines=$(cat -n ${TheCode} | grep "<<shell>>" | cut -f 1)
				if  [ ! -z "${GenLines}" ]; then
					UseGo "gencode" ${TheCode} | sponge ${TheCode}
				fi
			else
				echo "Please install \"sponge\" from the \"moreutils\" package"
			fi
			;;
		gencode)
			local LinesOfSrc
			local LastNum
			local GenLines
			local ShellCode
			local TheCode=${1}
			TheCode=$(UseGo "removeExt" ${TheCode})
			TheCode=$(UseGo "FindTheSrc" ${TheCode})
			GenLines=$(cat -n ${TheCode} | grep "<<shell>>" | cut -f 1)
			if  [ ! -z "${GenLines}" ]; then
				LinesOfSrc=$(cat ${TheCode} | wc -l)
				for line in ${GenLines};
				do
					if [ -z "${LastNum}" ]; then
						sed -n "1,$((${line} - 1))p" ${TheCode}
					else
						case ${line} in
							"$((${LastNum} - 1))"|"$((${LastNum} + 1))")
								;;
							*)
								sed -n "$((${LastNum} + 1)),$((${line} - 1))p" ${TheCode}
								;;
						esac
					fi
					ShellCode=$(sed -n "${line}p" ${TheCode} | grep "^<<shell>> ")
					if [ ! -z "${ShellCode}" ]; then
						echo ${ShellCode} | sed "s/^<<shell>> /\/\/<<shell>> /g"
						UseGo shell shell $(echo ${ShellCode} | sed "s/^<<shell>> //g")
					else
						sed -n "${line}p" ${TheCode}
					fi
					LastNum=${line}
				done
				sed -n "$((${LastNum} + 1)),${LinesOfSrc}p" ${TheCode}
			fi
			;;
		#source code directory
		getSrcDir)
			local project=${CodeProject}
			local UseProjectTemplate
			case ${project} in
				#not a project
				none)
					echo ${LangSrc}
					;;
				#is a project
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					pwd
					;;
			esac
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
		getDebugVersion)
			local debugV=$(${UseDebugger} --version 2> /dev/null | head -n 1)
			if [ ! -z "${debugV}" ]; then
				echo "${debugV}"
			fi
			;;
		getExt)
			echo ${LangExt}
			;;
		getOtherExt)
			;;
		SupportVersion)
			echo ${SupportV}
			;;
		MenuHelp)
			echo -e "new <file> <type>\t\t: \"create new ${Lang} source file\""
			echo -e "\t<file> main\t\t: \"create 'main' source file\""
			echo -e "\t<file> component\t: \"create 'component' source file\""
			echo -e "\t<file> header\t\t: \"create 'header' source file\""
			echo -e "\t\t\t\t: \"if no type is provide, cl[ide] will assume for you\""
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
		IsDebugEnabled)
#			local DebugFlag=$(echo ${CplArgs//,/ } | grep -w "\-g")
#			if [ ! -z "${DebugFlag}" ]; then
#				echo "yes"
#			fi
			;;
		getDebugger)
			echo "${UseDebugger}"
			;;
		getDebugVersion)
			local debugV=$(${UseDebugger} --version 2> /dev/null | head -n 1)
			if [ ! -z "${debugV}" ]; then
				echo "${debugV}"
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
		FindTheSrc)
			local name=$1
			local project=${CodeProject}
			local CheckForFile
			local ThePossible
			local ext
			if [ ! -z "${name}" ]; then
				case ${project} in
					none)
						case ${Type} in
							FindTheSrc)
								if [ -f "${name}${LangExt}" ]; then
									echo "${name}.go"
								fi
								;;
							*)
								;;
						esac

						;;
					*)
						case ${Type} in
							FindTheSrc)
								ext=${LangExt}
								ThePossible=".go"
								;;
							*)
								;;
						esac
						CheckForFile=$(UseGo "getProjSrc" ${name}${ext} 2> /dev/null)
						if [ -z "${CheckForFile}" ]; then
							for ext in ${ThePossible//,/ };
							do
								CheckForFile=$(UseGo "getProjSrc" ${name}${ext} 2> /dev/null)
								if [ ! -z "${CheckForFile}" ]; then
									echo ${CheckForFile}
									break
								fi
								look=$((${look}+1))
							done
						else
							echo ${CheckForFile}
						fi
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
		#Look for binary from set code
		getBin)
			local setCode=$1
			#if no code is set
			if [ ! -z "${setCode}" ]; then
				#Remove the extension
				local srcCode=${setCode}
				local TheCpl
				local TheItem
				#Get list of compiled code
				local CplList=$(UseGo lscpl | tr '\n' '|')
				#Get the number of set source code
				for TheItem in ${srcCode//,/ };
				do
					#Choose one item

					TheItem=$(UseGo "removeExt" ${TheItem})
					#Look for binary from list of compiled
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
			name=$(UseGo "removeExt" ${name})
			local oldCode=$2
			local project=${CodeProject}
			local newName
			local DirPath
			local TheSrcDir
			local UseProjectTemplate
			case ${project} in
				#Is not a project
				none)
					TheSrcDir=${LangSrc}
					;;
				#Is a project
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					case ${ProjectType} in
						#Is a generic project
						${ProjectDefaultType})
							#handle path
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
						#Is a specalized project
						*)
							#get source code from project template
							TheSrcDir=$(ProjectTemplateHandler "${EnvVars[@]}" ${Type} ${mode})
							;;
					esac
					;;
			esac

			#Account for extension based on set code
			case ${oldCode} in
				#set code has source code with default extension
				*"${name}${LangExt}"*)
					#normal source file exists
					#
					#if [ -f ${TheSrcDir}/${name}${LangExt} ]; then
					if [ -f ${name}${LangExt} ]; then
						#return default source file
						echo ${name}${LangExt}
					fi
					;;
				#no code as been set
				*)
					#normal source file exists
					#
					#if [ -f ${TheSrcDir}/${name}${LangExt} ]; then
					if [ -f ${name}${LangExt} ]; then
						echo ${name}${LangExt}
					#Extension is accounted for and is a file
					#
					#elif [ -f ${TheSrcDir}/${name} ]; then
					elif [ -f ${name} ]; then
						echo ${name}
					fi
					;;
			esac
			;;
		#check if compiler is installed
		pgLang)
			local ShowCpl=$1
			if [ ! -z "${ShowCpl}" ]; then
				echo ${LangCpl}
			else
				local HasLang=$(which ${LangCpl} 2> /dev/null)
				if [ ! -z "${HasLang}" ]; then
					#Return Go tag
					echo "${Lang}"
				else
					#Return rejection
					echo "no"
				fi
			fi
			;;
		#Look for source code before and after new source code created
		BeforeFiles|AfterFiles)
			ls *${LangExt} 2> /dev/null
			;;
		pgDir)
			#Return Go src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
			;;
		shell)
			UseGo "runCode" "${ShellCodeSrc}" "${@}"
			;;
		newCodeHelp)
			if [ -f ${TemplateCode} ]; then
				echo -e "\t-c, --custom <args>\t\t: \"Custom src file using ${Lang} template\""
				echo -e "\t-s, --show <args>\t\t: \"Show custom src code from ${Lang} template without saving\""
			fi
			;;
		#Make sure directories in place
		EnsureDirs)
			if [ ! -z "${LangCpl}" ]; then
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
		#Pull version from new template code
		TemplateVersion)
			if [ -f ${TemplateCode} ]; then
				echo -n "${TemplateCode##*/} "
				${TemplateCode} 2> /dev/null | grep Version | sed "s/Version//g"
			else
				echo "no ${TemplateCode##*/} found"
			fi
			;;
		#compiler version
		CplVersion)
			echo -e "\e[1;4${ColorNum}m[${Lang} Compiler]\e[0m"
			${LangCpl} version | head -n 1
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
			name=$(UseGo "removeExt" ${name})
			local ThePath
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
					name=${name}${LangExt}
					;;
				*)
					;;
			esac
			if [ -f ${ThePath}/${name} ]; then
				echo ${ThePath}/${name}
			fi
			;;
		editCode|readCode)
			local src=${TheCode}
			local num=$1
			local project=${CodeProject}
			local newName
			local DirPath
			local TheSrcDir
			local ReadOrEdit
			local UseProjectTemplate

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
												${ReadOrEdit} ${num}
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
									${ReadOrEdit} ${src}
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
		make)
			;;
		setCplArgs)
#			shift
#			shift
			Vals="none"
			Item=""
			str=( "${@}" )
			IFS=' '         # space is set as delimiter
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
			echo -e "--warnings\t\t: \"Show ALL warnings (-Wall -g)\""
			echo -e "--std=<version>\t\t: \"Set Go version\""
			;;
		compileCode-message)
			echo -e "\e[1;4${ColorNum}m[${Lang} Code Compiled]\e[0m"
			;;
		compileCode)
			local src=${TheCode}
			local name=$1
			local cplArgs=${CplArgs//,/ }
			local project=${CodeProject}
			local ReplaceTheSrcDir
			local TheSrcDir
			local TheBinDir
			local ERROR
			local FoundMain="yes"
			local NumOfMain
			local UseProjectTemplate

			#Handle Project Dir
			case ${project} in
				none)
					TheSrcDir=${LangSrc}
					project=""
					TheBinDir=${LangBin}
					#Handle multiple files
					if [ -z "${name}" ]; then
						case ${src} in
							*,*)
								src=${src//,/ }
								name=$(grep -l "func main(" ${src} 2> /dev/null)
								if [ -z "${name}" ]; then
									FoundMain="no"
								else
									NumOfMain=$(echo -e "${name// /\\n}" | wc -l)
									case ${NumOfMain} in
										1)
											name=$(UseGo "removeExt" ${name})
											;;
										*)
											FoundMain="no"
											errorCode "cpl" "ERROR" "More than one \"main\" files were found"
											;;
									esac
								fi
								;;
							*)
								name=$(UseGo "removeExt" ${src})
								;;
						esac
					fi
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					TheSrcDir="${LangProject}/${project}/src"
					ReplaceTheSrcDir=$(echo "${LangProject}/${project}src/" | tr '/' '|')
					src=$(find ${TheSrcDir} -type f -name "*${LangExt}" | tr '/' '|' | sed "s/${ReplaceTheSrcDir}//g" | tr '|' '/')
					name=$(grep -l "func main(" ${src} 2> /dev/null)
					if [ -z "${name}" ]; then
						FoundMain="no"
					else
						NumOfMain=$(echo -e "${name// /\\n}" | wc -l)
						case ${NumOfMain} in
							1)
								name=${name##*/}
								name=$(UseGo "removeExt" ${name})
								;;
							*)
								FoundMain="no"
								errorCode "cpl" "ERROR" "More than one \"main\" files were found"
								;;
						esac
					fi
					TheBinDir="${LangProject}/${project}/bin"
					;;
			esac

			#Compile ONLY if source code is selected OR makefile is present
			if [[ "${src}" == *"${LangExt}"* ]] || [ -f ${LangProject}/${project}makefile ]; then
				cd ${TheSrcDir}
				case ${cplArgs} in
					none)
						cplArgs=${LangCplVersion}
						;;
					*)
						cplArgs="${cplArgs} ${LangCplVersion}"
						;;
				esac
				#Compile with makefile
				if [ -f ${LangProject}/${project}makefile ]; then
					cd ${LangProject}/${project}
					echo "make"
					cd - > /dev/null
					UseGo compileCode-message
				#Compile without makefile
				else
					#source file is empty
					if [ -z "${name}" ]; then
						errorCode "cpl" "choose"
					else
						case ${FoundMain} in
							yes)
								#Compile and check for errors
								ERROR=$(${LangCpl} build ${src} 2>&1 | tr '\n' '|')
								#Code compiled successfully
								if [ -z "${ERROR}" ]; then
									case ${project} in
										none)
											mv ${name} ${TheBinDir}/
											;;
										*)
											mv ${name} ${TheBinDir}/${project}
											;;
									esac
									UseGo compileCode-message
								else
									errorCode "cpl" "ERROR" "${ERROR}"
								fi
								;;
							*)
								;;
						esac
					fi
					cd - > /dev/null
				fi
			fi
			;;
		create-make)
			case ${CodeProject} in
				#No Project
				none)
					echo "Project ${Lang} ONLY"
					;;
				#Is a project
				*)
					#makefile already exists
					if [ -f ${LangSrc}/${CodeProject}/makefile ]; then
						echo "makefile Already made for \"${CodeProject}\""
						#makefile already made
					else
						touch ${LangSrc}/${CodeProject}/makefile
						echo "makefile Created"
					fi
					;;
			esac
			;;
		create-version|create-std=*)
			Type=${Type#create-}
			local cLang=$(UseGo color)
			case ${UserIn[1]} in
				-std=*)
					CplArgs="${UserIn[1]}"
					;;
				*)
					CplArgs="${UserIn[2]}"
					;;
			esac
			if [ -z "${CplArgs}" ]; then
				echo -n "${cLang}\$ -std="
				read -a CplArgs
			fi
			if [ ! -z "${CplArgs}" ]; then
				case ${CplArgs} in
					-std=*)
						CplArgs=${CplArgs#-std=}
						;;
					*)
						;;
				esac
				if [ ! -z "${CplArgs}" ] && [[ "${CplArgs}" == *"Go"* ]]; then
					CplArgs="-std=${CplArgs}"
				else
					CplArgs="none"
				fi
			fi
			echo ${CplArgs}
			;;
		discoverProject)
			echo ${LangProject}
			;;
		newProject)
			local ProjectType=$1
			local project=$2
			local path=${LangProject}/${project}
			local UseProjectTemplate
			#create and cd to project dir
			if [ ! -d ${path} ]; then
				case ${ProjectType} in
					${ProjectDefaultType})
						mkdir -p ${path}/bin
						mkdir -p ${path}/build
						mkdir -p ${path}/doc
						mkdir -p ${path}/include
						mkdir -p ${path}/lib
						mkdir -p ${path}/spike
						mkdir -p ${path}/src
						mkdir -p ${path}/test
						cd ${path}/src
						;;
					*)
						UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type}) 
						mkdir -p ${path}
						if [ ! -z "${UseProjectTemplate}" ]; then
							ProjectTemplateHandler "${EnvVars[@]}" ${Type} ${project}
							if [ ! -d "${path}/bin/" ]; then
								mkdir -p ${path}/bin
							fi
							if [ ! -d "${path}/src/" ]; then
								mkdir -p ${path}/src
							fi
						else
							mkdir -p ${path}/bin
							mkdir -p ${path}/build
							mkdir -p ${path}/doc
							mkdir -p ${path}/include
							mkdir -p ${path}/lib
							mkdir -p ${path}/spike
							mkdir -p ${path}/src
							mkdir -p ${path}/test
						fi
						cd ${path}/src
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
					if [ -f "${TheBinDir}/${BinFile}" ]; then
						#Add command to Aliases
						AddAlias "${BinFile}" "${TheBinDir}/${BinFile}"
					elif [ ! -f "${TheBinDir}/${BinFile}" ]; then
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
					if [ -f "${TheBinDir}/${BinFile}" ]; then
						if [ -f ${ThePath}/${BinFile} ]; then
							errorCode "install" "already" "${BinFile}" "${ThePath}/"
							echo ""
							errorCode "HINT" "This must be done manually to protect from unwanted over-written binaries"
							errorCode "HINT" "command"
							case ${USER} in
								root)
									errorCode "HINT" "cp ${TheBinDir}/${BinFile} ${ThePath}/${BinFile}"
									;;
								*)
									errorCode "HINT" "sudo cp ${TheBinDir}/${BinFile} ${ThePath}/${BinFile}"
									;;
							esac
						else
							case ${USER} in
								root)
									cp ${TheBinDir}/${BinFile} ${ThePath}/${BinFile}
									;;
								*)
									sudo cp ${TheBinDir}/${BinFile} ${ThePath}/${BinFile}
									;;
							esac
						fi
					elif [ ! -f "${TheBinDir}/${BinFile}" ]; then
						#compile or swap to binary
						errorCode "install" "${BinFile}"
					else
						errorCode "noCode"
					fi
					;;
				Install-root)
					ThePath="/usr/sbin"
					#Make sure Binary exists
					if [ -f "${TheBinDir}/${BinFile}" ]; then
						if [ -f ${ThePath}/${BinFile} ]; then
							errorCode "install" "already" "${BinFile}" "${ThePath}/"
						else
							case ${USER} in
								root)
									cp ${TheBinDir}/${BinFile} ${ThePath}/${BinFile}
									;;
								*)
									sudo cp ${TheBinDir}/${BinFile} ${ThePath}/${BinFile}
									;;
							esac
						fi
					elif [ ! -f "${TheBinDir}/${BinFile}" ]; then
						#compile or swap to binary
						errorCode "install" "${BinFile}"
					else
						errorCode "noCode"
					fi
					;;
				Install-user)
					ThePath="~/bin"
					#Make sure Binary exists
					if [ -f "${TheBinDir}/${BinFile}" ]; then
						if [ -f ${ThePath}/${BinFile} ]; then
							errorCode "install" "already" "${BinFile}" "${ThePath}/"
						else
							if [ -d ${ThePath} ]; then
								cp ${TheBinDir}/${BinFile} ${ThePath}/${BinFile}
							else
								errorCode "ERROR"
								errorCode "ERROR" "${ThePath}/ does not exist"
							fi
						fi
					elif [ ! -f "${TheBinDir}/${BinFile}" ]; then
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
			if [ -f "${TheBinDir}/${BinFile}" ]; then
				echo "${TheBinDir}/${BinFile}"
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
					echo -n "./${cTemplate} "
					read -a Args
				fi
				#Program Args Given
				if [ ! -z "${Args}" ]; then
					${TemplateCode} "${Args[@]}"
				#No Program Name Given
				else
					#Help Page
					${TemplateCode} --help
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
					echo -n "./${cTemplate} --no-save "
					read -a Args
				fi
				#Program Args Given
				if [ ! -z "${Args}" ]; then
					${TemplateCode} --no-save "${Args[@]}"
				#No Program Name Given
				else
					#Help Page
					${TemplateCode} --help
				fi
			else
				#Program Name Given
				errorCode "customCode" "notemp" "${Lang}"
			fi
			;;
		#Create new src files
		newCode)
			local name=$1
			local CodeType=$2
			local oldCode=$3
			local TheName
			local project=${CodeProject}
			local UseProjectTemplate

			#Sometimes "oldCode" gets passed as "Type"
			if [ -z "${oldCode}" ]; then
				case ${CodeType} in
					*${LangExt})
						oldCode=${Type}
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
			name=$(UseGo "removeExt" ${name})

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
										${TemplateCode} --name ${name} --main ${TemplateCodeArgs}
									#No Program Name Given
									else
										#Help Page
										${TemplateCode} --help
									fi
								else
									#Program Name Given
									if [ ! -z "${name}" ]; then
										local Content="package main\n\nimport (\n\t\"fmt\"\n\t\"os\"\n)\n\nfunc main() {\n\targs := os.Args[1:]\n\n\tfor arg := range args {\n\t\tfmt.Println(arg,args[arg])\n\t}\n\tfmt.Println(\"And thats it!\")\n}"
										touch ${name}${LangExt}
										echo -e "${Content}" > ${name}${LangExt}
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
										${TemplateCode} -n "${name}"
									#No Program Name Given
									else
										#Help Page
										${TemplateCode} --help
									fi
								else
									#Program Name Given
									if [ ! -z "${name}" ]; then
										local Content="package main\n\nimport (\n\t"fmt"\n\t"os"\n)\n\nfunc main() {\n\targs := os.Args[1:]\n\n\tfor arg := range args {\n\tfmt.Println(arg,args[arg])\n\t}\n\tfmt.Println(\"And thats it!\")\n}"
										touch ${name}${LangExt}
										echo -e "${Content}" > ${name}${LangExt}
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
								if [ ! -z "${oldCode}" ]; then
									TheName=$(UseGo "removeExt" ${name})
									case ${TheName}${LangExt} in
										*"${oldCode}"*)
											;;
										#In the event you already have a main file, create a component
										*)
											#echo "component"
											UseGo "newCode" ${name} "component" ${oldCode}
											;;
									esac
								#No source code has been made, create a main file
								else
									#echo "main"
									UseGo "newCode" ${name} "main"
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
									TheName=$(UseGo "removeExt" ${name})
									local NumFound=$(find ${TheSrcDir} -name ${TheName}${LangExt} 2> /dev/null | wc -l)
									case ${NumFound} in
										#No other source code was found...make your main file
										0)
											UseGo "newCode" ${name} "component" ${oldCode}
											;;
										#Source code was found...make a component
										1)
											UseGo "newCode" ${name} "header" ${oldCode}
											;;
										*)
											;;
									esac
								#Make first source file
								else
									UseGo "newCode" ${name} "main" ${oldCode}
								fi
								;;
						esac
						;;
				esac
			fi
			;;
		cli)
			local TheName=$1
			local project=${CodeProject}
			#Handle Project Dir
			case ${project} in
				none)
					TheName=$(OtherColor "${TheName%.*}")
					echo "./${TheName}"
					;;
				*)
					TheName=$(OtherColor "${project}")
					echo "./${TheName}"
					;;
			esac
			;;
		#Run the compiled code
		runCode|debug)
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
					TheBin=$(UseGo "removeExt" ${name})
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

			#Handle multiple src files
			case ${name} in
				*","*)
					case ${project} in
						none)
							#Find the main file
							if [ ! -z "${name}" ]; then
								if [ -d "${TheSrcDir}" ]; then
									cd ${TheSrcDir}
									name=${name//,/ }
									name=$(grep -l "func main(" ${name} 2> /dev/null)
									if [ ! -z "${name}" ]; then
										TheBin=$(UseGo "removeExt" ${name})
									else
										TheBin=""
									fi
									cd - > /dev/null
								else
									TheBin=""
								fi
							fi
							;;
						*)
							;;
					esac
					;;
				*)
					;;
			esac

			#Find Executable
			if [ -f ${TheBinDir}/${TheBin} ]; then
				case ${Type} in
					debug)
						if [ ! -z "${ThePipe}" ]; then
							if [ -f "${MultiPipeFile}" ]; then
								if [ -z "${Args[0]}" ]; then
									cat ${MultiPipeFile} | ${UseDebugger} ${TheBinDir}/${TheBin}
								else
									cat ${MultiPipeFile} | ${UseDebugger} ${TheBinDir}/${TheBin} "${Args[@]}"
								fi
							else
								if [ -z "${Args[0]}" ]; then
									cat /dev/stdin | ${UseDebugger} ${TheBinDir}/${TheBin}
								else
									cat /dev/stdin | ${UseDebugger} ${TheBinDir}/${TheBin} "${Args[@]}"
								fi
							fi
						else
							if [ -z "${Args[0]}" ]; then
								${UseDebugger} ${TheBinDir}/${TheBin}
							else
								${UseDebugger} ${TheBinDir}/${TheBin} "${Args[@]}"
							fi
						fi
						;;
					runCode)
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
			else
				case ${project} in
					none)
						errorCode "cpl" "need" "${name}"
						;;
					*)
						errorCode "cpl" "need" "${TheBin}"
						;;
				esac
			fi
			;;
		backup|backup-remove|restore)
			local name=$1
			name=$(UseGo "removeExt" ${name})
			name="${name}${LangExt}"
			local project=${CodeProject}
			local TheDir
			local TheCount
			local TheFound
			local UseProjectTemplate

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
								TheCount=$(UseGo "getProjSrc" "${name}.bak" | wc -l)
								case ${TheCount} in
									0)
										errorCode "restore" "null"
										;;
									1)
										TheFound=$(UseGo "getProjSrc" "${name}.bak")
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
								TheCount=$(UseGo "getProjSrc" "${name}" | wc -l)
								case ${TheCount} in
									0)
										errorCode "backup" "null"
										;;
									1)
										TheFound=$(UseGo "getProjSrc" "${name}")
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
								TheCount=$(UseGo "getProjSrc" "${name}" | wc -l)
								case ${TheCount} in
									0)
										errorCode "backup" "null"
										;;
									1)
										TheFound=$(UseGo "getProjSrc" "${name}")
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
						TheOld=$(UseGo "removeExt" ${Src})
						TheNew=$(UseGo "removeExt" ${New})

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

					HasAnExt=$(UseGo "hasExt" ${Src})
					if [ ! -f ${Src} ]; then
						#Extension is NOT given
						if [ -z "${HasAnExt}" ]; then
							#Find src
							CheckForSrc=$(UseGo "getProjSrc" ${Src}${LangExt} 2> /dev/null)
							ThePath=${CheckForSrc%/*}
							Src=${CheckForSrc##*/}
						else
							CheckForFile=$(UseGo "getProjSrc" ${Src} 2> /dev/null)
							if [ ! -z "${CheckForFile}" ]; then
								ThePath=${CheckForFile%/*}
							fi
						fi
					fi

					TheOld=${Src}
					HasAnExt=$(UseGo "hasExt" ${New})
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

UseGo "${@}"
