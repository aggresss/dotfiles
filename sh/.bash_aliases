# file .bash_aliases
# wget https://raw.githubusercontent.com/aggresss/dotfiles/main/sh/.bash_aliases

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
function env_insert() {
    eval local env_var=\$\{${1}\-\}
    local new_element=${2%/}
    if ! echo $env_var | grep -E -q "(^|:)$new_element($|:)"; then
        eval export $1="${new_element}\${$1:+\:}\${$1-}"
    fi
}

# add new element to environment variable append mode
# $1 enviroment variable
# $2 new element
function env_append() {
    eval local env_var=\$\{${1}\-\}
    local new_element=${2%/}
    if ! echo $env_var | grep -E -q "(^|:)$new_element($|:)"; then
        eval export $1="\${$1-}\${$1:+\:}${new_element}"
    fi
}

# trim element from environment variable
# $1 enviroment variable
# $2 trim element
function env_trim() {
    eval local env_var=\$\{${1}\-\}
    local del_element=${2%/}
    eval export $1="$(echo ${env_var} | sed -E -e "s;(^|:)${del_element}(:|\$);\1\2;g" -e "s;^:|:\$;;g" -e "s;::;:;g")"
}

# amend environment variable
# $1 enviroment variable
# $2 amend element
function env_amend() {
    eval export $1="$(echo $2)"
}

# unset environment variable
# $1 enviroment variable
function env_unset() {
    eval unset $1
}

