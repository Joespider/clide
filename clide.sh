Shell=$(which bash)
#!${Shell}

#cl[ide] future features
#{
	#provide X11 support via -lX11 g++ flag
#}

#Version tracking
#Increment by 1 number per category
#1st # = Overflow
#2nd # = Additional features
#3rd # = Bug/code tweaks/fixes
Version="0.65.74"

#cl[ide] config
#{
editor=nano
ReadBy=less
Aliases=~/.bash_aliases
repoTool=git
#repoTool=svn

#Repo assist is for simplistic commands
#True = cl[ide] takes care of repo commands
repoAssist="True"
#False = User handles repo commands
#repoAssist="False"
#Repo mangement is neither run by user nor cl[ide]
#repoAssist=

Head="cl[ide]"
IDE=$(echo -e "\e[1;40mide\e[0m")
Name="cl${IDE}"

#Compilers/Interpreters
BashCpl=bash
PythonRun=python
PerlRun=perl
RubyRun=ruby
CppCpl=g++
JavaCpl=javac
JavaRun=java

#root dir
ProgDir=~/Programs
ClideDir=${ProgDir}/.clide

#Program Homes
BashHome=${ProgDir}/Bash
PythonHome=${ProgDir}/Python
PerlHome=${ProgDir}/Perl
RubyHome=${ProgDir}/Ruby
CppHome=${ProgDir}/C++
JavaHome=${ProgDir}/Java

#Soruce Code
BashSrc=${BashHome}/src
PythonSrc=${PythonHome}/src
PerlSrc=${PerlHome}/src
RubySrc=${RubyHome}/src
CppSrc=${CppHome}/src
JavaSrc=${JavaHome}/src

#Bin Code
BashBin=${BashHome}/bin
PythonBin=${PythonHome}/bin
PerlBin=${PerlHome}/bin
RubyBin=${RubyHome}/bin
CppBin=${CppHome}/bin
JavaBin=${JavaHome}/bin

#Global Vars
#{
Project=""
CodeProject="none"
RunTimeArgs=""
JavaRunProp=""
CppCplVersion=""
declare -A Commands
#}

#}


#Language Support
#{

UseBash()
{
	local BashCpl=bash
	local LangHome=${ProgDir}/Bash
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local TemplateCode=${LangBin}/newBash.sh
	local Type=$1
	shift
	case ${Type} in
		color)
			#Return Green
			echo -e "\e[1;32mBash\e[0m"
			;;
		MenuHelp)
			echo -e "new <file>\t\t\t: \"create new ${Lang} script\""
			echo -e "compile|cpl\t\t\t: \"make code executable\""
			;;
		pgLang)
			if [ ! -z "${BashCpl}" ]; then
				#Return Bash tag
				echo "Bash"
			else
				#Return rejection
				echo "no"
			fi
			;;
		pgDir)
			#Return Bash src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
			;;
		newCodeHelp)
			if [ -f ${TemplateCode} ]; then
				echo -e "--custom|-c\t\t\t: \"Custom src file using ${Lang} template\""
			fi
			;;
		EnsureDirs)
			#Home
			if [ ! -d "${LangHome}" ] && [ ! -z "${BashCpl}" ]; then
				mkdir "${LangHome}"
			fi
			#Src
			if [ ! -d "${LangSrc}" ] && [ ! -z "${BashCpl}" ]; then
				mkdir "${LangSrc}"
			fi
			#Bin
			if [ ! -d "${LangBin}" ] && [ ! -z "${BashCpl}" ]; then
				mkdir "${LangBin}"
			fi
			;;
		TemplateVersion)
			if [ -f ${TemplateCode} ]; then
				${TemplateCode} 2> /dev/null | grep Version
			else
				echo "no newBash.sh found"
			fi
			;;
		CodeVersion)
		echo "[Bash]"
			${BashCpl} --version | head -n 1
			;;
		selectCode)
			local name=$1
			#Correct filename
			if [[ ! "${name}" == *".sh" ]]; then
				name="${name}.sh"
			fi
			echo ${name}
			;;
			#Add code to active session
		addCode)
			local src=$1
			local new=$2
			case ${src} in
				*.sh)
					case ${new} in
						*.sh)
							if [ -f "${new}" ]; then
							echo "${src},${new}"
							else
								echo "${src}"
							fi
							;;
						*)
							if [ -f "${new}.sh" ]; then
								echo "${src},${new}.sh"
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
				*.sh)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "editNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".sh" ]]; then
									${editor} ${num}
								else
									${editor} "${num}.sh"
								fi
							else
								errorCode "editNot"
							fi
						fi
					else
						case ${src} in
							clide.sh)
								errorCode "editMe"
								;;
							*)
								${editor} ${src}
								;;
						esac
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
				*.sh)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "readNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".sh" ]]; then
									${ReadBy} ${num}
								else
									${ReadBy} "${num}.sh"
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
			local project=${CodeProject}
			local name=$2
			local keep=$3
			local cplArgs=""
			#Handle Project Dir
			if [[ "${project}" == "none" ]]; then
				project=""
			else
				project="${project}/"
			fi
			case ${src} in
				*.sh)
					#Multiple code selected
					if [[ "${src}" == *","* ]]; then
						#varable is empty
						if [ -z ${name} ]; then
							errorCode "cpl" "choose"
						else
							#chosen file is in the list of files
							if [[ "${src}" == *"${name}"* ]]; then
								#only name is given
								if [[ "${name}" != *".sh" ]]; then
									#full filename given
									num=${name}.sh
								fi
								#Make Bash Script executable
								chmod +x ${name}
								#Check if Bash Script does NOT exist
								if [[ ! -f "${LangBin}/${name}" ]]; then
									#Change to Bash Binary dir
									cd ${LangBin}
									#Create Symbolic Link to Bash Script
									ln -s ../src/${project}${name}
									#Change to Bash Source dir
									cd "${LangSrc}/${project}"
									echo -e "\e[1;42m[Bash Code Compiled]\e[0m"
								else
									errorCode "cpl" "already" ${name}
								fi
							else
								errorCode "cpl" "not"
							fi
						fi
					#single code selected
					else
						#Make Bash Script executable
						chmod +x ${src}
						#Check if Bash Script does NOT exist
						if [[ ! -f "${LangBin}/${src}" ]]; then
							#Change to Bash Binary dir
							cd ${LangBin}
							#Create Symbolic Link to Bash Script
							ln -s ../src/${project}${src}
							#Change to Bash Source dir
							cd "${LangSrc}/${project}"
							echo -e "\e[1;42m[Bash Code Compiled]\e[0m"
						else
							errorCode "cpl" "already" ${src}
						fi
					fi
					;;
				*)
					;;
			esac
			;;
		newProject)
			path=${LangSrc}/${project}
			if [ ! -d ${path} ]; then
				mkdir ${path}
				cd ${path}
				mkdir src bin
				cd ${path}/src
			else
				cd ${path}/srs
			fi
			echo ${path}
			;;
		SwapToSrc)
			local src=$1
			echo "${src}"
			;;
		SwapToBin)
			local bin=$1
			case ${bin} in
				*.sh)
					#Check if Bash Binary exists
					if [ -f "${LangBin}/${bin}" ]; then
						#Return Bash Binary Name
						#cd "${LangBin}"
						echo "${bin}"
					else
						echo "${bin}"
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
				AddAlias "${BinFile}" "${LangBin}/${bin}"
			elif [ ! -f "${LangBin}/${bin}" ]; then
				errorCode "install" "${bin}"
			else
				errorCode "noCode"
			fi
			;;
		customCode)
			local cLang=$1
			Type=$(echo ${Type} | tr A-Z a-z)
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				echo -n "${cLang}\$ ./newBash.sh "
				read -a Args
				#Template Args Given
				if [ ! -z "${Args}" ];then
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
			local Project=$2
			local Type=$3
			Type=$(echo ${Type} | tr A-Z a-z)
			name=${name%.sh}
			if [ ! -f ${name}.sh ]; then
				#Check for Custom Code Template
				if [ -f ${TemplateCode} ]; then
					#Program Name Given
					if [ ! -z "${name}" ];then
						${TemplateCode} ${name} > ${name}.sh
					#No Program Name Given
					else
						${TemplateCode} --help
					fi
				else
					#Program Name Given
					if [ ! -z "${name}" ];then
						touch ${name}.sh
					else
						errorCode "newCode"
					fi
				fi
			fi
			;;
		*)
			;;
	esac
}

UsePython()
{
	local PythonRun=python
	local LangHome=${ProgDir}/Python
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local TemplateCode=${LangBin}/newPython.py
	local Type=$1
	shift
	case ${Type} in
		color)
			#Return Yellow
			echo -e "\e[1;33mPython\e[0m"
			;;
		MenuHelp)
			echo -e "new <file>\t\t\t: \"create new ${Lang} script\""
			echo -e "compile|cpl\t\t\t: \"make code executable\""
			echo -e "shell\t\t\t\t: run shell for testing"
			;;
		pgLang)
			if [ ! -z "${PythonRun}" ]; then
				#Return Python tag
				echo "Python"
			else
				#Return rejection
				echo "no"
			fi
			;;
		pgDir)
			#Return Python src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
			;;
		newCodeHelp)
			if [ -f ${TemplateCode} ]; then
				echo -e "--custom|-c\t\t\t: \"Custom src file using ${Lang} template\""
			fi
			;;
		EnsureDirs)
			#Home
			if [ ! -d "${LangHome}" ] && [ ! -z "${PythonRun}" ]; then
				mkdir "${LangHome}"
			fi
			#Src
			if [ ! -d "${LangSrc}" ] && [ ! -z "${PythonRun}" ]; then
				mkdir "${LangSrc}"
			fi
			#Bin
			if [ ! -d "${LangBin}" ] && [ ! -z "${PythonRun}" ]; then
				mkdir "${LangBin}"
			fi
			;;
		TemplateVersion)
			if [ -f ${TemplateCode} ]; then
				${PythonRun} ${TemplateCode} 2> /dev/null | grep Version
			else
				echo "no newPython found"
			fi
			;;
		CodeVersion)
			echo "[Python]"
			${PythonRun} --version
			;;
		selectCode)
			local name=$1
			#Correct filename
			if [[ ! "${name}" == *".py" ]]; then
				name="${name}.py"
			fi
			echo ${name}
			;;
		addCode)
			local src=$1
			local new=$2
			case ${src} in
				*.py)
					case ${new} in
						*.py)
							if [ -f "${new}" ]; then
								echo "${src},${new}"
							else
								echo "${src}"
							fi
							;;
						*)
							if [ -f "${new}.py" ]; then
								echo "${src},${new}.py"
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
				*.py)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "editNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".py" ]]; then
									${editor} ${num}
								else
									${editor} "${num}.py"
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
				*.py)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "readNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".py" ]]; then
									${ReadBy} ${num}
								else
									${ReadBy} "${num}.py"
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
			local project=${CodeProject}
			local name=$2
			local keep=$3
			local cplArgs=""
			#Handle Project Dir
			if [[ "${project}" == "none" ]]; then
				project=""
			else
				project="${project}/"
			fi
			case ${src} in
				*.py)
					#Compile Python Script
					#py2bin "${src}"
					#Get Python Name
			                #pyBin="${src%.*}"
					#Move Python Program to Binary dir
					#mv ${pyBin} ../bin/
					#Check if Python Script does NOT exist
					#Multiple code selected
					if [[ "${src}" == *","* ]]; then
						#variable is empty
						if [ -z ${name} ]; then
							errorCode "cpl" "choose"
						#variable found
						else
							#chosen file is in the list of files
							if [[ "${src}" == *"${name}"* ]]; then
								#only name is given
								if [[ "${name}" != *".py" ]]; then
									#full filename given
									num=${name}.py
								fi
								#Make Python Script executable
								chmod +x ${name}
								#Check if Python Script does NOT exist
								if [[ ! -f "${LangBin}/${name}" ]]; then
									#Change to Python Binary dir
									cd ${LangBin}
									#Create Symbolic Link to Python Script
									ln -s ../src/${project}${name}
									#Change to Python Source dir
									cd "${LangSrc}/${project}"
									echo -e "\e[1;43m[Python Code Compiled]\e[0m"
								else
									errorCode "cpl" "already" ${name}
								fi
							else
								echo "code not found"
							fi
						fi
					#single code selected
					else
						#Make Python Script executable
						chmod +x ${src}
						#Check if Python Script does NOT exist
						if [[ ! -f "${LangBin}/${src}" ]]; then
							#Change to Python Binary dir
							cd ${LangBin}
							#Create Symbolic Link to Python Script
							ln -s ../src/${project}${src}
							#Change to Python Source dir
							cd "${LangSrc}/${project}"
							echo -e "\e[1;43m[Python Code Compiled]\e[0m"
						#Code is already found
						else
							errorCode "cpl" "already" ${src}
						fi
					fi
					;;
				*)
					;;
			esac
			;;
		newProject)
			path=${LangSrc}/${project}
			if [ ! -d ${path} ]; then
				mkdir ${path}
				cd ${path}
				mkdir src bin
				cd ${path}/src
			else
				cd ${path}/src
			fi
			echo ${path}
			;;
		SwapToSrc)
			local src=$1
			#Get Python Name
		#	src="${src}.py"
		#	#Check if Python source exists
		#	if [[ -f "${LangSrc}/${src}" ]]; then
		#		#Return Python Source Name
				echo "${src}"
		#	fi
			;;
		SwapToBin)
			local bin=$1
			case ${bin} in
				*.py)
					#Get Python Name
				#	bin="${bin%.*}"
					#Check if Python Binary exists
					if [[ -f "${LangBin}/${bin}" ]]; then
						#cd "${LangBin}"
						#Return Python Binary Name
						echo "${bin}"
					else
						echo "${bin}"
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
				AddAlias "${BinFile}" "${PythonRun} ${LangBin}/${bin}"
			elif [ ! -f "${LangBin}/${bin}" ]; then
				errorCode "install" "${bin}"
			else
				errorCode "noCode"
			fi
			;;
		customCode)
			local cLang=$1
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				echo -n "${cLang}\$ ${PythonRun} newPython.py "
				read -a Args
				#Program Args Given
				if [ ! -z "${Args}" ];then
					${PythonRun} ${TemplateCode} ${Args[@]}
				#No Program Name Given
				else
					${PythonRun} ${TemplateCode} --help
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
			name=${name%.py}
			if [ ! -f ${name}.py ]; then
				#Check for Custom Code Template
				if [ -f ${TemplateCode} ]; then
					#Program Name Given
					if [ ! -z "${name}" ];then
						${PythonRun} ${TemplateCode} -n ${name} --cli --main --shell --write-file --read-file --os --random
					#No Program Name Given
					else
						${PythonRun} ${TemplateCode} --help
					fi
				else
					#Program Name Given
					if [ ! -z "${name}" ];then
						touch ${name}.py
					else
						errorCode "newCode"
					fi
				fi
			fi
			;;
		*)
			;;
	esac
}

