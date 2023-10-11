#!/bin/bash

if [ "$1" = "-a" ] || ["$1" = "--add"]; then
    clear && . bin/withParam/ingresarParam.sh -a $2 $3 $4
fi
