Shell=$(which bash)
#!${Shell}

SupportV="0.1.57"
Lang=Java
LangExt=".java"
ColorNum=1

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
ProjectMode=$1
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

UseJava()
{
	local LookForLang="Use(${Lang})"
	local LangConfig=$(grep "${LookForLang}" ${VarDir}/clide.conf | sed "s/${LookForLang}=//1")
	local LangCpl=$(echo ${LangConfig} | cut -d ',' -f 1)
	local LangRun=$(echo ${LangConfig} | cut -d ',' -f 2)

	local LangHome=${ProgDir}/${Lang}
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local LangProject=${LangHome}/projects

	local NewLangSrc="New(${Lang})"
	local TemplateCode=$(grep "${NewLangSrc}" ${VarDir}/clide.conf | sed "s/${NewLangSrc}=//1")
	TemplateCode=${TemplateCode%.class}
	TemplateCode=${TemplateCode%.jar}
	TemplateCode=${TemplateCode%${LangExt}}

	local TemplateCodeClass=${LangBin}/${TemplateCode}.class
	local TemplateCodeJar=${LangBin}/${TemplateCode}.jar

	local EnvVars=( ${LangRun} ${LangHome} ${LangSrc} ${LangBin} ${LangExt} )
	local Type=$1
	shift
	case ${Type} in
		color)
			#Return Red
			echo -e "\e[1;3${ColorNum}m${Lang}\e[0m"
			;;
		ProjectColor)
			echo -e "\e[1;4${ColorNum}m${CodeProject}\e[0m"
			;;
		getExt)
			echo ${LangExt}
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
		ProjectHelp)
			echo ""
			echo -e "${Lang} specific project help"
			echo ""
			;;
		getProjectDir)
			local project=${CodeProject}
			echo ${LangProject}/${project}
			;;
		getCode)
			local name=$1
			name=${name%${LangExt}}
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
						Generic)
							case ${name} in
								*.*)
									newName=${name##*.}
									DirPath=$(echo ${name%${newName}} | tr '.' '/')
									PackageName=$(echo ${name%.*} | sed "s/${ProjectMode}.java.//1" | tr '/' '.')
									TheSrcDir="${LangProject}/${project}/src/${DirPath}"
									;;
								*/*)
									newName=${name##*/}
									PackageName=$(echo ${name%/*} | sed "s/${ProjectMode}\/java\///1" | tr '/' '.')
									DirPath=${name%${newName}}
									TheSrcDir="${LangProject}/${project}/src/${DirPath}"
									;;
								*)
									PackageName=$(pwd | sed "s/${project}\/src/|/g" | sed "s/${ProjectMode}\/java\///1" | cut -d '|' -f 2 | tr '/' '.')
									TheSrcDir="$(pwd)/"
									newName=${name}
									;;
							esac
							if [ -f ${TheSrcDir}${newName}${LangExt} ]; then
								echo ${name}${LangExt}
							fi
							;;
						*)
							ProjectTemplateHandler ${EnvVars[@]} ${Type} ${mode}
							;;
					esac
					;;
			esac
			;;
		pgLang)
			local HasLangCpl=$(which ${LangCpl} 2> /dev/null)
			local HasLangRun=$(which ${LangRun} 2> /dev/null)
			if [ ! -z "${HasLangCpl}" ] && [ ! -z "${HasLangRun}" ]; then
				#Return Java tag
				echo "${Lang}"
			else
				#Return rejection
				echo "no"
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
			echo -e "prop, properties, -D\t: create custome ${Lang} properties"
			echo -e "jar, manifest\t\t: create ${Lang} Manifest Jar builds"
			;;
		shell)
			;;
		newCodeHelp)
			if [ -f ${TemplateCodeJar} ] || [ -f ${TemplateCodeClass} ]; then
				echo -e "--custom|-c\t\t\t: \"Custom src file using ${Lang} template\""
			fi
			;;
		EnsureDirs)
			if [ ! -z "${LangCpl}" ] && [ ! -z "${LangRun}" ]; then

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
			if [ -f ${TemplateCodeJar} ]; then
                                echo -n "${TemplateCodeJar##*/} : "
				java -jar ${TemplateCodeJar} 2> /dev/null | grep Version | sed "s/Version: //g"
			else
				echo "no ${TemplateCodeJar##*/} found"
			fi
                        ;;
		CplVersion)
			echo "[${Lang} JDK/JRE]"
			local LangRunVersion=$(${LangRun} --version 2> /dev/null)
			local LangCplVersion=$(${LangCpl} --version 2> /dev/null)
			if [ ! -z "${LangRunVersion}" ]; then
				LangRunVersion=$(${LangRun} --version | head -n 1)
				LangCplVersion=$(${LangCpl} --version | head -n 1)
				echo "${LangRunVersion}"
				echo "${LangCplVersion}"
			else
				${LangRun} -version
				${LangCpl} -version
			fi
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
				name=${name%${LangExt}}${LangExt}
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
								new=${new%${LangExt}}${LangExt}
								LookFor=${new}
								;;
							selectCode)
								name=${name%${LangExt}}${LangExt}
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
											new=${new%${LangExt}}
											newName=${new##*/}
											echo "${name},${newName}${LangExt}"
										else
											echo "${name}"
										fi
										;;
									selectCode)
										name=$(find ${TheSrcDir} -name ${name} 2> /dev/null | grep "${ProjectMode}")
										if [ -f ${name} ]; then
											name=${name%${LangExt}}
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
								if [ -z ${num} ]; then
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
								echo "Please Add support for handling ${src}"
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
		compileCode)
			local src=$1
			local name=$2
			local keep=$3
			local project=${CodeProject}
			local cplArgs=""
			local TheSrcDir
			local TheBinDir
			local des
			local ERROR

			#Handle Project Dir
			case ${project} in
				#Code is NOT part of a project
				none)
					project=""
					TheBinDir=${LangBin}
					#Compile source code
					case ${src} in
						*${LangExt})
							if [[ "${project}" == *"/" ]]; then
								#Compile Java prgram
								ERROR=$(${LangCpl} *${LangExt} 2>&1 | tr '\n' '|')
								#move Java Class to Binary dir
								if [ -f *.class ]; then
									mv *.class ${TheBinDir}/
								else
									errorCode "cpl" "ERROR" "${ERROR}"
								fi
							#non-project code selected
							else
								src=$(echo ${src} | tr ',' ' ')
								#Compile Java prgram
								ERROR=$(${LangCpl} ${src} 2>&1 | tr '\n' '|')
								des=$(grep -l "public static void main" ${src})
								#get Java Class/compiled file name
								des=${des%.*}.class
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
											echo -e "\e[1;4${ColorNum}m[${Lang} Code Compiled (JAR)]\e[0m"
											;;
										#Do nothing...keep class
										*|--class)
											#move Java Class to Binary dir
											mv *.class ${TheBinDir}/
											#remove old jar
											if [ -f ${TheBinDir}/${des%.class}.jar ]; then
												rm ${TheBinDir}/${des%.class}.jar
											fi
											echo -e "\e[1;4${ColorNum}m[${Lang} Code Compiled (CLASS)]\e[0m"
											;;
									esac
								else
									#Display Error from compiler
									errorCode "cpl" "ERROR" "${ERROR}"
								fi
							fi
							;;
						*)
							;;
					esac
					;;
				#Code is part of a project
				*)
					local Package
					local IsMain
					local TheMain
					local TheClassPath
					local ManifestFile=META-INF/MANIFEST.MF
					local TheLibDir="${LangProject}/${project}/lib/"
					TheSrcDir="${LangProject}/${project}/src/"
					local ThePWD=${LangProject}/${project}/
					local TheClassDir=${ThePWD}classes/
					cd ${ThePWD}
					local ReplaceTheSrcDir=$(echo ${LangProject}/${project}/ | tr '/' '|')
					local ReplaceTheBinDir=$(echo ${LangProject}/${project}/classes/ | tr '/' '|')
					TheBinDir="${LangProject}/${project}/bin"

					#Compile as jar or class
					case ${name} in
						#Compile as Jar
						--jar)
							#Compile to Class
							ERROR=$(UseJava ${Type} ${src} --class ${keep})
							#Convert Class files to Jar
							if [ -z "${ERROR}" ]; then
								#Look for java class containing main
								#{
								local Files=$(cat sources.txt | tr '\n' '|')
								IFS="|"
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
									TheClassPath=$(echo ${TheClassPath} | tr ';' ' ')
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
								find ${TheClassDir} -name "*.class" | tr '/' '|' | sed "s/${ReplaceTheBinDir}//g" | tr '|' '/'  > sources.txt
								local ClassFound=$(cat sources.txt)
								#package as jar of class found
								if [ ! -z "${ClassFound}" ]; then
									ERROR=$(jar -cfm ${project}.jar ${ManifestFile} -C classes @sources.txt 2>&1 | tr '/' '|' | sed "s/${ReplaceTheSrcDir}/\//g" | tr '|' '/' | tr '\n' '|')
									#move Java Class to Binary dir
									if [ -z "${ERROR}" ]; then
										mv ${project}.jar ${TheBinDir}/ 2> /dev/null
										rm -rf ${TheClassDir}* 2> /dev/null
										echo -e "\e[1;4${ColorNum}m[Project \"${project}\" Compiled (JAR)]\e[0m"
									else
										#Display Error from compiler
										errorCode "cpl" "ERROR" "${ERROR}"
									fi
								else
									errorCode "cpl" "ERROR" "No compiled Clases found"
								fi
							else
								#Display Error from compiler
								errorCode "cpl" "ERROR" "${ERROR}"
							fi
							rm sources.txt
							cd - > /dev/null
							;;
						#compile class
						--class)
							find ${TheSrcDir} -name "*${LangExt}" | grep "${ProjectMode}" | tr '/' '|' | sed "s/${ReplaceTheSrcDir}//g" | tr '|' '/'  > sources.txt
							#Compile java code with lib jars
							if [ -d "${TheLibDir}" ]; then
								local ReplaceTheLibDir=$(echo "${LangProject}/${project}/" | tr '/' '|')
								TheClassPath=$(find ${TheLibDir} -name "*.jar" | grep "${ProjectMode}" | tr '/' '|' | sed "s/${ReplaceTheLibDir}//g" | tr '|' '/' | tr '\n' ';' | rev | sed "s/;//1" | rev)
								#make sure jars exist in lib
								if [ ! -z "${TheClassPath}" ]; then
									ERROR=$(${LangCpl} -cp ".;${TheClassPath}" -d classes @sources.txt 2>&1 | tr '\n' '|')
								#jars don't exist in lib...compile as usual
								else
									ERROR=$(${LangCpl} -d classes @sources.txt 2>&1 | tr '\n' '|')
								fi
							#jars don't exist in lib...compile as usual
							else
								ERROR=$(${LangCpl} -d classes @sources.txt 2>&1 | tr '\n' '|')
							fi
							echo ${ERROR}
							;;
						#default
						*)
							#Compile to Class
							ERROR=$(UseJava ${Type} ${src} --class ${keep})
							IsClass=$(find ${ThePWD} -name "*.class")
							#Code Compile from Java
							if [ -z "${ERROR}" ] && [ ! -z "${IsClass}" ]; then
								if [ -f ${TheBinDir}/${project}.jar ]; then
									rm ${TheBinDir}/${project}.jar
								fi
								echo -e "\e[1;4${ColorNum}m[Project \"${project}\" Compiled (CLASS)]\e[0m"
							else
								if [ -z "${IsClass}" ]; then
									errorCode "cpl" "ERROR" "Class did not compile"
								else
									#Display Error from compiler
									errorCode "cpl" "ERROR" "${ERROR}"
								fi
							fi
							rm sources.txt
							cd - > /dev/null
							;;
					esac
					;;
			esac
			;;
		discoverProject)
			local path=${LangProject}/
			local ProjectList=$(ls ${path} 2> /dev/null | tr '\n' '|' | rev | sed "s/|//1" | rev)
			if [ ! -z "${ProjectList}" ]; then
				echo "${path}:${ProjectList}"
			fi
			;;
		newProject)
			local TheProjectType=$1
			local project=$2
			local path=${LangProject}/${project}
			if [ ! -d ${path} ]; then
				case ${ProjectType} in
					Generic)
						mkdir ${path}
						cd ${path}
						mkdir lib
						mkdir classes
						mkdir META-INF
						mkdir src bin
						mkdir src/main src/test
						mkdir src/main/java src/test/java
						;;
					*)
						ProjectTemplateHandler ${EnvVars[@]} ${Type} ${project}
						;;
				esac
			else
				cd ${path}
			fi
			echo ${path}
			;;
		newPackage)
			local name=$1
			local packagePath=$(echo ${name} | tr '.' '/')
			local project=${CodeProject}
			local path=${LangProject}/${project}/src/${ProjectMode}/java/
			if [ ! -z "${name}" ]; then
				cd ${path}
				mkdir -p ${packagePath}
				echo "package \"${name}\" created"
				cd - > /dev/null
			fi
			;;
		projectMode)
			local mode=$1
			case ${ProjectType} in
				Generic)
					case ${mode} in
						main|test)
							echo "${mode}"
							;;
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
					path=${LangProject}/${project}/bin/
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
			src="${src%.*}${LangExt}"
			#Check if Java source exists
			if [ -f "${LangSrc}/${src}" ]; then
				#Return Java Source Name
				echo "${src}"
			fi
			;;
		SwapToBin)
			local bin=$1
			case ${bin} in
				*${LangExt})
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
			#Java binary
			if [[ "${bin}" == *"${LangExt}" ]]; then
				#Check for Jar file
				if [ -f "${TheBinDir}/${BinFile}.jar" ]; then
					AddAlias "${BinFile}" "${LangRun} -jar ${TheBinDir}/${BinFile}.jar"
				elif [ -f "${TheBinDir}/${BinFile}.class" ]; then
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
			Type=${Type,,}
			#Check for Custom Code Template...is class
			if [ -f ${TemplateCodeClass} ]; then
				echo -n "${cLang}\$ java ${cTemplateC} "
				read -a Args
				#Program Args Given
				if [ ! -z "${Args}" ];then
					cd ${LangBin}
					${LangRun} new${Lang} ${Args[@]}
					cd - > /dev/null
					mv "${LangBin}/*${LangExt}" . 2> /dev/null
				else
					cd ${LangBin}
					${LangRun} new${Lang} --help
					cd - > /dev/null
				fi
			#Check for Custom Code Template...is jar
			elif [ -f ${TemplateCodeJar} ]; then
				echo -n "${cLang}\$ java -jar ${cTemplateJ} "
				read -a Args
				#Program Args Given
				if [ ! -z "${Args}" ];then
					${LangRun} -jar ${TemplateCodeJar} ${Args[@]}
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
			local Type=$2
			local oldCode=$3
			local project=${CodeProject}
			local newName
			local DirPath
			local PackageName
			local PackageNameJava
			local Content
			local TemplateC=${TemplateCodeClass##*/}
			TemplateC=${TemplateC%.*}

			Type=${Type,,}
			name=${name%${LangExt}}
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
							PackageName=$(pwd | sed "s/${project}\/src/|/g" | cut -d '|' -f 2 | sed "s/\/main\/java\///1" | sed "s/\/test\/java\///1" | tr '/' '.')
							if [ ! -z "${PackageName}" ]; then
								PackageNameJava="--package ${PackageName}"
							fi
							;;
					esac
						#Check for Custom Code Template...is class
						if [ -f ${TemplateCodeClass} ]; then
							case ${Type} in
								#create main file
								main)
									cd ${LangBin}
									${LangRun} ${TemplateC} --user $USER --main --shell --write-file --read-file --user-input --append-array ${PackageNameJava} --name ${name}
									cd - > /dev/null
									mv "${LangBin}/${name}${LangExt}" .
									;;
								#create component file
								component)
									cd ${LangBin}
									${LangRun} ${TemplateC} --user $USER --write-file --read-file --user-input --append-array ${PackageNameJava} --name ${name}
									cd - > /dev/null
									mv "${LangBin}/${name}${LangExt}" . 2> /dev/null
									;;
								#cl[ide] knows best
								*)
									#main class already created
									if [[ "${oldCode}" == *"${LangExt}" ]]; then
										#Create libary class
										UseJava "newCode" ${name} "component" ${oldCode}
									else
										#Create new main code
										UseJava "newCode" ${name} "main" ${oldCode}
									fi
									;;
							esac
						#Check for Custom Code Template...is jar
						elif [ -f ${TemplateCodeJar} ]; then
							case ${Type} in
								#create main file
								main)
									${LangRun} -jar ${TemplateCodeJar} --user $USER --main --shell --write-file --read-file --user-input --append-array ${PackageNameJava} --name ${name}
									;;
								#create component file
								component)
									${LangRun} -jar ${TemplateCodeJar} --user $USER --write-file --read-file ${PackageNameJava} --name ${name}
									;;
								#cl[ide] knows best
								*)
									if [[ "${oldCode}" == *"${LangExt}" ]]; then
										#Create libary class
										UseJava "newCode" ${name} "component" ${oldCode}
									else
										#Create new main code
										UseJava "newCode" ${name} "main" ${oldCode}
									fi
									;;
							esac
						#No Template Program
						else
							echo ${TheSrcDir}${name}${LangExt}
							if [ ! -z "${PackageName}" ]; then
								Content="package ${PackageName};\n\n/**\n *\n * @author $USER\n */\n\n//class name\npublic class ${name} {\n\n\t/**\n\t* @param args the command line arguments\n\t*/\n\tpublic static void main(String[] args) {\n\n\t}\n}"
							else
								Content="//class path goes here\n\n/**\n *\n * @author $USER\n */\n\n//class name\npublic class ${name} {\n\n\t/**\n\t* @param args the command line arguments\n\t*/\n\tpublic static void main(String[] args) {\n\n\t}\n}"
							fi
							touch ${name}${LangExt}
							echo -e "${Content}" > ${name}${LangExt}
						fi
				fi
			#No Program Name Given
			else
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
		runCode)
			local name=$1
			local TheBin="${name%.*}.class"
			local TheJar="${name%.*}.jar"
			local project=${CodeProject}
			local package
			local TheClassDir
			local TheJarDir
			local JavaProp=$2
			shift
			local Args=$@

			#Handle multiple files
			if [[ "${name}" == *","* ]]; then
				name=$(echo ${name} | tr ',' ' ')
				name=$(grep -l "public static void main" ${name})
				if [ -z "${name}" ]; then
					echo "Unable to find the \"main\" file"
					echo -n "Please choose: "
					read name
				fi
				TheBin="${name%.*}.class"
				TheJar="${name%.*}.jar"
			fi

			#Run Compiled Code
			if [ ! -z "${name}" ]; then
				case ${project} in
					none)
						project=""
						TheClassDir=${LangBin}/
						TheJarDir=${LangBin}
						;;
					*)
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
					package=$(echo ${package} | tr '/' '.')
					#If no JavaProp found
					case ${JavaProp} in
						none)
							#Execute without
							${LangRun} ${package}${TheBin} ${Args[@]}
							;;
						*)
							${LangRun} "${JavaProp}" ${package}${TheBin} ${Args[@]}
							;;
					esac
					cd - > /dev/null
				#Check if Java Jar exists
				elif [ -f ${TheJarDir}/${TheJar} ]; then
					${LangRun} -jar ${TheJarDir}/${TheJar} ${Args[@]}
				else
					errorCode "cpl" "need" "${name}"
				fi
			else
				echo "Unable to locate executable"
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
				sed "s/${TheOld}/${TheNew}/g" ${LangSrc}/${TheOld}${LangExt} > ${LangSrc}/${TheNew}${LangExt}
				rm ${LangSrc}/${TheOld}${LangExt}
				echo ${TheNew}${LangExt}
			fi
			;;
		copy)
			local TheOld=$1
			local TheNew=$2
			if [ ! -z "${TheNew}" ]; then
				TheOld="${TheOld%${LangExt}}"
				TheNew="${TheNew%${LangExt}}"
				sed "s/${TheOld}/${TheNew}/g" ${LangSrc}/${TheOld}${LangExt} > ${LangSrc}/${TheNew}${LangExt}
				echo ${TheNew}${LangExt}
			fi
			;;
		*)
			;;
	esac
}

UseJava $@
