#!/bin/zsh
PWD_SHORT=$(dirs -p | head -n 1)
echo -ne "\ek$PWD_SHORT\e\\"
