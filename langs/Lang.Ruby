Shell=$(which bash)
#!${Shell}

ProgDir=$1
shift
ClideDir=$1
LibDir=${ClideDir}/lib
shift
editor=$1
shift
ReadBy=$1
shift
project=$1
shift
CplArgs=$1
shift

SupportVersion()
{
        echo "0.1.01"
}

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

UserRuby()
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
			if [ -f ${LangSrc}/${name}.rb ]; then
				echo ${name}.rb
			elif [ -f ${LangSrc}/${name} ]; then
				echo ${name}
			fi
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
			local path=${LangSrc}/${project}
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
		cli)
			local TheName=$(OtherColor $1)
			echo "${RubyRun} ${TheName}"
			;;
		runCode)
			local name=$1
			local TheBin=${name}
			shift
			local Args=$@
			#Check if Ruby Bin exists
			if [ -f ${LangBin}/${TheBin} ]; then
				${RubyRun} ${LangBin}/${TheBin} ${Args[@]}
			else
				errorCode "cpl" "need" "${name}"
			fi
			;;
		*)
			;;
	esac
}

UserRuby $@