UsePerl()
{
	local PerlRun=perl
	local LangHome=${ProgDir}/Perl
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local TemplateCode=${LangBin}/newPerl.pl
	local Type=$1
	shift
	case ${Type} in
		color)
			#Return Purple
			echo -e "\e[1;35mPerl\e[0m"
			;;
		MenuHelp)
			echo -e "new <file>\t\t\t: \"create new ${Lang} script\""
			echo -e "compile|cpl\t\t\t: \"make code executable\""
			;;
		pgLang)
			if [ ! -z "${PerlRun}" ]; then
				#Return Perl tag
				echo "Perl"
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
		newCodeHelp)
			if [ -f ${TemplateCode} ]; then
				echo -e "--custom|-c\t\t\t: \"Custom src file using ${Lang} template\""
			fi
			;;
		EnsureDirs)
			#Home
			if [ ! -d "${LangHome}" ] && [ ! -z "${PerlRun}" ]; then
				mkdir "${LangHome}"
			fi
			#Src
			if [ ! -d "${LangSrc}" ] && [ ! -z "${PerlRun}" ]; then
				mkdir "${LangSrc}"
			fi
			#Bin
			if [ ! -d "${LangBin}" ] && [ ! -z "${PerlRun}" ]; then
				mkdir "${LangBin}"
			fi
			;;
		TemplateVersion)
			if [ -f ${TemplateCode} ]; then
				${PerlRun} ${TemplateCode} 2> /dev/null | grep Version
			else
				echo "no newPerl found"
			fi
			;;
		CodeVersion)
			echo "[Perl]"
			${PerlRun} --version 2> /dev/null | grep Version
			;;
		selectCode)
			local name=$1
			#Correct filename
			if [[ ! "${name}" == *".pl" ]]; then
				name="${name}.pl"
			fi
			echo ${name}
			;;
		addCode)
			local src=$1
			local new=$2
			case ${src} in
				*.pl)
					case ${new} in
						*.pl)
							if [ -f "${new}" ]; then
								echo "${src},${new}"
							else
								echo "${src}"
							fi
							;;
						*)
							if [ -f "${new}.pl" ]; then
								echo "${src},${new}.pl"
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
				*.pl)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "editNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".pl" ]]; then
									${editor} ${num}
								else
									${editor} "${num}.pl"
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
				*.pl)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "readNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".pl" ]]; then
									${ReadBy} ${num}
								else
									${ReadBy} "${num}.pl"
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
			local project=${CodeProject}
			local name=$2
			local keep=$3
			local cplArgs=""
			#Handle Project Dir
			if [[ "${project}" == "none" ]]; then
				project=""
			else
				project="${project}/"
			fi
			case ${src} in
				*.pl)
					#Multiple code selected
					if [[ "${src}" == *","* ]]; then
						#variable is empty
						if [ -z ${name} ]; then
							errorCode "cpl" "choose"
						#variable found
						else
							#chosen file is in the list of files
							if [[ "${src}" == *"${name}"* ]]; then
								#only name is given
								if [[ "${name}" != *".pl" ]]; then
									#full filename given
									num=${name}.pl
								fi
								#Make Perl Script executable
								chmod +x ${name}
								#Check if Perl Script does NOT exist
								if [[ ! -f "${LangBin}/${name}" ]]; then
									#Change to Perl Binary dir
									cd ${LangBin}
									#Create Symbolic Link to Perl Script
									ln -s ../src/${project}${name}
									#Change to Perl Source dir
									cd "${LangSrc}/${project}"
									echo -e "\e[1;45m[Perl Code Compiled]\e[0m"
								else
									errorCode "cpl" "already" ${name}
								fi
							else
								echo "code not found"
							fi
						fi
					#single code selected
					else
						#Make Perl Script executable
						chmod +x ${src}
						#Check if Perl Script does NOT exist
						if [[ ! -f "${LangBin}/${src}" ]]; then
							#Change to Perl Binary dir
							cd ${LangBin}
							#Create Symbolic Link to Perl Script
							ln -s ../src/${project}${src}
							#Change to Perl Source dir
							cd "${LangSrc}/${project}"
							echo -e "\e[1;45m[Perl Code Compiled]\e[0m"
							#Code is already found
						else
							errorCode "cpl" "already" ${src}
						fi
					fi
					;;
				*)
					;;
			esac
			;;
		newProject)
			path=${LangSrc}/${project}
			if [ ! -d ${path} ]; then
				mkdir ${path}
				cd ${path}
				mkdir src bin
				cd ${path}/src
			else
				cd ${path}/src
			fi
			echo ${path}
			;;
		SwapToSrc)
			local src=$1
			#Get Perl Name
			echo "${src}"
			;;
		SwapToBin)
			local bin=$1
			case ${bin} in
				*.pl)
					#Get Perl Name
				#	bin="${bin%.*}"
					#Check if Perl Binary exists
					if [[ -f "${LangBin}/${bin}" ]]; then
						#cd "${LangBin}"
						#Return Perl Binary Name
						echo "${bin}"
					else
						echo "${bin}"
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
				AddAlias "${BinFile}" "${PerlRun} ${LangBin}/${bin}"
			elif [ ! -f "${LangBin}/${bin}" ]; then
				errorCode "install" "${bin}"
			else
				errorCode "noCode"
			fi
			;;
		customCode)
			local cLang=$1
			if [ -f ${TemplateCode} ]; then
				echo -n "${cLang}\$ ${PerlRun} newPerl.pl "
				read -a Args
				#Program Args Given
				if [ ! -z "${Args}" ];then
					${PerlRun} ${TemplateCode} ${Args[@]}
				#No Program Name Given
				else
					${PerlRun} ${TemplateCode} --help
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
			name=${name%.pl}
			if [ ! -f ${name}.pl ]; then
				#Check for Custom Code Template
				if [ -f ${TemplateCode} ]; then
					#Program Name Given
					if [ ! -z "${name}" ];then
						${PerlRun} ${TemplateCode} --name ${name} --cli --main --write-file --read-file --os
					#No Program Name Given
					else
						${PerlRun} ${TemplateCode} --help
					fi
				else
					#Program Name Given
					if [ ! -z "${name}" ];then
						touch ${name}.pl
					else
						errorCode "newCode"
					fi
				fi
			fi
			;;
		*)
			;;
	esac
}

UseRuby()
{
	local RubyRun=ruby
	local LangHome=${ProgDir}/Ruby
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local TemplateCode=${LangBin}/newRuby.rb
	local Type=$1
	shift
	case ${Type} in
		color)
			#Return Red
			echo -e "\e[1;31mRuby\e[0m"
			;;
		MenuHelp)
			echo -e "new <file>\t\t\t: \"create new ${Lang} script\""
			echo -e "compile|cpl\t\t\t: \"make code executable\""
			;;
		pgLang)
			if [ ! -z "${RubyRun}" ]; then
				#Return Ruby tag
				echo "Ruby"
			else
				#Return rejection
				echo "no"
			fi
			;;
		pgDir)
			#Return Ruby src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
			;;
		newCodeHelp)
			if [ -f ${TemplateCode} ]; then
				echo -e "--custom|-c\t\t\t: \"Custom src file using ${Lang} template\""
			fi
			;;
		EnsureDirs)
			#Home
			if [ ! -d "${LangHome}" ] && [ ! -z "${RubyRun}" ]; then
				mkdir "${LangHome}"
			fi
			#Src
			if [ ! -d "${LangSrc}" ] && [ ! -z "${RubyRun}" ]; then
				mkdir "${LangSrc}"
			fi
			#Bin
			if [ ! -d "${LangBin}" ] && [ ! -z "${RubyRun}" ]; then
				mkdir "${LangBin}"
			fi
			;;
		TemplateVersion)
			if [ -f ${TemplateCode} ]; then
				${RubyRun} ${TemplateCode} 2> /dev/null | grep Version
			else
				echo "no newRuby found"
			fi
			;;
		CodeVersion)
			echo "[Ruby]"
			${RubyRun} --version
			;;
		selectCode)
			local name=$1
			#Correct filename
			if [[ ! "${name}" == *".rb" ]]; then
				name="${name}.rb"
			fi
			echo ${name}
			;;
		addCode)
			local src=$1
			local new=$2
			case ${src} in
				*.rb)
					case ${new} in
						*.rb)
							if [ -f "${new}" ]; then
								echo "${src},${new}"
							else
								echo "${src}"
							fi
							;;
						*)
							if [ -f "${new}.rb" ]; then
								echo "${src},${new}.rb"
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
				*.rb)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "editNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".rb" ]]; then
									${editor} ${num}
								else
									${editor} "${num}.rb"
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
				*.rb)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "readNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".rb" ]]; then
									${ReadBy} ${num}
								else
									${ReadBy} "${num}.rb"
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
			local project=${CodeProject}
			local name=$2
			local keep=$3
			local cplArgs=""
			#Handle Project Dir
			if [[ "${project}" == "none" ]]; then
				project=""
			else
				project="${project}/"
			fi
			case ${src} in
				*.rb)
					#Multiple code selected
					if [[ "${src}" == *","* ]]; then
						#variable is empty
						if [ -z ${name} ]; then
							errorCode "cpl" "choose"
						#variable found
						else
							#chosen file is in the list of files
							if [[ "${src}" == *"${name}"* ]]; then
								#only name is given
								if [[ "${name}" != *".rb" ]]; then
									#full filename given
									num=${name}.rb
								fi
								#Make Ruby Script executable
								chmod +x ${name}
								#Check if Ruby Script does NOT exist
								if [[ ! -f "${LangBin}/${name}" ]]; then
									#Change to Ruby Binary dir
									cd ${LangBin}
									#Create Symbolic Link to Ruby Script
									ln -s ../src/${project}${name}
									#Change to Ruby Source dir
									cd "${LangSrc}/${project}"
									echo -e "\e[1;41m[Ruby Code Compiled]\e[0m"
								else
									errorCode "cpl" "already" ${name}
								fi
							else
								echo "code not found"
							fi
						fi
					#single code selected
					else
						#Make Ruby Script executable
						chmod +x ${src}
						#Check if Ruby Script does NOT exist
						if [[ ! -f "${LangBin}/${src}" ]]; then
							#Change to Ruby Binary dir
							cd ${LangBin}
							#Create Symbolic Link to Ruby Script
							ln -s ../src/${project}${src}
							#Change to Ruby Source dir
							cd "${LangSrc}/${project}"
							echo -e "\e[1;41m[Ruby Code Compiled]\e[0m"
						#Code is already found
						else
							errorCode "cpl" "already" ${src}
						fi
					fi
					;;
				*)
					;;
			esac
			;;
		newProject)
			path=${LangSrc}/${project}
			if [ ! -d ${path} ]; then
				mkdir ${path}
				cd ${path}
				mkdir src bin
				cd ${path}/src
			else
				cd ${path}/src
			fi
			echo ${path}
			;;
		SwapToSrc)
			local src=$1
			#Get Ruby Name
			echo "${src}"
			;;
		SwapToBin)
			local bin=$1
			case ${bin} in
				*.rb)
					#Get Ruby Name
				#	bin="${bin%.*}"
				#Check if Perl Binary exists
					if [[ -f "${LangBin}/${bin}" ]]; then
					#cd "${LangBin}"
					#Return Ruby Binary Name
						echo "${bin}"
					else
						echo "${bin}"
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
				AddAlias "${BinFile}" "${RubyRun} ${LangBin}/${bin}"
			elif [ ! -f "${LangBin}/${bin}" ]; then
				errorCode "install" "${bin}"
			else
				errorCode "noCode"
			fi
			;;
		customCode)
			local cLang=$1
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				echo -n "${cLang}\$ ${RubyRun} newRuby.rb "
				read -a Args
				#Program Args Given
				if [ ! -z "${Args}" ];then
					${RubyRun} ${TemplateCode} ${Args[@]}
				#No Program Name Given
				else
					${RubyRun} ${TemplateCode} --help
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
			name=${name%.rb}
			if [ ! -f ${name}.rb ]; then
				#Check for Custom Code Template
				if [ -f ${TemplateCode} ]; then
					#Program Name Given
					if [ ! -z "${name}" ];then
						${RubyRun} ${TemplateCode} -n ${name} --cli --user $USER --main --write-file --read-file --user-input
					#No Program Name Given
					else
						${RubyRun} ${TemplateCode} --help
					fi
				else
					#Program Name Given
					if [ ! -z "${name}" ];then
						touch ${name}.rb
					else
						errorCode "newCode"
					fi
				fi
			fi
			;;
		*)
			;;
	esac
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
		MenuHelp)
			echo -e "new <file> {main|header|component} : \"create new ${Lang} source file\""
			echo -e "compile|cpl\t\t\t: \"make code executable\""
			;;
		pgLang)
			if [ ! -z "${CppCpl}" ]; then
				#Return C++ tag
				echo "C++"
			else
				#Return rejection
				echo "no"
			fi
			;;
		pgDir)
			#Return C++ src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
			echo -e "make\t\t\t: create makefile"
			echo -e "version|-std=<c++#>\t: create makefile"
			;;
		newCodeHelp)
			if [ -f ${TemplateCode} ]; then
				echo -e "--custom|-c\t\t\t: \"Custom src file using ${Lang} template\""
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
				${TemplateCode} 2> /dev/null | grep Version
			else
				echo "no newC++ found"
			fi
			;;
		CodeVersion)
			echo "[C++]"
			${CppCpl} --version | head -n 1
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
			local project=${CodeProject}
			local name=$2
			local keep=$3
			local cplArgs=""
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
							${CppCpl} ${prog} -o ../bin/${name} ${cplArgs}
							echo -e "\e[1;44m[C++ Code Compiled]\e[0m"
						fi
					#single code selected
					else
						#Compile for threading
						NeedThreads=$(grep "#include <thread>" ${src})
						if [ ! -z "${NeedThreads}" ]; then
							cplArgs="${cplArgs} -lpthread"
						fi
						#Compile and move C++ to Binary dir
						${CppCpl} ${src} -o ../bin/${src%.*} ${cplArgs}
						echo -e "\e[1;44m[C++ Code Compiled]\e[0m"
					fi
				fi
			fi
			;;
		newProject)
			path=${LangSrc}/${project}
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
					OldBin="${bin}"
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
			local cLang=$1
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				echo -n "${cLang}\$ ./newC++ "
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
								${TemplateCode} --write-file --read-file --cli --main --is-in --user-input --name ${name}
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
		*)
			;;
	esac
}

