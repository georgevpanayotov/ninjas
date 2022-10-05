#!/usr/bin/python3

import os, sys

# For use with the bash PROMPT_COMMAND
# scans up to find if the current pwd lives in a repo or home (~)
# outputs (without newline) the name of that repo (or ~ for home) followed by a ":"

def find_containing_folder(special_dirs, dot_files):
    # keep track of where we started
    starting_cwd=os.getcwd();
    outname = None

    # go up the dir tree until you find a special folder or repo
    while os.getcwd() != "/" and outname is None:

        # dot_files (like .git) imply that a repo exists here
        # The "file" can actually be a folder (like .git)
        for dot_file in dot_files:
            if os.path.exists(os.path.join(os.getcwd(), dot_file)):
                outname = os.getcwd()

        # check if the dir is a special dir
        # this takes precedence so if a dir is both special and a repo, it's special
        # name will be printed
        if os.getcwd() in special_dirs:
            outname = special_dirs[os.getcwd()]

        # only go up if we need to, at the end of this we want the cwd to be the
        # folder that we found
        if outname is None:
            # go up to the next level
            os.chdir(os.path.dirname(os.getcwd()))

    # if we found a dir (repo or special) output its name
    # but only if we are in a subfolder (not in the folder itself)
    # because that would be redundant
    if (outname is not None) and (starting_cwd != os.getcwd()):
        sys.stdout.write(os.path.basename(outname) + ": ")

# only run when invoked as a script
if __name__ == "__main__":
    # We care about hg and git clients as well as any clients configured via
    # PROMPT_HEADER_DOT_FILES.
    special_dirs = {os.environ["HOME"] : "~"}
    env_dot_files = []
    if "PROMPT_DOT_FILES" in os.environ:
        env_dot_files = os.environ["PROMPT_DOT_FILES"].split(":")
    dot_files = [".hg", ".git"]
    dot_files.extend(env_dot_files)

    find_containing_folder(special_dirs, dot_files)
