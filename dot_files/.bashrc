#### CBD .bashrc file: 9/3/2023

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
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

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
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'


# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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


#### CBD Edits -----------------------


### CBD local ~/bin
export PATH="/home/cdaniels/bin:$PATH"


### Aliases -----------------------
## Safety
alias rm="rm -i"
alias mv="mv -i"
alias cp="cp -i"
set -o noclobber

## Listing, directories, and motion
alias ll="ls -alrtF --color"
alias la="ls -A"
alias l="ls -CF"
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias m='less'
alias ..='cd ..'
alias ...='cd ..;cd ..'
alias md='mkdir'
alias cl='clear'
alias du='du -ch --max-depth=1'
alias treeacl='tree -A -C -L 2'

## Text and editor commands
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'

### Emacs -----------------------
# Install required for emacs-doom (suggestted rg, fd and jq be installed)
export PATH="~/.emacs.d/bin:$PATH"

alias em='emacs -nw'
alias emacs='emacs -nw'
#alias emacs='emacsclient -a emacs'
export EDITOR='emacs -nw'
#export EDITOR='emacsclient -a emacs'


###  Modern Shell Commands -----------------------
##  Installed with apt or git and then linked to ~/bin

## rg (grep replacement): ln -s /usr/bin/rgrep ~/bin/rg

## dust (du replacement)

## fd (fdfind rep): ln -s /usr/bin/fdfiind ~/bin/fd

## bat (cat replacement; installed as batcat); ln -s /usr/bin/batcat ~/bin/bat

## jq (JSON processor)

##  fzf (fuzzy finder, git fixes autocompletion: https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh ): ln -s ~/.fzf/bin/fzf ~/bin/fz
[ -f ~/.fzf.bash ] && source ~/.fzf.bash




#### Optional Non-Standard Configurations

### Julia -----------------------
export PATH="/home/cdaniels/julia/bin:$PATH"


### Java (used by Clojure)
export _JAVA_OPTIONS=-Xmx4096m


### Python -----------------------
##  path to allow ai_utilites and fastbook (needed because there are problem pip install)
#export PYTHONPATH=${PYTHONPATH}:${HOME}
export PYTHONPATH=${PYTHONPATH}:"/home/cdaniels/python_modules/"


### CUDA -----------------------
# Set up default CUDA gpus. Here we assume that gpu=0 is reserved for the display
export CUDA_DEVICE_ORDER=PCI_BUS_ID
#export CUDA_VISIBLE_DEVICES=1,2
#export CUDA_VISIBLE_DEVICES=2,1
#export CUDA_VISIBLE_DEVICES=1,2 # ADDED `0` 6/17/2022
nvidia-smi -pm ENABLED &> /dev/null
nvidia-smi -ac 850,1912 &> /dev/null

# Enable CUDA bin programs
# export PATH="/usr/local/cuda-10.1/bin:/usr/local/cuda-10.1/NsightCompute-2019.1:$PATH"
export PATH=/usr/local/cuda-12./bin${PATH:+:${PATH}}


### Babashka -----------------------
# repl for Babashka, native Clojure interpreter. bb installed in ~/bin as a binary
alias bbr='rlwrap bb'
export BABASHKA_PRELOADS="(require '[clojure.java.shell :refer [sh]])"
_bb_tasks() {
    COMPREPLY+=(`bb tasks |tail -n +3 |cut -f1 -d ' '`)
}
# autocomplete filenames as well
complete -f -F _bb_tasks bb


### Google Cloud SDK -----------------------

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/cdaniels/google-cloud-sdk/path.bash.inc' ]; then source '/home/cdaniels/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/cdaniels/google-cloud-sdk/completion.bash.inc' ]  ; then source /home/cdaniels/google-cloud-sdk/completion.bash.inc; fi


#### Mamba Initialization
## Add mamba directly or with https://github.com/prairie-guy/gpu_setup/blob/master/install-server-mamba-1.sh
##
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/cdaniels/mambaforge/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/cdaniels/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/home/cdaniels/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="/home/cdaniels/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/home/cdaniels/mambaforge/etc/profile.d/mamba.sh" ]; then
    . "/home/cdaniels/mambaforge/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<
mamba activate fastai