UseJava()
{
	local JavaCpl=javac
	local JavaRun=java
	local LangHome=${ProgDir}/Java
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local TemplateCodeClass=${LangBin}/newJava.class
	local TemplateCodeJar=${LangBin}/newJava.jar
	local Type=$1
	shift
	case ${Type} in
		color)
			#Return Red
			echo -e "\e[1;31mJava\e[0m"
			;;
		MenuHelp)
			echo -e "new <file> {main|component}\t: \"create new ${Lang} source file\""
			echo -e "compile|cpl <type> <manifest>\t: \"make code executable\""
			echo -e "\t--class\t\t\t: \"make code (CLASS) executable\""
			echo -e "\t--jar\t\t\t: \"make code (JAR) executable\""
			echo -e "\t--jar --keep-manifest\t: \"keep manifest.mf\""
			;;
		pgLang)
			if [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
				#Return Java tag
				echo "Java"
			else
				#Return rejection
				echo "no"
			fi
			;;
		pgDir)
			#Return Java src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
			echo -e "prop|properties|-D\t: create custome Java properties"
			echo -e "jar|manifest\t\t: create Java Manifest Jar builds"
			;;
		newCodeHelp)
			if [ -f ${TemplateCodeJar} ] || [ -f ${TemplateCodeClass} ]; then
				echo -e "--custom|-c\t\t\t: \"Custom src file using ${Lang} template\""
			fi
			;;
		EnsureDirs)
			#Home
			if [ ! -d "${LangHome}" ] && [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
				mkdir "${LangHome}"
			fi
			#Src
			if [ ! -d "${LangSrc}" ] && [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
				mkdir "${LangSrc}"
			fi
			#Bin
			if [ ! -d "${LangBin}" ] && [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
				mkdir "${LangBin}"
			fi
			;;
		TemplateVersion)
			if [ -f ${TemplateCodeJar} ]; then
				java -jar ${TemplateCodeJar} 2> /dev/null | grep Version
			else
				echo "no newJava.jar found"
			fi
			;;
		CodeVersion)
			echo "[Java]"
			JavaRunVersion=$(${JavaRun} --version 2> /dev/null)
			JavaCplVersion=$(${JavaCpl} --version 2> /dev/null)
			if [ ! -z "${JavaRunVersion}" ]; then
				JavaRunVersion=$(${JavaRun} --version | head -n 1)
				JavaCplVersion=$(${JavaCpl} --version | head -n 1)
				echo "${JavaRunVersion}"
				echo "${JavaCplVersion}"
			else
				${JavaRun} -version
				${JavaCpl} -version
			fi
			;;
		selectCode)
			local name=$1
			#Correct filename
			if [[ ! "${name}" == *".java" ]]; then
				name="${name}.java"
			fi
			echo ${name}
			;;
		addCode)
			local src=$1
			local new=$2
			case ${src} in
				*.java)
					case ${new} in
						*.java)
							if [ -f "${new}" ]; then
								echo "${src},${new}"
							else
								echo "${src}"
							fi
							;;
						*)
							if [ -f "${new}.java" ]; then
								echo "${src},${new}.java"
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
				*.java)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "editNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".java" ]]; then
									${editor} ${num}
								else
									${editor} "${num}.java"
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
				*.java)
					if [[ "${src}" == *","* ]]; then
						if [ -z ${num} ]; then
							errorCode "readNull"
						else
							if [[ "${src}" == *"${num}"* ]]; then
								if [[ "${num}" == *".java" ]]; then
									${ReadBy} ${num}
								else
									${ReadBy} "${num}.java"
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
			local project=${CodeProject}
			local name=$2
			local keep=$3
			local cplArgs=""
			#Handle Project Dir
			if [[ "${project}" == "none" ]]; then
				project=""
			else
				project="${project}/"
			fi
			case ${src} in
				*.java)
					#Multiple code selected
					if [[ "${src}" == *","* ]]; then
						if [[ "${project}" == *"/" ]]; then
							#Compile Java prgram
							${JavaCpl} *.java
							#move Java Class to Binary dir
							if [ -f *.class ]; then
								mv *.class ../bin/
							fi
						else
							echo "Is not a project"
						fi
					#single code selected
					else
						#Compile Java prgram
						${JavaCpl} ${src}
						#get Java Class/compiled file name
						des=${src%.*}.class
						if [ -f ${des} ]; then
							#Compile as jar or class
							case ${name} in
								#Compile as Jar
								--jar)
									if [ ! -f manifest.mf ]; then
										echo "Manifest-Version: 1.1" > manifest.mf
										echo "Created-By: $USER" >> manifest.mf
										echo "Main-Class: ${des%.class}" >> manifest.mf
										echo "Sealed: true" >> manifest.mf
									fi
									#jar -cmf manifest.mf ${des%.class}.jar ${des}
									jar -cmf manifest.mf ${des%.class}.jar *.class
									#remove class file
									if [ -f ../bin/${des} ]; then
										rm ../bin/${des}
									fi
									case ${keep} in
										--keep-manifest)
											#rm ${des}
											rm *.class
											;;
										*)
											#rm manifest.mf ${des}
											rm manifest.mf *.class
										;;
									esac
									#move Java Jar to Binary dir
									mv ${des%.class}.jar ../bin/
									echo -e "\e[1;41m[Java Code Compiled (JAR)]\e[0m"
									;;
								#Do nothing...keep class
								*|--class)
									#move Java Class to Binary dir
									#mv ${des} ../bin/
									mv *.class ../bin/
									#remove old jar
									if [ -f ../bin/${des%.class}.jar ]; then
										rm ../bin/${des%.class}.jar
									fi
									echo -e "\e[1;41m[Java Code Compiled (CLASS)]\e[0m"
								;;
							esac
						fi
					fi
					;;
				*)
					;;
			esac
			;;
		newProject)
			path=${LangSrc}/${project}
			if [ ! -d ${path} ]; then
				mkdir ${path}
				cd ${path}
			else
				cd ${path}
			fi
			echo ${path}
			;;
		SwapToSrc)
			local src=$1
			#cd "${LangSrc}"
			#Get Java Name
			src="${src%.*}.java"
			#Check if Java source exists
			if [ -f "${LangSrc}/${src}" ]; then
				#Return Java Source Name
				echo "${src}"
			fi
			;;
		SwapToBin)
			local bin=$1
			case ${bin} in
				*.java)
					#cd "${LangBin}"
					#Keep SrcName
					OldBin="${bin}"
					#Get Java Name
					bin="${bin%.*}.class"
					#Check Java Binary exists
					if [ -f "${LangBin}/${bin}" ]; then
						#Return Java Binary Name
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
			#Java binary
			if [[ "${bin}" == *".java" ]]; then
				#Check for Jar file
				if [ -f "${LangBin}/${BinFile}.jar" ]; then
					AddAlias "${BinFile}" "${JavaRun} -jar ${LangBin}/${BinFile}.jar"
				elif [ -f "${LangBin}/${bin}.class" ]; then
					echo "Please compile as jar file"
					echo "[hint] $ cpl jar"
				else
					errorCode "install" "${bin}"
				fi
			else
				errorCode "noCode"
			fi
			;;
		customCode)
			local cLang=$1
			Type=$(echo ${Type} | tr A-Z a-z)
			#Check for Custom Code Template...is class
			if [ -f ${TemplateCodeClass} ]; then
				echo -n "${cLang}\$ java newJava "
				read -a Args
				#Program Args Given
				if [ ! -z "${Args}" ];then
					cd ${LangBin}
					java newJava ${Args[@]}
					cd - > /dev/null
					mv "${LangBin}/*.java" . 2> /dev/null
				else
					cd ${LangBin}
					java newJava --help
					cd - > /dev/null
				fi
			#Check for Custom Code Template...is jar
			elif [ -f ${TemplateCodeJar} ]; then
				echo -n "${cLang}\$ java -jar newJava.jar "
				read -a Args
				#Program Args Given
				if [ ! -z "${Args}" ];then
					java -jar ${TemplateCodeJar} ${Args[@]}
				#No Program Name Given
				else
					java -jar ${TemplateCodeJar} --help
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
			name=${name%.java}
			if [ ! -f ${name}.java ]; then
				#Check for Custom Code Template...is class
				if [ -f ${TemplateCodeClass} ]; then
					#Program Name Given
					if [ ! -z "${name}" ];then
						case ${Type} in
							#create main file
							main)
								cd ${LangBin}
								java newJava --user $USER --main --shell --write-file --read-file --user-input --name ${name}
								cd - > /dev/null
								mv "${LangBin}/${name}.java" .
								;;
							#create component file
							component)
								cd ${LangBin}
								java newJava --user $USER --write-file --read-file --name "${name}"
								cd - > /dev/null
								mv "${LangBin}/${name}.java" .
								;;
							#cl[ide] knows best
							*)
								#main class already created
								if [[ "${oldCode}" == *".java" ]]; then
									#Create libary class
									UseJava "newCode" ${name} ${oldCode} ${Project} "component"
								else
									#Create new main code
									UseJava "newCode" ${name} ${oldCode} ${Project} "main"
								fi
								;;
						esac
					#No Program Name Given
					else
						cd ${LangBin}
						java newJava --help
						cd - > /dev/null
					fi
				#Check for Custom Code Template...is jar
				elif [ -f ${TemplateCodeJar} ]; then
					#Program Name Given
					if [ ! -z "${name}" ];then
						case ${Type} in
							#create main file
							main)
								java -jar ${TemplateCodeJar} --user $USER --main --shell --write-file --read-file --user-input --name "${name}"
								;;
							#create component file
							component)
								java -jar ${TemplateCodeJar} --user $USER --write-file --read-file --name "${name}"
								;;
							#cl[ide] knows best
							*)
								#main class already created
								if [[ "${oldCode}" == *".java" ]]; then
									#Create libary class
									UseJava "newCode" ${name} ${oldCode} ${Project} "component"
								else
									#Create new main code
									UseJava "newCode" ${name} ${oldCode} ${Project} "main"
								fi
								;;
						esac
					#No Program Name Given
					else
						java -jar ${TemplateCodeJar} --help
					fi
				#No Program Name Given
				else
					#Program Name Given
					if [ ! -z "${name}" ];then
						touch ${name}.java
					else
						errorCode "newCode"
					fi
				fi
			fi
			;;
		*)
			;;
	esac
}

