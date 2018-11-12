#!/bin/zsh

INCLUDE_NAME=$1
shift
grep -hr "#include.*$INCLUDE_NAME" $* | sort | uniq
