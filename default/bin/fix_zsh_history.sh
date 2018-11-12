#!/bin/zsh

PERM_HISTORY=$(cat ~/.zshpermanenthistory | sort | uniq)
echo $PERM_HISTORY > ~/.zshpermanenthistory
