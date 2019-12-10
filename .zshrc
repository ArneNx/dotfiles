# This config started out by copying David Vilars .zshrc who merged it from
# david rybach's and patrick sudowe's zshrc files and his old bashrc stuff
#
# It's been heavily modified by me this then by adding stuff that I found 
# somewhere. Therefor I take any credit for  anything you find here

export SHELL=/bin/bash # Just in case we were started from bash

# setup path for my extensions
fpath=(~/.zsh.d $fpath)         

#HOSTNAME=`hostname` # Just in case
#if  [ "${HOSTNAME[0,7]}" = cluster ]; then
#    source /rbi/sge/default/common/settings.sh
#fi

#### Colors ####
autoload -U colors && colors
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxehedabagacad  # see 'man ls'
export LS_COLORS='*.swp=-1;44;37:*,v=5;34;93:*.vim=35:no=0:ex=1;31:fi=0:di=1;36:ln=33:or=5;35:mi=1;40:pi=93:so=33:bd=44;37:cd=44;37:*.jpg=1:*.jpeg=1:*.JPG=1:*.gif=1:*.png=1:*.jpeg=1:*.ppm=1:*.pgm=1:*.pbm=1:*.c=1;33:*.C=1;33:*.h=1;33:*.cc=1;33:*.awk=1;33:*.pl=1;33:*.py=1;33:*.m=1;33:*.rb=1;33:*.gz=0;33:*.tar=0;33:*.zip=0;33:*.lha=0;33:*.lzh=0;33:*.arj=0;33:*.bz2=0;33:*.tgz=0;33:*.taz=33:*.dmg=0;33:*.html=36:*.htm=36:*.doc=36:*.txt=1;36:*.o=1;36:*.a=1;36'   
# see http://linux-sxs.org/housekeeping/lscolors.html
# http://linux.die.net/man/5/dir_colors
export ZLS_COLORS=$LS_COLORS
export GREP_COLOR=32    # some greps have colorized ouput. enable...
export GREPCOLOR=32     # dito here


#########################                             
#export LD_LIBRARY_PATH=/lib:/usr/lib:/usr/local/lib:/usr/X11R6/lib
# add cuda for tensorflow
#export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cuda/lib64:/usr/local/cuda/extras/CUPTI/lib64"
#export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:/usr/local/cudnn-8.0-v5.1/lib64"
#export CUDA_HOME=/usr/local/cuda/
#export CUDNN=/usr/local/cudnn-8.0-v5.1

#source /u/standard/settings/sge_settings.sh
#export QSUBOPT="-l h_fsize=50G -M nix@i6.informatik.rwth-aachen.de -m n -cwd -j y -w n -S /bin/bash"
#source /rbi/sge/default/common/settings.sh
#######################
                                   

#### Path ####
# MYPATH=${MYPATH}:$HOME/bin
# PATH=${MYPATH}:${PATH}
# export PATH                                           
export PATH=$HOME/bin:/usr/local/bin:$PATH
                           
                                 
#### General Environment Setup #### 
                        
# Disable C-s to stop terminal output
stty -ixon -ixoff


# General zsh settings - usability
setopt extendedglob
setopt NO_BEEP
setopt AUTO_CD

# editing widget
bindkey '^B' vi-backward-blank-word

# nice title in window title-bar
source $HOME/.zsh.d/zsh_set_title_tab


                                  
#### Exports ####

#export LC_CTYPE=en_US.UTF-8

HISTSIZE=10000
SAVEHIST=3000
HISTFILE=$HOME/.zsh_history
setopt appendhistory extendedglob nomatch \
       INTERACTIVE_COMMENTS MAGIC_EQUAL_SUBST LIST_TYPES NUMERIC_GLOB_SORT \
       HIST_IGNORE_ALL_DUPS
unsetopt NOMATCH AUTO_PARAM_KEYS AUTO_REMOVE_SLASH FLOW_CONTROL

