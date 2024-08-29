#!/bin/zsh

FORMATTER=$1

shift

INPUT=$(cat)
OUTPUT=$(echo -E "$INPUT" | $FORMATTER $* 2> ~/wf_err)

EC=$?

if [[ "$EC" == "0" ]]; then
    echo -E "$OUTPUT"
else
    echo -E "$INPUT"
    exit $EC
fi
