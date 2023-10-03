#!/bin/bash

# preparamos las variables de trabajo
WORKPATH=$1
REGISTROS=$WORKPATH/registros
PRODUCTOS=$REGISTROS/productos
PEDIDOS=$REGISTROS/pedidos

# configuramos unos estilos y colores para destacar los mensajes
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)

N=$(tput sgr0) # Normal - restablece todos los estilos
B=$(tput bold) # Bold - negrita
U=$(tput smul) # Underline - subrayado

# Importamos las funciones necesarias
for file in $WORKPATH/helpers/*.sh; do
    . $file
done

# limpiamos pantalla
tput setaf 0
tput sgr0
tput clear
