# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

    # uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/conda/etc/profile.d/conda.sh" ]; then
        . "/opt/conda/etc/profile.d/conda.sh"
    else
        export PATH="/opt/conda/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<



# ----------------------------------------------------- my stuff -----------------------------------------------------  
# go
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
export GOPRIVATE=gitlab.spectral.energy/*

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv virtualenv-init -)"

# kubectl - this is needed because kubectl no longer bundles google specific auth stuff - so you have to use the plugin for it
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# restic S3 API
export AWS_ACCESS_KEY_ID='003c9a95e059c500000000001'
export AWS_SECRET_ACCESS_KEY='K003o+Q4xVrpIaHcDVH66tSXA9VMRQ0'
export RESTIC_REPOSITORY='s3:s3.eu-central-003.backblazeb2.com/work-linux-backup'
export RESTIC_PASSWORD='IA&ld4v!BHY0WJ!noc5ZEzy*gRyPpOEOqZX5KM4$KFYb45nY*4'

# custom path
PATH=$PATH:/home/dylan/.local/bin
PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

# general stuff
alias ls='ls --color=auto --group-directories-first'
alias lo=$'ls -Ago --color=always | sed -re \'s/^[^ ]* //\''
alias la='ls -la'
alias mi='mv -i'
alias mf='mv -f'
alias mv='mv -nv'
alias ter='gnome-terminal . & disown'



# ----------------------------------------------------- scripts -----------------------------------------------------  
alias unzip_all='for z in *.zip; do unzip "$z" -d "${z%".zip"}"; done'

daemons() {
    ps -eo 'tty,pid,comm' | grep ^?
}
daemonsv2() {
    ps -ax
}
myfind() {
    if (( $# < 2 )); then
        echo "myfind location arg"
        return
    fi
    local location=$1
    local to_find="${@:2}"
    find $location -name $to_find 2>&1 | egrep -v 'find: '.*': Permission denied'
}
jwtd() {
    if [[ -x $(command -v jq) ]]; then
         jq -R 'split(".") | .[0],.[1] | @base64d | fromjson' <<< "${1}"
         echo "Signature: $(echo "${1}" | awk -F'.' '{print $3}')"
    fi
}



# ----------------------------------------------------- pyenv -----------------------------------------------------  
parse_dockerfile() {
    # parse Dockerfile in current folder and echo python version number
    if (( $# != 1 )); then
        echo "parse_dockerfile file"
        return
    fi

    local file=$1
    local item_re="^FROM python:"

    while read -r line; do
        if [[ $line =~ $item_re ]]; then
            # remove everything before :
            local version=${line#*:}
            local version_number=${version%%-*}
            echo $version_number
            return
        fi
    done < "$file"
}

# inits
eval "$(pyenv init -)"

# pyenv commands
alias pyenv_local='pyenv versions'

pyenv_list_remote() {
    # list remote versions available with regex python version parameter
    if (( $# != 1 )); then
        echo "pyenv_list_remote version_pattern"
        echo "  - version_string is grepped, so can be partial, i.e. '3.'"
        return
    fi
    local version_string=$1
    pyenv install --list | grep "^\s*${version_string}"
}

pyenv_get_latest_remote() {
    # get the latest version available for given regex python version parameter
    # TODO this picks up the '-dev' versions as the latest if on minor version 0
    # i.e. before 3.11.1 appears, the versions are
    # 3.11.0
    # 3.11-dev
    # so dev gets picked up as the latest version
    if (( $# != 1 )); then
        echo "pyenv_get_latest_remote version_pattern"
        echo "  - version_string is grepped, so can be partial, i.e. '3.'"
        return
    fi
    local version_string=$1
    # take last one and trim whitespace
    pyenv_list_remote $version_string | tail -n1 | xargs
    
    # lines=$(pyenv_list_remote $version_string)
    # IFS=$'\n'
    # there's a way to do this settings IFS, then doing $(lines), then taking the last one
}

pyenv_create_env() {
    # install and create env with actual version using folder name
    if (( $# != 1 )); then
        echo "pyenv_setup version"
        echo "  - folder name will be picked up automatically"
        return
    fi
    local py_version=$1
    pyenv install $py_version -s  # install but skip if exists
    local folder=${PWD##*/}
    local env_name="${folder}_${py_version}"
    pyenv virtualenv $py_version $env_name && pyenv local $env_name && pip install --upgrade pip && pip install pip-tools && pip install black
    # [ ] calls the test command
    if [ -f requirements.in ]; then
        pip-compile --no-emit-index-url requirements.in
    fi
    if [ -f requirements.txt ]; then
        pip install -r requirements.txt
    fi
    if [ -f dev-requirements.txt ]; then
        pip install -r dev-requirements.txt
    fi
}

