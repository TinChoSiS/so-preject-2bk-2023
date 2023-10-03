#!/bin/bash

# Ejecuta un spinner por X segundos pasados como argumentos.
function spinner {
    delay=$(($1 * 10))
    spin='-\|/'
    i=1
    while [ $i -lt 20 ]; do
        i=$((i + 1))
        printf "\r${spin:$i%4:1}"
        sleep .1
    done
}
