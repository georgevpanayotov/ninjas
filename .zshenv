if [[ -e ~/.ninjas/.path ]]; then
    export NINJAS_PATH=$(cat ~/.ninjas/.path)
else
    echo "Ninjas not installed."
    return
fi

source $NINJAS_PATH/helpers.zsh

typeset -a EXTRA_PACKAGES
parseExtraPackages $*

() {
    rm -rf ~/.ninjas/.hgrc
    rm -rf ~/.ninjas/.gitconfig
    rm -rf ~/.ninjas/.screenrc

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

        local screenRc="$package/screenrc"
        if [[ -e "$screenRc" ]]; then
            createScreenrcIfNeeded
            echo "source $screenRc" >> ~/.ninjas/.screenrc
        fi
    done
}