#Language not yet supported
UseOther()
{
	local Lang=$1
	shift
	local Type=$1
	shift
	local Args=$@
	case ${Type} in
		color)
			local text=${Lang}
			#Return Purple
			echo -e "\e[1;35m${text}\e[0m"
			;;
		MenuHelp)
			echo -e "compile|cpl\t: \"make code executable\""
			;;
		#No Languge found
		pgLang|pgDir)
			#Return rejection
			echo "no"
			;;
		CreateHelp)
			;;
		newCodeHelp)
			;;
		compileCode)
			errorCode "cpl"
			;;
		TemplateVersion)
			echo "Please Choose a Language"
			;;
		SwapToSrc|SwapToBin)
			echo "${Args[0]}"
			;;
		Install)
			errorCode "noCode"
			;;
		*)
			;;
	esac
}

#Select Languge
ManageLangs()
{
	local Langs=$1
	shift
	local Manage=$@
	case ${Langs} in
		Bash|bash)
			UseBash ${Manage[@]}
			;;
		Python|python)
			UsePython ${Manage[@]}
			;;
		Perl|perl)
			UsePerl ${Manage[@]}
			;;
		Ruby|ruby)
			UseRuby ${Manage[@]}
			;;
		C++|c++)
			UseCpp ${Manage[@]}
			;;
		Java|java)
			UseJava ${Manage[@]}
			;;
		*)
			UseOther ${Langs} ${Manage[@]}
			;;
	esac
}

#}

Art()
{
	echo "                ____                       ____ "
	echo "               |  __|                     |__  |"
	echo "   ___   _     | |  _______   _____    ____  | |"
	echo "  / __| | |    | | |__   __| |  __ \  |  __| | |"
	echo " / /    | |    | |    | |    | |  \ \ | |_   | |"
	echo "| |     | |    | |    | |    | |  | | |  _|  | |"
	echo " \ \__  | |__  | |  __| |__  | |__/ / | |__  | |"
	echo "  \___| |____| | | |_______| |_____/  |____| | |"
	echo "               | |__                       __| |"
	echo "               |____|                     |____|"
}

#Clide menu help page
MenuHelp()
{
	local Lang=$1
	local project=$2
	echo ""
	echo "----------------[(${Head}) Menu]----------------"
	echo -e "ls\t\t\t\t: \"list progams\""
	echo -e "unset\t\t\t\t: \"deselect source code\""
	echo -e "use <language> <code>\t\t: \"choose language\""
	echo -e "swap|swp {src|bin}\t\t: \"swap between sorce code and executable\""
	echo -e "create <arg>\t\t\t: \"create compile and runtime arguments"
	ManageLangs ${Lang} "MenuHelp"
	echo -e "rm|remove|delete\t\t: \"delete src file\""
	echo -e "set <file>\t\t\t: \"select source code\""
	echo -e "add <file>\t\t\t: \"add new file to project\""
	echo -e "notes <action>\t\t: \"make notes for the ${Lang} language\""
	echo -e "${editor}|edit|ed\t\t\t: \"edit source code\""
	echo -e "${ReadBy}|read\t\t\t: \"Read source code\""
	echo -e "search <find>\t\t\t: \"search for code in project\""
	case ${project} in
		none)
			echo -e "project {new|list|load}\t\t: \"handle projects\""
			;;
		*)
#			echo -e "project {new|update|list|load|active}\t: \"handle projects\""
			echo -e "project {new|update|list|load}\t: \"handle projects\""
			echo -e "${repoTool}|repo\t: \"handle repos\""
			;;
	esac
	echo -e "search\t\t\t\t: \"search project src files for line of code\""
	echo -e "execute|exe|run {-a|--args}\t: \"run active program\""
	echo -e "last|load\t\t\t: \"Load last session\""
	echo -e "exit|close\t\t\t: \"close ide\""
	echo "------------------------------------------------"
	echo ""
}

CreateHelp()
{
	local Lang=$1
	echo ""
	echo "----------------[(${Head}) \"Create\" Help]----------------"
	echo -e "args\t\t\t: create custom args"
	ManageLangs ${Lang} "CreateHelp"
	echo -e "reset\t\t\t: clear all"
	echo "---------------------------------------------------------"
	echo ""
}

ProjectHelp()
{
	echo ""
	echo "----------------[(${Head}) \"Project\" Help]----------------"
	echo -e "Purpose: \"handle projects\""
	echo -e "new <project>\t\t\t: \"Create a new project\""
	echo -e "import <project> <path>\t\t: \"Import projects\""
	echo -e "update\t\t\t\t: \"Update the active project\""
	echo -e "load <project>\t\t\t: \"Choose a project to make active\""
	echo -e "list\t\t\t\t: \"List ALL projects\""
	echo -e "active\t\t\t\t: \"Display the name of the current project\""
	echo "----------------------------------------------------------"
	echo ""
}

NotesHelp()
{
	local Lang=$1
	echo ""
	echo "----------------[(${Head}) \"Notes\" Help]----------------"
	echo -e "edit|add\t\t: \"edit notes\""
	echo -e "read\t\t: \"read notes\""
	echo "----------------------------------------------------------"
	echo ""

}

newCodeHelp()
{
	local Lang=$1
	echo ""
	echo "----------------[(${Head}) \"new\" Help]----------------"
	echo -e "--version|-v\t\t\t: \"Get Version for each code template\""
	echo -e "--help|-h\t\t\t: \"This page\""
	ManageLangs ${Lang} "newCodeHelp"
	echo -e "<code>\t\t\t\t: \"provide code name; default settings\""
	echo "----------------------------------------------------------"
	echo ""
}

#Clide cli help page
CliHelp()
{
	echo ""
	echo "----------------[(${Head}) CLI]----------------"
	echo -e "-v |--version\t\t\t: \"Get Clide Version\""
	echo -e "-cv|--code-version\t\t: \"Get Compile/Interpreter Version\""
	echo -e "-tv|--temp-version\t\t: \"Get Code Template Version\""
	echo -e "-rv|--repo-version\t\t: \"Get git/svn Version\""
	echo -e "-c |--config\t\t\t: \"Get Clide Config\""
	echo -e "-p |--projects\t\t\t: \"List Clide Projects\""
	echo -e "-h |--help\t\t\t: \"Get CLI Help Page (Cl[ide] Menu: \"help\")\""
	echo -e "-l |--last|--load\t\t: \"Load last session\""
	echo "-----------------------------------------------"
	echo -e "$ clide <language> <code>\t: start clide"
	echo -e "$ clide java program.java\t: start clide using java and program.java"
	echo -e "$ clide java\t\t\t: start clide using java"
	echo ""
}

