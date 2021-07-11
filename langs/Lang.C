Shell=$(which bash)
#!${Shell}

#https://www3.ntu.edu.sg/home/ehchua/programming/cpp/gcc_make.html
SupportV="0.1.21"
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
	local LangCpl=${UseCpp}

	local LangHome=${ProgDir}/${Lang}
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local LangProject=${LangHome}/projects

	local TemplateCode=${NewCpp}
	TemplateCode=${LangBin}/${TemplateCode%${LangExt}}

	local TemplateCodeSrc=${NewCpp%${LangExt}}${LangExt}

	local EnvVars=( ${LangRun} ${LangHome} ${LangSrc} ${LangBin} ${LangExt} )
	local Type=$1
	shift
	case ${Type} in
		Art)
			local srt="\e[1;3${ColorNum}m"
			local end="\e[0m"
			echo -e "  ${srt}.oooooo.${end}"
			echo -e " ${srt}d8P'${end}"
			echo -e "${srt}888${end}"
			echo -e "${srt}888${end}"
			echo -e "${srt}888${end}"
			echo -e "${srt}\`88b${end}"
			echo -e " ${srt}\`Y8bood8P'${end}"
			echo ""
			;;
		color)
			#Return Blue
			echo -e "\e[1;3${ColorNum}m${Lang}\e[0m"
			;;
		ProjectColor)
			echo -e "\e[1;4${ColorNum}m${CodeProject}\e[0m"
			;;
		getNewCode)
			echo ${TemplateCodeSrc}
			;;
		getSrcDir)
			local project=${CodeProject}
			case ${project} in
				#not a project
				none)
					echo ${LangSrc}
					;;
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
			echo ${LangProject}/${project}
			;;
		getBin)
			local srcCode=$(echo $1 | sed "s/${LangExt}//g")
			if [ ! -z "${srcCode}" ]; then
				local TheCpl
				local TheItem
				local CplList=$(UseC lscpl | tr '\n' '|')
				local look=1
				local NumOfCpls=$(echo ${srcCode} | tr ',' '\n' | wc -l)
				while [ ${look} -le ${NumOfCpls} ];
				do
					TheItem=$(echo ${srcCode} | cut -d ',' -f ${look})
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
			name=${name%${LangExt}}
			name=${name%${LangOtherExt}}
			local oldCode=$2
                        local project=${CodeProject}
                        local newName
                        local DirPath
                        local TheSrcDir
			case ${project} in
				none)
					TheSrcDir=${LangSrc}
					;;
				*)
					case ${ProjectType} in
						Generic)
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
						*)
							TheSrcDir=$(ProjectTemplateHandler ${EnvVars[@]} ${Type} ${mode})
							;;
					esac
					;;
			esac

			case ${oldCode} in
				*"${name}${LangExt}"*)
					#if [ -f ${TheSrcDir}/${name}${LangOtherExt} ]; then
					if [ -f ${name}${LangOtherExt} ]; then
						echo ${name}${LangOtherExt}
					fi
					;;
				*"${name}${LangOtherExt}"*)
					#if [ -f ${TheSrcDir}/${name}${LangExt} ]; then
					if [ -f ${name}${LangExt} ]; then
						echo ${name}${LangExt}
					fi
					;;
				*)
					#if [ -f ${TheSrcDir}/${name}${LangExt} ]; then
					if [ -f ${name}${LangExt} ]; then
						echo ${name}${LangExt}
					#elif [ -f ${TheSrcDir}/${name}${LangOtherExt} ]; then
					elif [ -f ${name}${LangOtherExt} ]; then
						echo ${name}${LangOtherExt}
					elif [ -f ${TheSrcDir}/${name} ]; then
						echo ${name}
					fi
					;;
			esac
			;;
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
						case ${Type} in
							selectCode)
								#Correct filename
								if [[ ! "${name}" == *"${LangExt}" ]] && [ -f "${name}${LangExt}" ]; then
									name="${name}${LangExt}"
								elif [[ ! "${name}" == *"${LangOtherExt}" ]] && [ -f "${name}${LangOtherExt}" ]; then
									name="${name}${LangOtherExt}"
								fi

								#Return source file if exists
								if [ -f "${name}" ]; then
									echo "${name}"
								fi
								;;
							addCode)
								case ${name} in
									*${LangExt}|*${LangOtherExt})
										#Add cpp or header files with file extensions
										case ${new} in
											*${LangExt}|*${LangOtherExt})
												#Append file
												if [ -f "${new}" ]; then
													echo "${name},${new}"
												else
													echo "${name}"
												fi
												;;
											#Add cpp or header files without file extensions
											*)
												#Append cpp files
												if [ -f "${new}${LangExt}" ]; then
													echo "${name},${new}${LangExt}"
												#Append header files
												elif [ -f "${new}${LangOtherExt}" ]; then
													echo "${name},${new}${LangOtherExt}"
												else
													echo "${name}"
												fi
												;;
										esac
										;;
									*)
										;;
								esac
								;;
							*)
								;;
						esac
						;;
					#is a project
					*)
						TheSrcDir="${LangProject}/${project}/src/"
						local LookFor
						case ${Type} in
							selectCode)
								#Correct filename
								if [[ ! "${name}" == *"${LangExt}" ]] && [ -f "${name}${LangExt}" ]; then
									name="${name}${LangExt}"
								elif [[ ! "${name}" == *"${LangOtherExt}" ]] && [ -f "${name}${LangOtherExt}" ]; then
									name="${name}${LangOtherExt}"
								fi
								LookFor=${name}
								;;
							addCode)
								case ${name} in
									*${LangExt}|*${LangOtherExt})
										#Add cpp or header files with file extensions
										case ${new} in
											*${LangExt}|*${LangOtherExt})
												;;
											#Add cpp or header files without file extensions
											*)
												#Append cpp files
												if [ -f "${new}${LangExt}" ]; then
													new=${new}${LangExt}
												#Append header files
												elif [ -f "${new}${LangOtherExt}" ]; then
													new=${new}${LangOtherExt}
												fi
												;;
										esac
										;;
									*)
										;;
								esac
								LookFor=${new}
								;;
							*)
								;;
						esac

						local NumFound=$(find ${TheSrcDir} -name ${LookFor} 2> /dev/null | wc -l)
						case ${NumFound} in
							0)
								;;
							1)
								case ${Type} in
									addCode)
										new=$(find ${TheSrcDir} -name ${LookFor} 2> /dev/null)
										#Append file
										if [ -f "${new}" ]; then
											new=${new##*/}
											echo "${name},${new}"
										else
											echo "${LookFor}"
										fi
										;;
									selectCode)
										name=$(find ${TheSrcDir} -name ${LookFor} 2> /dev/null)
										if [ -f ${name} ]; then
											newName=${name##*/}
											echo ${newName}
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
			name=${name%${LangExt}}
			name=${name%${LangOtherExt}}
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
					local theHeader=${name%${LangExt}}${LangOtherExt}
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
					#secretly take care of the header file
					if [ -f ${ThePath}/${theHeader} ]; then
						rm ${ThePath}/${theHeader}
					fi
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
				*${LangExt}|*${LangOtherExt})
					case ${project} in
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
								if [ -z ${num} ]; then
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
		compileCode)
			local src=$1
			local name=$2
