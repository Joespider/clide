Shell=$(which bash)
#!${Shell}

#make files: https://www3.ntu.edu.sg/home/ehchua/programming/cpp/gcc_make.html
#Link Libs: https://gist.github.com/gubatron/32f82053596c24b6bec6
#both https://avikdas.com/2019/12/16/makefiles-for-c-cpp-projects.html

SupportV="0.2.11"
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
	${LibDir}/ProjectTemplateHandler.sh ${Lang} $@
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
		getExt)
			echo ${LangExt}
			;;
		getOtherExt)
			echo ${LangOtherExt}
			;;
		getMakeFile)
			local project=$1
			local TheMakeFile="${LangProject}/${project}/makefile"
			if [ -f ${TheMakeFile} ]; then
				echo ${TheMakeFile}
			fi
			;;
		SupportVersion)
			echo ${SupportV}
			;;
		makeHelp)
			echo -e "make help page"
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
			local UseProjectTemplate
			case ${project} in
				none)
					echo ${LangProject}
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					echo ${LangProject}/${project}
					;;
			esac
			;;
		getProjSrc)
			local name=$1
			local project=${CodeProject}
			local TheSrcDir=${LangProject}/${project}/src
			if [ ! -z "${name}" ]; then
				case ${name} in
					${LangExt})
						find ${TheSrcDir} -name *".cpp" 2> /dev/null
						find ${TheSrcDir} -name *".cc" 2> /dev/null
						find ${TheSrcDir} -name *".cxx" 2> /dev/null
						find ${TheSrcDir} -name *".c++" 2> /dev/null
						;;
					${LangOtherExt})
						find ${TheSrcDir} -name *".h" 2> /dev/null
						find ${TheSrcDir} -name *".hh" 2> /dev/null
						find ${TheSrcDir} -name *".hpp" 2> /dev/null
						find ${TheSrcDir} -name *".hxx" 2> /dev/null
						find ${TheSrcDir} -name *".h++" 2> /dev/null
						;;
					*)
						find ${TheSrcDir} -name "${name}" 2> /dev/null
						;;
				esac
			fi
			;;
		IsDebugEnabled)
			local DebugFlag=$(echo ${CplArgs//,/ } | grep -w "\-g")
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
				echo "${debugV}"
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
		FindTheSrc|FindTheHeader)
			local name=$1
			local project=${CodeProject}
			local CheckForFile
			local ThePossible
			local ext
			if [ ! -z "${name}" ]; then
				case ${project} in
					none)
						case ${Type} in
							FindTheSrc)
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
							FindTheHeader)
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
								;;
						esac

						;;
					*)
						case ${Type} in
							FindTheSrc)
								ext=${LangExt}
								ThePossible=".cpp,.cc,.cxx,.c++"
								;;
							FindTheHeader)
								ext=${LangOtherExt}
								ThePossible=".h,.hh,.hpp,.hxx,.h++"
								;;
							*)
								;;
						esac
						CheckForFile=$(UseC++ "getProjSrc" ${name}${ext} 2> /dev/null)
						if [ -z "${CheckForFile}" ]; then
							for ext in ${ThePossible//,/ };
							do
								CheckForFile=$(UseC++ "getProjSrc" ${name}${ext} 2> /dev/null)
								if [ ! -z "${CheckForFile}" ]; then
									echo ${CheckForFile}
									break
								fi
								look=$((${look}+1))
							done
						else
							echo ${CheckForFile}
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
				for TheItem in ${srcCode//,/ } ;
				do
					#Choose one item
					TheItem=$(UseC++ "removeExt" ${TheItem})

					#Look for binary from list of compiled
					TheCpl=$(echo -e "${CplList//|/\\n}" | grep -w ${TheItem})
					if [ ! -z "${TheCpl}" ]; then
						break
					fi
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
			local UseProjectTemplate
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
							UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
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
			echo -e "make\t\t\t\t: create makefile"
			echo -e "version, -std=<c++#>\t\t: compile with a specific version"
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
			echo -e "\e[1;4${ColorNum}m[${Lang} Compiler]\e[0m"
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
											newName=$(UseC++ "FindTheSrc" ${name})
											if [ -z "${newName}" ]; then
												CheckForHeader=$(UseC++ "getProjSrc" ${new}${LangOtherExt} 2> /dev/null)
												#Using default header
												if [ ! -z "${CheckForHeader}" ]; then
													name="${name}${LangOtherExt}"
												#Look for other header types
												else
													newName=$(UseC++ "FindTheHeader" ${name})
													name=${newName##*/}
												fi
											else
												name=${newName}
											fi
											newName=""
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
											#selected source code has defailt extensions
											*${LangExt}|*${LangOtherExt})
												;;
											#Add cpp or header files without file extensions
											*)
												#evaluate selected source code so as to know to add headers or not
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
														#Evaluate if file exists by extension
														HasAnExtSrc=$(UseC++ "hasExtForSrc" ${new})
														HasAnExtHeader=$(UseC++ "hasExtForHeader" ${new})
														if [ -z "${HasAnExtSrc}" ] || [ -z "${HasAnExtHeader}" ]; then
															new=$(UseC++ "removeExt" ${new})
															CheckForCpp=$(UseC++ "FindTheSrc" ${new})
															CheckForHeader=$(UseC++ "FindTheHeader" ${new})
															#Append cpp files
															if [ ! -z "${CheckForCpp}" ]; then
																new=${CheckForCpp##*/}
															#Append header files
															elif [ ! -z "${CheckForHeader}" ]; then
																new=${CheckForHeader##*/}
															fi
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
			local UseProjectTemplate

			if [ -z "${name}" ]; then
				case ${project} in
					none)
						;;
					*)
						UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
						name=${project}
						;;
				esac
			fi

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
					name=${name}${LangExt}
					;;
				*)
					;;
			esac
			if [ -f ${ThePath}/${name} ]; then
				echo ${ThePath}/${name}
			else
				case ${Type} in
					rmSrc)
						cd ${ThePath}/
						name=$(UseC++ "removeExt" ${name})
						theSrc=$(UseC++ "FindTheSrc" ${name})
						cd -> /dev/null
						if [ ! -z "${theSrc}" ]; then
							echo ${theSrc}
						fi
						;;
					*)
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
										num=$(echo -e "${src//,/\\n}" | grep ${num})
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
		handleCplArgs)
			local project=${CodeProject}
			local HasAutoInFunction
			local NeedThreads
			local HasXlib
			local HasXutil
			local HasXos
			local src=$1
			src=${src//,/ }
			local cplArgs=$2
			cplArgs=${cplArgs//,/ }

			case ${CplArgs} in
				none)
					cplArgs=""
					;;
				*)
					;;
			esac

			case ${project} in
				none)
					if [ ! -z "${src}" ]; then
						HasAutoInFunction=$(grep -E \(*auto*\) ${src} 2> /dev/null)
						NeedThreads=$(grep "#include <thread>" ${src} 2> /dev/null)
						HasXlib=$(grep "#include <X11/Xlib.h>" ${src} 2> /dev/null)
						HasXutil=$(grep "#include <X11/Xutil.h>" ${src} 2> /dev/null)
						HasXos=$(grep "#include <X11/Xos.h>" ${src} 2> /dev/null)
					fi
					;;
				*)
					#Look in headers
					local GetHeaders=$(UseC++ "getProjSrc" ${LangOtherExt})
					local GetSrc=$(UseC++ "getProjSrc" ${LangExt})

					#Check headers for ALL values
					if [ ! -z "${GetHeaders}" ]; then
						HasAutoInFunction=$(grep -E \(*auto*\) "${GetHeaders}" 2> /dev/null)
						NeedThreads=$(grep "#include <thread>" "${GetHeaders}" 2> /dev/null)
						HasXlib=$(grep "#include <X11/Xlib.h>" "${GetHeaders}" 2> /dev/null)
						HasXutil=$(grep "#include <X11/Xutil.h>" "${GetHeaders}" 2> /dev/null)
						HasXos=$(grep "#include <X11/Xos.h>" "${GetHeaders}" 2> /dev/null)
					fi

					#Nothing found
					if [ ! -z "${GetSrc}" ]; then
						if [ -z "${HasAutoInFunction}" ]; then
							HasAutoInFunction=$(grep -E \(*auto*\) "${GetHeaders}" 2> /dev/null)
						fi

						if [ -z "${NeedThreads}" ]; then
							#Look in source code
							NeedThreads=$(grep "#include <thread>" "${GetSrc}" 2> /dev/null)
						fi

						if [ -z "${HasXlib}" ] && [ -z "${HasXutil}" ] && [ -z "${HasXos}" ]; then
							HasXlib=$(grep "#include <X11/Xlib.h>" "${GetSrc}" 2> /dev/null)
							HasXutil=$(grep "#include <X11/Xutil.h>" "${GetSrc}" 2> /dev/null)
							HasXos=$(grep "#include <X11/Xos.h>" "${GetSrc}" 2> /dev/null)
						fi
					fi

					;;
			esac

			#[auto] Compile for auto in function
			#{
			if [ ! -z "${HasAutoInFunction}" ]; then
				case ${cplArgs} in
					*"-fconcepts"*)
						;;
					*)
						if [ -z "${cplArgs}" ]; then
							cplArgs="-fconcepts"
						else
							cplArgs="${cplArgs} -fconcepts"
						fi
						;;
				esac
			fi
			#}

			#[Threads] Compile for Threads
			#{
			if [ ! -z "${NeedThreads}" ]; then
				case ${cplArgs} in
					*"-lpthread"*)
						;;
					*)
						if [ -z "${cplArgs}" ]; then
							cplArgs="-lpthread"
						else
							cplArgs="${cplArgs} -lpthread"
						fi
						;;
				esac
			fi
			#}

			#[X11] Compile with X11 code
			#{
			if [ ! -z "${HasXlib}" ] || [ ! -z "${HasXutil}" ] || [ ! -z "${HasXos}" ]; then
				case ${cplArgs} in
					*"-I /usr/X11/include -L /usr/X11/lib -lX11"*)
						;;
					*)
						if [ -z "${cplArgs}" ]; then
							cplArgs="-I /usr/X11/include -L /usr/X11/lib -lX11"
						else
							cplArgs="${cplArgs} -I /usr/X11/include -L /usr/X11/lib -lX11"
						fi
					;;
				esac
			fi
			#}

			echo ${cplArgs// /,}
			;;
		setCplArgs)
			shift
			shift
			local Vals="none"
			local Item=""
			local str=$@
			# space is set as delimiter
			local IFS=' '
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
						-c|--concepts)
							Item="-fconcepts"
							;;
						-t|--thread)
							Item="-lpthread"
							;;
						-x|--gui)
							Item="-I /usr/X11/include -L /usr/X11/lib -lX11"
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
			echo -e "--c, --concepts\t\t: \"Set concepts (-fconcepts)\""
			echo -e "-t, --thread\t\t: \"Set Threading (-lpthread)\""
			echo -e "-x, --gui\t\t: \"Set GUI (-I /usr/X11/include -L /usr/X11/lib -lX11)\""
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
		compileCodeMake-message)
			echo -e "\e[1;4${ColorNum}m[${Lang} Code Compiled (MAKE)]\e[0m"
			;;
		compileCode)
			local src=$1
			local name=$2
			local cplArgs=${CplArgs//,/ }
			local IsVerbose
			local project=${CodeProject}
			local HasAnExt
			local ReplaceTheSrcDir
			local TheSrcDir
			local TheBinDir
			local ERROR
			local FoundMain="yes"
			local NumOfMain
			local UseProjectTemplate

			#Handle multiple files
			if [ -z "${name}" ]; then
				case ${src} in
					*,*)
						src=${src//,/ }
						name=$(grep -l "int main(" ${src} 2> /dev/null)
						if [ -z "${name}" ]; then
							FoundMain="no"
						else
							NumOfMain=$(echo -e "${name// /\\n}" | wc -l)
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
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
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
					ERROR=$(make 1> /dev/null 2>&1 | tr '\n' '|')
					cd - > /dev/null
					#Code compiled did compile
					if [ -z "${ERROR}" ]; then
						UseC++ compileCodeMake-message
					#Code compiled did NOT compile
					else
						#display the ERROR message
						errorCode "cpl" "ERROR" "${ERROR}"
					fi
				#Compile without makefile
				else
					#source file is empty
					if [ -z "${name}" ]; then
						errorCode "cpl" "choose"
					else
						case ${FoundMain} in
							yes)
								local CheckSrc=${src// /,}
								cplArgs=${cplArgs// /,}
								cplArgs=$(UseC++ "handleCplArgs" ${CheckSrc} ${cplArgs})
								cplArgs=${cplArgs//,/ }

								#Handle Verbose
								#{
								IsVerbose=$(echo ${cplArgs} | grep -w "\-v" 2> /dev/null)
								#}
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
			local src=$1
			src="${src//,/ /}"
			local UseProjectTemplate
			case ${CodeProject} in
				#No Project
				none)
					errorCode "make" "need-to-be-project" ${Lang}
					;;
				#Is a project
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					#makefile already exists\
					if [ -f ${LangProject}/${CodeProject}/makefile ]; then
						errorCode "make" "already"
					else
						local TheMakeArgs
						local cplArgs=${CplArgs// /,}
						if [ ! -z "${src}" ]; then
							local CheckSrc=${src// /,}
							cplArgs=$(UseC++ "handleCplArgs" "${CheckSrc}" ${cplArgs})
						else
							cplArgs=$(UseC++ "handleCplArgs" "none" ${cplArgs})
						fi
                                                cplArgs=${cplArgs//,/ }
                                                if [ -z "${cplArgs}" ]; then
							if [ ! -z "${src}" ]; then
								TheMakeArgs="CC = ${LangCpl}\n\nVPATH=src\n\nall: ${CodeProject}\n\n${CodeProject}: ${src}\n\t\$(CC) -o bin/\$@ \$<"
							else
								TheMakeArgs="CC = ${LangCpl}\n\nall: ${CodeProject}\n\n${CodeProject}:\n\t\$(CC) -o bin/${CodeProject} src/"
							fi
						else
							if [ ! -z "${src}" ]; then
								TheMakeArgs="CC = ${LangCpl}\nCFLAGS = ${cplArgs}\n\nVPATH=src\n\nall: ${CodeProject}\n\n${CodeProject}: ${src}\n\t\$(CC) -o bin/\$@ \$< \$(CFLAGS)"
							else
								TheMakeArgs="CC = ${LangCpl}\nCFLAGS = ${cplArgs}\n\nall: ${CodeProject}\n\n${CodeProject}:\n\t\$(CC) -o bin/${CodeProject} src/ \$(CFLAGS)"
							fi
						fi
						touch ${LangProject}/${CodeProject}/makefile
						echo -e "${TheMakeArgs}" > ${LangProject}/${CodeProject}/makefile
						errorCode "HINT" "makefile Created"
					fi
					;;
			esac
			;;
		edit-make)
			case ${CodeProject} in
				#No Project
				none)
					;;
				#Is a project
				*)
					#makefile already exists
					if [ -f ${LangProject}/${CodeProject}/makefile ]; then
						${editor} ${LangProject}/${CodeProject}/makefile
					else
						errorCode "make" "edit-make"
					fi
					;;
			esac
			;;
		disable-make)
			case ${CodeProject} in
				#No Project
				none)
					errorCode "make" "need-to-be-project" ${Lang}
					;;
				#Is a project
				*)
					#makefile already exists
					if [ -f ${LangProject}/${CodeProject}/makefile ]; then
						mv ${LangProject}/${CodeProject}/makefile ${LangProject}/${CodeProject}/makeDisabled
						errorCode "HINT" "makefile disabled"
					fi
					;;
			esac
			;;
		enable-make)
			case ${CodeProject} in
				#No Project
				none)
					errorCode "make" "need-to-be-project" ${Lang}
					;;
				#Is a project
				*)
					#makefile already exists
					if [ -f ${LangProject}/${CodeProject}/makeDisabled ]; then
						mv ${LangProject}/${CodeProject}/makeDisabled ${LangProject}/${CodeProject}/makefile
						errorCode "HINT" "makefile enabled"
					fi
					;;
			esac
			;;
		delete-make)
			case ${CodeProject} in
				#No Project
				none)
					errorCode "make" "need-to-be-project" ${Lang}
					;;
				#Is a project
				*)
					#makefile already exists
					if [ -f ${LangProject}/${CodeProject}/makeDisabled ]; then
						rm ${LangProject}/${CodeProject}/makeDisabled
					fi

					if [ -f ${LangProject}/${CodeProject}/makefile ]; then
						rm ${LangProject}/${CodeProject}/makefile
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
			echo ${LangProject}
			;;
		newProject)
			local ProjectType=$1
			local project=$2
			local path=${LangProject}/${project}
			local UseProjectTemplate
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
						;;
					*)
						UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
						mkdir ${path}
						if [ ! -z "${UseProjectTemplate}" ]; then
							ProjectTemplateHandler ${EnvVars[@]} ${Type} ${project}
							if [ ! -d ${path}/bin ]; then
								mkdir ${path}/bin
							fi
							if [ ! -d ${path}/src ]; then
								mkdir ${path}/src
							fi
						else
							mkdir ${path}/bin
							mkdir ${path}/build
							mkdir ${path}/doc
							mkdir ${path}/include
							mkdir ${path}/lib
							mkdir ${path}/spike
							mkdir ${path}/src
							mkdir ${path}/test
							mkdir ${path}/bin
							mkdir ${path}/src
						fi
						;;
				esac
				cd ${path}/src
			else
				cd ${path}/src
			fi
			echo ${path}
			;;
		projectMode)
			local mode=$1
			local UseProjectTemplate
			case ${ProjectType} in
				Generic)
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					if [ ! -z "${UseProjectTemplate}" ]; then
						ProjectTemplateHandler ${EnvVars[@]} ${Type} ${mode}
					fi
					;;
			esac
			;;
		lscpl)
			local project=${CodeProject}
			local path
			local UseProjectTemplate
			case ${CodeProject} in
				none)
					path=${LangBin}/
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					path=${LangProject}/${project}/bin
					;;
			esac
			if [ -d ${path} ]; then
				ls ${path}
			fi
			;;
		Install|exe-string)
			local bin=$1
			local BinFile=$(UseC++ "removeExt" ${bin%.*})
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

			case ${Type} in
				Install)
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
				exe-string)
					#Make sure Binary exists
					if [ -f "${TheBinDir}/${BinFile}" ]; then
						echo "${TheBinDir}/${BinFile}"
					fi
					;;
				*)
					;;
			esac
			;;
		customCode)
			local cLang=$(UseC++ "color")
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
			local CodeType=$2
			local TheName
			local oldCode=$3
			local project=${CodeProject}
			local HasAHeaderExt
			local IsNotAType
			local UseProjectTemplate

			#Sometimes "oldCode" gets passed as "CodeType"
			if [ -z "${oldCode}" ]; then
				IsNotAType=$(UseC++ "hasExtForAll" ${CodeType})
				case ${IsNotAType} in
					yes)
						oldCode=${CodeType}
						CodeType=""
	
						;;
					*)
						;;
				esac
			fi

			case ${project} in
				none)
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					;;
			esac

			CodeType=${CodeType,,}

			HasAHeaderExt=$(UseC++ "hasExtForHeader" ${name})
			case ${HasAHeaderExt} in
				yes)
					name=$(UseC++ "removeExt" ${name})
					CodeType="header"
					;;
				*)
					name=$(UseC++ "removeExt" ${name})
					;;
			esac

			if [ ! -f ${name}${LangExt} ] || [ ! -f ${name}${LangOtherExt} ]; then
				case ${CodeType} in
					#create header file
					header)
						if [ ! -f ${name}${LangOtherExt} ]; then
							if [ -z "${UseProjectTemplate}" ]; then
								#Program Name Given
								if [ ! -z "${name}" ]; then
									touch "${name}${LangOtherExt}"
									echo "#pragma once" > "${name}${LangOtherExt}"
								else
									errorCode "newCode"
								fi
							else
								ProjectTemplateHandler ${ProjectType} ${Type} ${name}${LangOtherExt} ${CodeType}
							fi
						fi
						;;
					#create main file
					main)
						if [ ! -f ${name}${LangExt} ]; then
							if [ -z "${UseProjectTemplate}" ]; then
								#Check for Custom Code Template
								if [ -f ${TemplateCode} ]; then
									#Program Name Given
									if [ ! -z "${name}" ]; then
										${TemplateCode} --random --write-file --read-file --cli --main --is-in --user-input --name "${name}" --ext "${LangExt}"
									#No Program Name Given
									else
										#Help Page
										${TemplateCode} --help
									fi
								else
									#Program Name Given
									if [ ! -z "${name}" ]; then
										local Content="#include <iostream>\n\n//${Lang} Main\nint main()\n{\n\n\treturn 0;\n}"
										touch ${name}${LangExt}
										echo -e "${Content}" > ${name}${LangExt}
									else
										errorCode "newCode"
									fi
								fi
							else
								ProjectTemplateHandler ${ProjectType} ${Type} ${name}${LangExt} ${CodeType}
							fi
						fi
						;;
					#create component file
					component)
						if [ ! -f ${name}${LangExt} ]; then
							if [ -z "${UseProjectTemplate}" ]; then
								if [ -f ${TemplateCode} ]; then
									#Program Name Given
									if [ ! -z "${name}" ]; then
										${TemplateCode} -n "${name}" --ext "${LangExt}"
									#No Program Name Given
									else
										#Help Page
										${TemplateCode} --help
									fi
								else
									#Program Name Given
									if [ ! -z "${name}" ]; then
										touch ${name}${LangExt}
									else
										errorCode "newCode"
									fi
								fi
							else
								ProjectTemplateHandler ${ProjectType} ${Type} ${name}${LangExt} ${CodeType}
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
			local UseProjectTemplate
			#Handle Project Dir
			case ${project} in
				none)
					TheName=$(OtherColor "${TheName%.*}")
					echo "./${TheName}"
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					TheName=$(OtherColor "${project}")
					echo "./${TheName}"
					;;
			esac
			;;
		#Run the compiled code
		runCode|debug)
			local name=$1
			local UseProjectTemplate

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
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
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
							name=${name//,/ }
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
			local UseProjectTemplate

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
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
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
		#create a copy of set code
		copy|rename)
			local Src=$1
			local New=$2
			local TheOld
			local TheNew
			local project=${CodeProject}
			local UseProjectTemplate
			case ${project} in
				none)
					if [ ! -z "${New}" ]; then
						TheOld=$(UseC++ "removeExt" ${Src})
						TheNew=$(UseC++ "removeExt" ${New})

						#Remove old file for "rename"
						case ${Type} in
							rename)
								mv ${LangSrc}/${TheOld}${LangExt} ${LangSrc}/${TheNew}${LangExt}
								;;
							copy)
								cp ${LangSrc}/${TheOld}${LangExt} ${LangSrc}/${TheNew}${LangExt}
								;;
							*)
								;;
						esac

						#return new file
						echo ${TheNew}${LangExt}
					fi
					;;
				*)
					UseProjectTemplate=$(ProjectTemplateHandler ${ProjectType} --check ${Type})
					#Check if extenion is given
					local HasAnExt
					local HasAnExtSrc
					local HasAnExtHeader
					local CheckForCpp
					local CheckForHeader
					local ThePath

					HasAnExt=$(UseC++ "hasExtForAll" ${Src})
					#Extension is NOT given
					if [ -z "${HasAnExt}" ]; then
						if [ ! -f ${Src} ]; then
							#Evaluate if file exists by extension
							HasAnExtSrc=$(UseC++ "hasExtForSrc" ${Src})
							HasAnExtHeader=$(UseC++ "hasExtForHeader" ${Src})
							#selected in priority...default src
							if [ -z "${HasAnExtSrc}" ]; then
								name=$(UseC++ "removeExt" ${Src})
								#Find src
								CheckForCpp=$(UseC++ "getProjSrc" ${name}${LangExt} 2> /dev/null)
								ThePath=${CheckForCpp%/*}
								Src=${CheckForCpp##*/}
								#default header
							elif [ -z "${HasAnExtHeader}" ]; then
								#Find header
								CheckForHeader=$(UseC++ "getProjSrc" ${name}${LangOtherExt} 2> /dev/null)
								ThePath=${CheckForHeader%/*}
							fi
						fi
					else
						if [ ! -f ${Src} ]; then
							CheckForFile=$(UseC++ "getProjSrc" ${Src} 2> /dev/null)
							if [ ! -z "${CheckForFile}" ]; then
								HasAnExtSrc=$(UseC++ "hasExtForSrc" ${Src})
								HasAnExtHeader=$(UseC++ "hasExtForHeader" ${Src})
								ThePath=${CheckForFile%/*}
							fi
						else
							HasAnExtSrc=$(UseC++ "hasExtForSrc" ${Src})
							HasAnExtHeader=$(UseC++ "hasExtForHeader" ${Src})
						fi
					fi

					TheOld=${Src}

					HasAnExt=$(UseC++ "hasExtForAll" ${New})
					if [ -z "${HasAnExt}" ]; then
						if [ ! -z "${HasAnExtSrc}" ]; then
							TheNew="${New}${LangExt}"
						elif [ ! -z "${HasAnExtHeader}" ]; then
							TheNew="${New}${LangOtherExt}"
						fi
					else
						TheNew=${New}
					fi

					if [ ! -z "${TheOld}" ] && [ ! -z "${TheNew}" ]; then
						if [ ! -z "${ThePath}" ]; then
							cd ${ThePath}
							case ${Type} in
								rename)
									mv ${TheOld} ${TheNew}
									;;
								copy)
									cp ${TheOld} ${TheNew}
									;;
								*)
									;;
							esac
							echo ${TheNew}
							cd - > /dev/null
						else
							case ${Type} in
								rename)
									mv ${TheOld} ${TheNew}
									;;
								copy)
									cp ${TheOld} ${TheNew}
									;;
								*)
									;;
							esac
							echo ${TheNew}
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
