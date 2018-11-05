#!/bin/zsh

key_file="$1"

# fall back to the default if no file is passed as a parameter
if [[ "$key_file" == "" ]]; then
    key_file=~/.ssh/authorized_keys
fi

# make sure the file exists
if [[ ! ( -e "$key_file" ) ]]; then
    echo "File $key_file not found"
    exit 1
fi

key_c=$(cat $key_file | wc -l)

key=1

while (( $key <= $key_c )); do

    # grab the key value
    key_value=$(cat $key_file | head -n $key | tail -n 1)

    # write the key value to a temp file
    (echo $key_value > tmpkey)

    # write the key's name
    echo $key_value | cut -d " " -f 3 | tr -d "\n"
    echo -n " "

    # write the key's fingerprint
    ssh-keygen $* -l -f tmpkey

    # move on to the next key
    key=$(( $key + 1 ))

    # remove the temp file
    rm tmpkey
done
