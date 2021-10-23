Shell=$(which bash)
#!${Shell}

errorCode()
{
	${LibDir}/errorCode.sh $@
}


TemplateHandler()
{
	local Lang=$1
	local ProjectType=$2
	local Job=$3
	local Action=$3
	case ${Action} in
		#Meant for Lang.<lang> to determine if actiont exists
		--check)
			Job=$4
			if [ -d ${TemplateProjectDir}/${Lang}.${ProjectType} ] && [ -f ${TemplateProjectDir}/${Lang}.${ProjectType}/${Job} ] && [ -x ${TemplateProjectDir}/${Lang}.${ProjectType}/${Job} ]; then
				local Content=$(cat ${TemplateProjectDir}/${Lang}.${ProjectType}/${Job})
				if [ ! -z "${Content}" ]; then
					echo "yes"
				fi
			fi
			;;
		*)
			case ${ProjectType} in
				${ProjectDefaultType})
					;;
				*)
					if [ -d ${TemplateProjectDir}/${Lang}.${ProjectType} ] && [ -f ${TemplateProjectDir}/${Lang}.${ProjectType}/${Job} ]; then
						shift
						shift
						shift
						${TemplateProjectDir}/${Lang}.${ProjectType}/${Job} $@
					fi
					;;
			esac
			;;
	esac
}

TemplateHandler $@
