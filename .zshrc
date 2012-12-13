PS1='[%c]$ '
alias build='./build'
alias ~="cd ~"
PATH=$PATH:~/bin
PATH=$PATH:/usr/share/TEE-CLC-10.1.0
export SVN_EDITOR=vim
export TF_AUTO_SAVE_CREDENTIALS=save
export TF_DIFF_COMMAND="mvim -d %1 %2"
export TF_MERGE_COMMAND="opendiff %1 %2 -ancestor %3 -merge %4"
pan1() { cd /src/panopto1/$*}
pan2() { cd /src/panopto2/$*}
pan3() { cd /src/panopto3/$*}
src() { cd /src/$*}
vimf() { vim "$(find . -iname $1)" }

alias mntgp="mount -t smbfs //gpanayotov@gpanayotov.panopto.local/c$ ~/win/gpanayotov"
alias mnttf="mount -t smbfs //gpanayotov@tfs.panopto.local/tfsbuilds ~/win/tfs"
alias mntpan2="mount -t smbfs //gpanayotov@panoptogon2.panopto.local/public ~/win/panoptogon2"
alias mntpan="mount -t smbfs //gpanayotov@panoptogon.panopto.local/public ~/win/panoptogon"
alias 0it="tr \"\\n\" \"\\0\""

if [[ $(screen -ls | grep -i gpanayotov | wc -l) -eq 0 ]]
    then
        screen -d -m -S gpanayotov
    fi
psed() { perl -pi -e $* }


