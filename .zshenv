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
    # Create tmp files to build the hgrc, gitconfig, and screenrc.
    createHgrcIfNeeded
    createGitConfigIfNeeded
    createScreenrcIfNeeded

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
            echo "%include $hgRc" >> ~/.ninjas/.hgrc.tmp
        fi

        local gitConfig="$package/gitconfig"
        if [[ -e "$gitConfig" ]]; then
            echo "path = $gitConfig" >> ~/.ninjas/.gitconfig.tmp
        fi

        local screenRc="$package/screenrc"
        if [[ -e "$screenRc" ]]; then
            echo "source $screenRc" >> ~/.ninjas/.screenrc.tmp
        fi
    done

    # Only disrupt the real files if the tmps actually need to replace them. This helps avoid
    # situations where the config file is briefly missing during a subshell invocation.
    replaceIfDifferent ~/.ninjas/.gitconfig ~/.ninjas/.gitconfig.tmp
    replaceIfDifferent ~/.ninjas/.hgrc ~/.ninjas/.hgrc.tmp
    replaceIfDifferent ~/.ninjas/.screenrc ~/.ninjas/.screenrc.tmp
}
