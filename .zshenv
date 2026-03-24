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
    local hgrctmp=$(mktemp)
    local gitconfigtmp=$(mktemp)
    local screenrctmp=$(mktemp)

    createRcHeader > $hgrctmp
    createGitConfigHeader > $gitconfigtmp
    createRcHeader > $screenrctmp

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
            echo "%include $hgRc" >> $hgrctmp
        fi

        local gitConfig="$package/gitconfig"
        if [[ -e "$gitConfig" ]]; then
            echo "path = $gitConfig" >> $gitconfigtmp
        fi

        local screenRc="$package/screenrc"
        if [[ -e "$screenRc" ]]; then
            echo "source $screenRc" >> $screenrctmp
        fi
    done

    # Only disrupt the real files if the tmps actually need to replace them. This helps avoid
    # situations where the config file is briefly missing during a subshell invocation.
    replaceIfDifferent ~/.ninjas/.gitconfig $gitconfigtmp
    replaceIfDifferent ~/.ninjas/.hgrc $hgrctmp
    replaceIfDifferent ~/.ninjas/.screenrc $screenrctmp
}
