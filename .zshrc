packages=($(loadPackages))

rm -rf .ninjas/.hgrc
rm -rf .ninjas/.gitconfig

() {
    for package in $packages; do

        local rcScript="$package/zshrc"
        if [[ -f "$rcScript" ]]; then
            source "$rcScript"
        fi

        local fnPath="$package/zshfn"
        if [[ -d "$fnPath" ]]; then
            fpath[1,0]=("$fnPath")
        fi

        local binPath="$package/bin"
        if [[ -d "$binPath" ]]; then
            PATH="$PATH:$binPath"
        fi

        local hgRc="$package/hgrc"
        if [[ -e "$hgRc" ]]; then
            echo "%include $hgRc" >> .ninjas/.hgrc
        fi

        local gitConfig="$package/gitconfig"
        if [[ -e "$gitConfig" ]]; then
            maybeCreateGitConfig
            echo "path = $gitConfig" >> .ninjas/.gitconfig
        fi
    done
}
