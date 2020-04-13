#!/bin/bash
#cl[ide] config
#{
edit=nano
Aliases=~/.bash_aliases

Head="cl[ide]"
Version="0.18"

ProgDir=~/Programs

#Program Homes
BashHome=${ProgDir}/Bash
PythonHome=${ProgDir}/Python
CppHome=${ProgDir}/C++
JavaHome=${ProgDir}/Java

#Soruce Code
BashSrc=${BashHome}/src
PythonSrc=${PythonHome}/src
CppSrc=${CppHome}/src
JavaSrc=${JavaHome}/src

#Bin Code
BashBin=${BashHome}/bin
PythonBin=${PythonHome}/bin
CppBin=${CppHome}/bin
JavaBin=${JavaHome}/bin

Project=""
#}

#Clide menu help page
MenuHelp()
{
	echo ""
	echo "----------------[(${Head}) Menu]----------------"
	echo "ls: \"list progams\""
	echo "unset: \"deselect source code\""
	echo "use {Bash|Python|C++|Java}: \"choose language\""
	echo "swap|swp {src|bin}: \"swap between sorce code and executable\""
	echo "new <file>: \"create new code template\""
	echo "set <file>: \"select source code\""
	echo "add <file>: \"add new file to project\""
	echo "edit|ed: \"edit source code\""
	echo "read: \"read source code\""
	echo "search <find>: \"search for code in project\""
	echo "project {new|update|load|active}: \"handle projects\""
	echo "compile|cpl: \"make code executable\""
	#echo "execute|exe|run: \"run active program\""
	echo "last|load: \"Load last session\""
	echo "exit|close: \"close ide\""
	echo "------------------------------------------------"
	echo ""
}

#Clide cli help page
CliHelp()
{
	echo ""
	echo "----------------[(${Head}) CLI]----------------"
	echo "-v|--version: \"Get Clide Version\""
	echo "-p|--projects: \"List Clide Projects\""
	echo "-h|--help: \"Get CLI Help Page (Cl[ide] Menu: \"help\") \""
	echo "-l|--last|--load: \"Load last session\""
	echo "-----------------------------------------------"
	echo ""
}

ClideVersion()
{
	echo ${Version}
}

Banner()
{
	echo "\"Welcome to ${Head} Version:(${Version})\""
	echo "\"The command line IDE for the Linux/Unix user\""
}

#Error messages
errorCode()
{
	ecd=$1
	sec=$2
	thr=$3
	case $ecd in
		alias)
			echo "\"${sec}\" already installed"
			;;
		install)
			if [[ "${sec}" == "choose" ]]; then
				echo "hint: please choose script"
			else
				echo "\"${sec}\" needs to be an executable"
				echo "[to compile]: cpl"
				echo "OR"
				echo "[swap to executable]: swp bin"
			fi
			;;
		noCode)
			echo "No Code Found"
			echo "[to set code]: set <name>"
			;;
		editNull)
			echo "hint: edit|ed <file>"
			;;
		editNot)
			echo "code is not found in project"
			;;
		readNull)
			echo "hint: read <file>"
			;;
		readNot)
			echo "code is not found in project"
			;;
		project)
			if [[ "${sec}" == "none" ]]; then
				echo "hint: must be a project"
				echo "No project name given"
			elif [[ "${sec}" == "exists" ]]; then
				echo "\"${thr}\" is already a project"
			elif [[ "${sec}" == "NotAProject" ]]; then
				echo "No \"${thr}\" project found"
			else
				echo "Project error"
			fi
			;;
		cpl)
			if [[ "${sec}" == "choose" ]]; then
				echo "hint: please choose script"
			elif [[ "${sec}" == "already" ]]; then
				echo "\"${thr}\" already compiled"
			elif [[ "${sec}" == "not" ]]; then
				echo "code not found"
			else
				echo "Nothing to Compile"
				echo "[to set code]: set <name>"
			fi
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
	project=$1
	search=$2
	if [[ "${project}" == "none" ]]; then
		errorCode "project" "none"
	else
		grep -i ${search} *
	fi
}

