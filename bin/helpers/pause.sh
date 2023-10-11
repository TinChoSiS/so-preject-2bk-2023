#!/bin/bash

# Función para pausar la ejecución del programa
# Si le pasamos true como segundo parámetro, limpiará la pantalla
function pause {

    if [ -z "$1" ]; then
        echo "Error: pause necesita un parámetro"
        exit 1
    fi

    echo ""
    read -s -n 1 -p "$1"

    if [ "$2" = true ]; then
        clear
    fi
}
