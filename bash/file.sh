#!/bin/bash

visit() {
    if [ -d "$1" ]; then
        for i in "$1"/*; do
            visit "$i"
        done
    elif [ -f "$1" ]; then
        echo "$1"
    fi
}

visit "$1"
# ls ICTF/*    # lists all files and folders in recursive manner

##./file.sh "./bcs'24"
## ./file.sh ".."   ## safety hishebe pass filenames in quotation. naile "cuber ctf" emon name dhorte parbena

folder_path="/path/to/your/folder"

# Recursively list all files and directories
find "$folder_path" -type f   # For files only


for item in *
do
    echo "$item"
done

# ($(find ...)) which splits on whitespace by default.