#Save Last Session
SaveSession()
{
	Session="${ProgDir}/.clide/session"
	#check for .clide dir
	if [ ! -d "${ProgDir}/.clide" ]; then
		mkdir ${ProgDir}/.clide
	fi
	Language=$1
	Project=$2
	SrcCode=$3
	#Source Needs to be present
	if [ ! -z ${SrcCode} ]; then
		touch ${Session}
		echo "${Project};${Language};${SrcCode}" > ${Session}
	fi
}

#Load Last Session
LoadSession()
{
	Session="${ProgDir}/.clide/session"
	#check for clide session
	if [ ! -f "${Session}" ]; then
		errorCode "loadSession"
	else
		cat ${Session}
	fi
}

#Create new project
newProject()
{
	lang=$1
	project=$2
	path=""
	#check for .clide dir
	if [ ! -d "${ProgDir}/.clide" ]; then
		mkdir ${ProgDir}/.clide
	fi
	#No Project is found
	if [ -z ${project} ]; then
		errorCode "project" "none"
	else
		#Locate Project Directory
		if [ -f "${ProgDir}/.clide/${project}.clide" ]; then
			errorCode "project" "exists" ${project}
		else
			#Grab Project Data
			#Name Value
			echo "name=${project}" > "${ProgDir}/.clide/${project}.clide"
			#Language Value
			echo "lang=${lang}" >> "${ProgDir}/.clide/${project}.clide"
			#Source Value
			echo "src=" >> "${ProgDir}/.clide/${project}.clide"
			#Check if Project dir is made
			if [[ "${lang}" == "Bash" ]]; then
				path=${BashSrc}/${project}
			#Python
			elif [[ "${lang}" == "Python" ]]; then
				path=${PythonSrc}/${project}
			#C++
			elif [[ "${lang}" == "C++" ]]; then
				path=${CppSrc}/${project}
			#Java
			elif [[ "${lang}" == "Java" ]]; then
				path=${JavaSrc}/${project}
			fi
			#create and cd to project dir
			if [ ! -d ${path} ]; then
				mkdir ${path}
				cd ${path}
			else
				cd ${path}
			fi

		fi
	fi
}

#Update config of active Projects
updateProject()
{
	project=$1
	src=$2
	#No Project is found
	if [ ! -z ${src} ]; then
		#Locate Project Directory
		if [ ! -f "${ProgDir}/.clide/${project}.clide" ]; then
			errorCode "project" "NotAProject" ${project}
		else
			grep -v "src=" ${ProgDir}/.clide/${project}.clide > new
			mv new ${ProgDir}/.clide/${project}.clide
			#Grab Project Data
			echo "src=${src}" >> "${ProgDir}/.clide/${project}.clide"
		fi
	fi
}

#list active projects
listProjects()
{
	#Get list of active prijects from .clide files
	ls ${ProgDir}/.clide/ | sed "s/.clide//g"
}

