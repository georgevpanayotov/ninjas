#!/bin/zsh

listPackages() {
    echo $NINJAS_PATH/default
    find -L $HOME/.ninjas/ -maxdepth 1 -mindepth 1 -type d | sort
}

listVimPaths() {
    packages=($(listPackages))

    for package in $packages; do
        if [[ -e $package/vimpaths ]]; then
            cat $package/vimpaths
        fi
    done
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
    if [[ ! -e ~/.ninjas/.gitconfig ]]; then
        echo "[include]" >> ~/.ninjas/.gitconfig
    fi
}
