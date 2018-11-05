let s:packages = split(system('source $NINJAS_PATH/helpers.zsh; loadPackages'), '\n')

for s:package in s:packages
    let &rtp .= ',' . s:package . '/vim'
endfor
