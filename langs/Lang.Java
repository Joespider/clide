Shell=$(which bash)
#!${Shell}

SupportV="0.1.25"

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
		ProjectColor)
			local text=$1
			if [ ! -z "${text}" ]; then
				echo -e "\e[1;41m${text}\e[0m"
			fi 
			;;
		SupportVersion)
			echo ${SupportV}
			;;
		MenuHelp)
			echo -e "new <file> {main|component}\t: \"create new ${Lang} source file\""
			echo -e "compile, cpl <type> <manifest>\t: \"make code executable\""
			echo -e "\t--class\t\t\t: \"make code (CLASS) executable\""
			echo -e "\t--jar\t\t\t: \"make code (JAR) executable\""
			echo -e "\t--jar --keep-manifest\t: \"keep manifest.mf\""
			;;
		getCode)
			local name=$1
			case ${CodeProject} in
				none)
					if [ -f ${LangSrc}/${name}.java ]; then
						echo ${name}.java
					elif [ -f ${LangSrc}/${name} ]; then
						echo ${name}
					fi
					;;
				*)
					if [ -f ${LangSrc}/${CodeProject}/src/${name}.java ]; then
						echo ${name}.java
					elif [ -f ${LangSrc}/${CodeProject}/src/${name} ]; then
						echo ${name}
					fi
					;;
			esac
			;;
		pgLang)
			local HasLangCpl=$(which ${JavaCpl} 2> /dev/null)
			local HasLangRun=$(which ${JavaRun} 2> /dev/null)
			if [ ! -z "${HasLangCpl}" ] && [ ! -z "${HasLangRun}" ]; then
				#Return Java tag
				echo "Java"
			else
				#Return rejection
				echo "no"
			fi
			;;
		BeforeFiles|AfterFiles)
			ls *.java 2> /dev/null
			;;
		pgDir)
			#Return Java src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
			echo -e "prop, properties, -D\t: create custome Java properties"
			echo -e "jar, manifest\t\t: create Java Manifest Jar builds"
			;;
		shell)
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
                                echo -n "${TemplateCodeJar##*/} : "
				java -jar ${TemplateCodeJar} 2> /dev/null | grep Version | sed "s/Version: //g"
			else
				echo "no ${TemplateCodeJar##*/} found"
			fi
                        ;;
		CplVersion)
			echo "[Java JDK/JRE]"
			local JavaRunVersion=$(${JavaRun} --version 2> /dev/null)
			local JavaCplVersion=$(${JavaCpl} --version 2> /dev/null)
			if [ ! -z "${JavaRunVersion}" ]; then
				JavaRunVersion=$(${JavaRun} --version | head -n 1)
				JavaCplVersion=$(${JavaCpl} --version | head -n 1)
				echo "${JavaRunVersion}"
				echo "${JavaCplVersion}"
			else
				${JavaRun} -version
				${JavaCpl} -version
			fi
			echo ""
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
			#Compile source code
			case ${src} in
				*.java)
					#Multiple code selected
					if [[ "${src}" == *","* ]]; then
						if [[ "${project}" == *"/" ]]; then
							#Compile Java prgram
							ERROR=$(${JavaCpl} *.java 2>&1 | tr '\n' '|')
							#move Java Class to Binary dir
							if [ -f *.class ]; then
								mv *.class ${TheBinDir}/
							else
								ERROR=$(echo ${ERROR} | tr '|' '\n')
								echo -en "\e[1;31m[\e[0m"
								echo -en "\e[1;41mERROR\e[0m"
								echo -e "\e[1;31m]\e[0m"
								echo -e "\e[1;31m${ERROR}\e[0m"
							fi
						else
							echo "Is not a project"
						fi
					#single code selected
					else
						#Compile Java prgram
						ERROR=$(${JavaCpl} ${src} 2>&1 | tr '\n' '|')
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
									jar -cmf manifest.mf ${des%.class}.jar *.class
									#remove class file
									if [ -f  ${TheBinDir}/${des} ]; then
										rm  ${TheBinDir}/${des}
									fi
									#Keep Generated Manafest file
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
									mv ${des%.class}.jar ${TheBinDir}/
									echo -e "\e[1;41m[Java Code Compiled (JAR)]\e[0m"
									;;
								#Do nothing...keep class
								*|--class)
									#move Java Class to Binary dir
									mv *.class ${TheBinDir}/
									#remove old jar
									if [ -f ${TheBinDir}/${des%.class}.jar ]; then
										rm ${TheBinDir}/${des%.class}.jar
									fi
									echo -e "\e[1;41m[Java Code Compiled (CLASS)]\e[0m"
									;;
							esac
						else
							ERROR=$(echo ${ERROR} | tr '|' '\n')
							echo -en "\e[1;31m[\e[0m"
							echo -en "\e[1;41mERROR\e[0m"
							echo -e "\e[1;31m]\e[0m"
							echo -e "\e[1;31m${ERROR}\e[0m"
						fi
					fi
					;;
				*)
					;;
			esac
			;;
		newProject)
			local project=$1
			local type=$2
			local path=${LangSrc}/${project}
			if [ ! -d ${path} ]; then
				mkdir ${path}
				cd ${path}
				mkdir src bin
			else
				cd ${path}
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
					path=${LangSrc}/${project}/bin/
					;;
			esac
			if [ -d ${path} ]; then
				ls ${path}
			fi
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
			local cLang=$(UseJava "color")
			local TemplateC=${TemplateCodeClass##*/}
			TemplateC=${TemplateC%.*}
			local TemplateJ=${TemplateCodeJar##*/}
			local cTemplateC=$(OtherColor ${TemplateC})
			local cTemplateJ=$(OtherColor ${TemplateJ})
			Type=$(echo ${Type} | tr A-Z a-z)
			#Check for Custom Code Template...is class
			if [ -f ${TemplateCodeClass} ]; then
				echo -n "${cLang}\$ java ${cTemplateC} "
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
				echo -n "${cLang}\$ java -jar ${cTemplateJ} "
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
						local Content="//class path goes here\n\n/**\n *\n * @author $USER\n */\n\n//class name\npublic class ${name} {\n\n\t/**\n\t* @param args the command line arguments\n\t*/\n\tpublic static void main(String[] args) {\n\n\t}\n}"
						touch ${name}.java
						echo -e "${Content}" > ${name}.java
					else
						errorCode "newCode"
					fi
				fi
			fi
			;;
		create-jar|create-manifest)
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
		#Java properties
		create-prop|create-properties|create--D)
			local EnvArgs
			#Enter Java properties
			echo -n "-D"
			read -e EnvArgs
			EnvArgs=$(echo "-D${EnvArgs}")
			#Ensure correct flags
			if [[ "${EnvArgs}" == "-D"*"=\""*"\"" ]]; then
				RunCplArgs=${EnvArgs}
			else
				RunCplArgs=""
			fi
			;;
		cli)
			local TheName=$1
			local TheBin="${TheName%.*}.class"
			local TheJar="${TheName%.*}.jar"
			local JavaProp=$2
			if [ ! -z "${JavaProp}" ]; then
				#Its a Class
				if [ -f ${LangBin}/${TheBin} ]; then
					TheName=$(OtherColor ${TheBin})
					echo "java ${JavaProp} ${TheName}"
				#Its a Jar
				elif [ -f ${LangBin}/${TheJar} ]; then
					TheName=$(OtherColor ${TheJar})
					echo "java -jar ${TheName}"
				fi
			else
				#Its a Class
				if [ -f ${LangBin}/${TheBin} ]; then
					TheName=$(OtherColor ${TheBin})
					echo "java ${TheName}"
				#Its a Jar
				elif [ -f ${LangBin}/${TheJar} ]; then
					TheName=$(OtherColor ${TheJar})
					echo "java -jar ${TheName}"
				fi
			fi
			;;
		runProp)
			local name=$1
			local JavaProp=$2
			#Check for Java System.getProperty
			local getPropPresent=$(grep "System.getProperty" ${name} | grep \, | tr -d '\t')
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
		runCode)
			local name=$1
			local TheBin="${name%.*}.class"
			local TheJar="${name%.*}.jar"
			local project=${CodeProject}
			local TheBinDir
			local JavaProp=$2
			shift
			local Args=$@

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
			#Check if Java Class exists
			if [ -f ${TheBinDir}/${TheBin} ]; then
				TheBin=${TheBin%.*}
				cd ${TheBinDir}
				#If no JavaProp found
				case ${JavaProp} in
					none)
						#Execute without
						${JavaRun} ${TheBin} ${Args[@]}
						;;
					*)
						${JavaRun} "${JavaProp}" ${TheBin} ${Args[@]}
						;;
				esac
				cd - > /dev/null
			#Check if Java Jar exists
			elif [ -f ${TheBinDir}/${TheJar} ]; then
				${JavaRun} -jar ${TheBinDir}/${TheJar} ${Args[@]}
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
				TheOld="${TheOld%.java}"
				TheNew="${TheNew%.java}"
				sed "s/${TheOld}/${TheNew}/g" ${LangSrc}/${TheOld}.java > ${LangSrc}/${TheNew}.java
				rm ${LangSrc}/${TheOld}.java
				echo ${TheNew}.java
			fi
			;;
		copy)
			local TheOld=$1
			local TheNew=$2
			if [ ! -z "${TheNew}" ]; then
				TheOld="${TheOld%.java}"
				TheNew="${TheNew%.java}"
				sed "s/${TheOld}/${TheNew}/g" ${LangSrc}/${TheOld}.java > ${LangSrc}/${TheNew}.java
				echo ${TheNew}.java
			fi
			;;
		*)
			;;
	esac
}

UseJava $@
