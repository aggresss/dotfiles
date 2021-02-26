# file .bash_aliases
# wget https://raw.githubusercontent.com/aggresss/dotfiles/master/sh/.bash_aliases

# color for echo
BLACK=$'\e[30m'
RED=$'\e[31m'
GREEN=$'\e[32m'
YELLOW=$'\e[33m'
BLUE=$'\e[34m'
MAGENTA=$'\e[35m'
CYAN=$'\e[36m'
WHITE=$'\e[37m'
NORMAL=$'\e[0m'
LIGHT=$'\e[1m'
INVERT=$'\e[7m'

##################################
# Environment Operate for Bash/Zsh
##################################

# add new element to environment variable insert mode
# $1 enviroment variable
# $2 new element
function env_insert()
{
    eval local env_var=\$\{${1}\-\}
    local new_element=${2%/}
    if ! echo $env_var | grep -E -q "(^|:)$new_element($|:)"; then
        eval export $1="${new_element}\${$1:+\:}\${$1-}"
    fi
}

# add new element to environment variable append mode
# $1 enviroment variable
# $2 new element
function env_append()
{
    eval local env_var=\$\{${1}\-\}
    local new_element=${2%/}
    if ! echo $env_var | grep -E -q "(^|:)$new_element($|:)"; then
        eval export $1="\${$1-}\${$1:+\:}${new_element}"
    fi
}

# trim element from environment variable
# $1 enviroment variable
# $2 prune element
function env_trim()
{
    eval local env_var=\$\{${1}\-\}
    local del_element=${2%/}
    eval export $1="$(echo ${env_var} | sed -e "s;\(^\|:\)${del_element}\(:\|\$\);\1\2;g" -e 's;^:\|:$;;g' -e 's;::;:;g')"
}

# amend environment variable
# $1 enviroment variable
# $2 amend element
function env_amend()
{
    eval export $1="$(echo $2)"
}

# amend environment variable
# $1 enviroment variable
function env_unset()
{
    eval unset $1
}

# print element from environment variable
# $1 enviroment variable
function env_print()
{
    eval local env_var=\$\{${1}\-\}
    echo -e ${1}:\\n${env_var//:/\\n}
}

##########################
# Operate System specified
##########################

# specified for system type
echo -e "${GREEN}$(uname -a)${NORMAL}"
echo -e "${CYAN}${SHELL}${NORMAL}"
case $(uname) in
    Darwin)
        # ls colours
        export CLICOLOR=1
        export LSCOLORS=ExGxFxDxCxegedabagacad
        # use "brew install gnu-*" instead of bsd-*
        alias sed='gsed'
        alias awk='gawk'
        alias tar='gtar'
        alias find='gfind'
        alias seq='gseq'
        # open application from command
        alias preview='open -a Preview'
        alias typora='open -a Typora'
        alias diffmerge='open -a DiffMerge'
        alias code='open -a Visual\ Studio\ Code'
        alias vlc='open -a VLC'
        alias skim='open -a Skim'
        alias drawio='open -a draw.io'
        alias chrome='open -a Google\ Chrome'
        alias firefox='open -a Firefox'
        alias safari='open -a Safari'
        alias edge='open -a Microsoft\ Edge'
        ;;
    Linux)
        # Export history format
        export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
        # Specified for Microsoft WSL
        if [[ $(uname -a) =~ "icrosoft" ]]; then
            export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0
        fi
        # Specified for docker container
        if [ -f /.dockerenv ]; then
            echo -e "${YELLOW}DOCKER_IMAGE: ${DOCKER_IMAGE}${NORMAL}"
        fi
        # Specified for Gnome environment
        if [ $(command -v gnome-terminal >/dev/null; echo $?) -eq 0 ]; then
            alias cbp='chromium-browser --proxy-server=socks5://127.0.0.1:1080'
            alias calc='gnome-calculator'
            alias gterm='gnome-terminal'
            alias mks='setxkbmap -option keypad:pointerkeys; xkbset ma 60 10 15 15 10'
            alias xck='xclock -bg cyan -update 1 &'
        fi
        ;;
    FreeBSD)
        # ls colours
        export CLICOLOR=1
        export LSCOLORS=ExGxFxDxCxegedabagacad
        ;;
    MINGW*)
        ;;
    *)
        echo "No support this ENV."
        ;;
esac

##########################
# Modify for utility
##########################

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# alias for fast command
if [ -f /.dockerenv ]; then
    alias s='cd /mnt/workspace-scratch'
    alias f='cd /mnt/workspace-formal'
    alias d='cd /mnt/Downloads'
    alias m='cd /mnt/Documents'
