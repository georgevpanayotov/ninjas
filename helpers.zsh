#!/bin/zsh

loadPackages() {
    echo $NINJAS_PATH/default
    find $HOME/.ninjas/ -maxdepth 1 -mindepth 1 -type d
}

relink() {
    if [[ ( -L $2 ) || ( ! ( -e $2 ) ) ]]; then
        echo "Linking $2 to point to $1"
        ln -s -f $1 $2
    else
        echo "File $2 already present. Please remove it first"
        exit 1
    fi
}

maybeCreateGitConfig() {
    if [[ ! -e .ninjas/.gitconfig ]]; then
        echo "[include]" >> .ninjas/.gitconfig
    fi
}
