PS1='[%c]$ '
alias build='./build'
alias ~="cd ~"
PATH=$PATH:~/bin
export SVN_EDITOR=vim
vimf() { vim "$(find . -iname $1)" }

alias 0it="tr \"\\n\" \"\\0\""

if [[ $(screen -ls | grep -i gpanayotov | wc -l) -eq 0 ]]
    then
        screen -d -m -S gpanayotov
    fi
psed() { perl -pi -e $* }
