if [[ "$NINJAS_PATH" == "" ]]; then
    echo "Ninjas not loaded."
    return
fi

loadPackage() {
    local package;package="$1"

    local fnPath;fnPath="$package/zshfn"
    if [[ -d "$fnPath" ]]; then
        fpath[1,0]=("$fnPath")
    fi

    local binPath;binPath="$package/bin"
    if [[ -d "$binPath" ]]; then
        PATH="$binPath:$PATH"
    fi

    local hgRc;hgRc="$package/hgrc"
    if [[ -e "$hgRc" ]]; then
        createHgrcIfNeeded
        echo "%include $hgRc" >> ~/.ninjas/.hgrc
    fi

    local gitConfig;gitConfig="$package/gitconfig"
    if [[ -e "$gitConfig" ]]; then
        createGitConfigIfNeeded
        echo "path = $gitConfig" >> ~/.ninjas/.gitconfig
    fi

    # Load this again after setting the fpath so that any custom completions in the package are
    # loaded.
    compinit

    local rcScript;rcScript="$package/zshrc"
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

    local packages;packages=($(listPackages))
    local package;package=""

    for package in $packages; do
        loadPackage $package
    done
}
