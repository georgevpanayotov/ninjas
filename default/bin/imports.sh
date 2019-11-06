#!/bin/zsh

IMPORT_NAME=$1
shift
grep -hr "^import.*$IMPORT_NAME" $* | sort | uniq