# zle -N zle-keymap-select color-cursor
bindkey -e
bindkey "^[Od" backward-word
bindkey "^[Oc" forward-word
bindkey "^[Oa" beginning-of-line
bindkey "^[Ob" end-of-line
bindkey "^[" vi-cmd-mode         

# In order to have the esc-key to react inmediately
# This can have side-effects, as it is not esc-key specific, but so far
# I haven't found any.
export KEYTIMEOUT=1        

autoload -U zmv

#### Completion ####

## Disabled do to startup speed
#fpath=(~/.zshcompletions $fpath)

autoload -Uz compinit
compinit                

setopt autolist automenu                  

zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*' completer _complete _match _prefix
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*' menu select=3
zstyle ':completion:*' use-cache on	# make complex completions faster
zstyle ':completion:*' cache-path ~/.zsh.d/cache                       


# color in completions
# http://linuxshellaccount.blogspot.com/2008/12/color-completion-using-zsh-modules-on.html     
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-colors 'reply=( "=(#b)(*$VAR)(?)*=00=$color[green]=$color[bg-green]" )'
zstyle ':completion:*:*:*:*:hosts' list-colors '=*=30;41'

# setup hostname completion for ssh
# http://zshwiki.org/home/examples/compsys/hostnames 
[ -f ~/.ssh/config ] && : ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}
[ -f ~/.ssh/known_hosts ] && : ${(A)ssh_known_hosts:=${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*}}
zstyle ':completion:*:*:*' hosts $ssh_config_hosts $ssh_known_hosts

# rake for ruby on rails
source $HOME/.zsh.d/rake_completion.zsh


#### Local history ####

function localHistory()
{
  tail .history.$USER 2>/dev/null
}

# filter commands that should not appear in history
#alias useHistory='grep -v "^ls$\|^ll$\|^cd \|^localHistory$\|^hgrep[$ ]\|^bg$\|^fg$\|^qsm$|^quser$\|^qstat" | wc -l'
alias useHistory='grep -v "^ls$\|^ll$\|^cd \|^localHistory$\|^hgrep \|^htail\|^bg$\|^fg$\|^man " | wc -l'

# main local history function:
# - only write history if current directory belongs to me
# - only write history if useHistory filter says "1"
# - add timestamp and historyline
function myLocalHistory()
{
  if [[ `ls -ld "$PWD" | awk '{print $3}'` == "$USER" ]] ; then
    HISTORYLINE="$*"
    if [[ `echo $HISTORYLINE | useHistory` -eq "1" ]] ; then
      #(date +%F.%H-%M-%S | tr -d '\n' ; echo " $HISTORYLINE") >>.history
      (date +%F.%H-%M-%S | tr -d '\n' ; echo " $HISTORYLINE") >>.history.$USER
      sync
    fi
  fi
}                             
function hdgrep()
{
  tr -d '\0' < .history.$USER | grep -i "$1" 2>/dev/null
}
function hgrep()
{
  tr -d '\0' < .history.$USER | grep -i "$1" 2>/dev/null | cut -f 2- -d ' '
}
function htail()
{
     tail .history.$USER 2>/dev/null
}

#### Aliases ####

alias h="htail"

alias topc="top -b -n 1 | head -15"

alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

alias ..='cd ..;'
alias ...='cd ../..;'
alias ....='cd ../../..;'
alias .....='cd ../../../..;'
alias ......='cd ../../../../..;'

alias sortc='sort | uniq -c'


# Neat little hack to set color in a linux and a mac environment 
ls --color -d . &>/dev/null 2>&1 && alias ls='ls --color=tty' || alias ls='ls -G'

# alternative way
#is_mac=(`uname -s` = 'Darwin')
#if [ $is_mac ]; then
#    alias ls='ls --color=tty'
#else
#    alias ls='ls -G'
#fi

alias l='ls -lah'
alias ll='ls -lh'
alias ltr='ls -ltr'
alias lSr='ls -lSr'
alias lss='ls -sS'

alias grep='grep --color=auto'
alias less="less -i" #ignore case
alias zcat="zcat -f"

