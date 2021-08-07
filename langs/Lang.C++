Shell=$(which bash)
#!${Shell}

#https://www3.ntu.edu.sg/home/ehchua/programming/cpp/gcc_make.html
SupportV="0.1.90"
Lang=C++
LangExt=".cpp"
LangOtherExt=".h"

#Checking user's desired extension for source files
case ${CppSrcExt,,} in
	.cc|.cxx|.c++)
		LangExt=${CppSrcExt,,}
		;;
	cc|cxx|c++)
		LangExt=".${CppSrcExt,,}"
		;;
	*)
		;;
esac

#Checking user's desired extension for header files
case ${CppHeadExt,,} in
	.hh|.hpp|.hxx|.h++)
		LangOtherExt=${CppHeadExt,,}
		;;
	hh|hpp|hxx|h++)
		LangOtherExt=".${CppHeadExt,,}"
		;;
	*)
		;;
esac

ColorNum=4

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

UseC++()
{
	#Get the enviornment variables for C++
	#{
	
	local LangCpl=${cplCpp}
	local UseDebugger=${debugCandCpp}

	local LangHome=${ProgDir}/${Lang}
	local LangSrc=${LangHome}/src
	local LangBin=${LangHome}/bin
	local LangProject=${LangHome}/projects

	local TemplateCode=${NewCpp}
	TemplateCode=${LangBin}/${TemplateCode%${LangExt}}

	local TemplateCodeSrc=${NewCpp%${LangExt}}${LangExt}

	local EnvVars=( ${LangRun} ${LangHome} ${LangSrc} ${LangBin} ${LangExt} )
	#}

	#Get action for from cl[ide]
	local Type=$1
	shift
	case ${Type} in
		#C++ artwork
		Art)
			local srt="\e[1;3${ColorNum}m"
			local end="\e[0m"
			echo -e "  ${srt}.oooooo.${end}"
			echo -e " ${srt}d8P'${end}  ${srt}\`Y8b${end}"
			echo -e "${srt}888${end}              ${srt}88${end}         ${srt}88${end}"
			echo -e "${srt}888${end}              ${srt}88${end}         ${srt}88${end}"
			echo -e "${srt}888${end}          ${srt}8888888888${end} ${srt}8888888888${end}"
			echo -e "${srt}\`88b${end}    ${srt}ooo${end}      ${srt}88${end}         ${srt}88${end}"
			echo -e " ${srt}\`Y8bood8P'${end}      ${srt}88${end}         ${srt}88${end}"
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
			echo ${LangProject}/${project}
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
				echo "[${Lang} Debugger]"
				echo "${debugV}"
				echo ""
			fi
			;;
		hasExt)
			local SourceFile=$1
			if [ ! -z "${SourceFile}" ]; then
				case ${SourceFile,,} in
					*.cpp|*.cc|*.cxx|*.c++)
						echo ${Lang}
						;;
					*)
						;;
				esac
			fi
			;;
		hasExtForCpl|hasExtForSrc)
			local SourceFile=$1
			if [ ! -z "${SourceFile}" ]; then
				case ${SourceFile,,} in
					*.cpp*|*.cc*|*.cxx*|*.c++*)
						echo "yes"
						;;
					*)
						;;
				esac
			fi
			;;
		hasExtForHeader)
			local SourceFile=$1
			if [ ! -z "${SourceFile}" ]; then
				case ${SourceFile,,} in
					*.h|*.hh|*.hpp|*.hxx|*.h++)
						echo "yes"
						;;
					*)
						;;
				esac
			fi
			;;
		hasExtForAll)
			local SourceFile=$1
			if [ ! -z "${SourceFile}" ]; then
				case ${SourceFile,,} in
					*.cpp*|*.cc*|*.cxx*|*.c++*|*.h*)
						echo "yes"
						;;
					*)
						;;
				esac
			fi
			;;
		FindTheSrc)
			local name=$1
			local project=${CodeProject}
			local CheckForCpp
			if [ ! -z "${name}" ]; then
				case ${project} in
					none)
						if [ -f "${name}.cpp" ]; then
							echo "${name}.cpp"
						elif [ -f "${name}.cc" ]; then
							echo "${name}.cc"
						elif [ -f "${name}.cxx" ]; then
							echo "${name}.cxx"
						elif [ -f "${name}.c++" ]; then
							echo "${name}.c++"
						fi
						;;
					*)
						local ext=${LangExt}
						local ThePosSrcs=".cpp .cc .cxx .c++"
						CheckForCpp=$(UseC++ "getProjSrc" ${name}${ext} 2> /dev/null)
						if [ -z "${CheckForCpp}" ]; then
							local look=1
							#Get the number of set source code
							local NumOfSrcs=$(echo ${ThePosSrs} | tr ',' '\n' | wc -l)
							while [ ${look} -le ${NumOfSrcs} ];
							do
								#Choose one item
								ext=$(echo ${ThePosSrs} | cut -d ',' -f ${look})

								CheckForCpp=$(UseC++ "getProjSrc" ${name}${ext} 2> /dev/null)
								if [ ! -z "${CheckForCpp}" ]; then
									echo ${CheckForCpp}
									break
								fi
								look=$((${look}+1))
							done
						else
							echo ${CheckForCpp}
						fi
						;;
				esac
			fi
			;;
		FindTheHeader)
			local name=$1
			local project=${CodeProject}
			local CheckForHeader

			if [ ! -z "${name}" ]; then
				case ${project} in
					none)
						if [ -f "${name}.h" ]; then
							echo "${name}.h"
						elif [ -f "${name}.hh" ]; then
							echo "${name}.hh"
						elif [ -f "${name}.hpp" ]; then
							echo "${name}.hpp"
						elif [ -f "${name}.hxx" ]; then
							echo "${name}.hxx"
						elif [ -f "${name}.h++" ]; then
							echo "${name}.h++"
						fi
						;;
					*)
						local ext=${LangOtherExt}
						local ThePosHeaders=".h .hh .hpp .hxx .h++"
						CheckForHeader=$(UseC++ "getProjSrc" ${name}${ext} 2> /dev/null)
						if [ -z "${CheckForHeader}" ]; then
							local look=1
							#Get the number of set source code
							local NumOfHs=$(echo ${ThePosHeaders} | tr ',' '\n' | wc -l)
							while [ ${look} -le ${NumOfHs} ];
							do
								#Choose one item
								ext=$(echo ${ThePosHeaders} | cut -d ',' -f ${look})

								CheckForHeader=$(UseC++ "getProjSrc" ${name}${ext} 2> /dev/null)
								if [ ! -z "${CheckForHeader}" ]; then
									echo ${CheckForHeader}
									break
								fi
								look=$((${look}+1))
							done
						else
							echo ${CheckForHeader}
						fi
						;;
				esac
			fi
			;;
		removeExt)
			local SourceFile=$1
			if [ ! -z "${SourceFile}" ]; then
				case ${SourceFile} in
					*.cpp)
						echo ${SourceFile%.cpp}
						;;
					*.cc)
						echo ${SourceFile%.cc}
						;;
					*.cxx)
						echo ${SourceFile%.cxx}
						;;
					*.c++)
						echo ${SourceFile%.c++}
						;;
					*.h)
						echo ${SourceFile%.h}
						;;
					*.hh)
						echo ${SourceFile%.hh}
						;;
					*.hpp)
						echo ${SourceFile%.hpp}
						;;
					*.hxx)
						echo ${SourceFile%.hxx}
						;;
					*.h++)
						echo ${SourceFile%.h++}
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
				local CplList=$(UseC++ lscpl | tr '\n' '|')
				local look=1
				#Get the number of set source code
				local NumOfCpls=$(echo ${srcCode} | tr ',' '\n' | wc -l)
				while [ ${look} -le ${NumOfCpls} ];
				do
					#Choose one item
					TheItem=$(echo ${srcCode} | cut -d ',' -f ${look})
					TheItem=$(UseC++ "removeExt" ${TheItem})

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
			name=$(UseC++ "removeExt" ${name})
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
				#Return C++ tag
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
			#Return C++ src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
			echo -e "make\t\t\t: create makefile"
			echo -e "version, -std=<c++#>\t: compile with a specific version"
			;;
		shell)
			;;
		newCodewHelp)
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
			local HasAnExt
			local HasAnExtSrc
			local HasAnExtHeader

			#Correct filename
			if [ ! -z "${name}" ]; then
				case ${project} in
					#not a project
					none)
						#"set" or "add"
						case ${Type} in
							#Used with "set"
							selectCode)
								#Check if extenion is given
								HasAnExt=$(UseC++ "hasExtForAll" ${name})
								#Extension is NOT given
								if [ -z "${HasAnExt}" ]; then
									#Evaluate if file exists by extension
									HasAnExtSrc=$(UseC++ "hasExtForSrc" ${name})
									HasAnExtHeader=$(UseC++ "hasExtForHeader" ${name})
									#selected in priority...default src
									if [ -z "${HasAnExtSrc}" ]; then
										#Using default src
										if [ -f "${name}${LangExt}" ]; then
											name="${name}${LangExt}"
										#Look for other src types
										else
											name=$(UseC++ "FindTheSrc" ${name})
										fi
									#default header
									elif [ -z "${HasAnExtHeader}" ]; then
										#Using default header
										if [ -f "${name}${LangOtherExt}" ]; then
											name="${name}${LangOtherExt}"
										#Look for other header types
										else
											name=$(UseC++ "FindTheHeader" ${name})
										fi
									fi
								fi
								#Return source file if exists
								if [ -f "${name}" ]; then
									echo "${name}"
								fi
								;;
							#Used with "add"
							addCode)
								HasAnExt=$(UseC++ "hasExtForAll" ${name})
								#source file has an extenion
								if [ ! -z "${HasAnExt}" ]; then
									#Evaluate added code...src or header
									HasAnExt=$(UseC++ "hasExtForAll" ${new})
									#Added code has an extension
									if [ ! -z "${HasAnExt}" ]; then
										#Check if file exists
										if [ -f "${new}" ]; then
											#check if is already selected
											case ${name} in
												*${new}*)
													echo "${name}"
													;;
												*)
													echo "${name},${new}"
													;;
											esac
										#File does not exist
										else
											echo "${name}"
										fi
									#Has NO extension
									else
										#src and NOT header
										if [ -f "${new}${LangExt}" ] && [ ! -f "${new}${LangOtherExt}" ]; then
											#Re-evaluate
											case ${name} in
												#Contains only src
												*${new}${LangExt}*)
													HasAnExtHeader=$(UseC++ "FindTheHeader" ${new})
													UseC++ ${Type} ${name} ${HasAnExtHeader}
													;;
												#Add src
												*)
													UseC++ ${Type} ${name} ${new}${LangExt}
													;;
											esac
										#Header and NOT src
										elif [ ! -f "${new}${LangExt}" ] && [ -f "${new}${LangOtherExt}" ]; then
											#Re-evaluate
											case ${name} in
												#Contains only Header
												*${new}${LangOtherExt}*)
													#Add src
													HasAnExtSrc=$(UseC++ "FindTheSrc" ${new})
													UseC++ ${Type} ${name} ${HasAnExtSrc}
													;;
												#Add header
												*)
													UseC++ ${Type} ${name} ${new}${LangOtherExt}
													;;
											esac
										#BOTH Header and src
										elif [ -f "${new}${LangExt}" ] && [ -f "${new}${LangOtherExt}" ]; then
											#evaluate set code
											case ${name} in
												#Both are already in selected code
												*${new}${LangExt}*${new}${LangOtherExt}*|*${new}${LangOtherExt}*${new}${LangExt})
													#Do nothing
													echo ${name}
													;;
												#One is in and one is not ins selected code
												*)
													#Re-evaluate
													case ${name} in
														#Contains only src
														*${new}${LangExt}*)
															#Add header
															UseC++ ${Type} ${name} ${new}${LangOtherExt}
															;;
														#Contains only header
														*${new}${LangOtherExt}*|*)
															#Add src
															UseC++ ${Type} ${name} ${new}${LangExt}
															;;
													esac
													;;
											esac
										#NONE of the above
										else
											HasAnExtSrc=$(UseC++ "FindTheSrc" ${new})
											HasAnExtHeader=$(UseC++ "FindTheHeader" ${new})
											#src and NOT header
											if [ ! -z "${HasAnExtSrc}" ] && [ -z "${HasAnExtHeader}" ]; then
												#Add src
												UseC++ ${Type} ${name} ${HasAnExtSrc}
											#Header and NOT src
											elif [ -z "${HasAnExtSrc}" ] && [ ! -z "${HasAnExtHeader}" ]; then
												#Add header
												UseC++ ${Type} ${name} ${HasAnExtHeader}
											#BOTH Header and src
											elif [ ! -z "${HasAnExtSrc}" ] && [ ! -z "${HasAnExtHeader}" ]; then
												case ${name} in
													#Both are already in selected code
													*${HasAnExtSrc}*${HasAnExtHeader}*|*${HasAnExtHeader}*${HasAnExtSrc})
														#Do nothing
														echo ${name}
														;;
													#One is in and one is not ins selected code
													*)
														#Re-evaluate
														case ${name} in
															#Contains only src
															*${HasAnExtSrc}*)
																#Add header
																UseC++ ${Type} ${name} ${HasAnExtHeader}
																;;
															#Contains only header
															*${HasAnExtHeader}*|*)
																#Add src
																UseC++ ${Type} ${name} ${HasAnExtSrc}
																;;
														esac
														;;
												esac
											else
												echo ${name}
											fi
										fi
									fi
								fi
								;;
							*)
								;;
						esac
						;;
					#is a project
					*)
						local CheckForCpp
						local CheckForHeader
						local LookFor

						#"set" or "add"
						case ${Type} in
							#Used with "set"
							selectCode)
								#Check if extenion is given
								HasAnExt=$(UseC++ "hasExtForAll" ${name})
								#Extension is NOT given
								if [ -z "${HasAnExt}" ]; then
									#Evaluate if file exists by extension
									HasAnExtSrc=$(UseC++ "hasExtForSrc" ${name})
									HasAnExtHeader=$(UseC++ "hasExtForHeader" ${name})
									#selected in priority...default src
									if [ -z "${HasAnExtSrc}" ]; then
										name=$(UseC++ "removeExt" ${name})
										CheckForCpp=$(UseC++ "getProjSrc" ${name}${LangExt} 2> /dev/null)
										#Using default src
										if [ ! -z "${CheckForCpp}" ]; then
											name="${name}${LangExt}"
										#Look for other src types
										else
											name=$(UseC++ "FindTheSrc" ${name})
										fi
									#default header
									elif [ -z "${HasAnExtHeader}" ]; then
										CheckForHeader=$(UseC++ "getProjSrc" ${new}${LangOtherExt} 2> /dev/null)
										#Using default header
										if [ ! -z "${CheckForHeader}" ]; then
											name="${name}${LangOtherExt}"
										#Look for other header types
										else
											name=$(UseC++ "FindTheHeader" ${name})
										fi
									fi
								fi

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
														new=$(UseC++ "removeExt" ${new})
														CheckForCpp=$(UseC++ "getProjSrc" ${new}${LangExt} 2> /dev/null)
														CheckForHeader=$(UseC++ "getProjSrc" ${new}${LangOtherExt} 2> /dev/null)
														#Append cpp files
														if [ ! -z "${CheckForCpp}" ]; then
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
						local NumFound=$(UseC++ "getProjSrc" ${LookFor} 2> /dev/null | wc -l)
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
			name=$(UseC++ "removeExt" ${name})
			local ThePath
			local theHeader
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
					theHeader=${name}${LangOtherExt}
					#secretly take care of the header file
					if [ -f ${ThePath}/${theHeader} ]; then
						rm ${ThePath}/${theHeader}
					else
						cd ${ThePath}/
						theHeader=$(UseC++ "FindTheHeader" ${name})
						cd -> /dev/null
						if [ ! -z "${theHeader}" ]; then
							rm ${ThePath}/${theHeader}
						fi
					fi
					;;
				*)
					;;
			esac
			if [ -f ${ThePath}/${name}${LangExt} ]; then
				echo ${ThePath}/${name}${LangExt}
			else
				cd ${ThePath}/
				theSrc=$(UseC++ "FindTheSrc" ${name})
				cd -> /dev/null
				if [ ! -z "${theSrc}" ]; then
					echo ${ThePath}/${theSrc}
				fi
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
			local HasAnExt

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

			HasAnExt=$(UseC++ "hasExtForAll" ${src})

			if [ ! -z "${HasAnExt}" ]; then
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
			fi
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
						-v|--verbose)
							Item="-v"
							;;
						-d|--debug)
							Item="-g"
							;;
						-w|--warnings)
							Item="-Wall"
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
			echo -e "--std=<version>\t\t: \"Set C++ version\""
			case ${LangCpl} in
				g++)
					echo "These are ALL the ${LangCpl} versions"
					echo -e "\t\tc++98"
					echo -e "\t\tc++11"
					echo -e "\t\tc++14"
					echo -e "\t\tc++17"
					echo -e "\t\tc++2a"
					;;
				clang++)
					;;
				*)
					;;
			esac
			;;
		compileCode-message)
			echo -e "\e[1;4${ColorNum}m[${Lang} Code Compiled]\e[0m"
			;;
		compileCode)
			local src=$1
			local name=$2
			local cplArgs=${CplArgs//,/ }
			local IsVerbose
			local project=${CodeProject}
			local HasAnExt
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
						name=$(grep -l "int main(" ${src} 2> /dev/null)
						if [ -z "${name}" ]; then
							FoundMain="no"
						else
							NumOfMain=$(echo ${name} | tr ' ' '\n' | wc -l)
							case ${NumOfMain} in
								1)
									name=$(UseC++ "removeExt" ${name})
									;;
								*)
									FoundMain="no"
									errorCode "cpl" "ERROR" "More than one \"main\" files were found"
									;;
							esac
						fi
						;;
					*)
						name=$(UseC++ "removeExt" ${src})
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

			HasAnExt=$(UseC++ "hasExtForCpl" ${src})
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
					echo "make"
					cd - > /dev/null
					UseC++ compileCode-message
				#Compile without makefile
				else
					#source file is empty
					if [ -z "${name}" ]; then
						errorCode "cpl" "choose"
					else
						case ${FoundMain} in
							yes)
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

								IsVerbose=$(echo ${cplArgs} |grep -w "\-v" 2> /dev/null)
								if [ -z "${IsVerbose}" ]; then
									#Compile and check for errors...and put into binary directory
									ERROR=$(${LangCpl} ${src} -o ${TheBinDir}/${name} ${cplArgs} 2>&1 | tr '\n' '|')

									#Code compiled successfully
									if [ -z "${ERROR}" ]; then
										UseC++ compileCode-message
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
										UseC++ compileCode-message
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
			local cLang=$(UseC++ color)
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
			local cLang=$(UseC++ "color")
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
			local TheOfType=$2
			local TheName
                        local oldCode=$3
			local project=${CodeProject}
			local HasAHeaderExt
			local IsNotAType

			#Sometimes "oldCode" gets passed as "TheOfType"
			if [ -z "${oldCode}" ]; then
				IsNotAType=$(UseC++ "hasExtForAll" ${TheOfType})
				case ${IsNotAType} in
					yes)
						oldCode=${TheOfType}
						TheOfType=""
	
						;;
					*)
						;;
				esac
			fi

			TheOfType=${TheOfType,,}

			HasAHeaderExt=$(UseC++ "hasExtForHeader" ${name})
			case ${HasAHeaderExt} in
				yes)
					name=$(UseC++ "removeExt" ${name})
					TheOfType="header"
					;;
				*)
					name=$(UseC++ "removeExt" ${name})
					;;
			esac

			if [ ! -f ${name}${LangExt} ] || [ ! -f ${name}${LangOtherExt} ]; then
				case ${TheOfType} in
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
									${TemplateCode} --random --write-file --read-file --cli --main --is-in --user-input --name "${name}" --ext "${LangExt}"
								#No Program Name Given
								else
									#Help Page
									${TemplateCode} --help
								fi
							else
								#Program Name Given
								if [ ! -z "${name}" ];then
									local Content="#include <iostream>\n\n//${Lang} Main\nint main()\n{\n\n\treturn 0;\n}"
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
									${TemplateCode} -n "${name}" --ext "${LangExt}"
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
								TheName=$(UseC++ "removeExt" ${name})
								if [ ! -z "${oldCode}" ]; then
									if [ -f ${TheName}${LangExt} ]; then
										#echo "header"
										UseC++ "newCode" ${TheName}${LangOtherExt} "header" ${oldCode}
									else
										#echo "component"
										UseC++ "newCode" ${name} "component" ${oldCode}
									fi
								#No source code has been made, create a main file
								else
									if [ ! -f ${TheName}${LangExt} ]; then
										#echo "main"
										UseC++ "newCode" ${name} "main"
									else
										#echo "header"
										UseC++ "newCode" ${TheName}${LangOtherExt} "header"
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
									TheName=$(UseC++ "removeExt" ${name})
									local NumFound=$(find ${TheSrcDir} -name ${TheName}${LangExt} 2> /dev/null | wc -l)
									case ${NumFound} in
										#No other source code was found...make your main file
										0)
											UseC++ "newCode" ${name} "component" ${oldCode}
											;;
										#Source code was found...make a component
										1)
											UseC++ "newCode" ${name} "header" ${oldCode}
											;;
										*)
											;;
									esac
								#Make first source file
								else
									UseC++ "newCode" ${name} "main" ${oldCode}
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
								TheCount=$(UseC++ "getProjSrc" "${name}.bak" | wc -l)
								case ${TheCount} in
									0)
										errorCode "restore" "null"
										;;
									1)
										TheFound=$(UseC++ "getProjSrc" "${name}.bak")
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
								TheCount=$(UseC++ "getProjSrc" "${name}" | wc -l)
								case ${TheCount} in
									0)
										errorCode "backup" "null"
										;;
									1)
										TheFound=$(UseC++ "getProjSrc" "${name}")
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
			local TheOld=$(UseC++ "removeExt" $1)
			local TheNew=$(UseC++ "removeExt" $2)
			TheOld="${TheOld}${LangExt}"
			TheNew="${TheNew}${LangExt}"
			local project=${CodeProject}
			case ${project} in
				none)
					if [ ! -z "${TheNew}" ]; then
						TheOld=$(UseC++ "removeExt" ${TheOld})
						TheNew=$(UseC++ "removeExt" ${TheNew})

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
							TheOld=$(UseC++ "removeExt" ${TheOld})
							TheNew=$(UseC++ "removeExt" ${TheNew})
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
							local TheCount=$(UseC++ "getProjSrc" "${TheOld}" | wc -l)
							case ${TheCount} in
								1)
									local TheFound=$(UseC++ "getProjSrc" "${TheOld}")
									#Get the dir
									TheDir=${TheFound%/*}
									#Get the file
									TheFound=${TheFound##*/}
									#Remove the extention
									TheOld=$(UseC++ "removeExt" ${TheOld})"
									TheNew=$(UseC++ "removeExt" ${TheNew})"
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
UseC++ $@
