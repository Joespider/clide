Shell=$(which bash)
#!${Shell}

SupportV="0.1.41"
Lang=C
LangExt=".c"
LangOtherExt=".h"
ColorNum=3

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

	local EnvVars=( ${LangRun} ${LangHome} ${LangSrc} ${LangBin} ${LangExt} )
	#}

	#Get action for from cl[ide]
	local Type=$1
	shift
	case ${Type} in
		#C artwork
		Art)
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
		color)
			#Return Yellow
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
		#source code directory
		getSrcDir)
			local project=${CodeProject}
			case ${project} in
				#not a project
				none)
					echo ${LangSrc}
					;;
				#is a project
				*)
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
		IsDebugEnabled)
			local DebugFlag=$(echo ${CplArgs} | tr ',' ' ' | grep -w "\-g")
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
				local look=1
				#Get the number of set source code
				local NumOfCpls=$(echo ${srcCode} | tr ',' '\n' | wc -l)
				while [ ${look} -le ${NumOfCpls} ];
				do
					#Choose one item
					TheItem=$(echo ${srcCode} | cut -d ',' -f ${look})
					TheItem=$(UseC "removeExt" ${TheItem})

					#Look for binary from list of compiled
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
			name=$(UseC "removeExt" ${name})
			local oldCode=$2
			local project=${CodeProject}
			local newName
			local DirPath
			local TheSrcDir
			case ${project} in
				#Is not a project
				none)
					TheSrcDir=${LangSrc}
					;;
				#Is a project
				*)
					case ${ProjectType} in
						#Is a generic project
						Generic)
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
					#if [ -f ${TheSrcDir}/${name}${LangOtherExt} ]; then
					if [ -f ${name}${LangOtherExt} ]; then
						#return header file
						echo ${name}${LangOtherExt}
					fi
					;;
				#set code if source file is a header
				*"${name}${LangOtherExt}"*)
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
					#header file exists
					#
					#elif [ -f ${TheSrcDir}/${name}${LangOtherExt} ]; then
					elif [ -f ${name}${LangOtherExt} ]; then
						echo ${name}${LangOtherExt}
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
			local HasLang=$(which ${LangCpl} 2> /dev/null)
			if [ ! -z "${HasLang}" ]; then
				#Return C tag
				echo "${Lang}"
			else
				#Return rejection
				echo "no"
			fi
			;;
		#Look for source code before and after new source code created
		BeforeFiles|AfterFiles)
			ls *${LangExt} *${LangOtherExt} 2> /dev/null
			;;
		pgDir)
			#Return C src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
			echo -e "make\t\t\t: create makefile"
			echo -e "version, -std=<c#>\t: compile with a specific version"
			;;
		shell)
			;;
		newCodeHelp)
			if [ -f ${TemplateCode} ]; then
				echo -e "-c, --custom\t\t\t: \"Custom src file using ${Lang} template\""
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
#								find ${TheSrcDir} -name ${name} 2> /dev/null | nl
#								if [ -f ${name} ]; then
#									name=$(UseC "removeExt" ${name})
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
			name=$(UseC "removeExt" ${name})
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
										if [[ "${num}" == *"${LangExt}" ]] || [[ "${num}" == *"${LangOtherExt}" ]]; then
											src=${num}
										else
											src=${num}${LangExt}
										fi
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
		handleCplArgs)
			local NeedThreads
			local HasXlib
			local HasXutil
			local HasXos
			local src=$1
			local cplArgs=$2
			#[Threads] Compile for Threads
			#{
			NeedThreads=$(grep "#include <pthread.h>" ${src})
			if [ ! -z "${NeedThreads}" ]; then
				cplArgs="${cplArgs} -lpthread"
			fi
			#}
			#[X11] Compile with X11 code
			#{
			HasXlib=$(grep "#include <X11/Xlib.h>" ${src})
			HasXutil=$(grep "#include <X11/Xutil.h>" ${src})
			HasXos=$(grep "#include <X11/Xos.h>" ${src})
			if [ ! -z "${HasXlib}" ] || [ ! -z "${HasXutil}" ] || [ ! -z "${HasXos}" ]; then
				cplArgs="${cplArgs} -I /usr/X11/include -L /usr/X11/lib -lX11"
			fi
			#}
			echo ${cplArgs// /,}
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
			echo -e "-w, --warnings\t\t: \"Show ALL warnings (-Wall)\""
			echo -e "--std=<version>\t\t: \"Set C version\""
			case ${LangCpl} in
				gcc)
					echo "These are ALL the ${LangCpl} versions"
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
			local src=$1
			local name=$2
			local cplArgs=${CplArgs//,/ }
			local IsVerbose
			local project=${CodeProject}
			local HasAnExt
			local ReplaceTheSrcDir
			local TheSrcDir
			local TheBinDir
			local ERROR
			local FoundMain="yes"
			local NumOfMain

			#Handle multiple files
			if [ -z "${name}" ]; then
				case ${src} in
					*,*)
						src=$(echo ${src} | tr ',' ' ')
						name=$(grep -l "int main(" ${src} 2> /dev/null)
						if [ -z "${name}" ]; then
							FoundMain="no"
						else
							NumOfMain=$(echo ${name} | tr ' ' '\n' | wc -l)
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
					project=""
					TheBinDir=${LangBin}
					;;
				*)
					name=${project}
					project="${project}/"
					TheSrcDir="${LangProject}/${project}src"
					#if NO code is selected, then select ALL
					#{
					#if [ -z "${src}" ]; then
						ReplaceTheSrcDir=$(echo "${LangProject}/${project}src/" | tr '/' '|')
						src=$(find ${TheSrcDir} -type f -name "*${LangExt}" | tr '/' '|' | sed "s/${ReplaceTheSrcDir}//g" | tr '|' '/')
					#fi
					#}
					TheBinDir="${LangProject}/${project}bin"
					;;
			esac

			HasAnExt=$(UseC "hasExt" ${src})

			#Compile ONLY if source code is selected OR makefile is present
			if [ ! -z "${HasAnExt}" ] || [ -f ${LangProject}/${project}makefile ]; then
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
					ERROR=$(make 1> /dev/null 2>&1 | tr '\n' '|')
					cd - > /dev/null

					#Code compiled did compile
					if [ -z "${ERROR}" ]; then
						UseC compileCodeMake-message
					#Code compiled did NOT compile
					else
						#display the ERROR message
						errorCode "cpl" "ERROR" "${ERROR}"
					fi
				#Compile without makefile
				else
					#source file is empty
					if [ -z "${name}" ]; then
						errorCode "cpl" "choose"
					else
						case ${FoundMain} in
							yes)
								cplArgs=${cplArgs// /,}
								cplArgs=$(UseC "handleCplArgs" ${src} ${cplArgs})
								cplArgs=${cplArgs//,/ }

								IsVerbose=$(echo ${cplArgs} |grep -w "\-v" 2> /dev/null)
								if [ -z "${IsVerbose}" ]; then
									#Compile and check for errors...and put into binary directory
									ERROR=$(${LangCpl} ${src} -o ${TheBinDir}/${name} ${cplArgs} 2>&1 | tr '\n' '|')

									#Code compiled successfully
									if [ -z "${ERROR}" ]; then
										UseC compileCode-message
									else
										#display the ERROR message
										errorCode "cpl" "ERROR" "${ERROR}"
									fi
								else
									#compile code and get verbose output
									ERROR=$(${LangCpl} ${src} -o ${name} ${cplArgs} 2>&1 | tr '\n' '|')
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
										#display the ERROR message
										errorCode "cpl" "ERROR" "${ERROR}"
									fi
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
			local src=$1
			src="${src//,/ /}"
			case ${CodeProject} in
				#No Project
				none)
					errorCode "make" "need-to-be-project" ${Lang}
					;;
				#Is a project
				*)
					#makefile already exists
					if [ -f ${LangProject}/${CodeProject}/makefile ]; then
						errorCode "make" "already"
					else
						local TheMakeArgs
						local cplArgs
						case ${CplArgs} in
							none)
								if [ ! -z "${src}" ]; then
									TheMakeArgs="CC = ${LangCpl}\n\nVPATH=src\n\nall: ${CodeProject}\n\n${CodeProject}: ${src}\n\t\$(CC) -o bin/\$@ \$<"
								else
									TheMakeArgs="CC = ${LangCpl}\n\nall: ${CodeProject}\n\n${CodeProject}:\n\t\$(CC) -o bin/${CodeProject} src/"
								fi
								;;
							*)
								cplArgs="${CplArgs//,/ }"
								if [ ! -z "${src}" ]; then
									TheMakeArgs="CC = ${LangCpl}\nCFLAGS = ${cplArgs}\n\nVPATH=src\n\nall: ${CodeProject}\n\n${CodeProject}: ${src}\n\t\$(CC) -o bin/\$@ \$< \$(CFLAGS)"
								else
									TheMakeArgs="CC = ${LangCpl}\nCFLAGS = ${cplArgs}\n\nall: ${CodeProject}\n\n${CodeProject}:\n\t\$(CC) -o bin/${CodeProject} src/ \$(CFLAGS)"
								fi
								;;
						esac
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
			#create and cd to project dir
			if [ ! -d ${path} ]; then
				case ${ProjectType} in
					Generic)
						mkdir ${path}
						mkdir ${path}/bin
						mkdir ${path}/build
						mkdir ${path}/doc
						mkdir ${path}/include
						mkdir ${path}/lib
						mkdir ${path}/spike
						mkdir ${path}/src
						mkdir ${path}/test
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
		customCode)
			local cLang=$(UseC "color")
			local cTemplate=$(OtherColor ${TemplateCode##*/})
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				echo -n "${cLang}\$ ./${cTemplate} "
				read -a Args
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
			local Type=$2
			local oldCode=$3
			local TheName
			local project=${CodeProject}

			#Sometimes "oldCode" gets passed as "Type"
			if [ -z "${oldCode}" ]; then
				case ${Type} in
					*${LangOtherExt}|*${LangExt})
						oldCode=${Type}
						;;
					*)
						;;
				esac
			fi

			Type=${Type,,}
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
				case ${Type} in
					#create header file
					header)
						if [ ! -f ${name}${LangOtherExt} ]; then
							#Program Name Given
							if [ ! -z "${name}" ]; then
								touch "${name}${LangOtherExt}"
								echo "#pragma once" > "${name}${LangOtherExt}"
							else
								errorCode "newCode"
							fi
						fi
						;;
					#create main file
					main)
						if [ ! -f ${name}${LangExt} ]; then
							#Check for Custom Code Template
							if [ -f ${TemplateCode} ]; then
								#Program Name Given
								if [ ! -z "${name}" ]; then
									${TemplateCode} --random --write-file --read-file --cli --main --is-in --user-input --name ${name}
								#No Program Name Given
								else
									#Help Page
									${TemplateCode} --help
								fi
							else
								#Program Name Given
								if [ ! -z "${name}" ]; then
									local Content="#include <stdio.h>\n\n//${Lang} Main\nint main()\n{\n\n\treturn 0;\n}"
									touch ${name}${LangExt}
									echo -e "${Content}" > ${name}${LangExt}
								else
									errorCode "newCode"
								fi
							fi
						fi
						;;
					#create component file
					component)
						if [ ! -f ${name}${LangExt} ]; then
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
									touch ${name}${LangExt}
								else
									errorCode "newCode"
								fi
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
		#Run the compiled code
		runCode|debug)
			local name=$1

			#Handle Extension
			case ${name} in
				*${LangExt})
					;;
				*)
					name="${name}${LangExt}"
					;;
			esac

			shift
			shift
			local Args=$@
			local TheBin="${name%.*}"
			local project=${CodeProject}
			local TheBinDir

			#Handle Project Dir
			case ${project} in
				none)
					project=""
					TheBinDir=${LangBin}
					cd ${LangSrc}/
					;;
				*)
					TheBinDir="${LangProject}/${project}/bin"
					cd ${LangProject}/${project}/src/
					TheBin="${project}"
					;;
			esac

			#Handle multiple src files
			if [[ "${name}" == *","* ]]; then
				case ${project} in
					none)
						#Find the main file
						if [ ! -z "${name}" ]; then
							name=$(echo ${name} | tr ',' ' ')
							name=$(grep -l "int main(" ${name} 2> /dev/null)
							TheBin="${name%.*}"
						fi
						;;
					*)
						TheBinDir="${LangProject}/${project}/bin"
						TheBin="${project}"
						cd ${LangProject}/${project}/src
						;;
				esac
			fi

			#Find Executable
			if [ -f ${TheBinDir}/${TheBin} ]; then
				case ${Type} in
					debug)
						cd ${TheBinDir}
						${UseDebugger} ${TheBin}
						cd - > /dev/null
						;;
					runCode)
						${TheBinDir}/${TheBin} ${Args[@]}
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
			local TheOld=$(UseC "removeExt" $1)
			local TheNew=$(UseC "removeExt" $2)
			TheOld="${TheOld}${LangExt}"
			TheNew="${TheNew}${LangExt}"
			local project=${CodeProject}
			case ${project} in
				none)
					if [ ! -z "${TheNew}" ]; then
						TheOld=$(UseC "removeExt" ${TheOld})
						TheNew=$(UseC "removeExt" ${TheNew})
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
							TheOld=$(UseC "removeExt" ${TheOld})
							TheNew=$(UseC "removeExt" ${TheNew})
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
							local TheCount=$(UseC "getProjSrc" "${TheOld}" | wc -l)
							case ${TheCount} in
								1)
									local TheFound=$(UseC "getProjSrc" "${TheOld}")
									#Get the dir
									TheDir=${TheFound%/*}
									#Get the file
									TheFound=${TheFound##*/}
									#Remove the extention
									TheOld=$(UseC "removeExt" ${TheOld})
									TheNew=$(UseC "removeExt" ${TheNew})
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
#init
UseC $@
