#!/bin/zsh

if [[ -e .fzf_paths ]]; then
    find $(cat .fzf_paths) -type f
else
    find * -type f
fi