else
    mkdir -p ${HOME}/workspace-scratch
    mkdir -p ${HOME}/workspace-formal
    alias s='cd ${HOME}/workspace-scratch'
    alias f='cd ${HOME}/workspace-formal'
    alias d='cd ${HOME}/Downloads'
    alias m='cd ${HOME}/Documents'
fi
# fast update bash env
alias u='source ${HOME}/.bash_aliases'
# git_prompt fast
alias p='git_prompt'
# fast switch to git top level
alias t='git_top'
# fast show git branch
alias b='git branch -vv'
# fast execute file content
alias x='source_file exec'
# fast copy file content
alias c='source_file copy'
# fast edit index note file
alias e='source_file edit'
# fast ssh-agent
alias a='ssh_agent_add'
alias k='ssh_agent_del'
alias ak='kill_all ssh-agent'
# fast git status
alias y='git_status'
# fast echo app return
alias o='echo $?'
# fast echo gopath
alias g='go_path'
# fast echo package.json run
alias j='jq .scripts package.json'
# fast history query
alias h='history | grep'

# find file
alias fdf='find . -name "*" |grep -sin'
# find file content
alias fdc='find . -name "*" |xargs grep -sin'
# count code line
alias ccl='find . -name "*[.h|.c|.hpp|.cpp|.go|.rs|.py|.java|.ts|.js]" -type f | xargs cat | wc -l'
# alias for some application special open
alias emacs='emacs -nw'
alias emacsx='emacs'
# alias for remove fast
alias rm_3rd='rm -rvf *.zip *.tgz *.bz2 *.gz *.dmg *.7z *.xz *.tar'
alias rm_mda='rm -rvf *.jpg *.jpeg *.png *.bmp *.gif *.mp3 *.acc *.wav *.mp4 *.flv *.mov *.avi *.ts *.wmv *.mkv'
alias rm_doc='rm -rvf *.doc *.docx *.xls *.xlsx *.ppt *.pptx *.numbers *.pages *.key'
alias rm_ds='rm_rcs .DS_Store'
# short for cd ..
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
# Some more alias to avoid making mistakes
alias rm='rm -i'
alias mv='mv -i'
# Generate GNU standard files
alias make_gnu='touch AUTHORS COPYING ChangeLog NEWS README'

# $1 download url
# $2 local filepath
function update_file()
{
    local tmp_path="/tmp"
    # can replace by dirname and basename command
    local down_file=`echo "$1" | awk -F "/" '{print $NF}'`
    local down_path=`echo "$2" | awk 'BEGIN{res=""; FS="/";}{for(i=2;i<=NF-1;i++) res=(res"/"$i);} END{print res}'`
    echo "Update $2 ..."
    if [ ! -d ${down_path} ]; then
        mkdir -vp ${down_path}
    fi
    if [[ $1 =~ ^http.* ]]; then
        rm -rf ${tmp_path}/${down_file}
        if [ $(command -v wget > /dev/null; echo $?) -eq 0 ]; then
            wget -P ${tmp_path} $1
        elif [ $(command -v curl > /dev/null; echo $?) -eq 0 ]; then
            cd ${tmp_path}
            curl -OL $1
            cd -
        else
            echo "No http request tool."
            exit 1;
        fi
        cp -vf ${tmp_path}/${down_file} $2
        rm -rf ${tmp_path}/${down_file}
        if [ ${down_file##*.} = "sh" ]; then
            chmod +x $2
        fi
    else
        cp -vf $1 $2
    fi
}

# fast ssh-agent
# ssh-add -l > /dev/null 2>&1
# $?=0 means the socket is there and it has a key
# $?=1 means the socket is there but contains no key
# $?=2 means the socket is not there or broken
function ssh_agent_check()
{
    ssh-add -l > /dev/null 2>&1; local ssh_add_ret=$?
    if [ $ssh_add_ret -eq 2 ] && [ -f ${HOME}/.ssh-agent.conf ]; then
        source ${HOME}/.ssh-agent.conf > /dev/null 2>&1
        ssh-add -l > /dev/null 2>&1; ssh_add_ret=$?
    fi
    if [ $ssh_add_ret -eq 2 ]; then
        eval `ssh-agent | tee ${HOME}/.ssh-agent.conf` > /dev/null 2>&1
        ssh-add -l > /dev/null 2>&1; ssh_add_ret=$?
    fi
    return $ssh_add_ret
}

function ssh_agent_add()
{
    ssh_agent_check
    case $? in
        0)
            echo "${YELLOW}Agent pid ${SSH_AGENT_PID:-NOCONFIG}${NORMAL}"
            ssh-add -l
            ;;
        1)
            echo "${YELLOW}Agent pid ${SSH_AGENT_PID:-NOCONFIG}${NORMAL}"
            ssh-add
            ;;
        *)
            echo -e "${RED}No ssh-agent found${NORMAL}"
            ;;
    esac
}

