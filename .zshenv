HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=1000

# Useful defines
PS1='[%c]$ '
PATH=$PATH:~/bin
PATH=$PATH:$(cat ~/.ninjas)/utils
TERM=xterm-256color
itup=build
dank=test

export EDITOR=vim
alias vimx="xcdoc | tail -n 1 | 0it | xargs -0 -o vim -o"