ClideConfig()
{
	if [[ "$USER" == "root" ]]; then
		Replace="\\$HOME\\/"
	else
		Replace="\\/home\\/$USER\\/"
	fi
	With="\~\\/"
	echo "----------------[(${Head}) Config]----------------"
	echo "Editor: \"${editor}\""
	echo "Read By: \"${ReadBy}\""
	Repo=$(which ${repoTool})
	if [ ! -z "${Repo}" ]; then
		echo "Repo By: \"${repoTool}\""
		case ${repoAssist} in
			True)
				echo "${Head} handles the repo commands"
				;;
			False)
				echo "The User is responsible for repo commands"
				;;
			*)
				echo "repo version control has been disabled"
				;;
		esac
	fi
	echo ""
	echo "---[${Head} Compilers/Interpreters]---"
	#Bash
	if [ ! -z "${BashCpl}" ]; then
		echo "Bash: \"${BashCpl}\""
	fi
	#Python
	if [ ! -z "${PythonRun}" ]; then
		echo "Python: \"${PythonRun}\""
	fi
	#Perl
	if [ ! -z "${PerlRun}" ]; then
		echo "Perl: \"${PerlRun}\""
	fi
	#Ruby
	if [ ! -z "${RubyRun}" ]; then
		echo "Ruby: \"${RubyRun}\""
	fi
	#C++
	if [ ! -z "${CppCpl}" ]; then
		echo "C++: \"${CppCpl}\""
	fi
	#Java
	if [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
		echo "Java: \"${JavaRun}\"/\"${JavaCpl}\""
	fi
	echo "--------------------------------------"
	echo ""
	echo "---[${Head} FileSystem]---"
	TheProgDir=$(echo ${ProgDir} | sed "s/${Replace}/${With}/g")
	echo "Root: \"${TheProgDir}\""
	TheClideDir=$(echo ${ClideDir} | sed "s/${Replace}/${With}/g")
	echo "Config: \"${TheClideDir}\""
	echo ""
	echo "[Language Directory]"
	#Bash
	if [ ! -z "${BashCpl}" ]; then
		TheBashHome=$(echo ${BashHome} | sed "s/${Replace}/${With}/g")
		echo "Bash: \"${TheBashHome}\""
	fi
	#Python
	if [ ! -z "${PythonRun}" ]; then
		ThePythonHome=$(echo ${PythonHome} | sed "s/${Replace}/${With}/g")
		echo "Python: \"${ThePythonHome}\""
	fi
	#Perl
	if [ ! -z "${PerlRun}" ]; then
		ThePerlHome=$(echo ${PerlHome} | sed "s/${Replace}/${With}/g")
		echo "Perl: \"${ThePerlHome}\""
	fi
	#Ruby
	if [ ! -z "${RubyRun}" ]; then
		TheRubyHome=$(echo ${RubyHome} | sed "s/${Replace}/${With}/g")
		echo "Ruby: \"${TheRubyHome}\""
	fi
	#C++
	if [ ! -z "${CppCpl}" ]; then
		TheCppHome=$(echo ${CppHome} | sed "s/${Replace}/${With}/g")
		echo "C++: \"${TheCppHome}\""
	fi
	#Java
	if [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
		TheJavaHome=$(echo ${JavaHome} | sed "s/${Replace}/${With}/g")
		echo "Java: \"${TheJavaHome}\""
	fi
	echo ""
	echo "[Source Directory]"
	#Bash
	if [ ! -z "${BashCpl}" ]; then
		TheBashSrc=$(echo ${BashSrc} | sed "s/${Replace}/${With}/g")
		echo "Bash: \"${TheBashSrc}\""
	fi
	#Python
	if [ ! -z "${PythonRun}" ]; then
		ThePythonSrc=$(echo ${PythonSrc} | sed "s/${Replace}/${With}/g")
		echo "Python: \"${ThePythonSrc}\""
	fi
	#Perl
	if [ ! -z "${PerlRun}" ]; then
		ThePerlSrc=$(echo ${PerlSrc} | sed "s/${Replace}/${With}/g")
		echo "Perl: \"${ThePerlSrc}\""
	fi
	#Ruby
	if [ ! -z "${RubyRun}" ]; then
		TheRubySrc=$(echo ${RubySrc} | sed "s/${Replace}/${With}/g")
		echo "Ruby: \"${TheRubySrc}\""
	fi
	#C++
	if [ ! -z "${CppCpl}" ]; then
		TheCppSrc=$(echo ${CppSrc} | sed "s/${Replace}/${With}/g")
		echo "C++: \"${TheCppSrc}\""
	fi
	#Java
	if [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
		TheJavaSrc=$(echo ${JavaSrc} | sed "s/${Replace}/${With}/g")
		echo "Java: \"${TheJavaSrc}\""
	fi
	echo ""
	echo "[Binary Directory]"
	#Bash
	if [ ! -z "${BashCpl}" ]; then
		TheBashBin=$(echo ${BashBin} | sed "s/${Replace}/${With}/g")
		echo "Bash: \"${TheBashBin}\""
	fi
	#Python
	if [ ! -z "${PythonRun}" ]; then
		ThePythonBin=$(echo ${PythonBin} | sed "s/${Replace}/${With}/g")
		echo "Python: \"${ThePythonBin}\""
	fi
	#Perl
	if [ ! -z "${PerlRun}" ]; then
		ThePerlBin=$(echo ${PerlBin} | sed "s/${Replace}/${With}/g")
		echo "Perl: \"${ThePerlBin}\""
	fi
	#Ruby
	if [ ! -z "${RubyRun}" ]; then
		TheRubyBin=$(echo ${RubyBin} | sed "s/${Replace}/${With}/g")
		echo "Ruby: \"${TheRubyBin}\""
	fi
	#C++
	if [ ! -z "${CppCpl}" ]; then
		TheCppBin=$(echo ${CppBin} | sed "s/${Replace}/${With}/g")
		echo "C++: \"${TheCppBin}\""
	fi
	#Java
	if [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
		TheJavaBin=$(echo ${JavaBin} | sed "s/${Replace}/${With}/g")
		echo "Java: \"${TheJavaBin}\""
	fi
	echo "--------------------------"
	echo ""
	echo "--------------------------------------------------"
}

EnsureLangs()
{
	#Compilers/Interpreters
#Check for Shell
#{
	CheckForShell=$(which bash)
	if [ -z "${CheckForShell}" ]; then
		CheckForShell=$(which zsh)
		if [ -z "${CheckForShell}" ]; then
			BashCpl=""
		else
			BashCpl=zsh
		fi
	fi
#}
#Check if Python Interpreter present
#{
	CheckForPython2=$(which python)
	CheckForPython3=$(which python3)
	if [ -z "${CheckForPython2}" ] && [[ "${PythonRun}" == "python" ]]; then
		CheckForPython=$(which python3)
		if [ -z "${CheckForPython}" ]; then
			PythonRun=""
		else
			PythonRun=python3
		fi
	elif [ -z "${CheckForPython3}" ] && [[ "${PythonRun}" == "python3" ]]; then
		CheckForPython=$(which python)
		if [ -z "${CheckForPython}" ]; then
			PythonRun=""
		else
			PythonRun=python
		fi
	fi
#}
#Check if Perl Interpreter present
#{
	CheckForPerl=$(which perl)
	if [ -z "${CheckForPerl}" ]; then
		PerlRun=""
	fi
#}
#Check if Perl Interpreter present
#{
	CheckForRuby=$(which ruby)
	if [ -z "${CheckForRuby}" ]; then
		RubyRun=""
	fi
#}
#Check if C++ Compiler present
#{
	CheckForGpp=$(which g++)
	CheckForClangpp=$(which clang++)
	if [ -z "${CheckForGpp}" ] && [[ "${CppCpl}" == "g++" ]]; then
		CheckForCpp=$(which clang++)
		if [ -z "${CheckForCpp}" ]; then
			CppCpl=""
		else
			CppCpl=clang++
		fi
	elif [ -z "${CheckForClangpp}" ] && [[ "${CppCpl}" == "clang++" ]]; then
		CheckForCpp=$(which g++)
		if [ -z "${CheckForCpp}" ]; then
			CppCpl=""
		else
			CppCpl=g++
		fi
	fi
#}
#Check Java is installed
#{
	CheckForJava=$(which java)
	CheckForJavac=$(which javac)
	if [ -z "${CheckForJava}" ] && [ -z "${CheckForJavac}" ]; then
		JavaCpl=""
		JavaRun=""
	fi
#}
}

EnsureDirs()
{
	#If missing...create "Programs" dir
	if [ ! -d "${ProgDir}" ]; then
		mkdir "${ProgDir}"
	fi
#check for .clide dir
#{
	if [ ! -d "${ClideDir}" ]; then
		mkdir "${ClideDir}"
	fi
#}
	ManageLangs "Bash" "EnsureDirs"
	ManageLangs "Python" "EnsureDirs"
	ManageLangs "Perl" "EnsureDirs"
	ManageLangs "Ruby" "EnsureDirs"
	ManageLangs "C++" "EnsureDirs"
	ManageLangs "Java" "EnsureDirs"
}

ClideVersion()
{
	echo ${Version}
}

RepoVersion()
{
	IsInstalled=$(which ${repoTool})
	if [ ! -z "${IsInstalled}" ]; then
		${repoTool} --version
	else
		echo "\"${repoTool}\" is not installed"
	fi
}

CodeVersion()
{
	local Lang=$1
	if [ ! -z "${Lang}" ]; then
		ManageLangs ${Lang} "TemplateVersion"
	else
		ManageLangs "Bash" "TemplateVersion" | sed "s/Version:/Bash:/g"
		ManageLangs "Python" "TemplateVersion" | sed "s/Version:/Python:/g"
		ManageLangs "Perl" "TemplateVersion" | sed "s/Version:/Perl:/g"
		ManageLangs "Ruby" "TemplateVersion" | sed "s/Version:/Ruby:/g"
		ManageLangs "C++" "TemplateVersion" | sed "s/Version:/C++:/g"
		ManageLangs "Java" "TemplateVersion" | sed "s/Version:/Java:/g"
	fi
}

Banner()
{
	Art
	echo "(${Version})"
	echo ""
	echo "\"Welcome to ${Head}\""
	echo "\"The command line IDE for the Linux/Unix user\""
}

#Error messages
errorCode()
{
	local ecd=$1
	local sec=$2
	local thr=$3
	local four=$4
	case $ecd in
		alias)
			echo "\"${sec}\" already installed"
			;;
		install)
			case ${sec} in
				choose)
					echo "hint: please choose script"
					;;
				*.java|*.class)
					echo "\"${sec}\" needs to be an java jar"
					echo "[to compile]: cpl --jar"
					;;
				*)
					echo "\"${sec}\" needs to be an executable"
					echo "[to compile]: cpl"
					echo "OR"
					echo "[swap to executable]: swp bin"
					;;
			esac
			;;
		lookFor)
			case ${sec} in
				none)
					echo "Nothing to search for"
					echo "Please provide a value"
					;;
				*)
					;;
			esac
			;;
		remove)
			case ${sec} in
				sure)
					echo "WARNING: YOU ARE TRYING TO DELETE A FILE"
					echo "WARNING: You will NOT recover this file"
					echo ""
					echo "\"yes\" is NOT \"YES\""
					;;
				hint)
					echo ""
					echo "HINT: to force removal, provide a \"--force\""
					;;
				*)
					;;
			esac
			;;
		noCode)
			echo "No Code Found"
			echo "[to set code]: set <name>"
			;;
		newCode)
			echo "Please Provide The Name Of Your New Code"
			echo "EX: new <name>"
			;;
		customCode)
			case ${sec} in
				completeNotFound)
					echo "${Head} did not find, or is not configured to find, your program"
					echo "Please select your code"
					echo "[to select code]: set <name>"
					;;
				notemp)
					echo "No ${thr} Template Found"
					;;
				*)
					;;
			esac
			;;
		editNull)
			echo "hint: ${editor}|edit|ed <file>"
			;;
		editNot)
			echo "code is not found in project"
			;;
		editMe)
			echo "For your safety, I am not allowed to edit myself"
			;;
		readNull)
			echo "hint: ${ReadBy}|read <file>"
			;;
		readNot)
			echo "code is not found in project"
			;;
		project)
			case ${sec} in
				none)
					echo "Your session MUST be a ${Head} Project"
					echo "hint: Please create or load a project"
					echo "$ project new <project>"
					echo "$ project load <project>"
					;;
				import)
					case ${thr} in
						link-nothing)
							echo "\"${four}\" is not a working directory"
							;;
						*)
							echo "import Methods"
							;;
					esac
					;;
				exists)
					echo "\"${thr}\" is already a project"
					;;
				NotAProject)
					echo "No \"${thr}\" project found"
					;;
				*)
					echo "Project error"
					;;
			esac
			;;
		cpl)
			case ${sec} in
				choose)
					echo "hint: please choose a program name"
					;;
				already)
					echo "\"${thr}\" already compiled"
					;;
				not)
					echo "code not found"
					;;
				need)
					echo "${thr} is not compiled"
					echo "[HINT] \$ cpl"
					;;
				none)
					echo "no code to run"
					echo "[hint] set <code>"
					;;
				*)
					echo "Nothing to Compile"
					echo "[to set code]: set <name>"
					;;
			esac
			;;
		loadSession)
				echo "No Session to load"
			;;
		*)
			;;
	esac
}

#Search selected code for element
lookFor()
{
	local project=$1
	local search=$2
	case ${project} in
		none)
			errorCode "project" "none"
			;;
		*)
			if [ ! -z "${search}" ]; then
				grep -iR ${search} * | less
			else
				errorCode "lookFor" "none"
			fi
			;;
	esac
}

#Save Last Session
SaveSession()
{
	local Session="${ClideDir}/session"
	local Language=$1
	local Project=$2
	local SrcCode=$3
	#Source Needs to be present
	if [ ! -z ${SrcCode} ]; then
		touch ${Session}
		echo "${Project};${Language};${SrcCode}" > ${Session}
	fi
}

#Load Last Session
LoadSession()
{
	local Session="${ClideDir}/session"
	#check for clide session
	if [ ! -f "${Session}" ]; then
		errorCode "loadSession"
	else
		cat ${Session}
	fi
}

importProject()
{
	local Lang=$1
	local Name=$2
	local Path=$3
	if [ ! -z "${Name}" ]; then
		if [ ! -f ${ClideDir}/${Name}.clide ]; then
			if [ -z "${Path}" ]; then
				echo -n "Import Project \"${Name}\" from : "
				read Path
			fi

			if [ -z "${Path}" ]; then
				echo "no path Given"
			else
				case ${Path} in
					*${Name}|*${Name}/)
						echo "name=${Name}" > ${ClideDir}/${Name}.clide
						echo "lang=${Lang}" >> ${ClideDir}/${Name}.clide
						echo "path=${Path}" >> ${ClideDir}/${Name}.clide
						echo "src=" >> ${ClideDir}/${Name}.clide
						echo "Project \"${Name}\" Imported"
						;;
					*)
						echo "${Name} must be in the directory of \"${Path}\""
						;;
				esac
			fi
		else
			echo "You Already have a project named \"${Name}\""
		fi
	else
		echo "import help"
	fi
}

#Create new project
newProject()
{
	local lang=$1
	local project=$2
	local path=""
	#No Project is found
	if [ -z ${project} ]; then
		errorCode "project" "none"
	else
		#Grab Project Data
		#Name Value
		echo "name=${project}" > ${ClideDir}/${project}.clide
		#Language Value
		echo "lang=${lang}" >> ${ClideDir}/${project}.clide
		#Create Project and get path
		path=$(ManageLangs ${Lang} "newProject")
		#Path Value
		echo "path=${path}" >> ${ClideDir}/${project}.clide
		#Source Value
		echo "src=" >> ${ClideDir}/${project}.clide
	fi
}

#Update config of active Projects
updateProject()
{
	local project=$1
	local src=$2
	#No Project is found
	if [ ! -z ${src} ]; then
		#Locate Project Directory
		if [ ! -f ${ClideDir}/${project}.clide ]; then
			errorCode "project" "NotAProject" ${project}
		else
			#Incorperate sed instead of what you're doing
			grep -v "src=" ${ClideDir}/${project}.clide > new
			mv new ${ClideDir}/${project}.clide
			#Grab Project Data
			echo "src=${src}" >> ${ClideDir}/${project}.clide
		fi
	fi
}

#list active projects
listProjects()
{
	#Get list of active prijects from .clide files
	ls ${ClideDir}/ | grep -v "session" | sed "s/.clide//g"
}

#Load active projects
loadProject()
{
	local project=$1
	local path=""
	local RtnVals=""
	local tag=""
	if [ ! -d "${ClideDir}" ]; then
		errorCode "project"
	else
		if [ -z ${project} ]; then
			echo "no"
		else
			#Locate Project Directory
			if [ -f ${ClideDir}/${project}.clide ]; then
				#Grab Project Data
				#Name Value
				tag="name="
				name=$(grep ${tag} ${ClideDir}/${project}.clide | sed "s/${tag}//g")
				#Language Value
				tag="lang="
				lang=$(grep ${tag} ${ClideDir}/${project}.clide | sed "s/${tag}//g")
				#Source Value
				tag="path="
				path=$(grep ${tag} ${ClideDir}/${project}.clide | sed "s/${tag}//g")
				#Source Value
				tag="src="
				src=$(grep ${tag} ${ClideDir}/${project}.clide | sed "s/${tag}//g")
				#return valid
				RtnVals="${lang};${src};${path}"
				echo ${RtnVals}
			else
				#return false value
				echo "no"
			fi
		fi
	fi
}

#remove source code
Remove()
{
	local active=$1
	local src=$2
	local option=$3
	if [ ! -z "${src}" ]; then
		case  ${src} in
			--force)
				src=${option}
				option="--force"
				;;
			*)
				;;
		esac
		if [ *"${src}"* == "${active}" ]; then
			if [ -f ${src} ]; then
				if [ "${option}" == "--force" ]; then
					rm ${src}
					echo "\"${src}\" is REMOVED"
				else
					clear
					errorCode "remove" "sure"
					echo -n "Are you Sure you want to remove \"${src}\" (YES/NO)? "
					read User
					case ${User} in
						YES)
							clear
							rm ${src}
							echo "\"${src}\" is REMOVED"
							;;
						*)
							clear
							echo "\"${src}\" is NOT removed"
							;;
		 			esac
					errorCode "remove" "hint"
				fi
			else
				echo "\"${src}\" not a file"
			fi
		else
			echo "\"${src}\" not a file"
		fi
	fi
}