#Load active projects
loadProject()
{
	project=$1
	path=""
	RtnVals=""
	if [ ! -d "${ProgDir}/.clide" ]; then
		errorCode "project"
	else
		if [ -z ${project} ]; then
			echo "no"
		else
			#Locate Project Directory
			if [ -f "${ProgDir}/.clide/${project}.clide" ]; then
				#Grab Project Data
				#Name Value
				tag="name"
				name=$(grep ${tag} "${ProgDir}/.clide/${project}.clide" | sed "s/${tag}=//g")
				#Language Value
				tag="lang"
				lang=$(grep ${tag} "${ProgDir}/.clide/${project}.clide" | sed "s/${tag}=//g")
				#Source Value
				tag="src"
				src=$(grep ${tag} "${ProgDir}/.clide/${project}.clide" | sed "s/${tag}=//g")
				#Bash
				if [[ "${lang}" == "Bash" ]]; then
					path=${BashSrc}/${name}
				#Python
				elif [[ "${lang}" == "Python" ]]; then
					path=${PythonSrc}/${name}
				#C++
				elif [[ "${lang}" == "C++" ]]; then
					path=${CppSrc}/${name}
				#Java
				elif [[ "${lang}" == "Java" ]]; then
					path=${JavaSrc}/${name}
				fi
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

#Edit Source code
editCode()
{
	src=$1
	num=$2
	#Bash
	if [[ "${src}" == *".sh" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "editNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".sh" ]]; then
						${edit} ${num}
					else
						${edit} "${num}.sh"
					fi
				else
					errorCode "editNot"
				fi
			fi
		else
			${edit} ${src}
		fi
	#Python
	elif [[ "${src}" == *".py" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "editNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".py" ]]; then
						${edit} ${num}
					else
						${edit} "${num}.py"
					fi
				else
					errorCode "editNot"
				fi
			fi
		else
			${edit} ${src}
		fi
	#C++
	elif [[ "${src}" == *".cpp" ]] || [[ "${src}" == *".h" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "editNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".cpp" ]] || [[ "${num}" == *".h" ]]; then
						${edit} ${num}
					else
						${edit} "${num}.cpp"
					fi
				else
					errorCode "editNot"
				fi
			fi
		else
			 ${edit} ${src}
		fi
	#Java
	elif [[ "${src}" == *".java" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "editNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".java" ]]; then
						${edit} ${num}
					else
						${edit} "${num}.java"
					fi
				else
					errorCode "editNot"
				fi
			fi
		else
			${edit} ${src}
		fi
	fi
}

#Add code to active session
addCode()
{
	src=$1
	new=$2
	#Bash
	if [[ "$src" == *".sh" ]]; then
		if [[ "${new}" == *".sh" ]]; then
			if [ -f "${new}" ]; then
				echo "${src},${new}"
			else
				echo "${src}"
			fi
		else
			if [ -f "${new}.sh" ]; then
				echo "${src},${new}.sh"
			else
				echo "${src}"
			fi
		fi
	#Python
	elif [[ "$src" == *".py" ]]; then
		if [[ "${new}" == *".py" ]]; then
			if [ -f "${new}" ]; then
				echo "${src},${new}"
			else
				echo "${src}"
			fi
		else
			if [ -f "${new}.py" ]; then
				echo "${src},${new}.py"
			else
				echo "${src}"
			fi
		fi
	#C++
	elif [[ "$src" == *".cpp" ]] || [[ "$src" == *".h" ]]; then
		#Add cpp or header files with file extensions
		if [[ "${new}" == *".cpp" ]] || [[ "${new}" == *".h" ]]; then
			#Append file
			if [ -f "${new}" ]; then
				echo "${src},${new}"
			else
				echo "${src}"
			fi
		#Add cpp or header files without file extensions
		else
			#Append cpp files
			if [ -f "${new}.cpp" ]; then
				echo "${src},${new}.cpp"
			#Append header files
			elif [ -f "${new}.h" ]; then
				echo "${src},${new}.h"
			else
				echo "${src}"
			fi
		fi
	#Java
	elif [[ "$src" == *".java" ]]; then
		if [[ "${new}" == *".java" ]]; then
			if [ -f "${new}" ]; then
				echo "${src},${new}"
			else
				echo "${src}"
			fi
		else
			if [ -f "${new}.java" ]; then
				echo "${src},${new}.java"
			else
				echo "${src}"
			fi
		fi
	fi
}

#Read source code without editing
readCode()
{
	src=$1
	num=$2
	#Bash
	if [[ "${src}" == *".sh" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "readNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".sh" ]]; then
						less ${num}
					else
						less "${num}.sh"
					fi
				else
					errorCode "readNot"
				fi
			fi
		else
			less ${src}
		fi
	#Python
	elif [[ "${src}" == *".py" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "readNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".py" ]]; then
						less ${num}
					else
						less "${num}.py"
					fi
				else
					errorCode "readNot"
				fi
			fi
		else
			less ${src}
		fi
	#C++
	elif [[ "${src}" == *".cpp" ]] || [[ "${src}" == *".h" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "readNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".cpp" ]] || [[ "${num}" == *".h" ]]; then
						less ${num}
					else
						less "${num}.cpp"
					fi
				else
					errorCode "readNot"
				fi
			fi
		else
			less ${src}
		fi
	#Java
	elif [[ "${src}" == *".java" ]]; then
		if [[ "${src}" == *","* ]]; then
			if [ -z $2 ]; then
				errorCode "readNull"
			else
				if [[ "${src}" == *"${num}"* ]]; then
					if [[ "${num}" == *".java" ]]; then
						less ${num}
					else
						less "${num}.java"
					fi
				else
					errorCode "readNot"
				fi
			fi
		else
			less ${src}
		fi
	fi
}

#Create new source code
newCode()
{
	Lang=$1
	name=$2
	oldCode=$3
	#Bash
	if [[ "${Lang}" == "Bash" ]]; then
		if [[ "${name}" == *".sh" ]]; then
			touch ${name}
			echo "#!/bin/bash" > ${name}
			echo "" >> ${name}
			echo "${name}"
		else
			touch "${name}.sh"
			echo "#!/bin/bash" > "${name}.sh"
			echo "" >> "${name}.sh"
			echo "${name}.sh"
		fi
	#Python
	elif [[ "${Lang}" == "Python" ]]; then
		if [[ "${name}" == *".py" ]]; then
			touch "${name}"
			echo "${name}"
		else
			touch "${name}.py"
			echo "${name}.py"
		fi
	#C++
	elif [[ "${Lang}" == "C++" ]]; then
		if [ ! -f "${name}.cpp" ]; then
			${CppBin}/newC++ -w -r -cli -n "${name}"
			echo "${name}.cpp"
		else
			echo "${oldCode}"
		fi
	#Java
	elif [[ "${Lang}" == "Java" ]]; then
		if [ ! -f "${name}.java" ]; then
			#main class already created
			if [[ "${oldCode}" == *".java" ]]; then
				#Create libary class
				python ${PythonBin}/newJava.py -n "${name}"
				echo "${oldCode},${name}.java"
			else
				python ${PythonBin}/newJava.py --main -n "${name}"
				echo "${name}.java"
			fi
		else
			echo "${oldCode}"
		fi
	else
		echo "${oldCode}"
	fi
}

RunCode()
{
	Lang=$1
	name=$2
	Args=$3
	#Bash
	if [[ "${Lang}" == "Bash" ]]; then
		#Check if Bash Script exists
		if [ -f "${BashBin}/${name}" ]; then
			${BashBin}/${name} ${Args}
		fi
	#Python
	elif [[ "${Lang}" == "Python" ]]; then
		#Check if Pythin Bin exists
		if [ -f "${PythonBin}/${name}" ]; then
			${PythonBin}/${name} ${Args}
		fi
	#C++
	elif [[ "${Lang}" == "C++" ]]; then
		#Check if C++ Bin exists
		if [ -f "${CppBin}/${name}" ]; then
			${CppBin}/${name} ${Args}
		fi
	#Java
	elif [[ "${Lang}" == "Java" ]]; then
		#Check if Java Class exists
		if [ -f "${JavaBin}/${name}" ]; then
			name=${name%.*}
			cd ${JavaBin}
			java ${name} ${Args}
			cd ${JavaSrc}
		fi
	fi
}

selectCode()
{
	code=$1
	name=$2
	old=$3
	#bash
	if [[ "${code}" == "Bash" ]]; then
		#Correct filename
		if [[ ! "${name}" == *".sh" ]]; then
			name="${name}.sh"
		fi
	#Python
	elif [[ "${code}" == "Python" ]]; then
		#Correct filename
		if [[ ! "${name}" == *".py" ]]; then
			name="${name}.py"
		fi
	#C++
	elif [[ "${code}" == "C++" ]]; then
		#Correct filename
		if [[ ! "${name}" == *".cpp" ]] && [ -f "${name}.cpp" ]; then
			name="${name}.cpp"
		elif [[ ! "${name}" == *".h" ]] && [ -f "${name}.h" ]; then
			name="${name}.h"
		fi
	#Java
	elif [[ "${code}" == "Java" ]]; then
		#Correct filename
		if [[ ! "${name}" == *".java" ]]; then
			name="${name}.java"
		fi
	fi

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
	code=$1
	#Bash
	if [[ "${code}" == "Bash" ]]; then
		#Return Bash src Dir
		echo ${BashSrc}
	#Python
	elif [[ "$code" == "Python" ]]; then
		#Return Python src Dir
		echo ${PythonSrc}
	#C++
	elif [[ "$code" == "C++" ]]; then
		#Return C++ src Dir
		echo ${CppSrc}
	#Java
	elif [[ "$code" == "Java" ]]; then
		#Return Java src Dir
		echo ${JavaSrc}
	#No Languge found
	else
		#Return rejection
		echo "no"
	fi
}

#get Language Name
pgLang()
{
	Lang=$(echo "$1" | tr A-Z a-z)
	#bash
	if [[ "${Lang}" == "b" ]] || [[ "${Lang}" == "bash" ]]; then
		#Return Bash tag
		echo "Bash"
	#Python
	elif [[ "${Lang}" == "p" ]] || [[ "${Lang}" == "python" ]]; then
		#Return Python tag
		echo "Python"
	#C++
	elif [[ "${Lang}" == "c" ]] || [[ "${Lang}" == "c++" ]]; then
		#Return C++ tag
		echo "C++"
	#Java
	elif [[ "${Lang}" == "j" ]] || [[ "${Lang}" == "java" ]]; then
		#Return Java tag
		echo "Java"
	#No Languge found
	else
		#Return rejection
		echo "no"
	fi
}

#Color Text
color()
{
	text=$1
	#bash
	if [[ "${text}" == "Bash" ]]; then
		#Return Green
		echo -e "\e[1;32m${text}\e[0m"
	#Python
	elif [[ "${text}" == "Python" ]]; then
		#Return Yellow
		echo -e "\e[33m${text}\e[0m"
	#C++
	elif [[ "${text}" == "C++" ]]; then
		#Return Blue
		echo -e "\e[1;34m${text}\e[0m"
	#Java
	elif [[ "${text}" == "Java" ]]; then
		#Return Red
		echo -e "\e[1;31m${text}\e[0m"
	#Other
	else
		#Return Purple
		echo -e "\e[1;35m${text}\e[0m"
	fi
}

ColorCodes()
{
	Bash=$(color "Bash")
	Python=$(color "Python")
	Cpp=$(color "C++")
	Java=$(color "Java")
	pg="${Bash}; ${Python}; ${Cpp}; ${Java}"
	echo ${pg}
}

#Compile Python script
py2bin()
{
	TheFile=$1
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
	AliasName=$1
	Command="$2 $3"
	Insert="alias ${AliasName}=\"${Command} \$@\""
	Replace="\/home\/$USER\/"
	With="\~\/"
	CheckFor=$(echo ${Insert} | sed "s/${Replace}/${With}/g")
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

#Install into bash_aliases
Install()
{
	code=$1
	bin=$2
	#bash
	if [[ "${bin}" == *".sh" ]]; then
		#Get Finary file name without extension
		BinFile="${bin%.*}"
		#Make sure Binary exists
		if [[ -f "${BashBin}/${bin}" ]]; then
			#Add command to Aliases
			AddAlias "${BinFile}" "${BashBin}/${bin}"
		else
			errorCode "install" "${bin}"
		fi
	#Python
	elif [[ "${bin}" == *".py" ]]; then
		#Get Finary file name without extension
		BinFile="${bin%.*}"
		#Make sure Binary exists
		if [[ -f "${PythonBin}/${bin}" ]]; then
			#Add command to Aliases
			AddAlias "${BinFile}" "python ${PythonBin}/${bin}"
		else
			errorCode "install" "${bin}"
		fi
	#C++ Binary
	elif [[ "${code}" == "C++" ]]; then
		#Make sure Binary exists
		if [[ -f "${CppBin}/${bin}" ]]; then
			#Add command to Aliases
			AddAlias "${bin}" "${CppBin}/${bin}"
		else
			errorCode "install" "${bin}"
		fi
	#C++ Source Code
	elif [[ "${bin}" == *".cpp" ]]; then
		errorCode "install" "${bin}"
	#Java binary
	elif [[ "${bin}" == *".class" ]]; then
		#Get Finary file name without extension
		BinFile="${bin%.*}"
		if [[ -f "${JavaBin}/${bin}" ]]; then
			AddAlias "${BinFile}" "${JavaBin}/${bin}"
		else
			errorCode "install" "${bin}"
		fi
	#Java Source Code
	elif [[ "${bin}" == *".java" ]]; then
		errorCode "install" "${bin}"
	#Not found
	else
		errorCode "noCode"
	fi
}

#Compile code
compileCode()
{
	src=$1
	project=$2
	num=$3
	#Handle Project Dir
	if [[ "${project}" == "none" ]]; then
		project=""
	else
		project="${project}/"
	fi
	#bash
	if [[ "${src}" == *".sh" ]]; then
		#Multiple code selected
		if [[ "${src}" == *","* ]]; then
			#varable is empty
			if [ -z ${num} ]; then
				errorCode "cpl" "choose"
			else
				#chosen file is in the list of files
				if [[ "${src}" == *"${num}"* ]]; then
					#only name is given
					if [[ "${num}" != *".sh" ]]; then
						#full filename given
						num=${num}.sh
					fi
					#Make Bash Script executable
					chmod +x ${num}
					#Check if Bash Script does NOT exist
					if [[ ! -f "${BashBin}/${num}" ]]; then
						#Change to Bash Binary dir
						cd ${BashBin}
						#Create Symbolic Link to Bash Script
						ln -s ../src/${project}${num}
						#Change to Bash Source dir
						cd "${BashSrc}/${project}"
						echo "[Code Bash Compiled]"
					else
						errorCode "cpl" "already" ${num}
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
			if [[ ! -f "${BashBin}/${src}" ]]; then
				#Change to Bash Binary dir
				cd ${BashBin}
				#Create Symbolic Link to Bash Script
				ln -s ../src/${project}${src}
				#Change to Bash Source dir
				cd "${BashSrc}/${project}"
				echo "[Code Bash Compiled]"
			else
				errorCode "cpl" "already" ${src}
			fi
		fi
	#Python
	elif [[ "$src" == *".py" ]]; then
		#Compile Python Script
		#py2bin "${src}"
		#Get Python Name
                #pyBin="${src%.*}"
		#Move Python Program to Binary dir
		#mv ${pyBin} ../bin/
		#Check if Python Script does NOT exist
		#
		#Multiple code selected
		if [[ "${src}" == *","* ]]; then
			#variable is empty
			if [ -z ${num} ]; then
				errorCode "cpl" "choose"
			#variable found
			else
				#chosen file is in the list of files
				if [[ "${src}" == *"${num}"* ]]; then
					#only name is given
					if [[ "${num}" != *".py" ]]; then
						#full filename given
						num=${num}.py
					fi
					#Make Python Script executable
					chmod +x ${num}
					#Check if Python Script does NOT exist
					if [[ ! -f "${PythonBin}/${num}" ]]; then
						#Change to Python Binary dir
						cd ${PythonBin}
						#Create Symbolic Link to Python Script
						ln -s ../src/${project}${num}
						#Change to Python Source dir
						cd "${PythonSrc}/${project}"
						echo "[Code Python Compiled]"
					else
						errorCode "cpl" "already" ${num}
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
			if [[ ! -f "${PythonBin}/${src}" ]]; then
				#Change to Python Binary dir
				cd ${PythonBin}
				#Create Symbolic Link to Python Script
				ln -s ../src/${project}${src}
				#Change to Python Source dir
				cd "${PythonSrc}/${project}"
				echo "[Code Python Compiled]"
			#Code is already found
			else
				errorCode "cpl" "already" ${src}
			fi
		fi
	#C++
	elif [[ "$src" == *".cpp"* ]]; then
		#Multiple code selected
		if [[ "${src}" == *","* ]]; then
			#num is empty
			if [ -z ${num} ]; then
				errorCode "cpl" "choose"
			else
				#Separate list of selected code
				prog=$(echo ${src} | sed "s/,/ /g")
				#Compile and move C++ to Binary dir
				if [[ "${project}" == *"/" ]]; then
					g++ ${prog} -o ../../bin/${num}
				else
					g++ ${prog} -o ../bin/${num}
				fi
				echo "[Code Compiled]"
			fi
		#single code selected
		else
			#Compile and move C++ to Binary dir
			if [[ "${project}" == *"/" ]]; then
				g++ ${src} -o ../../bin/${src%.*}

			else
				g++ ${src} -o ../bin/${src%.*}
			fi
			echo "[Code Compiled]"
		fi
	#Java
	elif [[ "$src" == *".java" ]]; then
		#Multiple code selected
		if [[ "${src}" == *","* ]]; then
			if [[ "${project}" == *"/" ]]; then
				#Compile Java prgram
				javac *.java
				#move Java Class to Binary dir
				mv *.class ../bin/
			else
				echo "Is not a project"
			fi
		#single code selected
		else
			#Compile Java prgram
			javac ${src}
			#get Java Class/compiled file name
			des=${src%.*}.class
			#move Java Class to Binary dir
			mv ${des} ../bin/
			echo "[Code Compiled]"
		fi
	#Not found
	else
		errorCode "cpl"
	fi
}

#Switch to Src file
SwapToSrc()
{
	Lang=$1
	src=$2
	#bash
	if [[ "${Lang}" == "Bash" ]]; then
		echo "${src}"
	#Python
	elif [[ "${Lang}" == "Python" ]]; then
		#Get Python Name
	#	src="${src}.py"
	#	#Check if Python source exists
	#	if [[ -f "${PythonSrc}/${src}" ]]; then
	#		#Return Python Source Name
			echo "${src}"
	#	fi
	#C++
	elif [[ "${Lang}" == "C++" ]]; then
		#Get C++ Name
		src="${src}.cpp"
		#Check if C++ source exists
		if [ -f "${CppSrc}/${src}" ]; then
			#Return C++ Source Name
			echo "${src}"
		fi
	#Java
	elif [[ "${Lang}" == "Java" ]]; then
		#Get Java Name
		src="${src%.*}.java"
		#Check if Java source exists
		if [ -f "${JavaSrc}/${src}" ]; then
			#Return Java Source Name
			echo "${src}"
		fi
	else
		echo "${src}"
	fi
}

#Switch to Bin file
SwapToBin()
{
	bin=$1
	#bash
	if [[ "${bin}" == *".sh" ]]; then
		#Check if Bash Binary exists
		if [[ -f "${BashBin}/${bin}" ]]; then
			#Return Bash Binary Name
			echo "${bin}"
		else
			echo "${bin}"
		fi
	#Python
	elif [[ "${bin}" == *".py" ]]; then
		#Get Python Name
	#	bin="${bin%.*}"
		#Check if Python Binary exists
		if [[ -f "${PythonBin}/${bin}" ]]; then
			#Return Python Binary Name
			echo "${bin}"
		else
			echo "${bin}"
		fi
	#C++
	elif [[ "${bin}" == *".cpp" ]]; then
		#Keep Src Name
		OldBin="${bin}"
		#Get C++ Name
		bin="${bin%.*}"
		#Check if C++ Binary exists
		if [ -f "${CppBin}/${bin}" ]; then
			#Return C++ Binary Name
			echo "${bin}"
		else
			echo "${OldBin}"
		fi
	#Java
	elif [[ "${bin}" == *".java" ]]; then
		#Keep SrcName
		OldBin="${bin}"
		#Get Java Name
		bin="${bin%.*}.class"
		#Check Java Binary exists
		if [ -f "${JavaBin}/${bin}" ]; then
			#Return Java Binary Name
			echo "${bin}"
		else
			echo "${OldBin}"
		fi
	#Nothing found
	else
		#Return the Source File
		echo ${bin}
	fi
}

#IDE
Actions()
{
	Dir=""
	Lang=$1
	CodeDir=$(pgDir ${Lang})
	pg=$(ColorCodes)
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
		Banner
		while true
		do
			#Change Color for Language
			cLang=$(color ${Lang})
			#Change Color for Code
			cCode=$(color ${Code})
			if [[ "${Code}" == "" ]]; then
				#Menu with no code
				echo -n "${Head}(${cLang}):$ "
			else
				#Menu with code
				echo -n "${Head}(${cLang}{${cCode}}):$ "
			fi
			read mode arg option
			case ${mode} in
				#List files
				ls)
					ls
					;;
				#Clear screen
				clear)
					clear
					;;
				#Set for session
				set)
					Code=$(selectCode ${Lang} ${arg} ${Code})
					;;
				#Unset code for session
				unset)
					Code=""
					;;
				#Handle Projects
				project)
					#Create new project
					if [ "${arg}" == "new" ]; then
						newProject ${Lang} ${option}
						updateProject ${option} ${Code}
						if [ ! -z ${option} ]; then
							CodeProject=${option}
						fi
					#Update live project
					elif [ "${arg}" == "update" ]; then
						updateProject ${CodeProject} ${Code}
					#Load an existing project
					elif [ "${arg}" == "load" ]; then
						project=$(loadProject ${option})
						if [ "${project}" != "no" ]; then
							Lang=$(echo ${project} | cut -d ";" -f 1)
							Code=$(echo ${project} | cut -d ";" -f 2)
							CodeDir=$(echo ${project} | cut -d ";" -f 3)
							CodeProject=${option}
							cd ${CodeDir}
						else
							echo "\"${CodeProject}\" is not a valid project"
						fi
					#Display active project
					elif [ "${arg}" == "active" ]; then
						echo "Active Project [${CodeProject}]"
					#List all known projects
					elif [ "${arg}" == "list" ]; then
						listProjects
					fi
					;;
				#Swap Programming Languages
				use)
					Old=${Lang}
					Lang=$(pgLang ${arg})
					if [[ ! "${Lang}" == "no" ]]; then
						cLang=$(color ${Lang})
						CodeDir=$(pgDir ${Lang})
						cd ${CodeDir}
						Code=""
						CodeProject="none"
					else
						Lang=${Old}
						echo "Possible: ${pLangs}"
					fi
					;;
				#Create new source code
				new)
					Code=$(newCode ${Lang} ${arg} ${Code})
					;;
				#Edit new source code
				edit|ed)
					editCode ${Code} ${arg}
					;;
				#Add code to Source Code
				add)
					Code=$(addCode ${Code} ${arg})
					;;
				#Read code without editing
				read)
					readCode ${Code} ${arg}
					;;
				#Swap from Binary to Src and vise-versa
				swap|swp)
					if [[ "${arg}" == "bin" ]]; then
						Code=$(SwapToBin ${Code})
					elif [[ "${arg}" == "src" ]]; then
						Code=$(SwapToSrc ${Lang} ${Code})
					else
						echo "$mode (src|bin)"
					fi
					;;
				#search for element in project
				search)
					lookFor ${CodeProject} ${arg}
					;;
				#Compile code
				compile|cpl)
					compileCode ${Code} ${CodeProject} ${arg}
					#compileCode ${Code} ${arg}
					#Code=$(SwapToBin ${Code})
					;;
				#Install compiled code into aliases
				install)
					Install ${Lang} ${Code} ${arg}
					;;
#				execute|exe|run)
#					RunCode ${Lang} ${Code} ${arg}
#					;;
				#Display cl[ide] version
				version|v)
					ClideVersion
					;;
				#Display help page
				help)
					MenuHelp
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
					case ${Lang} in
						Bash)
							CodeDir=${BashSrc}/${Dir}
							;;
						Python)
							CodeDir=${PythonSrc}/${Dir}
							;;
						C++)
							CodeDir=${CppSrc}/${Dir}
							;;
						Java)
							CodeDir=${JavaSrc}/${Dir}
							;;
					esac
					cd ${CodeDir}
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

