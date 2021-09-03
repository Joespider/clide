Shell=$(which bash)
#!${Shell}

SupportV="0.1.41"
Lang=Go
LangExt=".go"
#Color Green
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
	local TheType=$1
	local Action=$2
	shift
	shift
	${LibDir}/ProjectTemplateHandler.sh ${Lang} ${TheType} ${Action} $@
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

	local EnvVars=( ${LangRun} ${LangHome} ${LangSrc} ${LangBin} ${LangExt} )
	#}

	#Get action for from cl[ide]
	local Type=$1
	shift
	case ${Type} in
		#Go artwork
		Art)
			local srt="\e[1;3${ColorNum}m"
			local end="\e[0m"
			echo -e " ${srt}d888b${end}   ${srt}.d88b.${end}"
			echo -e "${srt}88'${end} ${srt}Y8b${end} ${srt}.8P${end}  ${srt}Y8.${end}"
			echo -e "${srt}88${end}      ${srt}88${end}    ${srt}88${end}"
			echo -e "${srt}88${end}  ${srt}ooo${end} ${srt}88${end}    ${srt}88${end}"
			echo -e "${srt}88.${end} ${srt}~8~${end} ${srt}\`8b${end}  ${srt}d8'${end}"
			echo -e " ${srt}Y888P${end}   ${srt}\`Y88P'${end}"
			echo ""
			;;
		color)
			#Return Blue
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
#			local DebugFlag=$(echo ${CplArgs} | tr ',' ' ' | grep -w "\-g")
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
				local look=1
				#Get the number of set source code
				local NumOfCpls=$(echo ${srcCode} | tr ',' '\n' | wc -l)
				while [ ${look} -le ${NumOfCpls} ];
				do
					#Choose one item
					TheItem=$(echo ${srcCode} | cut -d ',' -f ${look})
					TheItem=$(UseGo "removeExt" ${TheItem})
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
			name=$(UseGo "removeExt" ${name})
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
			local HasLang=$(which ${LangCpl} 2> /dev/null)
			if [ ! -z "${HasLang}" ]; then
				#Return Go tag
				echo "${Lang}"
			else
				#Return rejection
				echo "no"
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
			#Correct filename
			if [ ! -z "${name}" ]; then
				name=$(UseGo "removeExt" ${name})
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
						local LookFor
						TheSrcDir="${LangProject}/${project}/src/"
						case ${Type} in
							addCode)
								new=$(UseGo "removeExt" ${new})
								new=${new}${LangExt}
								LookFor=${new}
								;;
							selectCode)
								name=$(UseGo "removeExt" ${name})
								name=${name}${LangExt}
								LookFor=${name}
								;;
							*)
								;;
						esac

						local NumFound=$(find ${TheSrcDir} -name ${LookFor} 2> /dev/null | grep "${ProjectMode}" | wc -l)
						case ${NumFound} in
							0)
								;;
							1)
								case ${Type} in
									addCode)
										new=$(find ${TheSrcDir} -name ${new} 2> /dev/null | grep "${ProjectMode}")
										if [ -f ${new} ]; then
											new=$(UseGo "removeExt" ${new})
											newName=${new##*/}
											echo "${name},${newName}${LangExt}"
										else
											echo "${name}"
										fi
										;;
									selectCode)
										name=$(find ${TheSrcDir} -name ${name} 2> /dev/null | grep "${ProjectMode}")
										if [ -f ${name} ]; then
											name=$(UseGo "removeExt" ${name})
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
			name=$(UseGo "removeExt" ${name})
			local ThePath
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
						#Is NOT a project
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
										if [[ "${num}" == *"${LangExt}" ]]; then
											#Read or Write Code
											#{
											${ReadOrEdit} ${num}
											#}
										else
											#Read or Write Code
											#{
											${ReadOrEdit} "${num}${LangExt}"
											#}
										fi
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
						#Is a project
						*)
							if [[ "${src}" == *","* ]]; then
								echo "Please Add support for handling multiple source code"
							else
								TheSrcDir="${LangProject}/${project}/src/"

								local NumFound=$(find ${TheSrcDir} -name ${src} 2> /dev/null | grep "${ProjectMode}" | wc -l)
								case ${NumFound} in
									0)
										;;
									1)
										src=$(find ${TheSrcDir} -name ${src} 2> /dev/null | grep "${ProjectMode}")
										if [ -f ${src} ]; then
											#Read or Write Code
											#{
											${ReadOrEdit} ${src}
											#}
										fi
										;;
									*)
										local Select
										find ${TheSrcDir} -name ${src} 2> /dev/null | grep "${ProjectMode}" | sed "s/\/${project}\/src\//|/1" | cut -d '|' -f 2 | nl
										echo -n "> "
										read Select
										Select=$(echo ${Select} | grep "^-\?[0-9]*$")
										if [ ! -z "${Select}" ]; then
											if [ ${Select} -le ${NumFound} ] && [ ${Select} -gt 0 ]; then
												src=$(find ${TheSrcDir} -name ${src} 2> /dev/null | grep "${ProjectMode}" | tr '\n' '|' | cut -d '|' -f ${Select})
												#Read or Write Code
												#{
												${ReadOrEdit} ${src}
												#}
											fi
										fi
										;;
								esac

							fi
							;;
					esac
					;;
				*)
					;;
			esac
			;;
		make)
			local src=$1
			src=$(echo ${src} | tr ',' ' ')
			local cplArgs=${CplArgs}
			local project=${CodeProject}
			local NeedThreads
			local HasXlib
			local HasXutil
			local HasXos
			local TheBin=${project}
			local TheSrcDir="${LangProject}/${project}/src"
			local TheBinDir="${LangProject}/${project}/bin"

			case ${project} in
				none)
					;;
				*)

					#[Threads] Compile for Threads
					#{
					NeedThreads=$(grep "#include <thread>" ${src})
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

					#The Make file
					#{
					echo "#The Compiler for ${Lang}"
					echo "cpl = ${LangCpl}"
					case ${cplArgs} in
						none)
							;;
						*)
							echo ""
							echo "#Compile arguments"
							echo "cplArgs = ${cplArgs}"
							;;
					esac
					echo ""
					echo "The build target"
					echo "TheBin = ${TheBin}"
					echo ""
					echo "all: \$(TheBin)"
					echo ""
					echo "\$(TheBin): ${src}"
					case ${cplArgs} in
						none)
							echo -e "\t\$(cpl) ${src} -o ${TheBinDir}/\$(TheBin)"
							;;
						*)
							echo -e "\t\$(cpl) ${src} -o ${TheBinDir}/\$(TheBin) \$(cplArgs)"
							;;
					esac
					#}
					;;
			esac
			;;
		setCplArgs)
			shift
			shift
			Vals="none"
			Item=""
			str=$@
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
			local src=$1
			local name=$2
			local cplArgs=${CplArgs//,/ }
			local project=${CodeProject}
			local NeedThreads
			local HasXlib
			local HasXutil
			local HasXos
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
						name=$(grep -l "func main(" ${src} 2> /dev/null)
						if [ -z "${name}" ]; then
							FoundMain="no"
						else
							NumOfMain=$(echo ${name} | tr ' ' '\n' | wc -l)
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
									mv ${name} ${TheBinDir}/
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
			local cLang=$(UseGo "color")
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
					*${LangExt})
						oldCode=${Type}
						;;
					*)
						;;
				esac
			fi

			Type=${Type,,}
			name=$(UseGo "removeExt" ${name})

			if [ ! -f ${name}${LangExt} ]; then
				case ${Type} in
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
									local Content="package main\n\nimport (\n\t"fmt"\n\t"os"\n)\n\nfunc main() {\n\targs := os.Args[1:]\n\n\tfor arg := range args {\n\tfmt.Println(arg,args[arg])\n\t}\n\tfmt.Println(\"And thats it!\")\n}"
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
									local Content="package main\n\nimport (\n\t"fmt"\n\t"os"\n)\n\nfunc main() {\n\targs := os.Args[1:]\n\n\tfor arg := range args {\n\tfmt.Println(arg,args[arg])\n\t}\n\tfmt.Println(\"And thats it!\")\n}"
									touch ${name}${LangExt}
									echo -e "${Content}" > ${name}${LangExt}
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
		runCode)
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
				${TheBinDir}/${TheBin} ${Args[@]}
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
			name=$(UseGo "removeExt" ${name})
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
			TheOld=$(UseGo "removeExt" ${TheOld})
			TheOld="${TheOld}${LangExt}"
			TheNew=$(UseGo "removeExt" ${TheNew})
			TheNew="${TheNew}${LangExt}"
			local project=${CodeProject}
			case ${project} in
				none)
					if [ ! -z "${TheNew}" ]; then
						TheOld=$(UseGo "removeExt" ${TheOld})
						TheNew=$(UseGo "removeExt" ${TheNew})
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
							TheOld=$(UseGo "removeExt" ${TheOld})
							TheNew=$(UseGo "removeExt" ${TheNew})
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
							local TheCount=$(UseGo "getProjSrc" "${TheOld}" | wc -l)
							case ${TheCount} in
								1)
									local TheFound=$(UseGo "getProjSrc" "${TheOld}")
									#Get the dir
									TheDir=${TheFound%/*}
									#Get the file
									TheFound=${TheFound##*/}
									#Remove the extention
									TheOld=$(UseGo "removeExt" ${TheOld})
									TheNew=$(UseGo "removeExt" ${TheNew})
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
UseGo $@
