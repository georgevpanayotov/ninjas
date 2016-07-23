if [[ "$STY" != "" ]]; then
    # we are using a screen
    stitle.sh

    chpwd()
    {
        stitle.sh
    }
fi

PS1='[%c]$ '
alias build='./build'
alias ~="cd ~"
PATH=$PATH:~/bin
PATH=$PATH:$(cat ~/.ninjas)/utils
export SVN_EDITOR=vim
export EDITOR=vim
vimf() { vim "$(find . -iname $1)" }

alias 0it="tr \"\\n\" \"\\0\""
alias vimx="xcdoc | tail -n 1 | 0it | xargs -0 -o vim -o"

if [[ $(screen -ls | grep -i gpanayotov | wc -l) -eq 0 ]]
    then
        screen -d -m -S gpanayotov
    fi
psed() { perl -pi -e $* }

bindkey ';5D' backward-word
bindkey ';5C' forward-word
set -o emacs

# The following lines were added by compinstall
zstyle :compinstall filename '/Users/george/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history
