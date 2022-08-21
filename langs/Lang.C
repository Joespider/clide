#!/usr/bin/env bash

SupportV="0.1.83"
Lang=C
LangExt=".c"
LangOtherExt=".h"
ColorNum=3
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
	echo -e "\e[1;35m${text}\e[0m"
}

ProjectTemplateHandler()
{
	if [ -d ${LibDir} ] && [ -f ${LibDir}/ProjectTemplateHandler.sh ]; then
		${LibDir}/ProjectTemplateHandler.sh ${Lang} $@
	fi
}

UseC()
{
	#Get the enviornment variables for C
	#{
	local LangCpl=${cplC}
	local UseDebugger=${debugCandCpp}

	local LangHome=${ProgDir}/${Lang}
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local LangProject=${LangHome}/projects

	local TemplateCode=${NewC}
	TemplateCode=${LangBin}/${TemplateCode%${LangExt}}

	local TemplateCodeSrc=${NewC%${LangExt}}${LangExt}
	local TemplateCodeArgs=${NewCArgs}

	local TemplateCodeArgs=${NewCArgs}

	local EnvVars=( ${LangRun} ${LangHome} ${LangSrc} ${LangBin} ${LangExt} )
	#}

	#Get action for from cl[ide]
	local Type=$1
	shift
	case ${Type} in
		#C artwork
		Art)
			#https://textkool.com/en/ascii-art-generator
			#Font: Roman
			#Width: default
			#height: default
			local srt="\e[1;3${ColorNum}m"
			local end="\e[0m"
			echo -e "  ${srt}.oooooo.${end}"
			echo -e " ${srt}d8P'${end}  ${srt}\`Y8b${end}"
			echo -e "${srt}888${end}"
			echo -e "${srt}888${end}"
			echo -e "${srt}888${end}"
			echo -e "${srt}\`88b${end}    ${srt}ooo${end}"
			echo -e " ${srt}\`Y8bood8P'${end}"
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
					local Classified=$(UseC ${Type} classified)
					local Exe=$(UseC ${Type} executable)
					local RunTime=$(UseC ${Type} runtime)
					echo -e "Classified:\t${Classified}"
					echo -e "Executable:\t${Exe}"
					echo -e "Runtime:\t${RunTime}"
					;;
			esac
			;;
		color)
			#Return Yellow
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
		getExt)
			echo ${LangExt}
			;;
		getOtherExt)
			echo ${LangOtherExt}
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
			local TheHeaderDir=${LangProject}/${project}/include
			find ${TheSrcDir} -name *"${LangExt}" 2> /dev/null
			find ${TheHeaderDir} -name *"${LangOtherExt}" 2> /dev/null
			;;
		getProjSrc)
			local name=$1
			local project=${CodeProject}
			local TheSrcDir=${LangProject}/${project}/src
			local TheHeaderDir=${LangProject}/${project}/include
			local UseProjectTemplate
			if [ ! -z "${name}" ]; then
				case ${UseProjectTemplate} in
					none)
						;;
					*)
						UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
						;;
				esac

				case ${name} in
					${LangExt})
						find ${TheSrcDir} -name *"${LangExt}" 2> /dev/null
						;;
					${LangOtherExt})
						find ${TheHeaderDir} -name *"${LangOtherExt}" 2> /dev/null
						;;
					*)
						find ${TheSrcDir} -name "${name}" 2> /dev/null
						find ${TheHeaderDir} -name "${name}" 2> /dev/null
						;;
				esac
			fi
			;;
		IsDebugEnabled)
			local DebugFlag=$(echo ${CplArgs//,/ } | grep -w "\-g")
			if [ ! -z "${DebugFlag}" ]; then
				echo "yes"
			fi
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
		hasExtForCpl)
			local SourceFile=$1
			if [ ! -z "${SourceFile}" ]; then
				case ${SourceFile,,} in
					*${LangExt}*)
						echo "yes"
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
					*${LangOtherExt})
						echo ${SourceFile%${LangOtherExt}}
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
				local CplList=$(UseC lscpl | tr '\n' '|')
				for TheItem in ${srcCode//,/ };
				do
					#Choose one item
					TheItem=$(UseC "removeExt" ${TheItem})

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
			name=$(UseC "removeExt" ${name})
			local oldCode=$2
			local project=${CodeProject}
			local newName
			local DirPath
			local TheSrcDir
			local TheHeaderDir
			local UseProjectTemplate
			case ${project} in
				#Is not a project
				none)
					TheSrcDir=${LangSrc}
					TheHeaderDir=${LangSrc}
					;;
				#Is a project
				*)
					TheHeaderDir=${LangProject}/${project}/include
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
							UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
							#get source code from project template
							TheSrcDir=$(ProjectTemplateHandler ${EnvVars[@]} ${Type} ${mode})
							;;
					esac
					;;
			esac
			#Account for extension based on set code
			case ${oldCode} in
				#set code has source code with default extension
				*"${name}${LangExt}"*)
					#header file exists
					#
					if [ -f ${TheHeaderDir}/${name}${LangOtherExt} ]; then
						#return header file
						echo ${name}${LangOtherExt}
					fi
					;;
				#set code if source file is a header
				*"${name}${LangOtherExt}"*)
					#normal source file exists
					#
					if [ -f ${name}${LangExt} ]; then
						#return default source file
						echo ${name}${LangExt}
					fi
					;;
				#no code as been set
				*)
					#normal source file exists
					#
					if [ -f ${name}${LangExt} ]; then
						echo ${name}${LangExt}
					#header file exists
					#
					elif [ -f ${TheHeaderDir}/${name}${LangOtherExt} ]; then
						echo ${name}${LangOtherExt}
					#Extension is accounted for and is a file
					#
					elif [ -f ${TheSrcDir}/${name} ]; then
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
					#Return C tag
					echo "${Lang}"
				else
					#Return rejection
					echo "no"
				fi
			fi
			;;
		#Look for source code before and after new source code created
		BeforeFiles|AfterFiles)
			local project=${CodeProject}
			case ${project} in
				none)
					ls *${LangExt} *${LangOtherExt} 2> /dev/null
					;;
				*)
					find ${TheSrcDir} -name *${LangExt} 2> /dev/null
					find ${TheHeaderDir} -name *${LangOtherExt} 2> /dev/null
					;;
			esac
			;;
		pgDir)
			#Return C src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
			echo -e "make\t\t\t\t: create makefile"
			echo -e "version, -std=<c#>\t\t: compile with a specific version"
			;;
		shell)
			;;
		newCodeHelp)
			if [ -f ${TemplateCode} ]; then
				echo -e "\t-c, --custom <args>\t\t: \"Custom src file using ${Lang} template\""
			fi
			;;
		#Make sure directories in place
		EnsureDirs)
			if [ ! -z "${LangCpl}" ]; then
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
			${LangCpl} --version | head -n 1
			echo ""
			;;
		selectCode|addCode)
			local name=$1
			local new=$2
			local project=${CodeProject}
			local newName
			local DirPath
			local TheSrcDir
			local TheHeaderDir
			local UseProjectTemplate

			#Correct filename
			if [ ! -z "${name}" ]; then
				case ${project} in
					#not a project
					none)
						#"set" or "add"
						case ${Type} in
							#Used with "set"
							selectCode)
								#Add default or header files with file extensions
								case ${name} in
									#file contains extension
									*${LangExt}|*${LangOtherExt})
										;;
									*)
										#Correct filename
										if [[ ! "${name}" == *"${LangExt}" ]] && [[ -f "${name}${LangExt}" ]]; then
											name="${name}${LangExt}"
										elif [[ ! "${name}" == *"${LangOtherExt}" ]] && [[ -f "${name}${LangOtherExt}" ]]; then
											name="${name}${LangOtherExt}"
										fi
										;;
								esac
								#Return source file if exists
								if [ -f "${name}" ]; then
									echo "${name}"
								fi
								;;
							#Used with "add"
							addCode)
								#Evaluate set code
								case ${name} in
									#set code contains source code
									*${LangExt}|*${LangOtherExt})
										#Add default or header files with file extensions
										case ${new} in
											*${LangExt}|*${LangOtherExt})
												#Append file
												if [ -f "${new}" ]; then
													case ${name} in
														*${new}*)
															echo "${name}"
															;;
														*)
															echo "${name},${new}"
															;;
													esac
												else
													echo "${name}"
												fi
												;;
											#Add cpp or header files without file extensions
											*)
												case ${name} in
													#source code contains default code
													*"${new}${LangExt}"*)
														#Append header files
														if [ -f "${new}${LangOtherExt}" ]; then
															case ${name} in
																*${new}${LangOtherExt}*)
																	echo "${name}"
																	;;
																*)
																	echo "${name},${new}${LangOtherExt}"
																	;;
															esac
														fi
														;;
													#source code contains header file
													*"${new}${LangOtherExt}"*)
														#Append cpp files
														if [ -f "${new}${LangExt}" ]; then
															case ${name} in
																*${new}${LangExt}*)
																	echo "${name}"
																	;;
																*)
																	echo "${name},${new}${LangExt}"
																	;;
															esac
														fi
														;;
													*)
														#Append header files
														if [ -f "${new}${LangOtherExt}" ]; then
															echo "${name},${new}${LangOtherExt}"
														#Append cpp files
														elif [ -f "${new}${LangExt}" ]; then
															echo "${name},${new}${LangExt}"
														fi
														;;
												esac
												;;
										esac
										;;
									#Nothing has been set yet
									*)
										#do nothing
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
						local CheckForSrc
						local CheckForHeader
						local LookFor

						#"set" or "add"
						case ${Type} in
							selectCode)
								#Add default or header files with file extensions
								case ${name} in
									#file contains extension
									*${LangExt}|*${LangOtherExt})
										#echo "${name}"
										;;
									*)
										#Correct filename
										name=$(UseC "removeExt" ${name})
										CheckForSrc=$(UseC "getProjSrc" ${name}${LangExt} 2> /dev/null)
										CheckForHeader=$(UseC "getProjSrc" ${name}${LangOtherExt} 2> /dev/null)
										if [ ! -z "${CheckForSrc}" ]; then
											name="${name}${LangExt}"
										elif [ ! -z "${CheckForHeader}" ]; then
											name="${name}${LangOtherExt}"
										fi
										;;
								esac

								LookFor=${name}
								;;
							#Used with "add"
							addCode)
								#Evaluate set code
								case ${name} in
									#set code contains source code
									*${LangExt}|*${LangOtherExt})
										#Add default or header files with file extensions
										case ${new} in
											*${LangExt}|*${LangOtherExt})
												;;
											#Add cpp or header files without file extensions
											*)
												case ${name} in
													#source code contains default code
													*"${new}${LangExt}"*)
														new=${new}${LangOtherExt}
														;;
													#source code contains header file
													*"${new}${LangOtherExt}"*)
														new=${new}${LangExt}
														;;
													*)
														new=$(UseC "removeExt" ${new})
														CheckForSrc=$(UseC "getProjSrc" ${new}${LangExt} 2> /dev/null)
														CheckForHeader=$(UseC "getProjSrc" ${new}${LangOtherExt} 2> /dev/null)
														#Append cpp files
														if [ ! -z "${CheckForSrc}" ]; then
															new="${new}${LangExt}"
														#Append header files
														elif [ ! -z "${CheckForHeader}" ]; then
															new="${new}${LangOtherExt}"
														fi
														;;
												esac
												;;
										esac
										;;
									#Nothing has been set yet
									*)
										#do nothing
										;;
								esac
								LookFor=${new}
								;;
							*)
								;;
						esac
						#Check if exists and get number
						local NumFound=$(UseC "getProjSrc" ${LookFor} 2> /dev/null | wc -l)
						case ${NumFound} in
							#No files exist
							0)
								case ${Type} in
									#Return the old
									addCode)
										echo ${name}
										;;
									*)
										;;
								esac
								;;
							#One file exists
							1)
								case ${Type} in
									addCode)
										#Append file
										echo "${name},${LookFor}"
										;;
									selectCode)
										echo ${LookFor}
										;;
									*)
										;;
								esac
								;;
							*)
								echo ${name}
								;;
						esac
						;;
				esac
			fi
			;;
		rmBin|rmSrc)
			local name=$1
			name=$(UseC "removeExt" ${name})
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
					name=${name}${LangExt}
					;;
				*)
					;;
			esac

			if [ -f ${ThePath}/${name} ]; then
				echo ${ThePath}/${name}
			else
				case ${Type} in
					rmSrc)
						cd ${ThePath}/
						name=$(UseC "removeExt" ${name})
						theSrc=$(UseC "getProjSrc" ${name}${LangExt})
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
			local TheHeaderDir
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
				*${LangExt}|*${LangOtherExt})
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
							UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
							TheSrcDir="${LangProject}/${project}/src/"
							TheHeaderDir="${LangProject}/${project}/include/"
							local NumFound
							if [[ "${src}" == *","* ]]; then
								if [ -z "${num}" ]; then
									errorCode "editNull"
									NumFound=0
								else
									if [[ "${src}" == *"${num}"* ]]; then
										if [[ "${num}" == *"${LangExt}" ]] || [[ "${num}" == *"${LangOtherExt}" ]]; then
											src=${num}
										else
											src=${num}${LangExt}
										fi
										NumFound=$(find ${TheSrcDir} ${TheHeaderDir} -name ${src} 2> /dev/null | wc -l)
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
								NumFound=$(find ${TheSrcDir} ${TheHeaderDir} -name ${src} 2> /dev/null | wc -l)
							fi

							case ${NumFound} in
								0)
									;;
								1)
									src=$(find ${TheSrcDir} ${TheHeaderDir} -name ${src} 2> /dev/null)
									if [ -f ${src} ]; then
										#Read or Write Code
										#{
										${ReadOrEdit} ${src}
										#}
									fi
									;;
								*)
									local Select
									find ${TheSrcDir} ${TheHeaderDir} -name ${src} 2> /dev/null | sed "s/\/${project}\/src\//|/1" | cut -d '|' -f 2 | nl
									echo -n "> "
									read Select
									Select=$(echo ${Select} | grep "^-\?[0-9]*$")
									if [ ! -z "${Select}" ]; then
										if [ ${Select} -le ${NumFound} ] && [ ${Select} -gt 0 ]; then
											src=$(find ${TheSrcDir} ${TheHeaderDir} -name ${src} 2> /dev/null | tr '\n' '|' | cut -d '|' -f ${Select})
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
		handleCplArgs)
			local project=${CodeProject}
			local NeedThreads
			local HasXlib
			local HasXutil
			local HasXos
			local src=$1
			local UseProjectTemplate
			src=${src//,/ }
			local cplArgs=$2
			cplArgs=${cplArgs//,/ }

			case ${CplArgs} in
				none)
					cplArgs=""
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					;;
			esac

			case ${project} in
				none)
					if [ ! -z "${src}" ]; then
						NeedThreads=$(grep "#include <pthread.h>" ${src} 2> /dev/null | egrep -v "//|=|\"")
						HasXlib=$(grep "#include <X11/Xlib.h>" ${src} 2> /dev/null | egrep -v "//|=|\"")
						HasXutil=$(grep "#include <X11/Xutil.h>" ${src} 2> /dev/null | egrep -v "//|=|\"")
						HasXos=$(grep "#include <X11/Xos.h>" ${src} 2> /dev/null | egrep -v "//|=|\"")
					fi
					;;
				*)
					#Look in headers
					local GetHeaders=$(UseC "getProjSrc" ${LangOtherExt})
					local GetSrc=$(UseC "getProjSrc" ${LangExt})

					#Check headers for ALL values
					if [ ! -z "${GetHeaders}" ]; then
						NeedThreads=$(grep "#include <pthread.h>" "${GetHeaders}" 2> /dev/null | egrep -v "//|=|\"")
						HasXlib=$(grep "#include <X11/Xlib.h>" "${GetHeaders}" 2> /dev/null | egrep -v "//|=|\"")
						HasXutil=$(grep "#include <X11/Xutil.h>" "${GetHeaders}" 2> /dev/null | egrep -v "//|=|\"")
						HasXos=$(grep "#include <X11/Xos.h>" "${GetHeaders}" 2> /dev/null | egrep -v "//|=|\"")
					fi

					#Nothing found
					if [ ! -z "${GetSrc}" ]; then
						if [ -z "${NeedThreads}" ]; then
							#Look in source code
							NeedThreads=$(grep "#include <pthread.h>" "${GetSrc}" 2> /dev/null | egrep -v "//|=|\"")
						fi

						if [ -z "${HasXlib}" ] && [ -z "${HasXutil}" ] && [ -z "${HasXos}" ]; then
							HasXlib=$(grep "#include <X11/Xlib.h>" "${GetSrc}" 2> /dev/null | egrep -v "//|=|\"")
							HasXutil=$(grep "#include <X11/Xutil.h>" "${GetSrc}" 2> /dev/null | egrep -v "//|=|\"")
							HasXos=$(grep "#include <X11/Xos.h>" "${GetSrc}" 2> /dev/null | egrep -v "//|=|\"")
						fi
					fi

					;;
			esac

			#[Threads] Compile for Threads
			#{
			if [ ! -z "${NeedThreads}" ]; then
				case ${cplArgs} in
					*"-lpthread"*)
						;;
					*)
						if [ -z "${cplArgs}" ]; then
							cplArgs="-lpthread"
						else
							cplArgs="${cplArgs} -lpthread"
						fi
						;;
				esac
			fi
			#}
			#[X11] Compile with X11 code
			#{
			if [ ! -z "${HasXlib}" ] || [ ! -z "${HasXutil}" ] || [ ! -z "${HasXos}" ]; then
				case ${cplArgs} in
					*"-I /usr/X11/include -L /usr/X11/lib -lX11"*)
						;;
					*)
						if [ -z "${cplArgs}" ]; then
							cplArgs="-I /usr/X11/include -L /usr/X11/lib -lX11"
						else
							cplArgs="${cplArgs} -I /usr/X11/include -L /usr/X11/lib -lX11"
						fi
					;;
				esac
			fi
			#}

			echo ${cplArgs// /,}
			;;
		setCplArgs)