runCode()
{
	local Lang=$1
	local name=$2
	local option=$3
	local Args=""
	local JavaProp=""
	local TheBin=""
	local TheJar=""
	if [[ "${name}" == *","* ]]; then
		echo "${Head} can only handle ONE file"
	else
		case ${Lang} in
			#Adjust for C++ code
			C++)
				TheBin="${name%.*}"
				;;
			#Adjust for Java code
			Java)
				TheBin="${name%.*}.class"
				TheJar="${name%.*}.jar"
				#Check for Java System.getProperty
				getPropPresent=$(grep "System.getProperty" ${name} | grep \, | tr -d '\t')
				if [ ! -z "${getPropPresent}" ] && [ -z "${JavaProp}" ]; then
					if [ -z "${JavaRunProp}" ]; then
						#User Provide Values
						echo "Please Provide Java Property"
						echo -n "-D"
						read -e EnvArgs
						EnvArgs=$(echo "-D${EnvArgs}")
						#All Given in one line
					fi
					#Ensure correct flags
					if [[ "${EnvArgs}" == "-D"*"=\""*"\"" ]]; then
						JavaProp=${EnvArgs}
					#Args pre-set
					elif [[ "${JavaRunProp}" == "-D"*"=\""*"\"" ]]; then
						JavaProp=${JavaRunProp}
					else
						JavaProp=""
					fi
				fi
				;;
			#Bash and Python
			*)
				TheBin="${name}"
				;;
		esac

		#Come up with a way to know if arguments are needed
		TheLang=$(color "${Lang}")
		#If Java Class, remove .class
		if [[ "${TheBin}" == *".class" ]]; then
			TheName=$(color "${TheBin%.*}")
			TheNameJar=$(color "${TheBin%.*}.jar")
		#Other Languages
		else
			TheName=$(color "${TheBin}")
		fi
		#User Wishes to provide arments for program
		case ${option} in
			-a|--args)
				CLIout=""
				case ${Lang} in
					Python)
						CLIout="$USER@${Name}:~/${TheLang}\$ ${PythonRun} ${TheName}"
						;;
					Perl)
						CLIout="$USER@${Name}:~/${TheLang}\$ ${PerlRun} ${TheName}"
						;;
					Ruby)
						CLIout="$USER@${Name}:~/${TheLang}\$ ${RubyRun} ${TheName}"
						;;
					Java)
						if [ ! -z "${JavaProp}" ]; then
							#Its a Class
							if [ -f ${JavaBin}/${TheBin} ]; then
								CLIout="$USER@${Name}:~/${TheLang}\$ java ${JavaProp} ${TheName}"
							#Its a Jar
							elif [ -f ${JavaBin}/${TheJar} ]; then
								CLIout="$USER@${Name}:~/${TheLang}\$ java -jar ${TheNameJar}"
							fi
						else
							#Its a Class
							if [ -f ${JavaBin}/${TheBin} ]; then
								CLIout="$USER@${Name}:~/${TheLang}\$ java ${TheName}"
							#Its a Jar
							elif [ -f ${JavaBin}/${TheJar} ]; then
								CLIout="$USER@${Name}:~/${TheLang}\$ java -jar ${TheNameJar}"
							fi
						fi
						;;
					*)
						CLIout="$USER@${Name}:~/${TheLang}\$ ./${TheName}"
						;;
				esac
				#User Args not Pre-done
				if [ -z "${RunTimeArgs}" ]; then
					#Get User Args
					echo -n "${CLIout} "
					read -a Args
				#User Args Pre-done
				else
					#Show Args
					echo -n ${CLIout} "${RunTimeArgs[@]}"
					read
					Args=${RunTimeArgs[@]}
				fi
				;;
			*)
				;;
		esac

		case ${Lang} in
			#Bash
			Bash)
				#Check if Bash Script exists
				if [ -f ${BashBin}/${name} ]; then
				${BashBin}/${name} ${Args[@]}
				else
					errorCode "cpl" "need" "${name}"
				fi
				;;
			#Python
			Python)
				#Check if Pythin Bin exists
				if [ -f ${PythonBin}/${TheBin} ]; then
					${PythonRun} ${PythonBin}/${TheBin} ${Args[@]}
				else
					errorCode "cpl" "need" "${name}"
				fi
				;;
			#Perl
			Perl)
				#Check if Perl Bin exists
				if [ -f ${PerlBin}/${TheBin} ]; then
					${PerlRun} ${PerlBin}/${TheBin} ${Args[@]}
				else
					errorCode "cpl" "need" "${name}"
				fi
				;;
			#Ruby
			Ruby)
				#Check if Ruby Bin exists
				if [ -f ${RubyBin}/${TheBin} ]; then
					${RubyRun} ${RubyBin}/${TheBin} ${Args[@]}
				else
					errorCode "cpl" "need" "${name}"
				fi
				;;
			#C++
			C++)
				#Check if C++ Bin exists
				if [ -f ${CppBin}/${TheBin} ]; then
					${CppBin}/${TheBin} ${Args[@]}
				else
					errorCode "cpl" "need" "${name}"
				fi
				;;
			#Java
			Java)
				#Check if Java Class exists
				if [ -f ${JavaBin}/${TheBin} ]; then
					TheBin=${TheBin%.*}
					cd ${JavaBin}
					#If no JavaProp found
					if [ -z "${JavaProp}" ]; then
						#Execute without
						${JavaRun} ${TheBin} ${Args[@]}
					else
						${JavaRun} "${JavaProp}" ${TheBin} ${Args[@]}
					fi
					cd - > /dev/null
				#Check if Java Jar exists
				elif [ -f ${JavaBin}/${TheJar} ]; then
					${JavaRun} -jar ${JavaBin}/${TheJar} ${Args[@]}
				else
					errorCode "cpl" "need" "${name}"
				fi
				;;
			*)
				;;
		esac
	fi
}

selectCode()
{
	local code=$1
	local name=$2
	local old=$3
	name=$(ManageLangs ${code} "selectCode" ${name})
	#Return source file if exists
	if [ -f "${name}" ]; then
		echo "${name}"
	#Return old source file if new does not exist
	else
		echo "${old}"
	fi
}

#get Program Source Code Dir
pgDir()
{
	local code=$1
	ManageLangs ${code} "pgDir" ${name}
}

#get Language Name
pgLang()
{
	local Lang=$(echo "$1" | tr A-Z a-z)
	ManageLangs ${Lang} "pgLang"
}

#Color Text
color()
{
	local text=$1
	ManageLangs ${text} "color"
}

ColorCodes()
{
	#Bash
	if [ ! -z "${BashCpl}" ]; then
		Bash=$(color "Bash")
	fi
	#Python
	if [ ! -z "${PythonRun}" ]; then
		Python=$(color "Python")
	fi
	#Perl
	if [ ! -z "${PerlRun}" ]; then
		Perl=$(color "Perl")
	fi
	#Ruby
	if [ ! -z "${RubyRun}" ]; then
		Ruby=$(color "Ruby")
	fi
	#C++
	if [ ! -z "${CppCpl}" ]; then
		Cpp=$(color "C++")
	fi
	#Java
	if [ ! -z "${JavaCpl}" ] && [ ! -z "${JavaRun}" ]; then
		Java=$(color "Java")
	fi
	pg="${Bash} ${Python} ${Perl} ${Ruby} ${Cpp} ${Java}"
	echo ${pg}
}

#Compile Python script
py2bin()
{
	local TheFile=$1
	#Make sure its python
	if [[ "$TheFile" == *".py" ]]; then
		#Get program name
		Name=${TheFile[0]%.*}
		#Compile Python script
		pyinstaller -F $TheFile
		#clear terminal
		clear
		#move compiled to src dir
		mv dist/$Name .
		#Remove unwanted files/dir
		rm ${Name}.spec
		rm -rf build
		rm -rf dist
	fi
}

#Handle Aliases
AddAlias()
{
	local AliasName=$1
	local Command="$2 $3"
	local Insert="alias ${AliasName}=\"${Command} \$@\""
	if [[ "$USER" == "root" ]]; then
		Replace="\\$HOME\\/"
	else
		Replace="\\/home\\/$USER\\/"
	fi
	local With="\~\\/"
	local CheckFor=$(echo ${Insert} | sed "s/${Replace}/${With}/g")
	touch ${Aliases}
	if grep -q "alias ${AliasName}=" ${Aliases}; then
		errorCode "alias" ${AliasName}
	else
		if grep -q "${CheckFor}" ${Aliases}; then
			errorCode "alias" ${AliasName}
		else
			#Add Alias to .bash_aliases file
			echo ${Insert} >> ${Aliases}
			cat ${Aliases} | sort | uniq > ${Aliases}.new
			mv ${Aliases}.new ${Aliases}
			sed "s/${Replace}/${With}/g" ${Aliases} > ${Aliases}.new
			mv ${Aliases}.new ${Aliases}
			echo "\"${AliasName}\" installed"
		fi
	fi
}

#Handle Git commands
gitHandler()
{
	local repoAct=$1
	shift
	#check if git is installed
	GitTool=$(which git)
	#Git is installed
	if [ ! -z "${GitTool}" ]; then
		case ${repoAct} in
			#Create a new repo
			new|init)
				echo git init
				;;
			#clone a new repo
			setup|clone)
				#Find repo name
				repo=$@
				if [ ! -z "${repo}" ]; then
					echo git clone ${repo[@]}
				#Repo not given
				else
					#Ask User for Repo
					echo -n "repo: "
					read -a repo
					#Repo given
					if [ ! -z "${repo}" ]; then
						#Run through 2nd time
						gitHandler "clone" "${repo[@]}"
					#Again...nothing
					else
						#Nothing to do
						echo "Nothing to clone"
					fi
				fi
				;;
			#Add files to changes
			add)
				files=$@
				#Files given
				if [ ! -z "${files}" ]; then
					echo git add ${files}
				else
					#Get ALL files from user
					echo git add .
				fi
				;;
			#Provide message for repo
			message|commit)
				#Get message
				msg=$@
				if [ ! -z "${msg}" ]; then
					echo git commit -m "\"${msg}\""
				#No message found
				else
					#As for user...get EVERYTHING typed
					echo -n "Message: "
					read -a msg
					#Message given
					if [ ! -z "${msg}" ]; then
						gitHandler "commit" "${msg[@]}"
					else
						echo "No message found"
					fi
				fi
				;;
			#Handles Git Branches
			branch|branches)
				branchAct=$1
				shift
				case ${branchAct} in
					new)
						name=$1
						if [ ! -z "${name}" ]; then
							echo git checkout -b "${name}"
						else
							echo -n "Provide a branch name"
							read name
							if [ ! -z "${name}" ]; then
								gitHandler "branch" "new" "${name}"
							else
								echo "No branch has been created"
							fi
						fi
						;;
					#delete branches on local repo
					remove|delete)
						#Get branch name
						name=$1
						#branch name given
						if [ ! -z "${name}" ]; then
							#remove branch
							echo git branch -d "${name}"
						#no branch name given
						else
							#Get user to type branch name
							echo -n "Provide a branch name"
							read name
							#branch name given
							if [ ! -z "${name}" ]; then
								#remove branch
								gitHandler "branch" "delete" "${name}"
							#no branch name given
							else
								echo "No Branch has been deleted"
							fi
						fi
						;;
					select|checkout)
						#Get branch name
						name=$1
						#branch name given
						if [ ! -z "${name}" ]; then
							#Select branch
							echo git checkout "${name}"
						#no branch name given
						else
							#Get user to type branch name
							echo -n "Provide a branch name"
							read name
							#branch name given
							if [ ! -z "${name}" ]; then
								#Select branch
								gitHandler "branch" "checkout" "${name}"
							#no branch name given
							else
								echo "No Branch has been selected"
							fi
						fi
						;;
					#list all branches
					*)
						echo git branch -a
						;;
				esac
				;;
			upload|push)
				branch=$1
				if [ ! -z "${branch}" ]; then
					echo git push origin "\"${branch}\""
				else
					echo -n "Please choose a banch: "
					read branch
					if [ ! -z "${branch}" ]; then
						gitHandler "push" "${branch}"
					else
						echo "Code not pushed"
					fi
				fi
				;;
			#Download from the repo
			download|pull)
				echo git pull
				;;
			#Display repo infortmation
			state|status)
				echo git status
				;;
			#Peform quick and dirty commit
			slamdunk)
				gitHandler "add"
				gitHandler "commit"
				gitHandler "push"
				;;
			help|options)
				echo "git help page"
				;;
			*)
				RepoVersion
				;;
		esac
	#git is not installed
	else
		echo "Please Install git"
	fi
}

svnHandler()
{
	local repoAct=$1
	shift
	#check if git is installed
	SvnTool=$(which svn)
	#Git is installed
	if [ ! -z "${SvnTool}" ]; then
		echo "svn is installed"
	#svn is not installed
	else
		echo "Please Install svn"
	fi
}

repoHandler()
{
	case ${repoTool} in
		git)
			#git execution is handled by user
			if [[ "${repoAssist}" == "False" ]] && [[ "$1" == "${repoTool}" ]]; then
				IsInstalled=$(which ${repoTool})
				if [ ! -z "${IsInstalled}" ]; then
					$@
				else
					echo "\"${repoTool}\" is not installed"
				fi
			#git execution is handled by cl[ide]
			elif [[ "${repoAssist}" == "True" ]]; then
				shift
				gitHandler $@
			else
				echo "repo version control has been disabled"
			fi
			;;
		svn)
			#svn execution is handled by user
			if [[ "${repoAssist}" == "False" ]] && [[ "$1" == "${repoTool}" ]]; then
				IsInstalled=$(which ${repoTool})
				if [ ! -z "${IsInstalled}" ]; then
					$@
				else
					echo "\"${repoTool}\" is not installed"
				fi
			#svn execution is handled by cl[ide]
			elif [[ "${repoAssist}" == "True" ]]; then
				shift
				svnHandler $@
			else
				echo "repo version control has been disabled"
			fi
			;;
		*)
			echo "${Head} is unable to use \"${repoTool}\" at this time"
			;;
	esac
}