function ssh_agent_del()
{
    ssh-add -d
}

# fast ssh id copy
# $1 souce name
# $2 target name
function ssh_copy()
{
    if [ $# -ne 2 ]; then
        for id in `ls ${HOME}/.ssh/*.pub`
        do
            local trim_id=${id%.pub}
            echo -e "${YELLOW}\t${trim_id#${HOME}/.ssh/}${NORMAL}"
        done
        return 0
    fi
    local src_file="${HOME}/.ssh/id_rsa"
    if [ "$1" != "_" ]; then
        src_file="${src_file}_$1"
    fi
    local dest_file="${HOME}/.ssh/id_rsa"
    if [ "$2" != "_" ]; then
        dest_file="${dest_file}_$2"
    fi
    cp -vf ${src_file} ${dest_file} && cp -vf ${src_file}.pub ${dest_file}.pub
}

# kill all
# $1 process name to kill
function kill_all()
{
    local process_id=$(ps ax | grep -e "[/\ ]$1\$" -e "[/\ ]$1[\ ]" | grep -v grep | awk '{print $1}' | sort -u)
    if [ "x$process_id" != "x" ]; then
        for id in $process_id
        do
            kill -9 $id
        done
        echo -e "PID KILLED:\n${RED}${process_id}${NORMAL}"
    fi
}

# fast decompression archives
function un_ball()
{
    if [ $# -ne 1 ]; then
        echo -e "${RED}Arguments no support.${NORMAL}"
        return 1;
    fi
    if [[ $1 =~ .*\.zip$ ]]; then
        # *.zip
        unzip $1 -d ${1%.zip}
    elif [[ $1 =~ .*\.rar$ ]]; then
        # *.rar
        mkdir -p ${1%.rar}
        unrar x $1 ${1%.rar}
    elif [[ $1 =~ .*\.7z$ ]]; then
        # *.7z
        7z x $1
    elif [[ $1 =~ .*\.tar.xz$ ]]; then
        # *.tar.xz
        tar Jvxf $1
    elif [[ $1 =~ .*\.tar.gz$ || $1 =~ .*\.tgz$ ]]; then
        # *.tar.gz or *.tgz
        tar zvxf $1
    elif [[ $1 =~ .*\.tar.bz2$ ]]; then
        # *.tar.bz2
        tar jvxf $1
    elif [[ $1 =~ .*\.tar$ ]]; then
        # *.tar
        tar vxf $1
    else
        echo -e "${RED}Archive tpye no support.${NORMAL}"
    fi
}

# fast source file content
# $1: copy source
# $2: filename or ~/note/* index
# $3-: lines to execute
function source_file()
{
    local index_range=$(ls -1p ${HOME}/note/* 2>/dev/null | sed -n '$=')
    if [ $# -le 1 ]; then
        if [ ! -d ${HOME}/note ];then
            mkdir -p ${HOME}/note
            touch ${HOME}/note/note.common
        fi
        echo -e ${YELLOW}
        ls -1p ${HOME}/note/* 2>/dev/null | cat -n
        echo -e ${NORMAL}
    else
        # arguments >= 2
        if [ ! -f $2 -a $2 -ge 1 -a $2 -le ${index_range} ] 2>/dev/null; then
            local index_file=$(ls -1p ${HOME}/note/* | sed -n "${2}p")
        else
            local index_file=${2}
        fi
        if [ ! -f ${index_file} ]; then
            echo -e "${RED}\nFile not exist.\n${NORMAL}"
            return 1
        fi
        # edit command
        if [ "$1" = "edit" ]; then
            vim ${index_file}
            return 0
        fi
        # arguments = 2
        if [ $# -eq 2 ]; then
            echo -e ${GREEN}
            cat -n ${index_file}
            echo -e ${NORMAL}
        else
            # arguments > 2
            local tmp_src_file=$(mktemp)
            local i
            for ((i=3; i<=$#; i++))
            do
                eval local line_range=\$\{${i}\}
                line_range=${line_range/-/,}
                if [ "${line_range}" = "_" ]; then
                    line_range="1,$"
                fi
                sed -n "${line_range}p" ${index_file} >> ${tmp_src_file}
                local file_index=$(sed -n '$=' ${tmp_src_file})
            done
            sed -i 's/\r$//g' ${tmp_src_file}
            # operate file
            case $1 in
                copy)
                    echo -e ${CYAN}; cat -n ${tmp_src_file}; echo -e ${NORMAL}
                    case $(uname) in
                        Linux)
                            if [ ${file_index} -eq 1 ]; then
                                 cat ${tmp_src_file} | tr -d \\n | xclip -selection clipboard
                            else
                                 cat ${tmp_src_file} | xclip -selection clipboard
                            fi
                            ;;
                        Darwin)
                            if [ ${file_index} -eq 1 ]; then
                                 cat ${tmp_src_file} | tr -d \\n | pbcopy
                            else
                                 cat ${tmp_src_file} | pbcopy
                            fi
                            ;;
                        *)
                            echo -e "${RED}No support this OS.${NORMAL}"
                            ;;
                    esac
                    ;;
                exec)
                    echo -e ${MAGENTA}; cat -n ${tmp_src_file}; echo -e ${NORMAL}
                    source ${tmp_src_file}
                    ;;
                *)
                    echo -e "${RED}No support this command.${NORMAL}"
                    ;;
            esac
            rm -rf ${tmp_src_file}
        fi
    fi
}

# switch proxy on-off
# $1: port 1-65536; null to display; else to close
function proxy_cfg()
{
    if [ ${1:-NOCONFIG} = "NOCONFIG" ]; then
        if [ -n "${proxy-}" ]; then
            echo -e "${YELLOW}${proxy}${NORMAL}"
        else
            echo -e "${YELLOW}proxy disabled.${NORMAL}"
        fi
        return 0
    fi
    local port=$(echo $1 | sed 's/[^0-9]//g')
    if [ ${port:=0} -gt 0  -a ${port} -lt 65536 ]; then
        if [ -f /.dockerenv ]; then
            local proxy_url="http://host.docker.internal:${port}"
        else
            local proxy_url="http://localhost:${port}"
        fi
        export proxy=${proxy_url}
        export http_proxy=${proxy_url}
        export https_proxy=${proxy_url}
        export ftp_proxy=${proxy_url}
        echo -e "${GREEN}${proxy}${NORMAL}"
    else
        unset proxy http_proxy https_proxy ftp_proxy
        echo -e "${RED}porxy cloesd.${NORMAL}"
    fi
}

##########################
# Modify for Vagrant
##########################

# Fast list vagrant status
function vagrant_ps()
{
    command vagrant >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo -e ${YELLOW}; echo -e "vagrant box list:"
        vagrant box list
        echo -e ${GREEN}; echo -e "vagrant global-status:"
        vagrant global-status
        echo -e ${NORMAL}
    fi

}

##########################
# Modify for VirtualBox
##########################

# alias for VirtualBox
alias vb='VBoxManage'

##########################
# Modify for Docker
##########################

# Fast docker inside
function docker_shell()
{
    docker exec -it $1 bash -c "stty cols $COLUMNS rows $LINES && bash";
}

# Show docker host infomation
function docker_info()
{
    echo -e "${RED}DOCKER_HOST: ${GREEN}${DOCKER_HOST}${NORMAL}"
    echo -e "${RED}DOCKER_CERT_PATH: ${GREEN}${DOCKER_CERT_PATH}${NORMAL}"
    echo -e "${RED}DOCKER_TLS_VERIFY: ${GREEN}${DOCKER_TLS_VERIFY}${NORMAL}"
}

# Inspect volumes and port
function docker_inspect()
{
    echo -e "${GREEN}Volumes:"
    docker inspect --format='{{range .Mounts }}{{println .}}{{end}}' $1
    echo -e "${YELLOW}Ports:"
    docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{$p}} -> {{$conf}}{{println}}{{end}}' $1
    echo -e "${CYAN}Environment:"
    docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' $1
    echo -e "${MAGENTA}Command:"
    docker inspect  --format='{{.Config.Cmd}}' $1
    echo -e "${NORMAL}"
}

# Run and mount private file
function docker_private()
{
    if ! docker volume ls | grep -q root; then
        docker volume create root
    elif ! docker volume ls | grep -q home ; then
        docker volume create home
    fi
    case $(uname) in
        Linux)
            local docker_host=$(docker network inspect --format='{{range .IPAM.Config}}{{.Gateway}}{{end}}' bridge)
            xhost +local:docker > /dev/null
            docker run --rm -it \
                --add-host=host.docker.internal:${docker_host} \
                -v /tmp/.X11-unix/:/tmp/.X11-unix \
                -v root:/root \
                -v home:/home \
                -v ${HOME}/Downloads:/mnt/Downloads \
                -v ${HOME}/Documents:/mnt/Documents \
                -v ${HOME}/workspace-scratch:/mnt/workspace-scratch \
                -v ${HOME}/workspace-formal:/mnt/workspace-formal \
                -e DISPLAY \
                $*
            ;;
        Darwin)
            xhost +localhost > /dev/null
            docker run --rm -it \
                -v root:/root \
                -v home:/home \
                -v ${HOME}/Downloads:/mnt/Downloads \
                -v ${HOME}/Documents:/mnt/Documents \
                -v ${HOME}/workspace-scratch:/mnt/workspace-scratch \
                -v ${HOME}/workspace-formal:/mnt/workspace-formal \
                -e DISPLAY=host.docker.internal:0 \
                $*
            ;;
        *)
            echo "No support OS."
            ;;
    esac
}

# Run private with super privilage
function docker_sudo()
{
    docker_private \
        --privileged=true \
        $*
}

# Run private with user
function docker_user()
{
    docker_private \
        --privileged=true \
        --user docker \
        $*
}

# killall containers
function docker_kill()
{
    if [ -n "`docker ps -a -q`" ]; then
        docker rm -f `docker ps -a -q`
    fi
}


##########################
# Modify for Git
##########################

# fast change directry to git top level path
alias git_top='cd `git rev-parse --show-toplevel`'
# fast git diff file status
alias git_diff='git diff --name-status'
# git log oneline
alias git_log='git log --oneline'
# git skip worktree
alias git_skip='git update-index --skip-worktree'
# git assume unchanged
alias git_assume='git update-index --assume-unchanged'

# Show git status
function git_status()
{
    git status && echo
    git stash list 2> /dev/null && echo
    git ls-files -v  2> /dev/null | grep --color -E "^S|^h|^M" && echo
}

# no-skip-worktree all
function git_noskip()
{
    if [ $# -eq 0 ]; then
        git ls-files -v | grep "^S" | awk '{print $2}' |xargs git update-index --no-skip-worktree
    else
        git update-index --no-skip-worktree $1
    fi
}

# no-assume-unchanged all
function git_noassume()
{
    if [ $# -eq 0 ]; then
        git ls-files -v | grep "^h" | awk '{print $2}' |xargs git update-index --no-assume-unchanged
    else
        git update-index --no-assume-unchanged $1
    fi
}

# Signature for github repository
# $# -eq 1 => $1 user.email
# $# -eq 2 => $1 user.name; $2 user.email
function git_sig()
{
    if [ ${1:-NOCONFIG} = "NOCONFIG" ]; then
        echo "user.name: `git config --get user.name`"
        echo "user.email: `git config --get user.email`"
    elif [ ${2:-NOCONFIG} = "NOCONFIG" ]; then
        git config user.name `echo "$1" | awk -F "@" '{print $1}'`
        git config user.email $1
    else
        git config user.name $1
        git config user.email $2
    fi
}

# clone repo in hierarchy directory as site/org/repo
# $1 repo URI
function git_clone()
{
    local clone_path=$1
    # https
    clone_path=${clone_path#*://}
    # ssh
    clone_path=${clone_path#*@}
    # match next slash
    clone_path=${clone_path/:/\/}
    # trim .git suffix
    clone_path=${clone_path%.git}
    git clone $@ ${clone_path} && \
    echo -e "\n${GREEN} Clone $1 on ${PWD}/${clone_path} successfully.${NORMAL}\n"
}

# Get pull request to local branch
# $1 remote name
# $2 pull request index No.
function git_pull()
{
    if [ $# != 2 ]; then
        echo -e "${LIGHT}${RED}Please input remote name and pull request No.${NORMAL}"
        return 1
    fi
    local remote_name=$1
    local remote_pr=$2
    local pull_branch="pull/${remote_name}/${remote_pr}"
    local curr_branch=`git rev-parse --abbrev-ref HEAD` || return 1
    git fetch ${remote_name} pull/${remote_pr}/head:${pull_branch}_staging
    if [ $(echo $?) -ne 0 ]; then
        return 1
    fi
    if [ "${curr_branch}" = "${pull_branch}" ]; then
        git rebase ${pull_branch}_staging
    else
        git branch -q -D ${pull_branch} 2> /dev/null
        git checkout -b ${pull_branch} ${pull_branch}_staging
    fi
    git branch -q -D ${pull_branch}_staging
}

# Checkout a branch and delete current branch
# $1 branch for checkout
function git_leave()
{
    if [ $# != 1 ]; then
        echo -e "${LIGHT}${RED}Please input a branch to checkout.${NORMAL}"
        return 1
    fi
    local curr_branch=`git rev-parse --abbrev-ref HEAD` || return 1
    if [ -z "${curr_branch}" ]; then
        return 2
    fi
    git checkout $1 && git branch -D ${curr_branch}
}

# Delete git branch on local and remote
# $1 git branch
function git_del()
{
    local cur_branch
    local del_remote=0
    for i in `seq 1 $#`
    do
        eval cur_branch=\$$i
        if git branch | grep -q ${cur_branch}; then
            git branch -D ${cur_branch}
        else
            echo -e "${RED}No branch ${cur_branch} on local.${NORMAL}"
            continue
        fi
        if git branch -r | grep -q origin/${cur_branch}; then
            git push origin :${cur_branch}
            del_remote=1
        else
            echo -e "${RED}No branch ${cur_branch} on remote origin.${NORMAL}"
        fi
    done
    if [ ${del_remote} -eq 1 ]; then
        git remote update origin
    fi
}

# git config insteadOf
# $1: https/ssh/unset; null to display
# $2: domain name
function git_insteadof()
{
    local url="github.com"
    if [ $# -ge 2 ]; then
        url=$2
    fi
    case $1 in
        ssh)
            git config --global --unset-all url."https://${url}/".insteadof
            git config --global url."git@${url}:".insteadOf "https://${url}/"
            ;;
        https)
            git config --global --unset-all url."git@${url}:".insteadof
            git config --global url."https://${url}/".insteadOf "git@${url}:"
            ;;
        unset)
            git config --global --unset-all url."https://${url}/".insteadof
            git config --global --unset-all url."git@${url}:".insteadof
            ;;
        *)
            echo; git config -l | grep -E "url\.|\.insteadof=" && echo
            ;;
        esac
}

# Set git global set
function git_global_set()
{
  local base_url="https://github.com/aggresss/dotfiles/raw/master"
  update_file ${base_url}/.gitignore ${HOME}/.gitignore
  git config --global core.excludesfile ${HOME}/.gitignore
  git config --global core.editor "vim"
  git config --global core.autocrlf false
  git config --global core.quotepath false
  git config --global pull.rebase false
  git config --global push.default simple
}

GIT_NAME_TITLE=''
GIT_NAME_CONTENT=''
GIT_NAME_LEFT=''
GIT_NAME_RIGHT=''
GIT_NAME_HEAD=''

function git_branch_internal()
{
    local dir="."
    until [ "${dir}" -ef / ]; do
        if [ -f "${dir}/.git/HEAD" ]; then
            local head=$(< "${dir}/.git/HEAD")
            if [[ ${head} == ${GIT_NAME_HEAD} ]]; then
                return
            fi
            GIT_NAME_HEAD=${head}
            if [[ $head =~ ^ref\:\ refs\/heads\/* ]]; then
                GIT_NAME_TITLE="branch"
                GIT_NAME_CONTENT="${head#*/*/}"
            else
                local describe=$(git describe --tags --abbrev=7 2> /dev/null)
                if [ -n "${describe}" ]; then
                    GIT_NAME_TITLE="tag"
                    GIT_NAME_CONTENT=${describe}
                else
                    GIT_NAME_TITLE="commit"
                    GIT_NAME_CONTENT=${head:0:7}
                fi
            fi
            GIT_NAME_LEFT=":["
            GIT_NAME_RIGHT="]"
            return
        fi
        dir="../${dir}"
    done
    GIT_NAME_TITLE=''
    GIT_NAME_CONTENT=''
    GIT_NAME_LEFT=''
    GIT_NAME_RIGHT=''
    GIT_NAME_HEAD=''
}

# Git branch perception
function git_zsh_precmd()
{
    git_branch_internal
    PS1="${PS1_BAK}%{$fg_bold[blue]%}${GIT_NAME_TITLE}${GIT_NAME_LEFT}%{$fg_bold[red]%}${GIT_NAME_CONTENT}%{$fg_bold[blue]%}${GIT_NAME_RIGHT}%% %{$reset_color%}"
}

# color for PS1
black=$'\[\e[1;30m\]'
red=$'\[\e[1;31m\]'
green=$'\[\e[1;32m\]'
yellow=$'\[\e[1;33m\]'
blue=$'\[\e[1;34m\]'
magenta=$'\[\e[1;35m\]'
cyan=$'\[\e[1;36m\]'
white=$'\[\e[1;37m\]'
normal=$'\[\e[m\]'

# Git prompt for branch infomation
function git_prompt()
{
    if [ "${PS1_BAK-NODEFINE}" = "NODEFINE" ] ; then
        PS1_BAK=${PS1-}
        if [[ ${SHELL} =~ .*bash$ ]]; then
            PROMPT_COMMAND_BAK=${PROMPT_COMMAND-}
            PROMPT_COMMAND="git_branch_internal;${PROMPT_COMMAND-}"
            PS1="$PS1$blue\$GIT_NAME_TITLE\$GIT_NAME_LEFT$red\$GIT_NAME_CONTENT$blue\$GIT_NAME_RIGHT\$ $normal"
        elif [[ ${SHELL} =~ .*zsh$ ]]; then
            autoload -U colors && colors
            precmd_functions=(git_zsh_precmd)
        fi
    else
        if [[ ${SHELL} =~ .*bash$ ]]; then
            PROMPT_COMMAND=${PROMPT_COMMAND_BAK-}
            unset PROMPT_COMMAND_BAK
        elif [[ ${SHELL} =~ .*zsh$ ]]; then
            unset precmd_functions
        fi
        PS1=${PS1_BAK-}
        unset PS1_BAK
        GIT_NAME_HEAD=''
    fi
}

# Git fast add->commit->fetch->rebase->push ! Deprecated
# $1 operation: rebase
function git_haste()
{
    git_branch_internal;
    if [ -z ${GIT_NAME_TITLE} ]; then
        echo -e "${RED}Not a git repository${NORMAL}"
    elif [ ${GIT_NAME_TITLE} = "branch" ]; then
        git commit -m "`date +"%Y-%m-%d %T %Z W%UD%w"`"
        if [[ $1 == "commit" ]]; then
            return 0
        fi
        if [[ $1 == "rebase" ]]; then
            git fetch origin
            git rebase origin/${GIT_NAME_CONTENT}
        fi
        git push origin ${GIT_NAME_CONTENT}:${GIT_NAME_CONTENT}
    else
        echo -e "${RED}Detached HEAD state${NORMAL}"
    fi
}

# Git fast download file from url
# $1 url
function git_down()
{
    local l_url=$1
    local l_vendor=$(echo "${l_url}" | awk -F'[/:]' '{print $4}')
    local l_uri=$(echo "${l_url}" | cut -d/ -f4-)
    local l_user=$(echo "${l_uri}" | cut -d/ -f1)
    local l_repo=$(echo "${l_uri}" | cut -d/ -f2)
    local l_branch=$(echo "${l_uri}" | cut -d/ -f4)
    local l_path=$(echo "${l_uri}" | cut -d/ -f5-)

    if [[ -z ${l_url} || -z ${l_vendor} || -z ${l_uri} || -z ${l_user} || -z ${l_repo} || -z ${l_branch} || -z ${l_path} ]]; then
        echo -e "Invalid URL: $1"
        return 1
    fi
    local res_url="https://${l_vendor}/${l_user}/${l_repo}/raw/${l_branch}/${l_path}"
    echo -e "Download URL: ${res_url}"
    case ${l_vendor} in
        gitlab.com | github.com)
            curl -OL ${res_url}
            ;;
        *)
            echo -e "Not support URL: $1"
            ;;
    esac
}