alias ducks='du -cks * | sort -rn|head -11' # Lists the size of all the folders$
alias systail='tail -f /var/log/system.log'
alias profileme="history | awk '{print \$2}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"

alias realname='python -c "import os, sys; print os.path.realpath(sys.argv[1]);"'

#### Functions ####
function mkcdir()
{
    mkdir $1
    cd $1
}

function mkdd {
    DIRNAME=$(date +%Y-%m-%d)
    if [ $# -gt 0 ] ; then
        DIRNAME="$(echo $* | sed 's: :_:g').${DIRNAME}"
    fi
    mkdir -p $DIRNAME
    cd $DIRNAME
}

autoload -U promptinit && promptinit
prompt jtp

#### Settings for different system ####
SYSTEM_RC="$HOME/.zsh.d/zshrc."`uname -s`
if [ -e $SYSTEM_RC ]; then
    source $SYSTEM_RC
else
    echo "Unknown system or missing file, no system settings loaded"
fi

#### Local settings for differnt computers ####
LOCAL_RC=$HOME/.zshrc.local
if [ -e $LOCAL_RC ]; then
    source $LOCAL_RC
fi

if [[ -x /usr/lib/command-not-found ]] ; then
        function command_not_found_handler() {
                /usr/lib/command-not-found --no-failure-msg -- $1
        }
fi

bindkey -s '\eu' '^Ucd ../^M'

plugins=(dirhistory)

function swap()         
{
    local TMPFILE=tmp.$$
    mv "$1" $TMPFILE
    mv "$2" "$1"
    mv $TMPFILE "$2"
}

# source /u/nix/src/sisyphus/tools/v.zsh 

alias cn02="ssh cluster-cn-02"
alias cn01="ssh cluster-cn-01"
alias cn211="ssh cluster-cn-211"
alias activate="source /u/nix/opt/returnn_cpu/bin/activate"
alias q="qstat -u nix"
alias na="ssh natrium"
alias rh="ssh rhodium"
alias qgpu="qstat | grep GPU ; qstat | grep GPU | wc -l"
alias qover="/u/nix/bin/qover"
alias qjob="q -xml | grep -e 'JB_name'"
alias lr="less -R"
alias autopep8="/u/peter/opt/python-fuel/bin/autopep8 --max-line-length 120" 
alias sis=/u/nix/src/sisyphus/sis.sh
alias qlogingpu1080="qlogin -now y -l h_vmem=16G -l h_rt=08:00:00 -l num_proc=1 -l gpu=1 -l qname=*1080*"
alias qlogingpu="qlogin -now y -l h_vmem=8G -l h_rt=01:00:00 -l num_proc=1 -l gpu=1"
alias rp="realpath"
alias cleanup="for clean in CopyResumeTrain.*/output/models/clean_up.sh; do \$clean; rm \$clean; done"
alias createdummies="for dum in CopyResumeTrain.*/output/models/create_dummies.sh; do \$dum; rm \$dum; done"
alias show_dev_score="cat model.learning_rates | grep \"'dev_score': \" |grep -o \"[0-9].[0-9]*\""
alias show_train_score="cat model.learning_rates | grep \"'train_score': \" |grep -o \"[0-9].[0-9]*\""
alias show_learning_rate="cat model.learning_rates | grep \"learningRate=\" |grep -o \"[0-9].[0-9]*[e-]*[0-9]*,\" |grep -o \"[0-9].[0-9]*[e-]*[0-9]*\""
alias show_ips="ifconfig | grep -Eo 'inet (addr:)?([0-9]*\.){3}[0-9]*' | grep -Eo '([0-9]*\.){3}[0-9]*' | grep -v '127.0.0.1'"
alias run_docker_dev0="docker-compose run --service-ports --name anix_dev_GPU0 -d -e NVIDIA_VISIBLE_DEVICES=0 server_develop"
alias run_docker_job0="docker-compose run --name anix_prod_GPU0 -d -e NVIDIA_VISIBLE_DEVICES=0 server_job"
alias show_docker_log0="docker logs -f /anix_prod_GPU0"
