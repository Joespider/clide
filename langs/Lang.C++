Shell=$(which bash)
#!${Shell}

SupportV="0.1.13"

ProgDir=$1
shift
ClideDir=$1
LibDir=${ClideDir}/lib
shift
editor=$1
shift
ReadBy=$1
shift
CodeProject=$1
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

UseCpp()
{
	local CppCpl=g++
	local LangHome=${ProgDir}/C++
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local TemplateCode=${LangBin}/newC++
	local Type=$1
	shift
	case ${Type} in
		color)
			#Return Blue
			echo -e "\e[1;34mC++\e[0m"
			;;
		ProjectColor)
			local text=$1
			if [ ! -z "${text}" ]; then
				echo -e "\e[1;44m${text}\e[0m"
			fi 
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
			if [ -f ${LangSrc}/${name}.cpp ]; then
				echo ${name}.cpp
			elif [ -f ${LangSrc}/${name}.h ]; then
				echo ${name}.h
			elif [ -f ${LangSrc}/${name} ]; then
				echo ${name}
			fi
			;;
		pgLang)
			local HasLang=$(which ${CppCpl} 2> /dev/null)
			if [ ! -z "${HasLang}" ]; then
				#Return C++ tag
				echo "C++"
			else
				#Return rejection
				echo "no"
			fi
			;;
		BeforeFiles|AfterFiles)
			ls *.cpp *.h 2> /dev/null
			;;
		pgDir)
			#Return C++ src Dir
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
			if [ ! -d "${LangHome}" ] && [ ! -z "${CppCpl}" ]; then
				mkdir "${LangHome}"
			fi
			#Src
			if [ ! -d "${LangSrc}" ] && [ ! -z "${CppCpl}" ]; then
				mkdir "${LangSrc}"
			fi
			#Bin
			if [ ! -d "${LangBin}" ] && [ ! -z "${CppCpl}" ]; then
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
			echo "[C++ Compiler]"
			${CppCpl} --version | head -n 1
			echo ""
			;;
		selectCode)
			local name=$1
			#Correct filename
			if [[ ! "${name}" == *".cpp" ]] && [ -f "${name}.cpp" ]; then
				name="${name}.cpp"
			elif [[ ! "${name}" == *".h" ]] && [ -f "${name}.h" ]; then
				name="${name}.h"
			fi
			echo ${name}
			;;
		addCode)
			local src=$1
			local new=$2
			case ${src} in
				*.cpp|*.h)
					#Add cpp or header files with file extensions
					case ${new} in
						*.cpp|*.h)
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
							if [ -f "${new}.cpp" ]; then
								echo "${src},${new}.cpp"
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
				*.cpp|*.h)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "editNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".cpp" ]] || [[ "${num}" == *".h" ]]; then
									${editor} ${num}
								else
									${editor} "${num}.cpp"
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
				*.cpp|*.h)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "readNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".cpp" ]] || [[ "${num}" == *".h" ]]; then
									${ReadBy} ${num}
								else
									${ReadBy} "${num}.cpp"
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
			local ERROR
			#Handle Project Dir
			if [[ "${project}" == "none" ]]; then
				project=""
			else
				project="${project}/"
			fi
			if [[ "$src" == *".cpp"* ]] || [ -f ${LangSrc}/${project}makefile ]; then
				cplArgs=${CppCplVersion}
				if [ -f ${LangSrc}/${project}makefile ]; then
					cd ${LangSrc}/${project}
					echo "make"
					cd - > /dev/null
					echo -e "\e[1;44m[C++ Code Compiled]\e[0m"
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
							ERROR=$(${CppCpl} ${prog} -o ../bin/${name} ${cplArgs} 2>&1 | tr '\n' '|')
							if [ -z "${ERROR}" ]; then
								echo -e "\e[1;44m[C++ Code Compiled]\e[0m"
							else
								echo -en "\e[1;34m[C++ \e[0m"
								echo -en "\e[1;41mERROR\e[0m"
								echo -e "\e[1;34m]\e[0m"
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
						#Compile and move C++ to Binary dir
						ERROR=$(${CppCpl} ${src} -o ../bin/${src%.*} ${cplArgs} 2>&1 | tr '\n' '|')
						if [ -z "${ERROR}" ]; then
							echo -e "\e[1;44m[C++ Code Compiled]\e[0m"
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
					echo "Project C++ ONLY"
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
			local cLang=$(UseCpp color)
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
			local project=$1
			local path=${LangSrc}/${project}
			#create and cd to project dir
			if [ ! -d ${path} ]; then
				mkdir ${path}
				cd ${path}
				mkdir bin build doc include lib spike src test
				cd src
			else
				cd ${path}/src
			fi
			echo ${path}
			;;
		SwapToSrc)
			local src=$1
			#cd "${LangSrc}"
			#Get C++ Name
			src="${src}.cpp"
			#Check if C++ source exists
			if [ -f "${LangSrc}/${src}" ]; then
				#Return C++ Source Name
				echo "${src}"
			fi
			;;
		SwapToBin)
			local bin=$1
			case ${bin} in
				*.cpp)
					#cd "${LangBin}"
					#Keep Src Name
					local OldBin="${bin}"
					#Get C++ Name
					bin="${bin%.*}"
					#Check if C++ Binary exists
					if [ -f "${LangBin}/${bin}" ]; then
						#Return C++ Binary Name
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
			#Make sure Binary exists
			if [ -f "${LangBin}/${bin}" ]; then
				#Add command to Aliases
				AddAlias "${bin}" "${LangBin}/${bin}"
			elif [ ! -f "${LangBin}/${bin}" ]; then
				#compule or swap to binary
				errorCode "install" "${bin}"
			else
				errorCode "noCode"
			fi
			;;
		customCode)
			local cLang=$(UseCpp "color")
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
			local Project=$2
			local Type=$3
			Type=$(echo ${Type} | tr A-Z a-z)
			name=${name%.cpp}
			name=${name%.h}
			if [ ! -f ${name}.cpp ] || [ ! -f ${name}.h ]; then
				case ${Type} in
					#create header file
				header)
					#Program Name Given
					if [ ! -z "${name}" ];then
						touch "${name}.h"
					else
						errorCode "newCode"
					fi
					;;
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
							local Content="#include <iostream>\n\n//C++ Main\nint main()\n{\n\n\treturn 0;\n}"
							touch ${name}.cpp
							echo -e "${Content}" > ${name}.cpp
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
							touch ${name}.cpp
						else
							errorCode "newCode"
						fi
					fi
					;;
				#cl[ide] knows best
				*)
					#Is not a project
					if [[ "${Project}" == "none" ]]; then
						UseCpp "newCode" ${name} ${oldCode} ${Project} "main"
					#Is a project
					else
						if [[ "${oldCode}" == *".cpp" ]] || [[ "${oldCode}" == *".cpp" ]]; then
							UseCpp "newCode" ${name} ${oldCode} ${Project} "component"
						else
							UseCpp "newCode" ${oldCode} ${Project} "main"
						fi
					fi
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
			local Args=$@
			local TheBin="${name%.*}"
			if [ -f ${LangBin}/${TheBin} ]; then
				${LangBin}/${TheBin} ${Args[@]}
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
		*)
			;;
	esac
}

UseCpp $@