pyenv_create_latest() {
    # take latest version of supplied python regex and create env using folder name
    if (( $# != 1 )); then
        echo "pyenv_install_latest python_version"
    fi
    local python_version_string=$1
    local latest_remote=$(pyenv_get_latest_remote $python_version_string)
    pyenv install $latest_remote -s  # install but skip if exists
    pyenv_create_env $latest_remote
}

pyenv_create_from_dockerfile() {
    # take python version from dockerfile and create env using version as regex and folder name
    local python_version_string=$(parse_dockerfile Dockerfile)
    pyenv_create_latest $python_version_string
}



# ----------------------------------------------------- git -----------------------------------------------------  
git_rpl() {
    git fetch -p && git branch -r | awk '{print $1}' | egrep -v -f /dev/fd/0 <(git branch -vv | grep origin) | awk '{print $1}' | xargs git branch -d
}
git_reset() {
    git co master && git pull && git rpo && git_rpl
}
git_stash_reset() {
    git stash --include-untracked && git_reset && git stash apply
}
git_clone_setup() {
    if (( $# != 1 )); then
        echo "git_clone_setup url"
        echo "  - python version is taken from Dockerfile"
        return
    fi
    local url=$1
    # it should be possible to get folder in one command but it doesn't work...
    local url_without_ext=${url%%.git}
    local folder_name=${url_without_ext##*/}
    git clone $url && cd $folder_name
    
    pyenv_dockerfile
}



# ----------------------------------------------------- spectral -----------------------------------------------------  
run_port_forwards() {
   cd ~/Documents/spectral/repos/sbp/biz_apps/dap/dap/
   bash run_port_forwards.sh $@

}

export SP_USERNAME=dylan
export SP_PASSWORD=Elloh123!

__prod_cluster=gke_smart-building-platform_europe-west4-a_sbp
__test_cluster=gke_smart-building-platform-test_europe-west4-a_sbp-test

# two short aliases for manual cluster change
ctx_prod=--context=$__prod_cluster
ctx_test=--context=$__test_cluster

alias auth-pg="kbl sec get biz-apps client-database-config data --context='$__prod_cluster'"
alias auth-pg-test="kbl sec get biz-apps test-client-database-config data --context='$__test_cluster'"
alias auth-ts="kbl sec get lb authentication-service-config data --context='$__prod_cluster'"
alias auth-ts-test="kbl sec get lb authentication-service-config data --context='$__test_cluster'"
alias auth-keycloak="kbl sec get infra keycloak --context='$__prod_cluser'"
alias auth-keycloak-test="kbl sec get infra keycloak-test --context='$__test_cluser'"

# use context in timescale so we can mix and match - remove when full transfer to test cluster is over
alias port-forward-tsdataservice="kubectl -n lb port-forward svc/timeseries-io-tsdataservice 5003:5000 --context='$__prod_cluster'"
alias port-forward-tsdataservice-test="kubectl -n lb port-forward svc/timeseries-io-tsdataservice-test 5003:5000 --context='$__test_cluster'"
alias port-forward-timescale="kubectl -n infra port-forward svc/pg-timescale-proxy-production 2222:6543 --context='$__prod_cluster'"
# we use different port so that we differentiate in .pgpass
alias port-forward-timescale-test="kubectl -n infra port-forward svc/pg-timescale-proxy-test 2223:6543 --context='$__test_cluster'"
alias port-forward-rabbitmq="kubectl -n infra port-forward svc/rabbitmq 5672:5672 --context='$___prod_cluster'"
alias port-forward-rabbitmq-test="kubectl -n infra port-forward svc/rabbitmq-test 5672:5672 --context='$__test_cluster'"

alias psql-timescale="psql -U tsdbadmin -d defaultdb -h localhost -p 2222"
alias psql-timescale-test="psql -U tsdbadmin -d defaultdb -h localhost -p 2223"

auth_ts_args() {
    for z in ${@}; do kbl sec get lb authentication-service-config data | grep "${z^^}_API_KEY" | sed "s/${z^^}_API_KEY=/${z},/g"; done
}
auth_ts_args_all() {
    kbl sec get lb authentication-service-config data | grep '_API_KEY' | sed -E 's/(.*)_API_KEY=/\L\1\E,/g'
}
create_db() {
    ~/Documents/spectral/coding_tools/dbs/create_local_dbs $1
}

create_full_db() {
    create_db $1
    alembic upgrade head
    python -m dap_datamodel -populate common
    python -m dap_datamodel -populate $1
    python -m dap_customization recreate
}



# ----------------------------------------------------- kubectl -----------------------------------------------------  
# auto completion
source <(kubectl completion bash)

kbl() {
    if (( $# == 0 )); then
        echo "kbl sec"
        echo "kbl cronjob"
        echo "kbl job"
        echo "kbl context"
        
    elif (( $# > 0 )); then
        if [[ $1 == "sec" || $2 == "secret" ]]; then
            __kbl_sec "${@:2}"

        elif [[ $1 == "cronjob" ]]; then
            __kbl_cronjob "${@:2}"
            
        elif [[ $1 == "job" ]]; then
            __kbl_job "${@:2}"

        elif [[ $1 == "pod" ]]; then
            __kbl_pod "${@:2}"
            
        elif [[ $1 == "context" ]]; then
            __kbl_context "${@:2}"

        else
            echo "Unkown option '$1'"

        fi
    fi
}

__kbl_sec() {
    if (( $# < 1 )); then
        echo "kbl sec get"
        echo "kbl sec rep"
    
    elif [[ $1 == "get" ]]; then
        __kbl_sec_get "${@:2}"

    elif [[ $1 == "del" || $1 == "delete" ]]; then
        __kbl_sec_delete "${@:2}"

    elif [[ $1 == "rep" || $1 == "replace" ]]; then
        __kbl_sec_replace "${@:2}"

    fi
}

__kbl_sec_get() {
    if (( $# == 0 )); then
        kubectl get -A secret --field-selector type=Opaque

    elif (( $# == 1 )); then
        if [[ $1 == "--help" ]]; then
            echo "kbl sec get \$namespace \$secret_name \$file_name"

        else
            local namespace=$1
            kubectl -n $namespace get secret --field-selector type=Opaque

        fi

    elif (( $# == 2 )); then
        local namespace=$1
        local secret_name=$2

        kubectl -n $namespace get secret $secret_name -o json

    elif (( $# >= 3 )); then
        local namespace=$1
        local secret_name=$2
        local file_name
        
        if [[ $3 == "parse" || $3 == "parse-into" ]]; then
            # this sed command only works if the JSON at .data contains a single secret key value pair
            # it removes the surrounding syntax and key, leaving only the value behind (the base64 encoded secret)
            get_secret=$(kubectl -n $namespace get secret $secret_name -o jsonpath={.data} ${@:4} | sed "s/{\".*\":\"//g" | sed "s/\"}//g" | base64 -d)
            if [[ $3 == "parse-into" ]]; then
                echo "$get_secret" > $secret_name.yaml
            else
                echo "$get_secret"
            fi

        else
            if [[ $3 == "data" ]]; then
                if [[ $secret_name == *"settings"* ]]; then
                    file_name="settings\.yaml"

                elif [[ $secret_name == *"env"* ]]; then
                    file_name="\.env"

                elif [[ $secret_name == *"config"* ]]; then
                    file_name="\.config"

                fi

            elif [[ $3 == "env" ]]; then
                file_name="\.env"

            elif [[ $3 == "settings" ]]; then
                file_name="settings\.yaml"

            else
                file_name=$3

            fi
            
            # we pass any extra parameters to the original kubectl command, so we could provide flags
            kubectl -n $namespace get secret $secret_name -o jsonpath={.data.${file_name}} ${@:4} | base64 -d
        fi
    fi
}

__kbl_sec_delete() {
    if (( $# == 2 )); then
        local namespace=$1
        local secret_name=$2
    
        kubectl -n $namespace delete secret $secret_name
    	
    else
        echo "kbl sec del namespace secret_name"
    fi
}

__kbl_sec_replace() {
    if (( $# >= 2 & $# <=4 )); then
        if (( $# == 2 )); then
            local namespace=$1
            local secret_name=$2
            local file_name=settings\.yaml
            local local_file_name=$2\.yaml
        
        elif (( $# == 3 )); then
            local namespace=$1
            local secret_name=$2
            local file_name=$3
            local local_file_name=${2}${3}
        
        elif (( $# == 4 )); then
            local namespace=$1
            local secret_name=$2
            local file_name=$3
            local local_file_name=$4
        fi
    
        kubectl -n $namespace delete secret $secret_name
        kubectl -n $namespace create secret generic $secret_name --from-file=${file_name}=${local_file_name}
    	
    else
        echo "kbl sec rep namespace secret_name [file_name] [local_file_name]"
        echo ""
        echo "ts-puller-job-settings                     -> settings.yaml=ts-puller-job-settings.yaml"
        echo "ts-puller-job-settings .config             -> .config=ts-puller-job-setting.config"
        echo "ts-puller-job-settings .config test.config -> .config=test.config"
    fi
}

__kbl_cronjob() {
    if (( $# < 1 )); then
        echo "kbl cronjob get"
        echo "kbl cronjob create"
    
    elif [[ $1 == "get" ]]; then
        __kbl_cronjob_get "${@:2}"

    elif [[ $1 == "cre" || $1 == "create" ]]; then
        __kbl_create_from_cronjob "${@:2}"

    fi
}

__kbl_cronjob_get() {
    if (( $# == 0 )); then
        kubectl get cronjob -A

    elif (( $# == 1 )); then
        local namespace=$1
        kubectl get cronjob -n $namespace

    else
        echo "kbl cronjob get"
        echo "kbl cronjob get [namespace]"

    fi
}

__kbl_create_from_cronjob() {
    if (( $# == 2 )); then
        local namespace=$1
        local cronjob=$2
        kubectl create job -n $namespace --from=cronjob/$2 $2-manual-dylan

    else
        echo "kbl job|cronjob create [namespace] [cronjob]"

    fi
}

__kbl_job() {
    if [[ $1 == "get" ]]; then
        __kbl_job_get "${@:2}"

    elif [[ $1 == "cre" || $1 == "create" ]]; then
        __kbl_create_from_cronjob "${@:2}"

    elif [[ $1 == "del" || $1 == "delete" ]]; then
        __kbl_job_del "${@:2}"

    elif [[ $1 == "rec" || $1 == "recreate" ]]; then
        __kbl_job_del $2 $3-manual
        __kbl_create_from_cronjob "${@:2}"

    else
        echo "Arguments not understood: $@"
        echo "Supported commands:"
        echo "    kbl job get"
        echo "    kbl job cre|create"
        echo "    kbl job del"
        echo "    kbl job rec|recreate"
    fi
}

 __kbl_pod() {
     if (( $# < 1 )); then
         echo "kbl job get"
 
     elif [[ $1 == "get" ]]; then
         __kbl_pod_get "${@:2}"
 
     else
         echo "Arguments not understood: $@"
         echo "Supported commands:"
         echo "    kbl sec get"

     fi
 }

__kbl_pod_get() {
    if (( $# == 0 )); then
        kubectl get pod -A

    elif (( $# == 1 )); then
        local namespace=$1
        kubectl get pod -n $namespace

    else
        echo "Arguments not understood: $@"
        echo "Supported commands:"
        echo "    kbl pod get"
        echo "    kbl pod get [namespace]"

    fi
}

__kbl_job_del() {
    if (( $# == 2 )); then
        local namespace=$1
        local job_name=$2
        kubectl delete job -n $namespace $job_name

    else
        echo "kbl job del [namespace] [job_name]"

    fi
}

__kbl_job_get() {
    if (( $# == 0 )); then
        kubectl get job -A

    elif (( $# == 1 )); then
        local namespace=$1
        kubectl get job -n $namespace

    else
        echo "kbl job get"
        echo "kbl job get [namespace]"

    fi
}


__kbl_context() {
    if (( $# == 0 )); then
        kubectl config get-contexts | sed -e "s/gke_smart-building-platform-test_europe-west4-a_sbp-test/test                                                    /g" -e "s/gke_smart-building-platform_europe-west4-a_sbp/prod                                          /g"
    # TODO I've commented out the gcloud stuff for now as it's fucked for some reason and I don't currently need it, from Jerome:
    # > Well then you have your kubernetes environment pointing somewhere, but your GCloud environment poiting somewhere else,
    # > which can be a problem if you want to create or interact with elements that are in GCP and not in Kubernetes (persistent volumes, ingress, service accounts etc.)
    elif [[ $1 == "test" ]]; then
        # gcloud auth application-default set-quota-project smart-building-platform-test
        # gcloud config configurations activate sbp-test
        kubectl config use-context gke_smart-building-platform-test_europe-west4-a_sbp-test
    elif [[ $1 == "prod" ]]; then
        # gcloud auth application-default set-quota-project smart-building-platform
        # gcloud config configurations activate sbp
        kubectl config use-context gke_smart-building-platform_europe-west4-a_sbp
    fi
}

# delete after backup
kbl_create() {
    if (( $# >= 2 & $# <=4 )); then
        if (( $# == 2 )); then
            local namespace=$1
            local secret_name=$2
            local file_name=settings\.yaml
            local local_file_name=${secret_name}\.yaml
        
        elif (( $# == 3 )); then
            local namespace=$1
            local secret_name=$2
            local file_name=$3
            local local_file_name=${secret_name}\.yaml
        
        elif (( $# == 4 )); then
            local namespace=$1
            local secret_name=$2
            local file_name=$3
            local local_file_name=$4
        fi
    
        kubectl -n $namespace create secret generic $secret_name --from-file=${file_name}=${local_file_name}
    	
    else
        echo "Illegal number of parameters"
    fi
}

# ------------------------------ old ------------------------------
_kbl_get_args() {
	if (( $# == 3 )); then
		echo "$1 $2 $3"
	elif (( $# == 2 )); then
		echo "$1 $2 \.env"
	elif (( $# == 1 )); then
		echo "sbp $1 \.env"
	else
		echo "Illegal number of parameters"
	fi
}

_old_kbl_get() {
	local result=$(_kbl_get_args $@)
	local vals=($result)
	# local statement="kubectl -n ${vals[0]} get secret ${vals[1]} -o jsonpath=\"{.data.${vals[2]}}\" | base64 -d"
	# echo $statement
	
	kubectl -n ${vals[0]} get secret ${vals[1]} -o jsonpath="{.data.${vals[2]}}" | base64 -d; echo
	
	# potentially replace 'get' with 'edit' for vim on line 8 and edit secret in place
}

_kbl_create() {
    local result=$(kbl_get_args $@)
    local vals=($result)
    local statement="kubectl -n ${vals[0]} create secret generic ${vals[1]} --from-file=${vals[2]}} | base64"
    echo $statement
    $statement
}

_kbl_delete_create() {
    local result=$(kbl_get_args $@)
    local vals=($result)
    local statement="kubectl -n ${vals[0]} get secret ${vals[1]} -o jsonpath="{.data.${vals[2]}}" | base64"
    echo $statement
    $statement
}

