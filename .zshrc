if [[ "$NINJAS_PATH" == "" ]]; then
    echo "Ninjas not loaded."
    return
fi

loadPackage() {
    local package="$1"

    local fnPath="$package/zshfn"
    if [[ -d "$fnPath" ]]; then
        fpath[1,0]=("$fnPath")
    fi

    local binPath="$package/bin"
    if [[ -d "$binPath" ]]; then
        PATH="$binPath:$PATH"
    fi

    local hgRc="$package/hgrc"
    if [[ -e "$hgRc" ]]; then
        echo "%include $hgRc" >> ~/.ninjas/.hgrc
    fi

    local gitConfig="$package/gitconfig"
    if [[ -e "$gitConfig" ]]; then
        maybeCreateGitConfig
        echo "path = $gitConfig" >> ~/.ninjas/.gitconfig
    fi

    local rcScript="$package/zshrc"
    if [[ -f "$rcScript" ]]; then
        source "$rcScript"
    fi
}

rm -rf ~/.ninjas/.hgrc
rm -rf ~/.ninjas/.gitconfig

() {
    local packages=($(listPackages))
    local package=""

    for package in $packages; do
        loadPackage $package
    done
}

compinit
