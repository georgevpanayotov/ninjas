if [[ "$NINJAS_PATH" == "" ]]; then
    echo "Ninjas not loaded."
    return
fi

typeset -a PROMPT_TAGS

() {
    zstyle :compinstall filename '/Users/george/.zshrc'
    autoload -Uz compinit
    compinit

    local packages=($(listPackages))
    local package=""

    # Create tmp files to build the hgrc, gitconfig, and screenrc.
    local hgrctmp=$(mktemp)
    local gitconfigtmp=$(mktemp)
    local screenrctmp=$(mktemp)

    createRcHeader > $hgrctmp
    createGitConfigHeader > $gitconfigtmp
    createRcHeader > $screenrctmp

    for package in $packages; do
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

    for package in $packages; do
        local preExecScript="$package/prezshrc"
        if [[ -f "$preExecScript" ]]; then
            source "$preExecScript"
        fi
    done

    for package in $packages; do
        local rcScript="$package/zshrc"
        if [[ -f "$rcScript" ]]; then
            source "$rcScript"
        fi
    done
}
