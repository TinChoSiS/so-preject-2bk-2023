#!/bin/bash

# preparamos las variables de trabajo
WORKPATH=$(pwd)
REGISTROS=$WORKPATH/registros
PRODUCTOS=$REGISTROS/productos
VENTAS=$REGISTROS/ventas

# Cargamos todos los helpers
for file in $WORKPATH/helpers/*.sh; do
    . $file
done

# configuramos unos colores para destacar los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# configuramos también el IFS para que no se rompa al leer los archivos
IFS=$'\n'

# Revisamos los argumentos que han entrado
for arg in "$@"; do
    if [ "$arg" == "--help" ] || [ "$arg" == "-h" ]; then
        . $WORKPATH/scripts/help.sh
    fi
    if [ "$arg" == "--init" ] || [ "$arg" == "-i" ]; then
        . $WORKPATH/scripts/initialProducts.sh
    fi
done

# limpiamos pantalla
clear

# El bucle solo se detiene al usar la opción s|S
while true; do

    # Solicitamos la opción imprimiendo las mismas
    read -p "##################
    Ingrese una opción: 
    1) Consulta.
    2) Ingresar.
    3) Actualizar.
    4) Eliminar.
    S) Salir.
##################
" op

    # Seleccionamos la ejecución en bash en base a la ingreso del usuario.
    # Utilizamos un "clear" en cada opción para mostrar el resultado limpio.
    case $op in
    s | S) exit ;;
    1) clear && . bin/consulta.sh ;;
    2) clear && . bin/ingresar.sh ;;
    3) clear && . bin/actualizar.sh ;;
    4) clear && . bin/eliminar.sh ;;
    *) clear && echo -e "Opción no válida. Intenta de nuevo\n" ;;
    esac

done

# wc
# tail
# head
# 2>/dev/null