#IDE
Actions()
{
	loadAuto
	local Dir=""
	local ProjectDir=""
	local Lang=$1
	local CodeDir=$(pgDir ${Lang})
	local pLangs=$(ColorCodes)
	local prompt=""
	local UserArg=""
	#No Project Given
	if [ -z $2 ]; then
		Code=""
	else
		Code=$2
	fi
	#No Project Given
	if [ -z $3 ]; then
		CodeProject="none"
	else
		CodeProject=$3
		Dir="${CodeProject}"
	fi

	#Avoid getting incorrect directory name
	if [[ "${Dir}" == "none" ]]; then
		Dir=""
	fi
	#Language Chosen
	if [[ ! "${CodeDir}" == "no" ]]; then
		cd ${CodeDir}/${Dir}
		Code=$(selectCode ${Lang} ${Code})
		Banner
		while true
		do
			#Change Color for Language
			cLang=$(color ${Lang})
			#Change Color for Code
			cCode=$(color ${Code})

			if [[ "${Code}" == "" ]]; then
				if [[ "${CodeProject}" == "none" ]]; then
					#Menu with no code
					prompt="${Name}(${cLang}):$ "
				else
					ThePWD=$(pwd)
					ProjectDir=$(echo ${ThePWD#*${CodeProject}} | sed "s/\//:/1")
					cCodeProject=$(echo -e "\e[1;40m${CodeProject}\e[0m")
					#Menu with no code
					prompt="${Name}(${cLang}[${cCodeProject}${ProjectDir}]):$ "
				fi
			else
				if [[ "${CodeProject}" == "none" ]]; then
					#Menu with code
					cCodeProject=$(echo -e "\e[1;40m${CodeProject}\e[0m")
					prompt="${Name}(${cLang}{${cCode}}):$ "
				else
					ThePWD=$(pwd)
					ProjectDir=$(echo ${ThePWD#*${CodeProject}} | sed "s/\//:/1")
					#Menu with no code
					cCodeProject=$(echo -e "\e[1;40m${CodeProject}\e[0m")
					prompt="${Name}(${cLang}[${cCodeProject}${ProjectDir}]{${cCode}}):$ "
				fi
			fi
			#Handle CLI
			#read -a UserIn
			read -e -p "${prompt}" -a UserIn
			UserArg=$(echo ${UserIn[0]} | tr A-Z a-z)
			if [ ! -z "${UserIn[0]}" ]; then
				history -s "${UserIn[@]}"
			fi
			case ${UserArg} in
				#List files
				ls)
					ls ${UserIn[1]}
					;;
				ll)
					shift
					ls -lh ${UserIn[1]}
					;;
				#Clear screen
				clear)
					clear
					;;
				#Set for session
				set)
					Code=$(selectCode ${Lang} ${UserIn[1]} ${Code})
					;;
				#Unset code for session
				unset)
					Code=""
					;;
				#Delete source code
				rm|remove|delete)
					Remove ${Code} ${UserIn[1]} ${UserIn[2]}
					Code=""
					;;
				#change dir in project
				cd)
					#Use ONLY for Projects
					case ${CodeProject} in
						none)
							echo "Must have an active project"
							;;
						*)
							cd ${UserIn[1]}
							here=$(pwd)
							if [[ ! "${here}" == *"${CodeProject}"* ]]; then
								echo "Leaving your project is not allowed"
								cd - > /dev/null
							fi
							;;
					esac
					;;
				#get pwd of dir
				pwd)
					#Use ONLY for Projects
					if [[ ! "${CodeProject}" == "none" ]]; then
						here=$(pwd)/
						echo ${here#*${CodeProject}}
					else
						echo "Must have an active project"
					fi
					;;
				#make dir in project
				mkdir)
					#Use ONLY for Projects
					if [[ ! "${CodeProject}" == "none" ]]; then
						mkdir ${UserIn[1]}
					else
						echo "Must have an active project"
					fi
					;;
				#Handle Projects
				project)
					#Project commands
					case ${UserIn[1]} in
						#Create new project
						new)
							if [[ "${Lang}" == "Java" ]]; then
								echo "${Head} Cannot handle Java Projects"
							else
								#Locate Project Directory
								if [ -f "${ClideDir}/${UserIn[2]}.clide" ]; then
									errorCode "project" "exists" ${UserIn[2]}
								else
									newProject ${Lang} ${UserIn[2]}
									Code=""
									updateProject ${UserIn[2]} ${Code}
									if [ ! -z ${UserIn[2]} ]; then
										CodeProject=${UserIn[2]}
										echo "Created \"${CodeProject}\""
										ThePWD=$(pwd)
										ProjectDir=$(echo ${ThePWD#*${CodeProject}} | sed "s/\//:/1")
									fi
								fi
							fi
							;;
						#Update live project
						update)
							updateProject ${CodeProject} ${Code}
							echo "\"${CodeProject}\" updated"
							;;
						#Load an existing project
						load)
							project=$(loadProject ${UserIn[2]})
							if [ "${project}" != "no" ]; then
								CodeDir=$(echo ${project} | cut -d ";" -f 3)
								if [ -d ${CodeDir} ]; then
									Lang=$(echo ${project} | cut -d ";" -f 1)
									Code=$(echo ${project} | cut -d ";" -f 2)
									CodeProject=${UserIn[2]}
									cd ${CodeDir}
									echo "Project \"${CodeProject}\" loaded"
								else
									echo "Project \"${UserIn[2]}\" Directory not Found"
								fi
							else
								echo "Not a valid project"
							fi
							;;
						#Import project not created by cl[ide]
						import)
							importProject ${Lang} ${UserIn[2]} ${UserIn[3]}
							;;
						#Display active project
						active)
							#There is no project listed
							if [[ "${CodeProject}" == "none" ]]; then
								echo "There are no active projects"
							#Project is found
							else
								echo "Active Project [\"${CodeProject}\"]"
							fi
							;;
						#List all known projects
						list)
							listProjects
							;;
						#Show Project help page
						*)
							ProjectHelp
							;;
					esac
					;;
				#Swap Programming Languages
				use|c++|java|python|perl|ruby|bash)
					Old=${Lang}
					OldCode=${Code}
					case ${UserIn[0]} in
						use)
							Lang=$(pgLang ${UserIn[1]})
							Code=${UserIn[2]}
							;;
						*)
							Lang=$(pgLang ${UserIn[0]})
							Code=${UserIn[1]}
							;;
					esac
					if [[ ! "${Lang}" == "no" ]]; then
						cLang=$(color ${Lang})
						CodeDir=$(pgDir ${Lang})
						cd ${CodeDir}
						#Rest
						#{
						Code=$(selectCode ${Lang} ${Code} "")
						RunTimeArgs=""
						CodeProject="none"
						#}
					else
						Lang=${Old}
						echo "Possible: ${pLangs}"
					fi
					;;
				#use the shell of a given language
				shell)
					case ${Lang} in
						#Python
						Python)
							#Enter shell
							${PythonRun}
							;;
						#Language does not support a shell
						*)
							;;
					esac
					;;
				#Create new source code
				new)
					case ${UserIn[1]} in
						#Get Code Template Versions
						--version|-v)
							ManageLangs ${Lang} "TemplateVersion"
							;;
						#Get Help Page for new code
						--help|-h)
							newCodeHelp ${Lang}
							;;
						--custom|-c)
							local BeforeFiles=""
							local AfterFiles=""
							local Type=""
							case ${Lang} in
								#Language is Bash
								Bash)
									#Type="sh"
									#BeforeFiles=$(ls *.${Type})
									BeforeFiles=$(ls *.*)
									;;
								#Language is Python
								Python)
									#Type="py"
									#BeforeFiles=$(ls *.${Type})
									BeforeFiles=$(ls *.*)
									;;
								#Language is Perl
								Perl)
									#Type="pl"
									#BeforeFiles=$(ls *.${Type})
									BeforeFiles=$(ls *.*)
									;;
								#Language is Ruby
								Ruby)
									#Type="rb"
									#BeforeFiles=$(ls *.${Type})
									BeforeFiles=$(ls *.*)
									;;
								#Language is C++
								C++)
									#Type="cpp"
									#BeforeFiles=$(ls *.${Type})
									BeforeFiles=$(ls *.*)
									;;
								#Language is Java
								Java)
									#Type="java"
									#BeforeFiles=$(ls *.${Type})
									BeforeFiles=$(ls *.*)
									;;
								*)
									;;
							esac
							#Create new code
							ManageLangs ${Lang} "customCode" ${Lang} ${cLang}
							#AfterFiles=$(ls *.${Type})
							AfterFiles=$(ls *.*)
							#look for created files
							NewCode=$(echo ${BeforeFiles} ${AfterFiles} | tr ' ' '\n' | sort | uniq -u | tr -d '\n')
							#Check if new code is found
							if [ ! -z "${NewCode}" ]; then
								#Select new Code
								Code=$(selectCode ${Lang} ${NewCode} ${Code})
							fi
							;;
						#Protect against incorrect file naming
						-*)
							echo "\"${UserIn[1]}\" is not a valid program name"
							;;
						#Create new src file
						*)
							#Ensure filename is given
							if [ ! -z "${UserIn[1]}" ]; then
								#Return the name of source code
								ManageLangs ${Lang} "newCode" ${UserIn[1]} ${CodeProject} ${UserIn[2]}
								case ${Lang} in
									#Language is Bash
									Bash)
										#Get code
										if [ -f ${BashSrc}/${UserIn[1]}.sh ]; then
											Code=${UserIn[1]}.sh
										elif [ -f ${BashSrc}/${UserIn[1]} ]; then
											Code=${UserIn[1]}
										fi
										;;
									#Language is Python
									Python)
										#Get code
										if [ -f ${PythonSrc}/${UserIn[1]}.py ]; then
											Code=${UserIn[1]}.py
										elif [ -f ${PythonSrc}/${UserIn[1]} ]; then
											Code=${UserIn[1]}
										fi
										;;
									#Language is Perl
									Perl)
										#Get code
										if [ -f ${PerlSrc}/${UserIn[1]}.pl ]; then
											Code=${UserIn[1]}.pl
										elif [ -f ${PerlSrc}/${UserIn[1]} ]; then
										Code=${UserIn[1]}
										fi
										;;
									#Language is Ruby
									Ruby)
										#Get code
										if [ -f ${RubySrc}/${UserIn[1]}.rb ]; then
											Code=${UserIn[1]}.rb
										elif [ -f ${RubySrc}/${UserIn[1]} ]; then
											Code=${UserIn[1]}
										fi
										;;
									#Language is C++
									C++)
										#Get code
										if [ -f ${CppSrc}/${UserIn[1]}.cpp ]; then
											Code=${UserIn[1]}.cpp
										elif [ -f ${CppSrc}/${UserIn[1]}.h ]; then
											Code=${UserIn[1]}.h
										elif [ -f ${CppSrc}/${UserIn[1]} ]; then
											Code=${UserIn[1]}
										fi
										;;
									#Language is Java
									Java)
										#Get code
										if [ -f ${JavaSrc}/${UserIn[1]}.java ]; then
											Code=${UserIn[1]}.java
										elif [ -f ${JavaSrc}/${UserIn[1]} ]; then
											Code=${UserIn[1]}
										fi
										;;
									*)
										;;
								esac
							else
								newCodeHelp ${Lang}
							fi
							;;
					esac
					;;
				#Edit new source code
				${editor}|edit|ed)
					ManageLangs ${Lang} "editCode" ${Code} ${UserIn[1]}
					;;
				#Add code to Source Code
				add)
					Code=$(ManageLangs ${Lang} "addCode" ${Code} ${UserIn[1]})
					;;
				#Read code without editing
				${ReadBy}|read)
					ManageLangs ${Lang} "readCode" ${Code} ${UserIn[1]}
					;;
				#Swap from Binary to Src and vise-versa
				swap|swp)
					if [[ "${UserIn[1]}" == "bin" ]]; then
						Code=$(ManageLangs ${Lang} "SwapToBin" ${Code})
					elif [[ "${UserIn[1]}" == "src" ]]; then
						Code=$(ManageLangs ${Lang} "SwapToSrc" ${Code})
					else
						echo "${mode} (src|bin)"
					fi
					;;
				#git/svn handler
				${repoTool}|repo)
					#Use ONLY for Projects
					if [[ ! "${CodeProject}" == "none" ]]; then
						repoHandler ${UserIn[@]}
					else
						echo "Must have an active project"
					fi
					;;
				#search for element in project
				search)
					lookFor ${CodeProject} ${UserIn[1]}
					;;
				#Write notes for code
				notes)
					case ${UserIn[1]} in
						edit|add)
							if [ ! -f "${ClideDir}/${Lang}.notes" ]; then
								echo "[${Lang} Notes]" > ${ClideDir}/${Lang}.notes
							fi
								${editor} ${ClideDir}/${Lang}.notes
							;;
						read)
							if [ -f "${ClideDir}/${Lang}.notes" ]; then
								${ReadBy} ${ClideDir}/${Lang}.notes
							else
								echo "No notes for ${Lang} found"
							fi
							;;
						*)
							NotesHelp ${Lang}
							;;
					esac
					;;
				#create various files/vars for running/compiling code
				create)
					#what to create
					case ${UserIn[1]} in
						make)
							#Manage languages
							case ${Lang} in
								#C++ Make file
								C++)
									case ${CodeProject} in
										#No Project
										none)
											echo "Project C++ ONLY"
											;;
										#Is a project
										*)
											#makefile already exists
											if [ -f ${CppSrc}/${CodeProject}/makefile ]; then
												echo "makefile Already made for \"${CodeProject}\""
											#makefile already made
											else
												touch ${CppSrc}/${CodeProject}/makefile
												echo "makefile Created"
											fi
											;;
									esac
									;;
								#Is not C++
								*)
									echo "make files C++ Only"
									;;

							esac
							;;
						version|-std=*)
							case ${Lang} in
								C++)
									case ${UserIn[1]} in
										-std=*)
											CppCplVersion="${UserIn[1]}"
											;;
										*)
											CppCplVersion="${UserIn[2]}"
											;;
									esac

									if [ -z "${CppCplVersion}" ]; then
										echo -n "${cLang}\$ -std="
										read -a CppCplVersion
									fi
									if [ ! -z "${CppCplVersion}" ]; then
										case ${CppCplVersion} in
											-std=*)
												CppCplVersion=${CppCplVersion#-std=}
												;;
											*)
												;;
										esac
										if [ ! -z "${CppCplVersion}" ] && [[ "${CppCplVersion}" == *"c++"* ]]; then
											CppCplVersion="-std=${CppCplVersion}"
										else
											CppCplVersion=""
										fi
									fi
									;;
								*)
									echo "At this time, only for C++"
									;;
							esac
							;;
						jar|manifest)
							#Manage languages
							case ${Lang} in
								#Java Properties
								Java)
									#Creating new manifast.mf
									if [ ! -f manifest.mf ]; then
										echo "Manifest-Version: 1.1" > manifest.mf
										echo "Created-By: $USER" >> manifest.mf
										echo "Main-Class: " >> manifest.mf
										echo "Sealed: true" >> manifest.mf
									fi
									#edit manifest.mf
									${editor} manifest.mf
									;;
								*)
									echo "Java only"
									;;
							esac
							;;
						#Args for run time
						args)
							echo -n "${cLang}\$ "
							read -a RunTimeArgs
							;;
						#Java properties
						prop|properties|-D)
							#Manage languages
							case ${Lang} in
								#Java Properties
								Java)
									#Enter Java properties
									echo -n "-D"
									read -e EnvArgs
									EnvArgs=$(echo "-D${EnvArgs}")
									#Ensure correct flags
									if [[ "${EnvArgs}" == "-D"*"=\""*"\"" ]]; then
										JavaRunProp=${EnvArgs}
									else
										JavaRunProp=""
									fi
									;;
								*)
									echo "Java only"
									;;
							esac
							;;
						#Clear all
						reset)
							#Default values
							RunTimeArgs=""
							JavaRunProp=""
							echo "All rest"
							;;
						#Show help page
						*)
							CreateHelp ${Lang}
							;;
					esac
					;;
				#Compile code
				compile|cpl)
					ManageLangs ${Lang} "compileCode" ${Code} ${UserIn[1]} ${UserIn[2]}
					#Code=$(ManageLangs ${Lang} "SwapToBin" ${Code})
					;;
				#Install compiled code into aliases
				install)
					ManageLangs ${Lang} "Install" ${Code} ${UserIn[1]}
					;;
				#run compiled code
				execute|exe|run)
					if [ ! -z "${Code}" ]; then
						runCode ${Lang} ${Code} ${UserIn[1]}
					else
						errorCode "cpl" "none"
					fi
					;;
				#Display cl[ide] version
				version|v)
					#echo "${Head}"
					#ClideVersion
					CodeVersion ${Lang}
					;;
				#Display help page
				help)
					MenuHelp ${Lang} ${CodeProject}
					;;
				#load last session
				last|load)
					Dir=""
					session=$(LoadSession)
					Lang=$(echo ${session} | cut -d ";" -f 1)
					CodeProject=$(echo ${session} | cut -d ";" -f 2)
					Code=$(echo ${session} | cut -d ";" -f 3)
					if [[ "${CodeProject}" != "none" ]]; then
						Dir="${CodeProject}"
					fi
					#Determine Language
					case ${Lang} in
						#Language is Bash
						Bash)
							#Get code dir
							CodeDir=${BashSrc}/${Dir}
							;;
						#Language is Python
						Python)
							#Get code dir
							CodeDir=${PythonSrc}/${Dir}
							;;
						#Language is Perl
						Perl)
							#Get code dir
							CodeDir=${PerlSrc}/${Dir}
							;;
						#Language is Ruby
						Ruby)
							#Get code dir
							CodeDir=${RubySrc}/${Dir}
							;;
						#Language is C++
						C++)
							#Get code dir
							CodeDir=${CppSrc}/${Dir}
							;;
						#Language is Java
						Java)
							#Get code dir
							CodeDir=${JavaSrc}/${Dir}
							;;
					esac
					#Go to dir
					cd ${CodeDir}
					;;
				#List supported languages
				langs|languages)
					echo -n "${UserArg}: "
					ColorCodes
					;;
				#Close cl[ide]
				exit|close)
					SaveSession ${CodeProject} ${Lang} ${Code}
					break
					;;
				#ignore all other commands
				*)
					;;
			esac
		done
	fi
}