##########################
# Modify for Vscode
##########################

# go to vscode user path
function code_user {
    local GLOBAL_WORKSPACE="."
    case $(uname) in
        Darwin)
            GLOBAL_WORKSPACE="${HOME}/Library/Application Support/Code/User"
            ;;
        Linux)
            GLOBAL_WORKSPACE="${HOME}/.config/Code/User"
            ;;
        MINGW*)
            GLOBAL_WORKSPACE="%APPDATA%\Code\User"
            ;;
    esac
    cd ${GLOBAL_WORKSPACE}
}

##########################
# Modify for Golang
##########################

# environmnet for Golang
if [ -d "$HOME/.local/go" ]; then
    export GOROOT="$HOME/.local/go"
    env_insert "PATH" "$GOROOT/bin"
fi

if [ -d "$HOME/go" ];then
    if [ ${GOPATH:-NOCONFIG} = "NOCONFIG" ]; then
        env_insert "GOPATH" "$HOME/go"
    fi
    if [ ! -d "$HOME/go/bin" ]; then
        mkdir -p $HOME/go/bin
    fi
    env_insert "PATH" "$HOME/go/bin"
fi

if [ ${GOPATH_BAK:-NOCONFIG} = "NOCONFIG" ]; then
    GOPATH_BAK=${GOPATH-}
