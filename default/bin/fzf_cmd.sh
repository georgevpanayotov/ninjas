#!/bin/zsh

if [[ -e .fzf_paths ]]; then
    find $(cat .fzf_paths) -type f 2> /dev/null
elif [[ -x .fzf_cmd ]]; then
    ./.fzf_cmd
elif [[ -e .fzf_cmd ]]; then
    echo ".fzf_cmd not executable"
    exit 1
else
    find * -type f 2> /dev/null
fi
