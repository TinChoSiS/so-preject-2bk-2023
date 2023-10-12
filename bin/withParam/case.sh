#!/bin/bash

function casosDeParametros() {
    echo -e "${MAGENTA}Uso: $0 -c add <telefono_cliente> <codigo_producto> <cantidad>${N}"
}

if [ "$1" = "add" ]; then
    clear && . $WORKPATH/bin/withParam/ingresarParam.sh $1 $2 $3 $4
    exit 0
else
    echo -e "${MAGENTA}ERROR: parámetros incorrectos${N}"
    casosDeParametros
    exit 1
fi
