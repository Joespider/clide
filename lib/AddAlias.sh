Aliases=~/.bash_aliases
ShellPath=$(realpath $0)
root=$(dirname ${ShellPath})

errorCode()
{
	${root}/errorCode.sh $@
}

#Handle Aliases
AddAlias()
{
        local AliasName=$1
	shift
        local Command="$@"
        local Insert="alias ${AliasName}=\"${Command} \$@\""
        if [[ "$USER" == "root" ]]; then
                Replace="\\$HOME\\/"
        else
                Replace="\\/home\\/$USER\\/"
        fi
        local With="\~\\/"
        local CheckFor=${Insert//${Replace}/${With}}
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
                        sed  -i "s/${Replace}/${With}/g" ${Aliases}
                        echo "\"${AliasName}\" installed"
                fi
        fi
}

AddAlias $@
