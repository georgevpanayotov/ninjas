if [[ -e ~/.ninjas/.path ]]; then
    export NINJAS_PATH=$(cat ~/.ninjas/.path)
else
    echo "Ninjas not installed."
    return
fi

source $NINJAS_PATH/helpers.zsh

packages=($(listPackages))

for package in $packages; do
    envScript="$package/zshenv"

    if [[ -f "$envScript" ]]; then
        source "$envScript"
    fi
done
