Shell=$(which bash)
#!${Shell}

SupportV="0.1.18"

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
			echo -e "new <file>\t\t\t: \"create new ${Lang} script\""
			echo -e "cpl, compile\t\t\t: \"make code executable\""
			;;
		pgLang)
			local HasLang=$(which ${RubyRun} 2> /dev/null)
			if [ ! -z "${HasLang}" ]; then
				#Return Ruby tag
				echo "Ruby"
			else
				#Return rejection
				echo "no"
			fi
			;;
		getCode)
			local name=$1
			case ${CodeProject} in
				none)
					if [ -f ${LangSrc}/${name}.rb ]; then
						echo ${name}.rb
					elif [ -f ${LangSrc}/${name} ]; then
						echo ${name}
					fi
					;;
				*)
					if [ -f ${LangSrc}/${CodeProject}/src/${name}.rb ]; then
						echo ${name}.rb
					elif [ -f ${LangSrc}/${CodeProject}/src/${name} ]; then
						echo ${name}
					fi
					;;
			esac
			;;
		BeforeFiles|AfterFiles)
			ls *.rb
			;;
		pgDir)
			#Return Ruby src Dir
			echo ${LangSrc}
			;;
		CreateHelp)
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
				echo -n "${TemplateCode##*/} "
				${RubyRun} ${TemplateCode} 2> /dev/null | grep Version | sed "s/Version//g"
			else
				echo "no ${TemplateCode##*/} found"
			fi
			;;
		CplVersion)
			echo "[Ruby Shell]"
			${RubyRun} --version
			echo ""
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
			local name=$2
			local keep=$3
			local project=${CodeProject}
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
								#Check if Ruby Script does NOT exists
								if [ ! -f "${TheBinDir}/${name}" ]; then
									#Change to Ruby Binary dir
									cd ${TheBinDir}
									#Create Symbolic Link to Ruby Script
									ERROR=$(ln -s ../src/${name} 2>&1 | tr '\n' '|')
									#Change to Ruby Source dir
									cd - > /dev/null
									if [ -f "${TheBinDir}/${name}" ]; then
										echo -e "\e[1;41m[Ruby Code Compiled]\e[0m"
									else
										ERROR=$(echo ${ERROR} | tr '|' '\n')
										echo -en "\e[1;31m[\e[0m"
										echo -en "\e[1;41mERROR\e[0m"
										echo -e "\e[1;31m]\e[0m"
										echo -e "\e[1;31m${ERROR}\e[0m"
									fi
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
						if [ ! -f "${TheBinDir}/${src}" ]; then
							#Change to Ruby Binary dir
							cd ${TheBinDir}
							#Create Symbolic Link to Ruby Script
							ERROR=$(ln -s ../src/${src} 2>&1 | tr '\n' '|')
							#Change to Ruby Source dir
							cd - > /dev/null
							if [ -f "${TheBinDir}/${src}" ]; then
								echo -e "\e[1;41m[Ruby Code Compiled]\e[0m"
							else
								ERROR=$(echo ${ERROR} | tr '|' '\n')
								echo -en "\e[1;31m[\e[0m"
								echo -en "\e[1;41mERROR\e[0m"
								echo -e "\e[1;31m]\e[0m"
								echo -e "\e[1;31m${ERROR}\e[0m"
							fi
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
			local project=$1
			local type=$2
			local path=${LangSrc}/${project}
			if [ ! -d ${path} ]; then
				mkdir ${path}
				mkdir ${path}/src
				mkdir ${path}/bin
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
			local cLang=$(UseRuby "color")
			local cTemplate=$(OtherColor ${TemplateCode##*/})
			#Check for Custom Code Template
			if [ -f ${TemplateCode} ]; then
				echo -n "${cLang}\$ ${RubyRun} ${cTemplate} "
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
		cli)
			local TheName=$(OtherColor $1)
			echo "${RubyRun} ${TheName}"
			;;
		runCode)
                        local name=$1
                        local TheBin="${name}"
                        local project=${CodeProject}
                        local TheBinDir
                        shift
                        shift
                        local Args=$@
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
			#Check if Ruby Bin exists
			if [ -f ${TheBinDir}/${TheBin} ]; then
				${RubyRun} ${TheBinDir}/${TheBin} ${Args[@]}
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
				TheOld="${TheOld%.rb}" 
				TheNew="${TheNew%.rb}"
				mv ${LangSrc}/${TheOld}.rb ${LangSrc}/${TheNew}.rb
				echo ${TheNew}.rb
			fi
			;;
		copy)
			local TheOld=$1
			local TheNew=$2
			if [ ! -z "${TheNew}" ]; then
				TheOld="${TheOld%.rb}" 
				TheNew="${TheNew%.rb}"
				cp ${LangSrc}/${TheOld}.rb ${LangSrc}/${TheNew}.rb
				echo ${TheNew}.rb
			fi
			;;
		*)
			;;
	esac
}

UseRuby $@