#			shift
#			shift
			local Vals="none"
			local Item=""
			local str=$@
			# space is set as delimiter
			local IFS=' '
			read -ra arg <<< "${str}"
			for TheItem in "${arg[@]}"; do
				if [ ! -z "${TheItem}" ]; then
					case ${TheItem} in
						-Ofast|--speed)
							Item="-Ofast"
							;;
						-Og|--opt-debug)
							Item="-Og"
							;;
						-Os|--opt-space)
							Item="-Os"
							;;
						--opt=*)
							#Get Number
							local optVal=${TheItem/--opt=/}
							optVal=$(echo ${optVal} | grep -o '[0-9]*')
							if [ ! -z "${optVal}" ]; then
								Item="-O${optVal}"
							fi
							;;
						-v|--verboses)
							Item="-v"
							;;
						-d|--debug)
							Item="-g"
							;;
						-t|--thread)
							Item="-lpthread"
							;;
						-x|--gui)
							Item="-I /usr/X11/include -L /usr/X11/lib -lX11"
							;;
						-w|--warnings)
							Item="-g"
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
			echo -e "--speed\t\t: \"Optomize speed over standards (-Ofast)\""
			echo -e "--opt=<num>\t\t: \"Set optimization level to <num> (-O<num>)\""
			echo -e "--opt-debug\t\t: \"Optimize debugging over speed or size (-Og)\""
			echo -e "--opt-space\t\t: \"Optimize space over speed (-Os)\""
			echo -e "-v, --verboses\t\t: \"Verbose (-v)\""
			echo -e "-d, --debug\t\t: \"Set Debugging (-g)\""
			echo -e "-t, --thread\t\t: \"Set Threading (-lpthread)\""
			echo -e "-x, --gui\t\t: \"Set GUI (-I /usr/X11/include -L /usr/X11/lib -lX11)\""
			echo -e "-w, --warnings\t\t: \"Show ALL warnings (-Wall)\""
			echo -e "--std=<version>\t\t: \"Set C version\""
			case ${LangCpl} in
				gcc)
					echo "These are SOME of the ${LangCpl} versions"
					echo "\tc98"
					echo "\tc11"
					echo "\tc14"
					echo "\tc17"
					echo "\tc2a"
					;;
				clang)
					;;
				*)
					;;
			esac
			;;
		compileCode-message)
			echo -e "\e[1;4${ColorNum}m[${Lang} Code Compiled]\e[0m"
			;;
		compileCodeMake-message)
			echo -e "\e[1;4${ColorNum}m[${Lang} Code Compiled (MAKE)]\e[0m"
			;;
		compileCode)
			local src=${TheCode}
			local TheHeaders
			local name=$1
			local TheBinFile
			local cplArgs=${CplArgs//,/ }
			local IsVerbose
			local project=${CodeProject}
			local HasAnExt
			local ReplaceThiscDir
			local ProjectDir
			local TheSrcDir
			local TheHeaderDir
			local TheBinDir
			local ERROR
			local FoundMain="yes"
			local NumOfMain
			local UseProjectTemplate
			local SuggestedVersion

			#Handle multiple files
			if [ -z "${name}" ]; then
				case ${src} in
					*,*)
						src=${src//,/ }
						name=$(grep -l "int main(" ${src} 2> /dev/null)
						if [ -z "${name}" ]; then
							FoundMain="no"
						else
							NumOfMain=$(echo -e "${name// /\\n}" | wc -l)
							case ${NumOfMain} in
								1)
									name=$(UseC "removeExt" ${name})
									;;
								*)
									FoundMain="no"
									errorCode "cpl" "ERROR" "More than one \"main\" files were found"
									;;
							esac
						fi
						;;
					*)
						name=$(UseC "removeExt" ${src})
						;;
				esac
			fi

			#Handle Project Dir
			case ${project} in
				none)
					TheSrcDir=${LangSrc}
					ProjectDir="${TheSrcDir}"
					project=""
					TheBinDir=${LangBin}
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					name=${project}
					project="${project}/"
					ProjectDir="${LangProject}/${project}"
					TheSrcDir="${ProjectDir}src"
					TheHeaderDir="${ProjectDir}include"
					#if NO code is selected, then select ALL
					#{
					#if [ -z "${src}" ]; then
					ReplaceThiscDir=$(echo "${ProjectDir}" | tr '/' '|')
					src=$(find ${TheSrcDir} -type f -name "*${LangExt}" | tr '/' '|' | sed "s/${ReplaceThiscDir}//g" | tr '|' '/')
					TheHeaders=$(find ${TheHeaderDir} -type f -name "*${LangOtherExt}" | tr '/' '|' | sed "s/${ReplaceThiscDir}//g" | tr '|' '/')
					if [ ! -z "${TheHeaders}" ]; then
						TheHeaders="-I include/"
					fi
					#fi
					#}
					TheBinDir="${ProjectDir}bin"
					;;
			esac

			HasAnExt=$(UseC "hasExtForCpl" ${src})
			#Compile ONLY if source code is selected OR makefile is present
			if [ ! -z "${HasAnExt}" ] || [ -f ${LangProject}/${project}makefile ]; then
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
					cd ${ProjectDir}
					ERROR=$(make 1> /dev/null 2>&1 | tr '\n' '|')
					TheBinFile=$(ls bin/${name} 2> /dev/null)
					cd - > /dev/null
					#Code compiled did compile
					if [ -z "${ERROR}" ] && [ ! -z "${TheBinFile}" ]; then
						UseC compileCodeMake-message
					#Code compiled did NOT compile
					else
						SuggestedVersion=$(UseC "SuggestCVersion" ${ERROR})
						if [ ! -z "${SuggestedVersion}" ]; then
							errorCode "cpl" "CVersion" ${SuggestedVersion}
						else
							if [ -z "${ERROR}" ]; then
								ERROR="Please Check makefile for issues"
							fi
							#display the ERROR message
							errorCode "cpl" "ERROR" "${ERROR}"
						fi

					fi
				#Compile without makefile
				else
					cd ${ProjectDir}
					#source file is empty
					if [ -z "${name}" ]; then
						errorCode "cpl" "choose"
					else
						case ${FoundMain} in
							yes)
								local CheckSrc=${src// /,}
								cplArgs=${cplArgs// /,}
								cplArgs=$(UseC "handleCplArgs" ${CheckSrc} ${cplArgs})
								cplArgs=${cplArgs//,/ }

								#Handle Verbose
								#{
								IsVerbose=$(echo ${cplArgs} | grep -w "\-v" 2> /dev/null)
								#}
								if [ -z "${IsVerbose}" ]; then
									#Compile and check for errors...and put into binary directory
									ERROR=$(${LangCpl} ${TheHeaders} ${src} -o ${TheBinDir}/${name} ${cplArgs} 2>&1 | tr '\n' '|')

									#Code compiled successfully
									if [ -z "${ERROR}" ]; then
										UseC compileCode-message
									else
										SuggestedVersion=$(UseC "SuggestCVersion" ${ERROR})
										if [ ! -z "${SuggestedVersion}" ]; then
											errorCode "cpl" "CVersion" ${SuggestedVersion}
										else
											#display the ERROR message
											errorCode "cpl" "ERROR" "${ERROR}"
										fi
									fi
								else
									#compile code and get verbose output
									ERROR=$(${LangCpl} ${TheHeaders} ${src} -o ${name} ${cplArgs} 2>&1 | tr '\n' '|')
									#Code compiled successfully because binary exists
									if [ -f ${name} ]; then
										#display the verbose GOOD output
										errorCode "cpl" "Verbose" "${ERROR}"
										#move binary to bin directory
										mv ${name} ${TheBinDir}/
										echo ""
										UseC compileCode-message
									#Code compiled did NOT compile
									else
										SuggestedVersion=$(UseC "SuggestCVersion" ${ERROR})
										if [ ! -z "${SuggestedVersion}" ]; then
											errorCode "cpl" "CVersion" ${SuggestedVersion}
										else
											#display the ERROR message
											errorCode "cpl" "ERROR" "${ERROR}"
										fi
									fi
								fi
								;;
							*)
								;;
						esac
						cd - > /dev/null
					fi
				fi
			fi
			;;
		create-make)
			local src=${TheCode}
			local UseProjectTemplate

			src="${src//,/ /}"
			case ${CodeProject} in
				#No Project
				none)
					errorCode "make" "need-to-be-project" ${Lang}
					;;
				#Is a project
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					#makefile already exists
					if [ -f ${LangProject}/${CodeProject}/makefile ]; then
						errorCode "make" "already"
					else
						local TheMakeArgs
						local cplArgs=${CplArgs// /,}
						if [ ! -z "${src}" ]; then
							local CheckSrc=${src// /,}
							cplArgs=$(UseC "handleCplArgs" "${CheckSrc}" ${cplArgs})
						else
							cplArgs=$(UseC "handleCplArgs" "none" ${cplArgs})
						fi
						cplArgs=${cplArgs//,/ }
						if [ -z "${cplArgs}" ]; then
							if [ ! -z "${src}" ]; then
								TheMakeArgs="CC = ${LangCpl}\n\nVPATH = src include\n\nall: ${CodeProject}\n\n${CodeProject}: ${src}\n\t\$(CC) -o bin/\$@ \$<"
							else
								TheMakeArgs="CC = ${LangCpl}\n\nall: ${CodeProject}\n\n${CodeProject}:\n\t\$(CC) -o bin/${CodeProject} src/"
							fi
						else
							if [ ! -z "${src}" ]; then
								TheMakeArgs="CC = ${LangCpl}\nCFLAGS = ${cplArgs}\n\nVPATH=src\n\nall: ${CodeProject}\n\n${CodeProject}: ${src}\n\t\$(CC) -o bin/\$@ \$< \$(CFLAGS)"
							else
								TheMakeArgs="CC = ${LangCpl}\nCFLAGS = ${cplArgs}\n\nall: ${CodeProject}\n\n${CodeProject}:\n\t\$(CC) -o bin/${CodeProject} src/ \$(CFLAGS)"
							fi
						fi

						touch ${LangProject}/${CodeProject}/makefile
						echo -e "${TheMakeArgs}" > ${LangProject}/${CodeProject}/makefile
						errorCode "HINT" "makefile Created"
					fi
					;;
			esac
			;;
		edit-make)
			case ${CodeProject} in
				#No Project
				none)
					;;
				#Is a project
				*)
					#makefile already exists
					if [ -f ${LangProject}/${CodeProject}/makefile ]; then
						${editor} ${LangProject}/${CodeProject}/makefile
					else
						errorCode "make" "edit-make"
					fi
					;;
			esac
			;;
		disable-make)
			case ${CodeProject} in
				#No Project
				none)
					errorCode "make" "need-to-be-project" ${Lang}
					;;
				#Is a project
				*)
					#makefile already exists
					if [ -f ${LangProject}/${CodeProject}/makefile ]; then
						mv ${LangProject}/${CodeProject}/makefile ${LangProject}/${CodeProject}/makeDisabled
						errorCode "HINT" "makefile disabled"
					fi
					;;
			esac
			;;
		enable-make)
			case ${CodeProject} in
				#No Project
				none)
					errorCode "make" "need-to-be-project" ${Lang}
					;;
				#Is a project
				*)
					#makefile already exists
					if [ -f ${LangProject}/${CodeProject}/makeDisabled ]; then
						mv ${LangProject}/${CodeProject}/makeDisabled ${LangProject}/${CodeProject}/makefile
						errorCode "HINT" "makefile enabled"
					fi
					;;
			esac
			;;
		delete-make)
			case ${CodeProject} in
				#No Project
				none)
					errorCode "make" "need-to-be-project" ${Lang}
					;;
				#Is a project
				*)
					#makefile already exists
					if [ -f ${LangProject}/${CodeProject}/makeDisabled ]; then
						rm ${LangProject}/${CodeProject}/makeDisabled
					fi
					if [ -f ${LangProject}/${CodeProject}/makefile ]; then
						rm ${LangProject}/${CodeProject}/makefile
					fi
					;;
			esac
			;;
		create-version|create-std=*)
			Type=${Type#create-}
			local cLang=$(UseC color)
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
				if [ ! -z "${CplArgs}" ] && [[ "${CplArgs}" == *"c"* ]]; then
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
						mkdir ${path}
						mkdir ${path}/bin
						mkdir ${path}/build
						mkdir ${path}/doc
						mkdir ${path}/include
						mkdir ${path}/lib
						mkdir ${path}/spike
						mkdir ${path}/src
						mkdir ${path}/test
						;;
					*)
						UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
						mkdir ${path}
						if [ ! -z "${UseProjectTemplate}" ]; then
							ProjectTemplateHandler ${EnvVars[@]} ${Type} ${project}
							if [ ! -d ${path}/bin ]; then
								mkdir ${path}/bin
							fi
							if [ ! -d ${path}/src ]; then
								mkdir ${path}/src
							fi
						else
							mkdir ${path}/bin
							mkdir ${path}/build
							mkdir ${path}/doc
							mkdir ${path}/include
							mkdir ${path}/lib
							mkdir ${path}/spike
							mkdir ${path}/src
							mkdir ${path}/test
						fi
						;;
				esac
				cd ${path}/src
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
		exe-string)
			local bin=$1
			local BinFile=$(UseC "removeExt" ${bin})
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
			if [ -f "${TheBinDir}/${BinFile}" ]; then
				echo "${TheBinDir}/${BinFile}"
			fi
			;;

		Install*)
			local bin=$1
			local BinFile=$(UseC "removeExt" ${bin%.*})
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
					TheBinDir="${LangProject}/${project}/bin"
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
						errorCode "install" "${BinFile}"
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
		customCode)
			local cLang=$(UseC "color")
			local cTemplate=$(OtherColor ${TemplateCode##*/})
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				shift
				shift
				shift
				shift
				Args=$@
				if [ -z "${1}" ]; then
					echo -n "${cLang}\$ ./${cTemplate} "
					read -a Args
				fi
				#Program Args Given
				if [ ! -z "${Args}" ]; then
					${TemplateCode} ${Args[@]}
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
			local TheHeaderDir

			case ${project} in
				none)
					;;
				*)
					TheHeaderDir=${LangProject}/${project}/include/
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					;;
			esac

			#Sometimes "oldCode" gets passed as "Type"
			if [ -z "${oldCode}" ]; then
				case ${CodeType} in
					*${LangOtherExt}|*${LangExt})
						oldCode=${CodeType}
						;;
					*)
						;;
				esac
			fi

			CodeType=${CodeType,,}
			case ${name} in
				*${LangOtherExt})
					name=$(UseC "removeExt" ${name})
					Type="header"
					;;
				*)
					name=$(UseC "removeExt" ${name})
					;;
			esac
			if [ ! -f ${name}${LangExt} ] || [ ! -f ${name}${LangOtherExt} ]; then
				case ${CodeType} in
					#create header file
					header)
						if [ ! -f ${TheHeaderDir}${name}${LangOtherExt} ]; then
							if [ -z "${UseProjectTemplate}" ]; then
								#Program Name Given
								if [ ! -z "${name}" ]; then
									touch "${TheHeaderDir}${name}${LangOtherExt}"
									echo "#pragma once" > "${TheHeaderDir}${name}${LangOtherExt}"
								else
									errorCode "newCode"
								fi
							else
								ProjectTemplateHandler ${ProjectType} ${Type} ${name}${LangOtherExt} ${CodeType}
							fi
						fi
						;;
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
										local Content="#include <stdio.h>\n\n#define bool int\n#define false 1\n#define true 0\n\n//${Lang} Main\nint main()\n{\n\n\treturn 0;\n}"
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
							UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
							if [ -z "${UseProjectTemplate}" ]; then
								if [ -f ${TemplateCode} ]; then
									#Program Name Given
									if [ ! -z "${name}" ]; then
										${TemplateCode} --name "${name}"
									#No Program Name Given
									else
										#Help Page
										${TemplateCode} --help
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
								TheName=$(UseC "removeExt" ${name})
								if [ ! -z "${oldCode}" ]; then
									if [ -f ${TheName}${LangExt} ]; then
										#echo "header"
										UseC "newCode" ${TheName}${LangOtherExt} "header" ${oldCode}
									else
										#echo "component"
										UseC "newCode" ${name} "component" ${oldCode}
									fi
								#No source code has been made, create a main file
								else
									if [ ! -f ${TheName}${LangExt} ]; then
										#echo "main"
										UseC "newCode" ${name} "main"
									else
										#echo "header"
										UseC "newCode" ${TheName}${LangOtherExt} "header"
									fi
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
									TheName=$(UseC "removeExt" ${name})
									local NumFound=$(find ${TheSrcDir} -name ${TheName}}${LangExt} 2> /dev/null | wc -l)
									case ${NumFound} in
										#No other source code was found...make your main file
										0)
											UseC "newCode" ${name} "component" ${oldCode}
											;;
										#Source code was found...make a component
										1)
											UseC "newCode" ${name} "header" ${oldCode}
											;;
										*)
											;;
									esac
								#Make first source file
								else
									UseC "newCode" ${name} "main" ${oldCode}
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
		runCode|debug)
			local name=$1
			local UseProjectTemplate
			shift
			shift
			local Args=$@
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
					TheBin=$(UseC "removeExt" ${name})
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
			if [[ "${name}" == *","* ]]; then
				case ${project} in
					none)
						#Find the main file
						if [ ! -z "${name}" ]; then
							if [ -d "${TheSrcDir}" ]; then
								cd ${TheSrcDir}
								name=${name//,/ }
								name=$(grep -l "int main(" ${name} 2> /dev/null)
								if [ ! -z "${name}" ]; then
									TheBin=$(UseC "removeExt" ${name})
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
			fi

			#Find Executable
			if [ -f ${TheBinDir}/${TheBin} ]; then
				case ${Type} in
					debug)
						if [ ! -z "${ThePipe}" ]; then
							if [ -f "${MultiPipeFile}" ]; then
								cat ${MultiPipeFile} | ${UseDebugger} ${TheBinDir}/${TheBin} ${Args[@]}
							else
								cat /dev/stdin | ${UseDebugger} ${TheBinDir}/${TheBin} ${Args[@]}
							fi
						else
							${UseDebugger} ${TheBinDir}/${TheBin} ${Args[@]}
						fi
						;;
					runCode)
						if [ ! -z "${ThePipe}" ]; then
							if [ ! -z "${TimeRun}" ]; then
								if [ -f "${MultiPipeFile}" ]; then
									time cat ${MultiPipeFile} | ${TheBinDir}/${TheBin} ${Args[@]}
								else
									time cat /dev/stdin | ${TheBinDir}/${TheBin} ${Args[@]}
								fi
							else
								if [ -f "${MultiPipeFile}" ]; then
									cat ${MultiPipeFile} | ${TheBinDir}/${TheBin} ${Args[@]}
								else
									cat /dev/stdin | ${TheBinDir}/${TheBin} ${Args[@]}
								fi
							fi
						else
							if [ ! -z "${TimeRun}" ]; then
								time ${TheBinDir}/${TheBin} ${Args[@]}
							else
								${TheBinDir}/${TheBin} ${Args[@]}
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
		backup|restore)
			local name=$1
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
								TheCount=$(UseC "getProjSrc" "${name}.bak" | wc -l)
								case ${TheCount} in
									0)
										errorCode "restore" "null"
										;;
									1)
										TheFound=$(UseC "getProjSrc" "${name}.bak")
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
								TheCount=$(UseC "getProjSrc" "${name}" | wc -l)
								case ${TheCount} in
									0)
										errorCode "backup" "null"
										;;
									1)
										TheFound=$(UseC "getProjSrc" "${name}")
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
						TheOld=$(UseC "removeExt" ${Src})
						TheNew=$(UseC "removeExt" ${New})

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
					local HasAnExtSrc
					local HasAnExtHeader
					local CheckForCpp
					local CheckForHeader
					local ThePath

					HasAnExt=$(UseC "hasExtForAll" ${Src})
					#Extension is NOT given
					if [ -z "${HasAnExt}" ]; then
						if [ ! -f ${Src} ]; then
							#Evaluate if file exists by extension
							HasAnExtSrc=$(UseC "hasExtForSrc" ${Src})
							HasAnExtHeader=$(UseC "hasExtForHeader" ${Src})
							#selected in priority...default src
							if [ -z "${HasAnExtSrc}" ]; then
								name=$(UseC "removeExt" ${Src})
								#Find src
								CheckForCpp=$(UseC "getProjSrc" ${name}${LangExt} 2> /dev/null)
								ThePath=${CheckForCpp%/*}
								Src=${CheckForCpp##*/}
								#default header
							elif [ -z "${HasAnExtHeader}" ]; then
								#Find header
								CheckForHeader=$(UseC "getProjSrc" ${name}${LangOtherExt} 2> /dev/null)
								ThePath=${CheckForHeader%/*}
							fi
						fi
					else
						if [ ! -f ${Src} ]; then
							CheckForFile=$(UseC "getProjSrc" ${Src} 2> /dev/null)
							if [ ! -z "${CheckForFile}" ]; then
								HasAnExtSrc=$(UseC "hasExtForSrc" ${Src})
								HasAnExtHeader=$(UseC "hasExtForHeader" ${Src})
								ThePath=${CheckForFile%/*}
							fi
						else
							HasAnExtSrc=$(UseC "hasExtForSrc" ${Src})
							HasAnExtHeader=$(UseC "hasExtForHeader" ${Src})
						fi
					fi

					TheOld=${Src}

					HasAnExt=$(UseC "hasExtForAll" ${New})
					if [ -z "${HasAnExt}" ]; then
						if [ ! -z "${HasAnExtSrc}" ]; then
							TheNew="${New}${LangExt}"
						elif [ ! -z "${HasAnExtHeader}" ]; then
							TheNew="${New}${LangOtherExt}"
						fi
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

#init
UseC $@
