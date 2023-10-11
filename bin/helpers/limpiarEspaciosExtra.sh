#!/bin/bash

function limpiarEspaciosExtra() {
    if [ ! "$1" ]; then
        return 1
    fi
    echo $(echo "$1" | sed -e 's/+/ /g' -e 's/ //g')
}