#			local cplArgs=$3
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

			#Handle multiple files
			if [ -z "${name}" ]; then
				if [[ "${src}" == *","* ]]; then
					src=$(echo ${src} | tr ',' ' ')
					name=$(grep -l "int main(" ${src} 2> /dev/null)
					name=${name%.*}
				else
					name=${src%.*}
				fi
#				cplArgs=$2
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
			if [[ "$src" == *"${LangExt}"* ]] || [ -f ${LangProject}/${project}makefile ]; then
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
					echo -e "\e[1;4${ColorNum}m[${Lang} Code Compiled]\e[0m"
				#Compile without makefile
				else
					#source file is empty
					if [ -z ${name} ]; then
						errorCode "cpl" "choose"
					else
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

						#Compile and check for errors
						ERROR=$(${LangCpl} ${src} -o ${TheBinDir}/${name} ${cplArgs} 2>&1 | tr '\n' '|')

						#Code compiled successfully
						if [ -z "${ERROR}" ]; then
							echo -e "\e[1;4${ColorNum}m[${Lang} Code Compiled]\e[0m"
						else
							errorCode "cpl" "ERROR" "${ERROR}"
						fi
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
			local path=${LangProject}/
			local ProjectList=$(ls ${path} 2> /dev/null | tr '\n' '|' | rev | sed "s/|//1" | rev)
			if [ ! -z "${ProjectList}" ]; then
				echo "${path}:${ProjectList}"
			fi
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
		SwapToSrc)
			local src=$1
			#cd "${LangSrc}"
			#Get C Name
			src="${src}${LangExt}"
			#Check if C source exists
			if [ -f "${LangSrc}/${src}" ]; then
				#Return C Source Name
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
					#Get C Name
					bin="${bin%.*}"
					#Check if C Binary exists
					if [ -f "${LangBin}/${bin}" ]; then
						#Return C Binary Name
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
			#Make sure Binary exists
			if [ -f "${TheBinDir}/${BinFile}" ]; then
				#Add command to Aliases
				AddAlias "${BinFile}" "${TheBinDir}/${BinFile}"
			elif [ ! -f "${TheBinDir}/${BinFile}" ]; then
				#compule or swap to binary
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
		#Create new src files
		newCode)
			local name=$1
			local Type=$2
                        local oldCode=$3
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
					name=${name%${LangOtherExt}}
					Type="header"
					;;
				*)
					name=${name%${LangExt}}
					;;
			esac
			if [ ! -f ${name}${LangExt} ] || [ ! -f ${name}${LangOtherExt} ]; then
				case ${Type} in
					#create header file
					header)
						if [ ! -f ${name}${LangOtherExt} ]; then
							#Program Name Given
							if [ ! -z "${name}" ];then
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
									case ${name%${LangExt}}${LangExt} in
										#In the event you have a name.cpp file, also make a name.h file
										*"${oldCode}"*)
											#echo "header"
											UseC "newCode" ${name%${LangExt}}${LangOtherExt} "header" ${oldCode}
											;;
										#In the event you already have a main file, create a component
										*)
											#echo "component"
											UseC "newCode" ${name} "component" ${oldCode}
											;;
									esac
								#No source code has been made, create a main file
								else
									#echo "main"
									UseC "newCode" ${name} "main"
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
									local NumFound=$(find ${TheSrcDir} -name ${name%${LangExt}}${LangExt} 2> /dev/null | wc -l)
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
		backup)
			local name=$1
			if [ ! -z "${name}" ]; then
				#Backup file does NOT exist
				if [ ! -f "${LangSrc}/${name}.bak" ]; then
					#Make backup
					cp ${LangSrc}/${name} ${LangSrc}/${name}.bak
					echo "\"${name}\" backed-up"
				#Backup file exists
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
				#Backup file exists
				if [ -f "${LangSrc}/${name}.bak" ]; then
					#Restore from backup
					mv ${LangSrc}/${name}.bak ${LangSrc}/${name}
					echo "\"${name}\" restored"
				#Backup file does NOT exist
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
#init
UseC $@
