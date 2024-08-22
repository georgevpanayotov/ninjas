#!/bin/zsh

FORMATTER=$1

shift

INPUT=$(cat)
OUTPUT=$(echo $INPUT | $FORMATTER $* 2> ~/wf_err)

EC=$?

if [[ "$EC" == "0" ]]; then
    echo $OUTPUT
else
    echo $INPUT
    exit $EC
fi
