if [[ -e ~/.ninjas/.path ]]; then
    export NINJAS_PATH=$(cat ~/.ninjas/.path)
else
    echo "Ninjas not installed."
    return
fi

source $NINJAS_PATH/helpers.zsh

() {
    local packages;packages=($(listPackages))
    local package;package=""

    for package in $packages; do
        envScript="$package/zshenv"

        if [[ -f "$envScript" ]]; then
            source "$envScript"
        fi
    done
}