# list element from environment variable
# $1 enviroment variable
function env_list() {
    eval local env_var=\$\{${1}\-\}
    echo -e ${env_var//:/\\n}
}

#########################
# Git Prompt for Bash/Zsh
#########################

GIT_NAME_TITLE=''
GIT_NAME_CONTENT=''
GIT_NAME_LEFT=''
GIT_NAME_RIGHT=''
GIT_NAME_HEAD=''

function git_branch_internal() {
    local dir="."
    until [ "${dir}" -ef / ]; do
        if [ -f "${dir}/.git/HEAD" ]; then
            local head=$(<"${dir}/.git/HEAD")
            if [[ ${head} == ${GIT_NAME_HEAD} ]]; then
                return
            fi
            GIT_NAME_HEAD=${head}
            if [[ $head =~ ^ref\:\ refs\/heads\/* ]]; then
                GIT_NAME_TITLE="branch"
                GIT_NAME_CONTENT="${head#*/*/}"
            else
                local describe=$(git describe --tags --abbrev=7 2>/dev/null)
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
function git_zsh_precmd() {
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
function git_prompt() {
    if [ "${PS1_BAK-NODEFINE}" = "NODEFINE" ]; then
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

alias p='git_prompt'

##########################
# Source File for Bash/Zsh
##########################

# fast source file content
# $1: copy source
# $2: filename or ~/notes/* index
# $3-: lines to execute
function source_file() {
    local note_dir="${HOME}/notes"
    local index_range=$(ls -1p ${note_dir}/* 2>/dev/null | sed -n '$=')
    if [ $# -le 1 ]; then
        if [ ! -d ${note_dir} ]; then
            mkdir -p ${note_dir}
            touch ${note_dir}/note.common
        fi
        echo -e ${YELLOW}
        ls -1p ${note_dir}/* 2>/dev/null | cat -n
        echo -e ${NORMAL}
    else
        # arguments >= 2
        if [ ! -f $2 -a $2 -ge 1 -a $2 -le ${index_range} ] 2>/dev/null; then
            local index_file=$(ls -1p ${note_dir}/* | sed -n "${2}p")
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
            for ((i = 3; i <= $#; i++)); do
                eval local line_range=\$\{${i}\}
                line_range=${line_range/-/,}
                if [ "${line_range}" = "_" ]; then
                    line_range="1,$"
                fi
                sed -n "${line_range}p" ${index_file} >>${tmp_src_file}
                local file_index=$(sed -n '$=' ${tmp_src_file})
            done
            # trim end of line
            if [[ $(sed --version 2>&1 | head -n1) =~ "GNU" ]]; then
                sed -i 's/\r$//g' ${tmp_src_file}
            else
                sed -i '' 's/\r$//g' ${tmp_src_file}
            fi
            # operate file
            case $1 in
            copy)
                echo -e ${CYAN}
                cat -n ${tmp_src_file}
                echo -e ${NORMAL}
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
                echo -e ${MAGENTA}
                cat -n ${tmp_src_file}
                echo -e ${NORMAL}
                source ${tmp_src_file}
                ;;
            *)
                echo -e "${RED}No support this command.${NORMAL}"
                ;;
            esac
            rm -f ${tmp_src_file}
        fi
    fi
}

alias c='source_file copy'
alias x='source_file exec'
alias e='source_file edit'

#####################
# Common for Bash/Zsh
#####################

# Echo Env Information
echo -e "${GREEN}$(uname -a)${NORMAL}"
echo -e "${CYAN}${SHELL}${NORMAL}"

# Envronment specific
case $(uname) in
Darwin)
    # ls colours
    export CLICOLOR=1
    export LSCOLORS=ExGxFxDxCxegedabagacad
    # open application from command
    alias preview='open -a Preview'
    alias typora='open -a Typora'
    alias diffmerge='open -a DiffMerge'
    alias code='open -a Visual\ Studio\ Code'
    alias vlc='open -a VLC'
    alias skim='open -a Skim'
    alias wps='open -a wpsoffice'
    alias drawio='open -a draw.io'
    alias safari='open -a Safari'
    alias edge='open -a Microsoft\ Edge'
    alias chrome='open -a Google\ Chrome'
    alias firefox='open -a Firefox'
    alias chrome_command="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
    alias firefox_command='/Applications/Firefox.app/Contents/MacOS/firefox'
    # variable
    export ICD="${HOME}/Library/Mobile Documents/com~apple~CloudDocs"
    ;;
Linux)
    # Export history format
    export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
    # Specified for Microsoft WSL
    if [ -n "$WSL_DISTRO_NAME" ]; then
        export DISPLAY=$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0
        export PULSE_SERVER=tcp:$(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}');
    fi
    # Specified for docker container
    if [ -f /.dockerenv ]; then
        echo -e "${YELLOW}DOCKER_IMAGE: ${DOCKER_IMAGE}${NORMAL}"
    fi
    # Specified for Gnome environment
    if [ $(
        command -v gnome-terminal >/dev/null
        echo $?
    ) -eq 0 ]; then
        alias cbp='chromium-browser --proxy-server=socks5://127.0.0.1:1080'
        alias calc='gnome-calculator'
        alias gterm='gnome-terminal'
        alias mks='setxkbmap -option keypad:pointerkeys; xkbset ma 60 10 15 15 10'
        alias xck='xclock -bg cyan -update 1 &'
    fi
    if [ $(
        command -v valgrind >/dev/null
        echo $?
    ) -eq 0 ]; then
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
    ;;
FreeBSD)
    # ls colours
    export CLICOLOR=1
    export LSCOLORS=ExGxFxDxCxegedabagacad
    ;;
MINGW*) ;;

*)
    echo "No support this ENV."
    ;;
esac

# environment for ${HOME}/bin
if [ -d ${HOME}/bin ]; then
    env_insert "PATH" "${HOME}/bin"
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
# fast update bash env
alias u='source ${HOME}/.bash_aliases; hash -r'
# fast echo app return
alias o='echo $?'
# fast history query
alias h='history | grep'
# find file
alias fdf='find . -name "*" |grep -sin'
# find file content
alias fdc='find . -name "*" |xargs grep -sin'
# count code line
alias ccl='find . -name "*[.h|.c|.hpp|.cpp|.cc|.cs|.go|.rs|.py|.java|.ts|.js]" -type f | xargs cat | wc -l'
# alias for emacs
alias emacs='emacs -nw'
alias emacsx='emacs'
# alias for remove fast
alias rm_archive='rm -rvf *.zip *.tgz *.bz2 *.gz *.dmg *.7z *.xz *.tar'
alias rm_picture='rm -rvf *.jpg *.jpeg *.png *.bmp *.gif *.webp'
alias rm_media='rm -rvf *.mp3 *.acc *.wav *.wma *.mp4 *.webm *.mkv *.ogg *.flv *.mov *.avi *.wmv *.ts *.ivf *.h264'
alias rm_doc='rm -rvf *.doc *.docx *.xls *.xlsx *.ppt *.pptx *.numbers *.pages *.key *.pdf'
alias rm_ds='find . -name .DS_Store -exec rm -vf {} \;'
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
# alias for fast command
function mkdir_cd() {
    mkdir -p $1 && cd $1
}
alias s='mkdir_cd ${HOME}/workspace-scratch'
alias f='mkdir_cd ${HOME}/workspace-formal'
alias z='cd ${HOME}/workspace-zoo'
alias d='mkdir_cd ${HOME}/Downloads'
alias m='mkdir_cd ${HOME}/Documents'
# $1 download url
# $2 local filepath
function update_file() {
    local tmp_path="/tmp"
    # can replace by dirname and basename command
    local down_file=$(echo "$1" | awk -F "/" '{print $NF}')
    local down_path=$(echo "$2" | awk 'BEGIN{res=""; FS="/";}{for(i=2;i<=NF-1;i++) res=(res"/"$i);} END{print res}')
    echo "Update $2 ..."
    if [ ! -d ${down_path} ]; then
        mkdir -vp ${down_path}
    fi
    if [[ $1 =~ ^http.* ]]; then
        rm -rf ${tmp_path}/${down_file}
        if [ $(
            command -v wget >/dev/null
            echo $?
        ) -eq 0 ]; then
            wget -P ${tmp_path} $1
        elif [ $(
            command -v curl >/dev/null
            echo $?
        ) -eq 0 ]; then
            cd ${tmp_path}
            curl -OL $1
            cd -
        else
            echo "No http request tool."
            exit 1
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

# switch proxy on-off
# $1: port 1-65536; null to display; else to close
function proxy_cfg() {
    if [ ${1:-NOCONFIG} = "NOCONFIG" ]; then
        if [ -n "${proxy-}" ]; then
            echo -e "${YELLOW}${proxy}${NORMAL}"
        else
            echo -e "${YELLOW}proxy disabled.${NORMAL}"
        fi
        return 0
    fi
    local port=$(echo $1 | sed 's/[^0-9]//g')
    if [ ${port:=0} -gt 0 -a ${port} -lt 65536 ]; then
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

##################
# SSH for Bash/Zsh
##################

# fast ssh-agent
alias a='ssh_agent_add'
alias k='ssh_agent_del'
alias ak='kill_all ssh-agent'

# fast ssh-agent
# ssh-add -l > /dev/null 2>&1
# $?=0 means the socket is there and it has a key
# $?=1 means the socket is there but contains no key
# $?=2 means the socket is not there or broken
function ssh_agent_check() {
    ssh-add -l >/dev/null 2>&1
    local ssh_add_ret=$?
    if [ $ssh_add_ret -eq 2 ] && [ -f ${HOME}/.ssh-agent.conf ]; then
        source ${HOME}/.ssh-agent.conf >/dev/null 2>&1
        ssh-add -l >/dev/null 2>&1
        ssh_add_ret=$?
    fi
    if [ $ssh_add_ret -eq 2 ]; then
        eval $(ssh-agent | tee ${HOME}/.ssh-agent.conf) >/dev/null 2>&1
        ssh-add -l >/dev/null 2>&1
        ssh_add_ret=$?
    fi
    return $ssh_add_ret
}

function ssh_agent_add() {
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

function ssh_agent_del() {
    ssh-add -d
}

# fast ssh id copy
# $1 souce name
# $2 target name
function ssh_copy() {
    if [ $# -ne 2 ]; then
        for id in $(ls ${HOME}/.ssh/*.pub); do
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

# fast ssh forward a port
# $1 host
# $2 port
function ssh_forward_port() {
    ssh -Nn -L ${2}:localhost:${2} ${1}
}

##################
# Git for Bash/Zsh
##################

# fast git status
alias y='git_status'
# fast switch to git top level
alias t='git_top'
# fast show git branch
alias b='git branch -vv'
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
function git_status() {
    git status && echo
    git stash list 2>/dev/null && echo
    git ls-files -v 2>/dev/null | grep --color -E "^S|^h|^M" && echo
}

# no-skip-worktree all
function git_noskip() {
    if [ $# -eq 0 ]; then
        git ls-files -v | grep "^S" | awk '{print $2}' | xargs git update-index --no-skip-worktree
    else
        git update-index --no-skip-worktree $1
    fi
}

# no-assume-unchanged all
function git_noassume() {
    if [ $# -eq 0 ]; then
        git ls-files -v | grep "^h" | awk '{print $2}' | xargs git update-index --no-assume-unchanged
    else
        git update-index --no-assume-unchanged $1
    fi
}

# Signature for github repository
# $# -eq 1 => $1 user.email
# $# -eq 2 => $1 user.name; $2 user.email
function git_sig() {
    if [ ${1:-NOCONFIG} = "NOCONFIG" ]; then
        echo "user.name: $(git config --get user.name)"
        echo "user.email: $(git config --get user.email)"
    elif [ ${2:-NOCONFIG} = "NOCONFIG" ]; then
        git config user.name $(echo "$1" | awk -F "@" '{print $1}')
        git config user.email $1
    else
        git config user.name $1
        git config user.email $2
    fi
}

# clone repo in hierarchy directory as org/repo
# suit for https://site/org/repo.git or git@site:org/repo.git
# $1 repo URI
function git_clone() {
    local clone_path=$1
    # https
    clone_path=${clone_path#*://}
    # ssh
    clone_path=${clone_path#*@}
    # match colon to slash
    clone_path=${clone_path/:/\/}
    # trim suffix
    clone_path=${clone_path%/}
    clone_path=${clone_path%.git}
    # trim site if org exist
    if [ $(echo ${clone_path} | awk -F "/" '{print NF}') -ge 3 ]; then
        clone_path=${clone_path#*/}
    fi
    # execute
    git clone --origin upstream $@ ${clone_path}
}

# Get pull request to local branch
# $1 remote name
# $2 pull request index No.
function git_pull() {
    if [ $# != 2 ]; then
        echo -e "${LIGHT}${RED}Please input remote name and pull request No.${NORMAL}"
        return 1
    fi
    local remote_name=$1
    local remote_pr=$2
    local pull_branch="pull/${remote_name}/${remote_pr}"
    local curr_branch=$(git rev-parse --abbrev-ref HEAD) || return 1
    git fetch ${remote_name} pull/${remote_pr}/head:${pull_branch}_staging
    if [ $(echo $?) -ne 0 ]; then
        return 1
    fi
    if [ "${curr_branch}" = "${pull_branch}" ]; then
        git rebase ${pull_branch}_staging
    else
        git branch -q -D ${pull_branch} 2>/dev/null
        git checkout -b ${pull_branch} ${pull_branch}_staging
    fi
    git branch -q -D ${pull_branch}_staging
}

# Checkout a branch and delete current branch
# $1 branch for checkout
function git_leave() {
    if [ $# != 1 ]; then
        echo -e "${LIGHT}${RED}Please input a branch to checkout.${NORMAL}"
        return 1
    fi
    local curr_branch=$(git rev-parse --abbrev-ref HEAD) || return 1
    if [ -z "${curr_branch}" ]; then
        return 2
    fi
    git checkout $1 && git branch -D ${curr_branch}
}

# Delete git branch on local and remote
# $1 git branch
function git_del() {
    local cur_branch
    local del_remote=0
    for i in $(seq 1 $#); do
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
function git_insteadof() {
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
        echo -e "usage: git_insteadof <ssh|https|unset> <url>"
        echo
        git config -l | grep -E "url\.|\.insteadof=" && echo
        ;;
    esac
}

# Set git global set
function git_global_set() {
    local base_url="https://github.com/aggresss/dotfiles/raw/main"
    if [ ${1:-NoDefine} = "local" ] && [ -d ${HOME}/dotfiles ]; then
        base_url="${HOME}/dotfiles"
    fi
    update_file ${base_url}/.gitignore ${HOME}/.gitignore
    git config --global core.excludesfile ${HOME}/.gitignore
    git config --global core.editor "vim"
    git config --global core.autocrlf false
    git config --global core.quotepath false
    git config --global core.ignorecase false
    git config --global user.useConfigOnly true
    git config --global pull.rebase false
    git config --global push.default simple
    git config --global init.defaultBranch main
}

# Git fast add->commit->fetch->rebase->push ! Deprecated
# $1 operation: rebase
function git_haste() {
    git_branch_internal
    if [ -z ${GIT_NAME_TITLE} ]; then
        echo -e "${RED}Not a git repository${NORMAL}"
    elif [ ${GIT_NAME_TITLE} = "branch" ]; then
        git commit -m "$(date +"%Y-%m-%d %T %Z W%UD%w")"
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
function git_down() {
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

function git_latest() {
    git describe --tags $(git rev-list --tags --max-count=1)
}

# git set-upstream-to
# $1 upstream
function git_set_upstream() {
    git branch --set-upstream-to=$1
}

####################
# Cmake for Bash/Zsh
####################

function cmake_init() {
    touch CmakeLists.txt
}

#####################
# Vscode for Bash/Zsh
#####################

# go to vscode user path
function code_user() {
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

#####################
# Docker for Bash/Zsh
#####################

# Fast docker inside
function docker_shell() {
    docker exec -it $1 bash -c "stty cols $COLUMNS rows $LINES && bash"
}

# Show docker host infomation
function docker_info() {
    echo -e "${RED}DOCKER_HOST: ${GREEN}${DOCKER_HOST}${NORMAL}"
    echo -e "${RED}DOCKER_CERT_PATH: ${GREEN}${DOCKER_CERT_PATH}${NORMAL}"
    echo -e "${RED}DOCKER_TLS_VERIFY: ${GREEN}${DOCKER_TLS_VERIFY}${NORMAL}"
}

function docker_unset() {
    unset DOCKER_HOST
    unset DOCKER_CERT_PATH
    unset DOCKER_TLS_VERIFY
    unset MINIKUBE_ACTIVE_DOCKERD
}

function docker_minikube() {
    eval $(minikube docker-env)
}

# Inspect volumes and port
function docker_inspect() {
    echo -e "${GREEN}Volumes:"
    docker inspect --format='{{range .Mounts }}{{println .}}{{end}}' $1
    echo -e "${YELLOW}Ports:"
    docker inspect --format='{{range $p, $conf := .NetworkSettings.Ports}}{{$p}} -> {{$conf}}{{println}}{{end}}' $1
    echo -e "${CYAN}Environment:"
    docker inspect --format='{{range .Config.Env}}{{println .}}{{end}}' $1
    echo -e "${MAGENTA}Command:"
    docker inspect --format='{{.Config.Cmd}}' $1
    echo -e "${NORMAL}"
}

# Run and mount private file
function docker_private() {
    if ! docker volume ls | grep -q root; then
        docker volume create root
    elif ! docker volume ls | grep -q home; then
        docker volume create home
    fi
    case $(uname) in
    Linux)
        local docker_host=$(docker network inspect --format='{{range .IPAM.Config}}{{.Gateway}}{{end}}' bridge)
        xhost +local:docker >/dev/null
        docker run --rm -it \
            --add-host=host.docker.internal:${docker_host} \
            -v /tmp/.X11-unix/:/tmp/.X11-unix \
            -v root:/root \
            -v home:/home \
            -v ${HOME}/notes:/mnt/notes \
            -v ${HOME}/Downloads:/mnt/Downloads \
            -v ${HOME}/Documents:/mnt/Documents \
            -v ${HOME}/workspace-scratch:/mnt/workspace-scratch \
            -v ${HOME}/workspace-formal:/mnt/workspace-formal \
            -e DISPLAY \
            $*
        ;;
    Darwin)
        xhost +localhost >/dev/null
        docker run --rm -it \
            -v root:/root \
            -v home:/home \
            -v ${HOME}/notes:/mnt/notes \
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
function docker_sudo() {
    docker_private \
        --privileged=true \
        $*
}

# Run private with user
function docker_user() {
    docker_private \
        --privileged=true \
        --user docker \
        $*
}

# killall containers
function docker_kill() {
    if [ -n "$(docker ps -a -q)" ]; then
        docker rm -f $(docker ps -a -q)
    fi
}

#####################
# Golang for Bash/Zsh
#####################

# fast echo go env
alias g='go_env'
# mkdir for golang workspace
alias go_workspace='mkdir -p src pkg bin'

# environmnet for Golang
if [ -d "$HOME/.local/go" ]; then
    export GOROOT="$HOME/.local/go"
    env_insert "PATH" "$GOROOT/bin"
fi

if [ -d "$HOME/go" ]; then
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

# print go env
function go_env() {
    echo -e "${GREEN}GOPATH:${NORMAL}"
    env_list GOPATH
    echo -e "${GREEN}GODEBUG:${NORMAL}"
    env_list GODEBUG
}

# reset $GOPATH
function go_reset() {
    export GOPATH=${GOPATH_BAK-}
    echo -e "${GREEN}successful clear GOPATH \n${RED}GOPATH ==> ${GOPATH}${NORMAL}"
}

# set $PWD to $GOPATH
function go_pwd() {
    export GOPATH=${PWD}
    echo -e "${GREEN}successful set GOPATH \n${RED}GOPATH ==> ${GOPATH}${NORMAL}"
}

function go_proxy() {
    if [ ${GOPROXY:-NOCONFIG} = "NOCONFIG" ]; then
        export GOPROXY=https://goproxy.cn
        echo -e "${YELLOW}GOPROXY: ${GOPROXY}${NORMAL}"
    else
        unset GOPROXY
        echo -e "${YELLOW}GOPROXY: disabled${NORMAL}"
    fi
}

#####################
# Python for Bash/Zsh
#####################

# specified for ${HOME}/.local/bin
if [ ! -d ${HOME}/.local/bin ]; then
    mkdir -p ${HOME}/.local/bin
fi
env_insert "PATH" "${HOME}/.local/bin"

# specified for ${HOME}/Library/Python
if [ -d ${HOME}/Library/Python ]; then
    for file in $(ls ${HOME}/Library/Python); do
        if [ -d ${HOME}/Library/Python/${file}/bin ]; then
            env_insert "PATH" "${HOME}/Library/Python/${file}/bin"
        fi
    done
fi

# change directory to python3 user base
function py_path() {
    cd $(python3 -c 'import site; print(site.USER_BASE)')
}

###################
# Perl for Bash/Zsh
###################

# Using local::lib for Perl modules
PERL_LOCAL_LIB_ROOT="${HOME}/perl5"
if [ -d ${PERL_LOCAL_LIB_ROOT} ]; then
    env_insert "PATH" "${PERL_LOCAL_LIB_ROOT}/bin"
    env_insert "PERL5LIB" "${PERL_LOCAL_LIB_ROOT}/lib/perl5"
    env_insert "PERL_LOCAL_LIB_ROOT" "${PERL_LOCAL_LIB_ROOT}"
    env_amend "PERL_MB_OPT" "--install_base\ \\\"${PERL_LOCAL_LIB_ROOT}\\\""
    env_amend "PERL_MM_OPT" "INSTALL_BASE=${PERL_LOCAL_LIB_ROOT}"
fi

function perl_install() {
    for idx in $(seq $#); do
        eval perl -MCPAN -e \"install \$$idx\"
    done
}

#########################
# JavaScript for Bash/Zsh
#########################

function npm_link_list() {
    ls -F  ${NODE_PATH} | grep -E '@$'
}

# fast echo package.json run
alias j='jq .scripts package.json'

env_amend "NPM_PACKAGES" "${HOME}/.local"
if [ ! -d ${NPM_PACKAGES} ]; then
    mkdir -p ${NPM_PACKAGES}
fi
env_insert "PATH" "${NPM_PACKAGES}/bin"
env_insert "NODE_PATH" "${NPM_PACKAGES}/lib/node_modules"

function npm_rc() {
    if [ ! -f ${PWD}/.npmrc ]; then
        cat <<END >${PWD}/.npmrc
package-lock=false
END
    fi
}

###################
# Java for Bash/Zsh
###################

function mvn_gen() {
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

function mvn_exec() {
    if [ $# -lt 1 ]; then
        return
    elif [ $# -eq 1 ]; then
        mvn exec:java -Dexec.mainClass="$1"
    else
        local i
        local exec_args=""
        for ((i = 2; i <= $#; i++)); do
            eval exec_args=\$\{exec_args\}\"\ \"\$\{${i}\}
        done
        mvn exec:java -Dexec.mainClass="$1" -Dexec.args="${exec_args# }"
    fi
}

###################
# Rust for Bash/Zsh
###################

# environmnet for Rust
if [ -d "$HOME/.cargo/bin" ]; then
    env_insert "PATH" "$HOME/.cargo/bin"
fi

function rustup_proxy() {
    if [ ${RUSTUP_DIST_SERVER:-NOCONFIG} = "NOCONFIG" ]; then
        export RUSTUP_DIST_SERVER="https://rsproxy.cn"
        export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"
        echo -e "${YELLOW}Rustup proxy: ${RUSTUP_DIST_SERVER}${NORMAL}"
    else
        unset RUSTUP_DIST_SERVER
        unset RUSTUP_UPDATE_ROOT
        echo -e "${YELLOW}Rustup proxy: disabled${NORMAL}"
    fi
}

# End of .bash_aliases
