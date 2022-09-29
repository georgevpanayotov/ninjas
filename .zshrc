if [[ "$NINJAS_PATH" == "" ]]; then
    echo "Ninjas not loaded."
    return
fi

preLoadPackage() {
    local package="$1"
    local preExecScript="$package/prezshrc"
    if [[ -f "$preExecScript" ]]; then
        source "$preExecScript" 
    fi
}

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
        createHgrcIfNeeded
        echo "%include $hgRc" >> ~/.ninjas/.hgrc
    fi

    local gitConfig="$package/gitconfig"
    if [[ -e "$gitConfig" ]]; then
        createGitConfigIfNeeded
        echo "path = $gitConfig" >> ~/.ninjas/.gitconfig
    fi

    # Load this again after setting the fpath so that any custom completions in the package are
    # loaded.
    compinit

    local rcScript="$package/zshrc"
    if [[ -f "$rcScript" ]]; then
        source "$rcScript"
    fi
}

rm -rf ~/.ninjas/.hgrc
rm -rf ~/.ninjas/.gitconfig

() {
    zstyle :compinstall filename '/Users/george/.zshrc'
    autoload -Uz compinit
    compinit

    local packages=($(listPackages))
    local package=""

    for package in $packages; do
        preLoadPackage $package
    done

    for package in $packages; do
        loadPackage $package
    done
}
