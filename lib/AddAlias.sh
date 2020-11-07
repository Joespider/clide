Aliases=~/.bash_aliases
#Handle Aliases
AddAlias()
{
        local AliasName=$1
        local Command="$2 $3"
        local Insert="alias ${AliasName}=\"${Command} \$@\""
        if [[ "$USER" == "root" ]]; then
                Replace="\\$HOME\\/"
        else
                Replace="\\/home\\/$USER\\/"
        fi
        local With="\~\\/"
        local CheckFor=$(echo ${Insert} | sed "s/${Replace}/${With}/g")
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