fi

# echo current GOPATH
alias go_path='env_print GOPATH'
# mkdir for golang workspace
alias go_workspace='mkdir -p src pkg bin'

# reset $GOPATH
function go_reset()
{
    export GOPATH=${GOPATH_BAK-}
    echo -e "${GREEN}successful clear GOPATH \n${RED}GOPATH ==> ${GOPATH}${NORMAL}"
}

# set $PWD to $GOPATH
function go_pwd()
{
    export GOPATH=${PWD}
    echo -e "${GREEN}successful set GOPATH \n${RED}GOPATH ==> ${GOPATH}${NORMAL}"
}

function go_proxy()
{
    if [ ${GOPROXY:-NOCONFIG} = "NOCONFIG" ]; then
        export GOPROXY=https://goproxy.cn
        echo -e "${YELLOW}GOPROXY: ${GOPROXY}${NORMAL}"
    else
        unset GOPROXY
        echo -e "${YELLOW}GOPROXY: disabled${NORMAL}"
    fi
}

# clone repo in hierarchy directory as site/org/repo for golang workspace
# $1 repo URI
function go_clone()
{
    local clone_path=$1
    local repo_name=""
    # https
    clone_path=${clone_path#*://}
    # ssh
    clone_path=${clone_path#*@}
    clone_path=${clone_path/:/\/}
    # trim .git suffix
    clone_path=${clone_path%.git}
    # get repo name
    repo_name=`echo "${clone_path}" | awk -F "/" '{print $NF}'`
    # do clone
    clone_path="${repo_name}/src/${clone_path}"
    git clone $@ ${clone_path} && \
        mkdir -p ${repo_name}/bin ${repo_name}/pkg && \
        echo -e "\n${GREEN} Clone $1 on ${PWD}/${clone_path} successfully.${NORMAL}\n"
}

##########################
# Modify for Python
##########################

# specified for ${HOME}/.local/bin
if [ ! -d ${HOME}/.local/bin ]; then
    mkdir -p ${HOME}/.local/bin
fi
env_insert "PATH" "${HOME}/.local/bin"

# specified for ${HOME}/Library/Python
if [ -d ${HOME}/Library/Python ]; then
    for file in `ls ${HOME}/Library/Python`
    do
        if [ -d ${HOME}/Library/Python/${file}/bin ]; then
            env_insert "PATH" "${HOME}/Library/Python/${file}/bin"
        fi
    done
fi

# change directory to python3 user base
function py_path
{
    cd $(python3 -c 'import site; print(site.USER_BASE)')
}

##########################
# Modify for Perl
##########################

# Using local::lib for Perl modules
PERL_LOCAL_LIB_ROOT="${HOME}/perl5"
if [ -d ${PERL_LOCAL_LIB_ROOT} ]; then
    env_insert  "PATH" "${PERL_LOCAL_LIB_ROOT}/bin"
    env_insert "PERL5LIB" "${PERL_LOCAL_LIB_ROOT}/lib/perl5"
    env_insert "PERL_LOCAL_LIB_ROOT" "${PERL_LOCAL_LIB_ROOT}"
    env_amend "PERL_MB_OPT" "--install_base\ \\\"${PERL_LOCAL_LIB_ROOT}\\\""
    env_amend "PERL_MM_OPT" "INSTALL_BASE=${PERL_LOCAL_LIB_ROOT}"
fi

function perl_install
{
    for idx in $(seq $#); do
        eval perl -MCPAN -e \"install \$$idx\"
    done
}

##########################
# Modify for JavaScript
##########################

env_amend "NPM_PACKAGES" "${HOME}/.local"
if [ ! -d ${NPM_PACKAGES} ]; then
    mkdir -p ${NPM_PACKAGES}
fi
env_insert "PATH" "${NPM_PACKAGES}/bin"
env_insert "NODE_PATH" "${NPM_PACKAGES}/lib/node_modules"

function npm_rc
{
    if [ ! -f ${PWD}/.npmrc ]; then
        cat << END > ${PWD}/.npmrc
package-lock=false
END
    fi
}

##########################
# Modify for Java
##########################

function mvn_gen()
{
    if [ $# -eq 1 ]; then
        local groupId=${1%%:*}
        local artifactId=${1##*:}
        if [[ -n ${groupId} && -n ${artifactId} ]]; then
            mvn archetype:generate \
                -DarchetypeGroupId=org.apache.maven.archetypes \
                -DarchetypeArtifactId=maven-archetype-quickstart \
                -DgroupId=${groupId} \
                -DartifactId=${artifactId} \
                -Dversion=1.0-SNAPSHOT \
                -DinteractiveMode=false
        else
            echo -e "${RED}GroupId:ArtifactId${NORMAL}"
        fi
    else
        mvn archetype:generate
    fi
}

function mvn_exec()
{
    if [ $# -lt 1 ]; then
        return
    elif [ $# -eq 1 ]; then
        mvn exec:java -Dexec.mainClass="$1"
    else
        local i
        local exec_args=""
        for ((i=2; i<=$#; i++))
        do
            eval exec_args=\$\{exec_args\}\"\ \"\$\{${i}\}
        done
        mvn exec:java -Dexec.mainClass="$1" -Dexec.args="${exec_args# }"
    fi
}

##########################
# Modify for Envrionment
##########################

# environment for ${HOME}/bin
if [ -d ${HOME}/bin ]; then
    env_insert "PATH" "${HOME}/bin"
fi

if [ $(command -v valgrind >/dev/null; echo $?) -eq 0 ]; then
    alias vmc='valgrind \
        --tool=memcheck \
        --leak-check=yes \
        --track-fds=yes \
        --trace-children=yes \
        --show-reachable=yes \
        --undef-value-errors=no \
        --gen-suppressions=all \
        --error-exitcode=255'
fi

# end of .bash_aliases
