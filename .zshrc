if [[ "$NINJAS_PATH" == "" ]]; then
    echo "Ninjas not loaded."
    return
fi


() {
    zstyle :compinstall filename '/Users/george/.zshrc'
    autoload -Uz compinit
    compinit

    local packages=($(listPackages))
    local package=""

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
