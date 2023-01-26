if [[ -e ~/.ninjas/.path ]]; then
    export NINJAS_PATH=$(cat ~/.ninjas/.path)
else
    echo "Ninjas not installed."
    return
fi

source $NINJAS_PATH/helpers.zsh

() {
    rm -rf ~/.ninjas/.hgrc
    rm -rf ~/.ninjas/.gitconfig

    local packages=($(listPackages))
    local package=""

    for package in $packages; do
        envScript="$package/zshenv"

        if [[ -f "$envScript" ]]; then
            source "$envScript"
        fi

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
    done
}
