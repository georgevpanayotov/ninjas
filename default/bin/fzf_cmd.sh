#!/bin/zsh

if [[ -e .fzf_paths ]]; then
    find $(cat .fzf_paths) -type f 2> /dev/null
else
    find * -type f 2> /dev/null
fi
