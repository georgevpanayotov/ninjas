#!/bin/zsh

hg log -r 'allsuccessors(obsolete())' --template '{node}\n'