#Autocomplete Function
autocomp()
{
	local i
	local x
	local y
	local z
	local opt
	local addr
	local types
	local last_addr
	local last_addr_len
	local READLINE_ARRAY
	if [[ "${READLINE_LINE}" == "" ]]; then
		opt=()
		x=0
		while [ ${x} -le ${len} ];
		do
			opt[${#opt[@]}]=${Commands[${x},0]}
			x=$((${x}+1))
		done
		echo "${prompt}${READLINE_LINE}"
		echo "${opt[@]}"
	else
		READLINE_ARRAY=()
		for i in ${READLINE_LINE};
		do
			READLINE_ARRAY[${#READLINE_ARRAY[@]}]=${i}
		done
		opt=()
		x=0
		while [ ${x} -le ${len} ];
		do
			for i in ${Commands[${x},0]};
			do
				if [[ "${i}" == "${READLINE_ARRAY[0]}"* ]]; then
					opt[${#opt[@]}]=${i}
				fi
			done
			x=$((${x}+1))
		done
		if [ ${#opt[@]} == 1 ]; then
			READLINE_LINE="${opt[0]} "
			x=0
			while [[ "${Commands[${x},0]}" != *"${opt[0]}"* ]];
			do
				x=$((x+1))
			done
			if [ ${#READLINE_ARRAY[@]} -gt 1 ]; then
				opt=()
				for i in ${Commands[$x,1]};
				do
					if [[ "${i}" == "" ]]; then
						break
					elif [[ "${i}" == "${READLINE_ARRAY[1]}"* ]]; then
						opt[${#opt[@]}]=${i}
					fi
				done
				if [ ${#opt[@]} == 1 ]; then
					READLINE_LINE="${READLINE_LINE}${opt[0]} "
					z=0
					for i in ${Commands[${x},1]};
					do
						if [[ "${i}" == "${opt[0]}" ]]; then
							break
						fi
						z=$((${z}+1))
					done
					y=2
					while [ ${y} -le 3 ];
					do
						types=()
						for i in ${Commands[${x},${y}]}
						do
							types[${#types[@]}]=${i}
						done
						if [[ "${types[$z]}" == "file" ]]; then
							last_addr=""
							last_addr_len=-${#READLINE_ARRAY[${y}]}
							opt=()
							if [[ "${READLINE_ARRAY[${y}]:$((${#READLINE_ARRAY[${y}]}-1))}" != '/' ]]; then
								addr=${READLINE_ARRAY[${y}]//'/'/' '}
								for i in ${addr}
								do
									last_addr=${i}
								done
								last_addr_len=${#last_addr}
							fi
							for i in $(ls -F ${READLINE_ARRAY[${y}]::-${last_addr_len}})
							do
								if [[ "${i}" == "${last_addr}"* ]]; then
									opt[${#opt[@]}]=${i}
								fi
							done
							if [ ${#opt[@]} == 1 ]; then
								READLINE_LINE="${READLINE_LINE}${READLINE_ARRAY[${y}]::-${last_addr_len}}${opt[0]}"
							else
								if [ ${#opt[@]} -gt 1 ]; then
									echo "${prompt}${READLINE_ARRAY[@]}"
									echo "${opt[@]}"
								fi
								READLINE_LINE="${READLINE_LINE}${READLINE_ARRAY[${y}]}"
							fi
						else
							READLINE_LINE="${READLINE_LINE}${READLINE_ARRAY[${y}]}"
						fi
						y=$((${y}+1))
					done
				else
					if [ ${#opt[@]} -gt 1 ]; then
						echo "${prompt}${READLINE_ARRAY[@]}"
						echo "${opt[@]}"
					fi
					READLINE_LINE="${READLINE_LINE}${READLINE_ARRAY[1]}"
				fi
			else
				if [[ "${Commands[${x},1]}" != "" ]]; then
					echo "${prompt}${READLINE_ARRAY[@]}"
					echo "${Commands[${x},1]}"
				fi
			fi
		elif [ ${#opt[@]} -gt 1 ]; then
			echo "${prompt}${READLINE_ARRAY[@]}"
			echo "${opt[@]}"
		fi
	fi
	READLINE_POINT=${#READLINE_LINE}
}

#Add To Autocomplete Function
comp_list()
{
	len=$(((${#Commands[@]}+2)/3))
	Commands[${len},0]=$1
	Commands[${len},1]=$2
	Commands[${len},2]=$3
	Commands[${len},3]=$4
}

#Load AutoComplete
loadAuto()
{
	#init autocomplete
	set -o vi
	bind -x '"\t":autocomp'
	bind -x '"\C-l":clear'
	comp_list "ls"
	comp_list "ll"
	comp_list "clear"
	comp_list "set"
	comp_list "unset"
	comp_list "rm remove delete" "--force"
	comp_list "cd"
	comp_list "pwd"
	comp_list "mkdir"
	comp_list "use" "${pg}"
	comp_list "swap swp" "src bin"
	comp_list "project" "load import new list"
	comp_list "shell"
	comp_list "new" "--version -v --help -h --custom -c"
	comp_list "${editor} ed edit"
	comp_list "add"
	comp_list "${ReadBy} read"
	comp_list "${repoTool} repo"
	comp_list "search"
	comp_list "create" "make version -std= jar manifest args prop properties -D reset"
	comp_list "compile cpl"
	comp_list "execute exe run" "-a --args"
	comp_list "version"
	comp_list "help"
	comp_list "notes" "edit add read"
	comp_list "last load"
	comp_list "install"
	comp_list "langs languages"
	comp_list "exit close"
}

#Main Function
main()
{
	#Make sure everything is working
	EnsureLangs
	EnsureDirs
	local pg=$(ColorCodes)
	local UserArg=$1
	local prompt
	#No argument given
	if [ -z "${UserArg}" ]; then
		clear
		CliHelp
		echo "~Choose a language~"
		local getLang=""
		#Force user to select language
		while [[ "$getLang" == "" ]] || [[ "$Lang" == "no" ]];
		do
			prompt="${Name}(${pg}):$ "
			read -e -p "${prompt}" getLang
			case ${getLang} in
				exit)
					break
					;;
				*)
					#Verify Language
					Lang=$(pgLang ${getLang})
					;;
			esac
		done

		#Start IDE
		Actions ${Lang}
	else
		case ${UserArg} in
			#Get version from cli
			-v|--version)
				ClideVersion
				;;
			#Get compile/interpreter version from cli
			-cv|--code-version)
				CodeVersion
				;;
			#Get version of template
			-tv|--temp-version)
				ManageLangs Bash "TemplateVersion" | sed "s/Version/Bash/g" | grep -v found
				ManageLangs Python "TemplateVersion" | sed "s/Version/Python/g" | grep -v found
				ManageLangs Perl "TemplateVersion" | sed "s/Version/Perl/g" | grep -v found
				ManageLangs Ruby "TemplateVersion" | sed "s/Version/Ruby/g" | grep -v found
				ManageLangs C++ "TemplateVersion" | sed "s/Version/C++/g" | grep -v found
				ManageLangs Java "TemplateVersion" | sed "s/Version/Java/g" | grep -v found
				;;
			#Get version control version from cli
			-rv|--repo-version)
				RepoVersion
				;;
			#Get verseion from cli
			-c|--config)
				ClideConfig
				;;
			#List projects from cli
			-p|--projects)
				listProjects
				;;
			#Get cli help page
			-h|--help)
				CliHelp
				;;
			-l|--load|--last)
				session=$(LoadSession)
				Lang=$(echo ${session} | cut -d ";" -f 1)
				Code=$(echo ${session} | cut -d ";" -f 3)
				CodeProject=$(echo ${session} | cut -d ";" -f 2)
				#Start IDE
				Actions ${Lang} ${Code} ${CodeProject}
				;;
			#Check for language given
			*)
				#Verify Language
				Lang=$(pgLang $1)
				#Start IDE
				Actions ${Lang} $2
				;;
		esac
	fi
}

history -c
#Run clide
main $@
