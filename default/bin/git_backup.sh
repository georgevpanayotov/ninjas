#!/bin/zsh

# Backs up listed git repos to an output directory.
# Usage:
#   git_backup.sh $REPO_1 $REPO_2 -o $BACKUP_PATH
#
# For each repo a backup folder is created under:
#   $BACKUP_PATH/${REPO_NAME}_backup
# With files `path`, `bundle`, `stash` and `remotes`.
# `path` is the original path of the repo
# `bundle` is a git bundle that can be used to recreate a full copy of the given repo.
# `stash` is just a list of revs for the stash list. This is needed because the bundle command
# doesn't save the stash revs.
# `remotes` is a list of the remotes in this repo and their URLs.

set -A REPOS
while [[ "$1" != "" ]]; do
    if [[ "$1" == "-o" ]]; then
        if [[ "$OUT_PATH" != "" ]]; then
            echo "Error: already specified an outpath"
            exit 1
        fi
        shift
        OUT_PATH="$(realpath "$1")"
    else
        REPOS+="$1"
    fi

    shift
done

if [[ ${#REPOS} -eq 0 ]]; then
    # By default, back up the curent dir.
    REPOS=(.)
fi

if [[ "$OUT_PATH" == "" ]]; then
    echo "Must specify backup destination."
    exit 2
fi

if [[ ! -d "$OUT_PATH" ]]; then
    echo "Backup destination $OUT_PATH is not a directory."
    exit 3
fi

while [[ ${#REPOS} -ne 0 ]]; do
    REPO=$REPOS[1]

    echo "Backing up: $REPO to $OUT_PATH"

    git -C "$REPO" rev-parse --git-dir &>| /dev/null || echo "$REPO is not a repo"

    REPO_NAME="$(basename "$(realpath $REPO)")"

    BACKUP_PATH="$OUT_PATH/${REPO_NAME}_backup"

    mkdir -p "$BACKUP_PATH"
    set -A STASH_REVS

    # Stashes don't apply to bare repos.
    IS_BARE=$(git -C "$REPO" rev-parse --is-bare-repository | tr -d "\n")
    if [[ $IS_BARE == "false" ]]; then
        git -C "$REPO" stash list --format="%H %s" > "$BACKUP_PATH/stash"

        # Need to explicitly include stashes in the bundle because "--all" doesn't cover it.
        git -C "$REPO" stash list --format="%H" | while read i ; do
            STASH_REVS+=$i
        done
    fi

    git -C "$REPO" bundle create "$BACKUP_PATH/bundle" --all $STASH_REVS

    git -C "$REPO" remote -v > "$BACKUP_PATH/remotes"

    realpath "$REPO" > $BACKUP_PATH/path

    shift REPOS
done