#Main Function
main()
{
	pg=$(ColorCodes)
	#No argument given
	if [ -z "$1" ]; then
		clear
		CliHelp
		getLang=""
		#Force user to select language
		while [ "$getLang" == "" ] || [[ "$getLang" == "no" ]];
		do
			echo "~Choose a language~"
			echo -n "${Head}(${pg}):$ "
			read getLang
			#Verify Language
			Lang=$(pgLang ${getLang})
			clear
		done
		#Start IDE
		Actions ${Lang}
	#Get verseion from cli
	elif [[ "$1" == "-v" ]] || [[ "$1" == "--version" ]]; then
		ClideVersion
	#List projects from cli
	elif [[ "$1" == "-p" ]] || [[ "$1" == "--projects" ]]; then
		listProjects
	#Get cli help page
	elif [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
		CliHelp
	elif [[ "$1" == "-l" ]] || [[ "$1" == "--load" ]] || [[ "$1" == "--last" ]]; then
		session=$(LoadSession)
		Lang=$(echo ${session} | cut -d ";" -f 1)
		Code=$(echo ${session} | cut -d ";" -f 3)
		CodeProject=$(echo ${session} | cut -d ";" -f 2)
		#Start IDE
		Actions ${Lang} ${Code} ${CodeProject}
	#Check for language given
	else
		#Verify Language
		Lang=$(pgLang $1)
		#Start IDE
		Actions ${Lang} $2
	fi
}

#Run clide
main $@
