Shell=$(which bash)
#!${Shell}

SupportV="0.1.6"

ProgDir=$1
shift
ClideDir=$1
LibDir=${ClideDir}/lib
VarDir=${ClideDir}/var
shift
editor=$1
shift
ReadBy=$1
shift
CodeProject=$1
shift
ProjectType=$1
shift
TemplateProjectDir=$1
shift
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

UseGo()
{
	local Lang=Go
	local LangConfig=$(grep ${Lang} ${VarDir}/clide.conf | sed "s/${Lang}=//1")
	local LangCpl=${LangConfig}

#	local LangCpl=go
	local LangHome=${ProgDir}/${Lang}
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local LangExt=".go"
	local TemplateCode=${LangBin}/new${Lang}
	local Type=$1
	shift
	case ${Type} in
		color)
			#Return Green
			echo -e "\e[1;32m${Lang}\e[0m"
			;;
		ProjectColor)
			echo -e "\e[1;42m${CodeProject}\e[0m"
			;;
		getExt)
			echo ${LangExt}
			;;
		SupportVersion)
			echo ${SupportV}
			;;
		MenuHelp)
			echo -e "new <file> {main|header|component} : \"create new ${Lang} source file\""
			echo -e "cpl, compile\t\t\t: \"make code executable\""
			;;
		getCode)
			local name=$1
			case ${CodeProject} in
				none)
					if [ -f ${LangSrc}/${name}${LangExt} ]; then
						echo ${name}${LangExt}
					elif [ -f ${LangSrc}/${name}.h ]; then
						echo ${name}.h
					elif [ -f ${LangSrc}/${name} ]; then
						echo ${name}
					fi
					;;
				*)
					if [ -f ${LangSrc}/${CodeProject}/src/${name}${LangExt} ]; then
						echo ${name}${LangExt}
					elif [ -f ${LangSrc}/${CodeProject}/src/${name}.h ]; then
						echo ${name}.h
					elif [ -f ${LangSrc}/${project}/src/${name} ]; then
						echo ${name}
					fi
					;;
			esac
			;;
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
		BeforeFiles|AfterFiles)
			ls *${LangExt} *.h 2> /dev/null
			;;
		pgDir)
			#Return Go src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
			echo -e "make\t\t\t: create makefile"
			echo -e "version, -std=<c++#>\t: create makefile"
			;;
		shell)
			;;
		newCodeHelp)
			if [ -f ${TemplateCode} ]; then
				echo -e "-c, --custom\t\t\t: \"Custom src file using ${Lang} template\""
			fi
			;;
		EnsureDirs)
			#Home
			if [ ! -d "${LangHome}" ] && [ ! -z "${LangCpl}" ]; then
				mkdir "${LangHome}"
			fi
			#Src
			if [ ! -d "${LangSrc}" ] && [ ! -z "${LangCpl}" ]; then
				mkdir "${LangSrc}"
			fi
			#Bin
			if [ ! -d "${LangBin}" ] && [ ! -z "${LangCpl}" ]; then
				mkdir "${LangBin}"
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
			echo "[${Lang} Compiler]"
			${LangCpl} version | head -n 1
			echo ""
			;;
		selectCode)
			local name=$1
			#Correct filename
			if [[ ! "${name}" == *"${LangExt}" ]] && [ -f "${name}${LangExt}" ]; then
				name="${name}${LangExt}"
			elif [[ ! "${name}" == *".h" ]] && [ -f "${name}.h" ]; then
				name="${name}.h"
			fi
			#Return source file if exists
			if [ -f "${name}" ]; then
				echo "${name}"
			fi
			;;
		addCode)
			local src=$1
			local new=$2
			case ${src} in
				*${LangExt}|*.h)
					#Add cpp or header files with file extensions
					case ${new} in
						*${LangExt}|*.h)
							#Append file
							if [ -f "${new}" ]; then
								echo "${src},${new}"
							else
								echo "${src}"
							fi
							;;
						#Add cpp or header files without file extensions
						*)
							#Append cpp files
							if [ -f "${new}${LangExt}" ]; then
								echo "${src},${new}${LangExt}"
							#Append header files
							elif [ -f "${new}.h" ]; then
								echo "${src},${new}.h"
							else
								echo "${src}"
							fi
							;;
					esac
					;;
				*)
					;;
			esac
			;;
		editCode)
			local src=$1
			local num=$2
			case ${src} in
				*${LangExt}|*.h)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "editNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *"${LangExt}" ]] || [[ "${num}" == *".h" ]]; then
									${editor} ${num}
								else
									${editor} "${num}${LangExt}"
								fi
							else
								errorCode "editNot"
							fi
						fi
					else
						 ${editor} ${src}
					fi
					;;
				*)
					;;
			esac
			;;
		readCode)
			local src=$1
			local num=$2
			case ${src} in
				*${LangExt}|*.h)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "readNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *"${LangExt}" ]] || [[ "${num}" == *".h" ]]; then
									${ReadBy} ${num}
								else
									${ReadBy} "${num}${LangExt}"
								fi
							else
								errorCode "readNot"
							fi
						fi
					else
						${ReadBy} ${src}
					fi
					;;
				*)
					;;
			esac
			;;
		compileCode)
			local src=$1
			local name=$2
			local cplArgs=$3
			local project=${CodeProject}
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
					TheBinDir="${LangSrc}/${project}bin"
					;;
			esac
			if [[ "$src" == *"${LangExt}"* ]] || [ -f ${LangSrc}/${project}makefile ]; then
				cplArgs=${LangCplVersion}
				if [ -f ${LangSrc}/${project}makefile ]; then
					cd ${LangSrc}/${project}
					echo "make"
					cd - > /dev/null
					echo -e "\e[1;42m[${Lang} Code Compiled]\e[0m"
				else
					#Multiple code selected
					if [[ "${src}" == *","* ]]; then
						#num is empty
						if [ -z ${name} ]; then
							errorCode "cpl" "choose"
						else
							#Separate list of selected code
							prog=$(echo ${src} | sed "s/,/ /g")
							#Compile for Threads
							NeedThreads=$(grep "#include <thread>" ${prog})
							if [ ! -z "${NeedThreads}" ]; then
								cplArgs="${cplArgs} -lpthread"
							fi
							ERROR=$(${LangCpl} build ${prog} 2>&1 | tr '\n' '|')
							if [ -z "${ERROR}" ]; then
								mv ${prog%.*} ${LangBin}
								echo -e "\e[1;42m[${Lang} Code Compiled]\e[0m"
							else
								echo -en "\e[1;32m[${Lang} \e[0m"
								echo -en "\e[1;41mERROR\e[0m"
								echo -e "\e[1;32m]\e[0m"
								ERROR=$(echo ${ERROR} | tr '|' '\n')
								echo -e "\e[1;31m${ERROR}\e[0m"
							fi
						fi
					#single code selected
					else
						#Compile for threading
						NeedThreads=$(grep "#include <thread>" ${src})
						if [ ! -z "${NeedThreads}" ]; then
							cplArgs="${cplArgs} -lpthread"
						fi
						#Compile and move Go to Binary dir
						ERROR=$(${LangCpl} build ${src} 2>&1 | tr '\n' '|')
						if [ -z "${ERROR}" ]; then
							mv ${src%.*} ${LangBin}
							echo -e "\e[1;42m[${Lang} Code Compiled]\e[0m"
						else
							echo -en "\e[1;31m[\e[0m"
							echo -en "\e[1;41mERROR\e[0m"
							echo -e "\e[1;31m]\e[0m"
							ERROR=$(echo ${ERROR} | tr '|' '\n')
							echo -e "\e[1;31m${ERROR}\e[0m"
						fi
					fi
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
				if [ ! -z "${CplArgs}" ] && [[ "${CplArgs}" == *"c++"* ]]; then
					CplArgs="-std=${CplArgs}"
				else
					CplArgs="none"
				fi
			fi
			echo ${CplArgs}
			;;
		newProject)
			local type=$1
			local project=$2
			local path=${LangSrc}/${project}
			#create and cd to project dir
			if [ ! -d ${path} ]; then
				if [ -f ${TemplateProjectDir}/${Lang}.${type} ]; then
                                        ${TemplateProjectDir}/${Lang}.${type} newProject ${project}
                                else
					mkdir ${path}
					mkdir ${path}/bin
					mkdir ${path}/src
                                fi
				cd ${path}/src
			else
				cd ${path}/src
			fi
			echo ${path}
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
					path=${LangSrc}/${project}/bin
					;;
			esac
			if [ -d ${path} ]; then
				ls ${path}
			fi
			;;
		SwapToSrc)
			local src=$1
			#cd "${LangSrc}"
			#Get Go Name
			src="${src}${LangExt}"
			#Check if Go source exists
			if [ -f "${LangSrc}/${src}" ]; then
				#Return Go Source Name
				echo "${src}"
			fi
			;;
		SwapToBin)
			local bin=$1
			case ${bin} in
				*${LangExt})
					#cd "${LangBin}"
					#Keep Src Name
					local OldBin="${bin}"
					#Get Go Name
					bin="${bin%.*}"
					#Check if Go Binary exists
					if [ -f "${LangBin}/${bin}" ]; then
						#Return Go Binary Name
						echo "${bin}"
					else
						echo "${OldBin}"
					fi
					;;
				*)
					echo ${bin}
					;;
			esac
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
					TheBinDir="${LangSrc}/${project}bin"
					;;
			esac
			#Make sure Binary exists
			if [ -f "${TheBinDir}/${bin}" ]; then
				#Add command to Aliases
				AddAlias "${bin}" "${TheBinDir}/${bin}"
			elif [ ! -f "${TheBinDir}/${bin}" ]; then
				#compule or swap to binary
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
				if [ ! -z "${Args}" ];then
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
		newCode)
			local name=$1
			local Type=$2
			local oldCode=$3
			local project=${CodeProject}

			Type=$(echo ${Type} | tr A-Z a-z)
			name=${name%${LangExt}}
			name=${name%.h}
			if [ ! -f ${name}${LangExt} ]; then
				case ${Type} in
					#create main file
					main)
						#Check for Custom Code Template
						if [ -f ${TemplateCode} ]; then
							#Program Name Given
							if [ ! -z "${name}" ];then
								${TemplateCode} --random --write-file --read-file --cli --main --is-in --user-input --name ${name}
							#No Program Name Given
							else
								#Help Page
								${TemplateCode} --help
							fi
						else
							#Program Name Given
							if [ ! -z "${name}" ];then
								local Content="package main\n\nimport \"fmt\"\n\nfunc main() {\n\tfmt.Println(\"Hello, World!\")\n}"
								touch ${name}${LangExt}
								echo -e "${Content}" > ${name}${LangExt}
							else
								errorCode "newCode"
							fi
						fi
						;;
					#create component file
					component)
						if [ -f ${TemplateCode} ]; then
							#Program Name Given
							if [ ! -z "${name}" ];then
								${TemplateCode} -n "${name}"
							#No Program Name Given
							else
								#Help Page
								${TemplateCode} --help
							fi
						else
							#Program Name Given
							if [ ! -z "${name}" ];then
								touch ${name}${LangExt}
							else
								errorCode "newCode"
							fi
						fi
						;;
					#cl[ide] knows best
					*)
						#Is not a project
						case ${project} in
							none)
								UseGo "newCode" ${name} ${oldCode} ${Project} "main"
								;;
							#Is a project
							*)
								#clide knows best
								UseGo "newCode" ${name} ${oldCode} ${Project} "main"
								;;
						esac
						;;
				esac
			fi
			;;
		cli)
			local TheName=$1
			TheName=$(OtherColor "${TheName%.*}")
			echo "./${TheName}"
			;;
		runCode)
			local name=$1
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
					;;
				*)
					project="${project}/"
					TheBinDir="${LangSrc}/${project}bin"
					;;
			esac
			if [ -f ${TheBinDir}/${TheBin} ]; then
				${TheBinDir}/${TheBin} ${Args[@]}
			else
				errorCode "cpl" "need" "${name}"
			fi
			;;
		backup)
			local name=$1
			if [ ! -z "${name}" ]; then
				if [ ! -f "${LangSrc}/${name}.bak" ]; then
					cp ${LangSrc}/${name} ${LangSrc}/${name}.bak
					echo "\"${name}\" backed-up"
				else
					errorCode "backup" "exists"
				fi
			else
				errorCode "backup" "null"
			fi
			;;
		restore)
			local name=$1
			if [ ! -z "${name}" ]; then
				if [ -f "${LangSrc}/${name}.bak" ]; then
					mv ${LangSrc}/${name}.bak ${LangSrc}/${name}
					echo "\"${name}\" restored"
				else
					errorCode "restore" "exists"
				fi
                        else
				errorCode "restore" "null"
			fi
			;;
		rename)
			local TheOld=$1
			local TheNew=$2
			if [ ! -z "${TheNew}" ]; then
				TheOld="${TheOld%${LangExt}}" 
				TheNew="${TheNew%${LangExt}}"
				mv ${LangSrc}/${TheOld}${LangExt} ${LangSrc}/${TheNew}${LangExt}
				echo ${TheNew}${LangExt}
			fi
			;;
		copy)
			local TheOld=$1
			local TheNew=$2
			if [ ! -z "${TheNew}" ]; then
				TheOld="${TheOld%${LangExt}}" 
				TheNew="${TheNew%${LangExt}}"
				cp ${LangSrc}/${TheOld}${LangExt} ${LangSrc}/${TheNew}${LangExt}
				echo ${TheNew}${LangExt}
			fi
			;;
		*)
			;;
	esac
}

UseGo $@
