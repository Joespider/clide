#!/usr/bin/env bash

#https://stackoverflow.com/questions/10339637/java-import-cannot-find-symbol
#https://www.codejava.net/java-core/tools/how-to-compile-package-and-run-a-java-program-using-command-line-tools-javac-jar-and-java

SupportV="0.2.46"
Lang=Java
LangExt=".java"
ColorNum=1

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

UseJava()
{
	local LangConfig=${cplJava}
	local UseDebugger=${debugJava}

	local LangCpl=$(echo ${LangConfig} | cut -d ',' -f 1)
	local LangRun=$(echo ${LangConfig} | cut -d ',' -f 2)

	local LangHome=${ProgDir}/${Lang}
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local LangProject=${LangHome}/projects

	local TemplateCode=${NewJava}
	TemplateCode=${TemplateCode%.class}
	TemplateCode=${TemplateCode%.jar}
	TemplateCode=${TemplateCode%${LangExt}}

	local TemplateCodeSrc=${TemplateCode}${LangExt}

	local TemplateCodeClass=${LangBin}/${TemplateCode}.class
	local TemplateCodeJar=${LangBin}/${TemplateCode}.jar
	local ShellCodeSrc="shell"${LangExt}

	local TemplateCodeArgs=${NewJavaArgs}

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
			echo -e "   ${srt}oooo${end}"
			echo -e "   ${srt}\`888${end}"
			echo -e "    ${srt}888${end}  ${srt}.oooo.${end}   ${srt}oooo${end}    ${srt}ooo${end}  ${srt}.oooo.${end}"
			echo -e "    ${srt}888${end} ${srt}\`P${end}  ${srt})88b${end}   ${srt}\`88.${end}  ${srt}.8'${end}  ${srt}\`P${end}  ${srt})88b${end}"
			echo -e "    ${srt}888${end}  ${srt}.oP\"888${end}    ${srt}\`88..8'${end}    ${srt}.oP\"888${end}"
			echo -e "    ${srt}888${end} ${srt}d8(${end}  ${srt}888${end}     ${srt}\`888'${end}    ${srt}d8(${end}  ${srt}888${end}"
			echo -e "${srt}.o. ${srt}88P${end} ${srt}\`Y888\"\"8o${end}     ${srt}\`8'${end}     ${srt}\`Y888\"\"8o${end}"
			echo -e "${srt}\`Y888P${end}"
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
					echo "Compiled/Interpreted"
					;;
				*)
					local Classified=$(UseJava ${Type} classified)
					local Exe=$(UseJava ${Type} executable)
					local RunTime=$(UseJava ${Type} runtime)
					echo -e "Classified:\t${Classified}"
					echo -e "Executable:\t${Exe}"
					echo -e "Runtime:\t${RunTime}"
					;;
			esac
			;;
		color)
			#Return Red
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
		getSrcDir)
			echo ${LangSrc}
			;;
		getProjDir)
			echo ${LangProject}
			;;
		getAllProjSrc)
			local project=${CodeProject}
			local TheSrcDir=${LangProject}/${project}/src
			find ${TheSrcDir} -name *"${LangExt}" 2> /dev/null | grep "${ProjectMode}"
			;;
		getProjSrc)
			local name=$1
			local project=${CodeProject}
			local TheSrcDir=${LangProject}/${project}/src
			local UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
			if [ ! -z "${name}" ]; then
				if [ ! -z "${UseProjectTemplate}" ]; then
					ProjectTemplateHandler ${ProjectType} ${Type} ${TheSrcDir} ${name}
				else
					find ${TheSrcDir} -name "${name}" 2> /dev/null | grep "${ProjectMode}"
				fi
			fi
                        ;;
		getProjSrc)
			local name=$1
			local project=${CodeProject}
			local TheSrcDir=${LangProject}/${project}/src
			if [ ! -z "${name}" ]; then
				find ${TheSrcDir} -name "${name}" 2> /dev/null | grep "${ProjectMode}"
			fi
			;;
		IsDebugEnabled)
			local TheCode=$1
			local TheBinDir
			local project=${CodeProject}
			#Handle Project Dir
			case ${project} in
				none)
					TheBinDir=${LangBin}
					;;
				*)
					TheBinDir="${LangProject}/${project}bin"
					;;
			esac
			if [ -d ${TheBinDir} ]; then
				cd "${TheBinDir}"
				local IsClassNotJar=$(UseJava "getBin" "${TheCode}")
				if [ ! -z "${IsClassNotJar}" ]; then
					case ${IsClassNotJar} in
						*.class)
							echo "yes"
							;;
						*)
							echo ${IsClassNotJar}
							;;
					esac
				fi
				cd - > /dev/null
			fi
			;;
		getDebugger)
			echo "${UseDebugger}"
			;;
		getDebugVersion)
			local debugV=$(${UseDebugger} -version 2> /dev/null | head -n 1 | sed "s/This is jdb version/jdb/g")
			if [ ! -z "${debugV}" ]; then
				echo "${debugV}"
			fi
			;;
		getExt)
			echo ${LangExt}
			;;
		SupportVersion)
			echo ${SupportV}
			;;
		MenuHelp)
			echo -e "new <file> {main|component}\t\t: \"create new ${Lang} source file\""
			echo -e "new <file> {main|component} --package <package>\t: \"create new ${Lang} source file with a new or existing package\""
			echo -e "new <file> --package <package>\t\t: \"create new ${Lang} source file with a new or existing package\""
			echo -e "package new <package>\t\t: \"create a new package\""
			echo -e "package move <code> <package>\t\t: \"move existing source code to a new package\""
			echo -e "package move <package>\t\t: \"move a selected source code to a new package\""
			echo -e "\t<package> as in \"this.is.a.package\""
			echo -e "package get <code>\t\t: \"get the package of existing code\""
			echo -e "package get\t\t: \"get the package of selected code\""
			echo -e "compile, cpl <type> <manifest>\t: \"make code executable\""
			echo -e "\t--class\t\t\t: \"make code (CLASS) executable\""
			echo -e "\t--jar\t\t\t: \"make code (JAR) executable\""
			echo -e "\t--jar --keep-manifest\t: \"keep manifest.mf\""
			;;
		ProjectHelp)
			#local Action=$1
			#case ${Action} in
			#	newCode)
			#		echo -e "new <name> --package <package>"
			#		;;
			#	*)
			#		;;
			#esac
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
					*${LangExt}|*.class|*.jar)
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
					*.class)
						echo ${SourceFile%.class}
						;;
					*.jar)
						echo ${SourceFile%.jar}
						;;
					*)
						echo ${SourceFile}
						;;
				esac
			fi
			;;
		getBin)
			local srcCode=$1
			if [ ! -z "${srcCode}" ]; then
				local TheCpl
				local IsJar
				local IsClass
				local TheItem
				local CplList=$(UseJava lscpl | tr '\n' '|')
				for TheItem in ${srcCode//,/ };
				do
					TheItem=$(UseJava "removeExt" "${TheItem}")

					case ${TheItem} in
						*.jar)
							IsJar=$(echo -e "${CplList//|\\n}" | grep -w ${TheItem})
							;;
						*.class)
							IsClass=$(echo -e "${CplList//|/\\n}" | grep -w ${TheItem})
							;;
						*)
							IsJar=$(echo -e "${CplList//|/\\n}" | grep -w ${TheItem}.jar)
							IsClass=$(echo -e "${CplList//|/\\n}" | grep -w ${TheItem}.class)
							;;
					esac

					if [ ! -z "${IsJar}" ] || [ ! -z "${IsClass}" ] ; then
						if [ ! -z "${IsJar}" ]; then
							TheCpl=${IsJar}
						elif [ ! -z "${IsClass}" ] ; then
							TheCpl=${IsClass}
						fi
					break
					fi
				done
				echo ${TheCpl}
				fi
			;;
		getCode)
			local name=$1
			name=$(UseJava "removeExt" "${name}")
			local project=${CodeProject}
			local newName
			local DirPath
			local PackageName
			local TheSrcDir
			case ${project} in
				none)
					if [ -f ${LangSrc}/${name}${LangExt} ]; then
						echo ${name}${LangExt}
					fi
					;;
				*)
					case ${ProjectType} in
						${ProjectDefaultType})
							case ${name} in
								*.*)
									newName=${name##*.}
									DirPath=${name%${newName}}
									DirPath=${DirPath//./\/}
									PackageName=$(echo ${name%.*} | sed "s/${ProjectMode}.java.//1")
									PackageName=${PackageName//\//.}
									TheSrcDir="${LangProject}/${project}/src/${DirPath}"
									;;
								*/*)
									newName=${name##*/}
									PackageName=$(echo ${name%/*} | sed "s/${ProjectMode}\/java\///1")
									PackageName=${PackageName//\//.}
									DirPath=${name%${newName}}
									TheSrcDir="${LangProject}/${project}/src/${DirPath}"
									;;
								*)
									PackageName=$(pwd | sed "s/${project}\/src/|/g" | sed "s/${ProjectMode}\/java\///1" | cut -d '|' -f 2)
									PackageName=${PackageName//\//.}
									TheSrcDir="$(pwd)/"
									newName=${name}
									;;
							esac
							if [ -f ${TheSrcDir}${newName}${LangExt} ]; then
								echo ${name}${LangExt}
							fi
							;;
						*)
							ProjectTemplateHandler "${EnvVars[@]}" ${Type} ${mode}
							;;
					esac
					;;
			esac
			;;
		pgLang)
			local ShowCpl=$1
			if [ ! -z "${ShowCpl}" ]; then
				echo "${LangCpl}/${LangRun}"
			else
				local HasLangCpl=$(which ${LangCpl} 2> /dev/null)
				local HasLangRun=$(which ${LangRun} 2> /dev/null)
				if [ ! -z "${HasLangCpl}" ] && [ ! -z "${HasLangRun}" ]; then
					#Return Java tag
					echo "${Lang}"
				else
					#Return rejection
					echo "no"
				fi
			fi
			;;
		BeforeFiles|AfterFiles)
			local project=${CodeProject}
			ls *${LangExt} 2> /dev/null
			;;
		pgDir)
			#Return Java src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
			echo -e "prop, properties, -D\t\t: create custome ${Lang} properties"
			echo -e "jar, manifest\t\t\t: create ${Lang} Manifest Jar builds"
			;;
		shell)
			UseJava "runCode" "${ShellCodeSrc}"
			;;
		newCodeHelp)
			local project=${CodeProject}
			if [ -f ${TemplateCodeJar} ] || [ -f ${TemplateCodeClass} ]; then
				echo -e "\t-c, --custom <args>\t\t: \"Custom src file using ${Lang} template\""
				echo -e "\t-s, --show <args>\t\t: \"Show custom src code from ${Lang} template without saving\""
				case ${project} in
					none)
						;;
					*)
						echo -e "\t<name> --package <package>\t: \"New source code with package"
						;;
				esac
			fi

			;;
		EnsureDirs)
			if [ ! -z "${LangCpl}" ] && [ ! -z "${LangRun}" ]; then
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
		TemplateVersion)
			#Code is compiled as a jar
			if [ -f ${TemplateCodeJar} ]; then
				echo -n "${TemplateCodeJar##*/} : "
				java -jar ${TemplateCodeJar} 2> /dev/null | grep Version | sed "s/Version: //g"
			#Code is compiled as a class
			elif [ -f ${TemplateCodeClass} ]; then
				local TempBin=${TemplateCodeClass##*/}
				TempBin=${TempBin%.class}
				echo -n "${TemplateCodeClass##*/} : "
				cd ${LangBin}/
				${LangRun} ${TempBin} 2> /dev/null | grep Version | sed "s/Version: //g"
				cd - > /dev/null
			#Code is not compiled
			else
				echo "no ${TemplateCodeJar##*/} found"
			fi
			;;
		CplVersion)
			echo -e "\e[1;4${ColorNum}m[${Lang} JDK/JRE Compiler]\e[0m"
			local MavenVersion=$(mvn --version 2> /dev/null | head -n 1)
			local LangRunVersion=$(${LangRun} --version 2> /dev/null | head -n 1)
			local LangCplVersion=$(${LangCpl} --version 2> /dev/null | head -n 1)
			if [ ! -z "${LangRunVersion}" ]; then
				echo "${LangRunVersion}"
				echo "${LangCplVersion}"
				if [ ! -z "${LangRunVersion}" ]; then
					echo "${MavenVersion}"
				fi
				echo ""
			else
				${LangRun} -version
				${LangCpl} -version
				echo ""
			fi
			;;
		selectCode|addCode)
			local name=$1
			local new=$2
			local project=${CodeProject}
			local newName
			local DirPath
			local TheSrcDir
			local NumFound
			local UseProjectTemplate
			#Correct filename
			if [ ! -z "${name}" ]; then
				name=$(UseJava "removeExt" "${name}")
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
								new=$(UseJava "removeExt" "${new}")
								new=${new}${LangExt}
								LookFor=${new}
								;;
							selectCode)
								name=$(UseJava "removeExt" "${name}")
								name=${name}${LangExt}
								LookFor=${name}
								;;
							*)
								;;
						esac

						UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check "getProjSrc")
						if [ -z "${UseProjectTemplate}" ]; then
							NumFound=$(UseJava "getProjSrc" ${LookFor} 2> /dev/null | grep ${ProjectMode} | wc -l)
						else
							NumFound=$(UseJava "getProjSrc" ${LookFor} 2> /dev/null | wc -l)
						fi

						case ${NumFound} in
							0)
								;;
							1)
								case ${Type} in
									addCode)
										new=$(UseJava "getProjSrc" ${new})
										if [ -f ${new} ]; then
											new=$(UseJava "removeExt" "${new}")
											newName=${new##*/}
											echo "${name},${newName}${LangExt}"
										else
											echo "${name}"
										fi
										;;
									selectCode)
										name=$(UseJava "getProjSrc" ${name})
										if [ -f ${name} ]; then
											name=$(UseJava "removeExt" "${name}")
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
			local ThePath
			local TheName
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
							name=${project}
							ThePath="${LangProject}/${project}/bin"
							;;
					esac
					TheName=$(UseJava "removeExt" "${name}")
					if [ -f ${ThePath}/${TheName}.class ]; then
						echo ${ThePath}/${TheName}.class
					fi
					if [ -f ${ThePath}/${TheName}.jar ]; then
						echo ${ThePath}/${TheName}.jar
					fi
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
					TheName=$(UseJava "removeExt" ${name})
					if [ -f ${ThePath}/${TheName}${LangExt} ]; then
						echo ${ThePath}/${TheName}${LangExt}
					else
						cd ${ThePath}/
						name=$(UseJava "removeExt" ${name})
						theSrc=$(UseJava "getProjSrc" ${name}${LangExt})
						cd -> /dev/null
						if [ ! -z "${theSrc}" ]; then
							echo ${theSrc}
						fi
					fi
					;;
				*)
					;;
			esac
			;;
		editCode|readCode)
			local src=${TheCode}
			local num=$1
			local TheFile
			local project=${CodeProject}
			local newName
			local DirPath
			local TheSrcDir
			local ReadOrEdit
			local UseProjectTemplate
			local NumFound

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
								if [ -z "${num}" ]; then
									errorCode "editNull"
									NumFound=0
								else
									num=$(UseJava "removeExt" "${num}")
									num=${num}${LangExt}

									case ${src} in
										*,${num}*)
											TheFile=${num}
											;;
										*${num},*)
											TheFile=${num}
											;;
										*)
											;;
									esac
								fi
							else
								TheFile=${src}
							fi

							TheSrcDir="${LangProject}/${project}/src/"

							UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check "getProjSrc")
							if [ -z "${UseProjectTemplate}" ]; then
								NumFound=$(UseJava "getProjSrc" ${TheFile} 2> /dev/null | grep ${ProjectMode} | wc -l)
							else
								NumFound=$(UseJava "getProjSrc" ${TheFile} 2> /dev/null | wc -l)
							fi

							case ${NumFound} in
								0)
									;;
								1)
									if [ -z "${UseProjectTemplate}" ]; then
										TheFile=$(UseJava "getProjSrc" ${TheFile} 2> /dev/null | grep ${ProjectMode})
									else
										TheFile=$(UseJava "getProjSrc" ${TheFile} 2> /dev/null)
									fi

									if [ -f ${TheFile} ]; then
										#Read or Write Code
										#{
										${ReadOrEdit} ${TheFile}
										#}
									fi
									;;
								*)
									local Select
									if [ -z "${UseProjectTemplate}" ]; then
										UseJava "getProjSrc" 2> /dev/null | grep ${ProjectMode} | sed "s/\/${project}\/src\//|/1" | cut -d '|' -f 2 | nl
									else
										UseJava "getProjSrc" 2> /dev/null | sed "s/\/${project}\/src\//|/1" | cut -d '|' -f 2 | nl
									fi
									echo -n "> "
									read Select
									Select=$(echo ${Select} | grep "^-\?[0-9]*$")
									if [ ! -z "${Select}" ]; then
										if [ ${Select} -le ${NumFound} ] && [ ${Select} -gt 0 ]; then
											TheFile=$(UseJava "getProjSrc" ${TheFile} 2> /dev/null | tr '\n' '|' | cut -d '|' -f ${Select})
											#Read or Write Code
											#{
											${ReadOrEdit} ${TheFile}
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
		setCplArgs)
			;;
		BuildHelp)
			echo -e "*Default* (--jar)"
			echo -e "\t--jar\t\t: \"Build a jar from project\""
			echo -e "\t--war\t\t: \"Build a war from project\""
			;;
		setCplArgs-help)
			;;
		compileType-list)
			echo -e "--jar\t\t: \"build code as a jar\""
			echo -e "--class\t\t: \"build code as a class\""
			;;
		compileType)
			local GetCplType=$1
			case ${GetCplType,,} in
                                --jar|--class)
					echo ${GetCplType}
					;;
				class)
					echo "--class"
					;;
				jar)
					echo "--jar"
					;;
				*)
					;;
			esac
			;;
		compileCode-message)
			local cplType=$1
			case ${cplType} in
				class)
					echo -e "\e[1;4${ColorNum}m[${Lang} Code Compiled (CLASS)]\e[0m"
					;;
				jar)
					echo -e "\e[1;4${ColorNum}m[${Lang} Code Compiled (JAR)]\e[0m"
					;;
				project-jar)
					shift
					local TheProjName=$1
					echo -e "\e[1;4${ColorNum}m[Project \"${TheProjName}\" Compiled (JAR)]\e[0m"
					;;
				project-class)
					shift
					local TheProjName=$1
					echo -e "\e[1;4${ColorNum}m[Project \"${TheProjName}\" Compiled (CLASS)]\e[0m"
					;;
				project-mvn)
					shift
					local TheProjName=$1
					echo -e "\e[1;4${ColorNum}m[Maven Project \"${TheProjName}\" Compiled (JAR)]\e[0m"
					;;
				*)
					;;
			esac
			;;
		compileCode)
			local src=${TheCode}
			local name=$1
			local keep=$2
			local project=${CodeProject}
			local cplArgs=""
			local TheSrcDir
			local TheBinDir
			local TheMainClass
			local NumOfMain
			local TheItem
			local ERROR
			local look=1

			#Handle Project Dir
			case ${project} in
				#Code is NOT part of a project
				none)
					project=""
					TheBinDir=${LangBin}
					TheSrcDir=${LangSrc}
					#Compile source code
					case ${src} in
						*${LangExt})
							src=${src//,/ }
							#Looks for Main class
							TheMainClass=$(grep -l "public static void main" ${src})
							#get Java Class/compiled file name
							TheMainClass=$(echo ${TheMainClass} | sed "s/${LangExt}/.class/g")
							ERROR=$(${LangCpl} -d ${TheSrcDir}/ ${src} 2>&1 | tr '\n' '|' | grep -v "JAVA_OPTIONS")
							if [ -z "${ERROR}" ]; then
								#Compile as jar or class
								case ${UseTypeOfCpl} in
									#Compile as Jar
									--jar)
										NumOfMain=$(echo -e "${TheMainClass// /\\n}" | wc -l)
										case ${NumOfMain} in
											#only ONE "main" class was found
											1)
												if [ ! -f manifest.mf ]; then
													echo "Manifest-Version: 1.1" > manifest.mf
													echo "Created-By: $USER" >> manifest.mf
													echo "Main-Class: ${TheMainClass%.class}" >> manifest.mf
													echo "Sealed: true" >> manifest.mf
												fi
												jar -cmf manifest.mf ${TheMainClass%.class}.jar *.class
												#remove class file
												if [ -f  "${TheBinDir}/${TheMainClass}" ]; then
													rm  ${TheBinDir}/${TheMainClass}
												fi
												#Keep Generated Manafest file
												case ${keep} in
													--keep-manifest)
														rm *.class 2> /dev/null
														;;
													*)
														rm manifest.mf *.class 2> /dev/null
													;;
												esac
												#move Java Jar to Binary dir
												mv ${TheMainClass%.class}.jar ${TheBinDir}/ 2> /dev/null
												if [ -f "${TheBinDir}/${TheMainClass%.class}.jar" ]; then
													UseJava compileCode-message jar
												else
													errorCode "cpl" "ERROR" "No Jar Found"
												fi
												;;
											#more than ONE "main" class found
											*)
												rm *.class 2> /dev/null
												#Display Error from compiler
												errorCode "cpl" "ERROR" "More than one \"main\" classes were found"
												;;
										esac
										;;
									#Do nothing...keep class
									*|--class)
										#move Java Class to Binary dir
										mv *.class ${TheBinDir}/ 2> /dev/null
										NumOfMain=$(echo -e "${TheMainClass// /\\n}" | wc -l)
										case ${NumOfMain} in
											#only ONE "main" class was found
											1)
												#remove old jar
												if [ -f ${TheBinDir}/${TheMainClass%.class}.jar ]; then
													rm ${TheBinDir}/${TheMainClass%.class}.jar
												fi
												;;
											#many "main" class were found
											*)
												#remove ALL jar
												for TheItem in ${TheMainClass};
												do
													TheItem=${TheItem%.class}.jar
													#remove ALL jar that exist
													if [ -f ${TheBinDir}/${TheItem} ]; then
														rm ${TheBinDir}/${TheItem}
													fi
												done
												;;
										esac
										UseJava compileCode-message class
										;;
								esac
							else
								rm *.class 2> /dev/null
								#Display Error from compiler
								errorCode "cpl" "ERROR" "${ERROR}"
							fi
							;;
						*)
							;;
					esac
					;;
				#Code is part of a project
				*)
					src=${LangExt}
					TheBinDir=${LangProject}/${project}/bin/
					local TheOldDir=${PWD}
					local Package
					local IsMain
					local TheMain
					local TheJavaSrc
					local TheClassBin
					local TheClassPath
					local ManifestFile=${LangProject}/${project}/META-INF/MANIFEST.MF
					local TheLibDir="${LangProject}/${project}/lib/"
					TheSrcDir="${LangProject}/${project}/src/"
					local ThePWD=${LangProject}/${project}/
					local TheClassDir=${ThePWD}classes/
					local ReplaceTheSrcDir=${LangProject}/${project}/
					ReplaceTheSrcDir=${ReplaceTheSrcDir//\//|}
					local ReplaceTheBinDir=${LangProject}/${project}/classes/
					ReplaceTheBinDir=${ReplaceTheBinDir//\//|}
					local ReplaceTheLibDir=${LangProject}/${project}/
					ReplaceTheLibDir=${ReplaceTheLibDir//\//|}
					local ProjectModeDir
					local UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})

					if [ ! -z "${ProjectMode}" ]; then
						case ${ProjectMode} in
							main|test)
								ProjectModeDir=${TheSrcDir}${ProjectMode}/java/
								;;
							*)
								;;
						esac
					else
						ProjectModeDir=${TheSrcDir}
					fi

					if [ ! -z "${UseProjectTemplate}" ]; then
						ProjectTemplateHandler ${ProjectType} ${Type} ${LangProject}/${project} ${Lang} ${ColorNum} ${TheBinDir}
						local CplBin=$(ProjectTemplateHandler ${ProjectType} ${Type}.status ${project} ${LangProject}/${project} ${TheBinDir})
						if [ ! -z "${CplBin}" ]; then
							UseJava compileCode-message project-mvn ${project}
						fi
					else
						#Compile as jar or class
						case ${UseTypeOfCpl} in
							#Compile as Jar
							--jar)
								cd ${ProjectModeDir}
								UseTypeOfCpl="--class"
								UseJava ${Type} ${name} ${keep} | grep -v "(CLASS)"
								#Compile to Class
								ERROR=$(find ${ThePWD} -name "*.class")
								#Convert Class files to Jar
								if [ ! -z "${ERROR}" ]; then
									#Look for java class containing main
									#{
									local Files=$(find . -name "*${LangExt}")
									for val in ${Files};
									do
										IsMain=$(grep -w "public static void main" ${val})
										if [ ! -z "${IsMain}" ]; then
											TheMain=${val}
											Package=$(grep -w "package" ${TheMain} | head -n 1 | tr -d ';' | sed "s/package //g")
											TheMain=${TheMain##*/}
											break
										fi
									done
									#}

									#Create manifest file
									#{
									echo "Manifest-Version: 1.1" > ${ManifestFile}
									echo "Created-By: $USER" >> ${ManifestFile}
									#format for manifest file
									if [ -d "${TheLibDir}" ]; then
										TheClassPath=$(echo -e "${TheClassPath//;/ }")
										#Class path found
										if [ ! -z "${TheClassPath}" ]; then
											#Add to manifest
											echo "Class-Path: ${TheClassPath}" >> ${ManifestFile}
											fi
										fi
									echo "Package-Names: ${Package}" >> ${ManifestFile}
									echo "Main-Class: ${Package}.${TheMain%${LangExt}}" >> ${ManifestFile}
									echo "Sealed: true" >> ${ManifestFile}
									#}

									#Look for compiled classes
									cd ${TheClassDir}
									TheClassBin=$(find . -name "*.class")
									#package as jar of class found
									if [ ! -z "${TheClassBin}" ]; then
										#TheClassBin=$(ls -d *)
										#cd ${ThePWD}
										#ERROR=$(jar -cfm ${project}.jar ${ManifestFile} -C classes ${TheClassBin} 2>&1 | tr '\n' '|')
										ERROR=$(jar -cfm ${TheBinDir}${project}.jar ${ManifestFile} * 2>&1 | tr '\n' '|')
										#move Java Class to Binary dir
										if [ -z "${ERROR}" ]; then
											rm -rf ${TheClassDir}* 2> /dev/null
											UseJava compileCode-message project-jar ${project}
										else
											#Display Error from compiler
											errorCode "cpl" "ERROR" "${ERROR}"
										fi
									fi
								fi
								cd ${TheOldDir}
								;;
							#compile class
							--class)
								cd ${ProjectModeDir}
								TheJavaSrc=$(find . -name "*${LangExt}")
								if [ ! -z "${TheJavaSrc}" ]; then
									#Compile java code with lib jars
									if [ -d "${TheLibDir}" ]; then
										TheClassPath=$(find ${TheLibDir} -name "*.jar" | grep "${ProjectMode}" | tr '/' '|' | sed "s/${ReplaceTheLibDir}//g" | tr '|' '/' | tr '\n' ';' | rev | sed "s/;//1" | rev)
										#make sure jars exist in lib
										if [ ! -z "${TheClassPath}" ]; then
											ERROR=$(${LangCpl} -cp ".;${TheClassPath}" -d ${TheClassDir} ${TheJavaSrc} 2>&1 | tr '\n' '|')
										#jars don't exist in lib...compile as usual
										else
											ERROR=$(${LangCpl} -d ${TheClassDir} ${TheJavaSrc} 2>&1 | tr '\n' '|')
										fi
									#jars don't exist in lib...compile as usual
									else
										ERROR=$(${LangCpl} -d ${TheClassDir} ${TheJavaSrc} 2>&1 | tr '\n' '|')
									fi
								else
									ERROR="NO Java files found"
								fi

								IsClass=$(find ${ThePWD} -name "*.class")
								#Code Compile from Java
								if [ -z "${ERROR}" ] && [ ! -z "${IsClass}" ]; then
									if [ -f ${TheBinDir}/${project}.jar ]; then
										rm ${TheBinDir}/${project}.jar
									fi
									UseJava compileCode-message project-class ${project}
								else
									#Display Error from compiler
									errorCode "cpl" "ERROR" "${ERROR}"
									rm -rf ${TheClassDir}* 2> /dev/null
								fi
								cd - > /dev/null
								;;
							*)
								if [ -z "${src}" ]; then
									src=${LangExt}
								fi
								UseTypeOfCpl="--jar"
								UseJava ${Type} ${src} ${keep}
								;;
						esac
					fi
					;;
			esac
			;;
		discoverProject)
			echo ${LangProject}
			;;
		newProject)
			local TheProjectType=$1
			local project=$2
			local UseProjectTemplate
			local path=${LangProject}/${project}

			if [ ! -d ${path} ]; then
				UseProjectTemplate=$(ProjectTemplateHandler ${TheProjectType} --check ${Type})
				case ${TheProjectType} in
					${ProjectDefaultType})
						mkdir -p ${path}/lib
						mkdir -p ${path}/classes
						mkdir -p ${path}/META-INF
						mkdir -p ${path}/src
						mkdir -p ${path}/bin
						mkdir -p ${path}/src/main
						mkdir -p ${path}/src/test
						mkdir -p ${path}/src/main/java
						mkdir -p ${path}/src/test/java
						;;
					*)
						if [ ! -z "${UseProjectTemplate}" ]; then
							if [ ! -d ${path}/classes ]; then
								mkdir -p ${path}
							fi
							ProjectTemplateHandler ${TheProjectType} ${Type} ${path}
							#ProjectTemplateHandler "${EnvVars[@]}" ${Type} ${project}
							if [ ! -d ${path}/classes ]; then
								mkdir -p ${path}/classes
							fi
							if [ ! -d ${path}/bin ]; then
								mkdir -p ${path}/bin
							fi
							if [ ! -d ${path}/src ]; then
								mkdir -p ${path}/src
							fi
						else
							mkdir -p ${path}/lib
							mkdir -p ${path}/classes
							mkdir -p ${path}/META-INF
							mkdir -p ${path}/src
							mkdir -p ${path}/bin
							mkdir -p ${path}/src/main
							mkdir -p ${path}/src/test
							mkdir -p ${path}/src/main/java
							mkdir -p ${path}/src/test/java
						fi
						;;
				esac

				cd ${path}
			else
				cd ${path}
			fi
			echo ${path}
			;;
		newPackage)
			local name=$1
			local packagePath=${name//./\/}
			local project=${CodeProject}
			local path=${LangProject}/${project}/src/${ProjectMode}/java/
			local UseProjectTemplate
			case ${project} in
				none)
					;;
				*)
					if [ ! -z "${name}" ]; then
						case ${name} in
							*.new.*|*.this.*|new.*|this.*|*.new|*.this)
								errorCode "package" "not-valid"
								;;
							*)
								cd ${path}
								if [ ! -d ${packagePath} ]; then
									mkdir -p ${packagePath}
								fi
								cd - > /dev/null
								;;
						esac
					fi
					;;
			esac
			;;
		getPackage)
			local src=$1
			local TheFile
			local ThePackage
			local project=${CodeProject}
			local path=${LangProject}/${project}/src/${ProjectMode}/java
			case ${project} in
				none)
					;;
				*)
					if [ ! -z "${src}" ]; then
						src=$(UseJava "removeExt" "${src}")
						TheFile=${src}${LangExt}
						local NumFound=$(find -L ${TheSrcDir} -name ${TheFile} 2> /dev/null | grep "${ProjectMode}" | wc -l)
						case ${NumFound} in
							0)
								;;
							1)
								TheFile=$(find ${TheSrcDir} -name ${TheFile} 2> /dev/null | grep "${ProjectMode}")
								if [ -f ${TheFile} ]; then
									#Read or Write Code
									#{
									ThePackage=$(grep package ${TheFile})
									#}
								fi
								;;
							*)
								local Select
								find ${TheSrcDir} -name ${TheFile} 2> /dev/null | grep "${ProjectMode}" | sed "s/\/${project}\/src\//|/1" | cut -d '|' -f 2 | nl
								echo -n "> "
								read Select
								Select=$(echo ${Select} | grep "^-\?[0-9]*$")
								if [ ! -z "${Select}" ]; then
									if [ ${Select} -le ${NumFound} ] && [ ${Select} -gt 0 ]; then
									TheFile=$(find ${TheSrcDir} -name ${TheFile} 2> /dev/null | grep "${ProjectMode}" | tr '\n' '|' | cut -d '|' -f ${Select})
										#Read or Write Code
										#{
										ThePackage=$(grep package ${TheFile})
										#}
									fi
								fi
								;;
						esac

					fi

					if [ ! -z "${ThePackage}" ]; then
						ThePackage=${ThePackage//package /}
						ThePackage=${ThePackage%%;*}
						echo ${ThePackage}
					fi
					;;
			esac
			;;
		setPackage|isPackage|pathPackage)
			local name=$1
			local packagePath=${name//./\/}
			local project=${CodeProject}
			local path=${LangProject}/${project}/src/${ProjectMode}/java
			case ${project} in
				none)
					;;
				*)
					if [ ! -z "${name}" ]; then
						case ${name} in
							*.new.*|*.this.*|new.*|this.*|*.new|*.this)
								case ${Type} in
									setPackage)
										errorCode "package" "not-valid"
										;;
									*)
										;;
								esac
								;;
							*)
								if [ -d "${path}/${packagePath}" ]; then
									case ${Type} in
										setPackage|pathPackage)
											echo ${path}/${packagePath}
											;;
										isPackage)
											echo "yes"
											;;
										*)
											;;
									esac
								fi
								;;
						esac
					fi
					;;
			esac
			;;
		listPackage)
			local project=${CodeProject}
			local path=${LangProject}/${project}/src/${ProjectMode}/java/
			local RemoveDirs=${path//\//|}
			case ${project} in
				none)
					;;
				*)
					find ${path} -type d | tr '/' '|' | sed "s/${RemoveDirs}//g" | tr '|' '.'
					;;
			esac
			;;
		projectMode)
			local mode=$1
			local UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
			case ${ProjectType} in
				${ProjectDefaultType})
					case ${mode} in
						main|test)
							echo "${mode}"
							;;
						*)
							;;
					esac
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
					path=${LangProject}/${project}/bin/
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
			local ExeString
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
					#Java binary
					if [[ "${bin}" == *"${LangExt}" ]]; then
						#Check for Jar file
						if [ -f "${TheBinDir}/${BinFile}.jar" ]; then
							AddAlias "${BinFile}" "${LangRun} -jar ${TheBinDir}/${BinFile}.jar"
						elif [ -f "${TheBinDir}/${BinFile}.class" ]; then
							errorCode "ERROR"
							errorCode "ERROR" "Please compile as jar file"
							errorCode "HINT" "command"
							errorCode "HINT" "cpl jar"
						else
							errorCode "install" "${bin}"
						fi
					else
						errorCode "noCode"
					fi
					;;
				Install-bin)
					ThePath="/bin"
					#Make sure Binary exists
					if [ -f "${TheBinDir}/${BinFile}.jar" ]; then
						ExeString=$(UseJava "exe-string" ${bin})
						if [ -f ${ThePath}/${BinFile} ]; then
							errorCode "install" "already" "${BinFile}" "${ThePath}/"
						else
							case ${USER} in
								root)
									touch ${ThePath}/${BinFile}
									echo -e "#!/bin/bash\n${ExeString}" > ${BinFile}
									mv ${BinFile} ${ThePath}/${BinFile}
									chmod +x ${ThePath}/${BinFile}
									;;
								*)
									sudo touch ${ThePath}/${BinFile}
									echo -e "#!/bin/bash\n${ExeString}" > ${BinFile}
									sudo mv ${BinFile} ${ThePath}/${BinFile}
									sudo chmod +x ${ThePath}/${BinFile}
									;;
							esac
						fi
					elif [ ! -f "${TheBinDir}/${BinFile}.jar" ]; then
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
				Install-root)
					ThePath="/usr/sbin"
					#Make sure Binary exists
					if [ -f "${TheBinDir}/${BinFile}.jar" ]; then
						ExeString=$(UseJava "exe-string" ${bin})
						if [ -f ${ThePath}/${BinFile} ]; then
							errorCode "install" "already" "${BinFile}" "${ThePath}/"
						else
							case ${USER} in
								root)
									touch ${ThePath}/${BinFile}
									echo -e "#!/bin/bash\n${ExeString}" > ${BinFile}
									mv ${BinFile} ${ThePath}/${BinFile}
									chmod +x ${ThePath}/${BinFile}
									;;
								*)
									touch ${ThePath}/${BinFile}
									echo -e "#!/bin/bash\n${ExeString}" > ${BinFile}
									sudo mv ${BinFile} ${ThePath}/${BinFile}
									sudo chmod +x ${ThePath}/${BinFile}
									;;
							esac
						fi
					elif [ ! -f "${TheBinDir}/${BinFile}.jar" ]; then
						#compile or swap to binary
						errorCode "install" "${BinFile}"
					else
						errorCode "noCode"
					fi
					;;
				Install-user)
					ThePath="~/bin"
					#Make sure Binary exists
					if [ -f "${TheBinDir}/${BinFile}.jar" ]; then
						ExeString=$(UseJava "exe-string" ${bin})
						if [ -f ${ThePath}/${BinFile} ]; then
							errorCode "install" "already" "${BinFile}" "${ThePath}/"
						else
							if [ -d ${ThePath} ]; then
								touch ${ThePath}/${BinFile}
								echo -e "#!/bin/bash\n${ExeString}" > ${BinFile}
								mv ${BinFile} ${ThePath}/${BinFile}
								chmod +x ${ThePath}/${BinFile}
							else
								errorCode "ERROR"
								errorCode "ERROR" "${ThePath}/ does not exist"
							fi
						fi
					elif [ ! -f "${TheBinDir}/${BinFile}.jar" ]; then
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
					TheBinDir="${LangProject}/${project}/bin"
					;;
			esac
			#Java binary
			case ${bin} in
				*"${LangExt}")
					#Check for Jar file
					if [ -f "${TheBinDir}/${BinFile}.jar" ]; then
						echo "${LangRun} -jar ${TheBinDir}/${BinFile}.jar"
					fi
					;;
				*)
					;;
			esac
			;;
		customCode)
			local cLang=$(UseJava "color")
			local TemplateC=${TemplateCodeClass##*/}
			TemplateC=${TemplateC%.*}
			local TemplateJ=${TemplateCodeJar##*/}
			local cTemplateC=$(OtherColor ${TemplateC})
			local cTemplateJ=$(OtherColor ${TemplateJ})
			Type=${Type,,}
			#Check for Custom Code Template...is class
			if [ -f ${TemplateCodeClass} ]; then
				shift
				shift
				shift
				shift
				Args=( "${@}" )
				if [ -z "${1}" ]; then
					echo -n "${cLang}\$ java ${cTemplateC} "
					read -a Args
				fi

				#Program Args Given
				if [ ! -z "${Args}" ]; then
					cd ${LangBin}
					${LangRun} ${TemplateC} "${Args[@]}"
					cd - > /dev/null
					mv "${LangBin}/*${LangExt}" . 2> /dev/null
				else
					cd ${LangBin}
					${LangRun} ${TemplateC} --help
					cd - > /dev/null
				fi
			#Check for Custom Code Template...is jar
			elif [ -f ${TemplateCodeJar} ]; then
				shift
				shift
				shift
				shift
				Args=( "${@}" )
				if [ -z "${1}" ]; then
					echo -n "${cLang}\$ java -jar ${cTemplateJ} "
					read -a Args
				fi

				#Program Args Given
				if [ ! -z "${Args}" ]; then
					${LangRun} -jar ${TemplateCodeJar} "${Args[@]}"
				#No Program Name Given
				else
					${LangRun} -jar ${TemplateCodeJar} --help
				fi
			else
				#Program Name Given
				errorCode "customCode" "notemp" "${Lang}"
			fi
			;;
		customCodeShow)
			local cLang=$(UseJava "color")
			local TemplateC=${TemplateCodeClass##*/}
			TemplateC=${TemplateC%.*}
			local TemplateJ=${TemplateCodeJar##*/}
			local cTemplateC=$(OtherColor ${TemplateC})
			local cTemplateJ=$(OtherColor ${TemplateJ})
			Type=${Type,,}
			#Check for Custom Code Template...is class
			if [ -f ${TemplateCodeClass} ]; then
				shift
				shift
				shift
				shift
				Args=( "${@}" )
				if [ -z "${1}" ]; then
					echo -n "${cLang}\$ java ${cTemplateC} --no-save "
					read -a Args
				fi

				#Program Args Given
				if [ ! -z "${Args}" ]; then
					cd ${LangBin}
					${LangRun} ${TemplateC} --no-save "${Args[@]}"
					cd - > /dev/null
					mv "${LangBin}/*${LangExt}" . 2> /dev/null
				else
					cd ${LangBin}
					${LangRun} ${TemplateC} --help
					cd - > /dev/null
				fi
			#Check for Custom Code Template...is jar
			elif [ -f ${TemplateCodeJar} ]; then
				shift
				shift
				shift
				shift
				Args=( "${@}" )
				if [ -z "${1}" ]; then
					echo -n "${cLang}\$ java -jar ${cTemplateJ} --no-save "
					read -a Args
				fi

				#Program Args Given
				if [ ! -z "${Args}" ]; then
					${LangRun} -jar ${TemplateCodeJar} --no-save "${Args[@]}"
				#No Program Name Given
				else
					${LangRun} -jar ${TemplateCodeJar} --help
				fi
			else
				#Program Name Given
				errorCode "customCode" "notemp" "${Lang}"
			fi
			;;
		#Create new code
		newCode)
			local name=$1
			local CodeType=$2
			local oldCode=$3
			local project=${CodeProject}
			local newName
			local DirPath
			local PackageName
			local PackageNameJava
			local Content
			local UseProjectTemplate
			local TemplateC=${TemplateCodeClass##*/}
			TemplateC=${TemplateC%.*}

			#Sometimes "oldCode" gets passed as "CodeType"
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
			name=$(UseJava "removeExt" "${name}")
			local TheSrcDir

			#Program Name Given
			if [ ! -z "${name}" ]; then
				#source file does not exist
				if [ ! -f ${TheSrcDir}${name}${LangExt} ]; then
					#Determine if project
					case ${project} in
						#not a project
						none)
							;;
						#Handle Project Specific code
						*)
							UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
							PackageName=$(echo ${PWD}/ | sed "s/${project}\/src/|/g" | cut -d '|' -f 2 | sed "s/\/main\/java\///1" | sed "s/\/test\/java\///1")
							if [ ! -z "${PackageName}" ]; then
								PackageName=${PackageName//\//.}
								PackageName=${PackageName#.}
								PackageName=${PackageName%*.}
								PackageNameJava="--package ${PackageName}"
							fi
							;;
					esac
						#Check for Custom Code Template...is class
						if [ -f ${TemplateCodeClass} ]; then
							case ${CodeType} in
								#create main file
								main)
									if [ -z "${UseProjectTemplate}" ]; then
										#echo "main"
										cd ${LangBin}
										${LangRun} ${TemplateC} --name ${name} --main ${TemplateCodeArgs} ${PackageNameJava}
										cd - > /dev/null
										mv "${LangBin}/${name}${LangExt}" .
									else
										ProjectTemplateHandler ${ProjectType} ${Type} ${name}${LangExt} ${CodeType}
									fi
									;;
								#create component file
								component)
									if [ -z "${UseProjectTemplate}" ]; then
										#echo "component"
										cd ${LangBin}
										${LangRun} ${TemplateC} --name ${name} ${TemplateCodeArgs} ${PackageNameJava}
										cd - > /dev/null
										mv "${LangBin}/${name}${LangExt}" . 2> /dev/null
									else
										ProjectTemplateHandler ${ProjectType} ${Type} ${name}${LangExt} ${CodeType}
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
											case ${oldCode} in
												#main class already created
												*"${LangExt}")
													#Create libary class
													UseJava "newCode" ${name} "component" ${oldCode}
													;;
												*)
													#Create new main code
													UseJava "newCode" ${name} "main" ${oldCode}
													;;
											esac
											;;
										#Is a project
										*)
											case ${PWD} in
												*"/main/java"*|*"/test/java"*)
													case ${PWD} in
														*"/main/java"|*"/test/java")
															errorCode "newCode" "need-package"
															;;
														*)
															#Because a project can have source code scattered in different directories,
															#make sure you have one main component
															local TheSrcDir="${LangProject}/${project}/src/"
															local NumFound=$(find -L ${TheSrcDir} -type f -name "*${LangExt}" 2> /dev/null | wc -l)
															case ${NumFound} in
																#No other source code was found...make your main file
																0)
																	#Create new main code
																	UseJava "newCode" ${name} "main" ${oldCode}
																	;;
																#Source code was found...make a component
																*)
																	#Create libary class
																	UseJava "newCode" ${name} "component" ${oldCode}
																	;;
															esac
															;;
													esac
													;;
												*)
													errorCode "newCode" "choose-dir"
													;;
											esac
											;;
									esac
									;;
							esac
						#Check for Custom Code Template...is jar
						elif [ -f ${TemplateCodeJar} ]; then
							case ${CodeType} in
								#create main file
								main)
									if [ -z "${UseProjectTemplate}" ]; then
										#echo "main"
										${LangRun} -jar ${TemplateCodeJar} --name ${name} --main ${TemplateCodeArgs} ${PackageNameJava}
									else
										ProjectTemplateHandler ${ProjectType} ${Type} ${name}${LangExt} ${CodeType}
									fi
									;;
								#create component file
								component)
									if [ -z "${UseProjectTemplate}" ]; then
										#echo "component"
										${LangRun} -jar ${TemplateCodeJar} --name ${name} ${TemplateCodeArgs} ${PackageNameJava}
									else
										ProjectTemplateHandler ${ProjectType} ${Type} ${name}${LangExt} ${CodeType}
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
											case ${oldCode} in
												#main class already created
												*"${LangExt}")
													#Create libary class
													UseJava "newCode" ${name} "component" ${oldCode}
													;;
												*)
													#Create new main code
													UseJava "newCode" ${name} "main" ${oldCode}
													;;
											esac
											;;
										#Is a project
										*)
											case ${PWD} in
												*"/main/java"*|*"/test/java"*)
													case ${PWD} in
														*"/main/java"|*"/test/java")
															errorCode "newCode" "need-package"
															;;
														*)
															#Because a project can have source code scattered in different directories,
															#make sure you have one main component
															local TheSrcDir="${LangProject}/${project}/src/"
															local NumFound=$(find -L ${TheSrcDir} -type f -name "*${LangExt}" 2> /dev/null | wc -l)
															case ${NumFound} in
																#No other source code was found...make your main file
																0)
																	#Create new main code
																	UseJava "newCode" ${name} "main" ${oldCode}
																	;;
																#Source code was found...make a component
																*)
																	#Create libary class
																	UseJava "newCode" ${name} "component" ${oldCode}
																	;;
															esac
															;;
													esac
													;;
												*)
													errorCode "newCode" "choose-dir"
													;;
											esac
											;;
									esac
									;;
							esac
						#No Template Program
						else
							#Determine if project
							case ${project} in
								#not a project
								none)
									Content="//class path goes here\n\n/**\n *\n * @author $USER\n */\n\n//class name\npublic class ${name} {\n\n\t/**\n\t* @param args the command line arguments\n\t*/\n\tpublic static void main(String[] args) {\n\n\t}\n}"
									touch ${name}${LangExt}
									echo -e "${Content}" > ${name}${LangExt}
									;;
								#Handle Project Specific code
								*)
									case ${PWD} in
										*"/main/java"*|*"/test/java"*)
											if [ ! -z "${PackageName}" ]; then
												Content="package ${PackageName};\n\n/**\n *\n * @author $USER\n */\n\n//class name\npublic class ${name} {\n\n\t/**\n\t* @param args the command line arguments\n\t*/\n\tpublic static void main(String[] args) {\n\n\t}\n}"
											else
												Content="//class path goes here\n\n/**\n *\n * @author $USER\n */\n\n//class name\npublic class ${name} {\n\n\t/**\n\t* @param args the command line arguments\n\t*/\n\tpublic static void main(String[] args) {\n\n\t}\n}"
											fi
											touch ${name}${LangExt}
											echo -e "${Content}" > ${name}${LangExt}
											;;
										*)
											;;
									esac
									;;
							esac
						fi
				fi
			#No Program Name Given
			else
				if [ -z "${UseProjectTemplate}" ]; then
					#Check for Custom Code Template...is class
					if [ -f ${TemplateCodeClass} ]; then
						cd ${LangBin}
						${LangRun} ${TemplateC} --help
						cd - > /dev/null
					#Check for Custom Code Template...is jar
					elif [ -f ${TemplateCodeJar} ]; then
						${LangRun} -jar ${TemplateCodeJar} --help
					else
						errorCode "newCode"
					fi
				else
					ProjectTemplateHandler ${ProjectType} ${Type} ${name}${LangExt} ${CodeType}
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
			TheName=${TheName%.*}
			local TheBin="${TheName}"
			local TheJar="${TheName}.jar"
			local JavaProp=$2
			if [ ! -z "${JavaProp}" ]; then
				#Its a Class
				if [ -f ${LangBin}/${TheBin}.class ]; then
					TheName=$(OtherColor ${TheBin})
					echo "java ${JavaProp} ${TheName}"
				#Its a Jar
				elif [ -f ${LangBin}/${TheJar} ]; then
					TheName=$(OtherColor ${TheJar})
					echo "java -jar ${TheName}"
				fi
			else
				#Its a Class
				if [ -f ${LangBin}/${TheBin}.class ]; then
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
				if [ -z "${LangRunProp}" ]; then
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
				elif [[ "${LangRunProp}" == "-D"*"=\""*"\"" ]]; then
					JavaProp=${LangRunProp}
				else
					JavaProp=""
				fi
			fi
			;;
		runCode|debug)
			local name=$1
			local TheBin
			local TheJar
			local project=${CodeProject}
			local package
			local TheClassDir
			local TheJarDir
			local JavaProp=$2
			local UseProjectTemplate
			shift
			shift
			local Args=( "${@}" )

			#Run Compiled Code
			if [ ! -z "${name}" ]; then
				case ${project} in
					none)
						#Handle multiple files
						if [[ "${name}" == *","* ]]; then
							cd ${LangSrc}
							name=${name//,/ }
							name=$(grep -l "public static void main" ${name})
							if [ ! -z "${name}" ]; then
								TheBin=$(UseJava "removeExt" "${name}")
								TheBin="${TheBin}.class"
								TheJar=$(UseJava "removeExt" "${name}")
								TheJar="${TheJar}.jar"
							fi
							cd - > /dev/null
						else
							TheBin=$(UseJava "removeExt" "${name}")
							TheBin="${TheBin}.class"
							TheJar=$(UseJava "removeExt" "${name}")
							TheJar="${TheJar}.jar"
						fi
						project=""
						TheClassDir=${LangBin}/
						TheJarDir=${LangBin}
						;;
					*)
						if [ ! -z "${RunType}" ]; then
							UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type}.${RunType})
						else
							UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
						fi
						TheJar="${project}.jar"
						TheClassDir=${LangProject}/${project}/classes/
						package=$(find ${TheClassDir} -name "*.class")
						if [ ! -z "${package}" ]; then
							package="${package%${TheBin}}"
							package="${package#${TheClassDir}}"
						fi
						TheJarDir="${LangProject}/${project}/bin"
						;;
				esac

				#Check if Java Class exists
				if [ -f ${TheClassDir}${package}${TheBin} ]; then
					TheBin=${TheBin%.*}
					cd ${TheClassDir}
					package=$(echo -e "${package//\//.}")

					#If no JavaProp found
					case ${JavaProp} in
						none)
							case ${Type} in
								debug)
									if [ -z "${Args[0]}" ]; then
										echo "${UseDebugger} ${package}${TheBin}"
									else
										echo "${UseDebugger} ${package}${TheBin} ${Args[@]}"
									fi
									;;
								runCode)
									#Execute without
									if [ ! -z "${ThePipe}" ]; then
										if [ ! -z "${TimeRun}" ]; then
											if [ -f "${MultiPipeFile}" ]; then
												if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														time cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin}
													else
														time cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin} "${Args[@]}"
													fi
												elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														time cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin}
													else
														time cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin} "${Args[@]}"
													fi
												else
													if [ -z "${Args[0]}" ]; then
														time cat ${MultiPipeFile} | ${LangRun} ${package}${TheBin}
													else
														time cat ${MultiPipeFile} | ${LangRun} ${package}${TheBin} "${Args[@]}"
													fi
												fi
											else
												if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														time cat /dev/stdin | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin}
													else
														time cat /dev/stdin | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin} "${Args[@]}"
													fi
												elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														time cat /dev/stdin | ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin}
													else
														time cat /dev/stdin | ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin} "${Args[@]}"
													fi
												else
													if [ -z "${Args[0]}" ]; then
														time cat /dev/stdin | ${LangRun} ${package}${TheBin}
													else
														time cat /dev/stdin | ${LangRun} ${package}${TheBin} "${Args[@]}"
													fi
												fi
											fi
										else
											if [ -f "${MultiPipeFile}" ]; then
												if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin}
													else
														cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin} "${Args[@]}"
													fi
												elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin}
													else
														cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin} "${Args[@]}"
													fi
												else
													if [ -z "${Args[0]}" ]; then
														cat ${MultiPipeFile} | ${LangRun} ${package}${TheBin}
													else
														cat ${MultiPipeFile} | ${LangRun} ${package}${TheBin} "${Args[@]}"
													fi
												fi
											else
												if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														cat /dev/stdin | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin}
													else
														cat /dev/stdin | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin} "${Args[@]}"
													fi
												elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														cat /dev/stdin | ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin}
													else
														cat /dev/stdin | ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin} "${Args[@]}"
													fi
												else
													if [ -z "${Args[0]}" ]; then
														cat /dev/stdin | ${LangRun} ${package}${TheBin}
													else
														cat /dev/stdin | ${LangRun} ${package}${TheBin} "${Args[@]}"
													fi
												fi
											fi
										fi
									else
										if [ ! -z "${TimeRun}" ]; then
											if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
												if [ -z "${Args[0]}" ]; then
													time ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin}
												else
													time ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin} "${Args[@]}"
												fi
											elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
												if [ -z "${Args[0]}" ]; then
													time ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin}
												else
													time ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin} "${Args[@]}"
												fi
											else
												if [ -z "${Args[0]}" ]; then
													time ${LangRun} ${package}${TheBin}
												else
													time ${LangRun} ${package}${TheBin} "${Args[@]}"
												fi
											fi
										else
											if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
												if [ -z "${Args[0]}" ]; then
													ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin}
												else
													ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin} "${Args[@]}"
												fi
											elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
												if [ -z "${Args[0]}" ]; then
													ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin}
												else
													ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin} "${Args[@]}"
												fi
											else
												if [ -z "${Args[0]}" ]; then
													${LangRun} ${package}${TheBin}
												else
													${LangRun} ${package}${TheBin} "${Args[@]}"
												fi
											fi
										fi
									fi
									;;
								*)
									;;
							esac
							;;
						*)
							case ${Type} in
								debug)
									if [ -z "${Args[0]}" ]; then
										${UseDebugger} "${JavaProp}" ${package}${TheBin}
									else
										${UseDebugger} "${JavaProp}" ${package}${TheBin} "${Args[@]}"
									fi
									;;
								runCode)
									#Execute without
									if [ ! -z "${ThePipe}" ]; then
										if [ ! -z "${TimeRun}" ]; then
											if [ -f "${MultiPipeFile}" ]; then
												if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														time cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin}
													else
														time cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin} "${Args[@]}"
													fi
												elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														time cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} runCode --class
													else
														time cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} runCode --class "${Args[@]}"
													fi
												else
													if [ -z "${Args[0]}" ]; then
														time cat ${MultiPipeFile} | ${LangRun} "${JavaProp}" ${package}${TheBin}
													else
														time cat ${MultiPipeFile} | ${LangRun} "${JavaProp}" ${package}${TheBin} "${Args[@]}"
													fi
												fi
											else
												if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														time cat /dev/stdin | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin}
													else
														time cat /dev/stdin | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin} "${Args[@]}"
													fi
												elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														time cat /dev/stdin | ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin}
													else
														time cat /dev/stdin | ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin} "${Args[@]}"
													fi
												else
													if [ -z "${Args[0]}" ]; then
														time cat /dev/stdin | ${LangRun} "${JavaProp}" ${package}${TheBin}
													else
														time cat /dev/stdin | ${LangRun} "${JavaProp}" ${package}${TheBin} "${Args[@]}"
													fi
												fi
											fi
										else
											if [ -f "${MultiPipeFile}" ]; then
												if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin}
													else
														cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin} "${Args[@]}"
													fi
												elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin}
													else
														cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin} "${Args[@]}"
													fi
												else
													if [ -z "${Args[0]}" ]; then
														cat ${MultiPipeFile} | ${LangRun} "${JavaProp}" ${package}${TheBin}
													else
														cat ${MultiPipeFile} | ${LangRun} "${JavaProp}" ${package}${TheBin} "${Args[@]}"
													fi
												fi
											else
												if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														cat /dev/stdin | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin}
													else
														cat /dev/stdin | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin} "${Args[@]}"
													fi
												elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
													if [ -z "${Args[0]}" ]; then
														cat /dev/stdin | ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin}
													else
														cat /dev/stdin | ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin} "${Args[@]}"
													fi
												else
													if [ -z "${Args[0]}" ]; then
														cat /dev/stdin | ${LangRun} "${JavaProp}" ${package}${TheBin}
													else
														cat /dev/stdin | ${LangRun} "${JavaProp}" ${package}${TheBin} "${Args[@]}"
													fi
												fi
											fi
										fi
									else
										if [ ! -z "${TimeRun}" ]; then
											if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
												if [ -z "${Args[0]}" ]; then
													time ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin}
												else
													time ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin} "${Args[@]}"
												fi
											elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
												if [ -z "${Args[0]}" ]; then
													time ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin}
												else
													time ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin} "${Args[@]}"
												fi
										else
												if [ -z "${Args[0]}" ]; then
													time ${LangRun} "${JavaProp}" ${package}${TheBin}
												else
													time ${LangRun} "${JavaProp}" ${package}${TheBin} "${Args[@]}"
												fi
											fi
										else
											if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
												if [ -z "${Args[0]}" ]; then
													ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin}
												else
													ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${package}${TheBin} "${Args[@]}"
												fi
											elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
												if [ -z "${Args[0]}" ]; then
													ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin}
												else
													ProjectTemplateHandler ${ProjectType} runCode ${package}${TheBin} "${Args[@]}"
												fi
											else
												if [ -z "${Args[0]}" ]; then
													${LangRun} "${JavaProp}" ${package}${TheBin}
												else
													${LangRun} "${JavaProp}" ${package}${TheBin} "${Args[@]}"
												fi
											fi
										fi
									fi
									;;
								*)
									;;
							esac
							;;
					esac
					cd - > /dev/null
				#Check if Java Jar exists
				elif [ -f ${TheJarDir}/${TheJar} ]; then
					if [ ! -z "${ThePipe}" ]; then
						if [ ! -z "${TimeRun}" ]; then
							if [ -f "${MultiPipeFile}" ]; then
								if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
									if [ -z "${Args[0]}" ]; then
										time cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${TheJarDir}/${TheJar}
									else
										time cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${TheJarDir}/${TheJar} "${Args[@]}"
									fi
								elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
									if [ -z "${Args[0]}" ]; then
										time cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} runCode  ${TheJarDir}/${TheJar}
									else
										time cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} runCode  ${TheJarDir}/${TheJar} "${Args[@]}"
									fi
								else
									if [ -z "${Args[0]}" ]; then
										time cat ${MultiPipeFile} | ${LangRun} -jar ${TheJarDir}/${TheJar}
									else
										time cat ${MultiPipeFile} | ${LangRun} -jar ${TheJarDir}/${TheJar} "${Args[@]}"
									fi
								fi
							else
								if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
									if [ -z "${Args[0]}" ]; then
										time cat /dev/stdin | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${TheJarDir}/${TheJar}
									else
										time cat /dev/stdin | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${TheJarDir}/${TheJar} "${Args[@]}"
									fi
								elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
									if [ -z "${Args[0]}" ]; then
										time cat /dev/stdin | ProjectTemplateHandler ${ProjectType} runCode ${TheJarDir}/${TheJar}
									else
										time cat /dev/stdin | ProjectTemplateHandler ${ProjectType} runCode ${TheJarDir}/${TheJar} "${Args[@]}"
									fi
								else
									if [ -z "${Args[0]}" ]; then
										time cat /dev/stdin | ${LangRun} -jar ${TheJarDir}/${TheJar}
									else
										time cat /dev/stdin | ${LangRun} -jar ${TheJarDir}/${TheJar} "${Args[@]}"
									fi
								fi
							fi
						else
							if [ -f "${MultiPipeFile}" ]; then
								if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
									if [ -z "${Args[0]}" ]; then
										cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${TheJarDir}/${TheJar}
									else
										cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${TheJarDir}/${TheJar} "${Args[@]}"
									fi
								elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
									if [ -z "${Args[0]}" ]; then
										cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} runCode ${TheJarDir}/${TheJar}
									else
										cat ${MultiPipeFile} | ProjectTemplateHandler ${ProjectType} runCode ${TheJarDir}/${TheJar} "${Args[@]}"
									fi
								else
									if [ -z "${Args[0]}" ]; then
										cat ${MultiPipeFile} | ${LangRun} -jar ${TheJarDir}/${TheJar}
									else
										cat ${MultiPipeFile} | ${LangRun} -jar ${TheJarDir}/${TheJar} "${Args[@]}"
									fi
								fi
							else
								if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
									if [ -z "${Args[0]}" ]; then
										cat /dev/stdin | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${TheJarDir}/${TheJar}
									else
										cat /dev/stdin | ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${TheJarDir}/${TheJar} "${Args[@]}"
									fi
								elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
									if [ -z "${Args[0]}" ]; then
										cat /dev/stdin | ProjectTemplateHandler ${ProjectType} runCode ${TheJarDir}/${TheJar}
									else
										cat /dev/stdin | ProjectTemplateHandler ${ProjectType} runCode ${TheJarDir}/${TheJar} "${Args[@]}"
									fi
								else
									if [ -z "${Args[0]}" ]; then
										cat /dev/stdin | ${LangRun} -jar ${TheJarDir}/${TheJar}
									else
										cat /dev/stdin | ${LangRun} -jar ${TheJarDir}/${TheJar} "${Args[@]}"
									fi
								fi
							fi
						fi
					else
						if [ ! -z "${TimeRun}" ]; then
							if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
								if [ -z "${Args[0]}" ]; then
									time ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${TheJarDir}/${TheJar}
								else
									time ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${TheJarDir}/${TheJar} "${Args[@]}"
								fi
							elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
								if [ -z "${Args[0]}" ]; then
									time ProjectTemplateHandler ${ProjectType} runCode ${TheJarDir}/${TheJar}
								else
									time ProjectTemplateHandler ${ProjectType} runCode ${TheJarDir}/${TheJar} "${Args[@]}"
								fi
							else
								if [ -z "${Args[0]}" ]; then
									time ${LangRun} -jar ${TheJarDir}/${TheJar}
								else
									time ${LangRun} -jar ${TheJarDir}/${TheJar} "${Args[@]}"
								fi
							fi
						else
							if [ ! -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
								if [ -z "${Args[0]}" ]; then
									ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${TheJarDir}/${TheJar}
								else
									ProjectTemplateHandler ${ProjectType} ${Type}.${RunType} ${TheJarDir}/${TheJar} "${Args[@]}"
								fi
							elif [ -z "${RunType}" ] && [ ! -z "${UseProjectTemplate}" ]; then
								if [ -z "${Args[0]}" ]; then
									ProjectTemplateHandler ${ProjectType} runCode ${TheJarDir}/${TheJar}
								else
									ProjectTemplateHandler ${ProjectType} runCode ${TheJarDir}/${TheJar} "${Args[@]}"
								fi
							else
								if [ -z "${Args[0]}" ]; then
									${TimeRun} ${LangRun} -jar ${TheJarDir}/${TheJar}
								else
									${TimeRun} ${LangRun} -jar ${TheJarDir}/${TheJar} "${Args[@]}"
								fi
							fi
						fi
					fi
				else
					errorCode "cpl" "need" "${name}"
				fi
			else
				echo "Unable to locate executable"
			fi
			;;
		backup|backup-remove|restore)
			local name=$1
			name=$(UseJava "removeExt" "${name}")
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
					case ${Type} in
						restore)
							if [ -f "${name}.bak" ]; then
								mv ${name}.bak ${name}
								echo "\"${name}\" restored"
							else
								TheCount=$(UseJava "getProjSrc" "${name}.bak" | wc -l)
								case ${TheCount} in
									0)
										errorCode "restore" "null"
										;;
									1)
										TheFound=$(UseJava "getProjSrc" "${name}.bak")
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
								TheCount=$(UseJava "getProjSrc" "${name}" | wc -l)
								case ${TheCount} in
									0)
										errorCode "backup" "null"
										;;
									1)
										TheFound=$(UseJava "getProjSrc" "${name}")
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
								TheCount=$(UseJava "getProjSrc" "${name}" | wc -l)
								case ${TheCount} in
									0)
										errorCode "backup" "null"
										;;
									1)
										TheFound=$(UseJava "getProjSrc" "${name}")
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
		copy|rename)
			local Src=$1
			local New=$2
			local TheOld
			local TheNew
			local ReplaceTheOld
			local WithTheNew
			local project=${CodeProject}
			case ${project} in
				none)
					if [ ! -z "${New}" ]; then
						TheOld=$(UseJava "removeExt" ${Src})
						TheNew=$(UseJava "removeExt" ${New})

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
						sed -i "s/${TheOld}/${TheNew}/g" ${LangSrc}/${TheNew}${LangExt}

						#return new file
						echo ${TheNew}${LangExt}
					fi
					;;
				*)
					#Check if extenion is given
					local HasAnExt
					local CheckForSrc
					local ThePath
					local TheSrcPath
					local LocalSrc

					TheOld=$(UseJava "removeExt" ${Src})
					TheOld="${TheOld}${LangExt}"
					New=$(UseJava "removeExt" ${New})
					TheNew="${New}${LangExt}"

					if [ ! -z "${TheOld}" ] && [ ! -z "${TheNew}" ]; then
						TheSrcPath=$(UseJava "getProjSrc" ${TheOld})
						TheSrcPath=${TheSrcPath%/*}
						ReplaceTheOld=$(UseJava "removeExt" ${TheOld})
						WithTheNew=$(UseJava "removeExt" ${TheNew})
						case ${Type} in
							rename)
								LocalSrc=$(UseJava "getAllProjSrc")
								for TheSrc in ${LocalSrc};
								do
									case ${TheSrc} in
										${TheSrcPath}/${TheOld})
											;;
										*)
											sed -i "s/${ReplaceTheOld}/${WithTheNew}/g" ${TheSrc} 2> /dev/null
											;;
									esac
								done
								mv ${TheSrcPath}/${TheOld} ${TheSrcPath}/${TheNew} 2> /dev/null
								;;
							copy)
								cp ${TheSrcPath}/${TheOld} ${TheSrcPath}/${TheNew} 2> /dev/null
								;;
							*)
								;;
						esac
						sed -i "s/${ReplaceTheOld}/${WithTheNew}/g" ${TheSrcPath}/${TheNew} 2> /dev/null
						echo ${TheNew}
					fi
					;;
			esac
			;;
		*)
			;;
	esac
}

UseJava "${@}"
