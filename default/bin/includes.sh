#!/bin/zsh

INCLUDE_NAME=$1
shift
grep -hr "^#\(include\|import\).*$INCLUDE_NAME" $* | sort | uniq
