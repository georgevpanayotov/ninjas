if [[ -e ~/.ninjas/.path ]]; then
    NINJAS_PATH=$(cat ~/.ninjas/.path)
else
    echo "Ninjas not installed."
    exit 1
fi

source $NINJAS_PATH/helpers.zsh

packages=($(loadPackages))

for package in $packages; do
    envScript="$package/zshenv"

    if [[ -f "$envScript" ]]; then
        source "$envScript"
    fi
done
