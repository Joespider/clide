#!/usr/bin/env bash

SupportV="0.1.90"
Lang=Perl
LangExt=".pl"
#Color Purple
ColorNum=5
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
		${LibDir}/errorCode.sh $@
	fi
}

#Handle Aliases
AddAlias()
{
	if [ -d ${LibDir} ] && [ -f ${LibDir}/AddAlias.sh ]; then
		${LibDir}/AddAlias.sh $@
	fi
}

OtherColor()
{
	local text=$1
	#Return Purple
	echo -e "\e[1;3${ColorNum}m${text}\e[0m"
}

ProjectTemplateHandler()
{
	if [ -d ${LibDir} ] && [ -f ${LibDir}/ProjectTemplateHandler.sh ]; then
		${LibDir}/ProjectTemplateHandler.sh ${Lang} $@
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
	local TemplateCodeArgs=${NewPerlArgs}

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
			echo -e "${srt}ooooooooo.${end}                      ${srt}oooo${end}"
			echo -e "${srt}\`888${end}   ${srt}\`Y88.${end}                    ${srt}\`888${end}"
			echo -e " ${srt}888${end}   ${srt}.d88'${end}  ${srt}.ooooo.${end}  ${srt}oooo${end} ${srt}d8b${end}  ${srt}888${end}" 
			echo -e " ${srt}888ooo88P'${end}  ${srt}d88'${end} ${srt}\`88b${end} ${srt}\`888\"\"8P${end}  ${srt}888${end}" 
			echo -e " ${srt}888${end}         ${srt}888ooo888${end}  ${srt}888${end}      ${srt}888${end}" 
			echo -e " ${srt}888${end}         ${srt}888${end}    ${srt}.o${end}  ${srt}888${end}      ${srt}888${end}" 
			echo -e "${srt}o888o${end}        ${srt}\`Y8bod8P'${end} ${srt}d888b${end}    ${srt}o888o${end}"
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
					local Classified=$(UsePerl ${Type} classified)
					local Exe=$(UsePerl ${Type} executable)
					local RunTime=$(UsePerl ${Type} runtime)
					echo -e "Classified:\t${Classified}"
					echo -e "Executable:\t${Exe}"
					echo -e "Runtime:\t${RunTime}"
					;;
			esac
			;;
		color)
			#Return Purple
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
			local srcCode=$(echo $1 | sed "s/${LangExt}//g")
			if [ ! -z "${srcCode}" ]; then
				local TheCpl
				local TheItem
				local CplList=$(UsePerl lscpl | tr '\n' '|')
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
			name=$(UsePerl "removeExt" ${name})
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
				echo -e "\t-c, --custom <args>\t\t: \"Custom src file using ${Lang} template\""
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
			local UseProjectTemplate
			#Correct filename
			if [ ! -z "${name}" ]; then
				name=$(UsePerl "removeExt" ${name})
				name=${name}${LangExt}
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
						UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
						local LookFor
						TheSrcDir="${LangProject}/${project}/src/"
						case ${Type} in
							addCode)
								new=$(UsePerl "removeExt" ${new})
								new=${new}${LangExt}
								LookFor=${new}
								;;
							selectCode)
								name=$(UsePerl "removeExt" ${name})
								name=${name}${LangExt}
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
											new=$(UsePerl "removeExt" ${new})
											newName=${new##*/}
											echo "${name},${newName}${LangExt}"
										else
											echo "${name}"
										fi
										;;
									selectCode)
										name=$(find ${TheSrcDir} -name ${name} 2> /dev/null)
										if [ -f ${name} ]; then
											name=$(UsePerl "removeExt" ${name})
											newName=${name##*/}
											echo ${newName}${LangExt}
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
			name=$(UsePerl "removeExt" ${name})
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
						theSrc=$(UsePerl "getProjSrc" ${name}${LangExt})
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
#			shift
#			shift
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
								ERROR=$(ln -s ../src/${src} 2>&1 | tr '\n' '|')
								;;
							*)
								local GetCount=$(UsePerl "getProjSrc" ${src} | wc -l)
								case ${GetCount} in
									0)
										;;
									1)
										src=$(UsePerl "getProjSrc" ${src})
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
			local UseProjectTemplate
			case ${ProjectType} in
				${ProjectDefaultType})
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					if [ ! -z "${UseTempalt}" ]; then
						ProjectTemplateHandler ${EnvVars[@]} ${Type} ${mode}
					fi
					;;
			esac
			;;
		lscpl)
			local project=${CodeProject}
			local path
			local UseProjectTemplate
			case ${CodeProject} in
				none)
					path=${LangBin}/
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					path=${LangProject}/${project}/bin
					;;
			esac
			if [ -d ${path} ]; then
				ls --color=auto ${path}
			fi
			;;
		Install|exe-string)
			bin=$1
			BinFile=$(UsePerl "removeExt" ${bin})
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

			case ${Type} in
				Install)
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
				exe-string)
					#Make sure Binary exists
					if [ -f "${TheBinDir}/${bin}" ]; then
						echo "${LangRun} ${TheBinDir}/${bin}"
					fi
					;;
				*)
					;;
			esac
			;;
		customCode)
			local cLang=$(UsePerl "color")
			local cTemplate=$(OtherColor ${TemplateCode##*/})
			if [ -f ${TemplateCode} ]; then
				shift
				shift
				shift
				shift
				Args=$@
				if [ -z "${1}" ]; then
					echo -n "${cLang}\$ ${LangRun} ${cTemplate} "
					read -a Args
				fi
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

			CodeType=${CodeType,,}
			name=$(UsePerl "removeExt" ${name})

			case ${project} in
				none)
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					;;
			esac

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
								TheName=$(UsePerl "removeExt" ${name})
								if [ ! -z "${oldCode}" ]; then
									UsePerl "newCode" ${name} "component" ${oldCode}
								#No source code has been made, create a main file
								else
									UsePerl "newCode" ${name} "main"
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
									TheName=$(UsePerl "removeExt" ${name})
									local NumFound=$(find ${TheSrcDir} -name ${TheName}}${LangExt} 2> /dev/null | wc -l)
									case ${NumFound} in
										#No other source code was found...make your main file
										0)
											UsePerl "newCode" ${name} "component" ${oldCode}
											;;
										*)
											;;
									esac
								#Make first source file
								else
									UsePerl "newCode" ${name} "main" ${oldCode}
								fi
								;;
						esac
						;;
				esac
			fi
			;;
		cli)
			local TheName=$(OtherColor $2)
			echo "${LangRun} ${TheName}"
			;;
		runCode|debug)
			local name=$1
			local TheBin=$(UsePerl "removeExt" ${name})
			TheBin=${TheBin}${LangExt}
			local project=${CodeProject}
			local TheBinDir
			local UseProjectTemplate
			shift
			shift
			local Args=$@
			#Handle Project Dir
			case ${project} in
				none)
					project=""
					TheBinDir=${LangBin}
					#cd ${LangSrc}/
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					TheBinDir="${LangProject}/${project}/bin"
					#cd ${LangProject}/${project}/src
					;;
			esac

			#Handle multiple files
			if [[ "${name}" == *","* ]]; then
				#name=${name//,/ }
				if [ -z "${name}" ]; then
					echo "Unable to find the \"main\" file"
					echo -n "Please choose: "
					read name
				fi
				TheBin="${name}"
			fi

			#Check if Perl Bin exists
			if [ -f ${TheBinDir}/${TheBin} ]; then
				chmod -w ${TheBinDir}/${TheBin} 2> /dev/null
				case ${Type} in
					debug)
						echo "no debugger for Perl"
						#${LangRun} -m ${UseDebugger} ${TheBinDir}/${TheBin} ${Args[@]}
						;;
					runCode)
						if [ ! -z "${ThePipe}" ]; then
							if [ ! -z "${TimeRun}" ]; then
								time cat /dev/stdin | ${LangRun} ${TheBinDir}/${TheBin} ${Args[@]}
							else
								cat /dev/stdin | ${LangRun} ${TheBinDir}/${TheBin} ${Args[@]}
							fi
						else
							if [ ! -z "${TimeRun}" ]; then
								time ${LangRun} ${TheBinDir}/${TheBin} ${Args[@]}
							else
								${LangRun} ${TheBinDir}/${TheBin} ${Args[@]}
							fi
						fi
						;;
				esac
				chmod u+w ${TheBinDir}/${TheBin} 2> /dev/null
			else
				errorCode "cpl" "need" "${name}"
			fi
			;;
		backup|restore)
			local name=$1
			name=$(UsePerl "removeExt" ${name})
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
						TheOld=$(UsePerl "removeExt" ${Src})
						TheNew=$(UsePerl "removeExt" ${New})

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
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					#Check if extenion is given
					local HasAnExt
					local CheckForSrc
					local ThePath

					HasAnExt=$(UsePerl "hasExt" ${Src})
					if [ ! -f ${Src} ]; then
						#Extension is NOT given
						if [ -z "${HasAnExt}" ]; then
							#Find src
							CheckForSrc=$(UsePerl "getProjSrc" ${Src}${LangExt} 2> /dev/null)
							ThePath=${CheckForSrc%/*}
							Src=${CheckForSrc##*/}
						else
							CheckForFile=$(UsePerl "getProjSrc" ${Src} 2> /dev/null)
							if [ ! -z "${CheckForFile}" ]; then
								ThePath=${CheckForFile%/*}
							fi
						fi
					fi

					TheOld=${Src}
					HasAnExt=$(UsePerl "hasExt" ${New})
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

UsePerl $@
