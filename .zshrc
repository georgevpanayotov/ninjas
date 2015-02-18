PS1='[%c]$ '
alias build='./build'
alias ~="cd ~"
PATH=$PATH:~/bin
PATH=$PATH:$(cat ~/.ninjas)/utils
export SVN_EDITOR=vim
export EDITOR=vim
vimf() { vim "$(find . -iname $1)" }

alias 0it="tr \"\\n\" \"\\0\""

if [[ $(screen -ls | grep -i gpanayotov | wc -l) -eq 0 ]]
    then
        screen -d -m -S gpanayotov
    fi
psed() { perl -pi -e $* }

bindkey ';5D' backward-word
bindkey ';5C' forward-word
set -o emacs

autoload -U compinit 
compinit
