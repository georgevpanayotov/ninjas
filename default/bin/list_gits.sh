#!/bin/zsh

# Lists out all of the git repos in the current path. Only lists the repos directly below the
# current dir.

# By default, search the curent dir.
SRC_ROOT=.

if [[ "$1" != "" ]]; then
    SRC_ROOT="$1"
fi

find "$SRC_ROOT" -mindepth 1 -maxdepth 1 -type d | while read i; do
    pushd -q "$i"

    # Print out the path if it is a git directory.
    git rev-parse --git-dir &>| /dev/null && pwd

    popd -q
done
