unsetopt beep
bindkey -e
bindkey ^x accept-search

if [[ "$STY" != "" ]]; then
    # we are using a screen
    stitle.sh

    chpwd()
    {
        stitle.sh
    }
fi

if [[ $(screen -ls | grep -i gpanayotov | wc -l) -eq 0 ]]
    then
        screen -d -m -S gpanayotov
    fi

pvim()
{
    vim $@ -c "set nomod" -
}

bindkey ';5D' backward-word
bindkey ';5C' forward-word
set -o emacs

# The following lines were added by compinstall
zstyle :compinstall filename '/Users/george/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
